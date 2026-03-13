<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<%@ page import="org.json.*"%>
<%@ page import="java.net.*" %>
<%@ page import="javax.net.ssl.*" %>
<%@ page import="java.util.List" %>
<%@include file="/web/payment/newebpay/config.jsp" %>
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
	
	// 訂單相關資料
	TableRecord dh = app_sm.select(tbldh, dh_id);
	int dh_total = dh.getInt("dh_total");
	
	if ("".equals(dh.getString("dh_id")) || dh == null) {
		out.println("<script> alert('訂單資料有誤!!'); </script>");
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
	
	out.println("postIP :"+request.getRemoteAddr()+"<br/>");
	out.println("postUrl :"+post_url+"<br/>");
	out.println("postData :<br/>");
	for(int i=0;i<post_fields.length;i++) {
		post_json.put(post_fields[i], post_values[i]);			// 存資料庫用
		post_data.add(post_fields[i]+"="+post_values[i]);
		out.println(post_fields[i]+"="+post_values[i]+"<br/>");
	}
	out.println("<br/>");
	
	// out.println(String.join("&", post_data)+"<br/><br/>");
	
	//-----------------------------------------傳送查詢參數並獲取查詢結果資料(json)------------------------------------------------------------
	
	HttpsURLConnection connection = null;	
	JSONObject response_json = new JSONObject();
	
	try {
		URL apiurl = new URL(post_url);
		connection = (HttpsURLConnection) apiurl.openConnection();
		
		// 建立設定TLSv1.2 (Java 7)
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
	 	String responseMessage = connection.getResponseMessage();
	 	int responseCode = connection.getResponseCode();
	 	
	 	out.println("responseCode :"+responseCode+"<br/>");
	 	out.println("responseMessage :"+responseMessage+"<br/>");
	 	
	 	// 取得所有回應 headers
 	 	Map<String, List<String>> headers = connection.getHeaderFields();
 	 	
	 	out.println("responseHeaders :<br/>");
	 	for (Map.Entry<String, List<String>> entry : headers.entrySet()) {
 	 	    out.println(entry.getKey() + ": " + entry.getValue()+"<br/>");
 	 	}
	 	
// 	 	if(responseCode == 200){ 
	  	  	BufferedReader bufferedReader = new BufferedReader( new InputStreamReader(connection.getInputStream(),"UTF-8"));
	  		String inputLine;
	  		
	  		while ((inputLine = bufferedReader.readLine()) != null) {
	  			reserveResponse.append(inputLine);
	  		}
	  		bufferedReader.close();
// 	  	}
	 	
	 	// 將回傳的json格式資料轉為json物件 
  		out.println("reserveResponse :"+reserveResponse.toString()+"<br/><br/>");
  		response_json = new JSONObject(reserveResponse.toString());
	  		
	} catch(Exception ex){
		out.println("很抱歉，您的付款查詢失敗");
	}finally {
	    // 中斷連線
	    if(connection != null ) {
	    	connection.disconnect();
	    }
	    app_sm.close();
	}
	
	// 回列表頁
// 	out.println(HtmlCoder.form("trade_search", post_url, post_fields, post_values));
// 	out.println("<script> trade_search.submit(); </script>");
	return;
%>