<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/web/include/encryption.jsp"%>
<%!
	 // 大寫數字
	 private static final String[] NUMBERS = { "零", "壹", "貳", "叁", "肆", "伍", "陸", "柒", "捌", "玖" };
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
	String dh_id = StringTool.validString(request.getParameter("dh_id"));
	TableRecord dh = app_sm.select(tbldh, dh_id);
	TableRecord ph = app_sm.select(tblph, "data_id=?", new Object[]{dh_id});
	String real_dh_id = dh_id;
	if("".equals(dh.getString("dh_id"))) {
		out.println("<script> alert('捐款資料有誤!!'); </script>");
		return;
	}
	
	// 捐款日期&編號
	SimpleDateFormat sdf_f = new SimpleDateFormat("yyyy年MM月dd日");
	SimpleDateFormat sdf_p = new SimpleDateFormat("yyyy/MM/dd");
	Calendar donate_date = Calendar.getInstance();
	String dh_no = dh.getString("dh_no");
	
	try {
		donate_date.setTime(sdf_p.parse(dh.getString("dh_donatedate")));
	} catch(Exception e){
		out.println("<script> alert('捐款日期有誤!!'); </script>");
		return;
	}
	
	// 定期定額：抓第一期
	if(!"".equals(dh.getString("dh_main"))) {
		dh = app_sm.select(tbldh, dh.getString("dh_main"));
		dh_id = dh.getString("dh_id");
	}
	
	/*-- 捐款資訊 --*/
	// 捐款類別列表
	Vector<TableRecord> donate_project_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category=?"
			, new Object[]{"donate_category", lang, ""}, "dm_showseq ASC, dm_createdate DESC");
	// 院系捐款  
	TableRecord department_index = app_sm.select(tbldm, "dm_code=? and dm_lang=? and dm_category=?",
            new Object[]{"department_index", lang, ""}, "dm_showseq ASC, dm_createdate DESC");
	
	Map<String, String> donate_category_map = new HashMap<String, String>();
	
	for(TableRecord dm:donate_project_dms)
		donate_category_map.put(dm.getString("dm_id"), dm.getString("dm_title"));
	donate_category_map.put(department_index.getString("dm_id"), department_index.getString("dm_title"));
	
	// 系所類別
    Vector<TableRecord> dept_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? ", 
    		new Object[] { "department_category", lang }, "dm_showseq ASC, dm_createdate DESC");
    Map<String, String> donate_dept_map = new HashMap<String, String>();
    
    for(TableRecord dm:dept_dms) donate_dept_map.put(dm.getString("dm_id"), dm.getString("dm_title"));
	
	// 捐款類別
	String dh_donate_project_category = dh.getString("dh_donate_project_category");
	String dh_donate_project_title = dh.getString("dh_donate_project_title")+"("+dh.getString("dh_donate_project_no")+")";
	
	dh_donate_project_category = "other".equals(dh_donate_project_category)?"其他":donate_category_map.get(dh_donate_project_category) ; 
	
	// 捐款系所
	String dh_donate_college = "", dh_donate_department = "";
	
	if(donate_dept_map.containsKey(dh.getString("dh_donate_college"))) 
		dh_donate_college = donate_dept_map.get(dh.getString("dh_donate_college"));
	if(donate_dept_map.containsKey(dh.getString("dh_donate_department"))) 
		dh_donate_department = donate_dept_map.get(dh.getString("dh_donate_department"));
	
	// 身分證字號/統編
	String dh_pid = new AESDataEncryption().AESDecrypt(dh.getString("dh_pid"));
	
	// 地址
	String dh_address = dh.getString("dh_zipcode")+dh.getString("dh_county")+dh.getString("dh_city")+dh.getString("dh_address");
	String dh_receipt_address = dh.getString("dh_receipt_zipcode")+dh.getString("dh_receipt_county")+dh.getString("dh_receipt_city")+dh.getString("dh_receipt_address");
	
	// 幣別
	boolean is_foreign = !"TWD".equals(dh.getString("dh_currency"));
	// 院系捐款
	boolean is_dept = dh.getString("dh_donate_project_category").equals(department_index.getString("dm_id"));
	// 信用卡
	boolean is_credit = "pay.newebpay.credit".equals(dh.getString("dh_paymethod")) || "pay.newebpay.regular".equals(dh.getString("dh_paymethod"));

	// 洽詢專線聯絡人
	String contact_info  = SiteSetup.getValue("ss.contact_info");
	String contact_email = SiteSetup.getValue("ss.contact_email");
	
	// Server name.	
	String servername = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
	if(request.getServerPort()== 80 || request.getServerPort()== 443) {
		servername = request.getScheme()+"://"+request.getServerName();
	} 
	String localname = request.getScheme()+"://"+request.getLocalName()+":"+request.getLocalPort();
	String url = servername + request.getContextPath() + "/web/receipt";
%>
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/in_receipt.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/><!--讓ie在切換瀏覽器模式時 文件模式會使用最新的版本-->
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="Robots" content="none" /><!--不被搜尋引擎搜到-->
	
	<!--RWD用-->
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<!--RWD用-->
	
	<!--android 手機板主題顏色用 更改網址列顏色-->
	<meta name="theme-color" content="fff0">
	<!--android 手機板主題顏色用-->
	<meta name="format-detection" content="telephone=no"><!--取消行動版 safari 自動偵測數字成電話號碼-->
	
	<link rel="shortcut icon" href="../images/favicon.png" /><!--電腦版icon-->
	<link rel="apple-touch-icon" href="../images/icon.png" /><!--手機版icon  57x57px-->
	<link rel="apple-touch-icon" sizes="72x72" href="../images/icon-72.png" /><!--手機版icon  72x72px-->
	<link rel="apple-touch-icon" sizes="114x114" href="../images/icon@2.png" /><!--手機版icon  114x114px-->
	
	<!--內容區塊css-->
	<link rel="stylesheet" type="text/css" href="../css/style.css"/>
	<!--套印區塊css-->
	<link rel="stylesheet" type="text/css" href="../css/receipt_style.css"/>
	
	<!--google material icon-->
	<link rel="stylesheet" href="../icon_fonts/material_icons/material_icons.css">
	<link rel="stylesheet" href="../icon_fonts/material_icons/material_symbols_outlined.css">  <!-- 為了弱掃留原始檔案 -->
	<!-- <link href="https://fonts.googleapis.com/css2?family=Material+Icons" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet"> -->
	
	<!-- bootstrap-icons -->
	<!-- <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"> -->
	<link rel="stylesheet" href="../icon_fonts/bootstrap_icons/bootstrap-icons.css"> <!-- 為了弱掃留原始檔案 -->
	
	<!-- Font Awesome icon -->
	<!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"> -->
	<link rel="stylesheet" type="text/css" href="../icon_fonts/font_awesome_icon/font_awesome_icon_all.min.css"/><!-- 為了弱掃留原始檔案 -->
	
	<!-- jQuery版本3.7.1 -->
	<!-- <script src="https://code.jquery.com/jquery-3.7.1.min.js" type="text/javascript"></script> -->
	<script src="../js/jquery/jquery-3.7.1.min.js" type="text/javascript"></script>  <!-- 為了弱掃留原始檔案 -->
	<!-- jQuery 遷移插件_簡化從舊版本jQuery的轉換3.5.2-->
	<!-- <script src="https://code.jquery.com/jquery-migrate-3.5.2.min.js" type="text/javascript"></script> -->
	<script src="../js/jquery/jquery-migrate-3.5.2.min.js" type="text/javascript"></script>  <!-- 為了弱掃留原始檔案 -->
	<!-- 版本更新 jQuery by Judy 20241211 end -->
	
	<!--JavaScript共用區-->	
	<script src="../js/common.js" type="text/javascript"></script>
	
	<!-- Noto Sans Traditional Chinese字體 -->
	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
	
	<!-- Varela Round字體 -->
	<link href="https://fonts.googleapis.com/css2?family=Varela+Round&display=swap" rel="stylesheet">
	<!-- InstanceBeginEditable name="head" -->
	
	<title><%=app_webtitle%></title>

	<!-- 天主教靜宜大學捐款單 -->
	<link rel="stylesheet" href="../css/style_nav/style_receipt/style_donation_form_receipt.css">

<!-- InstanceEndEditable -->
</head>

<body>
    <div class="headertop" id="top"></div>
    
    <!--主內容區塊-->
    <div class="main main_receipt">
    
    <!-- InstanceBeginEditable name="main_receipt" -->
    
        <!--按鍵區-->
        <div class="btn_area one">
            <input type="submit" value="列印" class="printBtn" onclick="printPage('portrait');" />
		</div>
        
        <!--列印範圍-->
        <div class="overPrint" id="overPrint">
        
            <!--一頁A4大小-->
            <div class="page_print">
        
                <!--table header區塊-->
                <div class="donation_form_header">
                    <strong>
                        國立臺灣<img class="logo" style="width: 65px;" src="<%=url %>/images/logo.webp" alt="" />大學捐款單
                    </strong>
                    <div class="donation_code">捐款單號：<%=dh_no %></div>
                    <div class="date">填表日期：<%=sdf_f.format(donate_date.getTime()) %></div>
                </div>
                
                <!--table body區塊_基本資料-->
                <table class="basic_information basic_information1" cellpadding="0" cellspacing="0" border="0">
                    
                    <tbody>
                        
                        <tr>
                            <td rowspan="6" class="basic_information_title" width="8">
                                <div class="title">
                                    基本資料
                                </div>
                            </td>
                            <td width="103"><div class="title">姓名/機構名稱</div></td>
                            <td width="32%"><div class="fillBlank"><%=dh.getString("dh_name") %></div></td>
                            <td width="28%"><div class="title">身分證字號/統一編號</div></td>
                            <td><div class="fillBlank"><%=dh_pid %></div></td>
                        </tr>
            
                        <tr>
                            <td>
                                <div class="title">聯絡方式</div>
                            </td>
                            <td colspan="3" class="basic_information_in">
                                <div class="">
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tbody>
                                            <tr>
                                                <td width="40%">
                                                    <div class="list">
                                                        <div class="title">電話：</div><div class="fillBlank"><%=dh.getString("dh_phone") %></div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>                                               
                                                <td>
                                                    <div class="list">
                                                        <div class="title">連絡電話：</div><div class="fillBlank"><%=dh.getString("dh_cellphone") %></div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
            
                        <tr>
                            <td>
                                <div class="title">通訊地址</div>
                            </td>
                            <td  colspan="4">
                                <div class="fillBlank"><%=dh_address %></div>
                            </td>
                        </tr>
            
                        <tr>
                            <td>
                                <div class="title">電子信箱</div>
                            </td>
                            <td colspan="4"><div class="fillBlank"><%=dh.getString("dh_email") %></div></td>
                        </tr>

                        <tr class="identity">
                            <td>身　　份</td>
                            <td colspan="4" class="basic_information_in">
                                <div >
                                    <table>
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div class="list">
                                                        <%="1".equals(dh.getString("dh_identity"))?"⬛":"⬜" %> 靜宜校友，民國<div class="fillBlank"><%=dh.getString("dh_identity_year") %></div>年<div class="fillBlank"><%=dh.getString("dh_identity_dept") %></div>系/所/班 畢(結)業
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>                                               
                                                <td>
                                                	<span><%="2".equals(dh.getString("dh_identity"))?"⬛":"⬜" %></span> 靜宜教職員　　
                                                	<span><%="3".equals(dh.getString("dh_identity"))?"⬛":"⬜" %></span> 學生/家長　　
                                                	<span><%="4".equals(dh.getString("dh_identity"))?"⬛":"⬜" %></span> 企業機構　　
                                                	<span><%="5".equals(dh.getString("dh_identity"))?"⬛":"⬜" %></span> 社會人士
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        
                        <tr>
                            <td>                                
                                <div class="title">服務單位</div>
                            </td>
                            <td><div class="fillBlank"><%=dh.getString("dh_unit") %></div></td>
                            <td>職　　稱</td>
                            <td><div class="fillBlank"><%=dh.getString("dh_job") %></div></td>                            		
                        </tr>

                    </tbody>
                        
                </table>

                
                <!--table body區塊_捐款內容-->
                <table class="basic_information basic_information2" cellpadding="0" cellspacing="0" border="0">
                    
                    <tbody>
                        
                        <tr>
                            <td rowspan="2" class="basic_information_title" width="8">
                                <div class="title">
                                    捐款內容
                                </div>
                            </td>

                            <td width="103">捐款金額</td>
                            <td  colspan="2">
                                <div class="list">
                                    新台幣&nbsp;<div class="fillBlank"><%=app_df.format(dh.getInt("dh_total")) %></div>&nbsp;元整
                                    <%if(is_foreign){ 
                                    	TableRecord currency = app_sm.select(tbldm, "dm_subtitle=?", new Object[]{dh.getString("dh_currency")});
                                    %>
		                  			，<%=currency.getString("dm_title") %>&nbsp;<div class="fillBlank"><%=app_df.format(dh.getInt("dh_foreign_total"))%></div>&nbsp;元，
		                  			<%} %>
                                </div>
                            </td>
                        </tr>

                        <tr>
                            <td>捐款用途</td>
                            <td colspan="">
                                募款專案：<br/>
                                <%=dh_donate_project_category %><br/>
                                <%if(is_dept){ %>
                                <%=dh_donate_college %>-<br/>
                                <%=dh_donate_department %>-<br/>
                                <%} %>
                                <%=dh.getString("dh_donate_project_title") %><br/>
                                <%if(!"".equals(dh.getString("dh_donate_project_no"))){ %>
                                (<%=dh.getString("dh_donate_project_no") %>)
                                <%} %>
                            </td>
                            <td colspan="">
                                捐款受贈單位：<br/>
                                <%=dh.getString("dh_donate_unit_title") %><br/><br/>
                                捐款屬性：<br/>
                                <%=dh.getString("dh_donate_attribute_title") %>
                            </td>
                        </tr>
                        
                    </tbody>
                        
                </table>

                
                <!--table body區塊_收據-->
                <table class="basic_information basic_information3" cellpadding="0" cellspacing="0" border="0">
                    
                    <tbody>
                        
                        <tr>
                            <td rowspan="2" class="basic_information_title" width="8">
                                <div class="title">
                                    收據
                                </div>
                            </td>

                            <td colspan="2">
                                <div class="receipt_info receipt_info1">
                                    <div class="list list1">
                                        <span><%="N".equals(dh.getString("dh_receipt_status"))?"⬛":"⬜" %></span>不寄收據/感謝函。
                                    </div>
                                    <div class="list list2">
                                        <span><%="Y".equals(dh.getString("dh_receipt_status"))?"⬛":"⬜" %></span>寄收據/感謝函
                                    </div>
                                    <div class="list list3">
                                        <div class="title">
                                            <span><%="Y".equals(dh.getString("dh_receipt_status"))?"⬛":"⬜" %></span><p>抬頭名稱：</p>    	
                                        </div>
                                        
                                        <div class="receipt_info receipt_info2">
                                            <div class="list">
                                                <div class="title">
                                                	<span><%="Y".equals(dh.getString("dh_same_name"))?"⬛":"⬜" %></span>同捐款人&emsp; 
                                                	<span><%="N".equals(dh.getString("dh_same_name"))?"⬛":"⬜" %></span>指定</div>
                                                <div class="fillBlank"><%=dh.getString("dh_receipt_title") %></div>    	
                                            </div>
                                            <div class="list">
                                                <div class="title">
                                                	<span><%="Y".equals(dh.getString("dh_same_address"))?"⬛":"⬜" %></span>同通訊地址	 
                                                	<span><%="N".equals(dh.getString("dh_same_address"))?"⬛":"⬜" %></span>指定
                                                </div>
                                                <div class="fillBlank"><%=dh_receipt_address %></div>    	
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        
                    </tbody>
                        
                </table>


                <!--table body區塊_捐款方式-->
                <table class="basic_information basic_information4" cellpadding="0" cellspacing="0" border="0">
                    
                    <tbody>
                        
                        <tr>
                            <td rowspan="6" class="basic_information_title" width="8">
                                <div class="title">
                                    捐款方式
                                </div>
                            </td>
                            <td width="103">
                                <div class="title">
                                    <span><%="pay.cash".equals(dh.getString("dh_paymethod"))?"⬛":"⬜" %></span>現金
                                </div>
                            </td>
                            <td>請洽校友服務中心。</td>
                        </tr>
                        
                        <tr>
                            <td>
                                <div class="title">
                                    <span><%="pay.cheque".equals(dh.getString("dh_paymethod"))?"⬛":"⬜" %></span>支票
                                </div>
                            </td>
                            <td>
                                抬頭請寫「天主教靜宜大學」，連同本捐款單，以掛號郵寄：202-24基隆市北寧路2號，靜宜大學校友服務中心收。
                            </td>
                        </tr>
                        
                        <tr>
                            <td>
                                <div class="title">
                                    <span><%="pay.postal".equals(dh.getString("dh_paymethod"))?"⬛":"⬜" %></span>郵政劃撥
                                </div>
                            </td>
                            <td>
                                戶名「天主教靜宜大學校務基金募款專戶」；帳號「18914926」。
                            </td>
                        </tr>
                        
                        <tr>
                            <td>
                                <div class="title">
                                    <span><%="pay.bank".equals(dh.getString("dh_paymethod"))?"⬛":"⬜" %></span>銀行臨櫃
                                </div>
                            </td>
                            <td>
                                往來銀行「第一商業銀行哨船頭分行(銀行代碼0072436)」；<br/>戶名「天主教靜宜大學401專戶」；帳號「24330026365」。
                            </td>
                        </tr>
                        
                        <tr>
                            <td>
                                <div class="title">
                                    <span><%="pay.newebpay.vatm".equals(dh.getString("dh_paymethod"))?"⬛":"⬜" %></span>虛擬帳號
                                </div>
                            </td>
                            <td>
                                線上捐款-虛擬帳號付款，虛擬帳號編號：<%=ph.getString("ph_account") %>
                            </td>
                        </tr>
                        
                        <tr>
                            <td>
                                <div class="title">
                                    <span><%=is_credit?"⬛":"⬜" %></span>信用卡
                                </div>
                            </td>
                            <td colspan="" class="basic_information_in">
                                <div class="">
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tbody>
                                            <tr>
                                                <td width="40%">
                                                    <div class="list list5">
                                                        <div class="title">
                                                            <span><%="pay.newebpay.credit".equals(dh.getString("dh_paymethod"))?"⬛":"⬜" %></span>
                                                            線上捐款-信用卡單筆捐款&nbsp;新台幣<div class="fillBlank"><%="pay.newebpay.credit".equals(dh.getString("dh_paymethod"))?app_df.format(dh.getInt("dh_total")):"" %></div>元
                                                        </div>
                                                    </div>
                                                </td>  
                                            </tr>
                                            <tr class="regularContributions">                                               
                                                <td>
                                                    <div class="list">
                                                        <div class="title">
                                                            <span><%="pay.newebpay.regular".equals(dh.getString("dh_paymethod"))?"⬛":"⬜" %></span>
                                                            線上捐款-定期定額捐款。
                                                        </div>
                                                    </div>
                                                    <div class="list">
                                                        本人同意以本信用卡捐助天主教靜宜大學，方式如下：
                                                    </div>
                                                    <div class="list">
                                                    	<%if("pay.newebpay.regular".equals(dh.getString("dh_paymethod"))){ %>
                                                    	自民國<div class="fillBlank"><%=Integer.parseInt(dh.getString("dh_donatedate").substring(0,4))-1911 %></div>年<div class="fillBlank"><%=dh.getString("dh_donatedate").substring(5,7) %></div>月，
                                                        至民國<div class="fillBlank"><%=Integer.parseInt(dh.getString("dh_debit_due_year"))-1911 %></div>年<div class="fillBlank"><%=dh.getString("dh_debit_due_month") %></div>月，
                                                    	<%} else { %>
                                                    	自民國<div class="fillBlank">&nbsp;</div>年<div class="fillBlank">&nbsp;</div>月，
                                                        至民國<div class="fillBlank">&nbsp;</div>年<div class="fillBlank">&nbsp;</div>月，
                                                    	<%} %>
                                                    </div>
                                                    <div class="list list4">
                                                    	<%if("pay.newebpay.regular".equals(dh.getString("dh_paymethod"))){ %>
                                                        <div class="title">固定<span><%="M".equals(dh.getString("dh_regular_type"))?"⬛":"⬜" %></span>每月；</div>
                                                        <div class="title"><span><%="Y".equals(dh.getString("dh_regular_type"))?"⬛":"⬜" %></span>每年&emsp;</div>
                                                        <div class="title">捐款新台幣<div class="fillBlank"><%=app_df.format(dh.getInt("dh_total")) %></div>元。</div>
                                                    	<%} else { %>
                                                    	<div class="title">固定&nbsp;<span>⬜</span>每月；</div>
                                                        <div class="title"><span>⬜</span>每年&emsp;</div>
                                                        <div class="title">捐款新台幣<div class="fillBlank"></div>元。</div>
                                                    	<%} %>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                        
                </table>


                <!--table body區塊_徵信-->
                <table class="basic_information basic_information5" cellpadding="0" cellspacing="0" border="0">
                    
                    <tbody>
                        
                        <tr>
                            <td rowspan="2" class="basic_information_title" width="8">
                                <div class="title">
                                    徵信
                                </div>
                            </td>
                            <td>
                                <span><%="Y".equals(dh.getString("dh_public"))?"⬛":"⬜" %></span>公開 
                                <span><%="N".equals(dh.getString("dh_public"))?"⬛":"⬜" %></span>不公開（註記為熱心人士）
                            </td>
                            
                        </tr>
                        
                        <tr>
                            <td colspan="2">
                                *姓名、身份、捐款金額刊登於本校網站或刊物，以為公開徵信之用
                            </td>
                        </tr>
                        
                    </tbody>
                        
                </table>

                <!--table body區塊_國稅局-->
                <table class="basic_information basic_information6" cellpadding="0" cellspacing="0" border="0">
                    
                    <tbody>
                        
                        <tr>
                            <td rowspan="2" class="basic_information_title" width="8">
                                <div class="title">
                                    上傳稅務機關
                                </div>
                            </td>
                            <td>
                                <span><%="Y".equals(dh.getString("dh_tax"))?"⬛":"⬜" %></span>上傳
                                <span><%="N".equals(dh.getString("dh_tax"))?"⬛":"⬜" %></span>不上傳
                            </td>
                        </tr>
                        
                        <tr>
                            <td colspan="2">
                                *是否提供給稅務稽徵機關作為當年度綜合所得稅捐贈資料之歸戶作業。<br>
                                *公司行號/法人/一般團體(※不提供上傳國稅局報稅服務)<br>
                                *捐款可100％自個人當年度綜合所得/企業營利所得總額中扣除。
                            </td>
                        </tr>
                        
                    </tbody>
                        
                </table>

                <p class="notice">
                    捐款洽詢專線：<%=contact_info %>	E-mail：<%=contact_email %>
                </p>
                
            </div>

        </div>
        
        <iframe style="position: fixed; right: 0px; bottom: 0px; width: 0px; height: 0px; border: 0px; padding: 0px; margin: 0px;" 
        		src="donate_print.jsp?dh_id=<%=real_dh_id %>" id="print_page">
        </iframe>

        
		<script type="text/javascript">
			<%--
            function printPage(type){
                // CSS+JS控制列印方向 By Eric
                // 建立添加樣式
                var print_css  = document.createElement("style"); //print_css.id="print_style";
                $("head").append(print_css);
                // 新增樣式規則
                if(type=="landscape"){ // 橫向列印
                    print_css.sheet.insertRule("@page { size: landscape; margin: 0;}",0);
                }else{// 縱向列印
                    print_css.sheet.insertRule("@page { size: portrait; margin: 0;}",0);
                }
                // 列印指定範圍 By Eric
                var source_html = $("body").html();
                var print_html = $("#overPrint").html();
                $("body").html(print_html);
                window.print();
                $("body").html(source_html);
                $(print_css).remove();
            }
            --%>
            
            <%-- 變更列印寫法 - 使用 iframe 20250508 May --%>
            function printPage(type) {
            	const iframe = document.getElementById('print_page');
                const doc = iframe.contentDocument || iframe.contentWindow.document;

                setTimeout(function () {
                    iframe.contentWindow.focus();
                    iframe.contentWindow.print();
                }, 500); // 可根據圖片量調整延遲
            }
        </script>
    
	<!-- InstanceEndEditable -->
        
    </div>  

</body>
<!-- InstanceEnd --></html>
<%@include file="/WEB-INF/jspf/connclose.jspf" %>