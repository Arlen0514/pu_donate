<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<%@ page import="org.json.*"%>
<%@ page import="java.net.*" %>
<%@ page import="javax.net.ssl.*" %>
<%@ page import="java.util.List" %>
<%@include file="/web/payment/newebpay/config.jsp" %>
<%@include file="/WEB-INF/jspf/mis/check.jspf" %>
<%
	// 藍新付款查詢
	String code    = "donate";
	String company = SiteSetup.getSetup("cp.company" + "." + lang).getString("ss_text");

	/*-- 跳頁參數 --*/
	// Conditions.
	String qname = StringTool.validString(request.getParameter("_qname"));
	String qphone = StringTool.validString(request.getParameter("_qphone"));
	String qdhno = StringTool.validString(request.getParameter("_qdhno"));
	String qpayment = StringTool.validString(request.getParameter("_qpayment"),"");	
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"));
	String qposition = StringTool.validString(request.getParameter("_qposition"), "Y");
	String qcollect	 = StringTool.validString(request.getParameter("_qcollect"));
	
	String dh_id   = StringTool.validString(request.getParameter("dh_id"));
	
	// Names and values.
	String[] names = new String[] { 
		"npage", "_qname", "_qphone", "_qdhno", "_qpayment", "_qemitdate", "_qrestdate", "_qposition", "_qcollect"
	};
	String[] values = new String[] { 
		String.valueOf(pageno), qname, qphone, qdhno, qpayment, qemitdate, qrestdate, qposition, qcollect
	};
	
	// 回列表頁
	out.println(HtmlCoder.form("backdata", "../../"+code+".jsp", names, values));
	
	// 訂單相關資料
	TableRecord dh = app_sm.select(tbldh, dh_id);
	int dh_total = dh.getInt("dh_total");
	
	if ("".equals(dh.getString("dh_id")) || dh == null) {
		out.println("<script> alert('訂單資料有誤!!'); backdata.submit(); </script>");
		return;
	}
	
	// 付款紀錄
	TableRecord ph = app_sm.select(tblph, "data_id=? and ph_code=?", new Object[]{dh.getString("dh_id"), "payment"});
	
	/*-- 傳遞參數設定 --*/
	String MerchantID 			= SiteSetup.getText("newebpay.MerchantID"); 						// MerchantID	
	String HashKey 	  			= SiteSetup.getText("newebpay.HashKey"); 							// Hashkey	             
	String HashIV 	  			= SiteSetup.getText("newebpay.HashIV"); 							// HashIV
	String Version    			= "1.3";															// 串接程式版本:1.3
	String RespondType 			= "JSON";															// 回傳格式JSON 或是 String。
	String TimeStamp   			= String.valueOf(Calendar.getInstance().getTimeInMillis()/1000);	// 時間戳記
	String MerchantOrderNo 		= dh.getString("dh_no");											// 商店訂單編號
	int Amt 					= dh_total;															// 訂單金額
	String Gateway 			    = "";																// 資料來源(預設空值)
	
	// 檢查碼
	Vector<String> checkValArr = new Vector<String>();
	String PlainText = "", CheckValue = "";
	
	checkValArr.add("IV="+HashIV);
	checkValArr.add("Amt="+Amt);
	checkValArr.add("MerchantID="+MerchantID);
	checkValArr.add("MerchantOrderNo="+MerchantOrderNo);
	checkValArr.add("Key="+HashKey);
	
	PlainText  = String.join("&",checkValArr);
	CheckValue = createCheckValue(PlainText);
	
// 	System.out.println("PlainText="+PlainText);
// 	System.out.println("CheckValue="+CheckValue);
	
	String post_url_real = "https://core.newebpay.com/API/QueryTradeInfo";
	String post_url_test = "https://ccore.newebpay.com/API/QueryTradeInfo";
	String post_url      = "test".equals(api_status) ? post_url_test : post_url_real;
	
	String[] post_fields = { 
			"MerchantID", "Version", "RespondType", "TimeStamp", "MerchantOrderNo", "Amt", "Gateway", "CheckValue"
	};
	String[] post_values = {
			MerchantID, Version, RespondType, TimeStamp, MerchantOrderNo, String.valueOf(Amt), Gateway, CheckValue
	};
	Vector<String> post_data = new Vector<String>();
	JSONObject post_json = new JSONObject();
	
	for(int i=0;i<post_fields.length;i++) {
		post_json.put(post_fields[i], post_values[i]);			// 存資料庫用
		post_data.add(post_fields[i]+"="+post_values[i]);
	}
	
	ph.setValue("ph_post", post_json.toString());						// 儲存送出參數
	ph.setValue("ph_code", "search");
	ph.setInsert("trade_search");
	app_sm.insert(ph);
	
	//-----------------------------------------傳送查詢參數並獲取查詢結果資料(json)------------------------------------------------------------
	
	HttpsURLConnection connection = null;	
	JSONObject response_json = new JSONObject();
	
	try {
		URL apiurl = new URL(post_url);
		connection = (HttpsURLConnection) apiurl.openConnection();
		
		// 建立設定TLSv1.2 (Java 7)
		/*宣告使用1.2*/
	    TrustManager[] trustAllCerts = new TrustManager[] {
				new X509TrustManager() {
					public java.security.cert.X509Certificate[] getAcceptedIssuers() {
						return null;
					}
					public void checkClientTrusted(java.security.cert.X509Certificate[] certs, String authType) {
					}
					public void checkServerTrusted(java.security.cert.X509Certificate[] certs, String authType) {
					}
				}
		};
		HostnameVerifier hv = new HostnameVerifier(){
			public boolean verify(String urlHostName, SSLSession session){
				return true;
			}
		};
		HttpsURLConnection.setDefaultHostnameVerifier(hv);
		
		SSLContext sc = SSLContext.getInstance("TLSv1.2"); 
		// sc.init(null, null, new java.security.SecureRandom());
		sc.init(null, trustAllCerts, new java.security.SecureRandom());	
		//System.setProperty("https.protocols", "TLSv1.2");
		
		// 設定請求方法與傳送內容類型與指定的Request Header
		connection.setRequestMethod("POST");
		connection.setRequestProperty("User-Agent", "newebpay_00501503");				// 正式環境一要設定，不然會 403
		connection.setRequestProperty("Content-Type","application/x-www-form-urlencoded; charset=utf-8");
		connection.setSSLSocketFactory(sc.getSocketFactory());
		
		connection.setUseCaches(false);  		// post禁用緩存
	    connection.setDoInput(true); 			// 允許讀取結果
	    connection.setDoOutput(true); 			// 允許輸出 才可在寫入參數
	    connection.setConnectTimeout(5000); 	// 連接超時（毫秒）
	    connection.setReadTimeout(20000);  		// 讀取資料超時(毫秒）\
	    connection.connect();
	    
	 	// 傳送參數請求
	 	OutputStreamWriter writer = new OutputStreamWriter(connection.getOutputStream(),"UTF-8"); // 指定編碼 new OutputStreamWriter(connection.getOutputStream());
	 	writer.write(String.join("&", post_data));   
	 	writer.flush();
	 	writer.close();
	 	
	 	// 讀取回應資料
	  	StringBuffer reserveResponse = new StringBuffer();
	 	int responseCode = connection.getResponseCode();
	 	
	 	System.out.println("responseCode :"+responseCode);
	 	if(responseCode == 200){ 
	  	  	BufferedReader bufferedReader = new BufferedReader( new InputStreamReader(connection.getInputStream(),"UTF-8"));
	  		String inputLine;
	  		
	  		while ((inputLine = bufferedReader.readLine()) != null) {
	  			reserveResponse.append(inputLine);
	  		}
	  		bufferedReader.close();
	  	}
	 	
	 	// 將回傳的json格式資料轉為json物件 
  		System.out.println("reserveResponse="+reserveResponse.toString());
  		response_json = new JSONObject(reserveResponse.toString());
		
  		ph.setValue("ph_memo", response_json.toString());
	  	app_sm.update(ph);
	  		
	} catch(Exception ex){
		ph.setValue("ph_status", "N");
		ph.setValue("ph_memo", "付款查詢 API 執行錯誤(RECEIVE) - 例外原因:"+ex.getMessage());
		app_sm.update(ph);
		
		System.out.println(projectName+"[" + code + "]-付款查詢 API 執行錯誤(Post)；例外原因:"+ex+"；處理時間:"+DateTimeTool.dateTimeString());//System.out.println("Error info:[" + ex + "]File name edit.jsp for [" + page_code + "]Time:[" + DateTimeTool.dateTimeString() + "]");
		out.println("<script> alert('很抱歉，您的付款查詢失敗'); backdata.submit(); </script>");
		return;
	}finally {
	    // 中斷連線
	    if(connection != null ) {
	    	connection.disconnect();
	    }
	    app_sm.close();
	}
	
	//-----------------------------------------解析回傳資訊與沖銷(json)------------------------------------------------------------
	
	String Status  	  = "";	
	String Message    = "";	
	JSONObject Result = new JSONObject();	
	
	// 共通
	String TradeNo 			= "";									// 藍新金流交易序號
	String TradeStatus 		= "";									// 支付狀態(0=未付款,1=付款成功,2=付款失敗,3=取消付款,6=退款)
	String PaymentType 		= "";									// 支付方式(CREDIT=信用卡付款,VACC=銀行ATM轉帳付款,WEBATM=網路銀行轉帳付款,BARCODE=超商條碼繳費,CVS=超商代碼繳費,LINEPAY=LINE Pay付款,ESUNWALLET=玉山Wallet,TAIWANPAY=台灣Pay,CVSCOM = 超商取貨付款,FULA=Fula付啦)
	String PayTime 			= "";									// 支付完成時間
	String CheckCode		= "";									// 檢核碼
	int CheckAmt			= 0;									// 訂單金額
	
	// 信用卡
	String RespondCode 		= "";									// 回應碼
	String Card4No 			= "";									// 卡號末四碼
	
	// 超商付款/ATM
	String PayInfo 			= "";									// 超商繳款代碼(超商代碼)/繳款條碼(超商條碼，用半形逗號組合)/金融機構轉帳帳號(ATM轉帳)
	String ExpireDate 		= "";									// 繳費截止日期
	String OrderStatus 		= "";									// 交易狀態(0＝未付款,1＝已付款,2＝訂單失敗,3＝訂單取消,6＝已退款,9＝付款中，待銀行確認)

	try {
		Status  = response_json.getString("Status");	
		Message = response_json.getString("Message");	
		Result  = response_json.getJSONObject("Result");	
			
		TradeNo 	= Result.getString("TradeNo");
		TradeStatus = Result.getString("TradeStatus");
		PaymentType = Result.getString("PaymentType");
		PayTime 	= Result.getString("PayTime");
		CheckCode 	= Result.getString("CheckCode");
		CheckAmt    = Result.getInt("Amt");
		
		if("CREDIT".equals(PaymentType)) {
			Card4No     = Result.getString("Card4No");
			RespondCode = Result.getString("RespondCode");
		}
		
		if("VACC".equals(PaymentType) || "WEBATM".equals(PaymentType) 
			|| "CVS".equals(PaymentType) || "BARCODE".equals(PaymentType)) {
			PayInfo 	= Result.getString("PayInfo");
			ExpireDate 	= Result.getString("ExpireDate");
			OrderStatus = Result.getString("OrderStatus");
		}
		
		ph.setValue("ph_status", "Y");
		app_sm.update(ph);
		
	} catch(Exception ex){
		ph.setValue("ph_status", "N");
		ph.setValue("ph_error", "付款查詢解析結果錯誤(RECEIVE) - 例外原因:"+ex.getMessage());
		app_sm.update(ph);
		
		System.out.println(projectName+"[" + code + "]-付款查詢 API 執行錯誤(RECEIVE)；例外原因:"+ex+"；處理時間:"+DateTimeTool.dateTimeString());//System.out.println("Error info:[" + ex + "]File name edit.jsp for [" + page_code + "]Time:[" + DateTimeTool.dateTimeString() + "]");
		out.println("<script> alert('很抱歉，您的付款查詢失敗'); backdata.submit(); </script>");
		return;
	}finally {
		app_sm.close();
	}
	
	/*-------------------------------------------查詢結果處理-----------------------------------------------------------*/

	boolean check_response  = "SUCCESS".equals(Status);				// 交易回應碼確認 確保查詢成功
	boolean check_order     = CheckAmt == Amt;						// 訂單資料確認 確保訂單未遭竄改
	
	// 回傳訊息
	String ph_memo = "";
	ph_memo = "回應碼：" + Status + "； 回應訊息：" + Message + ";回傳記錄：" + Result;
	
	if(check_order) {
		if(check_response) {
// 			dh.setValue("dh_status","Y"); 				// 正常
			dh.setValue("dh_collect","Y"); 				// 已收款
			dh.setUpdate("trade_search");
			app_sm.update(dh);
			
			if("CREDIT".equals(PaymentType)) {
				ph.setValue("ph_status", "Y"); 					// 已付款
				ph.setValue("ph_paydate","交易日期:"+PayTime);
				ph.setValue("ph_bank_no", Card4No);				// 交易卡號末四碼
				ph.setValue("ph_return_no", Status);
 		        ph.setValue("ph_return_msg", Message);
 		      	ph.setValue("ph_note", response_json.toString());
				ph.setValue("ph_memo", ph_memo);
				app_sm.update(ph);
			} else if("VACC".equals(PaymentType)) {
				ph.setValue("ph_status", "Y"); 					// 已付款
				ph.setValue("ph_amount", Amt);
				ph.setValue("ph_paydate","交易日期:"+PayTime);
				ph.setValue("ph_return_no", Status);
 		        ph.setValue("ph_return_msg", Message);
 		      	ph.setValue("ph_note", response_json.toString());
				ph.setValue("ph_memo", ph_memo);
				app_sm.update(ph);
			}
			
			// 沖銷記錄更新
			TableRecord wh = app_sm.select(tblwh, "data_id=? and wh_status=?", new Object[]{dh.getString("dh_id"), "N"});
			
			if(!"".equals(wh.getString("wh_id"))) {
				String wh_pay_date = PayTime.substring(0, 10);
				String wh_pay_time = PayTime.substring(11);
				
				wh.setValue("wh_status", "Y");
				wh.setValue("wh_account", TradeNo);
				wh.setValue("wh_pay_date", wh_pay_date);
				wh.setValue("wh_pay_time", wh_pay_time);
				wh.setUpdate("trade_search");
				app_sm.update(wh);
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
				dr.setInsert("trade_search");
				app_sm.insert(dr);
				
				dh.setValue("dr_id", dr.getString("dr_id"));
				dh.setValue("dr_no", dr.getString("dr_no"));	// dh寫入收據編號
				app_sm.update(dh);
			}
			
			out.println("<script> alert('該筆交易付款成功!!'); backdata.submit(); </script>");
			return;
		} else {
// 			dh.setValue("dh_status","N"); 				// 正常
			dh.setValue("dh_collect","N"); 				// 已收款
			dh.setUpdate("trade_search");
			app_sm.update(dh);
			
			if("CREDIT".equals(PaymentType)) {
				ph.setValue("ph_status", "N"); 					// 已付款
				ph.setValue("ph_paydate","交易日期:"+PayTime);
				ph.setValue("ph_bank_no", Card4No);				// 交易卡號末四碼
				ph.setValue("ph_return_no", Status);
 		        ph.setValue("ph_return_msg", Message);
 		      	ph.setValue("ph_note", response_json.toString());
				ph.setValue("ph_memo", ph_memo);
				app_sm.update(ph);
			} else if("VACC".equals(PaymentType)) {
				ph.setValue("ph_status", "N"); 					// 已付款
				ph.setValue("ph_amount", Amt);
				ph.setValue("ph_paydate","交易日期:"+PayTime);
				ph.setValue("ph_return_no", Status);
 		        ph.setValue("ph_return_msg", Message);
 		      	ph.setValue("ph_note", response_json.toString());
				ph.setValue("ph_memo", ph_memo);
				app_sm.update(ph);
			}
			
			out.println("<script> alert('該筆交易付款失敗，失敗原因："+Message+"'); backdata.submit(); </script>");
			return;
		}
	} else {
		out.println("<script> alert('該筆交易驗證錯誤，訂單可能遭到竄改，請與客服連絡'); backdata.submit(); </script>");
		return;
	}
%>