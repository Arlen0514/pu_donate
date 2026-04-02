<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/sha256.jspf"%>
<%@ page import="org.apache.commons.io.*"%>
<noscript><font color="blue">您的瀏覽器未開啓 Active scripting 功能，將無法正常瀏覽網站!</font></noscript>
<%
	// Check 圖形驗証碼
	String r = StringTool.validString((String)session.getAttribute("rand"));
	String ind = StringTool.validString(request.getParameter("ind"));
	if(!r.equals(ind)) {
		out.println("<script> alert('您輸入的圖案文字錯誤!!'); location='index.jsp'; </script>");
	    return;
	}
	
	// 登入IP檢查
	if("Y".equals(SiteSetup.getValue("ss.check_ip"))) {
		Vector<TableRecord> ics = app_sm.selectAll(tblic, "ic_code=?", new Object[]{ "ip_white_list" });

		Map<String, String> whiteList = new HashMap();
		whiteList.put("0:0:0:0:0:0:0:1", "PASS");		// 本機
		whiteList.put("220.130.149.189", "PASS");		// Lab2、公司
		whiteList.put("10.10.10.1", "PASS");			// Lab11
		for(TableRecord ic : ics) {
			whiteList.put(ic.getString("ic_ip"), "PASS");
		}

		if(whiteList.get(request.getRemoteAddr()) == null) {
			out.println("<script> alert('登入失敗，您目前的IP位置無權進入此網站！'); history.back(); </script>");
			System.out.println("Project:" + projectName + ", Time:" + DateTimeTool.dateTimeString() + ", IP:" + request.getRemoteAddr()+ " 嘗試登入網站。");
		    return;
		}
	}

   	// Input data.
   	String account  = StringTool.validString(request.getParameter("au_account"));
   	String password = StringTool.validString(request.getParameter("au_password"));
   	String language = StringTool.validString(request.getParameter("language"));
   	String language_str = StringTool.validString(request.getParameter("language_str")).trim();

   	// Select data.
   	Vector aus = app_sm.selectAll("admin_user", "au_account=? and au_password=?", new Object[]{ account, sha256(password) });

   	
   	// Admin user.
   	TableRecord au = (aus.size() > 0) ? (TableRecord)aus.get(0) : new TableRecord("admin_user");

   	// Authorities.
   	Vector kamfs = app_sm.selectAll("admin_map_function", "au_id=?", new Object[]{ au.getValue("au_id") });
   	String mfid = "";
   	if(aus.size() > 0 && (au.getString("au_account").equals("root") || kamfs.size() > 0)) {
      	// Login user data.
      	session.setAttribute("app_user", au);

       	// Last login
       	String auid = au.getString("au_id");
       	Vector __als = app_sm.selectAll(tblal, "au_id=? and al_logtype='1'", new Object[] { auid }, "al_logdate desc");
       	TableRecord lastlogin = new TableRecord(tblal);
       	if(__als.size() > 0) {
        	lastlogin = (TableRecord)__als.firstElement();
       	}
       	session.setAttribute("lastlogin", lastlogin);

       	// Login log
       	TableRecord al = new TableRecord(tblal);
       	al.setValue("al_id", IDTool.getUID("AL"));
       	al.setValue("al_createuser", au.getValue("au_account"));
       	al.setValue("al_modifyuser", au.getValue("au_account"));
       	al.setValue("al_createdate", DateTimeTool.dateTimeString());
       	al.setValue("al_modifydate", DateTimeTool.dateTimeString());
       	al.setValue("au_id", auid);
       	al.setValue("al_logtype", "1");    // 1 - 登入　0 - 登出
       	al.setValue("al_logdate", DateTimeTool.dateTimeString());
       	al.setValue("al_remoteip", request.getRemoteAddr());
       	app_sm.insert(al);

	   	// 清除 1 年前的登入 Log 記錄
	   	int ago_year = DateTimeTool.getYear(app_today) - 1;			// 1年前
	   	int ago_mouth = DateTimeTool.getMonth(app_today);
	   	int ago_day = DateTimeTool.getDay(app_today);
	   	String target_date = DateTimeTool.dateString(ago_year, ago_mouth, ago_day);
	   	app_sm.delete(tblal, "al_logdate<?", new Object[]{ target_date });

       	// This login
       	session.setAttribute("thislogin", al);
      	session.setAttribute("node", "0");
      	
      	// 抓取功能主項目
      	Vector tmfs = app_sm.selectAll("mis_function", "mf_status='N' and mf_type='1'", new Object[]{ }, "mf_priority");
      	if(app_menu.equals("1")) {
          	tmfs = new Vector();
          	Vector xxtmfs = app_sm.selectAll("mis_function", "mf_status='N' and mf_type='1'", new Object[]{ }, "mf_priority");
          	for(int i = 0; i < xxtmfs.size(); i++) {
              	TableRecord xxtmf = (TableRecord)xxtmfs.get(i);
              	// Check authrities.
              	Vector xamfs = app_sm.selectAll("admin_map_function", "au_id=? and mf_id=?", new Object[]{ au.getValue("au_id"), xxtmf.getString("mf_id") });
              	if(xamfs.size() > 0 || au.getString("au_account").equals("root")) {
					tmfs.add(xxtmf);
              	}
          	}
      	}
      	
      	// 抓取功能次項目
      	Vector lmfs = app_sm.selectAll("mis_function", "mf_status='N' and mf_type<>'1'", new Object[]{ }, "mf_type, mf_priority");
      	// Not register..
      	if(tmfs.size() == 0) {
         	String[] fieldname = new String[] { 
				"mf_id", "mf_name", "mf_folder", "mf_status", "mf_image1", "mf_image2", "mf_topimage",
				"mf_bgcolor1", "mf_bgcolor2", "mf_type", "mf_url", "mf_upfunction" 
			};
         	String[] fieldvalue1 = new String[] {
				"1", "系統管理設定", "system", "N", "system_button_1.gif", "system_button_1s.gif",
				"system_top_1.gif", "#CDE7FF", "#52A0EB", "1", "", "" 
			};
         	String[] fieldvalue2 = new String[] { 
         		"2", "產品註冊", "", "N", "", "", "", "", "", "2", "register_a.jsp", "1" 
         	};
         	TableRecord mf = new TableRecord("mis_function");
         	TableRecord amf = new TableRecord("admin_map_function");
         	for(int i = 0; i < fieldname.length; i++) {
             	mf.setValue(fieldname[i], fieldvalue1[i]);
         	}
         	app_sm.insert(mf);
         	tmfs.add(mf);
         	mf = new TableRecord("mis_function");
         	for(int i = 0; i < fieldname.length; i++) {
             	mf.setValue(fieldname[i], fieldvalue2[i]);
         	}
         	app_sm.insert(mf);
         	lmfs.add(mf);
		}
      	//application.setAttribute("top_function", tmfs);
      	//application.setAttribute("left_function", lmfs);
      	session.setAttribute("top_function", tmfs);
      	session.setAttribute("left_function", lmfs);
      	// First top function.
      	TableRecord tmf = (TableRecord)tmfs.get(0);
      	mfid = tmf.getString("mf_id");
      	// Set top function into session.
      	session.setAttribute("current_top", tmf);
      	session.setAttribute("language", language);
      	session.setAttribute("language_str", language_str);
   	}
   	
  	/*-- site_setup欄位預設 --*/
  	String[] titles = new String[] { "可使用的硬碟容量(MB)", "超額使用通知人信箱", "超額通知信的寄送時間" };
  	String[] keywords = new String[] { "ss.diskCapacity", "ss.overuse", "ss.overuse_mail_time" };
  	String[] values = new String[] { "3072", "service@geneinfo.com.tw", "1990/01/01 00:00:00" };

  	// Get records.
  	for(int i = 0; i < titles.length; i++) {
  		TableRecord ss = SiteSetup.getSetup(keywords[i]);
  		if (ss.getString("ss_id").equals("")) {
  			ss = new TableRecord(tblss);
  			ss.setInsert("System");
  			ss.setValue("ss_title", titles[i]);
  			ss.setValue("ss_keyword", keywords[i]);
  			ss.setValue("ss_text", values[i]);
  			app_sm.insert(ss);
  		}
  	}

   	if(aus.size() > 0) {
       	if (au.getString("au_account").equals("root") || kamfs.size() > 0) {
       		/*-- 計算uploads資料夾下的所有檔案大小 --*/
       		File uploads_f = new File (app_uploadpath);
			long diskCapacity = Integer.valueOf(SiteSetup.getSetup("ss.diskCapacity").getString("ss_text"));	// 可使用的容量大小(MB)
			long user_size = FileUtils.sizeOfDirectory(uploads_f) / 1024 / 1024;								// 已使用的容量大小(MB)

			if(user_size > diskCapacity) {
				out.println("<script> location='overuse_sendmail.jsp?mfid="+mfid+"' </script>");
				return;
			} else {
           		out.println("<script> location='default.jsp?mfid="+mfid+"' </script>");
			}
       	} else {
           	out.println("<script> alert('您尚未有任何權限使用本系統!!'); location='index.jsp'; </script>");
       	}
   	} else {
       	out.println("<script> alert('帳號、密碼錯誤，請重新輸入!!'); location='index.jsp'; </script>");
   	}
%>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>