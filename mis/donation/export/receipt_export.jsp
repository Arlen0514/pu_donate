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
<%

	// 以利前端檢查時 , 了解正在進行檔案匯出的工作
	session.setAttribute("receipt_file", "start");

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
	
	qposition = "Y";
	qcollect = "Y";
	
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
		session.setAttribute("receipt_file", "no");
	} else {
		try {
			//建立新Excel
			// 不使用範本檔，建立新Excel來進行匯出
			XSSFWorkbook wb1 = new XSSFWorkbook();
			SXSSFWorkbook wb = new  SXSSFWorkbook(wb1, 1000, true, true); 			// 大資料數量用 
			SXSSFSheet sheet = wb.createSheet(DateTimeTool.dateString("").substring(2));
			
			// 欄位樣式 & 字型設定
			Font font = wb.createFont();
			font.setFontName("新細明體"); 												// 設定字體
			font.setFontHeightInPoints((short) 12); 								// 設定字體大小

			Font font2 = wb.createFont();
			font2.setFontName("新細明體"); 											// 設定字體
			font2.setFontHeightInPoints((short) 14); 								// 設定字體大小

			// 設定儲存格格式(新版寫法) 
			CellStyle styleRow1 = wb.createCellStyle();
			styleRow1.setAlignment(HorizontalAlignment.LEFT); 						// 水平置左
			styleRow1.setVerticalAlignment(VerticalAlignment.CENTER);	 			// 垂直置中
			styleRow1.setFont(font); 												// 設定字體

			CellStyle styleRow2 = wb.createCellStyle();
			styleRow2.setAlignment(HorizontalAlignment.LEFT); 						// 水平置左
			styleRow2.setVerticalAlignment(VerticalAlignment.CENTER); 				// 垂直置中
			styleRow2.setFont(font2); 		

			// 將資料內容寫入指定檔案	 
			String clientFileName = app_account + "_receipt_export.xlsx";
			
			// 欄位標題
			String[] field_titles = new String[]{
				"字軌","收據號碼","印刷號碼","日期","金額",
				"繳款人","銷帳編號","繳款方式(請填代碼0無1現金2匯款3支票4匯票5帳沖6其它7台灣PAY8LINE PAY50信用卡手續費)","事由","備註","科目(科目代碼)",
				"支票號碼","支票日期","付款銀行(銀行代碼)","收款狀態(1 正常、2 預開、3 有款無據)","發票人帳號",
				"計畫代碼","外系統單號","繳款日期","匯票號碼","身分證/統編",
				"捐贈款","分組","匯款日期","申請人","收款帳戶"
			};
			
			// 欄位預設
			String[] field_values = new String[]{
				"靜捐字","","","","",
				"","","","","(一)本收據可為所得稅報稅憑證，請妥為保存。(二)所得稅法第十七條第二項第二款規定捐贈教育機構得列舉扣除所得，屬於對政府捐獻，不受金額限制。","",
				"","","","1","",
				"","","","","",
				"","","","",""
			};
			
			// 付款方式
			Vector<TableRecord> payments = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=? and cp_display=?", 
					new Object[]{"guide", lang, "Y"}, "cp_showseq ASC, cp_createdate DESC");
			Map<String, String> payment_title_map = new HashMap<String, String>();
			
			for(TableRecord payment:payments) 
				payment_title_map.put(payment.getString("cp_category"),payment.getString("cp_no"));
			
			for(int i=0;i<dhs.size();i++){
				TableRecord dh = dhs.get(i);
				TableRecord wh = app_sm.select(tblwh, "data_id=?", new Object[]{dh.getString("dh_id")});
				String dh_donate_project_title = dh.getString("dh_donate_project_title")+"("+dh.getString("dh_donate_project_no")+")";
				
				field_values[4] = String.valueOf(dh.getInt("dh_total"));
				field_values[5] = dh.getString("dh_name");
				field_values[6] = wh.getString("wh_account");
				field_values[7] = payment_title_map.get(dh.getString("dh_paymethod"));
				field_values[8] = "捐款〈"+dh_donate_project_title+"〉 統編：00501503";
				
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
					
					cell.setCellStyle(styleRow1);					// 套用格式
					cell.setCellValue(field_values[e]); 			// 填入值
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
			session.setAttribute("receipt_file", "end");
		} catch (Exception e) {
			out.write("<script>alert('匯出失敗！');</script>");
			session.setAttribute("receipt_file", "error");
			System.out.println(e.getMessage());
		}
	}
%>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>