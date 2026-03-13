<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 上層基本參數
	String ap_category = StringTool.validString(request.getParameter("ap_category")); 	// 所屬上層相簿代號
	String back_code = "photo"; 														// 上層模組識別碼
	TableRecord apCode= app_sm.select(tblap,ap_category); 							  	// 所屬相簿資料
	
	// 若無上層資訊 , 則自動回上層列表頁
	if("".equals(ap_category)){
		out.println("<script> location='"+back_code+".jsp'; </script>");
	}
	
	// 基本參數
	String code = "photo_in"; 									// 模組識別碼
	String show_title = apCode.getString("ap_title")+"-相片";	// 模組標題

	// 圖片建議尺寸
	String image_info = "(建議尺寸800px * 692px)";
	// 圖片建議尺寸
	//String mobile_info = "(建議尺寸830px * 1300px)";
	
	// 功能參數
	boolean list_switch = true;			// 是否開啟列表功能
	boolean sort_switch = true;			// 是否開啟排序功能
	boolean keyword_switch = false;		// 是否開啟關鍵字設定
	boolean deadline_switch = false;	// 是否開啟上下架日期
	int add_num = -1;					// 設定可新增的資料筆數 , -1 為無限筆
/*-----------------------------------------------------------------------------------*/
	Vector aps = app_sm.selectAll(tblap, "ap_category=? and ap_code=? and ap_lang=?", new Object[] { ap_category, code, lang }, "ap_showseq ASC , ap_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,aps);
	
	// 跳頁參數
	String[] names = new String[] { "npage", "ap_category"};
	String[] values = new String[] { String.valueOf(pageno), ap_category};

	// 回列表頁
	out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
	// 回排序頁
	out.write(HtmlCoder.getForm("sortpage", code + "_sort.jsp", names, values));
	// 新增頁
	out.write(HtmlCoder.getForm("addpage", code + "_a.jsp", names, values));
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
<script>
function checkform(F){	
	//驗證副檔名
	var file_chk = /([^\/]+\.(?:jpg|jpeg|gif|png|webp))/;
	//驗證中文
	var chnese_chk = /[\u4e00-\u9fa5]/;
	
	if (F.ap_title.value == "") {
        alert("請輸入相片名稱!!");
        F.ap_title.focus();
	} else if (F.ap_image.value == "") {
       alert("請上傳圖檔!!");
       F.ap_image.focus();
	} else if (!file_chk.test(F.ap_image.value.toLowerCase())) {
		alert("附檔名限為jpg|jpeg|gif|png|webp!!");
		F.ap_image.focus();
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
				<td colspan="2" class="web_bk-2b">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td width="60" align="left" valign="middle">
					<img src="../images/web_icon_1.gif" width="55" height="48">
				</td>
				<td align="left" valign="middle" class="web_bigword"><%=show_title%></td>
			</tr>
			<tr>
				<td colspan="2">
				<hr size="1" noshade>
				</td>
			</tr>
			<tr>
				<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=A1&ap_category=<%=ap_category %>" onsubmit="javascript:return checkform(this);">
				<td align="center" colspan="2">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<tr>
						<td class="system_bk-2bk">
						<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
							<tr>
								<td align="center" colspan="4" class="web_title-1"><%=show_title%>&nbsp;&nbsp;
									<%if (add_switch) { %>
									<input type="button" value="新增相片" onclick="addpage.submit();" />&nbsp;
									<%} %>
									<%if (list_switch) { %>
									<input type="button" value="回到相片列表" onclick="listpage.submit();" />&nbsp;
									<%} %>
									<%if (sort_switch) { %>
									<input type="button" value="相片排序" onclick="sortpage.submit();" />
									<%} %>
								</td>
								<td width="15%" align="center" class="web_title-1">
									<input type="button" value="回到相簿列表" onclick="javascript:location.href='<%=back_code%>.jsp'" />&nbsp;
								</td>
							</tr>							
							<tr align="center" class="web_bk-2">
								<td colspan="5" align="center">新增資訊</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td width="15%" align="right">相片名稱</td>
								<td colspan="4" width="85%" align="left">
									<input type="text" name="ap_title" id="ap_title" size="100" maxlength="120" />
								</td>
							</tr>		
							
							<tr class="web_table-2-1">
								<td align="right" class="web_table-2-1">相片</td>
								<td colspan="4" align="left" class="tablebg">
									<input name="ap_image" id="ap_image" type="file" class="button" accept="image/*"> <%=image_info%>
								</td>
							</tr>
							
							<%--
							<tr class="web_table-2-1">
								<td align="right">內文</td>
								<td colspan="3" align="left">
									<textarea name="ap_content" id="ap_content" cols="100" rows="8" class="mceEditor"></textarea>
								</td>
							</tr>
							 --%>
							
							<%if(keyword_switch){ %>
							<tr align="center" class="web_table-2-1">
								<td colspan="5" align="center">關鍵字設定</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">網頁標題</td>
								<td colspan="3" align="left">
									<input type="text" name="ap_webtitle" id="ap_webtitle" size="100" maxlength="255" value="<%=SiteSetup.getSetup("web_title"+"."+lang).getString("ss_text") %>"/>
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td width="15%" align="right">設定索引[Robots]</td>
								<td width="35%" align="left">
									<select name="ap_robots" id="ap_robots">
										<option value="index , follow"     <%="index , follow".equals(SiteSetup.getSetup("seo.robots." + lang).getString("ss_text")) ? "selected" : "" %>>全部-All</option>
										<option value="noindex , nofollow" <%="noindex , nofollow".equals(SiteSetup.getSetup("seo.robots." + lang).getString("ss_text")) ? "selected" : "" %>>無-None</option>
										<option value="index , nofollow"   <%="index , nofollow".equals(SiteSetup.getSetup("seo.robots." + lang).getString("ss_text")) ? "selected" : "" %>>索引-不跟蹤</option>
										<option value="noindex , follow"   <%="noindex , follow".equals(SiteSetup.getSetup("seo.robots." + lang).getString("ss_text")) ? "selected" : "" %>>不索引-跟蹤</option>
									</select>
								</td>
								<td width="20%" align="right">設定來訪週期</td>
								<td width="30%" align="left" colspan="2">
									<input type="number" name="ap_revisit_after" id="ap_revisit_after" value="<%=SiteSetup.getSetup("seo.revisit_after"+"."+lang).getString("ss_text") %>" size="4" maxlength="4" />天
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">設定網頁版權說明</td>
								<td colspan="3" align="left">
									<input type="text" name="ap_copyright" id="ap_copyright" size="100" value="<%=SiteSetup.getSetup("seo.copyright"+"."+lang).getString("ss_text") %>"/>
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">
									設定主要關鍵字
								</td>
								<td colspan="3" align="left">
									<textarea name="ap_keywords" id="ap_keywords" cols="100" rows="3" maxlength="255"><%=SiteSetup.getSetup("seo.keywords"+"."+lang).getString("ss_text") %></textarea>
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">
									網頁內容簡介<br />[建議80-100字]
								</td>
								<td colspan="4" align="left">
									<textarea name="ap_description" id="ap_description" cols="100" rows="3" maxlength="255"><%=SiteSetup.getSetup("seo.description"+"."+lang).getString("ss_text") %></textarea>
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">設定head追蹤碼</td>
								<td colspan="3" align="left">
									<textarea name="ap_seo_head_track" id="ap_seo_head_track" cols="100" rows="3"><%=SiteSetup.getSetup("seo.head_track"+"."+lang).getString("ss_text") %></textarea>
								</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right">設定body追蹤碼</td>
								<td colspan="3" align="left">
									<textarea name="ap_seo_body_track" id="ap_seo_body_track" cols="100" rows="3"><%=SiteSetup.getSetup("seo.body_track"+"."+lang).getString("ss_text") %></textarea>
								</td>
							</tr>
							<%} %>
							
							<%if(deadline_switch) { %>
							<tr align="center" class="web_bk-2">
								<td colspan="5" align="center">上下架時間</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td align="right" class="web_table-2-1">上架日期</td>
								<td align="left" class="tablebg">
									<input type="text" name="ap_emitdate" id="_qemitdate" value="<%=DateTimeTool.dateString()%>" size="15" readonly />
								</td>
								<td align="right" class="tablebg">下架日期</td>
								<td align="left" class="tablebg" colspan="2">
									<input type="text" name="ap_restdate" id="_qrestdate" value="2099/12/31" size="15" readonly />
								</td>
							</tr>
							<%} %>
							
							<tr class="web_table-2-1">
								<td width="15%" align="right">資料建立人員</td>
								<td width="35%" align="left"><%=app_account%></td>
								<td width="15%" align="right">資料建立日期</td>
								<td width="35%" align="left" colspan="2"><%=app_today%></td>
							</tr>

						</table>
						</td>
					</tr>
					<tr align="center">
						<td colspan="4" align="center"><br />
						<input type="submit" value="確定送出" />&nbsp;
						<input type="reset" value="重新設定" />&nbsp;
						<input type="button" value="回上一頁" onClick="listpage.submit();">
					</td>
					</tr>
				</table>
				</td>
				</form>

			</tr>
			<tr>
				<td colspan="3">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="3" class="web_bk-2b">&nbsp;</td>
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