<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 基本參數
	String code = "banner"; 						// 模組識別碼
	String show_title = "首頁輪播維護";				// 模組標題

	// 設定圖檔上傳 MB 數
	Integer fSize = 2;

	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));;
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"), DateTimeTool.getYear() - 1 + DateTimeTool.dateString().substring(4));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"), DateTimeTool.getYear() + 1 + DateTimeTool.dateString().substring(4));

	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle", "_qemitdate", "_qrestdate" };
	String[] values = new String[] { String.valueOf(pageno), qtitle, qemitdate, qrestdate };	
%>
<%
try {
	// A:新增,M:修改,D:刪除,S:排序
	String action = StringTool.validString(request.getParameter("action"));
	// 修改資料id
	String ap_id = StringTool.validString(request.getParameter("ap_id"));

	// 刪除
	if("D".equals(action)) {
		TableRecord ap = app_sm.select(tblap, ap_id);
		//FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+ap.getString("ap_image"));
		//FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+ap.getString("ap_mobile"));
		app_sm.delete(ap);

		// 確認是否有其它資料顯示相同圖片(有其它檔案欄位再新增code)
		if(app_sm.success()) {
			if(app_sm.selectAll(tblap, "ap_image=?", new Object[]{ ap.getString("ap_image") }).size() == 0) {
				FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+ap.getString("ap_image"));
			}
			if(app_sm.selectAll(tblap, "ap_mobile=?", new Object[]{ ap.getString("ap_mobile") }).size() == 0) {
				FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+ap.getString("ap_mobile"));
			}
			// 回列表頁
			out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
			out.println("<script> alert('刪除成功!!'); listpage.submit(); </script>");
		} else {
			out.println("<script> alert('刪除失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;
	}

	// 檔案路徑與設置
	String dir = application.getRealPath("/") + "uploads/"+code+"/"+lang+"/";
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

	// 排序
	if("S".equals(action)) {
		String chk_ap = "";
		while(i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			// 這是用來確定是否為文件屬性
			if(fi.isFormField()) {
				String fieldName = new String(fi.getFieldName()); 			// 取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); 		// 取得值
				if("selData".equals(fieldName)) {
					chk_ap = fieldvalue.trim();
				}
			}
		}
		String list[] = chk_ap.split(",");
		for(int j = 0; j < list.length; j++) {
			if(!"".equals(list[j].trim())) {
				TableRecord ap = app_sm.select(tblap, "ap_id=?", new Object[]{ list[j] });
				ap.setValue("ap_showseq", j);
				ap.setUpdate(app_account);
				app_sm.update(ap);
			}
		}

		if(app_sm.success()) {
			// 回排序頁
			out.write(HtmlCoder.getForm("sortpage", code + "_sort.jsp", names, values));
			out.println("<script> alert('排序完成!!');sortpage.submit(); </script>");
		} else {
			out.println("<script> alert('排序失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;
	}
	
	// 新增
	if("A".equals(action)) {		
		TableRecord ap = new TableRecord(tblap);
		ap.setInsert(app_account);

		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			// 這是用來確定是否為文件屬性 
			if(fi.isFormField()) { 
				String fieldName = new String(fi.getFieldName()); 		// 取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); 	// 取得值
				//System.out.println("fieldName = " + fieldName + ", fieldvalue = " + fieldvalue);		// Debug用
				
				if(fieldName.equals("ap_title")) {
					Vector checks = app_sm.selectAll(tblap, "ap_title=? and ap_code=?", new Object[]{ fieldvalue, code });
					if(checks.size() > 0) {
						out.println("<script> alert('標題重複!!'); history.back(); </script>");
						return;
					}
				}
				ap.setValue(fieldName, fieldvalue.trim());				// 設定欄位值

			// 處理文件
			} else { 
				int g = fi.getName().lastIndexOf("\\");
				String fileName = fi.getName();
				String fileName_1 = "";
				if(g < 0) {
	                fileName = fi.getName();							// 兼容非ie
	                fileName_1 = fi.getName();
	            } else {
	                fileName = fi.getName().substring(g);				// 取得上傳文件名
	                fileName_1 = fileName.substring(1,fileName.length());
	            }
				//fileName_1 = ap.getString("ap_id")+"_"+fileName_1;

				if(fileName != null && !"".equals(fileName)) {
					String chk_str = fileName;
					/*
					if(chk_str.getBytes().length != new String(chk_str).length()) {
						out.println("<script> alert('上傳檔名不可為中文'); history.back(); </script>");
						return;
					}
					*/
					if((fSize * 1024 * 1024) < fi.getSize()) {
						out.println("<script> alert('上傳檔案不可超過"+String.valueOf(fSize)+"MB'); history.back(); </script>");
						return;
					}
					fi.write(new File(dir, fileName_1 ));
					ap.setValue(fi.getFieldName(), fileName_1);			// 設定圖
				}
			}
		}
		ap.setValue("ap_code", code);	// 識別碼
		ap.setValue("ap_lang", lang);	// 語系		
		app_sm.insert(ap);

		if(app_sm.success()) {
			// 回列表頁
			out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
			out.println("<script> alert('新增成功!!');listpage.submit(); </script>");
		} else {
			out.println("<script> alert('新增失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;

	// 修改
	} else if("M".equals(action)) {
		TableRecord ap = app_sm.select(tblap, "ap_id=?",new Object[] { ap_id });
		ap.setUpdate(app_account);
		while(i.hasNext()) {
			FileItem fi = (FileItem) i.next();

			// 這是用來確定是否為文件屬性
			if(fi.isFormField()) {  
				String fieldName = new String(fi.getFieldName()); 		// 取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); 	// 取得值
				//System.out.println("fieldName = " + fieldName + ", fieldvalue = " + fieldvalue);		// Debug用
				
				if(fieldName.equals("ap_title")) {
					Vector checks = app_sm.selectAll(tblap, "ap_title=? and ap_id !=? and ap_code=?", new Object[]{ fieldvalue, ap_id, code });
					if(checks.size() > 0) {
						out.println("<script> alert('標題重複!!'); history.back(); </script>");
						return;
					}
				}
				//System.out.println("欄位名:" + fieldName + "---" + "欄位值:" + fieldvalue );
				if((!fieldName.startsWith("imgradio")) && (!fieldName.startsWith("imgradio_mobile"))) {
					if("qtitle".equals(fieldName)) {
						values[1] = fieldvalue.trim();					// 解決查詢標題為中文時傳值的問題
					} else {
						ap.setValue(fieldName, fieldvalue.trim());		// 設定欄位值
					}
				}

			// 處理文件(file)
			} else { 
				int g = fi.getName().lastIndexOf("\\");
				String fileName = fi.getName();
				String fileName_1 = "";
				if(g < 0) {
	                fileName = fi.getName();							// 兼容非ie
	                fileName_1 = fi.getName();
	            } else {
	                fileName = fi.getName().substring(g);				// 取得上傳文件名
	                fileName_1 = fileName.substring(1,fileName.length());
	            }
				//fileName_1 = ap.getString("ap_id")+"_"+fileName_1;
				
				if(fileName != null && !"".equals(fileName)) {
					String chk_str = fileName;
					/*
					if(chk_str.getBytes().length != new String(chk_str).length()) {
						out.println("<script> alert('上傳檔名不可為中文'); history.back(); </script>");
						return;
					}
					*/
					if((fSize * 1024 * 1024) < fi.getSize()) {
						out.println("<script> alert('上傳檔案不可超過"+String.valueOf(fSize)+"MB'); history.back(); </script>");
						return;
					}
					// Delete 原來的 image file.
					if(!"".equals(ap.getString(fi.getFieldName()))) {
						// 確認其它資料沒有使用相同檔案
						if(app_sm.selectAll(tblap, fi.getFieldName()+"=?", new Object[] {ap.getString(fi.getFieldName()) }).size() == 1) {
							FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+ap.getString(fi.getFieldName()));
						}
					}

					fi.write(new File(dir, fileName_1 ));
					ap.setValue(fi.getFieldName(), fileName_1);			// 設定圖
				}
			}
		}		
		app_sm.update(ap);

		if(app_sm.success()) {
			// 回列表頁
			out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
		    out.println("<script> alert('修改成功!!'); listpage.submit(); </script>");
		} else {
			out.println("<script> alert('修改失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;
	}
} catch(Exception e) {
	System.out.println("Project:" + projectName + ", Error info:["+e+"]File name edit.jsp for ["+code+"]Time:["+DateTimeTool.dateTimeString()+"]");
	out.println("<script> alert('處理失敗'); history.back(); </script>");
} finally {
	app_sm.close();
}
%>