<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/web/include/words.jsp"%>
<% 
	// 參數設定
	String page_code 	= "donate", 				  			// 頁面識別碼
		   banner_code	= "donate_project";						// banner識別碼
	
	// 列表
	Vector<TableRecord> dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=?"
			, new Object[]{page_code+"_category", lang}, "dm_showseq ASC, dm_createdate DESC");
	

    //院系募款
    TableRecord department_index = app_sm.select(tbldm, "dm_code=? and dm_lang=? and dm_category=?",
            new Object[]{"department_index", lang, ""}, "dm_showseq ASC, dm_createdate DESC");
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
	
	<link rel="stylesheet" type="text/css" href="../css/style_nav/style_donate_project/style_donate_project.css"/>
</head>
<body class="body_in">
	<%-- 追蹤碼 --%>
	<%=SiteSetup.getText("seo.body_track." + lang)%>
	
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
                        
                        <span>募款專案</span> 
                        
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
                            <h2>募款專案</h2>
                            <span class="enTit">Donation Projects</span><!-- modify by david 20220914  -->
                        </div>
                        
                        <div class="right_contentBg">
            
                            <ul class="donate_projectArea">
                            	<%
                            	String default_image = "images/demo2.webp";
                            	int project_count = dms.size();
                            	int first_max = 3;
                            	boolean lower_three = project_count<3;
                            	
                            	if(lower_three) first_max = project_count;
                            	%>

								<%for(int i=0;i<first_max;i++){ 
									TableRecord dm = dms.get(i);
			                    	
			                    	// 預設圖片有上傳但圖片不見，路徑寫法
			                    	String donate_project_dm_image = default_image;
			                    	String filePath = app_uploadpath+ "/" + "donate_category" + "/" + lang + "/" + dm.getString("dm_image");
			                    	String filePath2 = app_fetchpath+ "/" + "donate_category" + "/" + lang + "/" + dm.getString("dm_image");
			                    	File file = new File(filePath);
			                    
			                    	if(!dm.getString("dm_image").equals(""))
			                    		if(file.exists() && !file.isDirectory()) donate_project_dm_image = filePath2;
								%>
                                <!-- 募款專案第一層列表 -->
                                <li>
                                    <div class="donate_projectList">
                                        <!-- 募款專案第一層圖片 -->
                                        <div class="donate_project_img">
                                            <a href="../donate_project/donate_project_in.jsp?dm_id=<%=dm.getString("dm_id")%>">
                                                <img src="<%=donate_project_dm_image %>" alt="<%=dm.getString("dm_title")%>" title="<%=dm.getString("dm_title")%>">
                                            </a>
                                        </div>
                                        <div class="dP_listInR">
                                    
                                            <!-- 募款專案第一層標題 -->
                                            <h3>
                                                <a href="../donate_project/donate_project_in.jsp?dm_id=<%=dm.getString("dm_id")%>">
                                                    <%=dm.getString("dm_title") %>
                                                </a>
                                                <span class="en"><%=dm.getString("dm_subtitle") %></span><!-- modify by david 20220914  -->
                                            </h3>
        
                                            <!-- 首頁募款專案按鈕 -->
                                            <div class="dP_btn">
                                                <a href="../donate_project/donate_project_in.jsp?dm_id=<%=dm.getString("dm_id")%>" class="inkMe" 
                                                                                                   ink-color="bgBlue" 
                                                                                                   multiple-ink=true>
                                                    查看更多
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </li>
                                <%} %>
                                
                                <%if(department_category_dms.size()>0){ %>
	                            <%
			                    String department_index_image = default_image;
			                    String department_index_filePath = app_uploadpath+ "/" + "department_index" + "/" + lang + "/" + department_index.getString("dm_image");
			                	String department_index_filePath2 = app_fetchpath+ "/" + "department_index" + "/" + lang + "/" + department_index.getString("dm_image");
			                	File department_index_file = new File(department_index_filePath);
			                	if(!department_index.getString("dm_image").equals(""))
			                		if(department_index_file.exists() && !department_index_file.isDirectory()) department_index_image = department_index_filePath2;
			                    %>
	                    
								<!-- 院系募款 -->
                                <li>
                                    <div class="donate_projectList">
                                        <!-- 募款專案第一層圖片 -->
                                        <div class="donate_project_img">
                                            <a href="../donate_project/dept_fund_list.jsp?dm_id=<%=department_index.getString("dm_id")%>">
                                                <img src="<%=department_index_image %>" alt="<%=department_index.getString("dm_title")%>" title="<%=department_index.getString("dm_title")%>">
                                            </a>
                                        </div>
                                        <div class="dP_listInR">
                                    
                                            <!-- 募款專案第一層標題 -->
                                            <h3>
                                                <a href="../donate_project/dept_fund_list.jsp?dm_id=<%=department_index.getString("dm_id")%>">
                                                    <%=department_index.getString("dm_title") %>
                                                </a>
                                                <span class="en"><%=department_index.getString("dm_subtitle") %></span><!-- modify by david 20220914  -->
                                            </h3>
        
                                            <!-- 首頁募款專案按鈕 -->
                                            <div class="dP_btn">
                                                <a href="../donate_project/dept_fund_list.jsp?dm_id=<%=department_index.getString("dm_id")%>" class="inkMe" 
                                                                                                   ink-color="bgBlue" 
                                                                                                   multiple-ink=true>
                                                    查看更多
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </li>
                                <%} %>
                                                                
                                <%if(!lower_three){ %>
                                <%for(int i=3;i<dms.size();i++){ 
									TableRecord dm = dms.get(i);
			                    	
			                    	// 預設圖片有上傳但圖片不見，路徑寫法
			                    	String donate_project_dm_image = default_image;
			                    	String filePath = app_uploadpath+ "/" + "donate_category" + "/" + lang + "/" + dm.getString("dm_image");
			                    	String filePath2 = app_fetchpath+ "/" + "donate_category" + "/" + lang + "/" + dm.getString("dm_image");
			                    	File file = new File(filePath);
			                    
			                    	if(!dm.getString("dm_image").equals(""))
			                    		if(file.exists() && !file.isDirectory()) donate_project_dm_image = filePath2;
								%>
                                <!-- 募款專案第一層列表 -->
                                <li>
                                    <div class="donate_projectList">
                                        <!-- 募款專案第一層圖片 -->
                                        <div class="donate_project_img">
                                            <a href="../donate_project/donate_project_in.jsp?dm_id=<%=dm.getString("dm_id")%>">
                                                <img src="<%=donate_project_dm_image %>" alt="<%=dm.getString("dm_title")%>" title="<%=dm.getString("dm_title")%>">
                                            </a>
                                        </div>
                                        <div class="dP_listInR">
                                    
                                            <!-- 募款專案第一層標題 -->
                                            <h3>
                                                <a href="../donate_project/donate_project_in.jsp?dm_id=<%=dm.getString("dm_id")%>">
                                                    <%=dm.getString("dm_title") %>
                                                </a>
                                                <span class="en"><%=dm.getString("dm_subtitle") %></span><!-- modify by david 20220914  -->
                                            </h3>
        
                                            <!-- 首頁募款專案按鈕 -->
                                            <div class="dP_btn">
                                                <a href="../donate_project/donate_project_in.jsp?dm_id=<%=dm.getString("dm_id")%>" class="inkMe" 
                                                                                                   ink-color="bgBlue" 
                                                                                                   multiple-ink=true>
                                                    查看更多
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </li>
                                <%} %>
                                <%} %>
                            </ul>

           
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