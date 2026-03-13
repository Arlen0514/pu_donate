<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<%@ page import="java.util.List" %>
<%@include file="config.jsp"%>
<%
	// 藍新信用卡-送出處理程式
	String page_code 		= "newebpay_credit";
	String company 			= SiteSetup.getSetup("cp.company" + "." + lang).getString("ss_text");
	
	// 訂單相關資料
	String dh_id 			= StringTool.validString(request.getParameter("dh_id"));
	TableRecord dh			= app_sm.select(tbldh,dh_id);
	if (dh == null) {
		out.println("<script> alert('訂單不存在!!'); location='../../../home.jsp'; </script>");
		return;
	}
	
	int dh_total			 = dh.getInt("dh_total");

	// Server name.
	String servername = request.getScheme() + "://"	+ request.getServerName() + ":" + request.getServerPort();
	if(request.getServerPort() == 80 || request.getServerPort() == 443) {
		servername = request.getScheme() + "://" + request.getServerName();
	}
	String localname = request.getScheme() + "://"	+ request.getLocalName() + ":" + request.getLocalPort();
	String url = servername + request.getContextPath();
	
	String MerchantID 			= SiteSetup.getText("newebpay.MerchantID"); 						// MerchantID	
	String HashKey 	  			= SiteSetup.getText("newebpay.HashKey"); 							// Hashkey	             
	String HashIV 	  			= SiteSetup.getText("newebpay.HashIV"); 							// HashIV
	String Version    			= "2.0";															// 串接程式版本:1.5
	String RespondType 			= "JSON";															// 回傳格式JSON 或是 String。
	String TimeStamp   			= String.valueOf(Calendar.getInstance().getTimeInMillis()/1000);	// 時間戳記
	String MerchantOrderNo 		= dh.getString("dh_no");											// 商店訂單編號
	int Amt 					= dh_total;															// 訂單金額
	String ItemDesc 			= company + " 線上捐款";												// 商品資訊
	String Email 				= dh.getString("dh_email");											// 付款人電子信箱
	int LoginType 				= 0;																// 1= 須要登入藍新金流會員，0 = 不須登入藍新金流會員
	String ReturnURL 			= url + "/web/payment/newebpay/credit_receive.jsp"; 				// 支付完成返回商店網址
	String NotifyURL 			= url + "/web/payment/newebpay/credit_result.jsp"; 					// 付款結果網址
	int CREDIT = 1;
	
	// 押碼字串(不傳送) NotifyURL 不接受 443 80 以外的 PORT 本機要關掉
	String temp_str = "MerchantID="+MerchantID+"&RespondType="+RespondType+"&TimeStamp="+TimeStamp+
					  "&Version="+Version+"&MerchantOrderNo="+MerchantOrderNo+"&Amt="+Amt+"&ItemDesc="+ItemDesc+
					  "&Email="+Email+"&LoginType="+LoginType+"&ReturnURL="+ReturnURL+"&CREDIT="+CREDIT+"&NotifyURL="+NotifyURL;
	
	if(is_local){
		temp_str = "MerchantID="+MerchantID+"&RespondType="+RespondType+"&TimeStamp="+TimeStamp+
				   "&Version="+Version+"&MerchantOrderNo="+MerchantOrderNo+"&Amt="+Amt+"&ItemDesc="+ItemDesc+
				   "&Email="+Email+"&LoginType="+LoginType+"&ReturnURL="+ReturnURL+"&CREDIT="+CREDIT;
	}

	String TradeInfo = getAES(HashKey, HashIV, temp_str);								// 交易資料AES加密
	String TradeSha  = getHashSha256(HashKey, HashIV, TradeInfo);						// 交易資料SHA256 加密

	String[] names 	 = { "MerchantID", "TradeInfo", "TradeSha", "Version" };
	String[] values  = { MerchantID, TradeInfo, TradeSha, Version };
	
	JSONObject post_json = new JSONObject();
	
	for(int i=0;i<names.length;i++) post_json.put(names[i], values[i]);
	post_json.put("temp_str", temp_str);									// 押碼字串
	
	// 新增付款紀錄
	TableRecord ph = new TableRecord (tblph);
	ph.setValue("data_id", dh.getString("dh_id"));
	ph.setValue("ph_post", post_json.toString());						// 儲存送出參數
	ph.setValue("ph_payment", dh.getString("dh_paymethod"));
	ph.setValue("ph_amount", Amt);
	ph.setValue("ph_status","N");
	ph.setValue("ph_code", "payment");
	ph.setInsert("credit_post");
	app_sm.insert(ph);
	
	// 建立沖銷紀錄(一筆訂單只會對應一筆沖銷紀錄)
	TableRecord wh = new TableRecord(tblwh);
	wh.setValue("wh_status", "N");				// 未沖銷
	wh.setValue("wh_total", Amt);
	wh.setValue("data_id", dh.getString("dh_id"));
	wh.setValue("wh_payment", dh.getString("dh_paymethod"));
	wh.setValue("wh_code", "credit_card");
	wh.setInsert("credit_post");
	app_sm.insert(wh);
	
	if("test".equals(api_status)) {
	   	out.println(HtmlCoder.form("credit", "https://ccore.newebpay.com/MPG/mpg_gateway", names,values ));   	// 測試位置
	} else if("online".equals(api_status)) {
		out.println(HtmlCoder.form("credit", "https://core.newebpay.com/MPG/mpg_gateway", names,values ));  	// 正式位置	
	}

   	out.println("<script>credit.submit(); </script>");
%>