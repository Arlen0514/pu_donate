<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<%@ page import="java.util.List" %>
<%@include file="config.jsp"%>
<% 
	String page_code = "newebpay_credit";						// 功能識別碼

	// 信用卡交易返回值
  	String HashKey 	  		= SiteSetup.getText("newebpay.HashKey"); 						// Hashkey	
	String HashIV 	  		= SiteSetup.getText("newebpay.HashIV"); 						// HashIV
	String TradeInfo 		= StringTool.validString(request.getParameter("TradeInfo"));	// 交易資料AES加密
	String TradeSha 		= StringTool.validString(request.getParameter("TradeSha"));		// 交易資料SHA256加密
	
	// AES解密回傳資訊
	TradeInfo 				= decryptAES(HashKey,HashIV,TradeInfo);	
	
	JSONObject jsonObj 		= new JSONObject(TradeInfo);
	String status			= jsonObj.getString("Status");
	String Message			= jsonObj.getString("Message");
	
	// 回傳結果參數
	JSONObject result 		= jsonObj.getJSONObject("Result"); 	
	String MerchantOrderNo 	= result.getString("MerchantOrderNo");	// 商店訂單編號
	String TradeNo 			= "";									// 藍新金流交易序號
	int Amt					= result.getInt("Amt");					// 交易金額
	String PaymentType 		= "";									// 支付方式
	String PayTime 			= "";									// 支付完成時間
	String Card4No 			= "";									// 卡號末四碼
	String RespondCode 		= "";									// 回應碼

	//判断JSONObject是否回傳交易序號   
	if(result.has("TradeNo")) {  			    
		TradeNo = result.getString("TradeNo");	
	}
	
	// 判断JSONObject是否回傳支付方式
	if(result.has("PaymentType")) {
		PaymentType = result.getString("PaymentType");

	}	
	
	// 判断JSONObject是否回傳支付完成時間
	if(result.has("PayTime")) {
		PayTime = result.getString("PayTime");	
	}
	
	// 判断JSONObject是否回傳卡號末四碼
	if(result.has("Card4No")) {  			
		Card4No = result.getString("Card4No");	
	}	
	
	// 判断JSONObject是否回傳回應碼
	if(result.has("RespondCode")) {  		
		RespondCode = result.getString("RespondCode");	
	}	
	
	// 付款方式設定
	String payment = "";
	if(PaymentType.equals("CREDIT")){
		payment="newebpay.credit";	// 信用卡
	}

	// 交易回應碼確認 確保繳費成功
	boolean check_response = false;
	if(RespondCode.equals("00")){
		check_response	= true ; // 刷卡成功
	}
	
	// 訂單資料確認 確保訂單未遭竄改
	boolean check_order = false;
	TableRecord dh 		= app_sm.select(tbldh,"dh_no=?",new Object[]{MerchantOrderNo}); 	// 取出訂單資料  
	if(dh.getInt("dh_total") == Amt){ 														// 交易金額正確
		check_order	 = true; 																// 訂單正確
	}

	// 交易結果處理(訂單未遭竄改)
	if(check_order) {
		// 交易成功
		if(check_response) {
			/*-- 頁面導向 --*/
			out.println("<script> location='../../donate/donate_sendmail.jsp?dh_id="+dh.getString("dh_id")+"'; </script>");
		// 交易失敗
		} else {
			out.println("<script> alert('交易失敗，錯誤碼為:"+RespondCode+"'); location='../../../home.jsp';</script>");
		}
	} else {
		out.println("<script> alert('驗證錯誤，訂單可能遭到竄改，請與客服連絡');location='../../../home.jsp';</script>"); 
	}
	return;
%>