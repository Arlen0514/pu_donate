<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/config.jspf" %>
<%@ include file="/WEB-INF/jspf/csrf_token.jspf" %>
<%

String page_code = "photo";
String code = "photo";
// 資料
Vector<TableRecord> aps = app_sm.selectAll(tblap, "ap_code=? and ap_lang=?", new Object[] { page_code, lang }, "ap_showseq ASC , ap_createdate DESC");

//換頁
int page_items=12;
app_dp = new DataPager(aps,page_items);    							//設定資料分頁每頁筆數
aps = app_dp.getPageContent(pageno);

String csrfToken = generateCSRFToken(session, "normalform");

%>
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/in.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<title><%=app_webtitle %></title>
<%@include file="../include/head.jsp" %>
<link rel="stylesheet" href="../css/style_nav/style_photo/style_photo.css">
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
                        
                        <span>活動紀實</span> 
                        
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
                            <h2>活動紀實</h2>
                            <!-- <span class="enTit">Photo Gallery</span> -->
                        </div>

                        <!--右側內頁內容區塊-->
                        <div class="right_contentBg">
                            
                            <div class="photo_area">
								<%for(TableRecord ap:aps){ %>
                                <div class="photo_list">
                                    <a href="../photo/photo_in.jsp?ap_category=<%=ap.getString("ap_id") %>" class="photo_list_in" tabindex="27">
                                        <div class="photo_img">
                                            <img src="<%=app_fetchpath+"/"+page_code+"/"+lang+"/"+ap.getString("ap_image")%>" alt="<%=ap.getString("ap_title") %>代表圖">
                                        </div>
                                        <div class="photo_info">
                                            <div class="photo_top">
                                                <div class="photo_number"><%=ap.getString("ap_no") %></div>
                                                <div class="photo_title">
                                                    <%=ap.getString("ap_title") %>
                                                </div>
                                            </div>
                            
                            
                                            <div class="photo_description">
                                                <%=ap.getString("ap_desc") %>
                                            </div>
                                        </div>
                            
                                    </a>
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
