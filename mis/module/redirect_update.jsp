<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<%@ page import="java.util.List" %>
<%
	// 基本參數
	String code 		= "redirect"; 												// 模組識別碼
	String action 		= StringTool.validString(request.getParameter("action"));	// A:新增,M:修改
	String db_names 	= tblrr; 								         			// 使用哪張資料表
	String show_title 	= "短網址設定";													// 功能標題

	// 讀取上層類別 ID
	String qcategory = StringTool.validString(request.getParameter("_qcategory"));

	String rr_id 		= StringTool.validString(request.getParameter("rr_id"));
	String rr_title 	= StringTool.validString(request.getParameter("rr_title"));
	String rr_url 		= StringTool.validString(request.getParameter("rr_url"));
	String rr_code 		= StringTool.validString(request.getParameter("rr_code"),"");
	out.println(HtmlCoder.lastPage(request.getHeader("referer"),new String[]{"rr_id"},new String[]{rr_code}));

	if("A".equals(action)){ // A: 新增
		if("".equals(rr_title)) {
			out.println("<script> alert('"+show_title+"代號不可為空白!!'); lastpage.submit(); </script>");
			return;
		}
		// 確認是否有該標題的短網址了 
		Vector rrs = app_sm.selectAll(tblrr, "rr_title = ? and rr_code = ? ", new Object[]{rr_title, rr_code});
		if(rrs.size()>0){
			out.println("<script> alert('短網址代號重複!!'); lastpage.submit(); </script>");
			return;
		}
	
		TableRecord rr = new TableRecord(tblrr);

		rr.setValue("rr_title", rr_title);
		rr.setValue("rr_url", rr_url);
		rr.setValue("rr_code", rr_code);
		rr.setInsert(app_account);
		app_sm.insert(rr);

		if(app_sm.success()) {
			out.println("<script> alert('資料新增成功!!'); lastpage.submit(); </script>");
		} else {
			out.println("<script> alert('新增失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;
	}
	
	if("M".equals(action)){ // M: 修改
		if("".equals(rr_title)) {
			out.println("<script> alert('"+show_title+"名稱不可為空白!!'); lastpage.submit(); </script>");
			return;
		}
		// 確認是否有該標題的短網址了 
		Vector rrs = app_sm.selectAll(tblrr, "rr_title = ? and rr_code = ? and rr_id <> ?", new Object[]{rr_title, rr_code, rr_id});
		if(rrs.size()>0){
			out.println("<script> alert('短網址代號重複!!'); lastpage.submit(); </script>");
			return;
		}
	
		TableRecord rr = app_sm.select(tblrr, rr_id);
		rr.setValue("rr_title", rr_title);
		rr.setValue("rr_url", rr_url);
		rr.setValue("rr_code", rr_code);
		rr.setUpdate(app_account);
		app_sm.update(rr);

		if(app_sm.success()) {
			out.println("<script> alert('資料修改成功!!'); lastpage.submit(); </script>");
		} else {
			out.println("<script> alert('修改失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;
	}
	
	if("D".equals(action)){ // D: 刪除
		// Get record.
		TableRecord rr = app_sm.select(tblrr, rr_id);
		// Delete record.
		app_sm.delete(tblrr, rr_id);
		if (app_sm.success()) {
		    out.println("<script> alert('資料刪除成功!!'); lastpage.submit(); </script>");
		} else {
			out.println("<script> alert('刪除失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;
	}
	
	try{
		//---//
		//檔案路徑與設置
		String dir = application.getRealPath("/") + "uploads/"+rr_code+"/"+lang+"/";
		DiskFileUpload fu = new DiskFileUpload();
		fu.setHeaderEncoding("UTF-8");//亂碼關鍵(1)
		//fu.setSizeMax(4194304); //設置文件大小
		//fu.setSizeThreshold(4096); //設置緩衝大小
		//fu.setRepositoryPath(application.getRealPath("/") + "uploads/temp");  //設置臨時目錄
		fu.setRepositoryPath(dir); //設置臨時目錄     
		List fileItems = fu.parseRequest(request);
		Iterator i = fileItems.iterator();
		//---//
		//--------------------------------------------------------------//
		if("S".equals(action)){//排序
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
					TableRecord pc = app_sm.select(db_names, "rr_id=?",new Object[] { list[j] });
					pc.setValue("rr_showseq", j+1);
					pc.setUpdate(app_account);
					app_sm.update(pc, new String[] { "rr_id" });
				}
			}

			if(app_sm.success()) {
				out.println("<script> alert('排序完成!!'); location='"+rr_code+".jsp"+("".equals(qcategory)?"":"?_qcategory="+qcategory)+"'; </script>");
			} else {
				out.println("<script> alert('修改失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
			}
			return;
		}
	} catch(Exception e) {
		System.out.println("Project:" + projectName + ", Error info:["+e+"]File name edit.jsp for ["+rr_code+"]Time:["+DateTimeTool.dateTimeString()+"]");
		out.println("<script> alert('處理失敗'); history.back(); </script>");
	} finally {
		app_sm.close();
	}
%>