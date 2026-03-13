<!DOCTYPE html>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	//基本參數
	String code 		= "guide"; 					// 模組識別碼
	String show_title 	= "捐款方式暨流程維護";				// 模組標題
	
	// 圖片建議尺寸
	String image_info = "(建議尺寸150px * 150px)";
	// 圖片建議尺寸
	String mobile_info = "(建議尺寸30px * 30px)";

	// 功能參數
	boolean list_switch = true;				// 是否開啟列表功能
	boolean sort_switch = true;				// 是否開啟排序功能
	boolean keyword_switch = false;			// 是否開啟關鍵字設定
	boolean deadline_switch = false;		// 是否開啟上下架日期
	int add_num = 7;						// 設定可新增的資料筆數 , -1 為無限筆

/*------------------------------------------------------------------------------------*/	

	Vector cps = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=?", new Object[]{ code, lang }, "cp_showseq ASC, cp_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,cps);

	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));

	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle" };
	String[] values = new String[] { String.valueOf(pageno), qtitle };
	// 回列表頁
	out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));

	// 修改資料id
	String cp_id = StringTool.validString(request.getParameter("cp_id"));	
	TableRecord cp = app_sm.select(tblcp, cp_id);	
%>
<html lang="<%=encoded%>">
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
<script>
	function checkform(F) {
		// 驗證副檔名
		var file_chk = /([^\/]+\.(?:jpg|jpeg|gif|png|svg))/;
		
		if (F.cp_title.value == "") {
	        alert("請輸入標題名稱!!");
	        F.cp_title.focus();
	    } else if(F.cp_image.value != "" && !file_chk.test(F.cp_image.value.toLowerCase())) {
	        alert("附檔名限為jpg|jpeg|gif|png|svg!!");
	        F.cp_image.focus();        	        
	    } else if(F.cp_mobile.value != "" && !file_chk.test(F.cp_mobile.value.toLowerCase())) {
	        alert("附檔名限為jpg|jpeg|gif|png|svg!!");
	        F.cp_mobile.focus();        	        
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
						<hr size="1" noshade />
					</td>
				</tr>
				<tr>
<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=M&cp_id=<%=cp_id %>&_qtitle=<%=qtitle %>&npage=<%=pageno %>" onsubmit="javascript:return checkform(this);">
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
									<td width="35%" align="left">
										<input type="text" name="cp_title" id="cp_title" size="57" maxlength="120" value="<%=cp.getString("cp_title")%>"/>
									</td>
									<td width="15%" align="right">標題(英文)</td>
									<td width="35%" align="left">
										<input type="text" name="cp_subtitle" id="cp_subtitle" size="57" maxlength="120" value="<%=cp.getString("cp_subtitle")%>" />
									</td>
								</tr>				
								<tr class="web_table-2-1">
									<td width="15%" align="right">是否在前台顯示</td>
									<td colspan="3" width="85%" align="left">
										<input type="checkbox" name="cp_display" id="cp_display" value="Y" <%=cp.getString("cp_display").equals("Y")?"checked":""%>/>
									</td>
								</tr>			

								<tr class="web_table-2-1">
									<td align="right">內文</td>
									<td colspan="3" align="left">
										<textarea name="cp_content" id="cp_content" cols="118" rows="8" class="ezEditor"><%=cp.getString("cp_content")%></textarea>
									</td>
								</tr>

								<tr class="web_table-2-1">
									<td align="right">捐款頁說明</td>
									<td colspan="3" align="left">
										<textarea name="cp_desc" id="cp_desc" cols="118" rows="8" class="ezEditor"><%=cp.getString("cp_desc")%></textarea>
									</td>
								</tr>
								<tr class="web_table-2-1">
									<td align="right">捐款完成頁說明</td>
									<td colspan="3" align="left">
										<textarea name="cp_content2" id="cp_content2" cols="118" rows="8" class="mceEditor"><%=cp.getString("cp_content2")%></textarea>
									</td>
								</tr>

								<tr class="web_table-2-1">
									<td rowspan="2" align="right" class="web_table-2-1">圖檔</td>	
									<td colspan="3" align="left" class="tablebg">&nbsp;
							        <% if(!cp.getString("cp_image").isEmpty()){ %>
										<img src="<%=app_fetchpath+"/"+code+"/"+lang+"/"+cp.getString("cp_image")%>" width="198">		                      		
								    <% } %>
									</td>
			                    </tr>
			                    <tr class="web_table-2-1">
									<td colspan="3" align="left" class="tablebg">
										<input name="imgradio" type="radio" value="ucpic" checked onclick="frm.cp_image.value='';">使用原圖<br>
										<input name="imgradio" type="radio" value="new">上傳新圖
										<input name="cp_image" id="cp_image" type="file" class="button" accept="image/*" onclick="frm.imgradio[1].checked=true;"> <%=image_info%>
									</td>
			                    </tr>								
								
								<tr class="web_table-2-1">
									<td rowspan="2" align="right" class="web_table-2-1">小icon</td>	
									<td colspan="3" align="left" class="tablebg">&nbsp;
							        <% if(!cp.getString("cp_mobile").isEmpty()){ %>
										<img src="<%=app_fetchpath+"/"+code+"/"+lang+"/"+cp.getString("cp_mobile")%>" width="198">		                      		
								    <% } %>
									</td>
			                    </tr>
			                    <tr class="web_table-2-1">
									<td colspan="3" align="left" class="tablebg">
										<input name="imgradio2" type="radio" value="ucpic" checked onclick="frm.cp_mobile.value='';">使用原圖<br>
										<input name="imgradio2" type="radio" value="new">上傳新圖
										<input name="cp_mobile" id="cp_mobile" type="file" class="button" accept="image/*" onclick="frm.imgradio2[1].checked=true;"> <%=mobile_info%>
									</td>
			                    </tr>	

								<%if(keyword_switch) { %>
								<tr align="center" class="web_bk-2">
									<td colspan="4" align="center">關鍵字設定</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">網頁標題</td>
									<td colspan="3" align="left">
										<input type="text" name="cp_webtitle" id="cp_webtitle" size="100" maxlength="255" value="<%=cp.getString("cp_webtitle") %>"/>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
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
								
								<tr class="web_table-2-1">
									<td align="right">設定網頁版權說明</td>
									<td colspan="3" align="left">
										<input type="text" name="cp_copyright" id="cp_copyright" size="100" value="<%=cp.getString("cp_copyright") %>"/>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">
										設定主要關鍵字
									</td>
									<td colspan="3" align="left">
										<textarea name="cp_keywords" id="cp_keywords" cols="100" rows="3" maxlength="255"><%=cp.getString("cp_keywords") %></textarea>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">
										網頁內容簡介<br />[建議80-100字]
									</td>
									<td colspan="3" align="left">
										<textarea name="cp_description" id="cp_description" cols="100" rows="3" maxlength="255"><%=cp.getString("cp_description") %></textarea>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">設定head追蹤碼</td>
									<td colspan="3" align="left">
										<textarea name="cp_seo_head_track" id="cp_seo_head_track" cols="100" rows="3"><%=cp.getString("cp_seo_head_track") %></textarea>
									</td>
								</tr>
								
								<tr class="web_table-2-1">
									<td align="right">設定body追蹤碼</td>
									<td colspan="3" align="left">
										<textarea name="cp_seo_body_track" id="cp_seo_body_track" cols="100" rows="3"><%=cp.getString("cp_seo_body_track") %></textarea>
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
										<input type="text" name="cp_emitdate" id="_qemitdate" value="<%=cp.getString("cp_emitdate") %>" size="15" readonly />
									</td>
									<td align="right" class="tablebg">下架日期</td>
									<td align="left" class="tablebg">
										<input type="text" name="cp_restdate" id="_qrestdate" value="<%=cp.getString("cp_restdate") %>" size="15" readonly />
									</td>
								</tr>
								<%} %>

								<tr class="web_table-2-1">
									<td align="right">最後修改人員</td>
									<td align="left"><%=cp.getString("cp_modifyuser") %></td>
									<td align="right">最後修改日期</td>
									<td align="left"><%=cp.getString("cp_modifydate") %></td>
								</tr>
							</table></td>
						</tr>
						<tr align="center">
							<td colspan="4" align="center"><br />
								<input type="hidden" name="_qtitle" value="<%=qtitle %>" />
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