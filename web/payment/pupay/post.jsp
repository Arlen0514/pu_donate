<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="config.jsp"%>
<%



String dh_id = StringTool.validString(request.getParameter("dh_id"));
TableRecord dh = app_sm.select(tbldh, dh_id);

/*----------身分證---------------------------*/
AESDataEncryption ade = new AESDataEncryption();

String dh_pid = ade.AESDecrypt(dh.getString("dh_pid")); 

/*------------------------繳費時間--------------------*/

int pay_deadtime = 3;

DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");

LocalDateTime now = LocalDateTime.now();
String nowStr = now.format(fmt);

System.out.println("現在時間：" + nowStr);

LocalDateTime after3Days = now.plusDays(pay_deadtime);
String after3DaysStr = after3Days.format(fmt);


/*---------------1.	加入繳費申請單--------------------------------------------*/
String page_code = "pu_api";
String api_name = "Puez_pay_external/pugive_apply";		//API網址

String apiUrl = api_url + api_name;	//完整API網址
String apiMethod = "POST";			//GET or POST
boolean isPost = "POST".equals(apiMethod);

try {
String Authorization = getToken(secret, is_test, printLog);
// if(printLog) System.out.println("Authorization :"+Authorization);

/*---------------送出資料-----------------------------------------------------------*/
//info
String order_id = dh.getString("dh_no");						//銷帳編號 格式(數字 20 碼，唯一碼) 開頭:1044001 後續:用時間戳記補滿
int amount = dh.getInt("dh_total");								//金額
String system_code = "pugive";				//繳費項目代碼表(pugive)
String acctno = dh_pid;							//身份證字號
String payment_item = "捐贈靜宜";				//繳費項目名稱(捐贈靜宜)
String start_payment_date = nowStr;				//繳費開始時間
String end_payment_date = after3DaysStr;				//繳費結束時間
String payment_method = "行動支付";					//繳費方式(行動支付、電子錢包、現金)
//info2
// String order_id = "";						//銷帳編號 格式(數字 20 碼，唯一碼) 開頭:1044001 後續:用時間戳記補滿
// String acctno = "";							//收據繳款人代號(身份字號或統編)
String name = dh.getString("dh_name");							//收據繳款人名稱(姓名或公司抬頭)
int seq = 1;
String paym_item = "捐贈靜宜";				//繳費項目名稱(捐贈靜宜)
// int amount = 0;								//金額
String ckdate = nowStr;							//建立時間



/*-----------------設定請求-----------------------------------------------------*/

URL url = new URL(apiUrl);
HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
if (is_test) {
	TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
		public X509Certificate[] getAcceptedIssuers() {
	return new X509Certificate[0];
		}

		public void checkClientTrusted(X509Certificate[] certs, String authType) {
		}

		public void checkServerTrusted(X509Certificate[] certs, String authType) {
		}
	} };
	SSLContext sc = SSLContext.getInstance("TLSv1.2");
	sc.init(null, trustAllCerts, new java.security.SecureRandom());
	conn.setSSLSocketFactory(sc.getSocketFactory());
	conn.setHostnameVerifier((hostname, sslSession) -> true);
} 
// 設定方法與 Header 
conn.setRequestMethod(apiMethod); 
if(isPost) conn.setDoOutput(true); 
conn.setConnectTimeout(15000); 
conn.setReadTimeout(15000); 
String boundary = "----WebKitFormBoundary" + System.currentTimeMillis();
conn.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
conn.setRequestProperty("Accept", "application/json;charset=UTF-8");
conn.setRequestProperty("Authorization", Authorization);

// ---------------- 組合 JSON ----------------
JSONObject infoObj = new JSONObject();
infoObj.put("order_id", order_id);
infoObj.put("amount", amount);
infoObj.put("system_code", system_code);
infoObj.put("acctno", acctno);
infoObj.put("payment_item", payment_item);
infoObj.put("start_payment_date", start_payment_date);
infoObj.put("end_payment_date", end_payment_date);
infoObj.put("payment_method", payment_method);

JSONObject info2Obj = new JSONObject();
info2Obj.put("order_id", order_id);
info2Obj.put("acctno", acctno);
info2Obj.put("name", name);
info2Obj.put("seq", seq);
info2Obj.put("pay_item", paym_item);
info2Obj.put("ckdate", ckdate);
info2Obj.put("amount", amount);

JSONObject dataObj = new JSONObject();
dataObj.put("info", new JSONArray().put(infoObj));
dataObj.put("info2", new JSONArray().put(info2Obj));

JSONObject rootObj = new JSONObject();
rootObj.put("data", dataObj);

String jsonStr = rootObj.toString();

System.out.println("送出 JSON：" + jsonStr);

// ---------------- 寫入 Request Body (form-data) ----------------
if (isPost) {
    try (OutputStream os = conn.getOutputStream();
         PrintWriter writer = new PrintWriter(new OutputStreamWriter(os, "UTF-8"), true)) {

        // 開始 form-data
        writer.append("--").append(boundary).append("\r\n");
        writer.append("Content-Disposition: form-data; name=\"request\"\r\n");
        writer.append("Content-Type: application/json; charset=UTF-8\r\n\r\n");
        writer.append(jsonStr).append("\r\n");

        // 結束 boundary
        writer.append("--").append(boundary).append("--").append("\r\n");
        writer.flush();
    }
}


// ---------------- 讀取回應 ---------------- 
int responseCode = conn.getResponseCode();
BufferedReader br = (responseCode == 200) 
			? new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"))
			: new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8")); 
StringBuilder sb = new StringBuilder(); 

String line; 
while ((line = br.readLine()) != null) { 
	sb.append(line); }

br.close(); 

String responseStr = sb.toString(); 
System.out.println("API response：" + responseStr); 

// ---------------- 解析回應 JSON ---------------- 
try { 
		JSONObject respJson = new JSONObject(responseStr); 
		System.out.println("解析後 JSON：" + respJson.toString(2)); 
		
		/*-------------成功取得JSON-------------------------------------*/
		int success = respJson.getInt("success"); 
		String message = respJson.optString("message");
		
		if (success == 1) { // 成功流程 
			
			System.out.println("成功！開始後續流程..."); 
		
			// 建立沖銷紀錄(一筆訂單只會對應一筆沖銷紀錄)
			TableRecord wh = new TableRecord(tblwh);
			wh.setValue("wh_status", "N");				// 未沖銷
			wh.setValue("wh_total", amount);
			wh.setValue("data_id", dh.getString("dh_id"));
			wh.setValue("wh_payment", dh.getString("dh_paymethod"));
			wh.setValue("wh_code", "pu");
			wh.setInsert("credit_post");
			app_sm.insert(wh);
		
		
// 			out.println("<script>location='../../donate/donate_sendmail.jsp?dh_id="+dh_id+"';</script>");
			out.println("<script>location='get_url.jsp?dh_id="+dh_id+"';</script>");
		
		} else if (success == -1) { // 失敗流程 
				
			System.out.println("失敗！原因：" + message); // 例如：重新取得 token 或提示使用者 
				
			if ("token error".equalsIgnoreCase(message)) {
				System.out.println("Token 錯誤，請重新呼叫 get_token API 取得新 token"); 
			} else { 
				System.out.println("其他錯誤，請檢查參數或 API 狀態"); 
			} 
		} else { // 其他情況 (防呆)
				 
			System.out.println("未知回傳，success=" + success + "，訊息：" + message); 
		}
		
	} catch(Exception e){ 
		System.out.println("回應不是 JSON：" + responseStr); 
	}


} catch(Exception e) {
    e.printStackTrace();
}







%>