<!DOCTYPE html>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	//基本參數
	String code = "department_index"; 		// 模組識別碼
	String show_title = "院系募款介紹維護";		// 模組標題

	// 圖片建議尺寸
	String image_info = "(建議尺寸1042px * 695px)";
	String icon_info = "(建議尺寸512px * 512px)";
	String image_info2 = "(建議尺寸1024px * 683px)";
	
	// 圖片建議尺寸
	//String mobile_info = "(建議尺寸830px * 1300px)";
	
	// 功能參數
	boolean list_switch = true;				// 是否開啟列表功能
	boolean sort_switch = true;				// 是否開啟排序功能
	boolean keyword_switch = true;			// 是否開啟關鍵字設定
	boolean deadline_switch = false;		// 是否開啟上下架日期
	boolean single = true;	        		// 單網編/單一修改畫面模組  true=關閉列表 + 排序+ 新增功能
	int add_num = -1;						// 設定可新增的資料筆數 , -1 為無限筆
/*------------------------------------------------------------------------------------*/	
	Vector dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=?", new Object[] { code, lang }, "dm_showseq ASC , dm_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,dms);

	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));

	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle" };
	String[] values = new String[] { String.valueOf(pageno), qtitle };
	
	// 回列表頁
	out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
	
	// 修改資料id
	String dm_id = StringTool.validString(request.getParameter("dm_id"));	
	TableRecord dm = app_sm.select(tbldm, dm_id);
	
	if(single) {
		list_switch = false;
		sort_switch = false;
		add_switch = false;
		add_num = 1;

		// 單網編 直接抓功能代號
		dm = app_sm.select(tbldm, "dm_code=? and dm_lang=?",new Object[]{code,lang});

		// 設定預設值(單網編模組 直接顯示修改畫面)
		if (dm.getString("dm_id").equals("")) {
			dm = new TableRecord(tbldm);
			dm.setValue("dm_title", show_title);
			dm.setValue("dm_robots", SiteSetup.getSetup("seo.robots"+"."+lang).getString("ss_text"));
			dm.setValue("dm_revisit_after", SiteSetup.getSetup("seo.revisit_after"+"."+lang).getString("ss_text"));
			dm.setValue("dm_keywords", SiteSetup.getSetup("seo.keywords"+"."+lang).getString("ss_text"));
			dm.setValue("dm_copyright", SiteSetup.getSetup("seo.copyright"+"."+lang).getString("ss_text"));
			dm.setValue("dm_description", SiteSetup.getSetup("seo.description"+"."+lang).getString("ss_text"));
			dm.setValue("dm_seo_head_track", SiteSetup.getSetup("seo.head_track"+"."+lang).getString("ss_text"));
			dm.setValue("dm_seo_body_track", SiteSetup.getSetup("seo.body_track"+"."+lang).getString("ss_text"));
			dm.setValue("dm_code", code);	// 識別碼
			dm.setValue("dm_lang", lang);	// 語系
			dm.setInsert(app_account);
			app_sm.insert(dm);
		}
		dm_id = dm.getString("dm_id");
	}
%>

<html lang="<%=encoded%>">
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
<script>
function checkform(F){
	// 驗證副檔名
	var file_chk = /([^\/]+\.(?:jpg|jpeg|gif|png|svg|webp))/;
	
	if (F.dm_title.value == "") {
        alert("請輸入類別名稱!!");
        F.dm_title.focus();
    } else if(F.dm_image.value != "" && !file_chk.test(F.dm_image.value.toLowerCase())) {
        alert("附檔名限為jpg|jpeg|gif|png|svg|webp!!");
        F.dm_image.focus();      
    } else if(F.dm_image2.value != "" && !file_chk.test(F.dm_image2.value.toLowerCase())) {
        alert("附檔名限為jpg|jpeg|gif|png|svg|webp!!");
        F.dm_image.focus();    
    } else if(F.dm_icon.value != "" && !file_chk.test(F.dm_icon.value.toLowerCase())) {
        alert("附檔名限為jpg|jpeg|gif|png|svg|webp!!");
        F.dm_icon.focus();        
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
				<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=M&dm_id=<%=dm_id %>&_qtitle=<%=qtitle %>&npage=<%=pageno %>" onsubmit="javascript:return checkform(this);">
				<td align="center" colspan="2">
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
								<td width="15%" align="right">類別名稱</td>
								<td colspan="3" width="85%" align="left">
									<input type="text" name="dm_title" id="dm_title" size="137" maxlength="120" value="<%=dm.getString("dm_title")%>"/>
								</td>
							</tr>

							<tr class="information_table-2-1">
								<td width="15%" align="right">類別名稱(英文)</td>
								<td colspan="3" width="85%" align="left">
									<input type="text" name="dm_subtitle" id="dm_subtitle" size="137" maxlength="120" value="<%=dm.getString("dm_subtitle")%>"/>
								</td>
							</tr>
							
							<%-- 
		                    <tr class="information_table-2-1">
								<td align="right">類別簡述</td>
								<td colspan="3" align="left">
									<textarea name="dm_desc" id="dm_desc" cols="118" rows="8" class="ezEditor"><%=dm.getString("dm_desc")%></textarea>
								</td>
							</tr>
																	
							<tr class="information_table-2-1">
								<td align="right">類別介紹</td>
								<td colspan="3" align="left">
									<textarea name="dm_content" id="dm_content" cols="118" rows="8" class="ezEditor"><%=dm.getString("dm_content")%></textarea>
								</td>
							</tr>
							--%>
							
							<tr class="information_table-2-1">
								<td rowspan="2" align="right" class="information_table-2-1">類別代表圖檔</td>	
								<td colspan="3" align="left" class="tablebg">&nbsp;
						        <% if(!dm.getString("dm_image").isEmpty()){ %>
									<img src="<%=app_fetchpath+"/"+code+"/"+lang+"/"+dm.getString("dm_image")%>" width="198">		                      		
							    <% } %>
								</td>
		                    </tr>
		                    <tr class="information_table-2-1">
								<td colspan="3" align="left" class="tablebg">
									<input name="imgradio" type="radio" value="ucpic" checked onclick="frm.dm_image.value='';">使用原圖<br>
									<input name="imgradio" type="radio" value="new">上傳新圖
									<input name="dm_image" id="dm_image" type="file" class="button" accept="image/*" onclick="frm.imgradio[1].checked=true;"> <%=image_info%>
								</td>
		                    </tr>
							
							<tr class="information_table-2-1">
								<td rowspan="2" align="right" class="information_table-2-1">類別icon圖檔</td>	
								<td colspan="3" align="left" class="tablebg">&nbsp;
						        <% if(!dm.getString("dm_icon").isEmpty()){ %>
									<img src="<%=app_fetchpath+"/"+code+"/"+lang+"/"+dm.getString("dm_icon")%>" width="198">		                      		
							    <% } %>
								</td>
		                    </tr>
		                    <tr class="information_table-2-1">
								<td colspan="3" align="left" class="tablebg">
									<input name="imgradio2" type="radio" value="ucpic" checked onclick="frm.dm_icon.value='';">使用原圖<br>
									<input name="imgradio2" type="radio" value="new">上傳新圖
									<input name="dm_icon" id="dm_icon" type="file" class="button" accept="image/*" onclick="frm.imgradio2[1].checked=true;"> <%=icon_info%>
								</td>
		                    </tr>

							<tr class="information_table-2-1">
								<td rowspan="2" align="right" class="information_table-2-1">內文介紹圖檔</td>	
								<td colspan="3" align="left" class="tablebg">&nbsp;
						        <% if(!dm.getString("dm_image2").isEmpty()){ %>
									<img src="<%=app_fetchpath+"/"+code+"/"+lang+"/"+dm.getString("dm_image2")%>" width="198">		                      		
							    <% } %>
								</td>
		                    </tr>
		                    <tr class="information_table-2-1">
								<td colspan="3" align="left" class="tablebg">
									<input name="imgradio3" type="radio" value="ucpic" checked onclick="frm.dm_image2.value='';">使用原圖<br>
									<input name="imgradio3" type="radio" value="new">上傳新圖
									<input name="dm_image2" id="dm_image2" type="file" class="button" accept="image/*" onclick="frm.imgradi32[1].checked=true;"> <%=image_info2%>
								</td>
		                    </tr>

							<%if(keyword_switch){ %>
							<tr align="center" class="information_bk-2">
								<td colspan="4" align="center">關鍵字設定</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td align="right">網頁標題</td>
								<td colspan="3" align="left">
									<input type="text" name="dm_webtitle" id="dm_webtitle" size="100" maxlength="255" value="<%=dm.getString("dm_webtitle") %>"/>
								</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td width="15%" align="right">設定索引[Robots]</td>
								<td width="35%" align="left">
									<select name="dm_robots" id="dm_robots">
										<option value="index , follow"     <%="index , follow".equals(dm.getString("dm_robots")) ? "selected" : "" %>>全部-All</option>
										<option value="noindex , nofollow" <%="noindex , nofollow".equals(dm.getString("dm_robots")) ? "selected" : "" %>>無-None</option>
										<option value="index , nofollow"   <%="index , nofollow".equals(dm.getString("dm_robots")) ? "selected" : "" %>>索引-不跟蹤</option>
										<option value="noindex , follow"   <%="noindex , follow".equals(dm.getString("dm_robots")) ? "selected" : "" %>>不索引-跟蹤</option>
									</select>
								</td>
								<td width="20%" align="right">設定來訪週期</td>
								<td width="30%" align="left">
									<input type="number" name="dm_revisit_after" id="dm_revisit_after" value="<%=dm.getString("dm_revisit_after") %>" size="4" maxlength="4" />天
								</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td align="right">設定網頁版權說明</td>
								<td colspan="3" align="left">
									<input type="text" name="dm_copyright" id="dm_copyright" size="100" value="<%=dm.getString("dm_copyright") %>"/>
								</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td align="right">
									設定主要關鍵字
								</td>
								<td colspan="3" align="left">
									<textarea name="dm_keywords" id="dm_keywords" cols="100" rows="3" maxlength="255"><%=dm.getString("dm_keywords") %></textarea>
								</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td align="right">
									網頁內容簡介<br />[建議80-100字]
								</td>
								<td colspan="3" align="left">
									<textarea name="dm_description" id="dm_description" cols="100" rows="3" maxlength="255"><%=dm.getString("dm_description") %></textarea>
								</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td align="right">設定head追蹤碼</td>
								<td colspan="3" align="left">
									<textarea name="dm_seo_head_track" id="dm_seo_head_track" cols="100" rows="3"><%=dm.getString("dm_seo_head_track") %></textarea>
								</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td align="right">設定body追蹤碼</td>
								<td colspan="3" align="left">
									<textarea name="dm_seo_body_track" id="dm_seo_body_track" cols="100" rows="3"><%=dm.getString("dm_seo_body_track") %></textarea>
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
									<input name="dm_emitdate" id="_qemitdate" type="text" value="<%=dm.getString("dm_emitdate") %>" size="15" readonly>
								</td>
								<td align="right" class="tablebg">下架日期</td>
								<td align="left" class="tablebg">
									<input name="dm_restdate" id="_qrestdate" type="text" value="<%=dm.getString("dm_restdate") %>" size="15" readonly>
								</td>
							</tr>
							<%} %>
							<tr class="information_table-2-1">
								<td align="right">最後修改人員</td>
								<td align="left"><%=dm.getString("dm_modifyuser") %></td>
								<td align="right">最後修改日期</td>
								<td align="left"><%=dm.getString("dm_modifydate") %></td>
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
				</td>
				</form>

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