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
	
	if("".equals(dh.getString("dh_id"))) {
		out.println("<script> alert('捐款資料有誤!!'); </script>");
		return;
	}
	
	/*-- 捐款資訊 --*/
	// 捐款日期
	SimpleDateFormat sdf_f = new SimpleDateFormat("yyyy年MM月dd日");
	SimpleDateFormat sdf_p = new SimpleDateFormat("yyyy/MM/dd");
	Calendar donate_date = Calendar.getInstance();
	
	try {
		donate_date.setTime(sdf_p.parse(dh.getString("dh_donatedate")));
	} catch(Exception e){
		out.println("<script> alert('受贈日期有誤!!'); </script>");
		return;
	}
	
	// 身分證字號/統編
	String dh_pid = dh.getString("dh_pid");
	
	if(!"".equals(dh_pid) && dh_pid.contains("==")) dh_pid = new AESDataEncryption().AESDecrypt(dh_pid);
	
	// 地址
	String dh_address = dh.getString("dh_zipcode")+dh.getString("dh_county")+dh.getString("dh_city")+dh.getString("dh_address");

	// 捐物單標題(共4聯)
	String[] receipt_titles = {
			"第一聯 (校友服務中心)","第二聯 (保管組)","第三聯 (受贈單位)","第四聯 (使用單位)"
	};
	
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
	
	<!-- 天主教靜宜大學_受贈財物簽辦單 -->
	<link rel="stylesheet" href="../css/style_nav/style_receipt/style_gift_approval_receipt.css">
	
	<!-- InstanceEndEditable -->
</head>

<body>
    
    <!--一頁A4大小-->
    <%for(String receipt_title:receipt_titles){ %>
    <div class="page_print" style="page-break-before: always;">

        <!--table header區塊-->
        <div class="donation_form_header">
            <strong>
                國立臺灣<img class="logo" src="<%=url %>/images/logo.webp" alt="">大學受贈財物簽辦單
            </strong>
            <div class="couplet">
                <%=receipt_title %>
            </div>
            <div class="donation_code">捐物單號：<%=dh.getString("dh_no") %></div>
            <div class="date">簽辦日期：<%=sdf_f.format(donate_date.getTime()) %></div>
        </div>
        <div class="donation_red">
            *為必填欄位
        </div>
        <div class="basic_information_area">
            
            <!--table body區塊_基本資料-->
            <table class="basic_information basic_information1" cellpadding="0" cellspacing="0" border="0">
                
                <tbody>
                    
                    <tr>
                        <td rowspan="6" class="basic_information_title" width="8">
                            <div class="title">
                                捐贈者基本資料
                            </div>
                        </td>                                
                        <td width="103"><div class="title">姓名/機構名稱<div class="donation_red">*</div></div></td>
                        <td width="32%"><div class="fillBlank"><%=dh.getString("dh_name") %></div></td>
                        <td width="20%"><div class="title">身分證字號/統一編號<div class="donation_red">*</div></div></td>
                        <td><div class="fillBlank"><%=dh_pid %></div></td>
                    </tr>
        
                    <tr>
                        <td>聯絡方式<div class="donation_red">*</div></td>
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
                        <td>通訊地址<div class="donation_red">*</div></td>
                        <td  colspan="4">
                            <div class="fillBlank"><%=dh_address %></div>
                        </td>
                    </tr>
        
                    <tr>
                        <td>電子信箱<div class="donation_red">*</div></td>
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
                     <td>服務單位</td>
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
                        <td rowspan="7" class="basic_information_title" width="8">
                            <div class="title">
                                捐贈內容
                            </div>
                        </td>

                        <td width="103">
                            <div class="title">
                                受贈日期<div class="donation_red">*</div>
                            </div>
                        </td>

                        <td width="" colspan="1">
                        	<%=dh.getString("dh_donatedate") %>
                        </td>

                        <!-- 財物屬性 -->
                        <td class="basic_information_in" rowspan="3" colspan="2">
                            <div class="">
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tbody>
                                        <tr>
                                            <td>

                                                <div class="basic_information_title propType">
                                                    <div class="title">
                                                        <div class="donation_red">*</div>
                                                        財物屬性
                                                    </div>
                                                </div>
                                                <div class="assetType_area">
                                                    <div class="list">
                                                        <span><%="1".equals(dh.getString("dh_donate_project_category"))?"⬛":"⬜" %></span>1.財產(單價超過新台幣1萬元以上)
                                                        <p>
                                                            【需附(1)捐贈者同意捐贈表示文件(含有無附負擔條件說明)；及(2)財物照片】
                                                        </p>
                                                    </div>
                                                    <div class="list">
                                                        <span><%="2".equals(dh.getString("dh_donate_project_category"))?"⬛":"⬜" %></span>2.非消耗品(單價新台幣1萬元以下)
                                                        <p>
                                                            【需附財物照片】 
                                                        </p>
                                                    </div>
                                                    <div class="list">
                                                        <span><%="3".equals(dh.getString("dh_donate_project_category"))?"⬛":"⬜" %></span>3.消耗品
                                                    </div>
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
                            <div class="title">
                                財物名稱<div class="donation_red">*</div>
                            </div>
                        </td>
                        <td colspan="1">
                            <div class="fillBlank"><%=dh.getString("dh_financialname") %></div>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <div class="title">
                                數量<div class="donation_red">*</div>
                            </div>
                        </td>
                        <td colspan="1">
                            <div class="fillBlank"><%=dh.getString("dh_num") %></div>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <div class="title">
                                型式規格<div class="donation_red">*</div>
                            </div>
                        </td>
                        <td colspan="3">
                            <div class="fillBlank"><%=dh.getString("dh_typespec") %></div>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <div class="title">
                                購置金額
                            </div>
                        </td>
                        <td colspan="3">
                            <div class="fillBlank">
                                新台幣 <%=app_df.format(dh.getInt("dh_total")) %> 元整，數量 <%=dh.getString("dh_num")+" "+dh.getString("dh_num_unit") %>
                            </div>
                            <!-- <br> -->
                            <p>(請附原始憑證-原購發票或收據)</p>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <div class="title">
                                購置日期
                            </div>
                        </td>
                        <td width="">
                            <div class="fillBlank"><%=dh.getString("dh_placedate") %></div>
                        </td>
                        <td width="">
                            <div class="title">
                                放置地點
                            </div>
                        </td>
                        <td>
                            <div class="fillBlank"><%=dh.getString("dh_placelocaction") %></div>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <div class="title">
                                捐贈用途<div class="donation_red">*</div>
                            </div>
                        </td>
                        <td colspan="3">
                            <div class="donationUse">
                                <div class="list">
                                    <div class="title">
                                        <span><%="1".equals(dh.getString("dh_donate_project"))?"⬛":"⬜" %></span>未指定
                                    </div>
                                </div>
                                <div class="list">
                                    <div class="title">
                                        <span><%="2".equals(dh.getString("dh_donate_project"))?"⬛":"⬜" %></span>指定使用單位
                                        <div class="fillBlank"><%="2".equals(dh.getString("dh_donate_project"))?dh.getString("dh_donate_project_title"):"" %></div>
                                    </div>
                                </div>
                                <div class="list">
                                    <div class="title">
                                        <span><%="3".equals(dh.getString("dh_donate_project"))?"⬛":"⬜" %></span>指定用途說明
                                        <div class="fillBlank"><%="3".equals(dh.getString("dh_donate_project"))?dh.getString("dh_donate_project_title"):"" %></div>
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                    
                </tbody>
                    
            </table>

        
            <p class="notice">
                ※	本單共分四聯，第一聯為受贈財物捐贈登記聯，第二聯為受贈財物核報聯，第三聯、第四聯為存查聯。
                <br>
                ※	奉核後請檢附完整附件送「保管組」及「校友服務中心」各一份憑辦。
            </p>
            
            <!--table body區塊_收據-->
            <table class="basic_information basic_information3" cellpadding="0" cellspacing="0" border="0">
                <thead>
                    <tr>
                        <th colspan="4">
                            校內單位簽辦
                        </th>
                    </tr>
                </thead>
                <tbody>
                    
                    <tr>
                        <td width="131">
                            <div class="title">受贈單位</div>
                        </td>
                        <td colspan="">
                            <div class="sign_area">
                                <div class="title">承辦人</div>		
                                <div class="fillBlank">
                                    <!-- <img src="images/seal.png" alt=""> -->
                                </div>    	
                            </div>
                        </td>
                        <td>
                            <div class="sign_area">
                                <div class="title">二級主管</div>
                                <div class="fillBlank">
                                    <!-- <img src="images/seal.png" alt=""> -->
                                </div>    	
                            </div>   
                        </td>
                        <td>
                            <div class="sign_area">
                                <div class="title">一級主管</div>
                                <div class="fillBlank">
                                    <!-- <img src="images/seal.png" alt=""> -->
                                </div>    	
                            </div>   
                        </td>
                    </tr>
                    
                    <tr>
                        <td width="">
                            <div class="title">使用單位<span>(未指定則免會)</span></div>                                    
                        </td>
                        <td colspan="">
                            <div class="sign_area">
                                <div class="title">承辦人</div>		
                                <div class="fillBlank">
                                    <!-- <img src="images/seal.png" alt=""> -->
                                </div>    	
                            </div>  
                        </td>
                        <td>
                            <div class="sign_area">
                                <div class="title">單位主管</div>
                                <div class="fillBlank">
                                    <!-- <img src="images/seal.png" alt=""> -->
                                </div>    	
                            </div>   	
                        </td>
                        <td>
                            <!-- <div class="title">一級主管</div>
                            <div class="fillBlank"></div>    	 -->
                        </td>
                    </tr>
                    
                    <tr>
                        <td width="">
                            <div class="title">校友服務中心</div>
                        </td>
                        <td colspan="">
                            <div class="sign_area">
                                <div class="title">承辦人</div>		
                                <div class="fillBlank">
                                    <!-- <img src="images/seal.png" alt=""> -->
                                </div>    	
                            </div>  
                        </td>
                        <td>
                            <div class="sign_area">
                                <div class="title">單位主管</div>
                                <div class="fillBlank">
                                    <!-- <img src="images/seal.png" alt=""> -->
                                </div>    	
                            </div>   	
                        </td>
                        <td>
                            <!-- <div class="title">一級主管</div>
                            <div class="fillBlank"></div>    	 -->
                        </td>
                    </tr>
                    
                    <tr>
                        <td colspan="">
                            <div class="title">
                                保管組
                                <span>
                                    (財務屬性1及2需會保管組)
                                </span>
                            </div>
                        </td>
                        <td colspan="">
                            <div class="sign_area">
                                <div class="title">承辦人</div>		
                                <div class="fillBlank">
                                    <!-- <img src="images/seal.png" alt=""> -->
                                </div>    	
                            </div>  
                        </td>
                        <td>
                            <div class="sign_area">
                                <div class="title">單位主管</div>
                                <div class="fillBlank">
                                    <!-- <img src="images/seal.png" alt=""> -->
                                </div>    	
                            </div>   	
                        </td>
                        <td>
                            <!-- <div class="title">一級主管</div>
                            <div class="fillBlank"></div> -->
                        </td>
                    </tr>

                    <tr>
                        <td><div class="title">主計室</div></td>
                        <td colspan="3"></td>
                    </tr>

                    <tr>
                        <td><div class="title">校長核定</div></td>
                        <td colspan="3"></td>
                    </tr>

                </tbody>
                    
            </table>


        </div>
        
    </div>
<%} %> 

</body>
<!-- InstanceEnd --></html>
<%@include file="/WEB-INF/jspf/connclose.jspf" %>