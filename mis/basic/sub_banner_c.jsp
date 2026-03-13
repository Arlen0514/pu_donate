<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 基本參數
	String code = "sub_banner"; 			// 模組識別碼
	String show_title = "單元形象圖維護";		// 模組標題

	// 圖片建議尺寸
	String image_info = "(建議尺寸1583px * 425px)";
	
	// 圖片建議尺寸
	String mobile_info = "(建議尺寸880px * 822px)";
	
	// 檔案建議大小
	String file_info = "檔案上傳限制2MB";
	
	// 設定圖檔上傳 K 數
	Integer fSize = 2048;
	
	// 功能參數
	boolean list_switch = true;				// 是否開啟列表功能
	boolean sort_switch = false;			// 是否開啟排序功能
	boolean keyword_switch = false;			// 是否開啟關鍵字設定
	boolean deadline_switch = false;		// 是否開啟上下架日期
	boolean mobile_image = false;			// 是否開啟手機形象圖檔
	int add_num = 0;						// 設定可新增的資料筆數 , -1 為無限筆
/*--------------------------------------------------------------------------------------*/
	Vector aps = app_sm.selectAll(tblap, "ap_code=? and ap_lang=?", new Object[] { code, lang}, "ap_showseq ASC, ap_createdate DESC");
	
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,aps);

	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"), DateTimeTool.getYear() - 1 + DateTimeTool.dateString().substring(4));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"), DateTimeTool.getYear() + 1 + DateTimeTool.dateString().substring(4));

	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle", "_qemitdate", "_qrestdate" };
	String[] values = new String[] { String.valueOf(pageno), qtitle, qemitdate, qrestdate };	
	
	// 回列表頁
	out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));

	// 修改資料id
	String ap_id = StringTool.validString(request.getParameter("ap_id"));
	TableRecord ap = app_sm.select(tblap, ap_id);
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="include/head.jsp"%>
<script>
	function checkform(F) {
		// 驗證副檔名
		var file_chk = /([^\/]+\.(?:jpg|jpeg|gif|png|webp))/;
		// 驗證中文
		var chnese_chk = /[\u4e00-\u9fa5]/;

		var image = document.getElementById('ap_image').files[0];
		//var mobile = document.getElementById('ap_mobile').files[0];

		if(F.ap_title.value == "") {
	        alert("請輸入標題名稱!!");
	        F.ap_title.focus();
	    } else if (F.ap_image.value != "" && !file_chk.test(F.ap_image.value.toLowerCase())) {
	        alert("附檔名限為jpg|jpeg|gif|png|webp!!");
	        F.ap_image.focus();
	        <%--
	    } else if (F.ap_alt.value == "") {
	        alert("請輸入圖檔說明!!");
	        F.ap_alt.focus();
	    } else if (F.ap_image.value != "" && chnese_chk.test(F.ap_image.value)) {
	        alert("檔案名稱不可有包含中文!!");
	        F.ap_image.focus();
	    } else if (F.ap_image.value != "" && image.size/1024><%=fSize%>) {
	        alert("<%=file_info%>!!");
	        F.ap_image.focus();
	         --%>
	    <%if(mobile_image) { %>
	    } else if (F.ap_mobile.value != "" && !file_chk.test(F.ap_mobile.value.toLowerCase())) {
	    	alert("附檔名限為jpg|jpeg|gif|png|webp!!");
	        F.ap_mobile.focus();
	    <%} %>
	        <%--
	    } else if (F.ap_mobile.value != "" && chnese_chk.test(F.ap_mobile.value)) {
	        alert("檔案名稱不可有包含中文!!");
	        F.ap_mobile.focus();
	    } else if (F.ap_mobile.value != "" && mobile.size/1024><%=fSize%>) {
	        alert("<%=file_info%>!!");
	        F.ap_mobile.focus();
	        --%>
	    } else if (F.ap_emitdate.value > F.ap_restdate.value) {
	        alert("上架日期不得大於下架日期!!");
	        F.ap_emitdate.focus();
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
						<img src="../images/web_icon_1.gif" width="55" height="48" />
					</td>	
					<td align="left" valign="middle" class="web_bigword"><%=show_title%></td>
				</tr>
				
				<tr>
					<td colspan="2">
						<hr size="1" noshade>
					</td>
				</tr>
				
				<tr>
<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=M&ap_id=<%=ap_id %>&_qemitdate=<%=qemitdate %>&_qrestdate=<%=qrestdate %>" onsubmit="javascript:return checkform(this);">
					<td align="center" colspan="2"><table width="95%" border="0" cellspacing="1" cellpadding="0">
						<tr>
							<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
								<tr>
									<td align="center" colspan="4" class="web_title-1"><%=show_title%>&nbsp;&nbsp;
										<%if(add_switch) { %>
										<input type="button" value="新增資料" onclick="javascript:location.href='<%=code%>_a.jsp'" />&nbsp;
										<%} %>
										<%if(list_switch) { %>
										<input type="button" value="回到列表" onclick="javascript:location.href='<%=code%>.jsp'" />&nbsp;
										<%} %>
										<%if(sort_switch) { %>
										<input type="button" value="資料排序" onclick="javascript:location.href='<%=code%>_sort.jsp'" />
										<%} %>
									</td>
								</tr>

								<tr align="center" class="web_bk-2">
									<td colspan="4" align="center">修改資訊</td>
								</tr>

								<tr class="web_table-2-1">
									<td width="15%" align="right">標題</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="ap_title" id="ap_title" size="100" maxlength="120" value="<%=ap.getString("ap_title")%>" Disabled/>
									</td>
								</tr>

								<%--
								<tr class="web_table-2-1">
									<td align="right">連結開啟方式</td>
									<td colspan="3" align="left">
										<select name="ap_target" id="ap_target">
											<option value="none" <%=ap.getString("ap_target").equals("none")?"selected":""%>>不連結</option>
											<option value="_self" <%=ap.getString("ap_target").equals("_self")?"selected":""%>>目前頁面</option>
											<option value="_blank" <%=ap.getString("ap_target").equals("_blank")?"selected":""%>>開新頁面</option>
										</select>
									</td>
								</tr>

								<tr class="web_table-2-1">
									<td align="right">連結網址</td>
									<td colspan="3" align="left">
										<input type="text" name="ap_url" id="ap_url" size="100" value="<%=ap.getString("ap_url")%>"/>
									</td>
								</tr>
								--%>

								<tr class="web_table-2-1">
									<td rowspan="2" align="right" class="web_table-2-1">單元形象圖</td>
									<td colspan="3" align="left" class="tablebg">&nbsp;
										<%if(!"".equals(ap.getString("ap_image"))) { %>
										<img src="<%=app_fetchpath+"/"+code+"/"+lang+"/"+ap.getString("ap_image")%>" width="100%" />
										<%} %>		                      		
									</td>
		                    	</tr>

		                    	<tr class="web_table-2-1">
									<td colspan="3" align="left" class="tablebg">
										<input name="imgradio" type="radio" value="ucpic" checked onclick="frm.ap_image.value='';">使用原圖<br>
										<input name="imgradio" type="radio" value="new">上傳新圖
										<input name="ap_image" id="ap_image" type="file" class="button" accept="image/*" onclick="frm.imgradio[1].checked=true;"> <%=image_info%>
									</td>
		                    	</tr>
		                    
		                    	<%if(mobile_image) { %>
								<tr class="web_table-2-1">
									<td rowspan="2" align="right" class="web_table-2-1">手機形象圖檔</td>
									<td colspan="3" align="left" class="tablebg">&nbsp;							 
										<img src="<%="".equals(ap.getString("ap_mobile"))?"":app_fetchpath+"/"+code+"/"+lang+"/"+ap.getString("ap_mobile")%>" width="415px">		                      		
									</td>
		                    	</tr>

		                    	<tr class="web_table-2-1">
									<td colspan="3" align="left" class="tablebg">
										<input name="imgradio_mobile" type="radio" value="ucpic" checked onclick="frm.ap_mobile.value='';">使用原圖<br>
										<input name="imgradio_mobile" type="radio" value="new">上傳新圖
										<input name="ap_mobile" id="ap_mobile" type="file" class="button" accept="image/*" onclick="frm.imgradio_mobile[1].checked=true;"> <%=mobile_info%>
									</td>
		                    	</tr>
								<%} %>

		                   		<tr class="web_table-2-1">
									<td align="right">圖檔說明</td>
									<td colspan="3" align="left">
										<textarea name="ap_alt" id="ap_alt" cols="100" rows="8" ><%=ap.getString("ap_alt")%></textarea>
									</td>
								</tr>							

								<%if(keyword_switch) { %>
								<tr align="center" class="web_table-2-1">
									<td colspan="4" align="center">關鍵字設定</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">網頁標題</td>
									<td colspan="3" align="left">
										<input type="text" name="ap_webtitle" id="ap_webtitle" size="100" maxlength="255" value="<%=ap.getString("ap_webtitle") %>"/>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td width="15%" align="right">設定索引[Robots]</td>
									<td width="35%" align="left">
										<select name="ap_robots" id="ap_robots">
											<option value="index , follow"     <%="index , follow".equals(ap.getString("ap_robots")) ? "selected" : "" %>>全部-All</option>
											<option value="noindex , nofollow" <%="noindex , nofollow".equals(ap.getString("ap_robots")) ? "selected" : "" %>>無-None</option>
											<option value="index , nofollow"   <%="index , nofollow".equals(ap.getString("ap_robots")) ? "selected" : "" %>>索引-不跟蹤</option>
											<option value="noindex , follow"   <%="noindex , follow".equals(ap.getString("ap_robots")) ? "selected" : "" %>>不索引-跟蹤</option>
										</select>
									</td>
									<td width="20%" align="right">設定來訪週期</td>
									<td width="30%" align="left">
										<input type="number" name="ap_revisit_after" id="ap_revisit_after" value="<%=ap.getString("ap_revisit_after") %>" size="4" maxlength="4" />天
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">設定主要關鍵字</td>
									<td align="left">
										<input type="text" name="ap_keywords" id="ap_keywords" size="40" maxlength="255" value="<%=ap.getString("ap_keywords") %>"/>
									</td>
									<td align="right">設定網頁版權說明</td>
									<td align="left">
										<input type="text" name="ap_copyright" id="ap_copyright" size="30" value="<%=ap.getString("ap_copyright") %>"/>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">
										網頁內容簡介<br />[建議80-100字]
									</td>
									<td colspan="3" align="left">
										<textarea name="ap_description" id="ap_description" cols="100" rows="3" maxlength="255"><%=ap.getString("ap_description") %></textarea>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">設定追蹤碼</td>
									<td colspan="3" align="left">
										<textarea name="ap_seo_track" id="ap_seo_track" cols="100" rows="3"><%=ap.getString("ap_seo_track") %></textarea>
									</td>
								</tr>
								<%} %>

								<%if(deadline_switch) { %>
								<tr align="center" class="web_bk-2">
									<td colspan="4" align="center">上下架時間</td>
								</tr>

								<tr class="web_table-2-1">
									<td align="right" class="web_table-2-1">上架日期</td>
									<td align="left" class="tablebg">
										<input type="text" name="ap_emitdate" id="_qemitdate" value="<%=ap.getString("ap_emitdate") %>" size="15" readonly />
									</td>
									<td align="right" class="tablebg">下架日期</td>
									<td align="left" class="tablebg">
										<input type="text" name="ap_restdate" id="_qrestdate" value="<%=ap.getString("ap_restdate") %>" size="15" readonly />
									</td>
								</tr>
								<%} %>

								<tr class="web_table-2-1">
									<td align="right">最後修改人員</td>
									<td align="left"><%=ap.getString("ap_modifyuser") %></td>
									<td align="right">最後修改日期</td>
									<td align="left"><%=ap.getString("ap_modifydate") %></td>
								</tr>
							</table></td>
						</tr>
						
						<tr align="center">
							<td colspan="4" align="center"><br />
								<input type="hidden" name="qtitle" value="<%=qtitle %>" />
								<input type="submit" value="確定送出" />&nbsp;
								<input type="reset" value="重新設定" />&nbsp;
								<input type="button" value="回上一頁" onClick="listpage.submit();">
							</td>
						</tr>
					</table></td>
</form>
				</tr>
				
				<tr>
					<td colspan="3">&nbsp;</td>
				</tr>
				
				<tr>
					<td colspan="3" class="web_bk-2b">&nbsp;</td>
				</tr>
			</table></td>
		</tr>
	</table>
</div>
</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>