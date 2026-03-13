<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<%@ page import="java.util.List" %>
<%
String code 		= StringTool.validString(request.getParameter("code"));		// 識別碼
String rl_code 		= "receipt";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
String db_names 	= tbldh; 													// 使用哪張資料表
String show_title 	= "捐款單管理";												// 功能標題
String src = StringTool.validString(request.getParameter("src"));
src = "".equals(src)?"":"?src="+src;

//
try{
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

	String qrlno	 = StringTool.validString(request.getParameter("_qrlno"));
	String qrsstatus	= StringTool.validString(request.getParameter("_qrsstatus"));		// 收據開立狀態
	
	// Names and values.
	String[] names = new String[] { "npage", "_qposition", "_qname", "_qemitdate", "_qrestdate", "_qship", "_qcollect", "_qbonus","_qphone","_qdhno","_qpayment" ,"dh_id","_qivoice","_qrlno","_qrsstatus"};
	String[] values = new String[] { String.valueOf(pageno), qposition, qname, qemitdate, qrestdate, qship, qcollect, qbonus, qdhno,qphone,qpayment,dh_id ,qivoice,qrlno,qrsstatus};
	
	//out.println(HtmlCoder.form("backdata", code+".jsp"+src, names, values));
	out.println(HtmlCoder.form("backdata", rl_code+".jsp"+src, names, values));  
	
	//---//
	if("D".equals(action)){				//刪除
		app_sm.delete(db_names, "dh_id=?", new Object[] { dh_id });		// 刪除詢價單
		app_sm.close();
		out.println("<script> alert('刪除成功!!'); backdata.submit();  </script>");
		return;
	}
	
	// 合併新增 
	if ("A".equals(action)) {	
		String rs_no_add = StringTool.validString(request.getParameter("rs_no_add"),"");
		String [] rl_add_id = rs_no_add.split(",");
		String rs_no = IDTool.getUID("receipt", "R"+DateTimeTool.getYear(), 6);				//收據編號
		String dh_no = "";
		
		
		TableRecord rs = new TableRecord(tblrs);
		rs.setInsert(app_account);
		rs.setValue("rs_no", rs_no);
		rs.setValue("dh_id", rs_no_add);
		
		rs.setValue("dh_order_name", StringTool.validString(request.getParameter("dh_order_name")));
		rs.setValue("dh_pid", StringTool.validString(request.getParameter("dh_pid")));
		// rs.setValue("os_compid", StringTool.validString(request.getParameter("os_compid")));
		rs.setValue("dh_total", Integer.parseInt(StringTool.validString(request.getParameter("dh_total"),"0")));
// 		rs.setValue("dh_total_cn", StringTool.validString(request.getParameter("dh_total_cn")));
		rs.setValue("dh_order_county", StringTool.validString(request.getParameter("dh_county")));
		rs.setValue("dh_order_city", StringTool.validString(request.getParameter("dh_city")));
		rs.setValue("dh_order_zip_code", StringTool.validString(request.getParameter("dh_zip_code")));
		rs.setValue("dh_order_address", StringTool.validString(request.getParameter("dh_address")));
// 		rs.setValue("dh_receipt", StringTool.validString(request.getParameter("dh_receipt_type")));				
		rs.setValue("rs_donateitem", StringTool.validString(request.getParameter("rs_donateitem")));
		rs.setValue("rs_status", "Y");			// 新增收據狀態 20221115 May
		rs.setValue("rs_type", "single");		// 新增收據類型 20240820 May
		rs.setValue("rs_code", "receipt");
		rs.setValue("rs_lang", lang);
		// rs.printAttributes();
		app_sm.insert(rs);
		
// 		for(int k=0;k<rl_add_id.length;k++){												// 批次選取
// 		String dhid = rl_add_id[k];
// 			TableRecord check = app_sm.select(tblrl, "dh_id=?", new Object[] { dhid });
// 			if (check.getString("dh_id").equals("")) {
				
// 				TableRecord new_rl = new TableRecord(tblrl);
// 				TableRecord dh = app_sm.select(tbldh, dhid);
// 				TableRecord dm = app_sm.select(tbldm, dh.getString("dh_donate_item"));
// 				new_rl.setInsert(app_account);
				
// 				new_rl.setValue("rs_no", rs_no);								// 收據編號
// 				new_rl.setValue("dh_id", dhid);									// 捐款id
// 				new_rl.setValue("dh_no", dh.getString("dh_no"));
// 				new_rl.setValue("dh_name", dh.getString("dh_name"));
// 				new_rl.setValue("dh_order_name", dh.getString("dh_receipt_title"));
// 				new_rl.setValue("dh_pid", dh.getString("dh_pid"));
// 				new_rl.setValue("dh_total", dh.getInt("dh_total"));
// 				new_rl.setValue("dh_paymethod", dh.getString("dh_paymethod"));
// 				new_rl.setValue("dh_receipt", dh.getString("dh_receipt_type"));				
// 				new_rl.setValue("rl_donateitem", dm.getString("dm_title"));
// 				new_rl.setValue("rl_code", "receipt");
// 				new_rl.setValue("rl_lang", lang);
// 				app_sm.insert(new_rl);
				
// 				dh_no += dh.getString("dh_no")+";" ;	//rs用-捐款單編號
				
// 				dh.setValue("rs_no", rs_no);//dh寫入收據編號
// 				app_sm.update(dh);
// 			}
// 		}
			
		TableRecord rs2 = app_sm.select(tblrs, rs.getString("rs_id"));	
		rs2.setValue("dh_no", dh_no);	//rs用-捐款單編號
		app_sm.update(rs2);	
			
		
		out.println("<script> alert('收據編碼填寫成功!!'); backdata.submit();  </script>");
		return;
		
	}else if ("A2".equals(action)) {
		String rs_no_add = StringTool.validString(request.getParameter("rs_no_add"),"");
		String [] rl_add_id = rs_no_add.split(",");
		
		for(int k=0;k<rl_add_id.length;k++){												// 批次選取
			String dhid = rl_add_id[k];
			TableRecord dh = app_sm.select(tbldh, "dh_id=?", new Object[] { dhid });
			TableRecord cp = app_sm.select(tblcp, dh.getString("dh_donate_project"));
			
			String rs_no = IDTool.getUID("receipt", "R"+DateTimeTool.getYear(), 6);				//收據編號
			String dh_no = "";
			
			TableRecord rs = new TableRecord(tblrs);
			rs.setInsert(app_account);
			rs.setValue("rs_no", rs_no);
			rs.setValue("dh_id", rs_no_add);
			
			rs.setValue("dh_order_name", dh.getString("dh_receipt_title"));
			rs.setValue("dh_pid", dh.getString("dh_pid"));
			// rs.setValue("os_compid", StringTool.validString(request.getParameter("os_compid")));
			rs.setValue("dh_no", dh.getString("dh_no"));
			rs.setValue("dh_total", dh.getInt("dh_total"));
			rs.setValue("dh_order_county", dh.getString("dh_county"));
			rs.setValue("dh_order_city", dh.getString("dh_city"));
			rs.setValue("dh_order_zip_code", dh.getString("dh_address"));
			rs.setValue("dh_order_address", dh.getString("dh_address"));
// 			rs.setValue("dh_receipt", dh.getString("dh_receipt_type"));				
			rs.setValue("rs_donateitem", cp.getString("cp_title"));
			rs.setValue("rs_status", "Y");			// 新增收據狀態 20221115 May
			rs.setValue("rs_type", "single");		// 新增收據類型 20240820 May
			rs.setValue("rs_code", "receipt");
			rs.setValue("rs_lang", lang);
			// rs.printAttributes();
			app_sm.insert(rs);
			
// 			TableRecord new_rl = new TableRecord(tblrl);
			
// 			new_rl.setInsert(app_account);
// 			new_rl.setValue("rs_no", rs_no);								// 收據編號
// 			new_rl.setValue("dh_id", dhid);									// 捐款id
// 			new_rl.setValue("dh_no", dh.getString("dh_no"));
// 			new_rl.setValue("dh_name", dh.getString("dh_name"));
// 			new_rl.setValue("dh_order_name", dh.getString("dh_receipt_title"));
// 			new_rl.setValue("dh_pid", dh.getString("dh_pid"));
// 			new_rl.setValue("dh_total", dh.getInt("dh_total"));
// 			new_rl.setValue("dh_paymethod", dh.getString("dh_paymethod"));
// 			new_rl.setValue("dh_receipt", dh.getString("dh_receipt_type"));				
// 			new_rl.setValue("rl_donateitem", dm.getString("dm_title"));
// 			new_rl.setValue("rl_code", "receipt");
// 			new_rl.setValue("rl_lang", lang);
// 			app_sm.insert(new_rl);
			
			dh_no += dh.getString("dh_no")+";" ;	//rs用-捐款單編號
			
			dh.setValue("rs_no", rs_no);//dh寫入收據編號
			app_sm.update(dh);
		}
		
		out.println("<script> alert('批次收據開立成功(單張)!!'); backdata.submit();  </script>");
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
	}else if("REPLY".equals(action)){
		TableRecord dh = app_sm.select(db_names, "dh_id=?", new Object[]{dh_id});
		dh.setUpdate(app_account);
		dh.setValue("dh_ship", "Y".equals(StringTool.validString(dh.getString("dh_ship")))?"N":"Y");
		app_sm.update(dh);
		// 回列表頁
		out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
		out.println("<script> alert('修改成功!!');listpage.submit(); </script> ");
		return;		
		
	}else if("STATUS".equals(action)){			//變更詢價單狀態
		TableRecord dh = app_sm.select(db_names, "dh_id=?", new Object[]{dh_id});
		dh.setValue("dh_status", "Y".equals(StringTool.validString(dh.getString("dh_status")))?"N":"Y");
		dh.setUpdate(app_account);
		app_sm.update(dh);	
		out.println("<script> backdata.submit();  </script>");
		return;
	}	
}catch(Exception e){
	System.out.println("Project" + projectName + ", Error info:["+e+"]File name edit.jsp for ["+code+"]Time:["+DateTimeTool.dateTimeString()+"]");
	out.println("<script> alert('處理失敗'); history.back(); </script>");
}finally{app_sm.close();}
%>