<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
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
	
	// 建立設定TLSv1.2 (Java 7)
	SSLContext sc = SSLContext.getInstance("TLSv1.2"); 
	sc.init(null, null, new java.security.SecureRandom());
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
%>
<%
	String page_code = "overuse"; 			// 功能識別碼
	String mfid = StringTool.validString(request.getParameter("mfid"));
	String overuse = SiteSetup.getSetup("ss.overuse").getString("ss_text");
	String overuse_mail_time = SiteSetup.getSetup("ss.overuse_mail_time").getString("ss_text");
	
	/*-- 每次寄信至少要過3天才能在寄一次 --*/
	Calendar cDate = Calendar.getInstance();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	cDate.setTime(sdf.parse(overuse_mail_time));
	cDate.add(Calendar.DATE, 3);			// 3天後可以再寄一次

	Date mailDate = cDate.getTime();								// 可以寄信的日期
	Date today = sdf.parse(DateTimeTool.dateTimeString());  		// 今天的日期
	if(today.before(mailDate) && !today.equals(mailDate)) {
		out.println("<script> location='default.jsp?mfid="+mfid+"' </script>");
		return;
	} else {
		TableRecord ss = SiteSetup.getSetup("ss.overuse_mail_time");
		ss.setUpdate("System");
		ss.setValue("ss_text", DateTimeTool.dateTimeString());
		app_sm.update(ss);
	}

	/*-- 利用 JavaMail 元件寄送信件 --*/
	final String uid = SiteSetup.getValue("smtp.auth.account"); 						// 設定 Smtp 認證帳號
	final String upw = SiteSetup.getValue("smtp.auth.password"); 						// 設定 Smtp 密碼
	String mailhost = SiteSetup.getValue("smtp.host.name"); 							// 設定 Smtp Server 名稱
	String smtpport = SiteSetup.getValue("smtp.auth.port"); 							// 設定 Smtp Server 的 Port 值
	String smtpauth = SiteSetup.getValue("smtp.auth.status"); 							// 設定 Smtp Server 是否需要認證 , 或是使用 GMail 465 Port
	String us_email = SiteSetup.getValue("service.email.address"); 						// 設定寄件人 e-Mail
	String us_name = SiteSetup.getValue("service.email.name"); 							// 設定寄件人 名稱
	String servmailto = overuse; 														// 設定正本收件人 e-Mail
	String servmailcc 	= "";													 		// 設定副本收件人 e-Mail
	String servmailbcc	= ""; 															// 設定密件副本收件人 e-Mail
	String subject = ""; 																// 設定信件主旨內容
	subject = SiteSetup.getText("cp.company." + lang) + " 硬碟容量超額使用通知信";

	// Server name.
	String servername = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort();
	if (request.getServerPort() == 80 || request.getServerPort() == 443) {
		servername = request.getScheme() + "://" + request.getServerName();
	}
	String localname = request.getScheme() + "://" + request.getLocalName() + ":" + request.getLocalPort();
	String url = servername + request.getContextPath();
	// 設定信件內容
	StringBuffer sb = new StringBuffer();
	String content = "";

	if(url.indexOf("https://") > -1) {
		content = SSLreturnContent(url + "/web/mail/overuse_mail.jsp?lang=" + lang);
	} else {
		Vector urlcontent = HttpURL.returnContent(url + "/web/mail/overuse_mail.jsp?lang=" + lang); // 信件內容產生的 JSP 檔
		for(int i = 0; i < urlcontent.size(); i++) {
			String line = (String) urlcontent.get(i);
			sb.append(line);
		}
		content = sb.toString();
	}

	request.setCharacterEncoding("UTF-8"); 	// 設定信件使用字集
	boolean sessionDebug = false; 			// 設定是否啟用除錯模式 true 為開啟 , false 為關閉
	String userName = uid; 					// your id
	String password = upw; 					// your password		

	try {
		java.util.Properties props = System.getProperties();
		props.put("mail.smtp.host", mailhost);
		props.put("mail.smtp.port", smtpport);

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
			 props.put("mail.smtp.ssl.enable", false);
			 props.put("mail.smtp.starttls.enable", false);
			 props.put("mail.smtp.auth.plain.disable", false);
		}

		Authenticator auth = new javax.mail.Authenticator() {
			String userName = uid;	// your id
			String password = upw;	// your password

			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(userName, password);
			}
		};
		//javax.mail.Session mailSession = javax.mail.Session.getDefaultInstance(props,auth);//在linux下用下列getInstance
		javax.mail.Session mailSession = javax.mail.Session.getInstance(props, auth);
		mailSession.setDebug(sessionDebug);
		MimeMessage msg = new MimeMessage(mailSession); 		// 需使用 MimeMessage 型態 , 信件主題才不會有亂碼
		msg.setFrom(new InternetAddress(us_email, us_name));	// set mail from
		// set to email
		// 指定收件人,多人請用逗點分開 
		InternetAddress[] address = InternetAddress.parse(servmailto);
		msg.setRecipients(Message.RecipientType.TO, address);
		// 副本
		InternetAddress[] ccAddress = InternetAddress.parse(servmailcc);
		msg.setRecipients(Message.RecipientType.CC,ccAddress);
		msg.setSubject(subject,"UTF-8");
		// 密件副本	
		InternetAddress[] bccAddress = InternetAddress.parse(servmailbcc);
		msg.setRecipients(Message.RecipientType.BCC,bccAddress);
		msg.setSubject(subject,"UTF-8");
		// set send date
		msg.setSentDate(new Date());
		// set content
		msg.setContent(content, "text/html; charset=UTF-8");
		// Get Transport use userName and password
		Transport trans = mailSession.getTransport("smtp");
		trans.connect(mailhost, userName, password);
		trans.send(msg);
		trans.close();

		out.println("<script> location='default.jsp?mfid="+mfid+"' </script>");
	} catch (Exception ex) {
		System.out.println("Project:" + projectName + ", Error info:" + ex + ", File name:overuse_sendmail.jsp, Time:" + DateTimeTool.dateTimeString());
		out.println("<script> location='default.jsp?mfid="+mfid+"' </script>");
	} finally {
		app_sm.close();
	}
%>