<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%	String code	= "admin_b";				// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@include file="include/head.jsp"%>
<script language="JavaScript" type="text/JavaScript">
	/*-- --*/
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
            <td align="left" valign="middle" class="system_bigword">帳號權限設定</td>
          </tr>
          <tr>
            <td colspan="2"><hr size="1" noshade></td>
          </tr>
<form name="form0" method="post" action="admin_b_1.jsp">
  <input type="hidden" name="node" value="<%=node%>">
          <tr align="center">
            <td colspan="2"><table width="95%"  border="0" cellspacing="1" cellpadding="0">
                <tr>
                  <td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="2" cellspacing="1">
                      <tr align="center" class="system_title-1">
                        <td colspan="2" class="system_title-1">帳號權限設定－查詢</td>
                      </tr>
                      <tr class="system_table-2-1">
                        <td width="39%" align="right">帳號</td>
                        <td width="61%" >
                          <div align="left">
                            <input name="_qaccount" type="text" value="" maxlength="15">
                          </div></td>
                      </tr>
                      <tr class="system_table-2-1">
                        <td align="right">姓名</td>
                        <td align="center"><div align="left">
                          <input name="_qname" type="text" value="" maxlength="15">
                        </div></td>
                      </tr>
                      <tr class="system_table-2-1">
                        <td align="right">權限設定</td>
                        <td align="center"><div align="left">
                          <select name="_qmfid">
                            <option value="" selected>請選擇</option>
<%
   for(int i = 0; i < app_tmfs.size(); i++) {
       TableRecord mf = (TableRecord)app_tmfs.get(i);
%>
                            <option value="<%=mf.getString("mf_id")%>"><%=mf.getString("mf_name")%></option>
<% } %>
                          </select>
                        </div></td>
                      </tr>
                  </table></td>
                </tr>
            </table>
            <br>
            <input name="query" type="submit"  value="確定查詢">&nbsp;
            <input name="reset" type="reset" value="重新設定" ></td>
          </tr>
</form>
          <tr>
            <td colspan="2"><div align="center">
              <br>
</div></td>
          </tr>
          <tr>
            <td colspan="2" class="system_bk-2b">&nbsp;</td>
          </tr>
        </table>
        <!-- InstanceEndEditable --></td>
    </tr>
  </table>
</div>
</div>
</body>
<!-- InstanceEnd --></html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>
