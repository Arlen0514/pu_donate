<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@page import="java.util.List"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<%
	
	// 以利前端檢查時 , 了解正在進行檔案匯出的工作
	session.setAttribute("taxes_file","start");

	String code = "receipt";										// 功能識別碼
	String fileLocation = app_uploadpath + "/root/report/";			// 檔案位置
	String fileName = app_account + "_taxes_export.csv";			// 檔案名稱
	
	// CSV欄位標題
	String[] titles = new String[] {
		" 捐贈年度","捐贈者身份證統一編號", "捐贈者姓名", "捐款金額", 
		"受捐贈單位統一編號", "捐贈別", "受捐贈者名稱", "專案核准文號"
	};
	
	
	String taxes_no = SiteSetup.getValue("taxes.no");
	String taxes_docno = SiteSetup.getValue("taxes.docno");
	String taxes_name = SiteSetup.getValue("taxes.name");

	// Conditions.
	String qpayment = StringTool.validString(request.getParameter("_qpayment"));
	String qdhno = StringTool.validString(request.getParameter("_qdhno"));
	String qname = StringTool.validString(request.getParameter("_qname"));
	
	String qgrade = StringTool.validString(request.getParameter("_qgrade"),"D");
	String qyear = StringTool.validString(request.getParameter("_qyear"),String.valueOf(DateTimeTool.getYear()));
	String qmonth = StringTool.validString(request.getParameter("_qmonth"),String.valueOf(DateTimeTool.getMonth()));
	String qday = StringTool.validString(request.getParameter("_qday"),String.valueOf(DateTimeTool.getDay()));
	
	
	String qrlno	 = StringTool.validString(request.getParameter("_qrlno"));
	String action = StringTool.validString(request.getParameter("action"));
	
	// Names and values.
	String[] names = new String[] { "npage",  "_qname", "_qdhno","_qpayment",  "_qgrade", "_qyear",  "_qmonth",  "_qday",  "_qrlno", "action"};
	String[] values = new String[] { String.valueOf(pageno), qname, qdhno, qpayment, qgrade,  qyear,  qmonth,  qday,  qrlno, action };
	
	String s_m = qmonth, s_d = qday;
	
	// Get records.
	StringBuffer sb = new StringBuffer();
	Vector keys = new Vector();
	
	sb.append("rs_code=? AND rs_lang=?");
	keys.add(code);
	keys.add(lang);
	sb.append(" and rs_status =  ?");		// 新增 收據狀態
	keys.add("Y");
	sb.append(" and dh_order_name like ?");
	keys.add("%"+qname+"%");
	sb.append(" and rs_no like ?");			//收據編碼
	keys.add("%"+qrlno+"%");
	if("Y".equals(qgrade)){
		sb.append(" and rs_createdate like ?");			//收據編碼
		keys.add(qyear+"/%");
	}else if("M".equals(qgrade)){
		if(qmonth.length()==1) s_m = "0"+qmonth;
		sb.append(" and rs_createdate like ?");			//收據編碼
		keys.add(qyear+"/"+s_m+"/%");
	}else {
		if(qmonth.length()==1) s_m = "0"+qmonth;
		if(qday.length()==1) s_d = "0"+s_d;
		sb.append(" and rs_createdate like ?");			//收據編碼
		keys.add(qyear+"/"+s_m+"/"+s_d+"%");
	}
	
	Vector<TableRecord> datas = app_sm.selectAll(tblrs, sb.toString(), keys.toArray() , "rs_createdate DESC");
	
	// 檢查是否有資料可以供匯出
	if(datas == null || datas.size() == 0) {
	   out.write("<script>alert('查無資料可供匯出！');</script>");
	   session.setAttribute("taxes_file", "no");
	   return;
	}

	/*-- 將CSV檔的輸出位置設定為uploads/root/report資料夾下 --*/	
	File outputFolder = new File(fileLocation);
	if(!outputFolder.exists()) {
		outputFolder.mkdir();
	}
	File outputFile = new File(outputFolder, fileName);
	if(outputFile.exists()) {
		outputFile.delete();
	}

	/*-- 資料寫入CSV檔內(csv檔案是逗號分隔，除第一個外，每次寫入一個單元格資料後需要輸入逗號) --*/
	
	FileOutputStream fos  = new FileOutputStream(outputFile);
    fos.write(0xef);
    fos.write(0xbb);
    fos.write(0xbf);
	
	OutputStreamWriter ow = new OutputStreamWriter(fos, "UTF-8");

	
	double all_money = 0;
	for(TableRecord data:datas) {

		Vector <TableRecord> rss = app_sm.selectAll(tblrs,sb.toString(), keys.toArray() , "rs_date DESC ");
		/*--------------------------日期計算------------------------------*/
		Calendar c = Calendar.getInstance();
		String today = String.valueOf(c.get(Calendar.YEAR)-1911);
		/*--------------------------日期計算------------------------------*/
		// 不匯出公司
		String os_pid = "";
		java.util.regex.Pattern p = java.util.regex.Pattern.compile("[a-zA-z]");
		if(p.matcher(data.getString("dh_pid")).find()) {
			os_pid = data.getString("dh_pid");
		} else {
			continue;
		}

		// 寫資料內容(因為金額千元以上會有,符號，所以用Tab間隔)
		ow.write(today);
		ow.write("|");
		ow.write(os_pid);
		ow.write("|");
		ow.write(data.getString("dh_order_name"));
		ow.write("|");
		ow.write(String.valueOf(data.getInt("dh_total")));
		ow.write("|");
		ow.write(taxes_no);
		ow.write("|");
		ow.write("55");
		ow.write("|");
		ow.write(taxes_name);
		ow.write("|");
		ow.write(taxes_docno);
		ow.write("\r\n");
	}

	ow.flush();
	ow.close();
	
	/*-- 下載CSV檔 --*/
	if(outputFile.exists() && outputFile.isFile()) {
		try {
		   	String mimetype = getServletConfig().getServletContext().getMimeType(fileLocation + fileName);
		   	response.setContentType((mimetype != null)?mimetype:"application/octet-stream");
		   	response.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20") + "\""); 
		   	OutputStream output = response.getOutputStream();
	   	   	InputStream in = new FileInputStream(outputFile);
		   	byte[] b = new byte[2048];
		   	int len;
		   	while((len = in.read(b)) > 0) {
				output.write(b,0,len);
		   	}
		   	in.close();
		   	output.flush();
		   	output.close();
		   	out.clear(); 
		   	out = pageContext.pushBody();
		   	
	   	} catch(Exception ex) {
		   	out.println("<script> alert('檔案處理失敗'); history.back(); </script>");
		   	return;
	   	}
   	} else {
	   	out.println("<script> alert('此檔案不存在'); history.back(); </script>");
	   	return;
	}
	
	// 以利前端檢查時 , 了解已完成檔案匯出的工作
	session.setAttribute("taxes_file", "end");
%>
