<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/config.jspf" %>
<%

String page_code = "donate_project";
String code = "donate_project";

String dm_id = StringTool.validString(request.getParameter("dm_id"),"");
String cp_id = StringTool.validString(request.getParameter("cp_id"),"");

if("".equals(dm_id.trim()) && "".equals(cp_id.trim()) ){// dm_id cp_id 為""
	Vector<TableRecord> nav_donate_project_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category=?",
			new Object[]{ "donate_category", lang , ""} ,"dm_showseq ASC, dm_createdate DESC");
	if(nav_donate_project_dms.size()>0) 
		dm_id = nav_donate_project_dms.get(0).getString("dm_id");
	
	Vector<TableRecord> donate_projects = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=? and cp_category = ?", new Object[] { code, lang, dm_id }, "cp_showseq ASC , " + "cp_createdate DESC");
	if(donate_projects.size()>0)  
		cp_id = donate_projects.get(0).getString("cp_id");
}

if("".equals(cp_id.trim())){ //cp_id 為"" dm_id 不為""
	Vector<TableRecord> donate_projects = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=? and cp_category = ?", new Object[] { code, lang, dm_id }, "cp_showseq ASC , " + "cp_createdate DESC");
	if(donate_projects.size()>0) 
		cp_id = donate_projects.get(0).getString("cp_id");
}

TableRecord cp = app_sm.select(tblcp, cp_id);

if("".equals(dm_id.trim())) 
	dm_id = cp.getString("cp_category");

TableRecord dm = app_sm.select(tbldm, dm_id);


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
                        
                        <span>
                            <a href="donate_project.jsp">
                                募款專案
                            </a>
                        </span> 
                        
                        <!-- <i class="material-icons">navigate_next</i>
                        
                        <span>募款專案2022</span> -->
                        
                        <i class="material-icons">navigate_next</i>
                        
                        <span><%=dm.getString("dm_title") %></span> 

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
                    <div class="left">
                    
                        <!--左側表單名稱-->
                        <div class="left_title">
                            募款專案
                            <!-- <span>Recommend</span> -->
                        </div>
                        
                        <%if(nav_donate_project_dms.size()>0){
                        	for (int i = 0; i < nav_donate_project_dms.size(); i++) {
                            	TableRecord nav_donate_project_dm = nav_donate_project_dms.get(i);
                            	Vector<TableRecord> donate_projects = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=? and cp_category = ?", new Object[] { code, lang, nav_donate_project_dm.getString("dm_id") }, "cp_showseq ASC , " + "cp_createdate DESC");

                            	
                        	%>
                        <div class="leftListArea">
                            
                            <div class="leftList <%=dm_id.equals(nav_donate_project_dm.getString("dm_id")) ? "active" : ""%>"><!-- 當前模式 class加上active -->
                            
                                <a href="javascript:void(0);">
                                    
                                    <!--代表性標誌-->
                                    <!--<div class="leftList_icon first">
                                        <i class="material-icons">fiber_manual_record</i>
                                    </div>-->
                                    
                                    <!--功能名稱-->
                                    <div class="leftList_title">
                                        <%=nav_donate_project_dm.getString("dm_title") %>
                                    </div>
                                    
                                    <!--方向標誌-->
                                    <div class="leftList_icon direction">
                                        <!--方向標誌_向下展開-->
                                        <i class="material-icons down">keyboard_arrow_down</i>
                                        <!--方向標誌_向上收合-->
                                        <i class="material-icons up">keyboard_arrow_up</i>
                                    </div>
                                </a>
                                
                                <!--展開選單-->
                                <div class="leftList_open <%=dm_id.equals(nav_donate_project_dm.getString("dm_id")) ? "active" : ""%>" style=""><!-- 當前模式 class加上active -->
                    				<%for(TableRecord donate_project:donate_projects){ %>
                                    <div class="leftList_open_list <%=cp_id.equals(donate_project.getString("cp_id")) ? "active" : ""%>"><!-- 當前模式 class加上active -->
                                        <a href="donate_project_in.jsp?cp_id=<%=donate_project.getString("cp_id") %>">
                                           <%=donate_project.getString("cp_title") %>
                                        </a>
                                    </div>
                    				<%} %>
                                                                                    
                                </div>
                                
                            </div>
                        </div>
                        <%} %>
                        <%} %>
                        
                    </div>
                    <!--右側-->
                    
                    
                    <div class="right"><!-- 無左側選單 -->
                        
                        <!--右側標題-->
                        <!-- <div class="right_title">
                            <h2>深耕圓夢獎助學金</h2>
                        </div> -->
                        <%if(!"".equals(cp.getString("cp_id"))){ %>
                        <div class="right_contentBg">
            
                            <div class="product_in">

                                <div class="pI_top">

                                    <!--商品內頁商品圖-->
                                    <div class="product_in_img">
                                        <span>
                                            <img src="<%=app_fetchpath+"/"+code+"/"+lang+"/"+cp.getString("cp_image")%>" alt="" srcset="">
                                        </span>                                        
                                    </div>

                                    <!--產品內頁上右-->
                                    <div class="pIT_right">

                                        <div class="pITR_tit">
                                            <h2><%=cp.getString("cp_title") %></h2>
                                        </div>

                                        <!-- 簡述 -->
                                        <div class="pITR_remark">                                            
                                            <%=cp.getString("cp_desc") %>
                                        </div>

                                        <!-- 按鍵 -->
                                        <div class="product_addBtn">
                                            <input type="submit" value="線上捐款" class="buy" onclick="location='../donate/donate.jsp?cp_id=<%=cp_id%>'">
                                        </div>
                                    </div>

                                </div>

                                <div class="pI_bottom">
                                    <!--網編區塊-->
                                    <section class="text_area">
                                         <%=cp.getString("cp_content") %>                               
                                    </section> 

                                </div>

                            </div>

                            <div class="btn_area one"><!--如果只有一個按鍵時class內加one-->
                                <input type="button" value="回上一頁" onclick="location='javascript:window.history.back();'" />
                                <!-- <input type="button" value="我要報名" onclick="location='../course/course_form.jsp'">        -->
                                <div class="clearfloat">
                                </div>
                            </div>

                        </div>
                        <%} %>
                    </div>
                
                    <!-- <div class="clearfloat">
                    </div>	 -->
                    
                </div>
                
            </div>  
		
		<!-- InstanceEndEditable -->
			
      	</div> 
        
    </main>  


    <!--版腳-->
<%@include file="../include/copyright.jsp" %>


</body>
<!-- InstanceEnd --></html>
