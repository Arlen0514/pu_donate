<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="config.jsp"%>
<%


String dh_id = StringTool.validString(request.getParameter("dh_id"));
TableRecord dh = app_sm.select(tbldh, dh_id);


/*---------------4.	加入繳費申請單--------------------------------------------*/
String page_code = "pu_api";
String api_name = "Puez_pay_external/get_order_token_url";		//API網址

String apiUrl = api_url + api_name;	//完整API網址
String apiMethod = "POST";			//GET or POST
boolean isPost = "POST".equals(apiMethod);

try {
String Authorization = getToken(secret, is_test, printLog);
// if(printLog) System.out.println("Authorization :"+Authorization);

/*---------------送出資料-----------------------------------------------------------*/
//info
String order_id = dh.getString("dh_no");	//銷帳編號 格式(數字 20 碼，唯一碼) 開頭:1044001 後續:用時間戳記補滿
String system_code = "pugive";				//繳費項目代碼表(pugive)
String payment_item = "捐贈靜宜";				//繳費項目名稱(捐贈靜宜)


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
} // 設定方法與 Header 
conn.setRequestMethod(apiMethod); 
if(isPost) conn.setDoOutput(true); 
conn.setConnectTimeout(15000); 
conn.setReadTimeout(15000); 
String boundary = "----WebKitFormBoundary" + System.currentTimeMillis();
conn.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
conn.setRequestProperty("Accept", "application/json;charset=UTF-8");
conn.setRequestProperty("Authorization", Authorization); 
// ---------------- 組合 JSON ---------------- 
JSONObject dataObj = new JSONObject(); 
JSONObject infoObj = new JSONObject(); 
infoObj.put("order_id", order_id); // 可改成動態生成 
infoObj.put("system_code", system_code); 
JSONArray infoArray = new JSONArray(); 
infoArray.put(infoObj); JSONObject data = new JSONObject(); 
data.put("info", infoArray); 
dataObj.put("data", data);

// ---------------- 寫入 Request Body ---------------- 
if(isPost){
	try (OutputStream os = conn.getOutputStream();
	         PrintWriter writer = new PrintWriter(new OutputStreamWriter(os, "UTF-8"), true)) {

	        // 開始 form-data
	        writer.append("--").append(boundary).append("\r\n");
	        writer.append("Content-Disposition: form-data; name=\"request\"\r\n");
	        writer.append("Content-Type: application/json; charset=UTF-8\r\n\r\n");
	        writer.append(dataObj.toString()).append("\r\n");
	        
	        System.out.println("/*-------------傳值start---------------------*/");
	        System.out.println(dataObj.toString());
	        
	        System.out.println("/*-------------傳值end---------------------*/");

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
		
		
		/*-------------------導向付款頁面------------------------------------------------*/
		
		String pay_url = respJson.optString("urlToken");
		out.println("<script>location='"+pay_url+"';</script>");
		return;
		
		
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
		e.printStackTrace();
		System.out.println("回應不是 JSON：" + responseStr); 
	}


} catch(Exception e) {
    e.printStackTrace();
}







%>