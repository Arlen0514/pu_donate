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
<%@ include file="/WEB-INF/jspf/config.jspf" %>
<%@ include file="/WEB-INF/jspf/mis/check.jspf" %>
<%--
// 新版poi(4.1.2) 匯出 xlsx 所需要的檔案如下
WEB-INF/lib/
	commons-codec-1.3.jar
	commons-collections4-4.4.jar
	commons-compress-1.21.jar
	poi-4.1.2.jar
	poi-ooxml-schemas-4.1.2.jar
	poi-ooxml.jar
	poi-scratchpad.jar
	xmlbeans-3.1.0.jar

// 舊版poi(3.6) 匯出xls 所需要的檔案如下
WEB-INF/lib/
	poi-3.6.jar
	log4j-1.2.7.jar

// 舊專案更新POI套件時請將舊版套件刪掉。
// 新版與舊版寫法不同，更新時也要記得把所有的EXCEL匯出改寫一次。
--%>
<%
	// 以利前端檢查時 , 了解正在進行檔案匯出的工作
	session.setAttribute("menu_file","start");

   	// Names and values.
   	String[] names = new String[] { "" };
   	String[] values = new String[] { "" };
   	
   	// Get records.
   	Vector <TableRecord> datas = app_sm.selectAll(tblmf, "mf_upfunction=? AND mf_type=?", new String[]{ "", "1" }, "mf_priority ASC");

	// 指定位置存相關資料
	int counter = 0;
	// 檢查是否有資料可以供匯出
	if(datas == null || datas.size() == 0) {
	   out.write("<script>alert('查無資料可供匯出！');</script>");
	   session.setAttribute("menu_file", "no");
	} else {
	    // 將資料內容寫入指定檔案
		String clientFileName = app_account + "_menu_export.xlsx";

	    try {
			// 不使用範本檔，建立新Excel來進行匯出
			XSSFWorkbook wb1 = new XSSFWorkbook();

			SXSSFWorkbook wb = new  SXSSFWorkbook(wb1, 1000, true, true); 			// 大資料數量用 
			SXSSFSheet sheet = wb.createSheet("功能清單");

			/*-- 將資料內容寫入指定檔案 --*/
			// 欄位名稱
			String[] fildnames = {
				"選單標籤名稱", "選單功能名稱", "選單功能名稱"
			};

			// 欄位樣式 & 字型設定
			Font font = wb.createFont();
			font.setFontName("新細明體"); 											// 設定字體
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
			styleRow2.setFont(font2); 												// 設定字體

			for(int i = 0; i < datas.size(); i++) {
				TableRecord data = datas.get(i);

				/*-- 第1層選單 --*/
				String mf_name_1 = data.getString("mf_name");
				String mf_url_1 = data.getString("mf_url");
				String mf_title_1 = mf_name_1;
				if(!"".equals(mf_url_1)) {
					mf_title_1 += " - " + mf_url_1;
				}

				// 放進去的資料
				String[] export_1 = {
					mf_title_1
				};

				// 先填入欄位名稱
				if(i == 0) {
					Row row = sheet.createRow(counter);
					for (int e = 0; e < fildnames.length; e++) {
						Cell cell = row.createCell(e);
						cell.setCellStyle(styleRow2); 								// 套用格式
						cell.setCellValue(fildnames[e]); 							// 填入值
						/*
						sheet.trackAllColumnsForAutoSizing();						// 自動調整欄位寬度
						sheet.autoSizeColumn(e,false);								// 自動調整欄位寬度
						*/
					}
				}

				// 新增一列空白列 開始放入資料
				counter++;
				Row row = sheet.createRow(counter);

				for(int e = 0; e < export_1.length; e++) {
					Cell cell = row.createCell(e);
					cell.setCellStyle(styleRow1);									// 套用格式
					cell.setCellValue(export_1[e]);									// 填入值
					if(i == datas.size() - 1) {
						sheet.trackAllColumnsForAutoSizing();						// 自動調整欄位寬度
						sheet.autoSizeColumn(e,false);								// 自動調整欄位寬度
					}
				}
				
				/*-- 第2層選單 --*/
				Vector<TableRecord> mf2s = app_sm.selectAll(tblmf, "mf_upfunction=? AND mf_type=?", new String[]{ data.getString("mf_id"), "2" }, "mf_priority ASC");
				for(TableRecord mf2:mf2s) {
					String mf_name_2 = mf2.getString("mf_name");
					String mf_url_2 = mf2.getString("mf_url");
					String mf_title_2 = mf_name_2;
					if(!"".equals(mf_url_2)) {
						mf_title_2 += " - " + mf_url_2;
					}

					// 放進去的資料
					String[] export_2 = {
						"|->", mf_title_2
					};

					// 新增一列空白列 開始放入資料
					counter++;
					row = sheet.createRow(counter);

					for(int e = 0; e < export_2.length; e++) {
						Cell cell = row.createCell(e);
						cell.setCellStyle(styleRow1);								// 套用格式
						cell.setCellValue(export_2[e]);								// 填入值
						if(i == datas.size() - 1) {
							sheet.trackAllColumnsForAutoSizing();					// 自動調整欄位寬度
							sheet.autoSizeColumn(e,false);							// 自動調整欄位寬度
						}
					}
					
					/*-- 第3層選單 --*/
					Vector<TableRecord> mf3s = app_sm.selectAll(tblmf, "mf_upfunction=? AND mf_type=?", new String[]{ mf2.getString("mf_id"), "3" }, "mf_priority ASC");
					for(TableRecord mf3:mf3s) {
						String mf_name_3 = mf3.getString("mf_name");
						String mf_url_3 = mf3.getString("mf_url");
						String mf_title_3 = mf_name_3;
						if(!"".equals(mf_url_3)) {
							mf_title_3 += " - " + mf_url_3;
						}

						// 放進去的資料
						String[] export_3 = {
							"", "|->", mf_title_3
						};

						// 新增一列空白列 開始放入資料
						counter++;
						row = sheet.createRow(counter);

						for(int e = 0; e < export_3.length; e++) {
							Cell cell = row.createCell(e);
							cell.setCellStyle(styleRow1);							// 套用格式
							cell.setCellValue(export_3[e]);							// 填入值
							if(i == datas.size() - 1) {
								sheet.trackAllColumnsForAutoSizing();				// 自動調整欄位寬度
								sheet.autoSizeColumn(e,false);						// 自動調整欄位寬度
							}
						}
					}
				}
				counter++;
			}

			// 無路徑-檔案目錄新增
			File outputFolder = new File(app_uploadpath + "/export/");
			if(!outputFolder.exists()) {
				outputFolder.mkdir();
			}

			// 新增檔案 / 若存在則刪除同檔
			File outputFile = new File(outputFolder, clientFileName);
			if(outputFile.exists()) {
				outputFile.delete();
			}

			// 輸出
			FileOutputStream fos = new FileOutputStream(outputFile);

			wb.write(fos);
			fos.flush();
			fos.close();

			// 以利前端檢查時 , 了解已完成檔案匯出的工作
			session.setAttribute("menu_file", "end");
		} catch (Exception e) {
			session.setAttribute("menu_file", "error");
			System.out.println("Project:" + projectName + ", Error info:" + e.getMessage() + ", File name menu_export.jsp, Time:" + DateTimeTool.dateTimeString());
		}
	}
%>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>