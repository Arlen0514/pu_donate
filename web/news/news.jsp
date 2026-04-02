<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/config.jspf" %>
<%@ include file="/WEB-INF/jspf/csrf_token.jspf" %>
<%

String page_code = "news";
String code = "news";
Vector<TableRecord> nps = app_sm.selectAll(tblnp, "np_code=? and np_lang=? and np_emitdate <= ?  and np_restdate >= ? ", new Object[] { "news",lang ,app_today,app_today}, "np_emitdate DESC , np_showseq ASC, np_createdate DESC ");
//換頁
int page_items=10;
app_dp = new DataPager(nps,page_items);    							//設定資料分頁每頁筆數
nps = app_dp.getPageContent(pageno);

String csrfToken = generateCSRFToken(session, "normalform");

%>
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/in.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<title><%=app_webtitle %></title>
<%@include file="../include/head.jsp" %>

<link rel="stylesheet" href="../css/style_nav/style_news/news.css">
<!-- InstanceEndEditable -->
<%
//Server name.	
	String servername = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
	if((request.getServerPort()== 80) || (request.getServerPort()== 443)) {
		servername = request.getScheme()+"://"+request.getServerName();
	} 
	String localname = request.getScheme()+"://"+request.getLocalName()+":"+request.getLocalPort();
	String url = servername + request.getContextPath();
%>
<%-- SEO 讀取關鍵字設定值 (讀取首頁共用值) --%>
<meta name="Robots" content="<%=SiteSetup.getText("seo.robots."+lang) %>" />
<meta name="revisit-after" content="<%=SiteSetup.getText("seo.revisit_after."+lang) %> days" />
<meta name="keywords" content="<%=SiteSetup.getText("seo.keywords."+lang) %>" />
<meta name="copyright" content="<%=SiteSetup.getText("seo.copyright."+lang) %>" />
<meta name="description" content="<%=SiteSetup.getText("seo.description."+lang) %>" />
<%-- 追蹤碼 --%><%=SiteSetup.getText("seo.head_track."+lang) %>
<!-- Facebook og 設定 -->
<meta property="og:title" content="<%=app_webtitle %>"></meta>
<meta property="og:url" content="<%=url %>"></meta>
<meta property="og:image" content="<%=url+"/web/images/logo.png" %>"></meta>
<meta property="og:description" content="<%=app_webtitle %>"></meta>

<%@include file="/WEB-INF/jspf/mis/pagerscript.jspf"%>
</head>

<body class="body_in">
    <%-- 追蹤碼 --%><%=SiteSetup.getText("seo.body_track."+lang) %> 
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
                        
                        <span>最新消息</span> 
                        
                        <!-- <i class="material-icons">navigate_next</i>
                        
                        <span>募款專案2022</span> --> 
                        
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
                    <div class="right no_left"><!-- 沒有左側附加noleft樣式 -->
                
                        <!--右側標題-->
                        <div class="right_title">
                            <h2>
                                最新消息
                            </h2>                        
                        </div>

                        <ul class="inNAarea">
                            
                            <!-- 首頁_最新消息_列表 -->
                            <%for(TableRecord np:nps){
	                    	String np_emitdate = np.getString("np_emitdate");
	                    	String news_year = np_emitdate.split("/")[0];
	                    	String news_month = np_emitdate.split("/")[1];
	                    	String news_day = np_emitdate.split("/")[2];
	                    	
	                    	%>
                            <li>
                                <!-- 最新消息_張貼日期 -->
                                <div class="time">
                                    <div class="year"><%=news_year %></div>
                                    <div class="date"><%=news_month %>/<%=news_day %></div>                            
                                </div>
                                <!-- 最新消息_標題 -->
                                <h3 class="title">
                                    <a href="news_in.jsp?np_id=<%=np.getString("np_id") %>">
                                        <%=np.getString("np_title") %>
                                    </a>
                                </h3>
                            </li>
                            <%} %>
                        </ul>
                        
                        
							<div class="number_pageArea">
							<%@include file="/WEB-INF/jspf/web/rwd_pager2.jspf"%>
							<form name="pageform" id="pageform" method="post" action="<%=request.getRequestURI()%>">
								<input type="hidden" name="npage" id="npage" value="<%=pageno %>" />
								<input type="hidden" name="csrfToken" value="<%=csrfToken %>" />
							</form>
							</div>                     
							</div>
                
                </div>
                
            </div>  
            
			
			
			<!-- InstanceEndEditable -->
			
      	</div> 
        
    </main>  


    <!--版腳-->
<%@include file="../include/copyright.jsp" %>

</body>
<!-- InstanceEnd --></html>
