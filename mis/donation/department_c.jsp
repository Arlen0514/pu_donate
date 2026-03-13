<!DOCTYPE html>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 基本參數
	String code = "department"; 					// 模組識別碼
	String show_title = "院系募款維護";			// 模組標題

	// 圖片建議尺寸
	String image_info = "(建議尺寸1280px * 580px)";
	// 圖片建議尺寸
	//String mobile_info = "(建議尺寸830px * 1300px)";
	
	// 功能參數
	boolean list_switch = true;			// 是否開啟列表功能
	boolean sort_switch = true;			// 是否開啟排序功能
	boolean keyword_switch = false;		// 是否開啟關鍵字設定
	boolean deadline_switch = false;	// 是否開啟上下架日期
	int add_num = -1;					// 設定可新增的資料筆數 , -1 為無限筆
	int category_num = 2;		    	// 設定類別層數 2層以上使用選擇器 一層使用下拉選單即可
/*------------------------------------------------------------------------------------*/	
	Vector cps = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=?", new Object[] { code, lang }, "cp_showseq ASC , cp_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,cps);
	
	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));
	String qcategory = StringTool.validString(request.getParameter("_qcategory"));
	String qupcategory = StringTool.validString(request.getParameter("_qupcategory"));

	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle", "_qcategory", "_qupcategory"  };
	String[] values = new String[] { String.valueOf(pageno), qtitle, qcategory, qupcategory  };
	// 回列表頁
	out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
	
	//所屬類別
	Vector<TableRecord> dms = app_sm.selectAll(tbldm, "dm_lang=? and dm_code=? and dm_category=?", new Object[]{ lang, code+"_category", "" } , "dm_showseq ASC , dm_createdate DESC");
	
	//受贈單位
	Vector<TableRecord> usages = app_sm.selectAll(tbldm, "dm_lang=? and dm_code=? and dm_category=?", new Object[]{ lang, "donate_usage", "" } , "dm_showseq ASC , dm_createdate DESC");

	//捐款屬性
	Vector<TableRecord> attributes = app_sm.selectAll(tbldm, "dm_lang=? and dm_code=? and dm_category=?", new Object[]{ lang, "donate_attribute", "" } , "dm_showseq ASC , dm_createdate DESC");

	// 修改資料id
	String cp_id = StringTool.validString(request.getParameter("cp_id"));	
	TableRecord cp = app_sm.select(tblcp, cp_id);
	
	// 所屬類別標題
	String title1=app_sm.select(tbldm,cp.getString("cp_upcategory")).getString("dm_title");
	String title2=app_sm.select(tbldm,cp.getString("cp_category")).getString("dm_title");
%>
<html lang="<%=encoded %>">
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
<script>
function checkform(F){
	//驗證副檔名
	var file_chk = /([^\/]+\.(?:jpg|jpeg|gif|png|webp))/;
	//驗證中文
	var chnese_chk = /[\u4e00-\u9fa5]/;
	
	if(F.cp_category.value == "") {
        alert("請選擇類別!!");
        F.cp_category.focus();
	} else if(F.cp_title.value == "") {
        alert("請輸入標題名稱!!");
        F.cp_title.focus();
    } else {
        return true;
    }
	return false;
}
</script>
</head>
<%-- 20250331 modify Miles top menu.jsp  改成 RWD --%>    
<body class="default_body">
<div class="pageContent default_pageContent">
<div align="center" class="default_area">
  <table class="default_table" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td colspan="2">
      	<table border="0" cellspacing="0" cellpadding="0">       
			<%@include file="/WEB-INF/jspf/mis/top.jspf"%>
      </table>
      </td>
    </tr>
    
    <tr class="default_table_bottom page_mis">
    
      <td width="" align="center" valign="top" class="system_bk-2">
      		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<%@include file="../leftmenu.jsp"%>          
      		</table>
      	</td>
      
      		<td width="99%" align="center" valign="top" class="system_bk-2p right_content_style"><table width="99%" border="0" cellspacing="0" cellpadding="0">
<%-- 20250331 modify Miles top menu.jsp  改成 RWD --%>
			<tr>
				<td colspan="2" class="information_bk-2b">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td width="60" align="left" valign="middle">
					<img src="../images/information_icon_1.gif" width="55" height="48">
				</td>
				<td align="left" valign="middle" class="information_bigword"><%=show_title%></td>
			</tr>
			<tr>
				<td colspan="2">
				<hr size="1" noshade>
				</td>
			</tr>
			<tr>
				<td align="center" colspan="2">
				<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=M&cp_id=<%=cp_id %>&_qtitle=<%=qtitle %>&npage=<%=pageno %>&_qcategory=<%=qcategory %>&_qupcategory=<%=qupcategory %>" onsubmit="javascript:return checkform(this);">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<tr>
						<td class="system_bk-2bk">
						<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
							<tr>
								<td align="center" colspan="4" class="information_title-1"><%=show_title%>&nbsp;&nbsp;
									<%if (add_switch) { %>
									<input type="button" value="新增資料" onclick="javascript:location.href='<%=code%>_a.jsp'" />&nbsp;
									<%} %>
									<%if (list_switch) { %>
									<input type="button" value="回到列表" onclick="javascript:location.href='<%=code%>.jsp'" />&nbsp;
									<%} %>
									<%if (sort_switch) { %>
									<input type="button" value="資料排序" onclick="javascript:location.href='<%=code%>_sort.jsp'" />
									<%} %>
								</td>
							</tr>							
							<tr align="center" class="information_bk-2">
								<td colspan="4" align="center">修改資訊</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td width="15%" align="right">所屬類別</td>
								<td width="35%" align="left">
								    <% if(category_num<=1){ %>
								    <select name="cp_category" id="cp_category">
										<option value="">請選擇類別</option>
										<% for(TableRecord dm : dms){ %>
											<option value="<%=dm.getString("dm_id")%>" <%=dm.getString("dm_id").equals(cp.getString("cp_category"))?"selected":""%>><%=dm.getString("dm_title")%></option>
										<% } %>
									</select>
									<% }else{  //2層以上 類別選擇器 %>
									<span id="dm_title" style="color:#FA0300;"><%=title1+"--"+title2%></span>&nbsp;&nbsp;
                   					<input type="hidden" name="cp_upcategory" id="cp_upcategory"  value="<%=cp.getString("cp_upcategory") %>"/>
									<input type="hidden" name="cp_category" id="cp_category"  value="<%=cp.getString("cp_category") %>"/>
                  					<input type="button" value="選擇類別" onclick="window.open('../mis_tools/category_selector.jsp?Back_id=cp_category&Back_category=cp_upcategory&max_layer=<%=category_num %>&dm_code=<%=code%>_category&css_type=information','_blank','height=260,width=400,top=50,left=300,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');" />
                  					<% } %>
                  					<%--
									//兩層下拉
									<select name="cp_category" id="cp_category">
										<%for(TableRecord dm : dms){ %>
										<optgroup label="<%=dm.getString("dm_title")%>">
											<%
												Vector<TableRecord> sub_dms = app_sm.selectAll(tbldm,"dm_code=? and dm_lang=? and dm_category=?",new Object[]{code,lang,dm.getString("dm_id")});
												for(TableRecord sub_dm : sub_dms){ 
											%>
											<option value="<%=sub_dm.getString("dm_id")%>" <%=cp.getString("cp_category").equals(sub_dm.getString("dm_id")) %>><%=sub_dm.getString("dm_title")%></option>
											<%} %>
										</optgroup>
										<%} %>
									</select>
									--%>
								</td>
								<td width="15%" align="right">計畫代碼</td>
								<td width="35%" align="left">
									<input type="text" name="cp_no" id="cp_no" value="<%=cp.getString("cp_no") %>" size="20" maxlength="120" />
								</td>
							</tr>
							<tr class="information_table-2-1">
								<td width="15%" align="right">捐款計畫</td>
								<td colspan="3" width="85%" align="left">
									<input type="text" name="cp_title" id="cp_title" size="100" maxlength="120" value="<%=cp.getString("cp_title")%>"/>
								</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td width="15%" align="right">受贈單位</td>
								<td width="35%" align="left">
									<select name="cp_usage" id="cp_usage">
										<%for(TableRecord usage : usages){%>
										<option value="<%=usage.getString("dm_id")%>" <%=cp.getString("cp_usage").equals(usage.getString("dm_id"))?"selected":"" %>><%=usage.getString("dm_title")%></option>
										<%}%>
									</select>
								</td>
								<td width="15%" align="right">捐款屬性</td>
								<td width="35%" align="left">
									<select name="cp_attr" id="cp_attr">
										<%for(TableRecord attribute : attributes){%>
										<option value="<%=attribute.getString("dm_id")%>"  <%=cp.getString("cp_attr").equals(attribute.getString("dm_id"))?"selected":"" %>><%=attribute.getString("dm_title")%></option>
										<%}%>
									</select>
								</td>
							</tr>
							
							
							<tr class="information_table-2-1">
								<td width="15%" align="right">聯繫窗口姓名</td>
								<td colspan="3" width="85%" align="left">
									<input type="text" name="cp_name" id="cp_name" size="45" maxlength="120"  value="<%=cp.getString("cp_name")%>"/>
								</td>
							</tr>
							<tr class="information_table-2-1">
								<td width="15%" align="right">聯繫窗口電話</td>
								<td width="35%" align="left">
									<input type="text" name="cp_phone" id="cp_phone" size="45" maxlength="120"  value="<%=cp.getString("cp_phone")%>"/>
								</td>
								<td width="15%" align="right">聯繫窗口E-mail</td>
								<td width="35%" align="left">
									<input type="text" name="cp_email" id="cp_email" size="45" maxlength="255"  value="<%=cp.getString("cp_email")%>"/>
								</td>
							</tr>							

							<%if(keyword_switch){ %>
							<tr align="center" class="information_table-2-1">
								<td colspan="4" align="center">關鍵字設定</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td align="right">網頁標題</td>
								<td colspan="3" align="left">
									<input type="text" name="cp_webtitle" id="cp_webtitle" size="100" maxlength="255" value="<%=cp.getString("cp_webtitle") %>"/>
								</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td width="15%" align="right">設定索引[Robots]</td>
								<td width="35%" align="left">
									<select name="cp_robots" id="cp_robots">
										<option value="index , follow"     <%="index , follow".equals(cp.getString("cp_robots")) ? "selected" : "" %>>全部-All</option>
										<option value="noindex , nofollow" <%="noindex , nofollow".equals(cp.getString("cp_robots")) ? "selected" : "" %>>無-None</option>
										<option value="index , nofollow"   <%="index , nofollow".equals(cp.getString("cp_robots")) ? "selected" : "" %>>索引-不跟蹤</option>
										<option value="noindex , follow"   <%="noindex , follow".equals(cp.getString("cp_robots")) ? "selected" : "" %>>不索引-跟蹤</option>
									</select>
								</td>
								<td width="20%" align="right">設定來訪週期</td>
								<td width="30%" align="left">
									<input type="number" name="cp_revisit_after" id="cp_revisit_after" value="<%=cp.getString("cp_revisit_after") %>" size="4" maxlength="4" />天
								</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td align="right">設定網頁版權說明</td>
								<td colspan="3" align="left">
									<input type="text" name="cp_copyright" id="cp_copyright" size="100" value="<%=cp.getString("cp_copyright") %>"/>
								</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td align="right">
									設定主要關鍵字
								</td>
								<td colspan="3" align="left">
									<textarea name="cp_keywords" id="cp_keywords" cols="100" rows="3" maxlength="255"><%=cp.getString("cp_keywords") %></textarea>
								</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td align="right">
									網頁內容簡介<br />[建議80-100字]
								</td>
								<td colspan="3" align="left">
									<textarea name="cp_description" id="cp_description" cols="100" rows="3" maxlength="255"><%=cp.getString("cp_description") %></textarea>
								</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td align="right">設定head追蹤碼</td>
								<td colspan="3" align="left">
									<textarea name="cp_seo_head_track" id="cp_seo_head_track" cols="100" rows="3"><%=cp.getString("cp_seo_head_track") %></textarea>
								</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td align="right">設定body追蹤碼</td>
								<td colspan="3" align="left">
									<textarea name="cp_seo_body_track" id="cp_seo_body_track" cols="100" rows="3"><%=cp.getString("cp_seo_body_track") %></textarea>
								</td>
							</tr>
							<%} %>
							<%if(deadline_switch){ %>
							<tr align="center" class="information_bk-2">
								<td colspan="4" align="center">上下架時間</td>
							</tr>
							<tr class="information_table-2-1">
								<td align="right" class="information_table-2-1">上架日期</td>
								<td align="left" class="tablebg">
									<input name="cp_emitdate" id="_qemitdate" type="text" value="<%=cp.getString("cp_emitdate") %>" size="15" readonly>
								</td>
								<td align="right" class="tablebg">下架日期</td>
								<td align="left" class="tablebg">
									<input name="cp_restdate" id="_qrestdate" type="text" value="<%=cp.getString("cp_restdate") %>" size="15" readonly>
								</td>
							</tr>
							<%} %>
							<tr class="information_table-2-1">
								<td align="right">最後修改人員</td>
								<td align="left"><%=cp.getString("cp_modifyuser") %></td>
								<td align="right">最後修改日期</td>
								<td align="left"><%=cp.getString("cp_modifydate") %></td>
							</tr>

						</table>
						</td>
					</tr>
					<tr align="center">
						<td colspan="4" align="center"><br />
						<input type="hidden" name="_qtitle" value="<%=qtitle %>" />
						<input type="submit" value="確定送出" />&nbsp;
						<input type="reset" value="重新設定" />&nbsp;
						<input type="button" value="回上一頁" onClick="listpage.submit();">
					</td>
					</tr>
				</table>
				</form>
				</td>
				

			</tr>
			<tr>
				<td colspan="3">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="3" class="information_bk-2b">&nbsp;</td>
			</tr>

		</table>
		</td>
		</div>
	</tr>
</table>
</div>
</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>