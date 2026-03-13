<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 基本參數
	String code = "ip_white_list"; 			// 模組識別碼
	String show_title = "IP白名單維護";		// 模組標題

	// 跳頁參數
	String[] names = new String[] { "npage" };
	String[] values = new String[] { String.valueOf(pageno) };

	// 回列表頁
	out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));

	try {
		// A:新增, M:修改, D:刪除, S:排序
		String action = StringTool.validString(request.getParameter("action"));	
	    String ic_id = StringTool.validString(request.getParameter("ic_id"));
		String ic_ip = StringTool.validString(request.getParameter("ic_ip"));
		
		// 新增
		if("A".equals(action)) {
			if("".equals(ic_ip)) {
				out.println("<script> alert('IP位置不可為空白！'); history.back(); </script>");
				return;
			}
			TableRecord ic = new TableRecord(tblic);
			ic.setValue("ic_ip", ic_ip);
			ic.setValue("ic_code", code);
			ic.setInsert(app_account);
			app_sm.insert(ic);
	
			if(app_sm.success()) {
				out.println("<script> alert('資料新增成功！'); listpage.submit(); </script>");
			} else {
				out.println("<script> alert('新增失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
			}
			return;
		}
	
		// 刪除
		if("D".equals(action)) {
			app_sm.delete(tblic, ic_id);
	
			if (app_sm.success()) {
			    out.println("<script> alert('資料刪除成功!!'); listpage.submit(); </script>");
			} else {
				out.println("<script> alert('刪除失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
			}
			return;
		}
	
		// 修改
		if("M".equals(action)) {
			if("".equals(ic_ip)) {
				out.println("<script> alert('IP位置不可為空白！'); history.back(); </script>");
				return;
			}
			TableRecord ic = app_sm.select(tblic, ic_id);
			ic.setValue("ic_ip", ic_ip);
			ic.setValue("ic_code", code);
			ic.setUpdate(app_account);
			app_sm.update(ic);
	
			if(app_sm.success()) {
				out.println("<script> alert('資料修改成功！'); listpage.submit(); </script>");
			} else {
				out.println("<script> alert('修改失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
			}
			return;
		}
		
		// 檔案路徑與設置
		/*
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
			String chk_data = "";
			while (i.hasNext()) {
				FileItem fi = (FileItem) i.next();
				if (fi.isFormField()) {											// 這是用來確定是否為文件屬性
					String fieldName = new String(fi.getFieldName()); 			// 取得表單名
					String fieldvalue = new String(fi.getString("UTF-8")); 		// 取得值
					if("selData".equals(fieldName)){chk_data = fieldvalue.trim();}
				}
			}
			String list[] = chk_data.split(",");
			for(int j = 0; j < list.length; j++) {
				if(!"".equals(list[j].trim())) {
					TableRecord data = app_sm.select(tblic, "ic_id=?", new Object[] { list[j] });
					data.setValue("ic_showseq", j);
					data.setUpdate(app_account);
					app_sm.update(data);
				}
			}
	
			if(app_sm.success()) {
				out.println("<script> alert('排序完成!!'); listpage.submit(); </script>");
			} else {
				out.println("<script> alert('排序失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
			}
			return;
		}
		*/
	} catch(Exception e) {
		System.out.println("Project:" + projectName + ", Error:" + e + ", File:ip_white_list_update.jsp, Time:" + DateTimeTool.dateTimeString());
		out.println("<script> alert('處理失敗'); history.back(); </script>");
	} finally {
		app_sm.close();
	}
%>