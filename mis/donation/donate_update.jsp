<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@ include file="/web/include/encryption.jsp"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<%@ page import="java.util.List" %>
<%
String code 		= StringTool.validString(request.getParameter("code"));		// 識別碼
String db_names 	= tbldh; 													// 使用哪張資料表
String show_title 	= "捐款資訊管理";												// 功能標題
String src = StringTool.validString(request.getParameter("src"));
src = "".equals(src)?"":"?src="+src;

try {
	String action = StringTool.validString(request.getParameter("action"));		//A:新增,M:修改,D:刪除,S:排序
	String dh_id = StringTool.validString(request.getParameter("dh_id"));

	// Conditions.
	String qposition = StringTool.validString(request.getParameter("_qposition"));
	String qcollect	 = StringTool.validString(request.getParameter("_qcollect"));
	String qship	 = StringTool.validString(request.getParameter("_qship"));
	String qbonus	 = StringTool.validString(request.getParameter("_qbonus"));
	String qivoice = StringTool.validString(request.getParameter("_qivoice"));

	String qdhno = StringTool.validString(request.getParameter("_qdhno"));
	String qname = StringTool.validString(request.getParameter("_qname"));
	String qphone = StringTool.validString(request.getParameter("_qphone"));
	String qpayment = StringTool.validString(request.getParameter("_qpayment"));
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"));

	// Names and values.
	String[] names = new String[] { "npage", "_qposition", "_qname", "_qemitdate", "_qrestdate", "_qship", "_qcollect", "_qbonus","_qdhno","_qpayment" ,"dh_id","_qivoice"};
	String[] values = new String[] { String.valueOf(pageno), qposition, qname, qemitdate, qrestdate, qship, qcollect, qbonus, qdhno,qpayment,dh_id ,qivoice};

	out.println(HtmlCoder.form("backdata", code+".jsp"+src, names, values));

	// 刪除
	if("D".equals(action)) {
		app_sm.delete(db_names, "dh_id=?", new Object[] { dh_id });		// 刪除
		app_sm.close();
		out.println("<script> alert('刪除成功!!'); backdata.submit();  </script>");
		return;
	}
	
	if("POP3".equals(action)){//設定收件者
		// Tiltes.
		String[] titles = new String[] { show_title+"正本收件者",show_title+"副本收件者" };
		// Keywords.
		String[] keywords = new String[] { "original" , "duplicate" };
		
		// Get records.
		Vector smtps = new Vector();
		for (int i = 0; i < titles.length; i++) {
		    TableRecord ss = SiteSetup.getSetup(keywords[i]+"."+code+"."+lang);
		    ss.setUpdate(app_account);
		    String value = StringTool.validString(request.getParameter(keywords[i]));
		    ss.setValue("ss_value", value);
		    ss.setUpdate(app_account);
		    app_sm.update(ss);
		}
		out.println("<script> alert('收件者設定成功!!'); backdata.submit();  </script>");
		return;

	// 變更處理狀態	
	}else if("COLLECT".equals(action)){
		TableRecord dh = app_sm.select(db_names, "dh_id=?", new Object[]{dh_id});
		TableRecord dr = app_sm.select(tbldr, "dh_id=?", new Object[]{dh_id});
		String dh_collect = "Y".equals(dh.getString("dh_collect"))?"N":"Y";
		
		if(!"".equals(dr.getString("dr_id"))) {
			dr.setValue("dr_status", dh_collect);
			dr.setUpdate(app_account);
			app_sm.update(dr);
		} else {
			if("Y".equals(dh_collect)){
				TableRecord donate_category = app_sm.select(tbldm, dh.getString("dh_donate_project_category"));
				boolean is_other   = "".equals(donate_category.getString("dm_id"));
				boolean is_public  = "Y".equals(dh.getString("dh_public"));
				boolean is_foreign = !"TWD".equals(dh.getString("dh_currency"));
				
				dr = new TableRecord(tbldr);
				dr.setValue("dh_id", dh.getString("dh_id"));
				dr.setValue("dh_no", dh.getString("dh_no"));
				dr.setValue("dr_no", IDTool.getUID("record", "DR"+DateTimeTool.dateString(""), 6));
				dr.setValue("dr_name", is_public?dh.getString("dh_name"):"熱心人士");
				dr.setValue("dr_identity", dh.getString("dh_identity"));
				dr.setValue("dr_donatedate", dh.getString("dh_donatedate"));
				dr.setValue("dr_donate_item_category", is_other?"其他":donate_category.getString("dm_title"));
				dr.setValue("dr_donate_item", dh.getString("dh_donate_project"));
				dr.setValue("dr_donate_item_title", dh.getString("dh_donate_project_title"));
				dr.setValue("dr_currency", dh.getString("dh_currency"));
				dr.setValue("dr_total", dh.getInt(is_foreign?"dh_foreign_total":"dh_total"));
				dr.setValue("dr_status", "Y");
				dr.setValue("dr_code", "directory");
				dr.setValue("dr_lang", lang);
				dr.setInsert(app_account);
				app_sm.insert(dr);
				
				dh.setValue("dr_id", dr.getString("dr_id"));
				dh.setValue("dr_no", dr.getString("dr_no"));	// dh寫入收據編號
			}
		}
		
		dh.setValue("dh_collect", dh_collect);
		dh.setUpdate(app_account);
		app_sm.update(dh);
		
		// 回列表頁
		out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
		out.println("<script> alert('付款狀態修改成功!!');listpage.submit(); </script> ");
		return;		
		
	}else if("STATUS".equals(action)){			//變更 狀態
		TableRecord dh = app_sm.select(db_names, "dh_id=?", new Object[]{dh_id});
		TableRecord dr = app_sm.select(tbldr, "dh_id=?", new Object[]{dh_id});
		String dh_status = "Y".equals(dh.getString("dh_status"))?"N":"Y";
			
		if(!"".equals(dr.getString("dr_id"))) {
			dr.setValue("dr_status", dh_status);
			dr.setUpdate(app_account);
			app_sm.update(dr);
		}
	
		dh.setValue("dh_status", dh_status);
		dh.setUpdate(app_account);
		app_sm.update(dh);	
		
		out.println("<script>alert('捐款單狀態修改成功!!'); backdata.submit();  </script>");
		return;
	}	
	
	//檔案路徑與設置
	String dir = app_uploadpath+"/"+code;
	DiskFileUpload fu = new DiskFileUpload();
	fu.setHeaderEncoding("UTF-8");//亂碼關鍵(1)
	fu.setSizeMax(4194304); //設置文件大小
	fu.setSizeThreshold(4096); //設置緩衝大小
	fu.setRepositoryPath(dir); //設置臨時目錄     
	List fileItems = fu.parseRequest(request);
	Iterator iter_i = fileItems.iterator();

	// 後台新增捐款單 20221018 May
	if("A".equals(action)) {
		TableRecord dh = new TableRecord(tbldh);
		String donate_project_dept = "";
		String donate_project_dept_title = "";
		
		dh.setValue("dh_same_name", "N");
		dh.setValue("dh_same_address", "N");
		
		while (iter_i.hasNext()) {
			FileItem fi = (FileItem) iter_i.next();
			if (fi.isFormField()){ //這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); //取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); //取得值
// 				System.out.println("fieldName = " + fieldName + ", fieldvalue = " + fieldvalue);
				
				if(fieldName.contains("dh_")){
					if(fieldName.equals("dh_pid") && !"".equals(fieldvalue.trim()))
						fieldvalue = new AESDataEncryption().AESEncrypt(fieldvalue.trim());
					else if(fieldName.equals("dh_currency") && "".equals(fieldvalue.trim()))
						fieldvalue = "TWD";
					dh.setValue(fieldName, fieldvalue.trim());
				} else if(fieldName.equals("donate_project_dept")){
					donate_project_dept = fieldvalue.trim();
				} else if(fieldName.equals("donate_project_dept_title")){
					donate_project_dept_title = fieldvalue.trim();
				}
			}
		}
		
		// 假設手機人名mp裡沒有新增，有則放到dh裡
		TableRecord mp1 = app_sm.select(tblmp, "mp_personid=?", new Object[] { dh.getString("dh_pid") });
		String mp_id = mp1.getString("mp_id");
		
		if(mp1.getString("mp_id").equals("")){
			TableRecord mp = new TableRecord(tblmp);
			mp.setValue("mp_name", dh.getString("dh_name"));
			mp.setValue("mp_personid", dh.getString("dh_pid"));
			mp.setValue("mp_email", dh.getString("dh_email"));
			mp.setValue("mp_cellphone", dh.getString("dh_cellphone"));
			mp.setValue("mp_phone", dh.getString("dh_phone"));
			mp.setValue("mp_county", dh.getString("dh_county"));
			mp.setValue("mp_city", dh.getString("dh_city"));
			mp.setValue("mp_zipcode", dh.getString("dh_zipcode"));
			mp.setValue("mp_address", dh.getString("dh_address"));
			mp.setValue("mp_unit", dh.getString("dh_unit"));
			mp.setValue("mp_job", dh.getString("dh_job"));
			mp.setValue("mp_mail_status","Y");
			mp.setValue("mp_regcode", "OK");
			mp.setValue("mp_status", "Y");
			mp.setValue("mp_code", "member");
			mp.setInsert("Web_User");
			app_sm.insert(mp);
			
			mp_id = mp.getString("mp_id");
		}
		
		// 院系捐款  
		TableRecord department_index = app_sm.select(tbldm, "dm_code=? and dm_lang=? and dm_category=?",
	            new Object[]{"department_index", lang, ""}, "dm_showseq ASC, dm_createdate DESC");
		boolean is_dept = dh.getString("dh_donate_project_category").equals(department_index.getString("dm_id"));
		
		if(is_dept) dh.setValue("dh_donate_project", donate_project_dept);
		
		// 捐款項目相關資訊
		TableRecord donate_project_cp = app_sm.select(tblcp, dh.getString("dh_donate_project"));
		
		if(!"".equals(donate_project_cp.getString("cp_id"))) {
			TableRecord donate_unit = app_sm.select(tbldm, donate_project_cp.getString("cp_usage"));	// 受贈單位
			TableRecord donate_attr = app_sm.select(tbldm, donate_project_cp.getString("cp_attr"));		// 捐款屬性
			
			String dh_donate_unit 			 = donate_unit.getString("dm_id");
			String dh_donate_unit_title 	 = donate_unit.getString("dm_title");
			String dh_donate_attribute 		 = donate_attr.getString("dm_id");
			String dh_donate_attribute_title = donate_attr.getString("dm_title");
			String dh_donate_project_no 	 = donate_project_cp.getString("cp_no");
			String dh_donate_project_title   = donate_project_cp.getString("cp_title");

			dh.setValue("dh_donate_project_no", dh_donate_project_no);
			dh.setValue("dh_donate_project_title", dh_donate_project_title);
			dh.setValue("dh_donate_unit", dh_donate_unit);
			dh.setValue("dh_donate_unit_title", dh_donate_unit_title);
			dh.setValue("dh_donate_attribute", dh_donate_attribute);
			dh.setValue("dh_donate_attribute_title", dh_donate_attribute_title);
		}
		
		/*------------------捐款編號 OrderID----------------------------------*/
		String dh_no = "";

		String idHead = "1044001";	
		String seq = IDTool.getUID("donate", DateTimeTool.dateString(""), 4);
		Random rand = new Random(); 
		int randomDigit = rand.nextInt(10);
		
		dh_no = idHead + seq + randomDigit ;	
		
		dh.setValue("dh_donatedate", app_today);
		dh.setValue("dh_no", dh_no);
		dh.setValue("rs_status", "N");
		dh.setValue("dh_mis", "Y");
		dh.setValue("dh_status", "Y");
		dh.setValue("dh_collect", "Y");
		dh.setValue("dh_calculate", "N");
		dh.setValue("dh_lang", lang);
		dh.setValue("dh_code", code);
		dh.setValue("mp_id", mp_id);
		dh.setInsert(app_account);
		app_sm.insert(dh);
		
		if(app_sm.success()){
			TableRecord dh_1 = app_sm.select(tbldh, dh.getString("dh_id"));
			TableRecord donate_category = app_sm.select(tbldm, dh_1.getString("dh_donate_project_category"));
			boolean is_other   = "".equals(donate_category.getString("dm_id"));
			boolean is_public  = "Y".equals(dh.getString("dh_public"));
			boolean is_foreign = !"TWD".equals(dh_1.getString("dh_currency"));
			
			TableRecord dr = new TableRecord(tbldr);
			dr.setValue("dh_id", dh_1.getString("dh_id"));
			dr.setValue("dh_no", dh_1.getString("dh_no"));
			dr.setValue("dr_no", IDTool.getUID("record", "DR"+DateTimeTool.dateString(""), 6));
			dr.setValue("dr_name", is_public?dh.getString("dh_name"):"熱心人士");
			dr.setValue("dr_identity", dh_1.getString("dh_identity"));
			dr.setValue("dr_donatedate", dh_1.getString("dh_donatedate"));
			dr.setValue("dr_donate_item_category", donate_category.getString("dm_title"));
			dr.setValue("dr_donate_item", dh_1.getString("dh_donate_project"));
			dr.setValue("dr_donate_item_title", dh_1.getString("dh_donate_project_title"));
			dr.setValue("dr_currency", dh_1.getString("dh_currency"));
			dr.setValue("dr_total", dh_1.getInt(is_foreign?"dh_foreign_total":"dh_total"));
			dr.setValue("dr_status", "Y");
			dr.setValue("dr_code", "directory");
			dr.setValue("dr_lang", lang);
			dr.setInsert("System");
			app_sm.insert(dr);
			
			dh_1.setValue("dr_id", dr.getString("dr_id"));
			dh_1.setValue("dr_no", dr.getString("dr_no"));	// dh寫入收據編號
			dh_1.setUpdate(app_account);
			app_sm.update(dh_1);
		}

		out.println("<script> alert('新增成功!!');location='"+code+".jsp'; </script>");
		return;
		
	// 修改
	} else if("M".equals(action)){
		TableRecord dh = app_sm.select(tbldh, dh_id);
		String donate_project_dept = "";
		String donate_project_dept_title = "";
		
		while (iter_i.hasNext()) {
			FileItem fi = (FileItem) iter_i.next();
			if (fi.isFormField()){ //這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); //取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); //取得值
// 				System.out.println("fieldName = " + fieldName + ", fieldvalue = " + fieldvalue);
				
				if(fieldName.contains("dh_")){
					dh.setValue(fieldName, fieldvalue.trim());
				} else if(fieldName.equals("donate_project_dept")){
					donate_project_dept = fieldvalue.trim();
				} else if(fieldName.equals("donate_project_dept_title")){
					donate_project_dept_title = fieldvalue.trim();
				}
			}
		}
		
		// 院系捐款  
		TableRecord department_index = app_sm.select(tbldm, "dm_code=? and dm_lang=? and dm_category=?",
	            new Object[]{"department_index", lang, ""}, "dm_showseq ASC, dm_createdate DESC");
		boolean is_dept = dh.getString("dh_donate_project_category").equals(department_index.getString("dm_id"));
		
		if(is_dept) {
			boolean is_other = "other".equals(donate_project_dept);
			
			dh.setValue("dh_donate_project", donate_project_dept);
			if(is_other) dh.setValue("dh_donate_project_title", donate_project_dept_title);
		}
		
		// 捐款項目相關資訊
		TableRecord donate_project_cp = app_sm.select(tblcp, dh.getString("dh_donate_project"));
		
		if(!"".equals(donate_project_cp.getString("cp_id"))) {
			TableRecord donate_unit = app_sm.select(tbldm, donate_project_cp.getString("cp_usage"));	// 受贈單位
			TableRecord donate_attr = app_sm.select(tbldm, donate_project_cp.getString("cp_attr"));		// 捐款屬性
			
			String dh_donate_unit 			 = donate_unit.getString("dm_id");
			String dh_donate_unit_title 	 = donate_unit.getString("dm_title");
			String dh_donate_attribute 		 = donate_attr.getString("dm_id");
			String dh_donate_attribute_title = donate_attr.getString("dm_title");
			String dh_donate_project_no 	 = donate_project_cp.getString("cp_no");
			String dh_donate_project_title   = donate_project_cp.getString("cp_title");

			dh.setValue("dh_donate_project_no", dh_donate_project_no);
			dh.setValue("dh_donate_project_title", dh_donate_project_title);
			dh.setValue("dh_donate_unit", dh_donate_unit);
			dh.setValue("dh_donate_unit_title", dh_donate_unit_title);
			dh.setValue("dh_donate_attribute", dh_donate_attribute);
			dh.setValue("dh_donate_attribute_title", dh_donate_attribute_title);
		}
		dh.setUpdate(app_account);
		app_sm.update(dh);
		
		/*-- 芳名錄 --*/
		TableRecord dr = app_sm.select(tbldr, "dh_id=?", new Object[]{dh_id});
		
		if(!"".equals(dr.getString("dr_id"))) {
			TableRecord donate_category = app_sm.select(tbldm, dh.getString("dh_donate_project_category"));
			boolean is_other = "".equals(donate_category.getString("dm_id"));
			
			dr.setValue("dr_donate_item_category", is_other?"其他":donate_category.getString("dm_title"));
			dr.setValue("dr_donate_item", dh.getString("dh_donate_project"));
			dr.setValue("dr_donate_item_title", dh.getString("dh_donate_project_title"));
			dr.setUpdate(app_account);
			app_sm.update(dr);
		}
		
		out.println("<script> alert('修改完成!!');location='"+code+"_b.jsp?dh_id="+dh.getString("dh_id")+"'; </script>");
		return;
	}
	
	
}catch(Exception e){
	System.out.println("Project" + projectName + ", Error info:["+e+"]File name edit.jsp for ["+code+"]Time:["+DateTimeTool.dateTimeString()+"]");
	out.println("<script> alert('處理失敗'); history.back(); </script>");
}finally{app_sm.close();}
%>