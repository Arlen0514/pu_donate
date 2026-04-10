<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/config.jspf" %>
<%@ include file="/WEB-INF/jspf/csrf_token.jspf" %>
<%

String page_code = "guide";
String code = "download";


Vector<TableRecord> fds = app_sm.selectAll(tblfd, "fd_code=? and fd_lang=? and fd_emitdate <= ?  and fd_restdate >= ? ", 
		new Object[] { code, lang, app_today, app_today }, 
		"fd_emitdate ASC, fd_showseq ASC , fd_createdate DESC"); 

//換頁
int page_items=10;
app_dp = new DataPager(fds,page_items);    							//設定資料分頁每頁筆數
fds = app_dp.getPageContent(pageno);

String csrfToken = generateCSRFToken(session, "normalform");

%>
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/in.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<title><%=app_webtitle %></title>
<%@include file="../include/head.jsp" %>

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
 <link rel="stylesheet" href="../css/style_nav/style_qa/style_qa_download.css">
<!-- InstanceEndEditable -->
</head>

<body class="body_in">
    
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
                        <div class="leftListArea">
                            
                            <div class="leftList "><!-- 當前模式 class加上active -->                      
                                <a href="../guide/guide.jsp">
                                    <!--功能名稱-->
                                    <div class="leftList_title">
                                        捐款方式暨流程
                                    </div>
                                </a>
                            </div>
                            <div class="leftList">
                                 <a href="../guide/guide_2.jsp" >
                                     <!--功能名稱-->
                                   	<div class="leftList_title">
                                   	捐款抵稅相關辦法
                                   	</div>
                                 </a>
                            </div>
                            <div class="leftList active">
                                <a href="../guide/qa_download.jsp">                                    
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
                            <h2>表單下載</h2>
                            <span class="enTit">Form Download</span>
                        </div>
                        
                        <div class="right_contentBg">
            
                            <!--驅動下載列表-->
                            <div class="downloadArea">
								<%for(TableRecord fd :fds){ %>
                                <!--驅動下載列表_清單-->
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
                                                <%=fd.getString("fd_title") %>
                                            </div>
                                        </div>

                                        <!--驅動下載_按鈕-->
                                        <div class="download_btn">
                                            <a target="_blank" href="<%=app_fetchpath+"/"+code+"/"+lang+"/"+fd.getString("fd_file")%>" class="inkMe" ink-color="bgBlue" multiple-ink=true >
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
							<%@include file="/WEB-INF/jspf/web/rwd_pager2.jspf"%>
							<form name="pageform" id="pageform" method="post" action="<%=request.getRequestURI()%>">
								<input type="hidden" name="npage" id="npage" value="<%=pageno %>" />
								<input type="hidden" name="csrfToken" value="<%=csrfToken %>" />
							</form>
							</div>
        
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
