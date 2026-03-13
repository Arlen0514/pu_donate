<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.genesis.config.AppConfig"%>
<%@page import="com.genesis.util.StringTool"%>
<%@page import="com.jspsmart.upload.SmartUpload"%>
<%
   	// Usage: download.jsp?file=
   	// Initiate object.
   	SmartUpload su = new SmartUpload();
   	// Download file name.
   	String fileName = StringTool.validString(request.getParameter("file"));
   	// Whole path of download file.
   	String downloadfile = request.getRealPath("/uploads/export") + "/"+fileName; 
	//System.out.println(downloadfile);
   	// Initialize.
   	su.initialize(pageContext);
   	// Download file.
   	su.setContentDisposition(null);   
   	su.downloadFile(downloadfile);

   	//解決 getOutputStream() has already been called for this response
   	out.clear(); 
   	out = pageContext.pushBody();
%>
<script> self.close(); </script>