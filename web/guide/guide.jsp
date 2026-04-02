<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/web/include/words.jsp"%>
<% 
	// 參數設定
	String page_code 	= "guide", 				  			// 頁面識別碼
		   banner_code	= "guide";  						
	
	// 捐款指南類別列表
	Vector<TableRecord> download_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category=?"
			, new Object[]{"download_category", lang, ""}, "dm_showseq ASC, dm_createdate DESC");
		   
	// 列表
	Vector<TableRecord> cps = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=? and cp_display=?"
			, new Object[]{page_code, lang, "Y"}, "cp_showseq ASC, cp_createdate DESC");
		   
	
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
	
	<link rel="stylesheet" href="../css/style_nav/style_guide/style_guide.css">
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
                        
                        <span>募款說明</span>   
                        
                        <i class="material-icons">navigate_next</i>
                        
                        <span>捐款方式暨流程</span> 
                        
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
                            募款說明
                            <!-- <span>Recommend</span> -->
                        </div>
                        
                        
                        <!--左側選單列表-->	
                        <div class="leftListArea">
                            
                            <div class="leftList active"><!-- 當前模式 class加上active -->                      
                                <a href="../guide/guide.jsp">
                                    <!--功能名稱-->
                                    <div class="leftList_title">
                                        捐款方式暨流程
                                    </div>
                                </a>
                            </div>
                            <div class="leftList">
                                 <a href="../guide/guide_2.jsp">
                                     <!--功能名稱-->
                                   	<div class="leftList_title">
                                   	捐款抵稅相關辦法
                                   	</div>
                                 </a>
                            </div>
                            <div class="leftList">
                                <a href="../qa/qa_download.jsp">                                    
                                    <!--功能名稱-->
                                    <div class="leftList_title">
                                        表單下載
                                    </div>                                    
                                </a>                                
                            </div>
                            

                        </div>
                        
                    </div>
                    
                    <!--右側-->
                    <div class="right">
                        
                        <!--右側標題-->
                        <div class="right_title">
                            <h2>捐款方式說明</h2>
                            <span class="enTit">How to donate</span><!-- modify by david 20220914  -->
                        </div>
                        
                        <div class="right_contentBg">
            
                            <!-- 捐款方式ICON -->
                            <ul class="cashFlowWay_icon">       
                            	
                            	<%
                            	for(int i=0;i<cps.size();i++){
                            		TableRecord cp = cps.get(i);
                            	%>                         
                                <li id="cashFlowWay_icon<%=i+1 %>" 
                                    data-aos="fade-right" 
                                    data-aos-delay="<%=(i+1)*400 %>" 
                                    data-aos-duration="600" 
                                    data-aos-anchor="#cashFlowWay_icon<%=i+1 %>" 
                                    data-aos-anchor-placement="bottom" 
                                    data-aos-once="true"
                                    data-aos-easing="ease-in-sine">
                                    <a href="#cash_flow<%=i+1%>">
                                        <img src="<%=app_fetchpath+"/"+page_code+"/"+lang+"/"+cp.getString("cp_image")%>" alt="<%=cp.getString("cp_title")%>" title="<%=cp.getString("cp_title")%>">
                                        <h3><%=cp.getString("cp_title") %></h3> 
                                        <h3><%=cp.getString("cp_subtitle") %></h3>                                        
                                    </a>
                                </li>
                                <%} %>
                                
                            </ul>
                            
                            <!-- 捐款方式說明文字區 -->
                            <ul class="cashFlowWay_guide">

                            	<%
                            	for(int i=0;i<cps.size();i++){
                            		TableRecord cp = cps.get(i);
                            	%>  
                                <!-- 線上刷卡 -->
                                <div id="cash_flow<%=i+1%>"></div>
                                <li class="cashFlowWay cfg<%=i+1%>">
                                    <!--右側標題-->
                                    <div class="right_title3">
                                        <span><img src="<%=app_fetchpath+"/"+page_code+"/"+lang+"/"+cp.getString("cp_mobile")%>" alt="<%=cp.getString("cp_title")%>" title="<%=cp.getString("cp_title")%>"></span>
                                        <h2><%=cp.getString("cp_title") %></h2><h2><%=cp.getString("cp_subtitle") %></h2>
                                    </div>

                                    <!--網編區塊-->
                                    <section class="text_area">
                                    	<%=cp.getString("cp_content") %>
                                    </section>

                                </li>
                                <%} %>

                            </ul>


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