<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	// Tiltes.
	String[] titles = new String[] { 
		"郵件伺服器名稱", "郵件伺服器埠號", "認證狀態","SSL使用狀態",
		"認證帳號", "認證密碼", "管理者名稱", "管理者信箱"
	};
	
	// Keywords.
	String[] keywords = new String[] {
		"smtp.host.name", "smtp.auth.port", "smtp.auth.status", "smtp.ssluse.status",
		"smtp.auth.account", "smtp.auth.password", "service.email.name", "service.email.address"
	};

	// Get records.
   	Vector smtps = new Vector();
   	for (int i = 0; i < titles.length; i++) {
       	TableRecord ss = SiteSetup.getSetup(keywords[i]);
       	ss.setUpdate(app_account);
       	String value = StringTool.validString(request.getParameter(keywords[i]));
       	ss.setValue("ss_value", value);
       	ss.setUpdate(app_account);
       	app_sm.update(ss);
   	}
   	if (app_sm.success()) {
       	out.println("<script> alert('資料修改成功!!'); location='smtp_c.jsp'; </script>");
   	} else {
		out.println("<script> alert('修改失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
   	}
%>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>