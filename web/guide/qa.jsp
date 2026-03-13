<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="javax.websocket.MessageHandler.Whole"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/web/include/words.jsp"%>
<% 
	// 參數設定
	String page_code 	= "qa", 				  				// 頁面識別碼
		   banner_code	= "guide";								// banner識別碼
	int    page_items 	= 10;									// 預設分頁每頁筆數
	
	// 捐款指南類別列表
	Vector<TableRecord> download_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category=?"
			, new Object[]{"download_category", lang, ""}, "dm_showseq ASC, dm_createdate DESC");
	
	// 列表
	Vector<TableRecord> cps = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=? and cp_category=?"
			, new Object[]{page_code, lang, ""}, "cp_showseq ASC, cp_createdate DESC");
	
	
	// 設定資料分頁每頁筆數
	page_items = "N".equals(SiteSetup.getValue("ss.pageno").trim()) ? 9999 : page_items;	   														// 預設列表分頁筆數設定
	app_dp = new DataPager(cps, page_items);
	cps = app_dp.getPageContent(pageno);
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
	
	<link rel="stylesheet" href="../css/style_nav/style_guide/style_qa.css">
	
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
                        
                        <span>Q&A</span> 
                        
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
                            
                            <div class="leftList "><!-- 當前模式 class加上active -->                      
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
                            <div class="leftList">
                                <a href="../guide/download.jsp">                                    
                                    <!--功能名稱-->
                                    <div class="leftList_title">
                                    	表單下載
                                    </div>                                    
                                </a>                                
                            </div>

                            <div class="leftList active">
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
                            <h2>Q&A</h2>
                        </div>
                        
                        <div class="right_contentBg">
            

                            <!--QA收合-->
                            <script type="text/javascript">
                                $(function(){
                                    $(".qa_list.active").children(".qaL_text").show();
                                    
                                    $(".qa_list").children(".qaL_tit").click(function(e) {
                                        $(".qa_list").children(".qaL_tit").not(this).parent(".qa_list").removeClass("active");
                                        $(this).parent(".qa_list").toggleClass("active");
                                        
                                        $(".qa_list").children(".qaL_tit").not(this).siblings(".qaL_text").slideUp();
                                        $(this).next(".qaL_text").slideToggle();
                                    });
                                })
                            </script> 

                            <!--常見問題列表-->
                            <div class="qa_list_area">
                                
                                <%
                                for(int i=0;i<cps.size();i++){ 
                                	TableRecord cp = cps.get(i);
                                %>
                                <div class="qa_list <%=i==0?"active":""%>">
                                    
                                    <div class="qaL_tit">
                                    	<%=cp.getString("cp_title") %>
                                    </div>
                                    
                                    <div class="qaL_text">
                                    	<%=cp.getString("cp_content") %>
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