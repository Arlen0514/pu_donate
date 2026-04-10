<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

// 募款專案類別
Vector<TableRecord> nav_donate_project_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category=?",
		new Object[]{ "donate_category", lang , ""} ,"dm_showseq ASC, dm_createdate DESC");

// 捐款指南類別
Vector<TableRecord> nav_download_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category=?",
		new Object[]{ "download_category", lang , ""} ,"dm_showseq ASC, dm_createdate DESC");

//系所類別
Vector<TableRecord> department_category_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category=? ", 
		new Object[] { "department_category", lang, "" }, "dm_showseq ASC, dm_createdate DESC");


	//常見問題類別
	Vector<TableRecord> qa_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? ",
          new Object[]{"qa2_category", lang}, "dm_showseq ASC, dm_createdate DESC");
	//捐款單下載檔案
	TableRecord download_file = app_sm.select(tblcp, "cp_code = ? AND cp_lang = ?", new Object[]{"donate_download",lang});
	//活動捐款項目
	Vector<TableRecord> activity_donates = app_sm.selectAll(tblcp, "cp_code = ? AND cp_lang = ? AND cp_emitdate <= ? AND cp_restdate >= ?", new Object[] { "activity_donate", lang, app_today, app_today }, "cp_showseq ASC , " + "cp_emitdate DESC");
	//最新消息
	Vector<TableRecord> home_news = app_sm.selectAll(tblnp, "np_code = ? AND np_lang = ? AND np_emitdate <= ? AND np_restdate >= ?", new Object[] { "news", lang, app_today, app_today }, "np_showseq ASC , " + "np_emitdate DESC limit 5");


	//banner預設圖
	String bannerImg = "../images/inbanner.webp";
	//內頁banner
	TableRecord ap_banner = app_sm.select(tblap,"ap_code=? and ap_lang=? and ap_category=?", new Object[]{"sub_banner", lang, page_code});
	if(!"".equals(ap_banner.getString("ap_image"))) {
		bannerImg = app_fetchpath+"/sub_banner/"+lang+"/"+ap_banner.getString("ap_image");
	}
	
	String ap_banner_alt = ap_banner.getString("ap_alt");






%>
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
                   <a href="../../home.jsp">
                        <img src="../images/logo.svg" alt="logo_pic"  class=""/>
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
                        <!--校友中心-->
                        <!-- <li class="">
                            <a href="#" target="_blank">
                                校友中心
                            </a>
                        </li> -->

                        <!--捐款單下載-->
                        <!-- <li class="">
                            <a href="web/annual_report/annual_report.jsp">
                                捐款單下載
                            </a>
                        </li> -->

                    </ul>

                    <!--主按鍵 navbar-->
                    <div class="navbar">
                        <!--靜宜概覽-->
                        <div class="nav">
                            <a href="../about/about.jsp">
                                靜宜概覽
                            </a>
                        </div>
                        <!--最新消息-->
                        <div class="nav">
                            <a href="../news/news.jsp">
                                最新消息
                            </a>
                        </div>
                        <!--募款專案-->
                        <div class="nav">                            
                            <div class="nav_title">
                                <a href="../donate_project/donate_project.jsp">
                                    募款專案
                                </a>
                                <div class="navOpen_icon">
                                    <img src="../images/navOpen_icon.svg">
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
                                        <a href="../donate_project/donate_project_in.jsp?dm_id=<%=nav_donate_project_dm.getString("dm_id")%>">
                                            <%=nav_donate_project_dm.getString("dm_title")%>
                                        </a>
                                    </div>
                                 <%} %>   
                                </div>
                            </div>
                            
                            <div class="navOpen mobile">
                                <div class="navOpenBg">                                
                                    <%for (int i = 0; i < nav_donate_project_dms.size(); i++) {
	                                	TableRecord nav_donate_project_dm = nav_donate_project_dms.get(i);
	                                %>                                
                                    <div class="navOpenList">
                                        <a href="../donate_project/donate_project_in.jsp?dm_id=<%=nav_donate_project_dm.getString("dm_id")%>">
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
                                <a href="../guide/guide.jsp">
                                    募款說明
                                </a>
                                <div class="navOpen_icon">
                                    <img src="../images/navOpen_icon.svg">
                                </div>
                            </div>

                            <!--主按鍵展開-->
                            <div class="navOpen pc">
                                <div class="navOpenBg">                                
                                    <div class="navOpenList">
                                        <a href="../guide/guide.jsp">
                                            捐款方式暨流程
                                        </a>
                                    </div>
                                    <div class="navOpenList">
                                        <a href="../guide/guide_2.jsp">
                                            捐款抵稅相關辦法
                                        </a>
                                    </div>
                                    <div class="navOpenList">
                                        <a href="../guide/qa_download.jsp">
                                            表單下載
                                        </a>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="navOpen mobile">
                                <div class="navOpenBg">                                
                                    <div class="navOpenList">
                                        <a href="../guide/guide.jsp">
                                            捐款方式暨流程
                                        </a>
                                    </div>
                                    <div class="navOpenList">
                                        <a href="../guide/guide_2.jsp">
                                            捐款抵稅相關辦法
                                        </a>
                                    </div>  
                                    <div class="navOpenList">
                                        <a href="../guide/qa_download.jsp">
                                            表單下載
                                        </a>
                                    </div>
                                        
                                </div>
                            </div> 
                            
                        </div>
                    
                        <!--捐款芳名錄-->
                        <div class="nav">                            
                            <div class="nav_title">
                                <a href="../directory/directory.jsp">
                                    捐款芳名錄
                                </a>
                                <div class="navOpen_icon">
                                    <img src="../images/navOpen_icon.svg">
                                </div>
                            </div>

                            <!--主按鍵展開-->
                            <div class="navOpen pc">
                                <div class="navOpenBg">                                
                                    <div class="navOpenList">
                                        <a href="../directory/directory.jsp">
                                            捐款明細
                                        </a>
                                    </div>
                                    <div class="navOpenList">
                                        <a href="../directory/directory_download.jsp">
                                            捐贈報告
                                        </a>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="navOpen mobile">
                                <div class="navOpenBg">                                
                                    <div class="navOpenList">
                                        <a href="../directory/directory.jsp">
                                            捐款明細
                                        </a>
                                    </div>
                                    <div class="navOpenList">
                                        <a href="../directory/directory_download.jsp">
                                            捐贈報告
                                        </a>
                                    </div>
                                        
                                </div>
                            </div> 
                            
                        </div>
                        <!--活動紀實-->
                        <div class="nav">
                            <a href="../photo/photo.jsp">
                                活動紀實
                            </a>
                        </div>
                        <!--常見問題-->
                        <%
                        if(qa_dms.size()>0){ 
                        %>
                        <div class="nav">                            
                            <div class="nav_title">
                                <a href="../qa/qa.jsp">
                                    常見問題
                                </a>
                                <div class="navOpen_icon">
                                    <img src="../images/navOpen_icon.svg">
                                </div>
                            </div>

                            <!--主按鍵展開-->
                            <div class="navOpen pc">
                                <div class="navOpenBg">                                
                                    <%for(TableRecord qa_dm:qa_dms){ %>                                
                                    <div class="navOpenList">
                                        <a href="../qa/qa.jsp?dm_id=<%=qa_dm.getString("dm_id") %>">
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
                                        <a href="../qa/qa.jsp?dm_id=<%=qa_dm.getString("dm_id") %>">
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
                                <a href="javascript:void(0);">
                                    活動捐款
                                </a>
                                <div class="navOpen_icon">
                                    <img src="../images/navOpen_icon.svg">
                                </div>
                            </div>

                            <!--主按鍵展開-->
                            <div class="navOpen pc">
                                <div class="navOpenBg">                                
                                    <%for(TableRecord activity_donate:activity_donates){ %>                               
                                    <div class="navOpenList">
                                        <a href="../fundraiser/fundraiser.jsp?cp_id=<%=activity_donate.getString("cp_id") %>" target="_blank">
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
                                        <a href="../fundraiser/fundraiser.jsp?cp_id=<%=activity_donate.getString("cp_id") %>" target="_blank">
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