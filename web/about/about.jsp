<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/config.jspf" %>
<%

String page_code = "about_content";
String code = "about_content";
TableRecord cp = app_sm.select(tblcp, "cp_code=? and cp_lang=?", new Object[]{ code, lang });



%>
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/in.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<title><%=app_webtitle %></title>
<%@include file="../include/head.jsp" %>

  <%-- SEO 讀取關鍵字設定值 (讀取首頁共用值) --%>
<meta name="Robots" content="<%=cp.getString("cp_robots") %>" />
<meta name="revisit-after" content="<%=cp.getString("cp_revisit_after") %> days" />
<meta name="keywords" content="<%=cp.getString("cp_keywords") %>" />
<meta name="copyright" content="<%=cp.getString("cp_copyright") %>" />
<meta name="description" content="<%=cp.getString("cp_description") %>" />
<%-- 追蹤碼 --%><%=cp.getString("cp_seo_head_track") %>
<!-- Facebook og 設定 -->
<meta property="og:url" content="<%=request.getRequestURL()+(request.getQueryString()!=null&&!request.getQueryString().isEmpty()?"?"+request.getQueryString():"") %>" />
<meta property="og:type" content="website" />
<meta property="og:title" content="<%=app_webtitle %>" />
<meta property="og:description" content="<%=SiteSetup.getText("seo.description."+lang) %>" />



</head>

<body class="body_in">
        <%-- 追蹤碼 --%><%=cp.getString("cp_seo_body_track") %>
    
    
    
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
                        
                        <span>靜宜概覽</span> 
                        
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
                    <div class="right no_left">
                        
                        <!--右側標題-->
                        <div class="right_title">
                            <h2>靜宜概覽</h2>
                        </div>
                        
                        <div class="right_contentBg">

                                <!--網編區塊-->
                                <section class="text_area">
                                    <%=cp.getString("cp_content") %>
                                </section>

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
