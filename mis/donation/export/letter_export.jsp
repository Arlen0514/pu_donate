<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.List" %>
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
<%@ page import="org.apache.poi.xwpf.usermodel.*" %>
<%@ page import="java.util.zip.ZipOutputStream" %>
<%@ page import="java.util.zip.ZipInputStream" %>
<%@ page import="java.util.zip.ZipEntry" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ include file="/WEB-INF/jspf/config.jspf" %>
<%@ include file="/WEB-INF/jspf/mis/check.jspf" %>
<%!
	//表格內文字替換
	public static void replaceTableText(XWPFDocument document, String oldValue, String newValue) {
	    for (XWPFTable table : document.getTables()) {
	        for (XWPFTableRow row : table.getRows()) {
	            for (XWPFTableCell cell : row.getTableCells()) {
	                for (XWPFParagraph paragraph : cell.getParagraphs()) {
	                    for (XWPFRun run : paragraph.getRuns()) {
	                        String text = run.getText(0);
	                        // System.out.println("text: "+text); // 列印
	                        
	                        if (text != null && text.contains(oldValue)) {
	                            run.setText(text.replace(oldValue, newValue), 0);
	                        }
	                    }
	                }
	            }
	        }
	    }
	}
	
	// 表格內子表格的文字替換
	public static void replaceSubTableText(XWPFTable table, String oldValue, String newValue) {
		for (XWPFTableRow row : table.getRows()) {
	        for (XWPFTableCell cell : row.getTableCells()) {
	            for (XWPFParagraph paragraph : cell.getParagraphs()) {
	                for (XWPFRun run : paragraph.getRuns()) {
	                    String text = run.getText(0);
	                    // System.out.println("text: "+text); // 列印
	                    
	                    if (text != null && text.contains(oldValue)) {
	                        run.setText(text.replace(oldValue, newValue), 0);
	                    }
	                }
	            }
	        }
	    }
	}
	
	// 表格內內容變更(名條)
	public static void replaceTableCellText(XWPFTableCell cell, Vector<String> data) {
	    XWPFParagraph paragraph = cell.getParagraphArray(0);
	                
	    for(int i=0;i<data.size();i++){
	        paragraph.createRun().setText(data.get(i));
	        if(i < data.size()-1) paragraph.createRun().addBreak();
	    }
	}
	
	//段落內文字替換
	public static void replaceParagraphText(XWPFDocument document, String oldValue, String newValue) {
	    for (XWPFParagraph paragraph : document.getParagraphs()) {
	        for (XWPFRun run : paragraph.getRuns()) {
	            String text = run.getText(0);
	            // if(text != null) System.out.println("text: "+text); // 列印
	            
	            if (text != null && text.contains(oldValue)) {
	                run.setText(text.replace(oldValue, newValue), 0);
	            }
	        }
	    }
	}
	
	// 文件合併
	public static XWPFDocument mergeDocuments(List<XWPFDocument> documents) {
	    XWPFDocument mergedDoc = documents.get(0);
	    for (int i = 1; i < documents.size(); i++) {
	        XWPFDocument doc = documents.get(i);
	        for (IBodyElement element : doc.getBodyElements()) {
	            if (element instanceof XWPFParagraph) {
	                mergedDoc.createParagraph().getCTP().set(((XWPFParagraph) element).getCTP().copy());
	            } else if (element instanceof XWPFTable) {
	                mergedDoc.createTable().getCTTbl().set(((XWPFTable) element).getCTTbl().copy());
	            }
	        }
	    }
	    return mergedDoc;
	}
	
	// 將郵遞區號分開
	public static String [] ExtractNumber (String address) {
		
		String data = address;
		String pattern = "\\d{3,6}";
		
		Pattern regexPattern = Pattern.compile(pattern);
		Matcher matcher = regexPattern.matcher(address);
		
		 if (matcher.find()) {
	         String extractedNumberStr = matcher.group();
	         int extractedNumber = Integer.parseInt(extractedNumberStr);
	
	         String remainingText = address.substring(matcher.end());
	         String formattedResult = extractedNumber + "," + remainingText;
	         data = formattedResult;
	     } else {
	         System.out.println("No matching number found.");
	     }
		return data.split(",");
	}
%>
<%!
	 // 大寫數字
	 private static final String[] NUMBERS = { "零", "壹", "貳", "叄", "肆", "伍", "陸", "柒", "捌", "玖" };
	 // 整數部分的單位
	 private static final String[] IUNIT = { "", "拾", "佰", "仟", "萬", "拾", "佰", "仟", "億", "拾", "佰", "仟", "萬", "拾", "佰", "仟" };
	 // 小數部分的單位
	 private static final String[] DUNIT = { "角", "分", "釐" };

	 // 轉成中文的大寫金額
	 public static String toChinese(String str) {
		 boolean flag = false;
		 
		 str = str.replaceAll(",", "");			// 去掉","
		 String integerStr;						// 整數部分數字
		 String decimalStr;						// 小數部分數字

		 // 初始化：分離整數部分和小數部分
		 if(str.indexOf(".") > 0) {
			 integerStr = str.substring(0,str.indexOf("."));
		 	decimalStr = str.substring(str.indexOf(".")+1);
		 } else if(str.indexOf(".") == 0) {
		 	integerStr = "";
			 decimalStr = str.substring(1);
		 } else {
			 integerStr = str;
			 decimalStr = "";
		 }

		 // beyond超出計算能力，直接返回
		 if(integerStr.length()>IUNIT.length) {
			 System.out.println(str+"：超出計算能力");
			 return str;
		 }

		 int[] integers = toIntArray(integerStr);	// 整數部分數字

		 // 判斷整數部分是否存在輸入012的情況
		 if (integers.length>1 && integers[0] == 0) {
		 System.out.println("抱歉，請輸入數字！");
			 if (flag) {
			 	str = "-"+str;
			 }
			 return str;
		 }
		 boolean isWan = isWan5(integerStr);		// 設置萬單位
		 int[] decimals = toIntArray(decimalStr);	// 小數部分數字
		 	String result = getChineseInteger(integers,isWan)+getChineseDecimal(decimals);	// 返回最終的大寫金額
		 if(flag) {
		 	return "負"+result;						// 如果是負數，加上"負"
		 } else {
		 	return result;
		 }
	 }

	 // 將字符串轉爲int數組
	 private static int[] toIntArray(String number) {
	 	int[] array = new int[number.length()];
		
	 	for(int i = 0;i<number.length();i++) {
		 	array[i] = Integer.parseInt(number.substring(i,i+1));
		}
	 	
	 	return array;
	 }

	 // 將整數部分轉爲大寫的金額
	 public static String getChineseInteger(int[] integers,boolean isWan) {
	 	 StringBuffer chineseInteger = new StringBuffer("");
		 int length = integers.length;
		 if (length == 1 && integers[0] == 0) {
		 	
		 }
		 for(int i=0;i<length;i++) {
		 String key = "";
		 if(integers[i] == 0) {
		 if((length - i) == 13)//萬（億）
		  	key = IUNIT[4];
		 else if((length - i) == 9) {//億
		  	key = IUNIT[8];
		 }else if((length - i) == 5 && isWan) {//萬
		  	key = IUNIT[4];
		 }else if((length - i) == 1) {//元
		  	key = IUNIT[0];
		 }
		 if((length - i)>1 && integers[i+1]!=0) {
		  	key += NUMBERS[0];
		 }
		 }
		 	chineseInteger.append(integers[i]==0?key:(NUMBERS[integers[i]]+IUNIT[length - i -1]));
		 }
	 	return chineseInteger.toString();
	 }

	 // 將小數部分轉爲大寫的金額
	 private static String getChineseDecimal(int[] decimals) {
	 	 StringBuffer chineseDecimal = new StringBuffer("");
		 
	 	 for(int i = 0;i<decimals.length;i++) {
		 if(i == 3) {
			 break;
		 }
		 	chineseDecimal.append(decimals[i]==0?"":(NUMBERS[decimals[i]]+DUNIT[i]));
		 }
		 
		 return chineseDecimal.toString();
	 }

	 // 判斷當前整數部分是否已經是達到【萬】
	 private static boolean isWan5(String integerStr) {
	 	int length = integerStr.length();
		 if(length > 4) {
		 	String subInteger = "";
			 if(length > 8) {
			 	subInteger = integerStr.substring(length- 8,length -4);
			 }else {
			 	subInteger = integerStr.substring(0,length - 4);
			 }
			return Integer.parseInt(subInteger) > 0;
		 }else {
			return false;
		 }
	 }
%>
<%
	// 以利前端檢查時 , 了解正在進行檔案匯出的工作
	session.setAttribute("letter_file","start");

	// Conditions.
	String qname = StringTool.validString(request.getParameter("_qname"));
	String qphone = StringTool.validString(request.getParameter("_qphone"));
	String qdhno = StringTool.validString(request.getParameter("_qdhno"));
	String qpayment = StringTool.validString(request.getParameter("_qpayment"),"");	
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"));
	String qposition = StringTool.validString(request.getParameter("_qposition"), "Y");
	String qcollect	 = StringTool.validString(request.getParameter("_qcollect"), "Y");
	String qidentity	 = StringTool.validString(request.getParameter("_qidentity"));
	String dh_id = StringTool.validString(request.getParameter("dh_id"), "");
	
	// Names and values.
	String[] names = new String[] { 
		"npage", "_qname", "_qphone", "_qdhno", "_qpayment", "_qemitdate", "_qrestdate", "_qposition", "_qcollect", "_qidentity"
	};
	String[] values = new String[] { 
		String.valueOf(pageno), qname, qphone, qdhno, qpayment, qemitdate, qrestdate, qposition, qcollect, qidentity
	};
	
	// Get records.
	StringBuffer sb = new StringBuffer();
	Vector keys = new Vector();
	
	sb.append("dh_code=? AND dh_lang=?");
	keys.add("donate");
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
	sb.append("and dh_identity_thank like ?");
	keys.add("%"+qidentity+"%");
	
	if(!"".equals(dh_id)){
		sb.append(" and dh_id=?");
		keys.add(dh_id);
	}
	
	Vector<TableRecord> dhs = app_sm.selectAll(tbldh, sb.toString(), keys.toArray() , "dh_createdate DESC");
	
	// 檢查是否有資料可以供匯出
	if(dhs == null || dhs.size() == 0) {
	   out.write("<script>alert('無列印資料!!');</script>");
	   session.setAttribute("letter_file", "no");
	} else {
		String template_file = "thank_letter.docx";						// 列印樣板
		
		// 贈與身分列表(感謝狀用)
		Vector<TableRecord> cps = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=?", new Object[]{"thank_info", lang});
		Map<String, TableRecord> thank_info_map = new HashMap<String, TableRecord>();
		
		for(TableRecord cp:cps) thank_info_map.put(cp.getString("cp_category"), cp);
		
	    try {
	    	// 將資料內容寫入指定檔案
    		String clientFileName = app_account + "_" + template_file;		
	    	
			// 创建一个新的文档列表
            List<XWPFDocument> newDocs = new ArrayList<>();
			
			for(TableRecord dh:dhs){
				// 檔案讀取
	    		InputStream fis = session.getServletContext().getResourceAsStream("/mis/donation/export/"+template_file);
		    	XWPFDocument document = new XWPFDocument(fis);
		    	
		    	// 判斷捐款人身分別
		    	TableRecord thank_info = new TableRecord(tblcp);
		    	String key = dh.getString("dh_identity_thank");
		    	String name = dh.getString("dh_name"), name_2 = "您";
		    	String school = "本校";
		    	boolean has_key = thank_info_map.containsKey(key);
		    	
		    	if(!has_key) key = "person"; 
		    	thank_info = thank_info_map.get(key);
		    	
		    	if("alumni".equals(key)) school = "母校";
		    	else if("company".equals(key)) name_2 = "貴公司";
		    	else if("organization".equals(key)) name_2 = "貴會";
		    	
		    	// 查找表格并替换占位符
	            replaceParagraphText(document, "${Name}", name);
	            replaceParagraphText(document, "${Name_2}", name_2);
	            replaceParagraphText(document, "${School}", school);
	            replaceParagraphText(document, "${Item}", dh.getString("dh_donate_project_title"));
	            replaceParagraphText(document, "${Total}", toChinese(String.valueOf(dh.getInt("dh_total"))));
	            replaceParagraphText(document, "${Desc}", thank_info.getString("cp_desc"));
	            replaceParagraphText(document, "${Content}", thank_info.getString("cp_content"));
	            replaceParagraphText(document, "${Year}", String.valueOf(DateTimeTool.getYear()-1911));
	            replaceParagraphText(document, "${Month}", String.valueOf(DateTimeTool.getMonth()));
	            replaceParagraphText(document, "${Day}", String.valueOf(DateTimeTool.getDay()));
		    	
		    	// 放進文檔列表
	            newDocs.add(document);
			}

            // 合并多个文档为一个文档
            XWPFDocument mergedDoc = mergeDocuments(newDocs);
            
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

			mergedDoc.write(fos);
			fos.flush();
			fos.close();
			
			// 以利前端檢查時 , 了解已完成檔案匯出的工作
			session.setAttribute("letter_file", "end");
		} catch (Exception e) {
			session.setAttribute("letter_file", "error");
			System.out.println("Project:" + projectName + ", Error info:" + e.getMessage() + ", File name letter_export.jsp, Time:" + DateTimeTool.dateTimeString());
		}
	}
%>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>