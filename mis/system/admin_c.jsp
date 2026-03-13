<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	String code	= "admin_b";				// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用

   	// Query conditions.
   	String qaccount = StringTool.validString(request.getParameter("_qaccount"));
   	String qname = StringTool.validString(request.getParameter("_qname"));
   	String qmfid = StringTool.validString(request.getParameter("_qmfid"));

   	// Selected record id.
   	String auid = StringTool.validString(request.getParameter("au_id"));

   	// Get record.   
   	Vector aus = app_sm.selectAll("admin_user", "au_id=?", new Object[] { auid });
   	TableRecord au = (aus.size() > 0) ? (TableRecord)aus.get(0) : new TableRecord("admin_user");
   
   	// Authorities.
   	Vector amfs = app_sm.selectAll("admin_map_function", "au_id=?", new Object[] { auid });
   	Vector mfids = new Vector();
   	for (int i = 0; i < amfs.size(); i++) {
       	TableRecord amf = (TableRecord)amfs.get(i);
       	mfids.add(amf.getString("mf_id"));
   	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@include file="include/head.jsp"%>
<script language="JavaScript" type="text/JavaScript">
	function check_account(INPUT) {
	    var litExp = /\W+/;  // non numeral or letter or underscore
	    var invalid = litExp.test(INPUT);
	    return invalid;
	}
	
	function check_pwd(INPUT) {
		// 密碼長度需為 8-30 位，其中必須包含1個數字、1個大寫字母及1個小寫字母
		var litExp = /^.*(?=.{8,30})(?=.*\d)(?=.*[A-Z]{1,})(?=.*[a-z]{1,}).*$/;
		
		// 密碼長度需為 8-30 位，其中必須包含1個數字、1個大寫字母、1個小寫字母及1個特殊字符
	    //var litExp = /^.*(?=.{8,30})(?=.*\d)(?=.*[A-Z]{1,})(?=.*[a-z]{1,})(?=.*[!@#$%^&*?\(\)]).*$/;
		
		// 密碼長度需為 6-16 位，其中必須包含1個數字、2個大寫字母、2個小寫字母及1個特殊字符
		//var litExp = /^.*(?=.{6,16})(?=.*\d)(?=.*[A-Z]{2,})(?=.*[a-z]{2,})(?=.*[!@#$%^&*?\(\)]).*$/;
		
	    var invalid = litExp.test(INPUT);
	    return invalid;
	}
	function isEmail(EMAIL) {
	    var filter=/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
	    return filter.test(EMAIL);
	}
	function checkEMAIL(EMAIL) {
	    return isEmail(EMAIL);
	}
	function checkform(F){
	    if (F.au_password.value != "" && !check_pwd(F.au_password.value)) {
        	alert("請輸入有效的密碼(密碼長度需為 8-30 位，其中必須包含1個數字、1個大寫字母及1個小寫字母)!!");
        	F.au_password.value = "";
        	F.au_passwordagain.value = "";
        	F.au_password.focus();
        	return false;
    	} else if (F.au_password.value != F.au_passwordagain.value) {
	        alert("兩次密碼不一致!!");
        	F.au_password.value = "";
        	F.au_passwordagain.value = "";
        	F.au_passwordagain.focus();
        	return false;   
    	} else if (F.au_email.value != "" && !checkEMAIL(F.au_email.value)) {
	        alert("請輸入有效的電子信箱!!");
        	F.au_email.value = "";
        	F.au_email.focus();
        	return false;
    	} else {
	        return true;
	    }
	}
</script>
<!--密碼強度檢測 開始-->
<link rel="stylesheet" type="text/css" href="../js/password_strength/style.css" />
<script type="text/javascript" src="../js/password_strength/jquery.passwordStrength.js"></script>
<script type="text/javascript">
	$(function(){
		$('#au_password').passwordStrength();
		
	});
</script>
<!--密碼強度檢測 結束-->
<%@include file="/WEB-INF/jspf/mis/authorities.jspf"%>
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
      
      		<td width="99%" align="center" valign="top" class="system_bk-2p right_content_style" ><table width="99%" border="0" cellspacing="0" cellpadding="0">
<%-- 20250331 modify Miles top menu.jsp  改成 RWD --%>      		
      		
          		<tr>
            		<td colspan="2" class="system_bk-2b">&nbsp;</td>
          		</tr>
          		<tr>
            		<td colspan="2">&nbsp;</td>
          		</tr>
          		<tr>
            		<td width="60" align="left" valign="middle"><img src="../images/system_icon_1.gif" width="55" height="48"></td>
            		<td align="left" valign="middle" class="system_bigword">帳號權限設定</td>
          		</tr>
          		<tr>
            		<td colspan="2"><hr size="1" noshade></td>
          		</tr>
<form name="form0" method="post" action="admin_c_update.jsp" onsubmit="return checkform(this);">
  				<input type="hidden" name="node" value="<%=node%>">
  				<input type="hidden" name="npage" value="<%=pageno%>">
  				<input type="hidden" name="_qaccount" value="<%=qaccount%>">
  				<input type="hidden" name="_qname" value="<%=qname%>">
  				<input type="hidden" name="_qmfid" value="<%=qmfid%>">
  				<input type="hidden" name="au_id" value="<%=au.getString("au_id")%>">

          		<tr align="center">
            		<td colspan="2"><table width="95%"  border="0" cellspacing="1" cellpadding="0">
              			<tr>
                			<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="2" cellspacing="1">
                    			<tr align="center" class="system_title-1">
                      				<td colspan="4" class="system_title-1">帳號權限設定－修改</td>
                    			</tr>
                    			
                    			<tr align="center" class="system_table-2-1">
                      				<td colspan="4">
										<font color='red'>密碼規則：密碼長度需為 8-30 位，其中必須包含1個數字、1個大寫字母及1個小寫字母,如無須修改密碼則不用填寫</font>
									</td>
                    			</tr>
                    			
                    			<tr class="system_table-2-1">
                      				<td width="15%" align="center"><div align="right"><font color='red'>＊</font>&nbsp;帳號</div></td>
                      				<td width="35%" align="center"><div align="left"><%=au.getString("au_account")%> </div></td>
                      				<td width="15%" align="right"><font color='red'>＊</font>&nbsp;姓名</td>
                      				<td width="35%" align="left"><%=au.getString("au_name")%> </td>
                    			</tr>

                    			<tr class="system_table-2-1">
                      				<td align="center"><div align="right"><font color='red'>＊</font>&nbsp;密碼</div></td>
                      				<td align="center">
	                      				<div align="left">
	                        				<input name="au_password" id="au_password" type="password" value="<%--=au.getString("au_password")--%>" size="15" maxlength="30" placeholder="密碼長度需為 8-30 位，其中必須包含1個數字、1個大寫字母及1個小寫字母">
						  					<div id="passwordStrengthDiv" class="is0"></div>
						  				</div>
					  				</td>
                      				<td align="right"><font color='red'>＊</font>&nbsp;再次輸入密碼</td>
                      				<td align="center"><div align="left">
                        				<input name="au_passwordagain" type="password" value="<%--=au.getString("au_password")--%>" size="15" maxlength="30" placeholder="密碼長度需為 8-30 位，其中必須包含1個數字、1個大寫字母及1個小寫字母">
                      				</div></td>
                    			</tr>
                    			
                    			<tr class="system_table-2-1">
                      				<td align="right">E-MAIL</td>
                      				<td colspan="3" align="left"><input name="au_email" type="text" size="40" maxlength="50" value="<%=au.getString("au_email")%>"></td>
                    			</tr>
                    			
                    			<tr class="system_table-2-1">
                      				<td align="right">權限設定</td>
                      				<td colspan="3" align="left"><input type="button" name="openall" value="全部開啟"  onClick="selectall(this.form,'0');">
					  				&nbsp;<input name="close" type="button"  value="全部關閉" onClick="selectall(this.form,'1');"></td>
                    			</tr>
                    
                    			<tr class="system_table-2-1">
                      				<td align="center">&nbsp;</td>
                      				<td colspan="3" align="left" class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
										<%
										// First level functions.
	   									for (int i = 0; i < app_tmfs.size(); i++) {
	       									TableRecord tmf = (TableRecord)app_tmfs.get(i);
										%>
	                        			<tr class="system_table-2-1">
	                          				<td width="20" align="left" class="system_table-2-1"><input type="checkbox" name="<%=tmf.getString("mf_id")%>" value="1" <%=(StringTool.indexOf(tmf.getString("mf_id"), mfids)>=0)?"checked":""%> onclick="change<%=tmf.getString("mf_id")%>(this.form);"></td>
	                          				<td colspan="3" align="left" class="system_table-2-1"><%=tmf.getString("mf_name")%></td>
	                        			</tr>
										<%
											// Second level functions.
	   										Vector mfs2 = app_sm.selectAll("mis_function", "mf_status='N' and mf_upfunction=? and mf_type='2'", new Object[] { tmf.getValue("mf_id") }, "mf_priority");
	   										for (int j = 0; j < mfs2.size(); j++) {
	       										TableRecord mf2 = (TableRecord)mfs2.get(j);
										%>
	                        			<tr class="system_table-2-1">
	                          				<td align="left" class="system_table-2-1">&nbsp;</td>
	                          				<td width="20" align="left" class="system_table-2-1"><input type="checkbox" name="<%=mf2.getString("mf_id")%>" value="2" <%=(StringTool.indexOf(mf2.getString("mf_id"), mfids)>=0)?"checked":""%> onclick="change<%=mf2.getString("mf_id")%>(this.form);"></td>
	                          				<td colspan="2" align="left" class="system_table-2-1"><%=mf2.getString("mf_name")%></td>
	                        			</tr>
										<%
												// Third level functions.
	   											Vector mfs3 = app_sm.selectAll("mis_function", "mf_status='N' and mf_upfunction=? and mf_type='3'", new Object[] { mf2.getValue("mf_id") }, "mf_priority");
	   											for (int k = 0; k < mfs3.size(); k++) {
	       											TableRecord mf3 = (TableRecord)mfs3.get(k);
										%>
	                        			<tr class="system_table-2-1">
	                          				<td align="left" class="system_table-2-1">&nbsp;</td>
	                          				<td align="left" class="system_table-2-1">&nbsp;</td>
	                          				<td width="20" align="left" class="system_table-2-1"><input type="checkbox" name="<%=mf3.getString("mf_id")%>" value="3" <%=(StringTool.indexOf(mf3.getString("mf_id"), mfids)>=0)?"checked":""%> onclick="change<%=mf3.getString("mf_id")%>(this.form);"></td>
	                          				<td align="left" class="system_table-2-1"><%=mf3.getString("mf_name")%></td>
	                        			</tr>
	                        			<%
	                        					}
	   										}
	   									}
	   									%>
                      				</table></td>
                    			</tr>
                    			<tr class="system_table-2-1">
	                      			<td align="center"><div align="right">最後修改人員</div></td>
                      				<td align="center"><div align="left"><%=au.getString("au_modifyuser")%></div></td>
                      				<td align="right">最後修改日期</td><td align="left"><%=au.getString("au_modifydate")%></td>
                    			</tr>
                			</table></td>
              			</tr>
            		</table>            
            		<br />
            		<input name="update" type="submit"   value="確定送出">&nbsp;&nbsp;&nbsp;&nbsp;
            		<input name="reset" type="reset"   value="重新填寫">&nbsp;&nbsp;
            		<input name="cancel" type="button"  value="放棄修改" onclick="lastpage.submit();">
            		</td>
          		</tr>
</form>
          		<tr>
		            <td colspan="2"><div align="center">
	            		<br />
					</div></td>
          		</tr>
          		<tr>
	            	<td colspan="2" class="system_bk-2b">&nbsp;</td>
          		</tr>
        	</table>
        	<p>&nbsp;</p>
      		</td>
    	</tr>
	</table>
</div>
</div>

<form name="lastpage" method="post" action="admin_b_1.jsp">
  	<input type="hidden" name="node" value="<%=node%>">
  	<input type="hidden" name="npage" value="<%=pageno%>">
  	<input type="hidden" name="_qaccount" value="<%=qaccount%>">
  	<input type="hidden" name="_qname" value="<%=qname%>">
  	<input type="hidden" name="_qmfid" value="<%=qmfid%>">
</form>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>