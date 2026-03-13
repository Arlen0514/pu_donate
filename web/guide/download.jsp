<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/web/include/words.jsp"%>
<% 
	// 參數設定
	String page_code 	= "download", 				  			// 頁面識別碼
		   banner_code	= "guide",								// banner識別碼
		   bannerImg 	= "../images/inbanner.webp";  			// 內頁banner預設圖
	
	
	// 類別列表
	Vector<TableRecord> guide_download_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category=?"
			, new Object[]{"download_category", lang, ""}, "dm_showseq ASC, dm_createdate DESC");
	
	
	// 內頁banner
	TableRecord inbanner_ap = app_sm.select(tblap,"ap_code=? and ap_lang=? and ap_category=?"
			, new Object[]{"sub_banner", lang, banner_code});
	if(!"".equals(inbanner_ap.getString("ap_image"))) {
		bannerImg = app_fetchpath+"/sub_banner/"+lang+"/"+inbanner_ap.getString("ap_image");
	}		
	
%>
<html xmlns="http://www.w3.org/1999/xhtml" lang="zh-TW">
<head>
	<%@include file="../include/head.jsp" %>
	
	<title><%=app_webtitle%></title>
	
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
	
	<link rel="stylesheet" href="../css/style_nav/style_guide/style_guide_form.css">
</head>
<body class="body_in">
	<%-- 追蹤碼 --%>
	<%=SiteSetup.getText("seo.body_track." + lang)%>
	
	<%@include file="../include/top_menu.jsp" %>
	
    <!--主內容區塊-->
    <main class="main inmain">
        
        <!--內頁banner-->
        <div class="inbanner" style="background-image:url(<%=bannerImg%>);">
        </div>
        
        <!--內頁內容_上方區塊-->
        <div class="pageContent_topArea">
        	<div class="wrap">     
               
            	<!--麵包屑-->
                <div class="crumb_bg">
                    <div class="crumb_area">
                    
                        <i class="material-icons">home</i>
                        
                        <span>
                            <a href="../../home.jsp">
                                首頁
                            </a>
                        </span> 
                        
                        <i class="material-icons">navigate_next</i>
						
						<!-- InstanceBeginEditable name="crumb" -->
                        
                        <span>捐款指南</span>   
                        
                        <i class="material-icons">navigate_next</i>
                        
                        <span>表單下載</span> 
                        
						<!-- InstanceEndEditable -->
        
                    </div>
                </div>
                
        		<!--<div class="clearfloat">
                </div>-->
            </div>    
        </div>                        
                        
                        
         <!--首頁內容區塊-->
        <div class="pageContent">
		
		<!-- InstanceBeginEditable name="pageContent" -->
        
            <div class="wrap">
                
                <div class="page">
                    
                    <!--左側-->
                    <div class="left">
                    
                        <!--左側表單名稱-->
                        <div class="left_title">
                            捐款指南
                            <!-- <span>Recommend</span> -->
                        </div>
                        
                        <!--左側選單列表-->	
                        <div class="leftListArea">
                            
                            <div class="leftList">                        
                                <a href="../guide/guide.jsp">
                                    <!--功能名稱-->
                                    <div class="leftList_title">
                                        捐款方式說明
                                    </div>
                                </a>
                            </div>
                            
                            <div class="leftList">
                                <a href="../guide/law.jsp">                                    
                                    <!--功能名稱-->
                                    <div class="leftList_title">
                                        法令規章
                                    </div>                                    
                                </a>                                
                            </div>
                            <div class="leftList active">
                                <a href="../guide/download.jsp">                                    
                                    <!--功能名稱-->
                                    <div class="leftList_title">
                                    	表單下載
                                    </div>                                    
                                </a>                                
                            </div>

                            <div class="leftList">
                                <a href="../guide/qa.jsp">                                    
                                    <!--功能名稱-->
                                    <div class="leftList_title">
                                        Q&A
                                    </div>                                    
                                </a>                                
                            </div>

                        </div>
                        
                    </div>
                    
                    <!--右側-->
                    <div class="right">
                        
                        <!--右側標題-->
                        <div class="right_title">
                            <h2>表單下載</h2>
                            <span class="enTit">Download</span>
                        </div>
                        
                        <div class="right_contentBg">
            
                            <!--下載列表-->
                            <div class="guide_download_bg">

								<%for(int i = 0; i<guide_download_dms.size();i++){ 
									TableRecord dm = guide_download_dms.get(i);
									Vector<TableRecord> fds = app_sm.selectAll(tblfd, "fd_code=? and fd_lang=? and fd_category=?"
											, new Object[]{page_code, lang, dm.getString("dm_id")}, "fd_showseq ASC, fd_createdate DESC");
									
									if(fds.size()==0) continue;
								%>
                                <div class="guide_downloadArea">

                                    <!--右側標題3-->
                                    <div class="right_title4">
                                        <i class="bi bi-file-text-fill"></i>
                                        <h2><%=dm.getString("dm_title") %></h2>
                                    </div>
    						
                                    <!--驅動下載列表-->
                                    <div class="downloadArea">
    
                                        <!--驅動下載列表_清單-->
                                        <%for(TableRecord fd : fds){ %>
                                        <div class="dLA_list">
                                            <div class="dLA_list_in">
    
                                                <!--驅動下載列表_清單_左側-->
                                                <div class="dLAL_left">
                                                    <!--驅動下載_標題-->
                                                    <div class="dLALL_tit">
                                                        <%=fd.getString("fd_title") %>
                                                    </div>
    
                                                    <!--驅動下載_內容-->
                                                    <div class="dLALL_text">
                                                        <%=fd.getString("fd_createdate").substring(0, 10).replace("/", ".") %>
                                                    </div>
                                                </div>
    
                                                <!--驅動下載_按鈕-->
                                                <div class="download_btn">
                                                    <a target="_blank" href="<%=app_fetchpath+"/"+page_code+"/"+lang+"/"+fd.getString("fd_file") %>" class="inkMe" ink-color="bgBlue" multiple-ink=true download>
                                                        下載
                                                    </a>
                                                </div>
    
                                            </div>
                                        </div>
                                        <%} %>
                                        
                                    </div>
    
                                </div>
								<%} %>
                                
                            </div>

        
                        </div>
                        
                    </div>
                
                </div>
                
            </div>  
		
		<!-- InstanceEndEditable -->
        	
      	</div> 
        
    </main>   

	<%@include file="../include/copyright.jsp" %>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>