<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@include file="/WEB-INF/jspf/config.jspf" %>
<%@include file="/WEB-INF/jspf/mis/check.jspf" %>
<%!
	 //大寫數字
	 private static final String[] NUMBERS = {"零","壹","貳","叄","肆","伍","陸","柒","捌","玖"};
	 // 整數部分的單位
	 private static final String[] IUNIT = {"元","拾","佰","仟","萬","拾","佰","仟","億","拾","佰","仟","萬","拾","佰","仟"};
	 //小數部分的單位
	 private static final String[] DUNIT = {"角","分","釐"};
	 
	 //轉成中文的大寫金額
	 public static String toChinese(String str) {
	 boolean flag = false;
	 
	 str = str.replaceAll(",", "");//去掉","
	 String integerStr;//整數部分數字
	 String decimalStr;//小數部分數字
	 
	 //初始化：分離整數部分和小數部分
	 if(str.indexOf(".")>0) {
		 integerStr = str.substring(0,str.indexOf("."));
	 	decimalStr = str.substring(str.indexOf(".")+1);
	 }else if(str.indexOf(".")==0) {
	 	integerStr = "";
		 decimalStr = str.substring(1);
	 }else {
		 integerStr = str;
		 decimalStr = "";
	 }
	 
	 //beyond超出計算能力，直接返回
	 if(integerStr.length()>IUNIT.length) {
		 System.out.println(str+"：超出計算能力");
		 return str;
	 }
	 
	 int[] integers = toIntArray(integerStr);//整數部分數字
	 //判斷整數部分是否存在輸入012的情況
	 if (integers.length>1 && integers[0] == 0) {
	 System.out.println("抱歉，請輸入數字！");
	 if (flag) {
	 	str = "-"+str;
	 }
	 return str;
	 }
	 boolean isWan = isWan5(integerStr);//設置萬單位
	 int[] decimals = toIntArray(decimalStr);//小數部分數字
	 	String result = getChineseInteger(integers,isWan)+getChineseDecimal(decimals);//返回最終的大寫金額
	 if(flag){
	 	return "負"+result;//如果是負數，加上"負"
	 }else{
	 	return result;
	 }
	 }
	 
	 //將字符串轉爲int數組
	 private static int[] toIntArray(String number) {
	 int[] array = new int[number.length()];
	 for(int i = 0;i<number.length();i++) {
	 	array[i] = Integer.parseInt(number.substring(i,i+1));
	 }
	 	return array;
	 }
	 //將整數部分轉爲大寫的金額
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
	 //將小數部分轉爲大寫的金額
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
	 //判斷當前整數部分是否已經是達到【萬】
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
	//相關參數設定
	String code 		= "receipt";				// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "收據管理作業";				// 功能標題
	
	// Conditions.
	String qposition = StringTool.validString(request.getParameter("_qposition"));
	String qcollect	 = StringTool.validString(request.getParameter("_qcollect"));
	String qship	 = StringTool.validString(request.getParameter("_qship"));
	String qpayment = StringTool.validString(request.getParameter("_qpayment"));
	String qivoice = StringTool.validString(request.getParameter("_qivoice"));
	
	String qosno = StringTool.validString(request.getParameter("_qosno"));
	String qname = StringTool.validString(request.getParameter("_qname"));
	String qphone = StringTool.validString(request.getParameter("_qphone"));
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"));
	
	String qrlno	 = StringTool.validString(request.getParameter("_qrlno"));
	String action = StringTool.validString(request.getParameter("action"));
	
	if("".equals(qposition)) {qposition = "Y";}
	if("".equals(qcollect)) {qcollect = "%";}
	if("".equals(qship)) {qship = "%";}
	/*
	if("".equals(qrlno)) {qrlno = "%";}
	*/
	
	String def_qrestdate = "2099/12/31" , def_qemitdate = DateTimeTool.dateString(DateTimeTool.getYear()-1,DateTimeTool.getMonth(),DateTimeTool.getDay());
	if("".equals(qemitdate)) {qemitdate = def_qemitdate;}
	if("".equals(qrestdate)) {qrestdate = def_qrestdate;}
	
	// Names and values.
	String[] names = new String[] { "npage", "_qposition", "_qname", "_qemitdate", "_qrestdate", "_qship", "_qcollect","_qosno","_qpayment","_qivoice","_qrlno", "action"};
	String[] values = new String[] { String.valueOf(pageno), qposition, qname, qemitdate, qrestdate, qship, qcollect, qosno,qpayment,qivoice,qrlno, action };
	
	// Selected id.
	String rs_id = StringTool.validString(request.getParameter("rs_id"));
	// Get record.
	TableRecord rs = app_sm.select(tblrs, rs_id);
	// 將數字轉成中文填入
	int os_total = rs.getInt("os_total");
	String total_ = toChinese(String.valueOf(os_total))+"整";
	
	if(!"".equals(rs.getString("os_total_cn")))total_ = rs.getString("os_total_cn");

%>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/><!--讓ie在切換瀏覽器模式時 文件模式會使用最新的版本-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="Robots" content="none" /><!--不被搜尋引擎搜到-->

<!--RWD用-->
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<!--RWD用-->

<!--android 手機板主題顏色用 更改網址列顏色-->
<meta name="theme-color" content="#0f4c81">
<!--android 手機板主題顏色用-->

<meta name="format-detection" content="telephone=no"><!--取消行動版 safari 自動偵測數字成電話號碼-->

<title>捐款收據</title>
<link rel="shortcut icon" href="../../web/images/favicon.png" /><!--電腦版icon-->
<link rel="apple-touch-icon" href="../../web/images/icon.png" /><!--手機版icon  57x57px-->
<link rel="apple-touch-icon" sizes="72x72" href="../../web/images/icon-72.png" /><!--手機版icon  72x72px-->
<link rel="apple-touch-icon" sizes="114x114" href="../../web/images/icon@2.png" /><!--手機版icon  114x114px-->
<script src="../../web/js/jquery-1.10.2.min.js" type="text/javascript"></script>
</head>

<body>

            <!--列印範圍-->
            <div class="overPrint" id="overPrint">
                    
                    
                <div class="page" style=" overflow: hidden;
                                          width: 297mm;
                                          height: 210mm;
                                          padding: 15mm 8.4mm;
                                          margin: 0.2mm auto;
                                          border-bottom: 1px #ccc solid;
                                          background: white;
                                          box-sizing: border-box;
                                          position: relative;
                                          page-break-after: auto;"><!--一頁A4大小-->
                
                    <div class="pageIn" style="width: 100%;
                                                height: 100%;
                                                margin: 0 auto;" >
                    
                    	<!--第一個區塊-->
                    	<div class="pageListTop" style="display: flex;
                                                        flex-direction: row;
                                                        flex-wrap: nowrap;
                                                        align-items: flex-end;
                                                        justify-content: space-between;
                                                        margin-bottom: 40px;">
                        
                            <div class="receiptLogo" style="flex: 3;
                                                            box-sizing:border-box;
                                                            min-width: 350px;
                                                            flex-grow: 0;
                                                            flex-shrink: 0;">
                            	<img src="../images/logo_01.png" style="width:100%; height:auto;" />
                            </div>                       
                        
                            <div class="receiptTit" style="box-sizing: border-box;
                                                                       font-size: 67px;
                                                                       line-height: 67px;
                                                                       flex: 4;
                                                                       text-align: center;">
                            	捐款收據
                            </div>                         
                        
                            <div class="receiptNumbering" style="box-sizing:border-box;
                                                                 font-size:30px;
                                                                 line-height:40px;
                                                                 flex: 3;
                                                                 text-align: right;">
                            	NO：<span><%=rs.getString("rs_no")%></span>
                            </div> 
                        
                        </div>
                    
                    	<!--第二個區塊-->
                    	<div class="pageListMiddle">
                        
                            <div class="pageListMiddleL" style="box-sizing: border-box;
    																		border: 1px #b3b3b3 solid;">
                            
                                <div class="pageList" style="padding: 30px 20px;
															 border-bottom: 1px #b3b3b3 solid;">
                                
                                    <div class="pageListIn" style="display: flex;
                                                                            flex-direction: row;
                                                                            flex-wrap: nowrap;
                                                                            align-items: center;
                                                                            box-sizing: border-box;
                                                                            padding-bottom: 20px;">
                                        <div class="rI_tit" style="display: inline-block;
                                                                   box-sizing: border-box;
                                                                   font-size: 30px;
                                                                   font-weight: bold;">
                                            捐贈者：<%=rs.getString("os_order_name")%>
                                        </div>
                                        <div class="rI_info" style="font-family: 標楷體;
                                                                    display: inline-block;
                                                                    box-sizing: border-box;
                                                                    font-size: 30px;
                                                                    line-height: 27px;
                                                                    font-weight: lighter;
                                                                    vertical-align: bottom;
                                                                    overflow: hidden;
                                                                    text-overflow: ellipsis;
                                                                    white-space: nowrap;">
                                        </div>
                                    </div>
                                
                                    <div class="pageListIn pageListInDate" style="display: flex;
                                                                                    flex-direction: row;
                                                                                    flex-wrap: nowrap;
                                                                                    align-items: center;
                                                                                    box-sizing: border-box;
                                                                                    padding-bottom: 20px;">
                                        <div class="rI_tit" style="display: inline-block;
                                                                    box-sizing: border-box;
                                                                    font-size: 30px;
                                                                    font-weight: bold;">
                                            日期：
                                        </div>
                                        <div class="rI_info" style="font-family: 標楷體;
                                                                    box-sizing: border-box;
                                                                    font-size: 30px;
                                                                    line-height: 27px;
                                                                    font-weight: lighter;
                                                                    vertical-align: bottom;
                                                                    overflow: hidden;
                                                                    text-overflow: ellipsis;
                                                                    white-space: nowrap;
                                                                    display: flex;
                                                                    flex-direction: row;
                                                                    flex-wrap: nowrap;
                                                                    align-items: center;">
                                        	<div style="width: 95px;
                                                        box-sizing: border-box;
                                                        text-align: center;
                                                        overflow: hidden;
                                                        text-overflow: ellipsis;
                                                        white-space: nowrap;"><%=DateTimeTool.getYear() %></div>
                                        	<span style="width: auto; box-sizing: border-box;">年</span>
                                        	<div style="width: 95px;
                                                        box-sizing: border-box;
                                                        text-align: center;
                                                        overflow: hidden;
                                                        text-overflow: ellipsis;
                                                        white-space: nowrap;"><%=DateTimeTool.getMonth() %></div>
                                        	<span style="width: auto; box-sizing: border-box;">月</span>
                                        	<div style="width: 95px;
                                                        box-sizing: border-box;
                                                        text-align: center;
                                                        overflow: hidden;
                                                        text-overflow: ellipsis;
                                                        white-space: nowrap;"><%=DateTimeTool.getDay() %></div>
                                        	<span style="width: auto; box-sizing: border-box;">日</span>                                            
                                        </div>
                                    </div> 
                                    
                                    <div class="pageListIn" style="display: flex;
                                                                    flex-direction: row;
                                                                    flex-wrap: nowrap;
                                                                    align-items: center;
                                                                    box-sizing: border-box;
                                                                    padding-bottom: 20px;">
                                        <div class="rI_tit" style="display: inline-block;
                                                                    box-sizing: border-box;
                                                                    font-size: 30px;
                                                                    font-weight: bold;">
                                            抬頭：<%=rs.getString("os_order_name")%>
                                        </div>
                                        <div class="rI_info" style="font-family: 標楷體;
                                                                    box-sizing: border-box;
                                                                    font-size: 30px;
                                                                    line-height: 27px;
                                                                    font-weight: lighter;
                                                                    vertical-align: bottom;
                                                                    overflow: hidden;
                                                                    text-overflow: ellipsis;
                                                                    white-space: nowrap;
                                                                    display: flex;
                                                                    flex-direction: row;
                                                                    flex-wrap: nowrap;
                                                                    align-items: center;">
                                        </div>
                                    </div>
                                                                    
                                    <div class="pageListIn Amount" style="display: flex;
                                                                            flex-direction: row;
                                                                            flex-wrap: nowrap;
                                                                            align-items: center;
                                                                            box-sizing: border-box;
                                                                            padding-bottom: 20px;">
                                        <div class="rI_tit" style="display: inline-block;
                                                                    box-sizing: border-box;
                                                                    font-size: 30px;
                                                                    font-weight: bold;">
                                            捐贈金額：<%=app_df.format(rs.getInt("os_total")) %> &emsp;&emsp;&emsp; 新台幣
                                        </div>
                                        <div class="rI_info" style="font-family: 標楷體;
                                                                    box-sizing: border-box;
                                                                    font-size: 30px;
                                                                    line-height: 27px;
                                                                    font-weight: lighter;
                                                                    vertical-align: bottom;
                                                                    overflow: hidden;
                                                                    text-overflow: ellipsis;
                                                                    white-space: nowrap;
                                                                    display: flex;
                                                                    flex-direction: row;
                                                                    flex-wrap: nowrap;
                                                                    align-items: center;
                                                                    display: flex;
                                                                    flex-direction: row;
                                                                    flex-wrap: nowrap;
                                                                    align-items: center;">
<div style="width: 95px;
               box-sizing: border-box;
               text-align: center;
               overflow: hidden;
               text-overflow: ellipsis;
               white-space: nowrap;"></div>
                            
										<span style="width: auto; box-sizing: border-box;"> <%=total_ %></span>                                                                    
<%--
<div style="width: 95px;
               box-sizing: border-box;
               text-align: center;
               overflow: hidden;
               text-overflow: ellipsis;
               white-space: nowrap;"></div>
               
<span style="width: auto; box-sizing: border-box;">萬</span>
<div style="width: 95px;
               box-sizing: border-box;
               text-align: center;
               overflow: hidden;
               text-overflow: ellipsis;
               white-space: nowrap;"></div>
               
<span style="width: auto; box-sizing: border-box;">仟</span>
<div style="width: 95px;
               box-sizing: border-box;
               text-align: center;
               overflow: hidden;
               text-overflow: ellipsis;
               white-space: nowrap;"></div>
               
<span style="width: auto; box-sizing: border-box;">佰</span>  
<div style="width: 95px;
               box-sizing: border-box;
               text-align: center;
               overflow: hidden;
               text-overflow: ellipsis;
               white-space: nowrap;"></div>
               
<span style="width: auto; box-sizing: border-box;">拾</span>
<div style="width: 95px;
               box-sizing: border-box;
               text-align: center;
               overflow: hidden;
               text-overflow: ellipsis;
               white-space: nowrap;"></div>
               
<span style="width: auto; box-sizing: border-box;">元整</span>    
 --%>


                                        	
                                        	                                        
                                        </div>
                                    </div>                                
                                
                                    <div class="pageListIn" style=" display: flex;
                                                                    flex-direction: row;
                                                                    flex-wrap: nowrap;
                                                                    align-items: center;
                                                                    box-sizing: border-box;
                                                                    padding-bottom: 0px;">
                                        <div class="rI_tit" style=" display: inline-block;
                                                                    box-sizing: border-box;
                                                                    font-size: 30px;
                                                                    font-weight: bold;">
                                            身分證字號 / 統一編號 ：<%=rs.getString("os_pid")%>
                                        </div>
                                        <div class="rI_info" style="font-family: 標楷體;
                                                                    box-sizing: border-box;
                                                                    font-size: 30px;
                                                                    line-height: 27px;
                                                                    font-weight: lighter;
                                                                    vertical-align: bottom;
                                                                    overflow: hidden;
                                                                    text-overflow: ellipsis;
                                                                    white-space: nowrap;
                                                                    display: flex;
                                                                    flex-direction: row;
                                                                    flex-wrap: nowrap;
                                                                    align-items: center;
                                                                    display: flex;
                                                                    flex-direction: row;
                                                                    flex-wrap: nowrap;
                                                                    align-items: center;">
                                        </div>
                                    </div>
                                    
                                </div>
<%--
                                <div class="pageList" style="padding: 30px 20px;
															border-bottom: 1px #b3b3b3 solid;">
                                    <div class="rI_tit" style="display: inline-block;
                                                               box-sizing: border-box;
                                                               font-size: 30px;
                                                               font-weight: bold;">
                                        收款方式：
                                    </div>
                                    <div class="rI_info" style="font-family: 標楷體;
                                                                box-sizing: border-box;
                                                                font-size: 30px;
                                                                line-height: 27px;
                                                                font-weight: lighter;
                                                                vertical-align: bottom;
                                                                overflow: hidden;
                                                                text-overflow: ellipsis;
                                                                white-space: nowrap;
                                                                display: flex;
                                                                flex-direction: row;
                                                                flex-wrap: nowrap;
                                                                align-items: center;
                                                                display: flex;
                                                                flex-direction: row;
                                                                flex-wrap: nowrap;
                                                                align-items: center;">                                       
                                    </div>
                                </div>
 --%>
                            
                                <div class="pageList" style="padding: 30px 20px;
                                                            display: flex;
                                                            flex-direction: row;
                                                            flex-wrap: nowrap;">
                                    <div class="pageListIn" style="display: flex;
                                                                    flex-direction: row;
                                                                    flex-wrap: nowrap;
                                                                    align-items: center;
                                                                    box-sizing: border-box;
                                                                    padding-bottom: 0px;
                                                                    width: 33.3%;">
                                        <div class="rI_tit" style="display: inline-block;
                                                                    box-sizing: border-box;
                                                                    font-size: 30px;
                                                                    font-weight: bold;"> 
                                            會長：
                                        </div>
                                        <div class="rI_info" style="font-family: 標楷體;
                                                                    box-sizing: border-box;
                                                                    font-size: 30px;
                                                                    line-height: 27px;
                                                                    font-weight: lighter;
                                                                    vertical-align: bottom;
                                                                    overflow: hidden;
                                                                    text-overflow: ellipsis;
                                                                    white-space: nowrap;
                                                                    display: flex;
                                                                    flex-direction: row;
                                                                    flex-wrap: nowrap;
                                                                    align-items: center;
                                                                    display: flex;
                                                                    flex-direction: row;
                                                                    flex-wrap: nowrap;
                                                                    align-items: center;">
                                        </div>
                                    </div>
                                    <div class="pageListIn" style="display: flex;
                                                                    flex-direction: row;
                                                                    flex-wrap: nowrap;
                                                                    align-items: center;
                                                                    box-sizing: border-box;
                                                                    padding-bottom: 0px;
                                                                    width: 33.3%;">
                                        <div class="rI_tit" style="display: inline-block;
                                                                    box-sizing: border-box;
                                                                    font-size: 30px;
                                                                    font-weight: bold;"> 
                                            會計：
                                        </div>
                                        <div class="rI_info" style="font-family: 標楷體;
                                                                    box-sizing: border-box;
                                                                    font-size: 30px;
                                                                    line-height: 27px;
                                                                    font-weight: lighter;
                                                                    vertical-align: bottom;
                                                                    overflow: hidden;
                                                                    text-overflow: ellipsis;
                                                                    white-space: nowrap;
                                                                    display: flex;
                                                                    flex-direction: row;
                                                                    flex-wrap: nowrap;
                                                                    align-items: center;
                                                                    display: flex;
                                                                    flex-direction: row;
                                                                    flex-wrap: nowrap;
                                                                    align-items: center;">
                                        </div>
                                    </div>                                    
                                    <div class="pageListIn" style="display: flex;
                                                                    flex-direction: row;
                                                                    flex-wrap: nowrap;
                                                                    align-items: center;
                                                                    box-sizing: border-box;
                                                                    padding-bottom: 0px;
                                                                    width: 33.3%;">
                                        <div class="rI_tit" style="display: inline-block;
                                                                    box-sizing: border-box;
                                                                    font-size: 30px;
                                                                    font-weight: bold;"> 
                                            經手人：
                                        </div>
                                        <div class="rI_info" style="font-family: 標楷體;
                                                                    box-sizing: border-box;
                                                                    font-size: 30px;
                                                                    line-height: 27px;
                                                                    font-weight: lighter;
                                                                    vertical-align: bottom;
                                                                    overflow: hidden;
                                                                    text-overflow: ellipsis;
                                                                    white-space: nowrap;
                                                                    display: flex;
                                                                    flex-direction: row;
                                                                    flex-wrap: nowrap;
                                                                    align-items: center;
                                                                    display: flex;
                                                                    flex-direction: row;
                                                                    flex-wrap: nowrap;
                                                                    align-items: center;">
                                        </div>
                                    </div>
                                </div>
                                                                
                            </div>                        
                        
                        
                        </div>                     
                     
                     	<!--第三個區塊-->
                    	<!--<div class="pageListBottom" style="width: 100%;
                                                    display: flex;
                                                    flex-direction: row;
                                                    flex-wrap: wrap;
                                                    align-items: center;
                                                    justify-content: space-between;
                                                    margin: 40px 0px 0px;">
                        
                            <div class="pageListIn" style=" width: 48%;
                                                            box-sizing: border-box;
                                                            font-size: 16px;
                                                            display: flex;
                                                            flex-direction: row;
                                                            flex-wrap: nowrap;
                                                            align-items: center;">
                                <div class="rI_tit" style="font-size: 18px;
                                                           display: inline-block;
                                                           box-sizing: border-box;
                                                           font-weight: bold;">
                                    法人登記：
                                </div>
                                <div class="rI_info" style="font-family: 標楷體;
                                                            box-sizing: border-box;
                                                            font-size: 18px;
                                                            line-height: 27px;
                                                            font-weight: bold;
                                                            vertical-align: bottom;
                                                            overflow: hidden;
                                                            text-overflow: ellipsis;
                                                            white-space: nowrap;
                                                            display: flex;
                                                            flex-direction: row;
                                                            flex-wrap: nowrap;
                                                            align-items: center;
                                                            display: flex;
                                                            flex-direction: row;
                                                            flex-wrap: nowrap;
                                                            display: inline-block;
                                                            align-items: center;"><%=SiteSetup.getText("cp.law.no."+lang) %></div>
                            </div>

                            <div class="pageListIn" style=" width: 48%;
                                                            box-sizing: border-box;
                                                            font-size: 16px;
                                                            display: flex;
                                                            flex-direction: row;
                                                            flex-wrap: nowrap;
                                                            align-items: center;">
                                <div class="rI_tit" style="font-size: 18px;
                                                           display: inline-block;
                                                           box-sizing: border-box;
                                                           font-weight: bold;">
                                    核准案例字號：
                                </div>
                                <div class="rI_info" style="font-family: 標楷體;
                                                            box-sizing: border-box;
                                                            font-size: 18px;
                                                            line-height: 27px;
                                                            font-weight: bold;
                                                            vertical-align: bottom;
                                                            overflow: hidden;
                                                            text-overflow: ellipsis;
                                                            white-space: nowrap;
                                                            display: flex;
                                                            flex-direction: row;
                                                            flex-wrap: nowrap;
                                                            align-items: center;
                                                            display: flex;
                                                            flex-direction: row;
                                                            flex-wrap: nowrap;
                                                            display: inline-block;
                                                            align-items: center;"><%=SiteSetup.getText("cp.case.no."+lang) %></div>
                            </div>
                            
                        </div>-->
                        
                    </div>
                    
                
                </div>
    
                
            </div>
            
            <!--按鍵區-->
            <div class="btn_area one" style="padding: 32px 0px;
                                             text-align: center;
                                             position: relative;
                                             z-index: 9;">
                <input type="submit" value="列印" class="printBtn" onclick="printPage('portrait');"  style="-webkit-appearance: none; -webkit-border-radius: 0px; margin: 0px 45px; padding: 0; outline: none; cursor: pointer; vertical-align: middle; border: none; width: 162px; height: 42px; background: #0f4c81; color: #fff; border-radius: 5px; line-height: 42px; transition: 0.2s ease all; letter-spacing: 1px;"/>
            </div>                      
            
            <script type="text/javascript">
                function printPage(type){
                    // CSS+JS控制列印方向 By Eric
                    // 建立添加樣式
                    var print_css  = document.createElement("style"); //print_css.id="print_style";
                    $("head").append(print_css);
                    // 新增樣式規則
                    if(type=="landscape"){ // 橫向列印
                        print_css.sheet.insertRule("@page { size: landscape;}",0);
                    }else{// 縱向列印
                        print_css.sheet.insertRule("@page { size: portrait;}",0);
                    }
                    // 列印指定範圍 By Eric
                    var source_html = $("body").html();
                    var print_html = $("#overPrint").html();
                    $("body").html(print_html);
                    window.print();
                    $("body").html(source_html);
                    $(print_css).remove();
                }
            </script>
</body>
</html>
