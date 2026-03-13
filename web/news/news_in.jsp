<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/config.jspf" %>
<%

String page_code = "news";
String code = "news";

String np_id = StringTool.validString(request.getParameter("np_id"),"");
TableRecord np = app_sm.select(tblnp, np_id);


%>

<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/in.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<title><%=app_webtitle %></title>
<%@include file="../include/head.jsp" %>

  <%-- SEO 讀取關鍵字設定值 (讀取首頁共用值) --%>
<meta name="Robots" content="<%=np.getString("np_robots") %>" />
<meta name="revisit-after" content="<%=np.getString("np_revisit_after") %> days" />
<meta name="keywords" content="<%=np.getString("np_keywords") %>" />
<meta name="copyright" content="<%=np.getString("np_copyright") %>" />
<meta name="description" content="<%=np.getString("np_description") %>" />
<%-- 追蹤碼 --%><%=np.getString("np_seo_head_track") %>
<!-- Facebook og 設定 -->
<meta property="og:url" content="<%=request.getRequestURL()+(request.getQueryString()!=null&&!request.getQueryString().isEmpty()?"?"+request.getQueryString():"") %>" />
<meta property="og:type" content="website" />
<meta property="og:title" content="<%=app_webtitle %>" />
<meta property="og:description" content="<%=SiteSetup.getText("seo.description."+lang) %>" />

</head>

<body class="body_in">
    <%-- 追蹤碼 --%><%=np.getString("np_seo_body_track") %> 
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
                        
                        <span>
                            <a href="news.jsp">
                                最新消息
                            </a>
                        </span> 
                        
                        <i class="material-icons">navigate_next</i>
                        
                        <span><%=np.getString("np_title") %></span> 
                        
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
                            <h2><%=np.getString("np_title") %></h2>
                        </div>
                        
                        <div class="right_contentBg">

                                <!--網編區塊-->
                                <section class="text_area">
									<%=np.getString("np_content") %>
                                </section>
                                <div class="btn_area one"><!--如果只有一個按鍵時class內加one-->
                                <input type="button" value="回上一頁" onclick="location='javascript:window.history.back();'">
                                <!-- <input type="button" value="我要報名" onclick="location='../course/course_form.jsp'">        -->
                                <div class="clearfloat">
                                </div>
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
