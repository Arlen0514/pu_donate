<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 上層基本參數
	String ap_category = StringTool.validString(request.getParameter("ap_category")); 	// 所屬上層相簿代號
	String back_code = "photo"; 														// 上層模組識別碼
	TableRecord apCode= app_sm.select(tblap,ap_category); 								// 所屬相簿資料
	
	// 基本參數
	String code = "photo_in"; 															// 模組識別碼
	String show_title = apCode.getString("ap_title")+"-相片";	 						// 模組標題

	// 設定圖檔上傳 MB 數
	Integer fSize = 1;	

	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));
 
	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle", "ap_category"};
	String[] values = new String[] { String.valueOf(pageno), qtitle, ap_category};	
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

		//確認是否有其它資料顯示相同圖片(有其它檔案欄位再新增code)
		if(app_sm.success()) {
			if(app_sm.selectAll(tblap, "ap_category=? and ap_code=? and ap_lang=? and ap_image=?", new Object[] {ap_category, code, lang, ap.getString("ap_image")}).size() == 0) {
				FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+ap_category+"/"+ap.getString("ap_image"));
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
	String dir = application.getRealPath("/") + "uploads/"+code+"/"+lang+"/"+ap_category;
	//建立 相簿資料夾(相片歸類)
	File f_dir = new File(dir);
	if(!f_dir.exists()){
		f_dir.mkdirs();
	}
	f_dir.mkdir();
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
		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			if (fi.isFormField()){											//這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); 			//取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); 		//取得值
				if("selData".equals(fieldName)){chk_ap = fieldvalue.trim();}
			}
		}
		String list[] = chk_ap.split(",");
		for(int j=0;j<list.length;j++){
			if(!"".equals(list[j].trim())){
				TableRecord ap = app_sm.select(tblap, "ap_id=?",new Object[] { list[j] });
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
		String ap_title = "";		// 相片名稱(圖片註解)(處理檔案時再加順序編號)
		int count_file = 0;			// 計算處理多少個相片檔案(批次)
		//ap.setInsert(app_account);
		//---------------------檔案上傳-----------------------------------------------
		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			if (fi.isFormField()){ //這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); //取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); //取得值
				//System.out.println("fieldName = " + fieldName + ", fieldvalue = " + fieldvalue);		// Debug用
				
				if(fieldName.equals("ap_title")){
					Vector checks = app_sm.selectAll(tblap,"ap_title =? and ap_category=? and ap_code=? and ap_lang=?",new Object[]{fieldvalue, ap_category, code, lang});
					if(checks.size()>0){
						out.println("<script> alert('標題重複!!'); history.back(); </script>");
						return;
					}else{
						ap_title=fieldvalue.trim();
						ap.setValue(fieldName, fieldvalue.trim());//設定欄位值
					}
				} else {
					ap.setValue(fieldName, fieldvalue.trim());//設定欄位值
				}
				
			} else { //處理文件
				// 目前有多少張相片
				Vector<TableRecord> pts = app_sm.selectAll(tblap, "ap_code=? and ap_lang=? and ap_category=?", new Object[]{ "photo_in", lang, ap_category });
				count_file++; // 計算處理多少個檔案(批次)
				int g = fi.getName().lastIndexOf("\\");
				String fileName = fi.getName();
				String fileName_1 = "";
				if(g<0){
	                fileName = fi.getName();//兼容非ie
	                fileName_1 = fi.getName();
	            }else{
	                fileName = fi.getName().substring(g);//取得上傳文件名
	                fileName_1 = fileName.substring(1,fileName.length());
	            }
				//fileName_1 = ap.getString("ap_id")+"_"+fileName_1;
				
				if (fileName != null && !"".equals(fileName)) {
					String chk_str = fileName;
					String imgName = "";
					/*
					if(chk_str.getBytes().length != new String(chk_str).length()){
						out.println("<script> alert('上傳檔名不可為中文'); history.back(); </script>");
						return;
					}
					*/
			        if(inValidFileExtension(fileName)) {
			        	out.println("<script> alert('上傳副檔名不正當!!');  history.back(); </script>");
			        	return;
			        }
					if((fSize * 1024 * 1024) < fi.getSize()) {
						out.println("<script> alert('上傳檔案不可超過"+String.valueOf(fSize)+"MB'); history.back(); </script>");
						return;
					}
					fi.write(new File(dir, fileName_1 ));
					// 批次上傳圖檔 最後的欄位屬性一定為file 所以直接將每筆檔名當作一筆資料加入資料庫
					String photoID = IDTool.getUID("photo_in", DateTimeTool.dateString(""), 3);
					if(ap_title.isEmpty()) {
						imgName = "相片 - " + photoID;
					} else {
						imgName += ap_title + " - " + photoID;
					}
					ap.setInsert(app_account);
					ap.setValue(fi.getFieldName(), fileName_1);		// 設定圖
					// 共用屬性(圖片標題)隨著每筆檔案順序編號
					/*
					if(count_file > 1) 
						ap.setValue("ap_title", ap_title+(count_file-1));   							
					else 
						ap.setValue("ap_title", ap_title);
					*/
					ap.setValue("ap_title", imgName);
					ap.setValue("ap_category", ap_category);		// 所屬相簿
					ap.setValue("ap_showseq", pts.size());			// 排序
					ap.setValue("ap_code", code);					// 識別碼
					ap.setValue("ap_lang", lang);					// 語系
					app_sm.insert(ap);
				}
			}
		}
		/*
		ap.setValue("ap_code", code);	// 識別碼
		ap.setValue("ap_lang", lang);	// 語系		
		app_sm.insert(ap);
		*/

		if(app_sm.success()) {
			// 回列表頁
			out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
			out.println("<script> alert('新增成功!!');listpage.submit(); </script>");
		} else {
			out.println("<script> alert('新增失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;

	// 單筆新增
	} else if("A1".equals(action)) {
		TableRecord ap = new TableRecord(tblap);
		ap.setInsert(app_account);
		//---------------------檔案上傳-----------------------------------------------
		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			if (fi.isFormField()){ //這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); //取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); //取得值
				//System.out.println("fieldName = " + fieldName + ", fieldvalue = " + fieldvalue);		// Debug用
				
				if(fieldName.equals("ap_title")){
					Vector checks = app_sm.selectAll(tblap,"ap_title =? and "+"ap_code=? and "+"ap_lang=?",new Object[]{fieldvalue, code, lang});
					if(checks.size()>0){
						out.println("<script> alert('標題重複!!'); history.back(); </script>");
						return;
					}
				}
				ap.setValue(fieldName, fieldvalue.trim());//設定欄位值
				
			} else { //處理文件
				int g = fi.getName().lastIndexOf("\\");
				String fileName = fi.getName();
				String fileName_1 = "";
				if(g<0){
	                fileName = fi.getName();//兼容非ie
	                fileName_1 = fi.getName();
	            }else{
	                fileName = fi.getName().substring(g);//取得上傳文件名
	                fileName_1 = fileName.substring(1,fileName.length());
	            }
				//fileName_1 = ap.getString("ap_id")+"_"+fileName_1;
				
				if (fileName != null && !"".equals(fileName)) {
					String chk_str = fileName;
					/*
					if(chk_str.getBytes().length != new String(chk_str).length()){
						out.println("<script> alert('上傳檔名不可為中文'); history.back(); </script>");
						return;
					}
					*/
			        if(inValidFileExtension(fileName)) {
			        	out.println("<script> alert('上傳副檔名不正當!!');  history.back(); </script>");
			        	return;
			        }
					if((fSize * 1024 * 1024) < fi.getSize()) {
						out.println("<script> alert('上傳檔案不可超過"+String.valueOf(fSize)+"MB'); history.back(); </script>");
						return;
					}
					fi.write(new File(dir, fileName_1 ));
					ap.setValue(fi.getFieldName(), fileName_1);//設定圖
				}
			}
		}
		ap.setValue("ap_category", ap_category);		// 所屬產品
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
		while (i.hasNext()) {

			FileItem fi = (FileItem) i.next();
			if (fi.isFormField()){ //這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); //取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); //取得值
			
				if(fieldName.equals("ap_title")){
					Vector checks = app_sm.selectAll(tblap,"ap_title =? and ap_id !=? and ap_category=? and ap_code=? and ap_lang=?",new Object[]{fieldvalue, ap_id, ap_category, code, lang});
					if(checks.size()>0){
						out.println("<script> alert('標題重複!!'); history.back(); </script>");
						return;
					}else{
						ap.setValue(fieldName, fieldvalue.trim());//設定欄位值
					}
			
			    }else if(!fieldName.startsWith("imgradio")){
			    	if("_qtitle".equals(fieldName)){ //解決查詢標題為中文時傳值的問題
						values[1] = fieldvalue.trim();
					}else{
						ap.setValue(fieldName, fieldvalue.trim());//設定欄位值
					}
			    }
			} else { //處理文件(file)
				int g = fi.getName().lastIndexOf("\\");
				String fileName = fi.getName();
				String fileName_1 = "";
				if(g<0){
	                fileName = fi.getName();//兼容非ie
	                fileName_1 = fi.getName();
	            }
	            else{
	                fileName = fi.getName().substring(g);					//取得上傳文件名
	                fileName_1 = fileName.substring(1,fileName.length());
	            }
				//fileName_1 = ap.getString("ap_id")+"_"+fileName_1;
				
				if (fileName != null && !"".equals(fileName)) {
					String chk_str = fileName;
					/*
					if(chk_str.getBytes().length != new String(chk_str).length()){
						out.println("<script> alert('上傳檔名不可為中文'); history.back(); </script>");
						return;
					}
					*/
			        if(inValidFileExtension(fileName)) {
			        	out.println("<script> alert('上傳副檔名不正當!!');  history.back(); </script>");
			        	return;
			        }
					if((fSize * 1024 * 1024) < fi.getSize()) {
						out.println("<script> alert('上傳檔案不可超過"+String.valueOf(fSize)+"MB'); history.back(); </script>");
						return;
					}
					// Delete 原來的 image file.
					if(!"".equals(ap.getString(fi.getFieldName()))) {
						//確認其它資料沒有使用相同檔案
						if(app_sm.selectAll(tblap, "ap_category=? and ap_code=? and ap_lang=? and "+fi.getFieldName()+"=?", new Object[] {ap_category, code, lang, ap.getString(fi.getFieldName()) }).size() == 1) {
							FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+ap_category+"/"+ap.getString(fi.getFieldName()));
						}
					}
					
					fi.write(new File(dir, fileName_1 ));
					ap.setValue(fi.getFieldName(), fileName_1);//設定圖
				}
			}
		}		
		app_sm.update(ap);

		if(app_sm.success()) {
			// 回列表頁
			out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
		    out.println("<script> alert('修改成功!!');listpage.submit(); </script>");
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