<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@ include file="/web/include/encryption.jsp"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<%@ page import="java.util.List" %>
<%
String code 		= StringTool.validString(request.getParameter("code"));		// 識別碼
String db_names 	= tbldh; 													// 使用哪張資料表
String show_title 	= "捐款單管理";												// 功能標題
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

	// 後台新增捐款單 20221018 May
	if("A".equals(action)) {
		//檔案路徑與設置
		String dir = app_uploadpath+"/"+code;
		DiskFileUpload fu = new DiskFileUpload();
		fu.setHeaderEncoding("UTF-8");//亂碼關鍵(1)
		fu.setSizeMax(4194304); //設置文件大小
		fu.setSizeThreshold(4096); //設置緩衝大小
		fu.setRepositoryPath(dir); //設置臨時目錄     
		List fileItems = fu.parseRequest(request);
		Iterator iter_i = fileItems.iterator();
		
		TableRecord dh = new TableRecord(tbldh);
		
		while (iter_i.hasNext()) {
			FileItem fi = (FileItem) iter_i.next();
			if (fi.isFormField()){ //這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); //取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); //取得值
				// System.out.println("fieldName = " + fieldName + ", fieldvalue = " + fieldvalue);
				
				if(fieldName.contains("dh_")){
					if(fieldName.equals("dh_pid") && !"".equals(fieldvalue.trim()))
						fieldvalue = new AESDataEncryption().AESEncrypt(fieldvalue.trim());
					dh.setValue(fieldName, fieldvalue.trim());
				}
			}
		}
		
		// dh.setValue("rs_status", "Y");
		dh.setValue("dh_status", "Y");
		dh.setValue("dh_collect", "Y");
		dh.setValue("dh_lang", lang);
		dh.setValue("dh_code", code);
		dh.setValue("dh_no", IDTool.getUID(code, "B"+DateTimeTool.dateString(""), 4));
		
		// 假設手機人名mp裡沒有新增，有則放到dh裡
		TableRecord mp1 = app_sm.select(tblmp, "mp_personid=?"
				, new Object[] { dh.getValue("dh_pid") });
		if(mp1.getString("mp_id").equals("")){
			TableRecord mp = new TableRecord(tblmp);

			mp.setValue("mp_personid", dh.getValue("dh_pid"));
			mp.setValue("mp_email", dh.getValue("dh_email"));
			mp.setValue("mp_name", dh.getValue("dh_name"));
			mp.setValue("mp_phone", dh.getValue("dh_phone"));
			mp.setValue("mp_mail_status","Y");
			mp.setValue("mp_regcode", "OK");
			mp.setValue("mp_status", "Y");
			mp.setInsert("Web_User");
			app_sm.insert(mp);
			dh.setValue("mp_id", mp.getString("mp_id"));
		} else {
			dh.setValue("mp_id", mp1.getString("mp_id"));
		}

		dh.setInsert(app_account);
		app_sm.insert(dh);

		out.println("<script> alert('新增成功!!');location='"+code+".jsp'; </script>");
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
		dh.setUpdate(app_account);
		dh.setValue("dh_collect", "Y".equals(StringTool.validString(dh.getString("dh_collect")))?"N":"Y");
		app_sm.update(dh);
		// 回列表頁
		out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
		out.println("<script> alert('付款狀態修改成功!!');listpage.submit(); </script> ");
		return;		
		
	}else if("STATUS".equals(action)){			//變更 狀態
		TableRecord dh = app_sm.select(db_names, "dh_id=?", new Object[]{dh_id});
		dh.setValue("dh_status", "Y".equals(StringTool.validString(dh.getString("dh_status")))?"N":"Y");
		dh.setUpdate(app_account);
		
		app_sm.update(dh);	
		out.println("<script>alert('捐款單狀態修改成功!!'); backdata.submit();  </script>");
		return;
	}	
}catch(Exception e){
	System.out.println("Project" + projectName + ", Error info:["+e+"]File name edit.jsp for ["+code+"]Time:["+DateTimeTool.dateTimeString()+"]");
	out.println("<script> alert('處理失敗'); history.back(); </script>");
}finally{app_sm.close();}
%>