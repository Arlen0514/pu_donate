<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/config.jspf" %>
<%@ include file="/WEB-INF/jspf/mis/check.jspf" %>
<%@ page import="org.apache.commons.io.*"%>
<%
	String code	= "websetup_c";				// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用

	// Left side type.
	String lefttype = "system";

	/*-- 針對各語系設定欄位 --*/
	// Tiltes.
	String[] titles = new String[] {
		"靜宜大學連結", "校友中心連結", "宗教輔導室",  "蓋夏圖書館", "體育室",
		"校友中心連結名稱",  "宗教輔導室名稱","蓋夏圖書館名稱", "體育室名稱",
		"Facebook", "Youtube", "Instagram", "Threads",
		"地址連結", "隱私連結",
		"網站前台名稱", "公司名稱", "地址", "電話", "傳真", "統編", "信箱",
		"Open Graph 標題", "Open Graph 簡述", "索引", "來訪週期", "關鍵字",
		"版權說明", "內容簡介", "head追踪碼", "body追踪碼"
	};

	// Keywords.
	String[] keywords = new String[] {
		"web_ntou_official_url" , "web_alumni_center_url", "campus_url", "library_url", "sport_url",
		"web_alumni_center_title", "campus_title", "library_title", "sport_title",
		"cp.fb", "cp.yt", "cp.ig", "cp.td", 
		"cp.address_link", "cp.privacy_link",
		"web_title", "cp.company", "cp.address", "cp.phone", "cp.fax", "cp.companyno", "cp.email",
		"og.title", "og.description", "seo.robots", "seo.revisit_after", "seo.keywords",
		"seo.copyright", "seo.description", "seo.head_track", "seo.body_track"
	};

	// Get records.
	Vector misimages = new Vector();
	for (int i = 0; i < titles.length; i++) {
		TableRecord ss = SiteSetup.getSetup(keywords[i] + "." + lang);
		if (ss.getString("ss_id").equals("")) {
			ss = new TableRecord(tblss);
			ss.setInsert(app_account);
			ss.setValue("ss_title", titles[i]);
			ss.setValue("ss_keyword", keywords[i] + "." + lang);
			app_sm.insert(ss);
		}
		misimages.add(ss);
	}
	/*-- 針對不分語系共通設定欄位 --*/
	// Tiltes.
	String[] titles_1 = new String[] { 
		"載入頁", "分頁設定", "檢查登入IP設定", "洽詢專線聯絡人-聯絡資訊", "洽詢專線聯絡人-電子信箱"
	};

	// Keywords.
	String[] keywords_1 = new String[] { 
		"ss.loading", "ss.pageno", "ss.check_ip" , "ss.contact_info" , "ss.contact_email" 
	};

	// Get records.
	Vector misimages_1 = new Vector();
	for (int i = 0; i < titles_1.length; i++) {
		TableRecord ss = SiteSetup.getSetup(keywords_1[i]);
		if (ss.getString("ss_id").equals("")) {
			ss = new TableRecord(tblss);
			ss.setInsert(app_account);
			ss.setValue("ss_title", titles_1[i]);
			ss.setValue("ss_keyword", keywords_1[i]);
			app_sm.insert(ss);
		}
		misimages.add(ss);
	}
	
	// 計算 uploads 下的資料
	File uploads_f = new File (app_uploadpath);

	long user_size = FileUtils.sizeOfDirectory(uploads_f)/1024/1024/1024;
	String user_size_str = user_size+" GB";
	/*
	System.out.println("file a---"+app_uploadpath);
	System.out.println("uploads_f.getTotalSpace()---"+uploads_f.getTotalSpace());    			// 整個空間大小
	System.out.println("uploads_f.getUsableSpace()---"+uploads_f.getUsableSpace());				// 可用空間大小
	System.out.println("uploads_f.getFreeSpace()---"+uploads_f.getFreeSpace());					// 尚未使用空間大小
	*/
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@include file="include/head.jsp"%>
<script language="JavaScript" type="text/JavaScript">
	function checkform(F) {
		return true;
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
				<td colspan="2" class="system_bk-2b">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td width="60" align="left" valign="middle"><img src="../images/system_icon_1.gif" width="55" height="48"></td>
				<td align="left" valign="middle" class="system_bigword">系統環境設定</td>
			</tr>
			<tr>
				<td colspan="2">
				<hr size="1" noshade>
				</td>
			</tr>
<form name="form0" method="post" action="websetup_c_update.jsp" onsubmit="return checkform(this);">
			<tr align="center">
				<td colspan="2"><table width="95%" border="0" cellspacing="1" cellpadding="0">
					<tr>
						<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
							<tr align="center">
								<td colspan="4" class="system_title-1">系統環境設定</td>
							</tr>

							<tr align="center">
								<td colspan="4" class="market_bk-2">共計使用空間大小:<%=user_size_str %></td>
							</tr>
							
							<tr>
								<td colspan="4" align="center" class="admini_bk-2">網頁標題（Title）設定</td>
							</tr>
							<tr class="system_table-2-1">
								<td width="15%" align="right" class="admini_bk-2">名稱</td>
								<td width="85%" colspan="3" align="left" class="system_table-2-1">
									<input name="web_title" type="text" size="50" value="<%=SiteSetup.getSetup("web_title" + "." + lang).getString("ss_text")%>" />
								</td>
							</tr>
							
							<tr>
								<td colspan="4" align="center" class="admini_bk-2">版頭連結設定</td>
							</tr>

							<tr class="system_table-2-1">
								<td width="15%" align="right" class="admini_bk-2">靜宜大學</td>
								<td width="85%" colspan="3" align="left" class="system_table-2-1">
									<input name="web_ntou_official_url" type="text" size="120" value="<%=SiteSetup.getSetup("web_ntou_official_url" + "." + lang).getString("ss_text")%>" />
								</td>
							</tr>

							<tr class="system_table-2-1">
								<td width="15%" align="right" class="admini_bk-2">
								<input name="web_alumni_center_title" type="text" style="width:55%"
								 value="<%=SiteSetup.getSetup("web_alumni_center_title" + "." + lang).getString("ss_text")%>" />
								連結
								</td>
								<td width="85%" colspan="3" align="left" class="system_table-2-1">
									<input name="web_alumni_center_url" type="text" size="120" value="<%=SiteSetup.getSetup("web_alumni_center_url" + "." + lang).getString("ss_text")%>" />
								</td>
							</tr>
							<tr class="system_table-2-1">
								<td width="15%" align="right" class="admini_bk-2">
									<input name="campus_title" type="text" style="width:55%"
									 value="<%=SiteSetup.getSetup("campus_title" + "." + lang).getString("ss_text")%>" />
									連結
								</td>
								<td width="85%" colspan="3" align="left" class="system_table-2-1">
									<input name="campus_url" type="text" size="120" value="<%=SiteSetup.getSetup("campus_url" + "." + lang).getString("ss_text")%>" />
								</td>
							</tr>
							<tr class="system_table-2-1">
								<td width="15%" align="right" class="admini_bk-2">
									<input name="library_title" type="text" style="width:55%"
									 value="<%=SiteSetup.getSetup("library_title" + "." + lang).getString("ss_text")%>" />
								連結
								</td>
								<td width="85%" colspan="3" align="left" class="system_table-2-1">
									<input name="library_url" type="text"  style="width:55%"
									value="<%=SiteSetup.getSetup("library_url" + "." + lang).getString("ss_text")%>" />
								</td>
							</tr>
							<tr class="system_table-2-1">
								<td width="15%" align="right" class="admini_bk-2">
									<input name="sport_title" type="text" style="width:55%"
									 value="<%=SiteSetup.getSetup("sport_title" + "." + lang).getString("ss_text")%>" />
								連結
								</td>	
								<td width="85%" colspan="3" align="left" class="system_table-2-1">
									<input name="sport_url" type="text" size="120" value="<%=SiteSetup.getSetup("sport_url" + "." + lang).getString("ss_text")%>" />
								</td>
							</tr>
							<tr class="system_table-2-1">
								<td width="15%" align="right" class="admini_bk-2">隱私權連結</td>
								<td width="85%" colspan="3" align="left" class="system_table-2-1">
									<input name="cp.privacy_link" type="text" size="120" value="<%=SiteSetup.getSetup("cp.privacy_link" + "." + lang).getString("ss_text")%>" />
								</td>
							</tr>
							<tr class="system_table-2-1">
								<td width="15%" align="right" class="admini_bk-2">Facebook</td>
								<td width="85%" colspan="3" align="left" class="system_table-2-1">
									<input name="cp.fb" type="text" size="120" value="<%=SiteSetup.getSetup("cp.fb" + "." + lang).getString("ss_text")%>" />
								</td>
							</tr>
							<tr class="system_table-2-1">
								<td width="15%" align="right" class="admini_bk-2">Youtube</td>
								<td width="85%" colspan="3" align="left" class="system_table-2-1">
									<input name="cp.yt" type="text" size="120" value="<%=SiteSetup.getSetup("cp.yt" + "." + lang).getString("ss_text")%>" />
								</td>
							</tr>
							<tr class="system_table-2-1">
								<td width="15%" align="right" class="admini_bk-2">Instagram</td>
								<td width="85%" colspan="3" align="left" class="system_table-2-1">
									<input name="cp.ig" type="text" size="120" value="<%=SiteSetup.getSetup("cp.ig" + "." + lang).getString("ss_text")%>" />
								</td>
							</tr>
							<tr class="system_table-2-1">
								<td width="15%" align="right" class="admini_bk-2">Threads</td>
								<td width="85%" colspan="3" align="left" class="system_table-2-1">
									<input name="cp.td" type="text" size="120" value="<%=SiteSetup.getSetup("cp.td" + "." + lang).getString("ss_text")%>" />
								</td>
							</tr>
						</table></td>
					</tr>
				</table></td>
			</tr>

			<tr align="center">
				<td colspan="2"><table width="95%" border="0" cellspacing="1" cellpadding="0">
					<tr>
						<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">

							<tr align="center">
								<td colspan="4" class="admini_bk-2">頁尾 CopyRight 資訊設定</td>
							</tr>
							
							<tr class="system_table-2-1">
								<td align="right" class="admini_bk-2">名稱</td>
								<td colspan="3" align="left" class="system_table-2-1">
									<input name="cp.company" type="text" value="<%=SiteSetup.getSetup("cp.company" + "." + lang).getString("ss_text")%>" size="42" />
								</td>					
							</tr>
							<tr class="system_table-2-1">
								<td align="right" class="admini_bk-2">地址</td>
								<td colspan="3" align="left" class="system_table-2-1">
									<input name="cp.address" type="text" value="<%=SiteSetup.getSetup("cp.address" + "." + lang).getString("ss_text")%>" size="126" />
								</td>
							</tr>
							<tr class="system_table-2-1">
								<td align="right" class="admini_bk-2">地圖連結</td>
								<td colspan="3" align="left" class="system_table-2-1">
									<input name="cp.address_link" type="text" value="<%=SiteSetup.getSetup("cp.address_link" + "." + lang).getString("ss_text")%>" size="126" />
								</td>
							</tr>
						
							<tr class="system_table-2-1">
								<td width="15%" align="right" class="admini_bk-2">Email</td>
								<td width="35%" align="left" class="system_table-2-1">
									<input name="cp.email" type="text" value="<%=SiteSetup.getSetup("cp.email" + "." + lang).getString("ss_text")%>" size="42" />
								</td>
								
								<td width="15%" align="right" class="admini_bk-2">捐款專線</td>
								<td width="35%" align="left" class="system_table-2-1">
									<input name="cp.phone" type="text" value="<%=SiteSetup.getSetup("cp.phone" + "." + lang).getString("ss_text")%>" size="42" />
								</td>
								
							</tr>
							<tr class="system_table-2-1">
								<td align="right" class="admini_bk-2">傳真</td>
								<td colspan="3" align="left" class="system_table-2-1">
									<input name="cp.fax" type="text" value="<%=SiteSetup.getSetup("cp.fax" + "." + lang).getString("ss_text")%>" size="42" />
								</td>
							</tr>

						</table></td>
					</tr>
				</table></td>
			</tr>

			<tr align="center">
				<td colspan="2"><table width="95%" border="0" cellspacing="1" cellpadding="0">
					<tr>
						<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
							<tr align="center">
								<td colspan="4" class="admini_bk-2">系統環境相關參數設定</td>
							</tr>

	                        <tr class="system_table-2-1">
	                          	<td width="15%" align="right" class="admini_bk-2">載入頁 開關設定</td>
	                          	<td width="35%" align="left" class="system_table-2-1">
	                          		<label>
		                          		<input name="ss.loading" type="radio" value="Y" <%="Y".equals(SiteSetup.getSetup("ss.loading").getString("ss_value").trim())?"checked":"" %> />
		                            	開啟
	                            	</label>
	                            	<label>
		                            	<input name="ss.loading" type="radio" value="N" <%=!"Y".equals(SiteSetup.getSetup("ss.loading").getString("ss_value").trim())?"checked":"" %> />
										關閉
									</label>
	                          	</td>
	                          	<td width="15%" align="right" class="admini_bk-2">前台分頁 開關設定</td>
	                          	<td width="35%" align="left" class="system_table-2-1">
	                          		<label>
		                          		<input name="ss.pageno" type="radio" value="Y" <%="Y".equals(SiteSetup.getSetup("ss.pageno").getString("ss_value").trim())?"checked":"" %> />
		                            	開啟
	                            	</label>
	                            	<label>
		                            	<input name="ss.pageno" type="radio" value="N" <%=!"Y".equals(SiteSetup.getSetup("ss.pageno").getString("ss_value").trim())?"checked":"" %> />
										關閉
									</label>
	                          	</td>
	                        </tr>

	                        <tr class="system_table-2-1">
	                          	<td width="15%" align="right" class="admini_bk-2">
	                          		檢查後台登入IP 開關設定
	                          	</td>
	                          	<td colspan="3" width="85%" align="left" class="system_table-2-1">
	                          		&nbsp;&nbsp;
	                          		<input type="button" value="白名單設定" onclick="location='ip_white_list.jsp';" />
									&nbsp;｜&nbsp;
	                          		<label>
		                          		<input name="ss.check_ip" type="radio" value="Y" <%="Y".equals(SiteSetup.getSetup("ss.check_ip").getString("ss_value").trim())?"checked":"" %> />
		                            	開啟
	                            	</label>
	                            	<label>
		                            	<input name="ss.check_ip" type="radio" value="N" <%=!"Y".equals(SiteSetup.getSetup("ss.check_ip").getString("ss_value").trim())?"checked":"" %> />
										關閉
									</label>
	                          	</td>
	                        </tr>
	                        
	                        <tr align="center">
								<td colspan="4" class="admini_bk-2">捐款洽詢專線聯絡人設定</td>
							</tr>
							
							<tr class="system_table-2-1">
	                          	<td width="15%" align="right" class="admini_bk-2">聯絡資訊</td>
	                          	<td width="35%" align="left" class="system_table-2-1">
		                            <input name="ss.contact_info" type="text" value="<%=SiteSetup.getValue("ss.contact_info") %>" size="40" />
	                          	</td>
	                          	<td width="15%" align="right" class="admini_bk-2">電子信箱</td>
	                          	<td width="35%" align="left" class="system_table-2-1">
		                          	<input name="ss.contact_email" type="text" value="<%=SiteSetup.getValue("ss.contact_email") %>" size="40" />
	                          	</td>
	                        </tr>
						</table></td>
					</tr>
				</table></td>
			</tr>

			<tr align="center">
				<td colspan="2"><table width="95%" border="0" cellspacing="1" cellpadding="0">
					<tr>
						<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
							<tr align="center">
								<td colspan="4" class="admini_bk-2">Open Graph(OG)參數設定</td>
							</tr>

	                        <tr class="system_table-2-1">
								<td width="15%" align="right" class="admini_bk-2">標題</td>
								<td colspan="3" width="85%" align="left" class="system_table-2-1">
									<input name="og.title" type="text" size="100" value="<%=SiteSetup.getSetup("og.title" + "." + lang).getString("ss_text") %>" />
								</td>
							</tr>
							
							<tr class="system_table-2-1">
								<td width="15%" align="right" class="admini_bk-2">簡述</td>
								<td colspan="3" width="85%" align="left" class="system_table-2-1">
									<textarea name="og.description" cols="100" rows="4"><%=SiteSetup.getSetup("og.description" + "." + lang).getString("ss_text") %></textarea>
								</td>
							</tr>
						</table></td>
					</tr>
				</table></td>
			</tr>

			<tr align="center">
				<td colspan="2"><table width="95%" border="0" cellspacing="1" cellpadding="0">
					<tr>
						<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
							<tr>
								<td colspan="4" align="center" class="admini_bk-2">首頁暨各列表頁面關鍵字設定</td>
							</tr>
							<tr class="system_table-2-1">
								<td width="15%" align="right" class="admini_bk-2">設定索引[Robots]</td>
								<td width="35%" align="left" class="system_table-2-1">
									<select name="seo.robots">
										<option value="index , follow"     <%="index , follow".equals(SiteSetup.getSetup("seo.robots." + lang).getString("ss_text")) ? "selected" : "" %>>全部-All</option>
										<option value="noindex , nofollow" <%="noindex , nofollow".equals(SiteSetup.getSetup("seo.robots." + lang).getString("ss_text")) ? "selected" : "" %>>無-None</option>
										<option value="index , nofollow"   <%="index , nofollow".equals(SiteSetup.getSetup("seo.robots." + lang).getString("ss_text")) ? "selected" : "" %>>索引-不跟蹤</option>
										<option value="noindex , follow"   <%="noindex , follow".equals(SiteSetup.getSetup("seo.robots." + lang).getString("ss_text")) ? "selected" : "" %>>不索引-跟蹤</option>
									</select>
								</td>
								<td width="15%" align="right" class="admini_bk-2">設定來訪週期</td>
								<td width="35%" align="left" class="system_table-2-1">
									<input name="seo.revisit_after" type="text" size="5" value="<%=SiteSetup.getSetup("seo.revisit_after" + "." + lang).getString("ss_text")%>" /> [請輸入數字]
								</td>
							</tr>
							<tr class="system_table-2-1">
								<td align="right" class="admini_bk-2">設定網頁版權說明</td>
								<td colspan="3" align="left" class="system_table-2-1"><input name="seo.copyright" type="text" size="100" value="<%=SiteSetup.getSetup("seo.copyright" + "." + lang).getString("ss_text")%>" /></td>
							</tr>
							<tr class="system_table-2-1">
								<td align="right" class="admini_bk-2">設定主要關鍵字<br />[建議80~100字]</td>
								<td colspan="3" align="left" class="system_table-2-1"><textarea name="seo.keywords" cols="100" rows="4"><%=SiteSetup.getSetup("seo.keywords" + "." + lang).getString("ss_text")%></textarea></td>
							</tr>
							<tr class="system_table-2-1">
								<td align="right" class="admini_bk-2">網頁內容簡介<br />[建議80~100字]</td>
								<td colspan="3" align="left" class="system_table-2-1"><textarea name="seo.description" cols="100" rows="4"><%=SiteSetup.getSetup("seo.description" + "." + lang).getString("ss_text")%></textarea></td>
							</tr>
							<tr class="system_table-2-1">
								<td align="right" class="admini_bk-2">設定head追蹤碼</td>
								<td colspan="3" align="left" class="system_table-2-1"><textarea name="seo.head_track" cols="100" rows="8"><%=SiteSetup.getSetup("seo.head_track" + "." + lang).getString("ss_text")%></textarea></td>
							</tr>
							<tr class="system_table-2-1">
								<td align="right" class="admini_bk-2">設定body追蹤碼</td>
								<td colspan="3" align="left" class="system_table-2-1"><textarea name="seo.body_track" cols="100" rows="8"><%=SiteSetup.getSetup("seo.body_track" + "." + lang).getString("ss_text")%></textarea></td>
							</tr>
							<tr class="system_table-2-1">
								<td align="right" class="admini_bk-2">最後修改人員</td>
								<td align="left" class="system_table-2-1"><%=SiteSetup.getSetup("seo.robots" + "." + lang).getString("ss_modifyuser") %></td>
								<td align="right" class="admini_bk-2">最後修改日期</td>
								<td align="left" class="system_table-2-1"><%=SiteSetup.getSetup("seo.robots" + "." + lang).getString("ss_modifydate") %></td>
							</tr>
						</table></td>
					</tr>
				</table>
				<br />
				<input type="submit" name="update" value="確定送出">&nbsp;
				<input type="reset" name="cancel" value="放棄修改"></td>
			</tr>
</form>
			<tr>
				<td colspan="2">
					<div align="center"><br></div>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="system_bk-2b">&nbsp;</td>
			</tr>
		</table></td>
	</tr>
</table>
</div>
</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>