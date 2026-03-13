<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@page import="java.net.URLEncoder"%>
<%
	//MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
	MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request,null,100*1024*1024,MultipartFormDataRequest.COSPARSER,"UTF-8");
	String uploadpath = mrequest.getParameter("path"); 					//上傳路徑
			
	String type = mrequest.getParameter("type");  						//上傳檔案型態
	String fulluploadpath = request.getRealPath(uploadpath);  			//實體路徑
	
	//action 是上傳的話就上傳 不然就建立資料夾
	if(((String)mrequest.getParameter("action")).equals("upload")){
%>
<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean">
	<jsp:setProperty name="upBean" property="folderstore" value="<%=fulluploadpath %>" />
	<jsp:setProperty name="upBean" property="overwrite" value="true" />
</jsp:useBean>
<%
		//處理上傳檔案
	    Hashtable files = mrequest.getFiles();
	    if (files != null && !files.isEmpty()) {
	        UploadFile file = (UploadFile) files.get("image");
	        String fileName = file.getFileName(); 						// 原本檔名

	        upBean.store(mrequest, "image");
		    response.sendRedirect("lister.jsp?path="+URLEncoder.encode(uploadpath,"UTF-8")+"&type="+type+"&filename="+URLEncoder.encode(fileName,"UTF-8"));
		}
	}

	//建立資料夾
	else if(((String)mrequest.getParameter("action")).equals("create")){
		String folder = URLEncoder.encode(mrequest.getParameter("folder"),"UTF-8");
	    File newFolder = new File(fulluploadpath+"/"+mrequest.getParameter("folder"));
	    newFolder.mkdir();
	    response.sendRedirect("lister.jsp?path="+ URLEncoder.encode( uploadpath+"/"+folder,"UTF-8")  );
	}
%>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>