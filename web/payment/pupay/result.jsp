<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.json.*" %>
<%@ page import="java.io.*" %>
<%@include file="config.jsp"%>

<%@page import="javax.mail.*"%>
<%@page import="javax.mail.internet.*"%>
<%@page import="javax.activation.*"%>
<%@ page import="java.net.URL" %>
<%@ page import="javax.net.ssl.*" %>
<%!
	public static String SSLreturnContent(String strURL) throws Exception{
		String content = "";
		String line = "";
		URL l_url = new URL(strURL);
		HttpsURLConnection l_connection = (HttpsURLConnection)l_url.openConnection();
		
		// for 智邦 20240123 Miles start
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
		
		// 建立設定TLSv1.2 (Java 7)
		SSLContext sc = SSLContext.getInstance("TLSv1.2"); 
		// sc.init(null, null, new java.security.SecureRandom());
		sc.init(null, trustAllCerts, new java.security.SecureRandom());
		
		// for 智邦 20240123 Miles end 
		l_connection.setSSLSocketFactory(sc.getSocketFactory());
		
		l_connection.connect();
		StringBuffer buffer = new StringBuffer();
		InputStream l_urlStream = l_connection.getInputStream();
		BufferedReader l_reader = new BufferedReader(new InputStreamReader(l_urlStream, "UTF-8"));
		while ((line = l_reader.readLine()) != null) {
			buffer.append(line);
		}
		
		l_reader.close();
		l_urlStream.close();
		l_connection.disconnect();
		
		content = buffer.toString();
		
		return content;
	}

	// 20240416 Roy 修改
	public synchronized boolean sendRecordMail(String subject, String messages, String email, 
			String servmailbcc, String lang, boolean debug) throws Exception {
		boolean status = true;
		
		try {
			final String uid	= SiteSetup.getValue("smtp.auth.account"); 					// 設定 Smtp 認證帳號
			final String upw 	= SiteSetup.getValue("smtp.auth.password"); 	
			String mailhost 	= SiteSetup.getValue("smtp.host.name");
			String smtpport 	= SiteSetup.getValue("smtp.auth.port");
			String smtpauth 	= SiteSetup.getValue("smtp.auth.status");
			String ssluseauth = SiteSetup.getValue("smtp.ssluse.status"); 						// 設定 Smtp SSL 是否使用
			String us_email 	= SiteSetup.getValue("service.email.address");
			String us_name 		= SiteSetup.getValue("service.email.name");
			
			String content = messages ;
			boolean sessionDebug = debug;
			String userName = uid;
			String password = upw;
			
			java.util.Properties props = System.getProperties();
			props.put("mail.smtp.host", mailhost);
			props.put("mail.smtp.port", smtpport);
			
			// 以下設定如果設定錯會發不出信建
			if ("G".equals(smtpauth)) {
			// 使用 Gmail SMTP	Server 465 port 寄信
			// 注意需先至 https://www.google.com/settings/security/lesssecureapps 將帳號開啟允許低安全登錄
			props.put("mail.smtp.auth", true);
			props.setProperty("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
			props.setProperty("mail.smtp.socketFactory.fallback", "false");
			props.setProperty("mail.smtp.socketFactory.port", smtpport);
			props.put("mail.smtp.ssl.enable", true);
			props.put("mail.smtp.starttls.enable", true);
			props.put("mail.smtp.auth.plain.disable", true);
		} else if ("O".equals(smtpauth)) {										// 使用Office 365 smtp 寄信
			props.put("mail.smtp.auth", true);
			props.put("mail.smtp.ssl.enable", false);
			props.put("mail.smtp.tls.enable", true);
			props.put("mail.smtp.starttls.enable",true);
		} else {																// 使用一般 SMTP Sever 寄信
		 	 props.put("mail.smtp.auth", "N".equals(smtpauth)?false:true);
			 props.setProperty("mail.smtp.socketFactory.class", "");
			 props.setProperty("mail.smtp.socketFactory.fallback", "false");
			 props.setProperty("mail.smtp.socketFactory.port", smtpport);
			 if("Y".equals(ssluseauth)){
				 // For SSL use 
				 props.put("mail.smtp.ssl.trust", "*");
				 props.put("mail.smtp.ssl.enable", true);
				 props.put("mail.smtp.starttls.enable", true);
				 props.put("mail.smtp.auth.plain.disable", true);
			 }else{
				 props.put("mail.smtp.ssl.enable", false);
				 props.put("mail.smtp.starttls.enable", false);
				 props.put("mail.smtp.auth.plain.disable", false);				 
			 }
		}
			
			
			javax.mail.Authenticator auth = new javax.mail.Authenticator() {
				String userName = uid;		//your id
				String password = upw;		//your password
		
				protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
					return new javax.mail.PasswordAuthentication(this.userName, this.password);
				}
			};
			
			javax.mail.Session mailSession = javax.mail.Session.getInstance(props, auth);
			mailSession.setDebug(sessionDebug);
			
			MimeMessage msg = new MimeMessage(mailSession);
			msg.setFrom(new InternetAddress(us_email, us_name));
			
			InternetAddress[] address = InternetAddress.parse(email);
			msg.setRecipients(Message.RecipientType.TO, address);
			
			// 密件副本	
			InternetAddress[] bccAddress = InternetAddress.parse(servmailbcc);
			msg.setRecipients(Message.RecipientType.BCC,bccAddress);
			msg.setSentDate(new Date());
			msg.setSubject(subject, "UTF-8");
			msg.setContent(content, "text/html; charset=UTF-8");
			
			Transport trans = mailSession.getTransport("smtp");
			trans.connect(mailhost, userName, password);
			trans.send(msg);
		
			if (trans.isConnected()) {
				trans.close();
			}
		} catch (Exception e) {
			status = false;
		}
		
		return status;
	}
	
	// 取得信件內容
	public String getMailContent(String url_path, String mail_file) throws Exception {
		StringBuffer sb = new StringBuffer();
		String content = "";
		
		try {
			if(url_path.indexOf("https://")>-1) {
				content = SSLreturnContent(url_path + mail_file);
			} else {
				Vector urlcontent = HttpURL.returnContent(url_path + mail_file); // 信件內容產生的 JSP 檔
				for(int i = 0; i < urlcontent.size(); i++) {
					String line = (String) urlcontent.get(i);
					sb.append(line);
				}
				content = sb.toString();
			}
		} catch(Exception e){
			content = "";
		}
		
		return content;
	}
%>
<%
    // 1. 先拿 request 參數
    String requestJson = StringTool.validString(request.getParameter("request"));
    System.out.println("RAW requestJson: " + requestJson);

    // 2. 防呆：空值
    if(requestJson == null || requestJson.trim().isEmpty()){
        out.print("{\"success\":-1,\"message\":\"沒有收到 request 參數或空值\"}");
        return;
    }

    // 3. 解析 JSON
    JSONObject jsonObj = null;
    try {
        jsonObj = new JSONObject(requestJson);
    } catch(Exception e){
        e.printStackTrace();
        out.print("{\"success\":-1,\"message\":\"JSON 格式不合法: " + e.getMessage() + "\"}");
        return;
    }

    // 4. 取各欄位
    String payment_time = jsonObj.optString("payment_time", "");
    int amount = jsonObj.optInt("amount", -1);
    String card_last4 = jsonObj.optString("card_last4", "");
    String order_id = jsonObj.optString("order_id", "");
    String status = jsonObj.optString("status", "");
    String message = jsonObj.optString("message", "");
    String method = jsonObj.optString("method", "");

    // 5. 防呆檢查
    if(payment_time.isEmpty() || amount <= 0 || order_id.isEmpty() || status.isEmpty() || method.isEmpty()){
        out.print("{\"success\":-1,\"message\":\"缺少必要欄位或資料不合法\"}");
        return;
    }

    // 6. 付款方式檢查
//     if(!("信用卡".equalsIgnoreCase(method) || "LINEPAY".equalsIgnoreCase(method) || "TAIWAN PAY".equalsIgnoreCase(method))){
//         out.print("{\"success\":-1,\"message\":\"付款方式不合法\"}");
//         return;
//     }

    // 7. 交易狀態檢查
    if(!("SUCCESS".equalsIgnoreCase(status) || "FAIL".equalsIgnoreCase(status))){
        out.print("{\"success\":-1,\"message\":\"交易狀態不合法\"}");
        return;
    }

    // 8. TODO: 寫入資料庫
    // insert into payment_log(payment_time, amount, card_last4, order_id, status, message, method)
    
    
    if("".equals(order_id.trim())){
    	System.out.println("訂單 :"+order_id+"遺失");
    	
    }else{
    	
    	TableRecord ph = app_sm.select(tblph, "ph_no = ?",
				new Object[]{order_id});
    	ph.setUpdate("pu_receive");
    	
        ph.setValue("ph_bank_no",card_last4);
        ph.setValue("ph_payment",method);
        ph.setValue("ph_status",status);
        ph.setValue("ph_return_msg",message);
        ph.setValue("ph_paydate",payment_time);
    	
		if(!"".equals(ph.getString("ph_id"))){
        	
        	app_sm.update(ph);
        	
        }else{
        	TableRecord dh = app_sm.select(tbldh,"dh_no = ?", new Object[]{order_id});
        	ph.setValue("data_id",dh.getString("dh_id"));
        	app_sm.insert(ph);
        }    	
    	
    	/*-------------------更新dh--------------------------*/
    	TableRecord dh = app_sm.select(tbldh,ph.getString("data_id"));
    	dh.setUpdate("pupay");
        dh.setValue("dh_collect", "Y");
//         dh.setValue("dh_payno", outNo); // 建議存金流交易單號
        app_sm.update(dh);

/*----------捐款完成信---------------*/
  //Server name.	
  	String servername = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
  	if((request.getServerPort()== 80) || (request.getServerPort()== 443)) {
  		servername = request.getScheme()+"://"+request.getServerName();
  	} 
  	String localname = request.getScheme()+"://"+request.getLocalName()+":"+request.getLocalPort();
  	String url = servername + request.getContextPath();
  	
		String email    = dh.getString("dh_email");				// 收件人
		String subject  = "捐款完成感謝信";									// 信件主旨
		String data_id  = dh.getString("dh_id");					// 信件資料ID
		String language = "tw";					   						// 使用語系
		String emailbcc = "";										// 副本收件人
		String template = "";										// 信件樣板
		String content  = "";										// 信件內容
		boolean log_status 	 = false;							// Log 開關
		boolean send_success = true;								// 是否成功寄信
				
				
		template = "/web/mail/thank_mail.jsp?dh_id=" + data_id + "&lang=" + lang;
		content = getMailContent(url, template);
		//發信
		send_success = sendRecordMail(subject, content, email, emailbcc, language, log_status);
    	
    }
    
    

    // 9. 成功回應
    out.print("{\"success\":1,\"message\":\"資料接收成功\"}");
%>
