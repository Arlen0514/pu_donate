<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 基本參數
	String code = "sitemap_upload"; 		// 模組識別碼
	String upload_code = "sitemap_upload"; 	// 上傳資料夾識別碼
	String show_title = "Sitemap上傳"; 		// 模組標題
	
	// Server name.	
	String servername = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
	if(request.getServerPort()== 80 || request.getServerPort()== 443) {
		servername = request.getScheme()+"://"+request.getServerName();
	}
	String localname = request.getScheme()+"://"+request.getLocalName()+":"+request.getLocalPort();
	String url = servername + request.getContextPath();
	String sitemapFile = url + "/sitemap.xml";
	
	// 判斷sitemap.xml是否存在
	HttpURLConnection.setFollowRedirects(false);
	HttpURLConnection con = (HttpURLConnection) new URL(sitemapFile).openConnection();
	con.setRequestMethod("HEAD");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
<script>
	// 驗證副檔名
	var file_chk = /([^\/]+\.(?:xml))/;

	function checkform(F) {
		if(F.sitemap_file.value == "") {
			alert("請上傳sitemap !!");
	        F.sitemap_file.focus();
		} else if(F.sitemap_file.value != "" && !file_chk.test(F.sitemap_file.value.toLowerCase())) {
	        alert("附檔名限為xml !!");
	        F.sitemap_file.focus();
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
					<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp" onsubmit="return checkform(this);">
						<table width="95%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td colspan="2" class="system_bk-2b">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td width="60" align="left" valign="middle">
									<img src="../images/system_icon_1.gif" width="55" height="48" />
								</td>
								<td align="left" valign="middle" class="system_bigword"><%=show_title%>
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
														<td align="center" colspan="4" class="system_title-1">
															<%=show_title%>&nbsp;&nbsp;
														</td>
													</tr>

							                    	<tr class="system_table-2-1">
							                    		<td width="15%" align="center" class="tablebg">
															上傳sitemap.xml
														</td>
														<td width="35%" align="left" class="tablebg">
															<input name="sitemap_file" id="sitemap_file" type="file" class="button" accept=".xml" required/>
														</td>
							                    		<td width="15%" align="center" class="tablebg">
															目前的sitemap.xml
														</td>
														<td width="35%" align="left" class="tablebg">
															&nbsp;&nbsp;
															<%if(con.getResponseCode() == HttpURLConnection.HTTP_OK) { %>
																<a href="<%=sitemapFile %>" download>點我下載</a>
															<%} else { %>
																無
															<%} %>
														</td>
							                    	</tr>

												</table>
											</td>
										</tr>
										<tr align="center">
											<td colspan="4" align="center">
												<br />
												<input type="submit" value="確定送出" />
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="3">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="3" class="system_bk-2b">&nbsp;</td>
							</tr>
						</table>
					</form>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>