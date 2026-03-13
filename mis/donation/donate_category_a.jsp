<!DOCTYPE html>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	//基本參數
	String code = "donate_category"; 		// 模組識別碼
	String show_title = "募款專案類別維護";		// 模組標題

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
	int add_num = -1;						// 設定可新增的資料筆數 , -1 為無限筆
/*----------------------------------------------------------------------------------------------*/
	Vector datas = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=?", new Object[] { code, lang }, "dm_showseq ASC , dm_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,datas);
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
	} else if (F.dm_icon.value == "") {
        alert("請上傳類別icon!!");
        F.dm_icon.focus();   
    } else if(!file_chk.test(F.dm_icon.value.toLowerCase())) {
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
				
				<td align="center" colspan="2">
				<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=A" onsubmit="javascript:return checkform(this);">
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
								<td colspan="4" align="center">新增資訊</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td width="15%" align="right">類別名稱</td>
								<td colspan="3" width="85%" align="left">
									<input type="text" name="dm_title" id="dm_title" size="137" maxlength="120" />
								</td>
							</tr>

							<tr class="information_table-2-1">
								<td width="15%" align="right">類別名稱(英文)</td>
								<td colspan="3" width="85%" align="left">
									<input type="text" name="dm_subtitle" id="dm_subtitle" size="137" maxlength="120" />
								</td>
							</tr>
							<tr class="information_table-2-1">
								<td align="right">類別簡述</td>
								<td colspan="3" align="left">
									<textarea name="dm_desc" id="dm_desc" cols="118" rows="8" class="ezEditor"></textarea>
								</td>
							</tr>
							<tr class="information_table-2-1">
								<td align="right">類別介紹</td>
								<td colspan="3" align="left">
									<textarea name="dm_content" id="dm_content" cols="118" rows="8" class="ezEditor"></textarea>
								</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td align="right" class="information_table-2-1">類別代表圖檔</td>
								<td colspan="3" align="left" class="tablebg">
									<input name="dm_image" id="dm_image" type="file" class="button" accept="image/*"> <%=image_info%>
								</td>
							</tr>							
							
							<tr class="information_table-2-1">
								<td align="right" class="information_table-2-1">類別icon圖檔</td>
								<td colspan="3" align="left" class="tablebg">
									<input name="dm_icon" id="dm_icon" type="file" class="button" accept="image/*"> <%=icon_info%>
								</td>
							</tr>			
							<tr class="information_table-2-1">
								<td align="right" class="information_table-2-1">內文介紹圖檔</td>
								<td colspan="3" align="left" class="tablebg">
									<input name="dm_image2" id="dm_image2" type="file" class="button" accept="image/*"> <%=image_info2%>
								</td>
							</tr>
							
							<%if(keyword_switch){ %>
							<tr align="center" class="information_bk-2">
								<td colspan="4" align="center">關鍵字設定</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td align="right">網頁標題</td>
								<td colspan="3" align="left">
									<input type="text" name="dm_webtitle" id="dm_webtitle" size="100" maxlength="255" value="<%=SiteSetup.getSetup("web_title"+"."+lang).getString("ss_text") %>"/>
								</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td width="15%" align="right">設定索引[Robots]</td>
								<td width="35%" align="left">
									<select name="dm_robots" id="dm_robots">
										<option value="index , follow"     <%="index , follow".equals(SiteSetup.getSetup("seo.robots." + lang).getString("ss_text")) ? "selected" : "" %>>全部-All</option>
										<option value="noindex , nofollow" <%="noindex , nofollow".equals(SiteSetup.getSetup("seo.robots." + lang).getString("ss_text")) ? "selected" : "" %>>無-None</option>
										<option value="index , nofollow"   <%="index , nofollow".equals(SiteSetup.getSetup("seo.robots." + lang).getString("ss_text")) ? "selected" : "" %>>索引-不跟蹤</option>
										<option value="noindex , follow"   <%="noindex , follow".equals(SiteSetup.getSetup("seo.robots." + lang).getString("ss_text")) ? "selected" : "" %>>不索引-跟蹤</option>
									</select>
								</td>
								<td width="20%" align="right">設定來訪週期</td>
								<td width="30%" align="left">
									<input type="number" name="dm_revisit_after" id="dm_revisit_after" value="<%=SiteSetup.getSetup("seo.revisit_after"+"."+lang).getString("ss_text") %>" size="4" maxlength="4" />天
								</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td align="right">設定網頁版權說明</td>
								<td colspan="3" align="left">
									<input type="text" name="dm_copyright" id="dm_copyright" size="100" value="<%=SiteSetup.getSetup("seo.copyright"+"."+lang).getString("ss_text") %>"/>
								</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td align="right">
									設定主要關鍵字
								</td>
								<td colspan="3" align="left">
									<textarea name="dm_keywords" id="dm_keywords" cols="100" rows="3" maxlength="255"><%=SiteSetup.getSetup("seo.keywords"+"."+lang).getString("ss_text") %></textarea>
								</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td align="right">
									網頁內容簡介<br />[建議80-100字]
								</td>
								<td colspan="3" align="left">
									<textarea name="dm_description" id="dm_description" cols="100" rows="3" maxlength="255"><%=SiteSetup.getSetup("seo.description"+"."+lang).getString("ss_text") %></textarea>
								</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td align="right">設定head追蹤碼</td>
								<td colspan="3" align="left">
									<textarea name="dm_seo_head_track" id="dm_seo_head_track" cols="100" rows="3"><%=SiteSetup.getSetup("seo.head_track"+"."+lang).getString("ss_text") %></textarea>
								</td>
							</tr>
							
							<tr class="information_table-2-1">
								<td align="right">設定body追蹤碼</td>
								<td colspan="3" align="left">
									<textarea name="dm_seo_body_track" id="dm_seo_body_track" cols="100" rows="3"><%=SiteSetup.getSetup("seo.body_track"+"."+lang).getString("ss_text") %></textarea>
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
									<input name="dm_emitdate" id="_qemitdate" type="text" value="<%=DateTimeTool.dateString()%>" size="15" readonly>
								</td>
								<td align="right" class="tablebg">下架日期</td>
								<td align="left" class="tablebg">
									<input name="dm_restdate" id="_qrestdate" type="text" value="2099/12/31" size="15" readonly>
								</td>
							</tr>
							<%} %>
							<tr class="information_table-2-1">
								<td align="right">資料建立人員</td>
								<td align="left"><%=app_account%></td>
								<td align="right">資料建立日期</td>
								<td align="left"><%=app_today%></td>
							</tr>

						</table>
						</td>
					</tr>
					<tr align="center">
						<td colspan="4" align="center"><br />
						<input type="submit" value="確定送出" />&nbsp;
						<input type="reset" value="重新設定" />&nbsp;
						<input type="button" value="回上一頁" onClick="location='<%=code%>.jsp';">
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