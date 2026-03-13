<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<%@ page import="java.util.List" %>
<%@include file="config.jsp"%>
<%@page import="org.json.JSONObject" %>
<%
	String page_code = "newebpay_credit";						// 功能識別碼
	
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
	JSONObject result 		= jsonObj.getJSONObject("Result"); 	
	String MerchantOrderNo 	= result.getString("MerchantOrderNo");		// 商店訂單編號
	String TradeNo 			= "";										// 藍新金流交易序號
	int Amt					= result.getInt("Amt");						// 交易金額
	String PaymentType 		= "";										// 支付方式
	String PayTime			= "";										// 支付完成時間
	String Card4No 			= "";										// 卡號末四碼
	String RespondCode 		= "";										// 回應碼

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
		payment = "newebpay.credit";	// 信用卡
	}

	// 交易回應碼確認 確保繳費成功    20191226Miles modify  更新成為抓 Status  = SUCCESS 
	boolean check_response	= false;
	if(status.equals("SUCCESS")) {
		check_response	= true ;	// 刷卡成功			 
	}
	/*
	if(RespondCode.equals("00")){
		check_response	= true ; 	// 刷卡成功
	}
	*/
	
	// 訂單資料確認 確保訂單未遭竄改
	boolean check_order		= false;
	TableRecord dh = app_sm.select(tbldh,"dh_no=?",new Object[]{MerchantOrderNo}); 	// 取出訂單資料  
	if(dh.getInt("dh_total") == Amt){ 												// 交易金額正確
		check_order	 = true; 														// 訂單正確
	}
	
	// 回傳訊息
	String ph_memo = "";
	ph_memo = "回應碼：" + status + "； 回應訊息：" + Message + ";回傳記錄：" + jsonObj;

	// 交易結果處理(訂單未遭竄改)
	if(check_order) {
		// 交易成功
		if(check_response) {
			dh.setValue("dh_status","Y"); 				// 正常
			dh.setValue("dh_collect","Y"); 				// 已收款
			dh.setUpdate("newebpay_credit");
			app_sm.update(dh);
			
			// 付款記錄更新
			TableRecord ph = app_sm.select(tblph, "data_id=? and ph_status=?", new Object[]{dh.getString("dh_id"), "N"});
			
			if(!"".equals(ph.getString("ph_id"))) {
				ph.setValue("ph_status", "Y"); 					// 已付款
				ph.setValue("ph_paydate","交易日期:"+PayTime);
				ph.setValue("ph_bank_no", Card4No);				// 交易卡號末四碼
				ph.setValue("ph_return_no",status);
 		        ph.setValue("ph_return_msg",Message);
 		      	ph.setValue("ph_note", response_json.toString());
				ph.setValue("ph_memo", ph_memo);
				ph.setUpdate("newebpay_credit");
				app_sm.update(ph);	
				
				// 沖銷記錄更新
				TableRecord wh = app_sm.select(tblwh, "data_id=? and wh_status=?", new Object[]{dh.getString("dh_id"), "N"});
				
				if(!"".equals(wh.getString("wh_id"))) {
					String wh_pay_date = PayTime.substring(0, 10);
					String wh_pay_time = PayTime.substring(11);
					
					wh.setValue("wh_status", "Y");
					wh.setValue("wh_account", TradeNo);
					wh.setValue("wh_pay_date", wh_pay_date);
					wh.setValue("wh_pay_time", wh_pay_time);
					wh.setUpdate("credit_result");
					app_sm.update(wh);
				}
			}
			
			// 芳名錄
			TableRecord dr = app_sm.select(tbldr, "dh_id=?", new Object[]{dh.getString("dh_id")});
			
			if("".equals(dr.getString("dr_id"))) {
				TableRecord donate_category = app_sm.select(tbldm, dh.getString("dh_donate_project_category"));
				boolean is_other   = "".equals(donate_category.getString("dm_id"));
				boolean is_public  = "Y".equals(dh.getString("dh_public"));
				boolean is_foreign = !"TWD".equals(dh.getString("dh_currency"));
				
				dr = new TableRecord(tbldr);
				dr.setValue("dh_id", dh.getString("dh_id"));
				dr.setValue("dh_no", dh.getString("dh_no"));
				dr.setValue("dr_no", IDTool.getUID("record", "DR"+DateTimeTool.dateString(""), 6));
				dr.setValue("dr_name", is_public?dh.getString("dh_name"):"熱心人士");
				dr.setValue("dr_identity", dh.getString("dh_identity"));
				dr.setValue("dr_donatedate", dh.getString("dh_donatedate"));
				dr.setValue("dr_donate_item_category", is_other?"其他":donate_category.getString("dm_title"));
				dr.setValue("dr_donate_item", dh.getString("dh_donate_project"));
				dr.setValue("dr_donate_item_title", dh.getString("dh_donate_project_title"));
				dr.setValue("dr_currency", dh.getString("dh_currency"));
				dr.setValue("dr_total", dh.getInt(is_foreign?"dh_foreign_total":"dh_total"));
				dr.setValue("dr_status", "Y");
				dr.setValue("dr_code", "directory");
				dr.setValue("dr_lang", lang);
				dr.setInsert("newebpay_credit");
				app_sm.insert(dr);
				
				dh.setValue("dr_id", dr.getString("dr_id"));
				dh.setValue("dr_no", dr.getString("dr_no"));	// dh寫入收據編號
				app_sm.update(dh);
			}

		// 交易失敗
		} else {
			dh.setValue("dh_status","N"); 				// 正常
			dh.setValue("dh_collect","N"); 				// 已收款
			dh.setUpdate("newebpay_credit");
			app_sm.update(dh);
			
			// 付款記錄更新
			TableRecord ph = app_sm.select(tblph, "data_id=? and ph_status=?", new Object[]{dh.getString("dh_id"), "N"});
			
			if(!"".equals(ph.getString("ph_id"))) {
				ph.setValue("ph_status", "N"); 					// 未付款
				ph.setValue("ph_paydate", "交易日期:"+PayTime);
				ph.setValue("ph_bank_no", Card4No);				// 交易卡號末四碼
				ph.setValue("ph_return_no",status);
 		        ph.setValue("ph_return_msg",Message);
 		      	ph.setValue("ph_note", response_json.toString());
				ph.setValue("ph_memo", ph_memo);
				ph.setUpdate("newebpay_credit");
				app_sm.update(ph);
			}
		}
	}
%>