<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="/WEB-INF/jspf/sha256.jspf"%>
<%
	String au_password = sha256(StringTool.validString(request.getParameter("au_password")));

   	app_user.setValue("au_password", au_password);
   	app_user.setValue("au_modifyuser", app_user.getValue("au_account"));
   	app_user.setValue("au_modifydate", DateTimeTool.dateString());
   	app_sm.update(app_user, new String[] { "au_id" });
   	session.invalidate();

	if(app_sm.success()) {
		out.println("<script> alert('密碼修改成功!!請重新登入!!'); location='../index.jsp'; </script>");
   	} else {
		out.println("<script> alert('密碼修改失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
   	}
%>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>