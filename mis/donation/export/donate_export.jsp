<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="org.apache.xmlbeans.*" %>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.ss.usermodel.*" %>
<%@ page import="org.apache.poi.ss.usermodel.Font" %>
<%@ page import="org.apache.poi.ss.usermodel.Cell" %>
<%@ page import="org.apache.poi.hssf.util.*" %>
<%@ page import="org.apache.poi.xssf.usermodel.*" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFCell" %>
<%@ page import="org.apache.poi.xssf.util.*" %>
<%@ page import="org.apache.poi.xssf.streaming.SXSSFWorkbook" %> 
<%@ page import="org.apache.poi.xssf.streaming.SXSSFSheet" %>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@ include file="/web/include/encryption.jsp"%>
<%@page import="java.util.List"%>
<%
	
	// 以利前端檢查時 , 了解正在進行檔案匯出的工作
	session.setAttribute("donate_file","start");

	String code = "donate";										// 功能識別碼
	
	// Conditions.
	String qname = StringTool.validString(request.getParameter("_qname"));
	String qphone = StringTool.validString(request.getParameter("_qphone"));
	String qdhno = StringTool.validString(request.getParameter("_qdhno"));
	String qpayment = StringTool.validString(request.getParameter("_qpayment"),"");	
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"));
	String qposition = StringTool.validString(request.getParameter("_qposition"));
	String qcollect	 = StringTool.validString(request.getParameter("_qcollect"));

	// Names and values.
	String[] names = new String[] { 
		"npage", "_qname", "_qphone", "_qdhno", "_qpayment", "_qemitdate", "_qrestdate", "_qposition", "_qcollect"
	};
	String[] values = new String[] { 
		String.valueOf(pageno), qname, qphone, qdhno, qpayment, qemitdate, qrestdate, qposition, qcollect
	};

	// Get records.
	StringBuffer sb = new StringBuffer();
	Vector keys = new Vector();
	
	sb.append("dh_code=? AND dh_lang=?");
	keys.add(code);
	keys.add(lang);
	sb.append(" and dh_no like ?");
	keys.add("%"+qdhno+"%");
	sb.append(" and dh_collect like ?");
	keys.add("%"+qcollect+"%");
	sb.append(" and dh_status like ? and dh_name like ?");
	keys.add("%"+qposition+"%");
	keys.add("%"+qname+"%");
	sb.append(" and dh_cellphone like ?");
	keys.add("%"+qphone+"%");
	sb.append("and dh_paymethod like ?");
	keys.add("%"+qpayment+"%");
	sb.append(" and !(dh_createdate>? || dh_createdate<?)");
	keys.add(qrestdate+" 24:00:00");
	keys.add(qemitdate);
	
	Vector<TableRecord> dhs = app_sm.selectAll(tbldh, sb.toString(), keys.toArray() , "dh_createdate DESC");
	
	// 指定位置存相關資料
	int counter = 0;
	if(dhs == null || dhs.size() == 0) {
	   out.write("<script>alert('查無資料可供匯出！');</script>");
	   session.setAttribute("donate_file", "no");
	} else {
		try {
			// 建立新Excel
			// 不使用範本檔，建立新Excel來進行匯出
			XSSFWorkbook wb1 = new XSSFWorkbook();
			SXSSFWorkbook wb = new  SXSSFWorkbook(wb1, 1000, true, true); 			// 大資料數量用 
			SXSSFSheet sheet = wb.createSheet(qemitdate.replace("/","")+"-"+qrestdate.replace("/",""));
			
			// 欄位樣式 & 字型設定
			Font font = wb.createFont();
			font.setFontName("新細明體"); 												// 設定字體
			font.setFontHeightInPoints((short) 12); 								// 設定字體大小

			Font font2 = wb.createFont();
			font2.setFontName("新細明體"); 											// 設定字體
			font2.setFontHeightInPoints((short) 14); 								// 設定字體大小

			// 設定儲存格格式(新版寫法) 
			CellStyle styleRow1 = wb.createCellStyle();
			styleRow1.setAlignment(HorizontalAlignment.CENTER);
			styleRow1.setVerticalAlignment(VerticalAlignment.CENTER);				// 水平置中
			styleRow1.setFont(font); 												// 設定字體

			CellStyle styleRow2 = wb.createCellStyle();
			styleRow2.setAlignment(HorizontalAlignment.CENTER); 					// 水平置中
			styleRow2.setVerticalAlignment(VerticalAlignment.CENTER); 				// 垂直置中
			styleRow2.setFont(font2); 
			
			/*-- 對照表 --*/
			Vector<TableRecord> payments = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=? and cp_display=?", 
					new Object[]{"guide", lang, "Y"}, "cp_showseq ASC, cp_createdate DESC");
			Map<String, String> payment_title_map = new HashMap<String, String>();
			
			for(TableRecord payment:payments) 
				payment_title_map.put(payment.getString("cp_category"),payment.getString("cp_title"));
			
			// 將資料內容寫入指定檔案	 
			String clientFileName = app_account + "_donate_export.xlsx";
			
			// 欄位標題
			String[] field_titles = new String[]{
				"捐款日期", "捐款是否付款", "捐款單編號", "銷帳編號", "姓名", "捐款金額", "身份證字號/統編/居留證號", 
				"電子信箱", "電話", "聯絡電話", "聯絡地址(郵遞區號)", "聯絡地址",  "捐款計畫",
				"計畫代碼", "受贈單位", "捐款屬性", 
				"收據抬頭", "付款方式", "捐款收據", "收據地址(郵遞區號)", "收據地址","備註說明"
			};
			
			
			// 寫資料內容
			for(int i=0;i<dhs.size();i++) {
				TableRecord dh = dhs.get(i);
				TableRecord wh = app_sm.select(tblwh, "data_id=?", new Object[]{dh.getString("dh_id")});
				String dh_pid = new AESDataEncryption().AESDecrypt(dh.getString("dh_pid"));
				String dh_paymethod = payment_title_map.containsKey(dh.getString("dh_paymethod"))?payment_title_map.get(dh.getString("dh_paymethod")):"";
			
				String[] field_values = {
						dh.getString("dh_donatedate"),
						"Y".equals(dh.getString("dh_collect"))?"已付款":"未付款",
						dh.getString("dh_no"),
						wh.getString("wh_account"),
						dh.getString("dh_name"),
						app_df.format(dh.getInt("dh_total")),
						dh_pid,
						dh.getString("dh_email"),
						dh.getString("dh_phone"),
						dh.getString("dh_cellphone"),
						dh.getString("dh_zipcode"),
						dh.getString("dh_county")+dh.getString("dh_city")+dh.getString("dh_address").replace(",", ""),
						dh.getString("dh_donate_project_title"),
						dh.getString("dh_donate_project_no"),
						dh.getString("dh_donate_unit_title"),
						dh.getString("dh_donate_attribute_title"),
						dh.getString("dh_receipt_title"),
						dh_paymethod,
						"Y".equals(dh.getString("dh_receipt_status"))?"寄收據":"不寄收據",
						dh.getString("dh_receipt_zipcode"),
						dh.getString("dh_receipt_county")+dh.getString("dh_receipt_city")+dh.getString("dh_receipt_address").replace(",", ""),
						dh.getString("dh_memo")
				};	
				
				if(i==0){
					Row row = sheet.createRow(counter);
					for(int e=0;e<field_titles.length;e++){
						Cell cell = row.createCell(e);
						
						cell.setCellStyle(styleRow2);					// 套用格式
						cell.setCellValue(field_titles[e]); 			// 填入值
					}
				}
				
				counter++;
				Row row = sheet.createRow(counter);
				for(int e=0;e<field_values.length;e++){
					Cell cell = row.createCell(e);
					
					cell.setCellStyle(styleRow2);						// 套用格式
					cell.setCellValue(field_values[e]); 				// 填入值
					if(i==dhs.size()-1){
						sheet.trackAllColumnsForAutoSizing();								// 自動調整欄位寬度
						sheet.autoSizeColumn(e,false);										// 自動調整欄位寬度
					}
				}
			}
			
			// 無路徑-檔案目錄新增
			File outputFolder = new File(app_uploadpath+ "/export/");
			if (!outputFolder.exists()) {
				outputFolder.mkdir();
			}
			
			// 新增檔案 / 若存在則刪除同檔
			File outputFile = new File(outputFolder, clientFileName);
			if (outputFile.exists()) {
				outputFile.delete();
			}
			
			//輸出
			FileOutputStream fos = new FileOutputStream(outputFile);

			wb.write(fos);
			fos.flush();
			fos.close();

			// 以利前端檢查時 , 了解已完成檔案匯出的工作
			session.setAttribute("donate_file", "end");
		} catch(Exception e){
			out.write("<script>alert('匯出失敗！');</script>");
			session.setAttribute("donate_file", "error");
			System.out.println(e.getMessage());
		}
	}
%>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>