<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/config.jspf" %>
<%-- <%@ include file="/web/include/words.jsp" %> --%>
<%
    String page_code = "home";

    /*----------------------------------------------------------- 主選單 -----------------------------------------------------------*/

    // 募款專案類別
    Vector<TableRecord> nav_donate_project_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category=?",
            new Object[]{"donate_category", lang, ""}, "dm_showseq ASC, dm_createdate DESC");
    // 捐款指南類別
    Vector<TableRecord> nav_download_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category=?",
            new Object[]{"download_category", lang, ""}, "dm_showseq ASC, dm_createdate DESC");


    /*----------------------------------------------------------- 主功能 -----------------------------------------------------------*/

    // 輪播圖
    Vector<TableRecord> banner_aps = app_sm.selectAll(tblap, "ap_code=? AND ap_lang =? AND NOT(ap_emitdate>? OR ap_restdate<?)",
            new Object[]{"banner", lang, app_today, app_today}, "ap_showseq ASC , ap_createdate DESC");

    // 募款專案類別
    Vector<TableRecord> donate_project_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category=?",
            new Object[]{"donate_category", lang, ""}, "dm_showseq ASC, dm_createdate DESC limit 6");
	//常見問題類別
	Vector<TableRecord> qa_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? ",
            new Object[]{"qa2_category", lang}, "dm_showseq ASC, dm_createdate DESC");
	//捐款單下載檔案
	TableRecord download_file = app_sm.select(tblcp, "cp_code = ? AND cp_lang = ?", new Object[]{"donate_download",lang});
	//活動捐款項目
	Vector<TableRecord> activity_donates = app_sm.selectAll(tblcp, "cp_code = ? AND cp_lang = ? AND cp_emitdate <= ? AND cp_restdate >= ?", new Object[] { "activity_donate", lang, app_today, app_today }, "cp_showseq ASC , " + "cp_emitdate DESC");
	//最新消息
	Vector<TableRecord> home_news = app_sm.selectAll(tblnp, "np_code = ? AND np_lang = ? AND np_emitdate <= ? AND np_restdate >= ?", new Object[] { "news", lang, app_today, app_today }, "np_showseq ASC , " + "np_emitdate DESC limit 5");
    
    /*----------------------------------------------------------- 版腳資訊 -----------------------------------------------------------*/
    String copr_company = SiteSetup.getSetup("cp.company" + "." + lang).getString("ss_text"),
    		copr_address = SiteSetup.getSetup("cp.address" + "." + lang).getString("ss_text"),
    		copr_address_link = SiteSetup.getSetup("cp.address_link" + "." + lang).getString("ss_text"),
            copr_email = SiteSetup.getSetup("cp.email" + "." + lang).getString("ss_text"),
            copr_phone = SiteSetup.getSetup("cp.phone" + "." + lang).getString("ss_text"),
            copr_fax = SiteSetup.getSetup("cp.fax" + "." + lang).getString("ss_text"),
            web_alumni_center_url = SiteSetup.getSetup("web_alumni_center_url" + "." + lang).getString("ss_text"),
            campus_url = SiteSetup.getSetup("campus_url" + "." + lang).getString("ss_text"),
            library_url = SiteSetup.getSetup("library_url" + "." + lang).getString("ss_text"),
            sport_url = SiteSetup.getSetup("sport_url" + "." + lang).getString("ss_text"),
            fb_url = SiteSetup.getSetup("cp.fb" + "." + lang).getString("ss_text"),
            yt_url = SiteSetup.getSetup("cp.yt" + "." + lang).getString("ss_text"),
            ig_url = SiteSetup.getSetup("cp.ig" + "." + lang).getString("ss_text"),
            td_url = SiteSetup.getSetup("cp.td" + "." + lang).getString("ss_text");

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=app_webtitle %></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/><!--讓ie在切換瀏覽器模式時 文件模式會使用最新的版本-->

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<!-- <meta name="Robots" content="none" />不被搜尋引擎搜到 -->

<!--RWD用-->
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<!--RWD用-->

<!--android 手機板主題顏色用 更改網址列顏色-->
<meta name="theme-color" content="#66CCCC">
<!--android 手機板主題顏色用-->

<meta name="format-detection" content="telephone=no"><!--取消行動版 safari 自動偵測數字成電話號碼-->


<link rel="shortcut icon" href="web/images/favicon.png" /><!--電腦版icon-->
<link rel="apple-touch-icon" href="web/images/icon.png" /><!--手機版icon  57x57px-->
<link rel="apple-touch-icon" sizes="72x72" href="web/images/icon-72.png" /><!--手機版icon  72x72px-->
<link rel="apple-touch-icon" sizes="114x114" href="web/images/icon@2.png" /><!--手機版icon  114x114px-->

<!--內容區塊css-->
<link rel="stylesheet" type="text/css" href="web/css/style.css"/>
<!--版頭區塊css-->
<link rel="stylesheet" type="text/css" href="web/css/style_header.css"/>
<!--版腳區塊css-->
<link rel="stylesheet" type="text/css" href="web/css/style_footer.css"/>

<!--home區塊css-->
<link rel="stylesheet" type="text/css" href="web/css/style_home.css"/>


<!--google material icon-->
<link rel="stylesheet" href="web/icon_fonts/material_icons/material_icons.css">
<link rel="stylesheet" href="web/icon_fonts/material_icons/material_symbols_outlined.css">  <!-- 為了弱掃留原始檔案 -->
<!-- <link href="https://fonts.googleapis.com/css2?family=Material+Icons" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet"> -->

<!-- bootstrap-icons -->
<!-- <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"> -->
<link rel="stylesheet" href="web/icon_fonts/bootstrap_icons/bootstrap-icons.css"> <!-- 為了弱掃留原始檔案 -->

<!-- Font Awesome icon -->
<!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"> -->
<link rel="stylesheet" type="text/css" href="web/icon_fonts/font_awesome_icon/font_awesome_icon_all.min.css"/><!-- 為了弱掃留原始檔案 -->

<!-- jQuery版本3.7.1 -->
<!-- <script src="https://code.jquery.com/jquery-3.7.1.min.js" type="text/javascript"></script> -->
<script src="web/js/jquery/jquery-3.7.1.min.js" type="text/javascript"></script>  <!-- 為了弱掃留原始檔案 -->
<!-- jQuery 遷移插件_簡化從舊版本jQuery的轉換3.5.2-->
<!-- <script src="https://code.jquery.com/jquery-migrate-3.5.2.min.js" type="text/javascript"></script> -->
<script src="web/js/jquery/jquery-migrate-3.5.2.min.js" type="text/javascript"></script>  <!-- 為了弱掃留原始檔案 -->
<!-- 版本更新 jQuery by Judy 20241211 end -->


<!--JavaScript共用區-->	
<script src="web/js/common.js" type="text/javascript"></script>
    
<!-- 輪播 Swiper's CSS_Swiper 11.1.15 -->
<!-- <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"  type="text/css" /> -->
<link rel="stylesheet" href="web/js/swiper-master/css/swiper-bundle.min.css" type="text/css" />

<!-- 輪播 Swiper's JS_Swiper 11.1.15 -->
<!-- <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script> -->
<script src="web/js/swiper-master/js/swiper-bundle.min.js"></script>
  

<!--當卷軸到一定高度時，物件才會出現-->    	
<script type="text/javascript" src="web/js/wow/wow.min.js"></script>
<!-- Animate 4.1.1 -->
<link rel="stylesheet" type="text/css" href="web/js/animate/animate.css"/>
<!-- <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/> -->
<script type="text/javascript" src="web/js/wow/wow_example.js"></script>

<!--aos@3.0.0-beta.6每滑到該區域重複執行-->   
<link rel="stylesheet" type="text/css" href="web/js/aos/aos.css"/>  <!-- 為了弱掃留原始檔案 -->
<!-- <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" /> -->


<!-- InkDrops水墨按鍵效果css -->
<link rel="stylesheet" type="text/css" href="web/js/inkbtn/inkdrops.css"/>
<link rel="stylesheet" type="text/css" href="web/js/inkbtn/style_ink.css"/>


<!-- Noto Sans Traditional Chinese字體 -->
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">

<!-- Varela Round字體 -->
<link href="https://fonts.googleapis.com/css2?family=Varela+Round&display=swap" rel="stylesheet">

    <%-- SEO --%>
    <meta name="Robots" content="<%=SiteSetup.getText("seo.robots." + lang)%>" />
    <meta name="revisit-after" content="<%=SiteSetup.getText("seo.revisit_after." + lang)%> days" />
    <meta name="keywords" content="<%=SiteSetup.getText("seo.keywords." + lang)%>" />
    <meta name="copyright" content="<%=SiteSetup.getText("seo.copyright." + lang)%>" />
    <meta name="description" content="<%=SiteSetup.getText("seo.description." + lang)%>" />
    <%-- 追蹤碼 --%><%=SiteSetup.getText("seo.head_track." + lang)%>
    
    <%-- og 設定 --%>
	<%
	// Server name.	
	String servername = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
	if(request.getServerPort() == 80 || request.getServerPort() == 443) {
		servername = request.getScheme()+"://"+request.getServerName();
	}
	String localname = request.getScheme()+"://"+request.getLocalName()+":"+request.getLocalPort();
	String url = servername + request.getContextPath();
	%>
	<meta property="og:url" content="<%=request.getRequestURL()+(request.getQueryString()!=null&&!request.getQueryString().isEmpty()?"?"+request.getQueryString():"") %>" />
	<meta property="og:type" content="website" />
	<meta property="og:title" content="<%=app_webtitle %>" />
	<meta property="og:description" content="<%=SiteSetup.getText("seo.description."+lang) %>" />
	<meta property="og:image" content="<%=url+"/web/images/logo.png" %>" />
</head>

<body>
      	<%-- 追蹤碼 --%>
	<%=SiteSetup.getText("seo.body_track."+lang) %>  
    
    <div class="headertop" id="top"></div>
    
    <header class="headerArea">

        <!--版頭-->
        <div class="header">
    
            <div class="wrap">

                <!--手機menu按鍵-->
                <div id="menu_btn" class="menu_btn">
                    <span>
                    </span>
                    <span>
                    </span>
                    <span>
                    </span>
                </div>
                
                <!--logo-->
                <h1 class="logo">
                   <a href="home.jsp">
                        <img src="web/images/logo.svg" alt="logo_pic"  class=""/>
                        <!-- <img src="web/images/logo.svg"  class="pc"/>
                        <img src="web/images/logo2.svg" class="mobile"/> -->
                    </a>
                </h1>            
                
                <div class="headerRight">

                    <!-- 版頭右側_上方區塊 -->
                    <ul class="headerRight_topArea">
	                    <%if (!"".equals(SiteSetup.getText("web_ntou_official_url." + lang))) { %>
                        <!--靜宜大學-->
                        <li class="">
                            <a href="<%=SiteSetup.getText("web_ntou_official_url."+lang) %>" target="_blank">
                                靜宜首頁
                            </a>
                        </li>
                        <%} %>

                    </ul>

                    <!--主按鍵 navbar-->
                    <div class="navbar">
                        <!--靜宜概覽-->
                        <div class="nav">
                            <a href="web/about/about.jsp">
                                靜宜概覽
                            </a>
                        </div>
                        <!--最新消息-->
                        <div class="nav">
                            <a href="web/news/news.jsp">
                                最新消息
                            </a>
                        </div>
                        <!--募款專案-->
                        <div class="nav">                            
                            <div class="nav_title">
                                <a href="web/donate_project/donate_project.jsp">
                                    募款專案
                                </a>
                                <div class="navOpen_icon">
                                    <img src="web/images/navOpen_icon.svg">
                                </div>
                            </div>
                            <!--主按鍵展開-->
                            <%if(nav_donate_project_dms.size()>0){ %>
                            <div class="navOpen pc">
                                <div class="navOpenBg"> 
                                    <%for (int i = 0; i < nav_donate_project_dms.size(); i++) {
	                                	TableRecord nav_donate_project_dm = nav_donate_project_dms.get(i);
	                                %>                       
                                    <div class="navOpenList">
                                        <a href="web/donate_project/donate_project_in.jsp?dm_id=<%=nav_donate_project_dm.getString("dm_id")%>">
                                            <%=nav_donate_project_dm.getString("dm_title")%>
                                        </a>
                                    </div>
                                    <%} %>
                                </div>
                            </div>
                            <%} %>
                            <%if(nav_donate_project_dms.size()>0){ %>
                            <div class="navOpen mobile">
                                <div class="navOpenBg"> 
                                	<%for (int i = 0; i < nav_donate_project_dms.size(); i++) {
	                                	TableRecord nav_donate_project_dm = nav_donate_project_dms.get(i);
	                                %>                                
                                    <div class="navOpenList">
                                        <a href="web/donate_project/donate_project_in.jsp?dm_id=<%=nav_donate_project_dm.getString("dm_id")%>">
                                            <%=nav_donate_project_dm.getString("dm_title")%>
                                        </a>
                                    </div>
                                    <%} %>
                                </div>
                            </div> 
                            <%} %>
                        </div>
                        
                        <!--捐款指南-->
                        <div class="nav">                            
                            <div class="nav_title">
                                <a href="web/guide/guide.jsp">
                                    募款說明
                                </a>
                                <div class="navOpen_icon">
                                    <img src="web/images/navOpen_icon.svg">
                                </div>
                            </div>

                            <!--主按鍵展開-->
                            <div class="navOpen pc">
                                <div class="navOpenBg">                                
                                    <div class="navOpenList">
                                        <a href="web/guide/guide.jsp">
                                            捐款方式暨流程
                                        </a>
                                    </div>
                                    <div class="navOpenList">
                                        <a href="web/guide/guide_2.jsp">
                                            捐款抵稅相關辦法
                                        </a>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="navOpen mobile">
                                <div class="navOpenBg">                                
                                    <div class="navOpenList">
                                        <a href="web/guide/guide.jsp">
                                            捐款方式暨流程
                                        </a>
                                    </div>
                                    <div class="navOpenList">
                                        <a href="web/guide/guide_2.jsp">
                                            捐款抵稅相關辦法
                                        </a>
                                    </div>  
                                        
                                </div>
                            </div> 
                            
                        </div>
                    
                        <!--捐款芳名錄-->
                        <div class="nav">                            
                            <div class="nav_title">
                                <a href="web/directory/directory.jsp">
                                    捐款芳名錄
                                </a>
                                <div class="navOpen_icon">
                                    <img src="web/images/navOpen_icon.svg">
                                </div>
                            </div>

                            <!--主按鍵展開-->
                            <div class="navOpen pc">
                                <div class="navOpenBg">                                
                                    <div class="navOpenList">
                                        <a href="web/directory/directory.jsp">
                                            捐款明細
                                        </a>
                                    </div>
                                    <div class="navOpenList">
                                        <a href="web/directory/directory_download.jsp">
                                            捐贈報告
                                        </a>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="navOpen mobile">
                                <div class="navOpenBg">                                
                                    <div class="navOpenList">
                                        <a href="web/directory/directory.jsp">
                                            捐款明細
                                        </a>
                                    </div>
                                    <div class="navOpenList">
                                        <a href="web/directory/directory_download.jsp">
                                            捐贈報告
                                        </a>
                                    </div>  
                                        
                                </div>
                            </div> 
                            
                        </div>
                        <!--活動紀實-->
                        <div class="nav">
                            <a href="web/photo/photo.jsp">
                                活動紀實
                            </a>
                        </div>
                        <!--常見問題-->
                        <%if(qa_dms.size()>0){%>
                        <div class="nav">                            
                            <div class="nav_title">
                                <a href="web/qa/qa.jsp">
                                    常見問題
                                </a>
                                <div class="navOpen_icon">
                                    <img src="web/images/navOpen_icon.svg">
                                </div>
                            </div>
                            <!--主按鍵展開-->
                            <div class="navOpen pc">
                                <div class="navOpenBg">
                                	<%for(TableRecord qa_dm:qa_dms){ %>                                
                                    <div class="navOpenList">
                                        <a href="web/qa/qa.jsp?dm_id=<%=qa_dm.getString("dm_id") %>">
                                            <%=qa_dm.getString("dm_title") %>
                                        </a>
                                    </div>
                                    <%} %>
                                </div>
                            </div>
                            
                            <div class="navOpen mobile">
                                <div class="navOpenBg">                                
                                    <%for(TableRecord qa_dm:qa_dms){ %>                                
                                    <div class="navOpenList">
                                        <a href="web/qa/qa.jsp?dm_id=<%=qa_dm.getString("dm_id") %>">
                                            <%=qa_dm.getString("dm_title") %>
                                        </a>
                                    </div>
                                    <%} %>
                                </div>
                            </div> 
                            
                        </div>
                        <%} %>
                        <!--線上捐款-->
                        <!-- <div class="nav nav_donateNow">
                            <a href="web/donate/donate.jsp">
                                <div class="icon">
                                    <img src="web/images/donate_icon.svg">
                                </div>
                                線上捐款
                                
                                <span>Donate Now</span>
                                
                            </a>
                        </div> -->
                    
                        <!--捐款單下載-->
                        <%if(!"".equals(download_file.getString("cp_image"))) { %>
                        <div class="nav">
                            <a target="_blank" href="<%=app_fetchpath+"/donate_download/"+lang+"/"+download_file.getString("cp_image")%>">
                                捐款單下載
                            </a>
                        </div>
                        <%} %>
                        <!--活動捐款-->
                        <%if(activity_donates.size()>0){ %>
                        <div class="nav nav_donateNow">                            
                            <div class="nav_title">
                                <a href="javascript:void(0);" >
                                    活動捐款
                                </a>
                                <div class="navOpen_icon">
                                    <img src="web/images/navOpen_icon.svg">
                                </div>
                            </div>

                            <!--主按鍵展開-->
                            <div class="navOpen pc">
                                <div class="navOpenBg"> 
                                <%for(TableRecord activity_donate:activity_donates){ %>                               
                                    <div class="navOpenList">
                                        <a href="web/fundraiser/fundraiser.jsp?cp_id=<%=activity_donate.getString("cp_id") %>" target="_blank">
                                            <%=activity_donate.getString("cp_title") %>
                                        </a>
                                    </div>
                                <%} %>
                                </div>
                            </div>
                            
                            <div class="navOpen mobile">
                                <div class="navOpenBg">                                
                                    <%for(TableRecord activity_donate:activity_donates){ %>                               
                                    <div class="navOpenList">
                                        <a href="web/fundraiser/fundraiser.jsp?cp_id=<%=activity_donate.getString("cp_id") %>" target="_blank">
                                            <%=activity_donate.getString("cp_title") %>
                                        </a>
                                    </div>
                                	<%} %>
                                        
                                </div>
                            </div> 
                            
                        </div>
                        <%} %>
                    </div>

                </div>

                <!-- <div class="clearfloat">
                </div> -->
                
            </div>

        </div>    
    
    </header>
    
    <!--主內容區塊-->
    <main class="main indexMain ">
        
        <div class="indexBannerArea">

            <!--輪播--><!-- 只放Banner圖與效果，放下面 -->
            <%if (banner_aps.size() > 0) { %>
            <div class="banner banner_down">

                <div class="swiper-button-prev" role="button" aria-label="上一張輪播" aria-controls="swiper-wrapper-1426590ce514d65e" tabindex="28"></div>
                <div class="swiper-button-next" role="button" aria-label="下一張輪播" aria-controls="swiper-wrapper-1426590ce514d65e" tabindex="29"></div>

                <div id="particles-js"><canvas class="particles-js-canvas-el" width="1850" height="740" style="width: 100%; height: 100%;"></canvas></div>   
                
                <!-- Swiper -->
                <div class="swiper mySwiper swiper-container_down ">
                    <div class="swiper-wrapper" >
                    <%
//                     System.out.println(banner_aps.size());
	                        for (TableRecord banner : banner_aps) {
// 	                        	System.out.println("banner :"+banner.getString("ap_id"));
	                            String banner_url = "javascript:void(0)";
	                            String banner_target = banner.getString("ap_target");
	                            boolean isLink = false;
	                            if (!banner.getString("ap_desc").equals("") && !banner.getString("ap_url").equals("") && !"none".equals(banner_target)) {
	                                isLink = true;
	                            }
	                            
	                            if(!"none".equals(banner_target)) banner_url = banner.getString("ap_url");
                                else banner_target = "";
	                %>
                    <div class="swiper-slide ">
                            <div class="indexBannerList">
                            <%if (isLink) {%>
                                <a href="<%=banner_url %>" tabindex="25" target="<%=banner_target %>">
                            <%} %>

                                    <div class="pcBanner" style="background-image:url('<%=app_fetchpath+"/"+"banner"+"/"+lang+"/"+banner.getString("ap_image")%>');">                                    
                                        
<%-- 										<%if (isLink) {%> --%>
	                                    <div class="indexBannerIn">
	                                        <!--首頁banner列表標題-->
	                                        <h2 class="indexBanner_title">
	                                            <%=banner.getString("ap_desc")%>
	                                        </h2>
	
	                                        <!--首頁banner列表文字-->
	                                        <div class="indexBanner_remark">
	                                            <%=banner.getString("ap_content")%>
	                                        </div>
											 <%if (isLink) {%>
	                                        <!--首頁banner列表按鍵-->
	                                        <div class="btn">
	                                            <label><strong>了解更多</strong></label>
	                                        </div>
	                                        <%} %>
	                                    </div>
<%-- 	                                    <%}%>                                         --%>
                                    </div>



                                    <div class="mobileBanner" style="background-image:url('<%=app_fetchpath+"/"+"banner"+"/"+lang+"/"+banner.getString("ap_mobile")%>');">                                    
                                    
<%--                                         <%if (isLink) {%> --%>
	                                    <div class="indexBannerIn">
	                                        <!--首頁banner列表標題-->
	                                        <h2 class="indexBanner_title">
	                                            <%=banner.getString("ap_desc")%>
	                                        </h2>
	
	                                        <!--首頁banner列表文字-->
	                                        <div class="indexBanner_remark">
	                                            <%=banner.getString("ap_content")%>
	                                        </div>
	
	                                        <!--首頁banner列表按鍵-->
	                                        <%if (isLink) {%>
	                                        <div class="btn">
	                                            <label><strong>了解更多</strong></label>
	                                        </div>
	                                        <%} %>
	                                    </div>
<%-- 	                                    <%}%> --%>
                                    
                                    </div>
								<%if (isLink) {%>
                                </a>
								<%}%>

                            </div>
                        </div>
						<%} %>
                                                
                        </div>
                    <!-- <div class="swiper-button-prev"></div>
                    <div class="swiper-button-next"></div>
                    <div class="swiper-pagination"></div> -->                    
                <span class="swiper-notification" aria-live="assertive" aria-atomic="true"></span></div>

            </div>
			<%} %>
            <!-- Initialize Swiper -->
            <script>
                var swiper_down = new Swiper(".swiper-container_down", {
                    //輪播一次顯示幾張
                    slidesPerView: 1,
                    
                    //輪播位置啟始值為置中
                    centeredSlides: true,
                    
                    //自動輪播
                    // autoplay: {
                    //     delay: 5000,
                    //     disableOnInteraction: false,
                    // },
                    
                    //無限循環
                    loop: true,

                    //高度自適應
                    autoHeight: true,

                    speed: 1500,
                    
                    //視差效果
                    parallax : true,

                    //手動滑動
                    //allowTouchMove: true,  

                    // grabCursor: true,

                    //輪播點點顯示
                    // pagination: {
                    //     el: ".swiper-container_pc .swiper-pagination",
                    //     clickable: true,
                    // },
                    //左右按鍵點擊效果
                    navigation: {
                        nextEl: '.indexBannerArea .swiper-button-next',
                        prevEl: '.indexBannerArea .swiper-button-prev',
                    },
                    on: {
                        init: function () {
                        fixPaginationFocus();
                        },
                        slideChange: function () {
                        fixPaginationFocus();
                        },
                        paginationUpdate: function () {
                        fixPaginationFocus();
                        }
                    }

                });

                // 專門處理 pagination 可聚焦
                function fixPaginationFocus() {
                const bullets = document.querySelectorAll('.indexmain .banner .swiper-pagination .swiper-pagination-bullet');
                bullets.forEach((bullet, index) => {
                    bullet.setAttribute('tabindex', '0'); // 保證可以 Tab
                    bullet.setAttribute('role', 'button');
                    bullet.setAttribute('aria-label', `跳至第 ${index + 1} 張輪播`);
                });
                }
            </script>

            <script type="text/javascript" src="web/js/particles_master/particles.js"></script>
            <script type="text/javascript" src="web/js/particles_master/app.js"></script><!-- 速度1.5 -->

        </div>

        
            
        <%if(home_news.size()>0){ %>  
        <!-- 首頁最新消息區塊 -->
        <div class="index_NAbg" style="background-image: linear-gradient(to left, #ffffff00 0% , #ffffff6e 20% , #ffffffc7 50%, #ffffff 100%) , url(web/index/images/newbg.webp);">
            <div class="wrap">
                <!-- 首頁標題 -->
                <div class="index_tit">
                    <div class="index_tit_icon">
                        <!-- <i class="icon bi bi-megaphone"></i> -->
                    </div>                        
                    <h2>最新消息</h2>
                    
                </div>  
                
                <ul class="index_NAarea" id="index_NAarea">
                    
                    <%for(TableRecord home_new:home_news){
                    	System.out.println(home_new.getString("np_id"));
                    	String np_emitdate = home_new.getString("np_emitdate");
                    	String news_year = np_emitdate.split("/")[0];
                    	String news_month = np_emitdate.split("/")[1];
                    	String news_day = np_emitdate.split("/")[2];
                    	
                    	%>
                    <!-- 首頁_最新消息_列表 -->
                    <li>
                        <!-- 最新消息_張貼日期 -->
                        <div class="time">
                            <div class="year"><%=news_year %></div>
                            <div class="date"><%=news_month %>/<%=news_day %></div>                            
                        </div>
                        <!-- 最新消息_標題 -->
                        <h3 class="title">
                            <a href="web/news/news_in.jsp?np_id=<%=home_new.getString("np_id") %>">
                                <%=home_new.getString("np_title") %>
                            </a>
                        </h3>
                    </li>
                    <%} %>
                    <!-- 首頁_最新消息_列表 -->

                </ul>
                <!-- 首頁_button -->
                <div class="btn_area one"><!--如果只有一個按鍵時class內加one-->
                    <input type="button" value="查看更多" onclick="location='web/news/news.jsp'">
                    <div class="clearfloat">
                    </div>
                </div>
                
                
            </div>
                
            <script>
                // 1. 抓取所有新聞列表的 li
                var newsList = document.querySelectorAll('.index_NAarea li');

                // 2. 跑迴圈設定
                newsList.forEach(function(item, index) {
                    
                    // --- 動畫設定 ---
                    item.setAttribute('data-aos', 'fade-up');
                    item.setAttribute('data-aos-duration', '800'); // 動畫跑多久
                    item.setAttribute('data-aos-once', 'true');    // 只跑一次

                    // --- 關鍵設定：觸發時機 ---
                    
                    // 綁定錨點：讓所有 li 都聽命於 ul (整個區塊) 的位置
//                     item.setAttribute('data-aos-anchor', '#index_NAarea'); 
                    
                    // 修正這裡：改成 'top-center'
                    // 意思：當 #index_NAarea 的頂部 (top) 滑到視窗的正中間 (center) 時，才開始播動畫
//                     item.setAttribute('data-aos-anchor-placement', 'top-center'); 

                    // --- 順序延遲 (階梯效果) ---
                    var delay = index * 150; 
                    item.setAttribute('data-aos-delay', delay);
                }); 
            </script>
        </div>
		<%} %>

        

		<%if (donate_project_dms.size() > 0) { %>
        <!-- 首頁募款專案 -->
        <div class="indexDonateProjectBg">

            <div class="wrap">

                <!-- 首頁標題 -->
                <div class="index_tit">
                    <h2>募款專案</h2>
                </div>

                <!-- 首頁募款專案區 -->
                <ul class="indexDPArea" id="indexDPArea" 
                                        data-aos="fade-up" 
                                        data-aos-delay="4000" 
                                        data-aos-duration="2000" 
                                        data-aos-anchor="#indexDPArea"
                                        data-aos-anchor-placement="bottom" 
                                        data-aos-once="true"
                                        data-aos-easing="ease-in-sine">

                    <!-- 首頁募款專案列表 -->
                    <%
	                    String default_image = "web/donate_project/images/demo2.webp";
                    	
	                    %>
	                    <%for (int i = 0; i<donate_project_dms.size();i++) { 
	                    	TableRecord donate_project_dm = donate_project_dms.get(i);
	                    	
	                    	// 預設圖片有上傳但圖片不見，路徑寫法
	                    	String donate_project_dm_image = default_image;
	                    	String filePath = app_uploadpath+ "/" + "donate_category" + "/" + lang + "/" + donate_project_dm.getString("dm_image");
	                    	String filePath2 = app_fetchpath+ "/" + "donate_category" + "/" + lang + "/" + donate_project_dm.getString("dm_image");
	                    	File file = new File(filePath);
	                    
	                    	if(!donate_project_dm.getString("dm_image").equals(""))
	                    		if(file.exists() && !file.isDirectory()) donate_project_dm_image = filePath2;
	                    %>
                    <li class="">
                        <div class="indexDPlist">

                            <!-- 首頁募款專案圖片 -->
                            <div class="indexDPimg">
                                <a href="web/donate_project/donate_project.jsp?dm_id=<%=donate_project_dm.getString("dm_id")%>">
                                    <img src="<%=donate_project_dm_image %>"
	                                         alt="<%=donate_project_dm.getString("dm_title")%>"
	                                         title="<%=donate_project_dm.getString("dm_title")%>">
                                </a>
                            </div>
                            <div class="indexDP_indexBottom">
                                
                                <!-- 首頁募款專案標題 -->
                                <h3>
                                    <a href="web/donate_project/donate_project.jsp?dm_id=<%=donate_project_dm.getString("dm_id")%>">
	                                        <%=donate_project_dm.getString("dm_title") %>
	                                    </a>
                                </h3>
                            </div>
                        </div>
                    </li>
                    <%} %>

                </ul>

                <div class="btn_area one"><!--如果只有一個按鍵時class內加one-->
                    <input type="button" value="查看更多" onclick="location='web/donate_project/donate_project.jsp'" />
                    <div class="clearfloat">
                    </div>
                </div>

            </div>
            
            <!-- <div class="bg_wave">
                <img src="web/images/bg_wave.webp" alt="">
            </div> -->
            
        </div>
		<%} %>
        
        
    </main>  


    <!--版腳-->
	<footer class="footer">
        <div class="CommunityBtn_area" style="bottom: 190px;">

            <!--右側浮動捐款-->
            <div class="donateBtn">
				<a target="_blank" href="web/donate/donate.jsp">
                    <img src="web/images/donate-01.webp" alt="donate" title="donate">
                </a>
                <div class="tab_description">
                    線上捐款
                </div>
            </div>
            <%if(!"".equals(download_file.getString("cp_image"))) { %>
            <div class="donateBtn">
				<a target="_blank" href="<%=app_fetchpath+"/donate_download/"+lang+"/"+download_file.getString("cp_image")%>">
                    <img src="web/images/donate-02.webp" alt="download" title="download">
                </a>
                <div class="tab_description">
                    捐款單下載
                </div>
            </div>
            <%} %>
        </div>
    	<!--浮動top鍵--><!--js在common.js內-->
        <div class="topBtn">
            <a href="#top">
            	<span>TOP</span>
            </a>
        </div>
    	
        
        <!--版腳內容區塊-->
        <div class="footer_content">
        	<div class="wrap">  

                <div class="footer_navbar">

                    <!--右側導覽列-->
                    <%if (!"".equals(web_alumni_center_url)) { %>
                    <div class="fR_nav fR_nav2">                    
                        <span>
                            <a href="<%=web_alumni_center_url %>" target="_blank">
                            	校友服務與社會連結中心
                            </a>
                        </span>
                    </div>
                    <%} %>
                    <%if (!"".equals(campus_url)) { %>
                    <div class="fR_nav fR_nav2">                    
                        <span>
                            <a href="<%=campus_url %>" target="_blank">
                            	宗教輔導室
                            </a>
                        </span>
                    </div>
                    <%} %>
                    <%if (!"".equals(library_url)) { %>
                    <div class="fR_nav fR_nav2">                    
                        <span>
                            <a href="<%=library_url %>" target="_blank">
                            	蓋夏圖書館
                            </a>
                        </span>
                    </div>
                    <%} %>
                    <%if (!"".equals(sport_url)) { %>
                    <div class="fR_nav fR_nav2">                    
                        <span>
                            <a href="<%=sport_url %>" target="_blank">
                            	體育室
                            </a>
                        </span>
                    </div>    
					<%} %>
                    <div class="clearfloat">
                    </div>

                </div>

                

                <div class="footer_bottom">
                    <div class="footer_contentIn"> 

                        


                        
                        <div class="footer_contentItem">        
                            <%if (!"".equals(copr_company)) { %>
		                    <h3><%=copr_company %>
		                    </h3>
		                    <%} %>
                            <%if (!"".equals(copr_address)) { %>
		                    <h3>
		                        <i class="bi bi-geo-alt-fill"></i>
		                        <a href="<%=copr_address_link %>" target="_blank">
		                            地址：<%=copr_address %>
		                        </a>
		                    </h3>
		                    <%} %>                  
                            <%if (!"".equals(copr_email)) { %>
		                    <h3>
		                        <i class="bi bi-envelope-fill"></i>
		                        <a href="mailto:<%=copr_email %>" target="_blank">
		                            E-Mail：<%=copr_email %>
		                        </a>
		                    </h3>
		                    <%} %>
                            <%if (!"".equals(copr_phone)) { %>
		                    <h3>
		                        <i class="bi bi-chat-dots-fill"></i>
		                        <a href="tel:<%=copr_phone %>">電話：<%=copr_phone %>
		                        </a>
		                    </h3>
		                    <%} %>
		                    <%if (!"".equals(copr_fax)) { %>
		                    <h3>
		                        <i class="bi bi-printer-fill"></i>
		                        <a href="tel:<%=copr_fax %>">傳真：<%=copr_fax %>
		                        </a>
		                    </h3>
		                    <%} %>
	                        </div>  

                        
                    </div>

                    <!--版權宣告-->
                    <div class="copyright">
                        <!-- <div class="wrap"> -->
                            © <%=DateTimeTool.getYear() + " "%> <a href="https://www.geneinfo.com.tw" target="_blank">Greatest Idea Strategy Co.,Ltd</a> All rights reserved.
                    </div>

                    <div class="sns_linkBg">
                    		<%if (!"".equals(fb_url)) { %>
                            <div class="list fb_link">
                                <a href="<%=fb_url %>" target="_blank">
                                    <img src="web/images/fb_icon.svg" alt="facebook" title="facebook">
                                </a>
                            </div>
                            <%} %>
                           
                            <%if (!"".equals(ig_url)) { %>
                            <div class="list yt_link">
                                <a href="<%=ig_url %>" target="_blank">
                                    <img src="web/images/ig_icon.svg" alt="instagram" title="instagram">
                                </a>
                            </div>
                            <%} %>
                            <%if (!"".equals(td_url)) { %>
                            <div class="list yt_link">
                                <a href="<%=td_url %>" target="_blank">
                                    <img src="web/images/threads_icon.svg" alt="threads" title="threads">
                                </a>
                            </div>
                        	<%} %>
                        	
                        	 <%if (!"".equals(yt_url)) { %>
                            <div class="list yt_link">
                                <a href="<%=yt_url %>" target="_blank">
                                    <img src="web/images/yt_icon.svg" alt="youtube" title="youtube">
                                </a>
                            </div>
                            <%} %>
                    </div>
                </div>
                
                
            </div>
        </div>
        
    </footer>
    

    <!--每滑到該區域重複執行-->   
    <script type="text/javascript" src="web/js/aos/aos.js"></script> 
    <script>
      AOS.init();
    </script>   

    <!-- InkDrops水墨按鍵效果js -->
    <script type="text/javascript" src="web/js/inkbtn/ink.js"></script>
    <!-- https://github.com/akhilarjun/InkDrops -->

    <!-- Ink Transition Effect水墨過度 -->
    <!-- <script type="text/javascript" src="web/js/ink_transition_effect/js/ink_transition_effec_main.js"></script>
    <script type="text/javascript" src="web/js/ink_transition_effect/js/modernizr.js"></script> -->


</body>
</html>
