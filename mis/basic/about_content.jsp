<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 基本參數
	String code = "about_content"; 			// 模組識別碼
	String upload_code = "about_content"; 	// 上傳資料夾識別碼
	String show_title = "靜宜概覽"; 			// 模組標題

	// 圖片建議尺寸
	String image_info = "(建議尺寸1280px * 800px)";
	// 圖片建議尺寸
	String mobile_info = "(建議尺寸880px * 822px)";

	// 功能參數
	boolean single = true;	   				// 單網編/單一修改畫面模組 true=關閉列表+ 排序+ 新增功能
	boolean list_switch = true;				// 是否開啟列表功能
	boolean sort_switch = true;				// 是否開啟排序功能
	boolean keyword_switch = true;			// 是否開啟關鍵字設定
	boolean deadline_switch = false;		// 是否開啟上下架日期
	int add_num = -1;						// 設定可新增的資料筆數 , -1 為無限筆
/*--------------------------------------------------------------------------------------*/
	Vector cps = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=?", new Object[] { code, lang }, "cp_showseq ASC, cp_createdate DESC");	
	
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num, cps);

	// 修改資料ID
	String cp_id = StringTool.validString(request.getParameter("cp_id"));
	TableRecord cp = app_sm.select(tblcp, cp_id);

	if(single) {
		list_switch = false;
		sort_switch = false;
		add_switch = false;
		add_num = 1;

		// 單網編 直接抓功能代號
		cp = app_sm.select(tblcp, "cp_code=? and cp_lang=?", new Object[]{ code, lang });
		
		// 設定預設值(單網編模組 直接顯示修改畫面)
		if(cp.getString("cp_id").equals("")) {
			cp = new TableRecord(tblcp);
			cp.setValue("cp_title", show_title);
			cp.setValue("cp_webtitle", SiteSetup.getSetup("web_title"+"."+lang).getString("ss_text"));
			cp.setValue("cp_robots", SiteSetup.getSetup("seo.robots"+"."+lang).getString("ss_text"));
			cp.setValue("cp_revisit_after", SiteSetup.getSetup("seo.revisit_after"+"."+lang).getString("ss_text"));
			cp.setValue("cp_keywords", SiteSetup.getSetup("seo.keywords"+"."+lang).getString("ss_text"));
			cp.setValue("cp_copyright", SiteSetup.getSetup("seo.copyright"+"."+lang).getString("ss_text"));
			cp.setValue("cp_description", SiteSetup.getSetup("seo.description"+"."+lang).getString("ss_text"));
			cp.setValue("cp_seo_head_track", SiteSetup.getSetup("seo.head_track"+"."+lang).getString("ss_text"));
			cp.setValue("cp_seo_body_track", SiteSetup.getSetup("seo.body_track"+"."+lang).getString("ss_text"));
			cp.setValue("cp_code", code);	// 識別碼
			cp.setValue("cp_lang", lang);	// 語系
			cp.setInsert(app_account); 
			app_sm.insert(cp);
		}
		cp_id = cp.getString("cp_id");
	}
%>
<html lang="<%=encoded%>">
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
<script>
	// 驗證副檔名
	var file_chk = /([^\/]+\.(?:jpg|jpeg|gif|png|webp))/;

	function checkform(F) {
		if(F.cp_image.value != "" && !file_chk.test(F.cp_image.value.toLowerCase())) {
	        alert("附檔名限為jpg|jpeg|gif|png|webp!!");
	        F.cp_image.focus();
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
      
      		<td width="99%" align="center" valign="top" class="system_bk-2p right_content_style">
<%-- 20250331 modify Miles top menu.jsp  改成 RWD --%>
					<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=M&cp_id=<%=cp_id%>" onsubmit="return checkform(this);">
					<table width="99%" border="0" cellspacing="0" cellpadding="0">							
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
								<td align="left" valign="middle" class="web_bigword"><%=show_title%>
								</td>
							</tr>
							
							<tr>
								<td colspan="2">
									<hr size="1" noshade />
								</td>
							</tr>
							
							<tr>
								<td align="center" colspan="2">
									<table width="95%" border="0" cellspacing="1" cellpadding="0">
										<tr>
											<td class="system_bk-2bk">
												<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
													<tr>
														<td align="center" colspan="4" class="web_title-1"><%=show_title%>&nbsp;&nbsp;
															<%if (add_switch) { %>
															<input type="button" value="新增資料" onclick="javascript:location.href='<%=code%>_a.jsp'" />
															&nbsp;
															<%} %>
															<%if (list_switch) { %>
															<input type="button" value="回到列表" onclick="javascript:location.href='<%=code%>.jsp'" />
															&nbsp;
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
															<%=cp.getString("cp_title") %>
															<%--
															<input type="text" name="cp_title" id="cp_title" size="100" maxlength="120" value="<%=cp.getString("cp_title")%>"/>
															 --%>
														</td>
													</tr>
													
													<tr class="web_table-2-1">
														<td align="right">內文</td>
														<td colspan="3" align="left">
															<textarea name="cp_content" id="cp_content" cols="100" rows="8" class="mceEditor"><%=cp.getString("cp_content")%></textarea>
														</td>
													</tr>

<!-- 													<tr class="web_table-2-1"> -->
<!-- 														<td rowspan="2" align="right" class="web_table-2-1">圖檔</td> -->
<!-- 														<td colspan="3" align="left" class="tablebg">&nbsp; -->
<%-- 															<%if(!"".equals(cp.getString("cp_image"))) { %> --%>
<%-- 															<img src="<%=app_fetchpath+"/"+code+"/"+lang+"/"+cp.getString("cp_image")%>" width="100%" /> --%>
<%-- 															<%} %>		                      		 --%>
<!-- 														</td> -->
<!-- 							                    	</tr> -->

<!-- 							                    	<tr class="web_table-2-1"> -->
<!-- 														<td colspan="3" align="left" class="tablebg"> -->
<!-- 															<input name="imgradio" type="radio" value="ucpic" checked onclick="frm.cp_image.value='';" />使用原圖<br /> -->
<!-- 															<input name="imgradio" type="radio" value="new" />上傳新圖 -->
<%-- 															<input name="cp_image" id="cp_image" type="file" class="button" accept="image/*" onclick="frm.imgradio[1].checked=true;" /> <%=image_info%> --%>
<!-- 														</td> -->
<!-- 							                    	</tr> -->

													<%if(keyword_switch) { %>
													<tr align="center" class="web_table-2-1">
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
															<input type="text" name="cp_revisit_after" id="cp_revisit_after" value="<%=cp.getString("cp_revisit_after")%>" size="4" maxlength="4" />
															天
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
															網頁內容簡介
															<br />
															[建議80-100字]
														</td>
														<td colspan="3" align="left">
															<textarea name="cp_description" id="cp_description" cols="100" rows="3" maxlength="255"><%=cp.getString("cp_description")%></textarea>
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
														<td align="left"><%=cp.getString("cp_modifyuser")%></td>
														<td align="right">最後修改日期</td>
														<td align="left"><%=cp.getString("cp_modifydate")%></td>
													</tr>
												</table>
											</td>
										</tr>
										
										<tr align="center">
											<td colspan="4" align="center">
												<br />
												<input type="submit" value="確定送出" />
												&nbsp;
												<input type="reset" value="重新設定" />
											</td>
										</tr>
									</table>
								</td>
							</tr>
							
							<tr>
								<td colspan="3">&nbsp;</td>
							</tr>
							
							<tr>
								<td colspan="3" class="web_bk-2b">&nbsp;</td>
							</tr>
						</table>
					</form>
				</td>
			</tr>
		</table>
	</div>
	</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>