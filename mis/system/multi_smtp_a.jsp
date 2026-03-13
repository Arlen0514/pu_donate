<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/config.jspf" %>
<%@ include file="/WEB-INF/jspf/mis/check.jspf" %>
<%@ include file="include/function.jsp" %>
<%
	// 基本參數
	String code = "multi_smtp"; 			// 模組識別碼
	String show_title = "SMTP 維護";			// 模組標題

	// 圖片建議尺寸
	//String image_info = "(建議尺寸1280px * 580px)";
	// 圖片建議尺寸
	//String mobile_info = "(建議尺寸830px * 1300px)";

	// 功能參數
	boolean list_switch = true;				// 是否開啟列表功能
	boolean sort_switch = true;				// 是否開啟排序功能
	boolean keyword_switch = true;			// 是否開啟關鍵字設定
	boolean deadline_switch = false;		// 是否開啟上下架日期	
	int add_num = -1;						// 設定可新增的資料筆數 , -1 為無限筆
/*----------------------------------------------------------------------------------------------*/
	Vector datas = app_sm.selectAll(tblst, "st_code=?", new Object[] { code }, "st_showseq ASC, st_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,datas);
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
<script>
	function checkform(F) {	
		if (F.st_hostname.value == "") {
	        alert("請輸入外送郵件伺服器名稱(SMTP)!!");
	        F.st_hostname.focus();
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
					<td colspan="2" class="system_bk-2b">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td width="60" align="left" valign="middle">
						<img src="../images/system_icon_1.gif" width="55" height="48">
					</td>
					<td align="left" valign="middle" class="system_bigword"><%=show_title%></td>
				</tr>
				<tr>
					<td colspan="2">
						<hr size="1" noshade />
					</td>
				</tr>
				<tr>
					<td align="center" colspan="2">
<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=A" onsubmit="javascript:return checkform(this);">
					<table width="95%" border="0" cellspacing="1" cellpadding="0">
						<tr>
							<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
								<tr>
									<td align="center" colspan="4" class="system_title-1">
										<%=show_title%>&nbsp;&nbsp;
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
								
								<tr align="center" class="system_bk-2">
									<td colspan="4" align="center">新增資訊</td>
								</tr>
								
								<tr class="system_table-2-1">
									<td width="15%" align="right">外送郵件伺服器名稱(SMTP)</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="st_hostname" id="st_hostname" size="100" maxlength="120" required/>
									</td>
								</tr>
								
								<tr class="system_table-2-1">
									<td width="15%" align="right">可寄次數</td>
									<td colspan="3" width="85%" align="left">
										<input type="number" name="st_times" id="st_times" min="0" value="0" required/>
									</td>
								</tr>
							
								<tr class="system_table-2-1">
									<td width="15%" align="right">埠號(Port)</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="st_authport" id="st_authport" size="100" maxlength="120" required/>
									</td>
								</tr>
							
								<tr class="system_table-2-1">
									<td width="15%" align="right">認證狀態</td>
									<td colspan="3" width="85%" align="left">
										<input name="st_authstatus" type="radio" value="Y" checked/>
		                          		是
										<input name="st_authstatus" type="radio" value="N" />
		                          		否
										<%-- 不建議客戶使用 ,除非客戶堅持才開啟
										<input name="st_authstatus" type="radio" value="G" />
			                          	使用 GMail SMTP Server (465 Port)
										<input name="st_authstatus" type="radio" value="O" />
			                          	使用 Office SMTP Server (587 Port)  
										--%>	
									</td>
								</tr>
								<tr class="system_table-2-1">
									<td width="15%" align="right">是否啟用 SSL</td>
									<td colspan="3" width="85%" align="left">
										<input name="st_ssluse" type="radio" value="Y" />
		                          		是
										<input name="st_ssluse" type="radio" value="N" checked/>
		                          		否
									</td>
								</tr>								
							
								<tr class="system_table-2-1">
									<td width="15%" align="right">認證帳號</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="st_authaccount" id="st_authaccount" size="100" maxlength="120" required/>
									</td>
								</tr>
								
								<tr class="system_table-2-1">
									<td width="15%" align="right">認證密碼</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="st_authpassword" id="st_authpassword" size="100" maxlength="120" required/>
									</td>
								</tr>
								
								<tr class="system_table-2-1">
									<td width="15%" align="right">寄件者名稱</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="st_serviceemailname" id="st_serviceemailname" size="100" maxlength="120" required/>
									</td>
								</tr>
								
								<tr class="system_table-2-1">
									<td width="15%" align="right">寄件者信箱</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="st_serviceemail" id="st_serviceemail" size="100" maxlength="120" required/>
									</td>
								</tr>

								<%if(deadline_switch) { %>
								<tr align="center" class="system_bk-2">
									<td colspan="4" align="center">上下架時間</td>
								</tr>

								<tr class="system_table-2-1">
									<td align="right" class="system_table-2-1">上架日期</td>
									<td align="left" class="tablebg">
										<input name="st_emitdate" id="_qemitdate" type="text" value="<%=DateTimeTool.dateString()%>" size="15" readonly />
									</td>
									<td align="right" class="tablebg">下架日期</td>
									<td align="left" class="tablebg">
										<input name="st_restdate" id="_qrestdate" type="text" value="2099/12/31" size="15" readonly />
									</td>
								</tr>
								<%} %>
								<tr class="system_table-2-1">
									<td align="right">資料建立人員</td>
									<td align="left"><%=app_account%></td>
									<td align="right">資料建立日期</td>
									<td align="left"><%=app_today%></td>
								</tr>
							</table></td>
						</tr>
						<tr align="center">
							<td colspan="4" align="center">
								<br />
								<input type="hidden" name="st_status" id="st_status" value="Y" />
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
					<td colspan="3" class="system_bk-2b">&nbsp;</td>
				</tr>
			</table></td>
		</tr>
	</table>
</div>
</body>
</html>
<%@ include file="/WEB-INF/jspf/connclose.jspf" %>