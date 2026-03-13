<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/web/include/words.jsp"%>
<% 
	// 參數設定
	String page_code 	= "department", 				  		// 頁面識別碼
		   banner_code	= "donate_project";						// banner識別碼
	int    page_items 	= 12;									// 預設分頁每頁筆數
			

    //院系募款
    TableRecord department_index = app_sm.select(tbldm, "dm_code=? and dm_lang=? and dm_category=?",
            new Object[]{"department_index", lang, ""}, "dm_showseq ASC, dm_createdate DESC");
    
    Vector<TableRecord> dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category = '' ", new Object[] { page_code+"_category", lang }, "dm_showseq ASC , " + "dm_createdate DESC");
	
    // 分頁
	page_items = "N".equals(SiteSetup.getValue("ss.pageno").trim()) ? 9999 : page_items;	   														// 預設列表分頁筆數設定
	app_dp = new DataPager(dms, page_items);
	dms = app_dp.getPageContent(pageno);
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
	
	<link rel="stylesheet" type="text/css" href="../css/style_nav/style_donate_project/style_dept_fund.css"/>
	
	<%@include file="/WEB-INF/jspf/mis/pagerscript.jspf"%>
</head>
<body class="body_in">
	<%-- 追蹤碼 --%>
	<%=SiteSetup.getText("seo.body_track." + lang)%>
	
	<%@include file="../include/top_menu.jsp" %>
    
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
                        
                        <span>募款專案</span> 
                        
                        <i class="material-icons">navigate_next</i>
                        
                        <span>院系募款</span>
                        
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
                    
                    <!--右側-->
                    <div class="right no_left"><!-- 無左側選單 -->
                        
                        <!--右側標題-->
                        <div class="right_title">
                            <h2>院系募款</h2>
                            <span class="enTit">Give To Colleges</span>
                        </div>
                        
                        <div class="right_contentBg">
            
                            <!-- 內頁募款專案區_第二層 -->
                            <ul class="dept_fund_area">
                            	
                            	<%for(TableRecord dm : dms){ %>
                                <!-- 首頁募款專案列表 -->
                                <li class="">
                                    <div class="dept_fund_box">
                                        <a href="dept_fund_in.jsp?dm_id=<%=dm.getString("dm_id")%>">
                                            <div class="dept_fund_img">
                                                <img src="<%=app_fetchpath+"/"+"department_category"+"/"+lang+"/"+dm.getString("dm_image")%>" alt="pic" loading="lazy">
                                            </div>
                                            <strong><%=dm.getString("dm_title")%></strong>
                                        </a>
                                    </div>
                                </li>
                                <%} %>
                            </ul>
                            
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