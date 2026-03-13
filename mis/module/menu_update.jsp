<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<%@ page import="java.util.List" %>
<%
String code = StringTool.validString(request.getParameter("code"));	// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
Integer fSize = 1; 													// 設定圖檔上傳 MB 數

try {
	String action = StringTool.validString(request.getParameter("action"));		// A:新增,M:修改
	String mf_id = StringTool.validString(request.getParameter("mf_id"));
	
		if("D".equals(action)) { // D: 刪除
			// Get record.
			TableRecord mf = app_sm.select(tblmf, mf_id);
			//讀取下一層選單項目及刪除
			Vector mfs_1 = app_sm.selectAll(tblmf, "mf_upfunction=?", new String[]{mf_id});
			for (int i = 0; i < mfs_1.size(); i++) {
				TableRecord mf_1 = (TableRecord)mfs_1.get(i);
				Vector mfs_2 = app_sm.selectAll(tblmf, "mf_upfunction=?", new String[]{mf_1.getString("mf_id")});
				for (int j = 0; j < mfs_2.size(); j++) {
					TableRecord mf_2 = (TableRecord)mfs_2.get(j);
					app_sm.delete(tblmf, mf_2.getString("mf_id"));
				}
				app_sm.delete(tblmf, mf_1.getString("mf_id"));
			}
			// Delete record.
			app_sm.delete(tblmf, mf_id);
			if (app_sm.success()) {
				if(app_sm.selectAll(tblmf, "mf_image1=?", new Object[] { mf.getString("mf_image1") }).size() == 0) {
			    	FileTool.deleteFile(app_uploadpath+"/"+"../mis/images/"+mf.getString("mf_image1"));
				}
				if(app_sm.selectAll(tblmf, "mf_image2=?", new Object[] { mf.getString("mf_image2") }).size() == 0) {
			    	FileTool.deleteFile(app_uploadpath+"/"+"../mis/images/"+mf.getString("mf_image2"));
				}
				if(app_sm.selectAll(tblmf, "mf_topimage=?", new Object[] { mf.getString("mf_topimage") }).size() == 0) {
				    FileTool.deleteFile(app_uploadpath+"/"+"../mis/images/"+mf.getString("mf_topimage"));
				}					
			    out.println("<script> alert('資料刪除成功!!'); location='"+code+".jsp?mf_upfunction="+mf.getString("mf_upfunction")+"&mf_type="+String.valueOf(Integer.parseInt(mf.getString("mf_type"))-1)+"'; </script>");
			} else {
				out.println("<script> alert('刪除失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
			}
			return;
		}

		if("REPLY".equals(action)) {	//變更處理狀態
			TableRecord mf = app_sm.select(tblmf, "mf_id=?", new Object[]{mf_id});
			mf.setValue("mf_status", StringTool.validString(request.getParameter("mf_status")));
			mf.setUpdate(app_account);
			app_sm.update(mf);

			if(app_sm.success()) {
				out.println("<script> alert('顯示狀態變更成功!!'); location='"+code+".jsp?mf_upfunction="+mf.getString("mf_upfunction")+"&mf_type="+String.valueOf(Integer.parseInt(mf.getString("mf_type"))-1)+"'; </script>");
			} else {
				out.println("<script> alert('顯示狀態變更失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
			}
			return;
		}

		if("MS".equals(action)){	//變更處理狀態
			TableRecord mf = app_sm.select(tblmf, "mf_id=?",new Object[] { mf_id });

			mf.setValue("mf_name", StringTool.validString(request.getParameter("mf_name")));
			mf.setValue("mf_url", StringTool.validString(request.getParameter("mf_url")));
			mf.setValue("mf_status", StringTool.validString(request.getParameter("mf_status")));
			
			mf.setUpdate(app_account);
			app_sm.update(mf);

			if(app_sm.success()) {
				out.println("<script> alert('資料修改成功!!'); location='"+code+".jsp?mf_upfunction="+mf.getString("mf_upfunction")+"&mf_type="+String.valueOf(Integer.parseInt(mf.getString("mf_type"))-1)+"'; </script>");
			} else {
				out.println("<script> alert('修改失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
			}
			return;
		}
		
	//檔案路徑與設置
	String dir = application.getRealPath("/") + "mis/images/";
	DiskFileUpload fu = new DiskFileUpload();
	fu.setHeaderEncoding("UTF-8");//亂碼關鍵(1)
	fu.setSizeMax(4194304); //設置文件大小
	fu.setSizeThreshold(4096); //設置緩衝大小
	fu.setRepositoryPath(dir); //設置臨時目錄     
	List fileItems = fu.parseRequest(request);
	Iterator i = fileItems.iterator();
	//--------------------------------------------------------------//
	if("S".equals(action)){//排序
		String mf_upfunction = StringTool.validString(request.getParameter("mf_upfunction"));
		String mf_type = StringTool.validString(request.getParameter("mf_type"));
		
		String chk_data = "";
		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			if (fi.isFormField()){											//這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); 			//取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); 		//取得值
				 if("selData".equals(fieldName)){chk_data = fieldvalue.trim();}
			}
		}
		String list[] = chk_data.split(",");
		for(int j=0;j<list.length;j++){
			if(!"".equals(list[j].trim())){
				TableRecord mf = app_sm.select(tblmf, "mf_id=?",new Object[] { list[j] });
				mf.setValue("mf_priority", j);
				mf.setUpdate(app_account);
				app_sm.update(mf, new String[] { "mf_id" });
			}
		}

		if(app_sm.success()) {
			out.println("<script> alert('排序完成!!');location='"+code+".jsp?mf_upfunction="+mf_upfunction+"&mf_type="+mf_type+"'; </script>");
		} else {
			out.println("<script> alert('修改失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;
	}
	if("A".equals(action)){//新增
		
		TableRecord mf = new TableRecord(tblmf);
		//---------------------檔案上傳-----------------------------------------------
		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			if (fi.isFormField()){ 											//這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); 			//取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); 		//取得值
				// System.out.println(fieldName);
				mf.setValue(fieldName, fieldvalue.trim());					//設定欄位值
			}else { //處理文件
				int g = fi.getName().lastIndexOf("\\");
				String fileName = fi.getName();
				String fileName_1 = "";
				if(g<0){
	                fileName = fi.getName();//兼容非ie
	                fileName_1 = fi.getName();
	            }
	            else{
	                fileName = fi.getName().substring(g);					//取得上傳文件名
	                // System.out.println(fileName);
	                fileName_1 = fileName.substring(1,fileName.length());
	            }
				if((fSize * 1024 * 1024) < fi.getSize() && (("mf_image1".equals(fi.getFieldName())) || ("mf_image2".equals(fi.getFieldName())) ||("mf_topimage".equals(fi.getFieldName())) )){
					out.println("<script> alert('上傳檔案不可超過"+String.valueOf(fSize)+"MB'); history.back(); </script>");return;
				}
				if (fileName != null && !"".equals(fileName)) {
					String chk_str = fileName;
					/*
					if(chk_str.getBytes().length != new String(chk_str).length()){
						out.println("<script> alert('上傳檔名不可為中文'); history.back(); </script>");
						return;
					}
					*/
					fi.write(new File(dir, fileName_1 ));
					mf.setValue(fi.getFieldName(), fileName_1);				//設定圖
				}
			}
		}
		mf.setValue("mf_priority", "99");
		mf.setInsert(app_account);
		app_sm.insert(mf);	

		if(app_sm.success()) {
			out.println("<script> alert('新增成功!!');location='"+code+".jsp?mf_upfunction="+mf.getString("mf_upfunction")+"&mf_type="+String.valueOf(Integer.parseInt(mf.getString("mf_type"))-1)+"'; </script>");
		} else {
			out.println("<script> alert('新增失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;
	}else if("M".equals(action)){//修改
		TableRecord mf = app_sm.select(tblmf, "mf_id=?",new Object[] { mf_id });
		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			if (fi.isFormField()) {//這是用來確定是否為文件(file)屬性
				String fieldName = fi.getFieldName(); //取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); 			//取得值
				//System.out.println(fieldName);
				if(!("imgradio1".equals(fieldName) || "imgradio2".equals(fieldName) || "topimgradio".equals(fieldName) )) {
					mf.setValue(fieldName, fieldvalue.trim());			//設定欄位值
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
	                fileName = fi.getName().substring(g);//取得上傳文件名
	                fileName_1 = fileName.substring(1,fileName.length());
	            }
				if((fSize * 1024 * 1024) < fi.getSize() && "mf_image".equals(fi.getFieldName())) {
					out.println("<script> alert('上傳檔案不可超過"+String.valueOf(fSize)+"MB'); history.back(); </script>");return;
				}
				if (fileName != null && !"".equals(fileName)) {
					String chk_str = fileName;
					/*
					if(chk_str.getBytes().length != new String(chk_str).length()){
						out.println("<script> alert('上傳檔名不可為中文'); history.back(); </script>");
						return;
					}
					*/
					
					// Delete 原來的 image file.
					if(!"".equals(mf.getString(fi.getFieldName()))){
						FileTool.deleteFile(app_uploadpath+"/"+"../mis/images/"+mf.getString(fi.getFieldName()));
					}
					
					fi.write(new File(dir, fileName_1 ));
					mf.setValue(fi.getFieldName(), fileName_1);//設定圖
				}
			}
		}
		// Update record.
		mf.setUpdate(app_account);
		app_sm.update(mf);

		if(app_sm.success()) {
			out.println("<script> alert('資料修改成功!!'); location='"+code+".jsp'; </script>");
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