<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%
	// 檢查是否為登入狀態
	TableRecord app_user = (TableRecord)session.getAttribute("app_user");
	if (!(app_user == null)) {
	   // Login account.
	   String app_account = app_user.getString("au_account");

	   //thislogin.setInsert(app_account);
	   TableRecord thislogin = (TableRecord)session.getAttribute("thislogin");
	   if (thislogin != null) {
	       thislogin.setValue("al_id", IDTool.getUID("AL"));
	       thislogin.setValue("al_createuser", app_account);
	       thislogin.setValue("al_modifyuser", app_account);
	       thislogin.setValue("al_createdate", DateTimeTool.dateTimeString());
	       thislogin.setValue("al_modifydate", DateTimeTool.dateTimeString());
	       thislogin.setValue("al_logtype", "0");
	       thislogin.setValue("al_logdate", DateTimeTool.dateTimeString());
	       thislogin.setValue("al_remoteip", request.getRemoteAddr());
	       app_sm.insert(thislogin);
	   }
	   session.invalidate();
	}
%>
<html>
<head><title><%=app_mistitle%></title></head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="Robots" content="none"> 
<Script language="Javascript">
<!--
function logout()
{
<%
   if (request.getParameter("st") != null) {
%>
    alert("尚未登入！");
    window.location = "index.jsp";
<%
   } else {
%>
    alert("登出成功！");
    window.location = "index.jsp";
<% } %>
}
-->
</Script>
<body onLoad="logout()">
</body>
</html>
