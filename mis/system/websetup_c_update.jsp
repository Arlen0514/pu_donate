<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	/*-- 針對各語系設定欄位 --*/
	// Tiltes.
	String[] titles = new String[] {
		"靜宜大學連結", "校友中心連結", "宗教輔導室",  "蓋夏圖書館", "體育室",
		"校友中心連結名稱",  "宗教輔導室名稱","蓋夏圖書館名稱", "體育室名稱",
		"Facebook", "Youtube", "Instagram", "Threads",
		"地址連結", "隱私連結",
		"網站前台名稱", "公司名稱", "地址", "電話", "傳真", "統編", "信箱",
		"Open Graph 標題", "Open Graph 簡述", "索引", "來訪週期", "關鍵字",
		"版權說明", "內容簡介", "head追踪碼", "body追踪碼"
	};

	// Keywords.
	String[] keywords = new String[] {
		"web_ntou_official_url" , "web_alumni_center_url", "campus_url", "library_url", "sport_url",
		"web_alumni_center_title", "campus_title", "library_title", "sport_title",
		"cp.fb", "cp.yt", "cp.ig", "cp.td", 
		"cp.address_link", "cp.privacy_link",
		"web_title", "cp.company", "cp.address", "cp.phone", "cp.fax", "cp.companyno", "cp.email",
		"og.title", "og.description", "seo.robots", "seo.revisit_after", "seo.keywords",
		"seo.copyright", "seo.description", "seo.head_track", "seo.body_track"
	};

	// Get records.
	Vector misimages = new Vector();
	for (int i = 0; i < titles.length; i++) {
		TableRecord ss = SiteSetup.getSetup(keywords[i] + "." + lang);
		ss.setUpdate(app_account);
		String value = StringTool.validString(request.getParameter(keywords[i]));
		ss.setValue("ss_text", value);
		ss.setUpdate(app_account);
		app_sm.update(ss);
	}

	/*-- 針對不分語系共通設定欄位 --*/
	// Tiltes.
	String[] titles_1 = new String[] { 
		"載入頁", "分頁設定", "檢查登入IP設定", "洽詢專線聯絡人-聯絡資訊", "洽詢專線聯絡人-電子信箱"
	};

	// Keywords.
	String[] keywords_1 = new String[] { 
		"ss.loading", "ss.pageno", "ss.check_ip" , "ss.contact_info" , "ss.contact_email" 
	};

	// Get records.
	Vector misimages_1 = new Vector();
	for (int i = 0; i < titles_1.length; i++) {
		TableRecord ss = SiteSetup.getSetup(keywords_1[i]);
		ss.setUpdate(app_account);
		String value = StringTool.validString(request.getParameter(keywords_1[i]));
		ss.setValue("ss_value", value);
		ss.setUpdate(app_account);
		app_sm.update(ss);
	}

	if (app_sm.success()) {
		out.println("<script> alert('資料修改成功!!'); location='websetup_c.jsp'; </script>");
	} else {
		out.println("<script> alert('資料修改失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
	}
%>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>