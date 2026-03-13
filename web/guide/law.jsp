<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/web/include/words.jsp"%>
<% 
	// 參數設定
	String page_code 	= "law", 				  				// 頁面識別碼
		   banner_code	= "guide";								// banner識別碼
	int    page_items 	= 10;									// 預設分頁每頁筆數
	
	
	// 列表
	Vector<TableRecord> fds = app_sm.selectAll(tblfd, "fd_code=? and fd_lang=? "
			, new Object[]{page_code, lang}, "fd_showseq ASC, fd_createdate DESC");
	
	
	// 設定資料分頁每頁筆數
	page_items = "N".equals(SiteSetup.getValue("ss.pageno").trim()) ? 9999 : page_items;	   														// 預設列表分頁筆數設定
	app_dp = new DataPager(fds, page_items);
	fds = app_dp.getPageContent(pageno);
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
	
	<link rel="stylesheet" href="../css/style_nav/style_guide/style_download.css">
	
	<%-- 分頁處理 --%>
	<%@include file="/WEB-INF/jspf/mis/pagerscript.jspf"%>
</head>
<body class="body_in">
	<%-- 追蹤碼 --%>
	<%=SiteSetup.getText("seo.body_track." + lang)%>
	
	<%@include file="../include/top_menu.jsp" %>
	
    <!--主內容區塊-->
    <main class="main inmain">
        
        <!--內頁banner-->
       <div class="inbanner" style="background-image:url('<%=bannerImg%>');"   
        title="<%=ap_banner_alt%>">
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
                        
                        <span>法令規章</span> 
                        
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
                            
                            <div class="leftList active">
                                <a href="../guide/law.jsp">                                    
                                    <!--功能名稱-->
                                    <div class="leftList_title">
                                        法令規章
                                    </div>                                    
                                </a>                                
                            </div>
                            <div class="leftList">
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
                            <h2>法令規章</h2>
                            <span class="enTit">Law</span><!-- modify by david 20220914  -->
                        </div>
                        
                        <div class="right_contentBg">
            
                            <!--下載列表-->
                            <div class="downloadArea">

								<%for(TableRecord fd:fds){ %>
                                <!--下載列表_清單-->
                                <div class="dLA_list">
                                    <div class="dLA_list_in">

                                        <!--下載列表_清單_左側-->
                                        <div class="dLAL_left">
                                            <!--下載_標題-->
                                            <div class="dLALL_tit">
                                                <%=fd.getString("fd_title") %>
                                            </div>

                                            <!--下載_內容-->
                                            <div class="dLALL_text">
                                                <%=fd.getString("fd_createdate").substring(0,10).replace("/", ".") %>
                                            </div>
                                        </div>

                                        <!--下載_按鈕-->
                                        <div class="download_btn">
                                            <a target="_blank" href="<%=app_fetchpath+"/"+page_code+"/"+lang+"/"+fd.getString("fd_file") %>" class="inkMe" ink-color="bgBlue" multiple-ink=true download>
                                                下載
                                            </a>
                                        </div>

                                        <!-- <div class="clearfloat">
                                        </div> -->
                                    </div>
                                </div>
                                <%} %>
                                
                            </div>

                            <!--頁數列區塊-->
				            <div class="number_pageArea">
				            	<!-- 分頁 -->
								<%@include file="/WEB-INF/jspf/web/rwd_pager2.jspf"%>
								<form name="pageform" id="pageform" method="post" action="<%=request.getRequestURI()%>">
									<input type="hidden" name="npage" id="npage" value="<%=pageno%>" />
								</form>
								<!-- 分頁-END -->
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