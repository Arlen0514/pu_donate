<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.genesis.config.AppConfig"%>
<%@page import="com.genesis.util.StringTool"%>
<%@page import="com.jspsmart.upload.SmartUpload"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.net.URLEncoder"%>
<%
   	// Usage: download.jsp?file=
    String fileName = StringTool.validString(request.getParameter("file"));
    String downloadfile = request.getRealPath("/uploads/export") + "/"+fileName;

    boolean isCsv = fileName.toLowerCase().endsWith(".csv");
    if(isCsv){
        File file = new File(downloadfile);
        response.reset();
        response.setCharacterEncoding("Big5");
        response.setContentType("text/csv; charset=Big5");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"; filename*=Big5''" + URLEncoder.encode(fileName, "Big5"));
        response.setContentLengthLong(file.length());

        FileInputStream fis = new FileInputStream(file);
        byte[] buffer = new byte[4096];
        int len = 0;
        while((len = fis.read(buffer)) != -1){
            response.getOutputStream().write(buffer, 0, len);
        }
        response.getOutputStream().flush();
        fis.close();
    }else{
        SmartUpload su = new SmartUpload();
        su.initialize(pageContext);
        su.setContentDisposition(null);
        su.downloadFile(downloadfile);
    }

   	//解決 getOutputStream() has already been called for this response
   	out.clear(); 
   	out = pageContext.pushBody();
%>
<%if(!isCsv){ %>
<script> self.close(); </script>
<%} %>
