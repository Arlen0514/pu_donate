<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.genesis.utils.StringTool"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/web/include/words.jsp"%>
<% 
	// 參數設定
	String page_code 	= "directory", 				  		// 頁面識別碼
		   banner_code	= "directory";						// banner識別碼
		   
		   
		   
	Vector<TableRecord> fds = app_sm.selectAll(tblfd, "fd_code=? and fd_lang=?", new Object[] { "annual_report", lang }, "fd_showseq ASC , " + "fd_createdate DESC");
	//換頁
// 	int page_items=10;
// 	app_dp = new DataPager(fds,page_items);    							//設定資料分頁每頁筆數
// 	fds = app_dp.getPageContent(pageno);

	
%>
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/in.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<title><%=app_webtitle %></title>
<%@include file="../include/head.jsp" %>
<link rel="stylesheet" href="../css/style_nav/style_directory/style_form.css">
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
<%-- <%@include file="/WEB-INF/jspf/mis/pagerscript.jspf"%> --%>

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
						
                        <span>捐款芳名錄</span>

                        <i class="material-icons">navigate_next</i>

                        <span>捐贈報告</span>
						
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
                            捐款芳名錄
                            <!-- <span>Recommend</span> -->
                        </div>

                        <!--左側選單列表-->
                        <div class="leftListArea">

                            <div class="leftList">
                                <a href="../directory/directory.jsp">
                                    <!--功能名稱-->
                                    <div class="leftList_title">
                                        捐款明細
                                    </div>
                                </a>
                            </div>

                            <div class="leftList active"><!-- 當前模式 class加上active -->
                                <a href="../directory/directory_download.jsp">
                                    <!--功能名稱-->
                                    <div class="leftList_title">
                                        捐贈報告
                                    </div>
                                </a>
                            </div>

                            

                        </div>

                    </div>

                    <!--右側-->
                    <div class="right">

                        <!--右側標題-->
                        <div class="right_title">
                            <h2>捐贈報告</h2>
                        </div>

                        <div class="right_contentBg">

                            <div class="guide_download_bg">

                                <div class="guide_downloadArea">

                                    <!--右側標題3-->
                                    <!-- <div class="right_title4">
                                        <i class="bi bi-box-seam-fill"></i>
                                        <h2>捐贈報告</h2>
                                    </div> -->
    
                                    <!--驅動下載列表-->
                                    <div class="downloadArea">
    									<%for(TableRecord fd:fds){ %>
                                        <!--驅動下載列表_清單-->
                                        <div class="dLA_list">
                                            <div class="dLA_list_in">
    
                                                <!--驅動下載列表_清單_左側-->
                                                <div class="dLAL_left">
                                                    <!--驅動下載_標題-->
                                                    <div class="dLALL_tit">
                                                        <%=fd.getString("fd_title") %>
                                                    </div>
    
                                                    
                                                </div>
    
                                                <!--驅動下載_按鈕-->
                                                <div class="download_btn">
                                                <%if(!fd.getString("fd_file").isEmpty()) { %>
<%-- 													<a href="" download><%=fd.getString("fd_file") %></a> --%>
													<a target="_blank" href="<%=app_fetchpath+"/annual_report/"+lang+"/"+fd.getString("fd_file")%>" class="inkMe" ink-color="bgBlue" multiple-ink=true >
															                      		
										    	<%} %>
                                                        下載
                                                    </a>
                                                </div>
    
                                                <!-- <div class="clearfloat">
                                                </div> -->
                                            </div>
                                        </div>
                                        <%} %>
    
                                        <!--驅動下載列表_清單-->
                                        
                                    </div>
    
                                </div>
                                
                                

                            </div>

                            
                            <!--頁數列區塊-->
                            <div class="number_pageArea" style="display: none;">
                                <!--左側區塊-->
                                <div class="numberPage_leftArea">
                                    <div class="numberPage_leftList">
                                        <a href="#">
                                            <img src="../images/last_leftIcon.png" width="31" height="30" />
                                        </a>
                                    </div>
                                    <div class="numberPage_leftList">
                                        <a href="#">
                                            <!--<img src="../images/leftIcon.png" width="31" height="30" />-->
                                            <span class="material-icons">
                                                keyboard_arrow_left
                                            </span>
                                        </a>
                                    </div>
                                </div>

                                <!--中間區塊-->
                                <div class="numberPage_middleArea">
                                    <div class="numberPage_middleList active"><!--當前模式 class 加 active-->
                                        <a href="#">
                                            1
                                        </a>
                                    </div>
                                    <div class="numberPage_middleList">
                                        <a href="#">
                                            2
                                        </a>
                                    </div>
                                    <div class="numberPage_middleList">
                                        <a href="#">
                                            3
                                        </a>
                                    </div>
                                    <div class="numberPage_middleList">
                                        <a href="#">
                                            4
                                        </a>
                                    </div>
                                    <div class="numberPage_middleList">
                                        <a href="#">
                                            5
                                        </a>
                                    </div>

                                    <div class="clearfloat">
                                    </div>
                                </div>

                                <!--右側區塊-->
                                <div class="numberPage_rightArea">
                                    <div class="numberPage_rightList">
                                        <a href="#">
                                            <!--<img src="../images/rightIcon.png" width="31" height="30" />-->
                                            <span class="material-icons">
                                                keyboard_arrow_right
                                            </span>
                                        </a>
                                    </div>
                                    <div class="numberPage_rightList">
                                        <a href="#">
                                            <img src="../images/last_rightIcon.png" width="31" height="30" />
                                        </a>
                                    </div>
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
