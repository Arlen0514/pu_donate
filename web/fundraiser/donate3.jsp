<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="javax.websocket.MessageHandler.Whole"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/web/include/words.jsp"%>
<% 
	// 參數設定
	String page_code 	= "donate", 				  			// 頁面識別碼
			banner_code	= "donate";								// banner識別碼
	
	// 資料編號
	String dh_id = StringTool.validString(request.getParameter("dh_id"));
	TableRecord dh = app_sm.select(tbldh , dh_id);	
	TableRecord ph = app_sm.select(tblph, "data_id=?", new Object[]{dh.getString("dh_id")});
		   
	TableRecord cp = app_sm.select(tblcp, "cp_category = ? and cp_code = ? and cp_lang = ? ", new Object[]{
    		dh.getString("dh_paymethod"), "guide", lang});
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
	
	<link rel="stylesheet" type="text/css" href="../css/style_nav/style_donate/style_donate_in.css"/>
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
                        
                        <span>我要捐款</span> 
                        
                        <i class="material-icons">navigate_next</i>
                        
                        <span>捐款完成頁</span> 
                        
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
                            <h2>捐款完成頁</h2>
<!--                             <span class="enTit">Donation Complete</span> -->
                        </div>
                        
                        <div class="right_contentBg">
            
                            <div class="valuationBg">

                                <!-- 網編區塊 -->
                                <section class="text_area">
                                	<%if("pay.newebpay.vatm".equals(dh.getString("dh_paymethod"))){ %>
				                	虛擬帳號，銀行代號(<%=ph.getString("ph_bank_no") %>):<%=ph.getString("ph_account") %>，繳費期限：<%=ph.getString("ph_limitdate").replace("-","/") %>
				                	<br/>
				                	<%} %>
									<%=cp.getString("cp_content2") %>
                                </section>

                            </div>
                            
                            <!--表單區 按鍵區-->
                            <div class="btn_area ">
                                <input type="button" value="返回首頁" onclick="location='../../home.jsp'">
                                <%if("pay.pu".equals(dh.getString("dh_paymethod"))){ %>
                                <input type="button" value="前往繳款" onclick="location='../payment/pupay/get_url.jsp?dh_id=<%=dh_id%>'">
                                <%} %>
                                <div class="clearfloat">
                                </div>
                            </div>

                        </div>
                        
                    </div>
                
                    <!-- <div class="clearfloat">
                    </div>	 -->
                    
                </div>
                
            </div>  
		
		<!-- InstanceEndEditable -->
			
      	</div> 
        
    </main>  

	<%@include file="../include/copyright.jsp" %>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>