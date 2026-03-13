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
	session.setAttribute("thing_file","start");

	String code = "thing";										// 功能識別碼
	
	// Conditions.
	String qname 	 = StringTool.validString(request.getParameter("_qname"));
	String qphone 	 = StringTool.validString(request.getParameter("_qphone"));
	String qdhno 	 = StringTool.validString(request.getParameter("_qdhno"));
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"));
	String qposition = StringTool.validString(request.getParameter("_qposition"));

	// Names and values.
	String[] names = new String[] { 
		"npage", "_qname", "_qphone", "_qdhno", "_qemitdate", "_qrestdate", "_qposition"
	};
	String[] values = new String[] { 
		String.valueOf(pageno), qname, qphone, qdhno,  qemitdate, qrestdate, qposition
	};

	// Get records.
	StringBuffer sb = new StringBuffer();
	Vector keys = new Vector();
	
	sb.append("dh_code=? AND dh_lang=?");
	keys.add(code);
	keys.add(lang);
	sb.append(" and dh_no like ?");
	keys.add("%"+qdhno+"%");
	sb.append(" and dh_status like ? and dh_name like ?");
	keys.add("%"+qposition+"%");
	keys.add("%"+qname+"%");
	sb.append(" and dh_phone like ?");
	keys.add("%"+qphone+"%");
	sb.append(" and !(dh_createdate>? || dh_createdate<?)");
	keys.add(qrestdate+" 24:00:00");
	keys.add(qemitdate);
	
	Vector<TableRecord> dhs = app_sm.selectAll(tbldh, sb.toString(), keys.toArray() , "dh_createdate DESC");
	
	// 指定位置存相關資料
	int counter = 0;
	if(dhs == null || dhs.size() == 0) {
	   out.write("<script>alert('查無資料可供匯出！');</script>");
	   session.setAttribute("thing_file", "no");
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
			
			// 將資料內容寫入指定檔案	 
			String clientFileName = app_account + "_thing_export.xlsx";
			
			// 欄位標題
			String[] field_titles = new String[]{
				"捐物日期", "捐物單編號", "姓名", "身份證字號/統編/居留證號", "電子信箱", 
		 		"電話", "聯絡電話", "聯絡地址", "財務屬性", "財務名稱",
		 		"捐物數量", "型式規格", "購置金額", "放置日期", "放置地點", 
		 		"捐贈用途"
			};
			
			AESDataEncryption ade = new AESDataEncryption();
			
			// 寫資料內容
			for(int i=0;i<dhs.size();i++) {
				TableRecord dh = dhs.get(i);
				String dh_pid = dh.getString("dh_pid");
			
				if(!"".equals(dh_pid) && dh_pid.contains("==")) dh_pid = ade.AESDecrypt(dh_pid);
				
				String[] field_values = {
						dh.getString("dh_donatedate"),
						dh.getString("dh_no"),
						dh.getString("dh_name"),
						dh_pid,
						dh.getString("dh_email"),
						dh.getString("dh_phone"),
						dh.getString("dh_cellphone"),
						dh.getString("dh_zipcode")+dh.getString("dh_county")+dh.getString("dh_city")+dh.getString("dh_address").replace(",", ""),
						dh.getString("dh_donate_project_category").replace("1","財產").replace("2","非消耗品").replace("3","消耗品"),
						dh.getString("dh_financialname"),
						dh.getString("dh_num"),
						dh.getString("dh_typespec"),
						app_df.format(dh.getInt("dh_total")),
						dh.getString("dh_placedate"),
						dh.getString("dh_placelocaction"),
						dh.getString("dh_donate_project").replace("1","未指定").replace("2","指定單位").replace("3","指定用途")  + " " + dh.getString("dh_donate_project_title")
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
			session.setAttribute("thing_file", "end");
		} catch(Exception e){
			out.write("<script>alert('匯出失敗！');</script>");
			session.setAttribute("thing_file", "error");
			System.out.println(e.getMessage());
		}
	}
%>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>