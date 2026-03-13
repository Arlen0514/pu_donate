<!DOCTYPE html>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 基本參數
	String code = "news"; 					// 模組識別碼
	String show_title = "最新消息維護";		// 模組標題

	// 圖片建議尺寸
	String image_info = "(建議尺寸198px * 140px)";
	// 圖片建議尺寸
	//String mobile_info = "(建議尺寸830px * 1300px)";

	// 功能參數
	boolean list_switch = true;				// 是否開啟列表功能
	boolean sort_switch = false;			// 是否開啟排序功能
	boolean modify_switch = true;			// 是否開啟修改功能
	boolean keyword_switch = true;			// 是否開啟關鍵字設定
	boolean deadline_switch = true; 		// 是否開啟上下架日期
	int add_num = -1;						// 設定可新增的資料筆數 , -1 為無限筆
/*-------------------------------------------------------------------------*/
	Vector nps = app_sm.selectAll(tblnp, "np_code=? and np_lang=?", new Object[] { code,lang }, "np_showseq ASC, np_createdate DESC");
	
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,nps);		

	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"), DateTimeTool.getYear() - 10 + DateTimeTool.dateString().substring(4));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"), DateTimeTool.getYear() + 1 + DateTimeTool.dateString().substring(4));

	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle", "_qemitdate", "_qrestdate" };
	String[] values = new String[] { String.valueOf(pageno), qtitle, qemitdate, qrestdate };

	// 回列表頁
	out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));

	// 修改資料id
	String np_id = StringTool.validString(request.getParameter("np_id"));
	TableRecord np = app_sm.select(tblnp, np_id);
%>
<html lang="<%=encoded%>">
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
<script>
	function checkform(F) {	
		//驗證副檔名
		var file_chk = /([^\/]+\.(?:jpg|jpeg|gif|png|webp))/;
		//驗證中文
		var chnese_chk = /[\u4e00-\u9fa5]/;
		
		if (F.np_title.value == ""){
		   	alert("請輸入標題名稱!!");
		   	F.np_title.focus();
// 		} else if (F.np_image.value != "" && !file_chk.test(F.np_image.value.toLowerCase())) {
// 			alert("附檔名限為jpg|jpeg|gif|png|webp!!");
// 			F.np_image.focus();
	    } else if (F.np_emitdate.value > F.np_restdate.value) {
	        alert("上架日期不得大於下架日期!!");
	        F.np_emitdate.focus();
	        return false;
	    }else {
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
						<hr size="1" noshade />
					</td>
				</tr>
				
				<tr>
					<td align="center" colspan="2">
<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=M&np_id=<%=np_id %>&_qtitle=<%=qtitle %>&npage=<%=pageno %>&_qemitdate=<%=qemitdate %>&_qrestdate=<%=qrestdate %>" onsubmit="javascript:return checkform(this);">
					<table width="95%" border="0" cellspacing="1" cellpadding="0">
						<tr>
							<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
								<tr>
									<td align="center" colspan="4" class="web_title-1"><%=show_title%>&nbsp;&nbsp;
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
								
								<tr align="center" class="web_bk-2">
									<td colspan="4" align="center">修改資訊</td>
								</tr>

								<tr class="web_table-2-1">
									<td width="15%" align="right">標題</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="np_title" id="np_title" size="100" maxlength="120" value="<%=np.getString("np_title")%>"/>
									</td>
								</tr>

<!-- 								<tr class="web_table-2-1"> -->
<!-- 									<td align="right">簡述</td> -->
<!-- 									<td colspan="3" align="left"> -->
<%-- 										<textarea name="np_desc" id="np_desc" cols="100" rows="5" class="ezEditor"><%=np.getString("np_desc") %></textarea> --%>
<!-- 									</td> -->
<!-- 								</tr> -->
							
								<tr class="web_table-2-1">
									<td align="right">內文</td>
									<td colspan="3" align="left">
										<textarea name="np_content" id="np_content" cols="100" rows="8" class="mceEditor"><%=np.getString("np_content") %></textarea>
									</td>
								</tr>
							
<!-- 								<tr class="web_table-2-1"> -->
<!-- 									<td rowspan="2" align="right" class="web_table-2-1">消息圖片</td>	 -->
<!-- 									<td colspan="3" align="left" class="tablebg">&nbsp; -->
<%-- 							        <% if(!np.getString("np_image").isEmpty()){ %> --%>
<%-- 										<img src="<%=app_fetchpath+"/"+code+"/"+lang+"/"+np.getString("np_image")%>" width="198">		                      		 --%>
<%-- 								    <% } %> --%>
<!-- 									</td> -->
<!-- 			                    </tr> -->
		                    	
<!-- 		                    	<tr class="web_table-2-1"> -->
<!-- 									<td colspan="3" align="left" class="tablebg"> -->
<!-- 										<input name="imgradio" type="radio" value="ucpic" checked onclick="frm.np_image.value='';">使用原圖<br> -->
<!-- 										<input name="imgradio" type="radio" value="new">上傳新圖 -->
<%-- 										<input name="np_image" id="np_image" type="file" class="button" accept="image/*" onclick="frm.imgradio[1].checked=true;"> <%=image_info%> --%>
<!-- 									</td> -->
<!-- 			                    </tr> -->

								<%if(keyword_switch) { %>
								<tr align="center" class="web_bk-2">
									<td colspan="4" align="center">關鍵字設定</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">網頁標題</td>
									<td colspan="3" align="left">
										<input type="text" name="np_webtitle" id="np_webtitle" size="100" maxlength="255" value="<%=np.getString("np_webtitle") %>"/>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td width="15%" align="right">設定索引[Robots]</td>
									<td width="35%" align="left">
										<select name="np_robots" id="np_robots">
											<option value="index , follow"     <%="index , follow".equals(np.getString("np_robots")) ? "selected" : "" %>>全部-All</option>
											<option value="noindex , nofollow" <%="noindex , nofollow".equals(np.getString("np_robots")) ? "selected" : "" %>>無-None</option>
											<option value="index , nofollow"   <%="index , nofollow".equals(np.getString("np_robots")) ? "selected" : "" %>>索引-不跟蹤</option>
											<option value="noindex , follow"   <%="noindex , follow".equals(np.getString("np_robots")) ? "selected" : "" %>>不索引-跟蹤</option>
										</select>
									</td>
									<td width="20%" align="right">設定來訪週期</td>
									<td width="30%" align="left">
										<input type="number" name="np_revisit_after" id="np_revisit_after" value="<%=np.getString("np_revisit_after") %>" size="4" maxlength="4" />天
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">設定網頁版權說明</td>
									<td colspan="3" align="left">
										<input type="text" name="np_copyright" id="np_copyright" size="100" value="<%=np.getString("np_copyright") %>"/>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">
										設定主要關鍵字
									</td>
									<td colspan="3" align="left">
										<textarea name="np_keywords" id="np_keywords" cols="100" rows="3" maxlength="255"><%=np.getString("np_keywords") %></textarea>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">
										網頁內容簡介<br />[建議80-100字]
									</td>
									<td colspan="3" align="left">
										<textarea name="np_description" id="np_description" cols="100" rows="3" maxlength="255"><%=np.getString("np_description") %></textarea>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">設定head追蹤碼</td>
									<td colspan="3" align="left">
										<textarea name="np_seo_head_track" id="np_seo_head_track" cols="100" rows="3"><%=np.getString("np_seo_head_track") %></textarea>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">設定body追蹤碼</td>
									<td colspan="3" align="left">
										<textarea name="np_seo_body_track" id="np_seo_body_track" cols="100" rows="3"><%=np.getString("np_seo_body_track") %></textarea>
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
										<input type="text" name="np_emitdate" id="_qemitdate" value="<%=np.getString("np_emitdate") %>" size="15" readonly />
									</td>
									<td align="right" class="tablebg">下架日期</td>
									<td align="left" class="tablebg">
										<input type="text" name="np_restdate" id="_qrestdate" value="<%=np.getString("np_restdate") %>" size="15" readonly />
									</td>
								</tr>
								<%} %>

								<tr class="web_table-2-1">
									<td align="right">最後修改人員</td>
									<td align="left"><%=np.getString("np_modifyuser") %></td>
									<td align="right">最後修改日期</td>
									<td align="left"><%=np.getString("np_modifydate") %></td>
								</tr>
							</table></td>
						</tr>
						
						<tr align="center">
							<td colspan="4" align="center">
								<br />
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