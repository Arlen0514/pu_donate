<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/web/include/words.jsp"%>
<% 
	// 參數設定
	String page_code 	= "department", 				  	// 頁面識別碼
		   banner_code	= "donate_project";						// banner識別碼
		   

	String dm_id = StringTool.validString(request.getParameter("dm_id"));
	TableRecord dm = app_sm.select(tbldm, dm_id);
    
    Vector<TableRecord> dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category = ?", new Object[] { page_code+"_category", lang, dm.getString("dm_id") }, "dm_showseq ASC , " + "dm_createdate DESC");
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
	
	<link rel="stylesheet" type="text/css" href="../css/style_nav/style_donate_project/style_dept_fund_in.css"/>
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
                        
                        <i class="material-icons">navigate_next</i>

                        <span><%=dm.getString("dm_title") %></span>
                        
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
                            <h2><%=dm.getString("dm_title") %></h2>
                        </div>
                        
                        <div class="right_contentBg">

                            
                                <!--頁籤變下拉選單特效 開始 不用的話刪除-->
                                <script type="text/javascript">
                                    $(document).ready(function(e) {
                                        $(".tabs_btn_now").click(function(e) {
                                            $(".img-scroll").slideToggle();
                                        });
                                        
                                        $(".tabs li span").click(function(e) {
                                            var tabsText = $(this).text();
                                            var bodywidth=document.documentElement.clientWidth;//取得螢幕可見寬度
                                            
                                            $(".tabs_btn_now span").replaceWith('<span>'+tabsText+'</span>');
                                            if ( bodywidth <= 760 ) {
                                                $(".img-scroll").slideToggle();
                                                $(".img-scroll").removeAttr("style");  //點擊後關閉
                                            }
                                        });
                                        
                                        $(window).resize(function(e) {
                                            $(".img-scroll").removeAttr("style");
                                        });
                                    });
                                </script>
                                <!--頁籤變下拉選單特效 結束-->

                                <script type="text/javascript" src="../js/tags_switching.js"></script>
                                <div class="text_bottom">
                                    <div class="tab_area">
                        
                                        <div class="tabs_btn_now"><!--變下拉選單時用 不用時可以刪除-->
                                            <span><%=dm.getString("dm_title") %></span>
                                            <div class="tabs_btn_now_arrow">
                                            </div>
                                        </div>
                                        <div class="tab_area">
                                            <div class="img-scroll">
                                                <div class="img-list">
                                                    <ul class="tabs">
                                                    	<%for(int i =0; i<dms.size();i++){ 
                                                    	TableRecord temp = dms.get(i);
                                                    	%>
                                                        <li class="<%=i==0?"active":""%>">
                                                            <span href="#tab<%=i+1%>">
                                                                <%=temp.getString("dm_title") %>
                                                            </span>
                                                        </li>
                                                        <%} %>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                        <!--頁籤區 結束-->
                                
                                    </div>
                            
                                    <!--產品內頁頁籤的網編區-->
                                    <div class="p_tab_text_area">
                                    	<%for(int i =0; i<dms.size();i++){ 
                                        	TableRecord temp = dms.get(i);
                                        	Vector<TableRecord> cps = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=? and cp_category = ? ", new Object[] { page_code, lang, temp.getString("dm_id") }, "cp_showseq ASC , " + "cp_createdate DESC");
                                        %>
                                        <div id="tab<%=i+1%>">
                                            
                                            <!--表單區底-->
                                            <div class="no_bg dept_fund_infoArea">
                                                
                                                <table cellpadding="0" cellspacing="0" border="0">
                                                        
                                                    <thead>
                                                        <tr>
                                                            <th class="">
                                                                募款專案
                                                            </th>
                                                            <th>
                                                                聯繫窗口
                                                            </th>
                                                            <th>
                                                            </th>
                                                        </tr>
                                                    </thead>
                                                
                                                    <!-- 表身 -->
                                                    <tbody>
                                                		<%for(TableRecord cp : cps){ %>
                                                        <tr>
                                                            <td data-name="募款專案：">
                                                                <%=cp.getString("cp_title") %>
                                                            </td>
                                                            <td data-name="聯繫窗口：" >
                                                                <%=cp.getString("cp_name") %>
                                                                <%if(!"".equals(cp.getString("cp_phone"))){ %>
                                                                <br/>
                                                                電話：<a href="tel:<%=cp.getString("cp_phone") %>"><%=cp.getString("cp_phone") %> </a>                                                                
                                                                <%} %>
                                                                <%if(!"".equals(cp.getString("cp_email"))){ %>
                                                                <br/>                                                                
                                                                E-mail：<a href="mailto:<%=cp.getString("cp_email") %>"><%=cp.getString("cp_email") %></a>       
                                                            	<%} %>
                                                            </td>
                                                            <td>
                                                                <input type="button" value="我要捐款" onclick="location='../donate/donate.jsp?donate_id=<%=cp.getString("cp_id")%>'">
                                                            </td>
                                                        </tr>
                                                        <%} %>

                                                    </tbody>
                                                </table>

                                            </div>  

                                        </div>
                                        <%} %>
                                    </div>

                                </div>
                                
                                <div class="btn_area one"><!--如果只有一個按鍵時class內加one-->
                                    <input type="button" value="回上一頁" onclick="location='javascript:window.history.back();'" />
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