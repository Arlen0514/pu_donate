<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>

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
			msg.setSentDate(new java.util.Date());
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
	// 基本參數
	String code = "mail_send"; 				// 模組識別碼
	String upload_code = "mail_send"; 		// 上傳資料夾識別碼
	String show_title = "電子報發送"; 				// 模組標題

	// 設定圖檔上傳 MB 數
	Integer fSize = 1;

	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));

	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle" };
	String[] values = new String[] { String.valueOf(pageno), qtitle};
%>	
<%
try {
	// A:新增,M:修改,D:刪除,S:排序
	String action = StringTool.validString(request.getParameter("action"));
	// 修改資料id
	String cp_id = StringTool.validString(request.getParameter("cp_id"));
	
	// 刪除
	if("D".equals(action)) {
		TableRecord cp = app_sm.select(tblcp, cp_id);
		//FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+cp.getString("cp_image"));
		//FileTool.deleteFile(app_uploadpath+"/"+code+"/"+lang+"/"+cp.getString("cp_mobile"));
		app_sm.delete(cp);

		// 確認是否有其它資料顯示相同圖片(有其它檔案欄位再新增code)
		if(app_sm.success()) {
			if(app_sm.selectAll(tblcp, "cp_image=?", new Object[]{ cp.getString("cp_image") }).size() == 0) {
				FileTool.deleteFile(app_uploadpath+"/"+upload_code+"/"+lang+"/"+cp.getString("cp_image"));
			}
			// 回列表頁
			out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
			out.println("<script> alert('刪除成功!!'); listpage.submit(); </script>");
		} else {
			out.println("<script> alert('刪除失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}	
		return;
	}
	
	// 檔案路徑與設置
	String dir = application.getRealPath("/") + "uploads/"+upload_code+"/"+lang+"/";
	File f_dir = new File(dir);
	if(!f_dir.exists()) {
		f_dir.mkdirs();
	}
	DiskFileUpload fu = new DiskFileUpload();
	fu.setHeaderEncoding("UTF-8");											// 亂碼關鍵(1)
	//fu.setSizeMax(4194304); 												// 設置文件大小
	//fu.setSizeThreshold(4096); 											// 設置緩衝大小
	//fu.setRepositoryPath(application.getRealPath("/") + "uploads/temp");  // 設置臨時目錄
	fu.setRepositoryPath(dir); 												// 設置臨時目錄     
	List fileItems = fu.parseRequest(request);
	Iterator i = fileItems.iterator();

	// 排序
	if("S".equals(action)) {
		String chk_cp = "";
		while(i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			if(fi.isFormField()) {											// 這是用來確定是否為文件屬性 
				String fieldName = new String(fi.getFieldName()); 			// 取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); 		// 取得值
				if("selData".equals(fieldName)){chk_cp = fieldvalue.trim();}
			}
		}
		String list[] = chk_cp.split(",");
		for(int j = 0; j < list.length; j++) {
			if(!"".equals(list[j].trim())) {
				TableRecord cp = app_sm.select(tblcp, "cp_id=?", new Object[]{ list[j] });
				cp.setValue("cp_showseq", j);
				cp.setUpdate(app_account);
				app_sm.update(cp);
			}
		}

		if(app_sm.success()) {
			// 回排序頁
			out.write(HtmlCoder.getForm("sortpage", code + "_sort.jsp", names, values));
			out.println("<script> alert('排序完成!!');sortpage.submit(); </script>");
		} else {
			out.println("<script> alert('排序失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;
	}
	
	// 新增
	if("A".equals(action)) {
		TableRecord cp = new TableRecord(tblcp);
		cp.setInsert(app_account);
		//---------------------檔案上傳-----------------------------------------------
		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();
			
			// 這是用來確定是否為文件屬性
			if(fi.isFormField()) {
				String fieldName = new String(fi.getFieldName()); 		// 取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); 	// 取得值
				//System.out.println("fieldName = " + fieldName + ", fieldvalue = " + fieldvalue);		// Debug用
				
				if(fieldName.equals("cp_title")) {
					Vector checks = app_sm.selectAll(tblcp, "cp_title=? and cp_code=? and cp_lang=?", new Object[]{ fieldvalue, code, lang });
					if(checks.size() > 0) {
						out.println("<script> alert('標題重複!!'); history.back(); </script>");
						return;
					}
				}
				cp.setValue(fieldName, fieldvalue.trim());				// 設定欄位值

			// 處理文件
			} else {
				int g = fi.getName().lastIndexOf("\\");
				String fileName = fi.getName();
				String fileName_1 = "";
				if(g < 0) {
	                fileName = fi.getName();							// 兼容非ie
	                fileName_1 = fi.getName();
	            } else {
	                fileName = fi.getName().substring(g);				// 取得上傳文件名
	                fileName_1 = fileName.substring(1,fileName.length());
	            }
				//fileName_1 = cp.getString("cp_id")+"_"+fileName_1;
				
				if(fileName != null && !"".equals(fileName)) {
					String chk_str = fileName;
					/*
					if(chk_str.getBytes().length != new String(chk_str).length()) {
						out.println("<script> alert('上傳檔名不可為中文'); history.back(); </script>");
						return;
					}
					*/
			        if(inValidFileExtension(fileName)) {
			        	out.println("<script> alert('上傳副檔名不正當!!');  history.back(); </script>");
			        	return;
			        }
					if((fSize * 1024 * 1024) < fi.getSize()) {
						out.println("<script> alert('上傳檔案不可超過"+String.valueOf(fSize)+"MB'); history.back(); </script>");
						return;
					}
					fi.write(new File(dir, fileName_1 ));
					cp.setValue(fi.getFieldName(), fileName_1);			// 設定圖
				}
			}
		}
		cp.setValue("cp_code", code);	// 識別碼
		cp.setValue("cp_lang", lang);	// 語系		
		app_sm.insert(cp);

		if(app_sm.success()) {
			// 回列表頁
			out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
			out.println("<script> alert('新增成功!!');listpage.submit(); </script>");
		} else {
			out.println("<script> alert('新增失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;

	// 修改
	} else if("M".equals(action)) {
		TableRecord cp = app_sm.select(tblcp, "cp_id=?",new Object[] { cp_id });
		cp.setUpdate(app_account);
		while (i.hasNext()) {
			FileItem fi = (FileItem) i.next();

			// 這是用來確定是否為文件屬性
			if(fi.isFormField()) {
				String fieldName = new String(fi.getFieldName()); 		// 取得表單名
				String fieldvalue = new String(fi.getString("UTF-8")); 	// 取得值
				//System.out.println("fieldName = " + fieldName + ", fieldvalue = " + fieldvalue);		// Debug用

				if(fieldName.equals("cp_title")) {
					Vector checks = app_sm.selectAll(tblcp, "cp_title=? and cp_id <>? and cp_code=? and cp_lang=?", new Object[]{ fieldvalue, cp_id, code, lang });
					if(checks.size() > 0) {
						out.println("<script> alert('標題重複!!'); history.back(); </script>");
						return;
					} else {
						cp.setValue(fieldName, fieldvalue.trim());		// 設定欄位值
					}
			    } else if(!fieldName.startsWith("imgradio")) {
			    	if("_qtitle".equals(fieldName)) { 					// 解決查詢標題為中文時傳值的問題
						values[1] = fieldvalue.trim();
					} else {
						cp.setValue(fieldName, fieldvalue.trim());		// 設定欄位值
					}
			    }
				
			// 處理文件(file)
			} else {
				int g = fi.getName().lastIndexOf("\\");
				String fileName = fi.getName();
				String fileName_1 = "";
				if(g < 0) {
	                fileName = fi.getName();							// 兼容非ie
	                fileName_1 = fi.getName();
	            } else {
	                fileName = fi.getName().substring(g);				// 取得上傳文件名
	                fileName_1 = fileName.substring(1,fileName.length());
	            }
				//fileName_1 = cp.getString("cp_id")+"_"+fileName_1;
				
				if(fileName != null && !"".equals(fileName)) {
					String chk_str = fileName;
					/*
					if(chk_str.getBytes().length != new String(chk_str).length()){
						out.println("<script> alert('上傳檔名不可為中文'); history.back(); </script>");
						return;
					}
					*/
			        if(inValidFileExtension(fileName)) {
			        	out.println("<script> alert('上傳副檔名不正當!!');  history.back(); </script>");
			        	return;
			        }
					if((fSize * 1024 * 1024) < fi.getSize()) {
						out.println("<script> alert('上傳檔案不可超過"+String.valueOf(fSize)+"MB'); history.back(); </script>");
						return;
					}
					// Delete 原來的 image file.
					if(!"".equals(cp.getString(fi.getFieldName()))) {
						//確認其它資料沒有使用相同檔案
						if(app_sm.selectAll(tblcp, fi.getFieldName()+"=?", new Object[]{ cp.getString(fi.getFieldName()) }).size() == 1) {
							FileTool.deleteFile(app_uploadpath+"/"+upload_code+"/"+lang+"/"+cp.getString(fi.getFieldName()));
						}
					}

					fi.write(new File(dir, fileName_1 ));
					cp.setValue(fi.getFieldName(), fileName_1);			// 設定圖
				}
			}
		}		
		app_sm.update(cp);

		if(app_sm.success()) {
			// 回列表頁
			out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
		    out.println("<script> alert('修改成功!!'); listpage.submit(); </script>");
		} else {
			out.println("<script> alert('修改失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
		}
		return;
	}
 else if("send".equals(action)) {
	TableRecord cp = app_sm.select(tblcp, "cp_id=?",new Object[] { cp_id });
	while (i.hasNext()) {
		FileItem fi = (FileItem) i.next();

		// 這是用來確定是否為文件屬性
		if(fi.isFormField()) {
			String fieldName = new String(fi.getFieldName()); 		// 取得表單名
			String fieldvalue = new String(fi.getString("UTF-8")); 	// 取得值
			System.out.println("fieldName = " + fieldName + ", fieldvalue = " + fieldvalue);		// Debug用

			if(fieldName.equals("cp_title")) {
				Vector checks = app_sm.selectAll(tblcp, "cp_title=? and cp_id <>? and cp_code=? and cp_lang=?", new Object[]{ fieldvalue, cp_id, code, lang });
				if(checks.size() > 0) {
					out.println("<script> alert('標題重複!!'); history.back(); </script>");
					return;
				} else {
					cp.setValue(fieldName, fieldvalue.trim());		// 設定欄位值
				}
		    } else if(!fieldName.startsWith("imgradio")) {
		    	if("_qtitle".equals(fieldName)) { 					// 解決查詢標題為中文時傳值的問題
					values[1] = fieldvalue.trim();
				} else {
					cp.setValue(fieldName, fieldvalue.trim());		// 設定欄位值
				}
		    }
			
		// 處理文件(file)
		} else {
			int g = fi.getName().lastIndexOf("\\");
			String fileName = fi.getName();
			String fileName_1 = "";
			if(g < 0) {
                fileName = fi.getName();							// 兼容非ie
                fileName_1 = fi.getName();
            } else {
                fileName = fi.getName().substring(g);				// 取得上傳文件名
                fileName_1 = fileName.substring(1,fileName.length());
            }
			//fileName_1 = cp.getString("cp_id")+"_"+fileName_1;
			
			if(fileName != null && !"".equals(fileName)) {
				String chk_str = fileName;
				/*
				if(chk_str.getBytes().length != new String(chk_str).length()){
					out.println("<script> alert('上傳檔名不可為中文'); history.back(); </script>");
					return;
				}
				*/
		        if(inValidFileExtension(fileName)) {
		        	out.println("<script> alert('上傳副檔名不正當!!');  history.back(); </script>");
		        	return;
		        }
				if((fSize * 1024 * 1024) < fi.getSize()) {
					out.println("<script> alert('上傳檔案不可超過"+String.valueOf(fSize)+"MB'); history.back(); </script>");
					return;
				}
				// Delete 原來的 image file.
				if(!"".equals(cp.getString(fi.getFieldName()))) {
					//確認其它資料沒有使用相同檔案
					if(app_sm.selectAll(tblcp, fi.getFieldName()+"=?", new Object[]{ cp.getString(fi.getFieldName()) }).size() == 1) {
						FileTool.deleteFile(app_uploadpath+"/"+upload_code+"/"+lang+"/"+cp.getString(fi.getFieldName()));
					}
				}

				fi.write(new File(dir, fileName_1 ));
				cp.setValue(fi.getFieldName(), fileName_1);			// 設定圖
			}
		}
	}		
	
	
// 	System.out.println("mail :"+ cp.getString("cp_desc"));
	String[] mails = cp.getString("cp_desc").split(",");
	
	
	
	String servername = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
  	if((request.getServerPort()== 80) || (request.getServerPort()== 443)) {
  		servername = request.getScheme()+"://"+request.getServerName();
  	} 
	String localname = request.getScheme()+"://"+request.getLocalName()+":"+request.getLocalPort();
  	String url = servername + request.getContextPath();
	
  	String msg = "";
  	
  	for(String mail : mails){
  	
		String email    = mail;				// 收件人
		String subject  = cp.getString("cp_title");					// 信件主旨
		String data_id  = cp.getString("cp_id");					// 信件資料ID
		String language = "tw";					   						// 使用語系
		String emailbcc = "";										// 副本收件人
		String template = "";										// 信件樣板
		String content  = "";										// 信件內容
		boolean log_status 	 = false;							// Log 開關
		boolean send_success = true;								// 是否成功寄信
				
				
		template = "/web/mail/mail.jsp?lang=" + lang;
		content = getMailContent(url, template);
		//發信
		send_success = sendRecordMail(subject, content, email, emailbcc, language, log_status);
		
		if(!send_success) msg += email+","; 
	
  	}
	
  	if(!"".equals(msg)) 
  		msg += "寄發完成，寄發失敗名單 :"+msg;
  	else
  		msg = "寄發完成!!";

	if(app_sm.success()) {
		// 回列表頁
		out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
	    out.println("<script> alert('"+msg+"'); listpage.submit(); </script>");
	} else {
		out.println("<script> alert('寄發失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
	}
	return;
}
} catch(Exception e) {
	System.out.println("Project:" + projectName + ", Error info:["+e+"]File name edit.jsp for ["+code+"]Time:["+DateTimeTool.dateTimeString()+"]");
	out.println("<script> alert('處理失敗'); history.back(); </script>");
} finally {
	app_sm.close();
}
%>