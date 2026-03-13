<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="config.jsp"%>
<%

/*--------------列表頁---------------------------*/


	String qname = StringTool.validString(request.getParameter("_qname"));
	String qphone = StringTool.validString(request.getParameter("_qphone"));
	String qdhno = StringTool.validString(request.getParameter("_qdhno"));
	String qpayment = StringTool.validString(request.getParameter("_qpayment"),"");	
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"));
	String qposition = StringTool.validString(request.getParameter("_qposition"), "Y");
	String qcollect	 = StringTool.validString(request.getParameter("_qcollect"));

	String def_qrestdate = "2099/12/31" , def_qemitdate = DateTimeTool.dateString(DateTimeTool.getYear()-1,DateTimeTool.getMonth(),DateTimeTool.getDay());
	if("".equals(qemitdate)) {qemitdate = def_qemitdate;}
	if("".equals(qrestdate)) {qrestdate = def_qrestdate;}

	// Names and values.
	String[] names = new String[] { 
		"npage", "_qname", "_qphone", "_qdhno", "_qpayment", "_qemitdate", "_qrestdate", "_qposition", "_qcollect"
	};
	String[] values = new String[] { 
		String.valueOf(pageno), qname, qphone, qdhno, qpayment, qemitdate, qrestdate, qposition, qcollect
	};


%>
<%=	HtmlCoder.getForm("frm1", "../../../mis/donation/donate.jsp", names, values)%>
<%
String dh_id = StringTool.validString(request.getParameter("dh_id"));
TableRecord dh = app_sm.select(tbldh, dh_id);


/*---------------4.	差尋訂單--------------------------------------------*/
String page_code = "pu_api";
String api_name = "Puez_pay_external/get_order_history";		//API網址

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

    int success = respJson.getInt("success");
    String message = respJson.optString("message");

    if (success != 1) {
        System.out.println("API 失敗：" + message);
        return;
    }

    // ===== API 查詢成功，開始解析交易資料 =====
    JSONArray dataArr = respJson.optJSONArray("data");

    if (dataArr == null || dataArr.length() == 0) {
        System.out.println("查無交易資料");
        return;
    }

    // 通常取最後一筆（最新狀態）
    JSONObject last = dataArr.getJSONObject(dataArr.length() - 1);

    String statusDesc = last.optString("status_desc");
    String outNo = last.optString("out_no");
    String originalOrdId = last.optString("original_ord_id");
    String valid_day = last.optString("valid_day");

    System.out.println("訂單：" + originalOrdId);
    System.out.println("交易單號：" + outNo);
    System.out.println("交易狀態：" + statusDesc);

    // ===== 依付款狀態處理 =====
    if ("交易成功".equals(statusDesc)) {

        System.out.println("付款成功，更新收款狀態");

        dh.setUpdate("pupay");
        dh.setValue("dh_collect", "Y");
//         dh.setValue("dh_payno", outNo); // 建議存金流交易單號
        app_sm.update(dh);
        
        /*-------------更新payment資料---------------------------------------*/
        TableRecord ph = new TableRecord(tblph);
        TableRecord ph_check = app_sm.select(tblph, "data_id = ? AND ph_no = ?",
        					new Object[]{dh_id, dh.getString("dh_no")});
        if(!"".equals(ph_check.getString("ph_id"))) ph = ph_check;
        
        ph.setValue("data_id",dh_id);
        ph.setValue("ph_no",dh.getString("dh_no"));
        ph.setValue("ph_name",dh.getString("dh_name"));
        ph.setValue("ph_payment","行動支付");
        ph.setValue("ph_status","Y");
        ph.setValue("ph_paydate",valid_day);
        ph.setValue("ph_note",respJson.toString(2));
        ph.setValue("ph_code","payment_history");
        ph.setValue("ph_lang",lang);
        
        
        if(!"".equals(ph_check.getString("ph_id"))){
        	
        	ph.setUpdate("pu_check");
        	app_sm.update(ph);
        	
        }else{
        	ph.setInsert("pu_check");
        	app_sm.insert(ph);
        }

    } else if ("交易失敗".equals(statusDesc)) {

        System.out.println("付款失敗，不更新入帳");

        // 可選：記錄失敗原因
        dh.setUpdate("pupay");
        dh.setValue("dh_collect", "N");
        app_sm.update(dh);
        
        
        
        /*-------------更新payment資料---------------------------------------*/
        TableRecord ph = new TableRecord(tblph);
        TableRecord ph_check = app_sm.select(tblph, "data_id = ? AND ph_no = ?",
        					new Object[]{dh_id, dh.getString("dh_no")});
        if(!"".equals(ph_check.getString("ph_id"))) ph = ph_check;
        
        ph.setValue("data_id",dh_id);
        ph.setValue("ph_no",dh.getString("dh_no"));
        ph.setValue("ph_name",dh.getString("dh_name"));
        ph.setValue("ph_payment","行動支付");
        ph.setValue("ph_status","N");
        ph.setValue("ph_paydate",valid_day);
        ph.setValue("ph_note",respJson.toString(2));
        ph.setValue("ph_code","payment_history");
        ph.setValue("ph_lang",lang);
        
        
        if(!"".equals(ph_check.getString("ph_id"))){
        	
        	ph.setUpdate("pu_check");
        	app_sm.update(ph);
        	
        }else{
        	ph.setInsert("pu_check");
        	app_sm.insert(ph);
        }
        

    } else {

        System.out.println("未知交易狀態：" + statusDesc);
    }

} catch (Exception e) {
    System.out.println("回應不是合法 JSON：" + responseStr);
    e.printStackTrace();
}

} catch(Exception e) {
    e.printStackTrace();
}
finally{
	/*--------返回頁面--------------------------------*/
out.println("<script>alert('付款狀態查詢成功!!');frm1.submit();</script>");
	return;	
}
%>

