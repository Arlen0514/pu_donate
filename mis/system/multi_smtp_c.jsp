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
	//boolean keyword_switch = true;		// 是否開啟關鍵字設定
	boolean deadline_switch = false;		// 是否開啟上下架日期
	int add_num = -1;						// 設定可新增的資料筆數 , -1 為無限筆
/*------------------------------------------------------------------------------------*/	
	Vector sts = app_sm.selectAll(tblst, "st_code=?", new Object[] { code }, "st_showseq ASC, st_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,sts);
	
	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));

	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle" };
	String[] values = new String[] { String.valueOf(pageno), qtitle };
	// 回列表頁
	out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
	
	// 修改資料id
	String st_id = StringTool.validString(request.getParameter("st_id"));	
	TableRecord st = app_sm.select(tblst, st_id);
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
<script>
	function checkform(F) {
		if (F.st_hostname.value == "") {
	        alert("請輸入標題名稱!!");
	        F.st_hostname.focus();
	    } else {
	        return true;
	    }
		return false;
	}
	<%-- SMTP測試 --%>
	function check_test_mail() {
		var isEmail = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
		
		if($("#test_email").val() == "" || !isEmail.test($("#test_email").val())) {
			alert("請輸入正確的Email!!");
			$("#test_email").focus();
		} else {
			$("#email").val( $("#test_email").val() );
			document.forms["frmEmail"].submit();
			return;
		}
	}	
</script>
</head>
<body class="default_body">
<%-- SMTP測試用表單 --%>
<form name="frmEmail" id="frmEmail" method="post" action="multi_smtp_sendmail.jsp">
	<input type="hidden" name="email" id="email" value="" />
	<input type="hidden" name="st_id" value="<%=st.getString("st_id") %>" />
</form>

<%-- 20250331 modify Miles top menu.jsp  改成 RWD --%>    
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
<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=M&st_id=<%=st_id %>&_qtitle=<%=qtitle %>&npage=<%=pageno %>" onsubmit="javascript:return checkform(this);">
					<td align="center" colspan="2"><table width="95%" border="0" cellspacing="1" cellpadding="0">
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
									<td colspan="4" align="center">修改資訊</td>
								</tr>
                      			<%-- SMTP測試 --%>
                      			<tr align="center" class="system_table-2-1">
                        			<td colspan="6" class="system_table-2-1"><strong>SMTP測試</strong>（工程人員測試用。於下方欄位輸入Email，系統將會寄送一封測試信件到該Email，主要用來測試下方填寫的SMTP資訊與郵件伺服器設定是否錯誤）</td>
								</tr>
                      			<tr class="system_table-2-1">
                        			<td colspan="2" align="right" class="admini_bk-2">Email</td>
                        			<td colspan="4" align="left" class="system_table-2-1">
                        				<input type="text" name="test_email" id="test_email" value="" size="50" />&nbsp;
                        				<input type="button" name="test_email_btn" value="寄送測試信件" onclick="check_test_mail();" />
                        			</td>
                      			</tr>								
	
								<tr class="system_table-2-1">
									<td width="15%" align="right">外送郵件伺服器名稱(SMTP)</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="st_hostname" id="st_hostname" size="100" maxlength="120" value="<%=st.getString("st_hostname") %>" required />
									</td>
								</tr>
	
								<tr class="system_table-2-1">
									<td width="15%" align="right">可寄次數</td>
									<td colspan="3" width="85%" align="left">
										<input type="number" name="st_times" id="st_times" min="0" value="<%=st.getInt("st_times")%>" required />
									</td>
								</tr>
	
								<tr class="system_table-2-1">
									<td width="15%" align="right">埠號(Port)</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="st_authport" id="st_authport" size="100" maxlength="120" value="<%=st.getString("st_authport")%>" required />
									</td>
								</tr>
	
								<tr class="system_table-2-1">
									<td width="15%" align="right">認證狀態</td>
									<td colspan="3" width="85%" align="left">
										<input name="st_authstatus" type="radio" value="Y" <%="Y".equals(st.getString("st_authstatus").trim())?"checked":"" %>/>
			                          	是
										<input name="st_authstatus" type="radio" value="N" <%="N".equals(st.getString("st_authstatus").trim())?"checked":"" %>/>
			                          	否
										<%-- 不建議客戶使用 ,除非客戶堅持才開啟
										<input name="st_authstatus" type="radio" value="G" <%="G".equals(st.getString("st_authstatus").trim())?"checked":"" %>/>
			                          	使用 GMail SMTP Server (465 Port)
										<input name="st_authstatus" type="radio" value="O" <%="O".equals(st.getString("st_authstatus").trim())?"checked":"" %>/>
			                          	使用 Office SMTP Server (587 Port)  
										--%>
									</td>
								</tr>
								<tr class="system_table-2-1">
									<td width="15%" align="right">是否啟用 SSL</td>
									<td colspan="3" width="85%" align="left">
										<input name="st_ssluse" type="radio" value="Y" <%="Y".equals(st.getString("st_ssluse").trim())?"checked":"" %>/>
		                          		是
										<input name="st_ssluse" type="radio" value="N" <%="N".equals(st.getString("st_ssluse").trim())?"checked":"" %>/>
		                          		否
									</td>
								</tr>								
	
								<tr class="system_table-2-1">
									<td width="15%" align="right">認證帳號</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="st_authaccount" id="st_authaccount" size="100" maxlength="120" value="<%=st.getString("st_authaccount")%>" required/>
									</td>
								</tr>
	
								<tr class="system_table-2-1">
									<td width="15%" align="right">認證密碼</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="st_authpassword" id="st_authpassword" size="100" maxlength="120" value="<%=st.getString("st_authpassword")%>" required/>
									</td>
								</tr>
	
								<tr class="system_table-2-1">
									<td width="15%" align="right">寄件者名稱</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="st_serviceemailname" id="st_serviceemailname" size="100" maxlength="120" value="<%=st.getString("st_serviceemailname")%>" required/>
									</td>
								</tr>
	
								<tr class="system_table-2-1">
									<td width="15%" align="right">寄件者信箱</td>
									<td colspan="3" width="85%" align="left">
										<input type="text" name="st_serviceemail" id="st_serviceemail" size="100" maxlength="120" value="<%=st.getString("st_serviceemail")%>" required/>
									</td>
								</tr>
	
								<%if(deadline_switch) { %>
								<tr align="center" class="system_bk-2">
									<td colspan="4" align="center">上下架時間</td>
								</tr>
	
								<tr class="system_table-2-1">
									<td align="right" class="system_table-2-1">上架日期</td>
									<td align="left" class="tablebg">
										<input name="st_emitdate" id="_qemitdate" type="text" value="<%=st.getString("st_emitdate") %>" size="15" readonly />
									</td>
									<td align="right" class="tablebg">下架日期</td>
									<td align="left" class="tablebg">
										<input name="st_restdate" id="_qrestdate" type="text" value="<%=st.getString("st_restdate") %>" size="15" readonly />
									</td>
								</tr>
								<%} %>
	
								<tr class="system_table-2-1">
									<td align="right">最後修改人員</td>
									<td align="left"><%=st.getString("st_modifyuser") %></td>
									<td align="right">最後修改日期</td>
									<td align="left"><%=st.getString("st_modifydate") %></td>
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
					</table></td>
</form>
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
</div>
</body>
</html>
<%@ include file="/WEB-INF/jspf/connclose.jspf" %>