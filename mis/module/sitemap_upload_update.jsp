<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 基本參數
	String code = "sitemap_upload"; 			// 模組識別碼
	String upload_code = "sitemap_upload"; 		// 上傳資料夾識別碼
	String show_title = "Sitemap上傳"; 			// 模組標題

	// 設定檔案上傳 MB 數
	Integer fSize = 2;

	try {
		// 檔案路徑與設置
		String dir = application.getRealPath("/");
		File f_dir = new File(dir);
		if(!f_dir.exists()) {
			f_dir.mkdirs();
		}
		DiskFileUpload fu = new DiskFileUpload();
		fu.setHeaderEncoding("UTF-8");											// 亂碼關鍵(1)
		//fu.setSizeMax(4194304); 												// 設置文件大小
		//fu.setSizeThreshold(4096); 											// 設置緩衝大小
		//fu.setRepositoryPath(application.getRealPath("/") + "uploads/temp");  // 設置臨時目錄
		fu.setRepositoryPath(dir); 												// 設置臨時目錄     
		List fileItems = fu.parseRequest(request);
		Iterator i = fileItems.iterator();

		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();

			if(!fi.isFormField()) {
				String fileName = fi.getName();

				if(fileName != null && !"".equals(fileName)) {
			        if(inValidFileExtension(fileName)) {
			        	out.println("<script> alert('上傳副檔名不正當!!');  history.back(); </script>");
			        	return;
			        }
					if(!fileName.contains(".xml")) {
						out.println("<script> alert('檔案必須為xml格式 !!'); history.back(); </script>");
						return;
					}
					if((fSize * 1024 * 1024) < fi.getSize()) {
						out.println("<script> alert('上傳檔案不可超過"+String.valueOf(fSize)+"MB'); history.back(); </script>");
						return;
					}
					fi.write(new File(dir, "sitemap.xml"));
				}
			}
		}

		out.println("<script> alert('上傳成功!!'); location='sitemap_upload.jsp'; </script>");

	} catch(Exception e) {
		System.out.println("Project:" + projectName + ", Error info:" + e + ", File name:sitemap_upload.jsp, Time:" + DateTimeTool.dateTimeString());
		out.println("<script> alert('上傳失敗'); history.back(); </script>");
	} finally {
		app_sm.close();
	}
%>