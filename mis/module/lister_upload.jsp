<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<%@ page import="java.util.List" %>
<%@page import="java.net.URLEncoder"%>
<%
Integer fSize = 3; // 設定圖檔上傳 MB 數
String path = StringTool.validString(request.getParameter("path"));
try{
	String code = StringTool.validString(request.getParameter("code"));		//A:新增,M:修改,D:刪除,S:排序

	//---//
	//檔案路徑與設置
	String dir = application.getRealPath("/") +path;
	DiskFileUpload fu = new DiskFileUpload();
	fu.setHeaderEncoding("UTF-8");//亂碼關鍵(1)
	fu.setSizeMax(1024*1024*10); //設置文件大小
	fu.setSizeThreshold(4*1024); //設置緩衝大小
	fu.setRepositoryPath(application.getRealPath("/") + "uploads/temp");  //設置臨時目錄
	fu.setRepositoryPath(dir); //設置臨時目錄     
	List fileItems = fu.parseRequest(request);
	Iterator i = fileItems.iterator();
	//---//
	//--------------------------------------------------------------//

	//---//
 	if("A".equals(code)){//新增
		int count_file=0;//計算處理多少個相片檔案(批次)
		
		//---------------------檔案上傳-----------------------------------------------
		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			if (!fi.isFormField()){  //處理文件
				count_file++; // 計算處理多少個檔案(批次)
				int g = fi.getName().lastIndexOf("\\");
				String fileName = fi.getName();
				String fileName_1 = "";
				if(g<0){
	                fileName = fi.getName();//兼容非ie
	                fileName_1 = fi.getName();
	            }
	            else{
	                fileName = fi.getName().substring(g);//取得上傳文件名
	                fileName_1 = fileName.substring(1,fileName.length());
	            }
				
		        // 確認副檔名 藥可以通過才能上傳
		        if(inValidFileExtension(fileName_1)) {
		        	out.println("<script> alert('上傳副檔名不正當!!');  history.back(); </script>");
		        	return;
		        }
				
				if((fSize * 1024 * 1024) < fi.getSize() ){
					out.println("<script> alert('上傳檔案不可超過"+String.valueOf(fSize)+"MB'); history.back(); </script>");return;
				}
				
				
				if (fileName != null && !"".equals(fileName)) {
					String chk_str = fileName;
					fi.write(new File(dir, fileName_1 ));
				}
				
			}
		}
		response.sendRedirect("lister.jsp?path="+ URLEncoder.encode(path,"UTF-8"));
	}
}catch(Exception e){
	System.out.println("Project:" + projectName + ", Error info:["+e+"]File name edit.jsp for [test]Time:["+DateTimeTool.dateTimeString()+"]");
	out.println("<script> alert('處理失敗'); history.back(); </script>");
}finally{app_sm.close();}
%>