<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%
	// 參數設定
	String page_code 	= "privacy", 				  			// 頁面識別碼
		   banner_code	= "privacy";							// banner識別碼

	// 資料
	String cp_id = StringTool.validString(request.getParameter("cp_id"));  //消息編號
	TableRecord cp = app_sm.select(tblcp , cp_id);  // 消息資料	
	
	// 列表
	Vector<TableRecord> cps = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=? and cp_category=?"
			, new Object[]{page_code, lang, ""}, "cp_showseq ASC, cp_createdate DESC");
	
	if("".equals(cp.getString("cp_id")) && cps.size()>0){
		cp = cps.get(0);
		cp_id = cp.getString("cp_id");
	}
	
%>

<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/in.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
	<%@include file="../include/head.jsp" %>
	
	<title><%=cp.getString("cp_webtitle")%></title>
	
    <%-- SEO --%>
    <meta name="Robots" content="<%=cp.getString("cp_robots")%>" />
    <meta name="revisit-after" content="<%=cp.getString("cp_revisit_after")%> days" />
    <meta name="keywords" content="<%=cp.getString("cp_keywords")%>" />
    <meta name="copyright" content="<%=cp.getString("cp_copyright")%>" />
    <meta name="description" content="<%=cp.getString("cp_description")%>" />
    <%-- 追蹤碼 --%><%=cp.getString("cp_seo_head_track")%>

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
</head>

<body class="body_in">
	<%-- 追蹤碼 --%>
	<%=cp.getString("cp_seo_body_track") %>

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
                            <a href="../../home.jsp?lang=tw">
                                首頁
                            </a>
                        </span> 
                        
                        <i class="material-icons">navigate_next</i>
						
						<!-- InstanceBeginEditable name="crumb" -->
                        
                        <span>個資聲明</span>   
                        
                        <i class="material-icons">navigate_next</i>
                        
                        <span><%=cp.getString("cp_title") %></span> 
                        
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
                            隱私權政策
                            <!-- <span>Recommend</span> -->
                        </div>
                        
                        <!--左側選單列表-->	
                        <div class="leftListArea">
                            

                            <%for(TableRecord leftcp:cps){ %>
                            <div class="leftList <%=cp_id.equals(leftcp.getString("cp_id"))?"active":""%>" >
                                <a href="../privacy/privacy.jsp?cp_id=<%=leftcp.getString("cp_id")%>&lang=tw">
                                    <!--功能名稱-->
                                    <div class="leftList_title">
                                        <%=leftcp.getString("cp_title") %>
                                    </div>
                                </a>                        
                            </div> 
                            <%} %>
                        </div>
                    </div>
                    
                    <!--右側-->
                    <div class="right">
                        
                        <!--右側標題-->
                        <div class="right_title">
                            <h2><%=cp.getString("cp_title") %></h2>
                        </div>
                        
                        <div class="right_contentBg">
            
                            <!--網編區塊-->
                            <section class="text_area">
								<%=cp.getString("cp_content") %>
                                
                            </section> 
           
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
<!-- InstanceEnd --></html>
<%@include file="/WEB-INF/jspf/connclose.jspf" %>