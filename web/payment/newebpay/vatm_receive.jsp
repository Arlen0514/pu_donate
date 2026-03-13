<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<%@ page import="java.util.List" %>
<%@include file="config.jsp"%>
<% 
	String page_code = "newebpay_vatm";						// 功能識別碼

	// 信用卡交易返回值
  	String Status 			= StringTool.validString(request.getParameter("Status"));		// 授權結果狀態
	String HashKey 	  		= SiteSetup.getText("newebpay.HashKey"); 						// Hashkey	
	String HashIV 	  		= SiteSetup.getText("newebpay.HashIV"); 						// HashIV
	String TradeInfo 		= StringTool.validString(request.getParameter("TradeInfo"));	// 交易資料AES加密
	String TradeSha 		= StringTool.validString(request.getParameter("TradeSha"));		// 交易資料SHA256 加密
	
	// AES解密回傳資訊
	TradeInfo 				= decryptAES(HashKey,HashIV,TradeInfo);	
	
	JSONObject jsonObj 		= new JSONObject(TradeInfo);
	String status			= jsonObj.getString("Status");
	String Message			= jsonObj.getString("Message");
	
	// 回傳資訊
	JSONObject response_json = new JSONObject();
	
	response_json.put("Status", Status);
	response_json.put("TradeInfo", TradeInfo);
	response_json.put("TradeSha", TradeSha);
	
	// 回傳結果參數
	JSONObject result 		=jsonObj.getJSONObject("Result"); 	
	String MerchantOrderNo 	= result.getString("MerchantOrderNo");	// 商店訂單編號
	String TradeNo 			= "";									// 藍新金流交易序號
	int Amt					= result.getInt("Amt");					// 交易金額
	String PaymentType 		= "";									// 支付方式
	String PayTime 			= "";									// 支付完成時間
	String Card4No 			= "";									// X信用卡卡號末四碼
	String RespondCode 		= "";									// X信用卡回應碼
	String BankCode 		= "";									// 金融機構代碼
	String CodeNo 			= "";									// 繳費代碼
	String ExpireDate 		= "";									// 繳費截止日期

	//判断JSONObject是否回傳交易序號
	if(result.has("TradeNo")) {  			       
		TradeNo =result.getString("TradeNo");	
	}
	
	// 判断JSONObject是否回傳支付方式
	if(result.has("PaymentType")) {  		
		PaymentType =result.getString("PaymentType");	
	}	
	
	// 判断JSONObject是否回傳支付完成時間
	if(result.has("PayTime")) {  			
		PayTime =result.getString("PayTime");	
	}
	
	// 判断JSONObject是否回傳卡號末四碼
	if(result.has("Card4No")) {  			
		Card4No =result.getString("Card4No");	
	}
	
	// 判断JSONObject是否回傳回應碼
	if(result.has("RespondCode")) {  		
		RespondCode =result.getString("RespondCode");	
	}
	
	// 判断JSONObject是否回BankCode
	if(result.has("BankCode")) {  		
		BankCode =result.getString("BankCode");	
	}
	
	// 判断JSONObject是否回CodeNo
	if(result.has("CodeNo")) {  		
		CodeNo =result.getString("CodeNo");	
	}
	
	// 判断JSONObject是否回ExpireDate
	if(result.has("ExpireDate")) {  		
		ExpireDate =result.getString("ExpireDate");	
	}
	
	// 付款方式設定
	String payment = "";
	if(PaymentType.equals("CREDIT")){
		payment="newebpay.credit";	// 信用卡
	}
	
	if(PaymentType.equals("BARCODE")){
		payment="newebpay.barcode";	// 超商代碼
	}
	
	if(PaymentType.equals("VACC")){
		payment="newebpay.webatm";	// ATM 轉帳
	}

	// 交易回應碼確認 確保繳費成功
	boolean check_response	= false;
	if(RespondCode.equals("00")){
		check_response	= true ; 	// 刷卡成功
	}
	if(status.equals("SUCCESS")){
		check_response	= true ;	// 取號成功				 
	}

	
	// 訂單資料確認 確保訂單未遭竄改
	boolean check_order		= false;
	TableRecord dh = app_sm.select(tbldh,"dh_no=?",new Object[]{MerchantOrderNo}); 	// 取出訂單資料  
	if(dh.getInt("dh_total")==Amt){ 												// 交易金額正確
		check_order	 = true;	// 訂單正確
	}

	// 回傳訊息
	String ph_memo = "";
	ph_memo = "回應碼:" + status  + "； 回應訊息:" + Message + "; 回傳記錄：" + jsonObj + "; BankCode：" + BankCode + "; CodeNo：" + CodeNo + "; ExpireDate：" + ExpireDate;

	// 交易結果處理(訂單未遭竄改)
	if(check_order) {
		// 取號成功
		if(check_response) {
			dh.setValue("dh_status","Y"); 				// 正常
			dh.setValue("dh_collect","N"); 				// 未收款
			dh.setUpdate("newebpay_vatm");
			app_sm.update(dh);
			
			// 付款記錄更新
			TableRecord ph = app_sm.select(tblph, "data_id=? and ph_status=?", new Object[]{dh.getString("dh_id"), "N"});
			
			if(!"".equals(ph.getString("ph_id"))){
				ph.setValue("ph_bank_no", BankCode);
				ph.setValue("ph_account", CodeNo);
				ph.setValue("ph_limitdate", ExpireDate);
				ph.setValue("ph_return_no",status);
 		        ph.setValue("ph_return_msg",Message);
 		      	ph.setValue("ph_note", response_json.toString());
				ph.setValue("ph_memo", ph_memo);
				ph.setUpdate("newebpay_vatm");
				app_sm.update(ph);
				
				// 沖銷記錄更新
				TableRecord wh = app_sm.select(tblwh, "data_id=? and wh_status=?", new Object[]{dh.getString("dh_id"), "N"});
				
				if(!"".equals(wh.getString("wh_id"))) {
					wh.setValue("wh_account", TradeNo);
					wh.setUpdate("vatm_receive");
					app_sm.update(wh);
				}
			}
			
			/*-- 頁面導向 --*/
			out.println("<script> location='../../donate/donate_sendmail.jsp?dh_id="+dh.getString("dh_id")+"'; </script>");
			return;

		// 取號失敗
		} else {
			dh.setValue("dh_status","N"); 				// 作廢
			dh.setValue("dh_collect","N"); 				// 未收款
			dh.setUpdate("newebpay_vatm");
			app_sm.update(dh);

			// 付款記錄更新
			TableRecord ph = app_sm.select(tblph, "data_id=? and ph_status=?", new Object[]{dh.getString("dh_id"), "N"});
			
			if(!"".equals(ph.getString("ph_id"))){
				ph.setValue("ph_bank_no", BankCode);
				ph.setValue("ph_account", CodeNo);
				ph.setValue("ph_limitdate", ExpireDate);
				ph.setValue("ph_return_no",status);
 		        ph.setValue("ph_return_msg",Message);
 		      	ph.setValue("ph_note", response_json.toString());
				ph.setValue("ph_memo", ph_memo);
				ph.setUpdate("newebpay_vatm");
				app_sm.update(ph);
			}
			
			/*-- 頁面導向 --*/
			out.println("<script> alert('虛擬帳號取號失敗'); location='../../../home.jsp';</script>");
		}
	} else {
		out.println("<script> alert('驗證錯誤，可能遭到竄改，請與客服連絡');location='../../../home.jsp';</script>");
	}
	return;
%>