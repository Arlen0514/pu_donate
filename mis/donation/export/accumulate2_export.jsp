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
	session.setAttribute("accumulate2_file", "start");

	String code = "donate";										// 功能識別碼
	
	// Conditions.
	String qname = StringTool.validString(request.getParameter("_qname"));
	String qphone = StringTool.validString(request.getParameter("_qphone"));
	String qemail = StringTool.validString(request.getParameter("_qemail"));
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"));
	String donate_project = StringTool.validString(request.getParameter("donate_project"),"all");

	// Names and values.
	String[] names = new String[] { 
		"npage", "_qname", "_qphone", "_qemail", "_qemitdate", "_qrestdate", "donate_project"
	};
	String[] values = new String[] { 
		String.valueOf(pageno), qname, qphone, qemail, qemitdate, qrestdate, donate_project
	};
	
	// Get records.
	// 會員資料
	StringBuffer sb = new StringBuffer();
	Vector keys = new Vector();
	
	sb.append("mp_code=? and mp_name like ? ");
	keys.add("member");
	keys.add("%"+qname+"%");
	sb.append("and mp_email like ? and mp_cellphone like ?");
	keys.add("%"+qemail+"%");
	keys.add("%"+qphone+"%");
	
	Vector<TableRecord> mps = app_sm.selectAll(tblmp, sb.toString(), keys.toArray() , "mp_total DESC, mp_createdate DESC");
	Map<String, TableRecord> member_info_map = new HashMap<String, TableRecord>();
	
	for(TableRecord mp:mps) member_info_map.put(mp.getString("mp_id"), mp);
	
	// 捐款資料
	StringBuffer sb2 = new StringBuffer();
	Vector keys2 = new Vector();
	
	sb2.append("dh_code=? AND dh_lang=? ");
	keys2.add("donate");
	keys2.add(lang);
	sb2.append("and dh_collect=? and dh_status=? ");
	keys2.add("Y");
	keys2.add("Y");
	sb2.append("and dh_donate_project_category='' ");
	if(!"all".equals(donate_project)){
		sb2.append("and dh_donate_project = ?");
		keys2.add(donate_project);
	}
	sb2.append("and !(dh_createdate>? || dh_createdate<?)");
	keys2.add(qrestdate+" 24:00:00");
	keys2.add(qemitdate);
	
	Vector<TableRecord> dhs = app_sm.selectAll(tbldh, sb2.toString(), keys2.toArray() , "dh_donatedate ASC, dh_createdate DESC");

	// 指定位置存相關資料
	int counter = 0;
	if(dhs == null || dhs.size() == 0) {
		out.write("<script>alert('查無資料可供匯出！');</script>");
		session.setAttribute("accumulate2_file", "no");
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
			
			// 背景底色
			CellStyle[] styleWithBgColors = new CellStyle[4];
			
			for(int i=0;i<4;i++){
				CellStyle style = wb.createCellStyle();
				
				style.setAlignment(HorizontalAlignment.CENTER);
				style.setVerticalAlignment(VerticalAlignment.CENTER);						// 水平置中
				
				// 背景顏色
				if(i==0) style.setFillForegroundColor(IndexedColors.CORAL.getIndex());		
				if(i==1) style.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());		
				if(i==2) style.setFillForegroundColor(IndexedColors.LIGHT_TURQUOISE.getIndex());		
				if(i==3) style.setFillForegroundColor(IndexedColors.TAN.getIndex());		
				
				style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
				style.setFont(font); 														// 設定字體
			
				styleWithBgColors[i] = style;
			}

			// 將資料內容寫入指定檔案	 
			String clientFileName = app_account + "_accumulate_export.xlsx";
			
			// 欄位標題
			String[] field_titles = new String[]{
					"姓名", "聯絡電話", "電子信箱", "累計金額", ""
			};
			
			// 欄位預設
			String[] field_values = new String[]{
					"", "", "", "", ""
			};
			
			// 統計資料
			Map<String, JSONObject> donate_info_map = new HashMap<String, JSONObject>();
			Vector<String> key_set = new Vector<String>();
			
			for(TableRecord dh:dhs){
				JSONObject donate_info = new JSONObject();
				String key = dh.getString("mp_id");
				boolean in_list = member_info_map.containsKey(key);
				
				if(in_list){
					int dh_total = dh.getInt("dh_total");
					
					if(donate_info_map.containsKey(key)) {
						donate_info = donate_info_map.get(key);
						dh_total += donate_info.getInt("dh_total");
					} else {
						donate_info.put("mp_id", key);
						key_set.add(key);
					}
					donate_info.put("dh_total", dh_total);
					donate_info_map.put(key, donate_info);
				}
			}
			
			key_set.sort(Comparator.comparingInt(key -> donate_info_map.get(key).getInt("dh_total")).reversed()
			    				   .thenComparing(key -> donate_info_map.get(key).getString("mp_id")));
			
			// 等級顏色
			Map<Integer, String> color_range_type = new HashMap<Integer, String>();
			Map<Integer, String> color_range_name = new HashMap<Integer, String>();
			String[] tag_names = {"1000W", "500W", "100W", "10W"};
			int[] total_range = {1000, 500, 100, 10};						// 要先乘以10000再判斷
			
			for(int i=0;i<total_range.length;i++) color_range_name.put(total_range[i], tag_names[i]);
			
			for(int i=0;i<key_set.size();i++){ 
				String key = key_set.get(i);
				JSONObject donate_info = donate_info_map.get(key);
				TableRecord mp = member_info_map.get(key);
				int total = donate_info.getInt("dh_total");
				int color_index = -1;
				String tag_str = "";
				
				for(int k=0;k<total_range.length;k++){
					if(total >= (total_range[k]*10000)){
						color_index = k;
						tag_str     = tag_names[k]+"達標";
						break;
					}
				}
				
				if(i==0){
					Row row = sheet.createRow(counter);
					for(int e=0;e<field_titles.length;e++){
						Cell cell = row.createCell(e);
						
						cell.setCellStyle(styleRow2);					// 套用格式
						cell.setCellValue(field_titles[e]); 			// 填入值
					}
				}
				
				field_values[0] = mp.getString("mp_name");
				field_values[1] = mp.getString("mp_cellphone");
				field_values[2] = mp.getString("mp_email");
				field_values[3] = app_df.format(total);
				field_values[4] = tag_str;
				
				counter++;
				Row row = sheet.createRow(counter);
				for(int e=0;e<field_values.length;e++){
					Cell cell = row.createCell(e);
					
					// 套用格式
					if(color_index>0) cell.setCellStyle(styleWithBgColors[color_index]);
					else cell.setCellStyle(styleRow2);
					
					cell.setCellValue(field_values[e]); 						// 填入值
					if(i==key_set.size()-1){
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
			session.setAttribute("accumulate2_file", "end");
		} catch (Exception e) {
			out.write("<script>alert('匯出失敗！');</script>");
			session.setAttribute("accumulate2_file", "error");
			System.out.println(e.getMessage());
		}
	}
%>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>