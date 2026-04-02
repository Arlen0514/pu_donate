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
<%@ page language="java" import="java.sql.*" errorPage=""%>
<%@ page import="java.util.List" %>
<%
	String code	= "donate";			// 頁面代碼
	String show_title = "捐款資訊匯入";				// 功能標題
	String ul_file = "";
	String cf_year = "";			// 年度
	
	try {
		//檔案路徑與設置
	    String dir = app_uploadpath+"/import";
		DiskFileUpload fu = new DiskFileUpload();
		fu.setHeaderEncoding("UTF-8");//亂碼關鍵(1)
		fu.setSizeMax(4194304); //設置文件大小
		fu.setSizeThreshold(4096); //設置緩衝大小
		fu.setRepositoryPath(dir); //設置臨時目錄     
		List fileItems = fu.parseRequest(request);
		Iterator i = fileItems.iterator();

		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			if (fi.isFormField()) { //這是用來確定是否為文件屬性 
				// 讀取匯入類別
				String fieldName = new String(fi.getFieldName()); //取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); //取得值
				
				if("cf_year".equals(fieldName)){
					cf_year = fieldvalue.trim();
				}
			} else {
				int g = fi.getName().lastIndexOf("\\");
				String fileName = fi.getName();
				String fileName_1 = "";
				if(g < 0) {
		        	fileName = fi.getName();//兼容非ie
		         	fileName_1 = fi.getName();
		        } else {
		        	fileName = fi.getName().substring(g);//取得上傳文件名
		        	fileName_1 = fileName.substring(1,fileName.length());
		      	}
				if (fileName != null && !"".equals(fileName)) {
					String chk_str = fileName;
					fi.write(new File(dir, fileName_1));
					ul_file = fileName_1;
				}
			}
		}
	} catch(Exception e) {
		System.out.println("Project:" + projectName + ", Error info:["+e+"]File name edit.jsp for [donate_import_update]Time:["+DateTimeTool.dateTimeString()+"]");
		out.println("<script> alert('檔案上傳處理失敗，請與管理人員聯絡 !!'); history.back(); </script>");
	} finally {
		app_sm.close();
	}
%>
<html><!-- InstanceBegin template="/Templates/market.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<%@include file="include/head.jsp"%>
<%@ include file="/WEB-INF/jspf/norobots.jspf" %>
<!-- InstanceBeginEditable name="doctitle" -->
<title><%=app_mistitle %></title>
<script language="JavaScript" type="text/JavaScript">
function checkform(F) {
	var file_chk = /([^\/]+\.(?:xlsx))/;		// 驗證副檔名
		return true;
}
</script>
<!-- InstanceBeginEditable name="head" --><!-- InstanceEndEditable -->
</head>

<body class="default_body">
<div class="pageContent default_pageContent">
<div align="center" class="default_area">
  <table width="1280" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td colspan="2"><table width="1280" border="0" cellspacing="0" cellpadding="0">        
		<%@ include file="/WEB-INF/jspf/mis/top.jspf" %>
      </table></td>
    </tr>
    <tr class="default_table_bottom page_mis">
      <td width="" align="center" valign="top" class="system_bk-2">
  		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<%@include file="../leftmenu.jsp"%>          
  		</table>
  	  </td>
  	  
      <td width="99%" align="center" valign="top" class="system_bk-2p right_content_style"><!-- InstanceBeginEditable name="system-page" -->
        <table width="99%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="2" class="web_bk-2b">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td width="8%" align="left" valign="middle"><img src="../images/web_icon_1.gif" width="55" height="48" /></td>
            <td width="92%" align="left" valign="middle" class="web_bigword"><%=show_title %></td>
          </tr>
          <tr>
            <td colspan="2"><hr size="1" noshade></td>
          </tr>

          <tr align="center">
            <td colspan="2"><table width="95%"  border="0" cellspacing="1" cellpadding="0">
            	<tr align="center">
                	<td class="web_title-1"><%=show_title %></td>
            	</tr>
             	<tr class="web_bk-2">
                	<td width="50%" align="center">
                   		<%=show_title %>
                   	</td>
               	</tr>
             	<tr class="web_table-2-1">
                	<td align="center">
                	<%
                	/*-- 讀取欲匯入的 Execl 檔 --*/
                    XSSFWorkbook wb = new XSSFWorkbook(session.getServletContext().getResourceAsStream("/uploads/import/"+ul_file));
                	XSSFSheet sheet = wb.getSheetAt(0);

                	// 獲取Excel的列數
                	int rows = sheet.getPhysicalNumberOfRows();
                	Vector in_db = new Vector();
                	String error_str = "";
                	
                	// 欄位資料
//             		String[] fieldname = { "dh_name", "dh_public", "dh_pid", "dh_birthday", "dh_phone", "dh_county", "dh_city", 
// 						"dh_zipcode", "dh_address", "dh_email", "dh_donate_item", "dh_receipt_title", "dh_total", "dh_paymethod","dh_receipt_type",
// 						"dh_receipt_county", "dh_receipt_city", "dh_receipt_zipcode", "dh_receipt_address", "dh_donatedate"};
                	
            		String[] fieldname = { 
            				"dh_donate_item_title","dh_donate_item_category", "dh_donatedate", "dh_total", "dh_receipt_type", "dh_name", "dh_pid", "dh_phone", 
    						"dh_email", "dh_address", "dh_public"/*, "dh_total_c"*/, "dh_paymethod"/*, "dh_publicname"*/};
            		String[] fieldname_title = { 
            				"專案名稱","專案別", "應扣款日期", "扣款金額", "開立方式", "捐款人姓名", "身分證字號", "聯絡電話", 
    						"聯絡Email", "收件地址", "匿名否",/* "扣款金額", */"來源"/*, "公開徵信"*/};
                	
            		// 必填欄位
            		String[] required_fields = {
            				"dh_donate_item_title","dh_donate_item_category", "dh_donatedate", "dh_total", "dh_receipt_type", /*"dh_name", *//*"dh_phone",*/ 
     						 "dh_public",/* "dh_total_c",*/ "dh_paymethod"/*, "dh_publicname"*/
            		};
            		String[] required_fields_title  = {
            				"專案名稱","專案別", "應扣款日期", "扣款金額", "開立方式",/* "捐款人姓名", "聯絡電話", */
     						 "匿名否", /*"扣款金額", */"來源"/*, "公開徵信"*/
            		};
            		
            		
            		Vector<String> require_datas = new Vector<String>(Arrays.asList(required_fields));

                	// 第0列為欄位名稱, 故而從第1列開始讀取 !!(程式有0列)
                    int import_counter = 0;			//  計算匯入總筆數 20230526 May
                    boolean all_can_into = true;
                    Vector<TableRecord> dhs = app_sm.selectAll(tbldh," dh_code='temp'",new Object[]{});
                    Vector<TableRecord> rss = app_sm.selectAll(tblrs," rs_code='temp'",new Object[]{});
//                     System.out.println(dhs.size());
                    int error_count = 0;
//                     System.out.println("rows :"+rows);
                    for(int ex = 1; ex < rows; ex++) {
                		String[] fieldvalue = new String[fieldname.length];
                		Arrays.fill(fieldvalue, "");
                		boolean can_into = true;
                		boolean has_error = false;
                		boolean is_end = false;
//                     	int error_count = 0;
                   		
                    	Row row = sheet.getRow(ex);
                		if (row != null) {
                			for(int j=0;j<fieldname.length;j++){
                				if(row.getCell(j) != null) {
                					if(row.getCell(j).getCellType() == CellType.STRING) {
                						row.getCell(j).setCellType(CellType.STRING);
                						
                						// 若包含超連結，取出超連結地址
                						if (row.getCell(j).getHyperlink() != null) 
                							fieldvalue[j] = row.getCell(j).getHyperlink().getAddress();
                				        else
                							fieldvalue[j] = row.getCell(j).getStringCellValue();
                					} else if(DateUtil.isCellDateFormatted(row.getCell(j))){ // 匯入為日期格式
                						DataFormatter dataFormatter = new DataFormatter();
                						SimpleDateFormat targetFormat = new SimpleDateFormat("yyyy/MM/dd");
										// String formattedDate = dataFormatter.formatCellValue(row.getCell(j));

                	                 	// If you want a specific date format, you can parse and format the date
                	                    try {
                	                    	fieldvalue[j] = targetFormat.format(row.getCell(j).getDateCellValue());
                	                        // System.out.println("Formatted Date: " + finalFormattedDate);
                	                    } catch (Exception e) {
                	                        // e.printStackTrace();
                	                    }
                					} else if(row.getCell(j).getCellType() == CellType.NUMERIC) {
                						row.getCell(j).setCellType(CellType.STRING);
                						fieldvalue[j] = row.getCell(j).getStringCellValue();
                					}
                				} else {
                					fieldvalue[j] = "";
//                 					if(require_datas.indexOf(fieldname[j])>-1) can_into = false;
//                 					if(require_datas.indexOf(fieldname[j])>-1) all_can_into = false;
                				}
                			}
                			
                			for(int j=0;j<fieldname.length;j++){
                				if(!"".equals(fieldvalue[j])){
                					is_end = true;
                					 break;
                				}
                				
                			}
                			if(!is_end) break;
                			
                			// 全抓值完畢
                			if(can_into){
                				import_counter++;
                				int dh_total = 0;
            					// 新增資料
                				TableRecord dh = new TableRecord(tbldh);
//                 				20250815Arlen顯示錯誤欄位
                				for (int j = 0; j < fieldname.length; j++) {
                				    try {
                				        String cleanValue = fieldvalue[j] == null ? "" : fieldvalue[j].replace(",", "");

                				        if ("dh_total".equals(fieldname[j])) {
                				            try {
                				            	if(!"".equals(cleanValue.trim()))
                				                	dh_total = Integer.parseInt(cleanValue);
                				            	
                				            } catch (NumberFormatException e) {
//                 				                error_count++;
												has_error = true;
//                 				                System.out.println("1231");
                				                error_str += "第" + ex + "筆資料: " + fieldvalue[5] + " ，欄位 " + fieldname_title[j] + " 不是有效數字<br />";
                				            }
                				        }
                				        if ("dh_paymethod".equals(fieldname[j])) {
            				            	if(		!"".equals(cleanValue.trim())	&&
            				            			!("信用卡".equals(cleanValue) || "JKO".equals(cleanValue)  //街口
            				            			|| "LINEPAY".equals(cleanValue) || "AJKO".equals(cleanValue)  //定期定額-街口
            				            			|| "匯款".equals(cleanValue) || "劃撥".equals(cleanValue)
            				            			|| "官網".equals(cleanValue) || "智邦".equals(cleanValue)
            				            			|| "蝦皮".equals(cleanValue) || "igiving".equals(cleanValue)
            				            			|| "NPO".equals(cleanValue) || "藍新".equals(cleanValue))){
											has_error = true;
            				                error_str += "第" + ex + "筆資料: " + fieldvalue[5] + " ，欄位 " + fieldname_title[j] +"--"+cleanValue +" 付款方式錯誤<br />";
            				        
            				            	}
            				        	}
                				        
                				        if ("dh_receipt_type".equals(fieldname[j])) {
                				            	if(!"".equals(cleanValue.trim())&&!("電子申報".equals(cleanValue) || "單次紙本收據".equals(cleanValue) || "年度紙本收據".equals(cleanValue) || "都不需要".equals(cleanValue) || "年度電子收據".equals(cleanValue) || "單次電子收據".equals(cleanValue))){
												has_error = true;
                				                error_str += "第" + ex + "筆資料: " + fieldvalue[5] + " ，欄位 " + fieldname_title[j] + " 收據類型錯誤<br />";
                				        
                				            	}
                				        }
                				        if (fieldname[j].startsWith("dh_")) {
                				            dh.setValue(fieldname[j], cleanValue);
                				        }

                				    } catch (Exception e) {
//                 				        error_count++;
                				        has_error = true;
//                 				        System.out.println("1231");
                				        error_str += "第" + ex + "筆資料: " + fieldvalue[5] + " ，欄位 " + fieldname_title[j] + " 處理錯誤<br />";
                				    }
                				}

                				for (int j = 0; j < required_fields.length; j++) {
                				    String required_field = required_fields[j];
                				    if ("".equals(dh.getValue(required_field))) {
//                 				    	error_count++;
										has_error = true;
                				        error_str += "第" + ex + "筆資料: " + fieldvalue[5] + " ，欄位 " + required_fields_title[j] + " 未填寫<br />";
                				    }
                				}
                				
                				
                				if(has_error){
                					error_count++;
                				}
                				
                				if(error_count == 0){
//                 					for(int j=0;j<fieldname.length;j++){
//                 						System.out.println(fieldname[j] + ":"+fieldvalue[j]);
//                     				}

									if(dh.getString("dh_name").equals("")){
										dh.setValue("dh_name", "善心人士");
										
									}

									String dh_donate_item_category = app_sm.select(tbldm,"dm_title = ? and dm_code ='donate_project_category2'",new Object[]{dh.getString("dh_donate_item_category")}).getString("dm_id");
									dh.setValue("dh_donate_item_category", dh_donate_item_category);

                					String dh_receipt_type = dh.getString("dh_receipt_type")
                							.replace("電子申報","N")
                							.replace("年度單次電子收據","年度電子收據")
                							.replace("單次紙本收據","single_paper")
                							.replace("年度紙本收據","year_paper")
                							.replace("單次電子收據","single_e")
                							.replace("年度電子收據","year_e");
                					
                					String dh_paymethod = dh.getString("dh_paymethod").replace("linepay","line").replace("藍星","newebpay.credit");
                					if("".equals(dh_paymethod)) dh_paymethod = "jko";
                					
                					
                					
                					
                					String dh_phone = dh.getString("dh_phone");
//                 					if(dh_phone.startsWith("9"))  //20251107 Arlen 全部直接開頭+0
                						dh_phone = "0"+dh_phone;
                					
                					dh.setValue("dh_receipt_type", dh_receipt_type);
                					
                					dh.setValue("dh_public", dh.getString("dh_public").replace("非匿名","N").replace("匿名","Y"));
                					
                					dh.setValue("dh_paymethod", dh_paymethod);
                					
                					
                					dh.setValue("dh_email", dh.getString("dh_email").replace("mailto:",""));
                					dh.setValue("dh_receipt_title", dh.getString("dh_name"));
                					dh.setValue("dh_receipt_email", dh.getString("dh_email"));
                					dh.setValue("dh_receipt_address", dh.getString("dh_address"));
                					dh.setValue("dh_phone", dh_phone);
                    				dh.setValue("dh_status", "Y");
                    				dh.setValue("dh_collect", "Y");
                    				dh.setValue("dh_lang", lang);
                    				dh.setValue("dh_code", code);
                    				dh.setValue("dh_no", IDTool.getUID(code, "M"+DateTimeTool.dateString(""), 4));
                    				
                    				//塞編號
                    				String donatedate = dh.getString("dh_donatedate");
									String[] date = donatedate.split("/");
									
									int year1 = Integer.parseInt(date[0]);
									String yearStr1 = String.format("%02d", year1%100);
							
									int month1 = Integer.parseInt(date[1]);
									int day1 = Integer.parseInt(date[2]);
									String mdStr1 = String.format("%02d%02d", month1, day1);
									
							
									TableRecord dm2 = app_sm.select(tbldm, dh.getString("dh_donate_item_category")); 
									String prefix1 = yearStr1 + mdStr1;
									String key1 = dm2.getString("dm_title") + prefix1;
									String seq = IDTool.getUID("receipt", key1, 3);
									String rs_no1 = seq;
									
									dh.setValue("rs_no", rs_no1);
                    				
                    				dh.setInsert(app_account);
                    				
//                     				app_sm.insert(dh);
                    				dhs.add(dh);
                    				// 開立收據

                    				/*----------------------------------收據開立start--------------------------------------*/
                    				// 		收據全部自動開立20251003Arlen

                    				// 收據開立
                    				TableRecord rs = new TableRecord(tblrs);
                    				rs.setValue("rs_no", dh.getString("rs_no"));
                    				rs.setValue("dh_order_name", dh.getString("dh_receipt_title"));
                    				rs.setValue("dh_pid", dh.getString("dh_pid"));
                    				rs.setValue("dh_id", dh.getString("dh_id"));
                    				rs.setValue("dh_no", dh.getString("dh_no"));
                    				rs.setValue("dh_total", Integer.parseInt(dh.getString("dh_total")));
                    				rs.setValue("dh_order_county", dh.getString("dh_receipt_county"));
                    				rs.setValue("dh_order_city", dh.getString("dh_receipt_city"));
                    				rs.setValue("dh_order_zip_code", dh.getString("dh_receipt_zipcode"));
                    				rs.setValue("dh_order_address", dh.getString("dh_receipt_address"));
                    				rs.setValue("rs_donateitem", dh.getString("dh_donate_item_title"));
                    				rs.setValue("dh_donatedate", dh.getString("dh_donatedate"));
                    				rs.setValue("dh_receipt", dh.getString("dh_receipt_type"));	//dh_1.getString("dh_receipt_type")			
                    				rs.setValue("rs_status", "Y");			// 新增收據狀態 20221115 May
                    				
                    				String rs_type = dh.getString("dh_receipt_type").contains("single") ? "single":"annual";
                    				
                    				
                    				rs.setValue("rs_type", rs_type);		// 新增收據類型 20240820 May
                    				rs.setValue("rs_code", "receipt");
                    				
//                    		 		20250821Arlen儲存收據印章+經辦
                    				TableRecord stamp = app_sm.select(tblcp, "cp_code=? and cp_lang=?", new Object[]{"receipt_stamp", lang });
                    				rs.setValue("rs_handle", stamp.getString("cp_content"));
                    				rs.setValue("rs_stamp", stamp.getString("cp_image"));
                    				rs.setValue("rs_stamp2", stamp.getString("cp_image2"));
                    				rs.setValue("rs_stamp3", stamp.getString("cp_image3"));
                    				rs.setValue("rs_stamp4", stamp.getString("cp_image4"));			
                    				rs.setValue("rs_lang", lang);
                    				// rs.printAttributes();
                    				rs.setInsert(app_account);
//                     				app_sm.insert(rs);
                    				rss.add(rs);
                    				
                    				//更新捐款單 收據狀態
                    				dh.setValue("rs_id", rs.getString("rs_id"));
                    				dh.setValue("rs_status", "Y");
                    				
//                     				app_sm.update(dh);
                    				/*----------------------------------收據開立end--------------------------------------*/
                    				
                    				

                				} else {
//                 					error_str += "總錯誤筆數 :"+error_count;
                				}
                           	} else {
//                            		error_str += "第"+ex+"筆資料:" + fieldvalue[0]+"，資料有缺漏或是資料不正確，此筆將不做新增<br />";
                           	}
                		}
                    }
                    error_str += "總錯誤筆數 :"+error_count;
                    if(error_count>0)all_can_into=false;
//                     System.out.println("匯入筆數 :"+dhs.size());
                    if(all_can_into){
                    	for(TableRecord dh:dhs){
//                     		System.out.println("+++++++++++++++"+dhs.size());
                    		app_sm.insert(dh);
//                     		System.out.println("+++++++++++++++"+dh.getString("dh_id"));



                    		/*------------------寄信排程start----------------------*/
                    		// 新增寄送紀錄 20250711 May
                    		
                    		if(dh.getString("dh_receipt_type").equals("single_e")){ //是否為電子收據)
                    					TableRecord mr = new TableRecord(tblmr);
                    					String subject = SiteSetup.getText("cp.company." + lang) + " 電子收據通知信";
                    					
                    					mr.setValue("data_id", dh.getString("rs_id"));
                    					mr.setValue("mr_recipient", dh.getString("dh_receipt_email"));
                    					mr.setValue("mr_subject", subject);
                    					mr.setValue("mr_status", "N");
                    					mr.setValue("mr_mail", "R");
                    					mr.setValue("mr_type", "A");
                    					mr.setValue("mr_priority", "B");
                    					mr.setValue("mr_code", "mail");
                    					mr.setValue("mr_lang", lang);
                    					mr.setInsert("Web_User");
                    					app_sm.insert(mr);
                    		}
                    		/*------------------寄信排程end----------------------*/

                    	}
                    	for(TableRecord rs:rss){
//                     		System.out.println("+++++++++++++++"+dhs.size());
                    		app_sm.insert(rs);
//                     		System.out.println("+++++++++++++++"+dh.getString("dh_id"));
                    	}
                    }
                    FileTool.deleteFile(app_uploadpath+"/import/"+ul_file);
                    
                    
                    String finish_str = "匯入處理完成.";
                    if(!all_can_into){
                    	finish_str = "資料匯入失敗.";
                    }
                    
            	 	%>
            	 	<br/><br/> 
					<span><B><%=finish_str %><br /><%=error_str %></span>
                  	</td>
               	</tr>
            </table></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" class="web_bk-2b">
			</td>
          </tr>
        </table>
      <!-- InstanceEndEditable --></td>
    </tr>
  </table>
</div>
</div>

</body>
<!-- InstanceEnd --></html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>
<%-- <%=HtmlCoder.getForm("backpage", code+".jsp" , names, values) %> --%>