<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/web/include/words.jsp"%>
<% 
	// 參數設定
	String page_code 	= "guide", 				  			// 頁面識別碼
		   banner_code	= "guide";  						
	
	// 列表
	Vector<TableRecord> cps = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=? "
			, new Object[]{"qa", lang}, "cp_showseq ASC, cp_createdate DESC");
	System.out.println(cps.size());
		   
	
%>
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/in.dwt" codeOutsideHTMLIsLocked="false" -->
<head>

<title><%=app_webtitle %></title>
<%@include file="../include/head.jsp" %>

<link rel="stylesheet" href="../css/style_nav/style_guide/style_guide.css">
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
<!-- InstanceEndEditable -->
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
                        
                        <span>募款說明</span>   
                        
                        <i class="material-icons">navigate_next</i>
                        
                        <span>捐款抵稅相關辦法</span> 
                        
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
                            
                            <div class="leftList"><!-- 當前模式 class加上active -->                      
                                <a href="../guide/guide.jsp">
                                    <!--功能名稱-->
                                    <div class="leftList_title">
                                        捐款方式暨流程
                                    </div>
                                </a>
                            </div>
                            
                            <div class="leftList active">
                                <a href="../guide/guide_2.jsp">                                    
                                    <!--功能名稱-->
                                    <div class="leftList_title">
                                        捐款抵稅相關辦法
                                    </div>                                    
                                </a>                                
                            </div>

                        </div>
                        
                    </div>
                    
                    <!--右側-->
                    <div class="right">
                        
                        <!--右側標題-->
                        <div class="right_title">
                            <h2>捐款抵稅相關辦法</h2>
                        </div>
                        
                        <div class="right_contentBg">
            
                            
                            
                            <!-- 募款說明文字區 -->
                            <ul class="cashFlowWay_guide">


                                <%for(TableRecord cp:cps){ %>
                                <div id="cash_flow2"></div>
                                <li class="cashFlowWay cfg2">
                                    <!--右側標題-->
                                    <div class="right_title3">
                                        <!-- <span><img src="../guide/images/cash_icon_02-2.svg"></span> -->
                                        <h2><%=cp.getString("cp_title") %></h2>
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
		

<!-- 附加aos動畫 -->
<script>

    document.querySelectorAll('ul.cashFlowWay_icon li').forEach(function(el, index) {
        var id = 'cashFlowWay_icon' + (index + 1);
        var delay = 400 + index * 100;

        el.id = id;
        el.setAttribute('data-aos', 'fade-right');
        el.setAttribute('data-aos-delay', delay.toString());
        el.setAttribute('data-aos-duration', '600');
        el.setAttribute('data-aos-anchor', '#' + id);
        el.setAttribute('data-aos-anchor-placement', 'bottom');
        el.setAttribute('data-aos-once', 'true');
        el.setAttribute('data-aos-easing', 'ease-in-sine');
    });


</script>



		<!-- InstanceEndEditable -->
			
      	</div> 
        
    </main>  


    <!--版腳-->
<%@include file="../include/copyright.jsp" %>
    


</body>
<!-- InstanceEnd --></html>
