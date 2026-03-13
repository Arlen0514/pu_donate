<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/config.jspf" %>
<%

String page_code = "qa";
String code = "qa";
String dm_id = StringTool.validString(request.getParameter("dm_id"),"");

//常見問題類別
Vector<TableRecord> left_menu_qa_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? ",
      new Object[]{"qa2_category", lang}, "dm_showseq ASC, dm_createdate DESC");
if(("".equals(dm_id) || dm_id==null) && left_menu_qa_dms.size()>0) dm_id = left_menu_qa_dms.get(0).getString("dm_id");

TableRecord dm = app_sm.select(tbldm,dm_id);




Vector<TableRecord> qas = app_sm.selectAll(tblcp, "cp_category = ? AND cp_code = ?", new Object[]{dm_id, "qa2"} , "cp_showseq ASC , " + "cp_createdate DESC"); 

//換頁
int page_items=10;
app_dp = new DataPager(qas,page_items);    							//設定資料分頁每頁筆數
qas = app_dp.getPageContent(pageno);


%>
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/in.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<title><%=app_webtitle %></title>
<%@include file="../include/head.jsp" %>
<!-- InstanceBeginEditable name="head" -->

<link rel="stylesheet" href="../css/style_nav/style_guide/style_qa.css">
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
                        
                        <span>常見問題</span>   
                        
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
                    
                    <!--左側-->
                    <div class="left">
                    
                        <!--左側表單名稱-->
                        <div class="left_title">
                            常見問題
                            <!-- <span>Recommend</span> -->
                        </div>
                        <div class="leftListArea">
                           <%for(TableRecord qa_dm:qa_dms){ %>                                
                            
                            <div class="leftList <%=qa_dm.getString("dm_id").equals(dm_id) ? "active" :""%>"><!-- 當前模式 class加上active -->                      
                                <a href="../qa/qa.jsp?dm_id=<%=qa_dm.getString("dm_id") %>">
                                    <!--功能名稱-->
                                    <div class="leftList_title">
                                        <%=qa_dm.getString("dm_title") %>
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
                            <h2><%=dm.getString("dm_title") %></h2>
                        </div>
                        
                        <div class="right_contentBg">
            

                            <!--QA收合-->
                            <script type="text/javascript">
                                $(function(){
                                    $(".qa_list.active").children(".qaL_text").show();
                                    
                                    $(".qa_list").children(".qaL_tit").click(function(e) {
                                        $(".qa_list").children(".qaL_tit").not(this).parent(".qa_list").removeClass("active");
                                        $(this).parent(".qa_list").toggleClass("active");
                                        
                                        $(".qa_list").children(".qaL_tit").not(this).siblings(".qaL_text").slideUp();
                                        $(this).next(".qaL_text").slideToggle();
                                    });
                                })
                            </script> 

                            <!--常見問題列表-->
                            <div class="qa_list_area">
                                <%for(TableRecord qa : qas){ %>
                                <div class="qa_list ">
                                    
                                    <div class="qaL_tit">
										<%=qa.getString("cp_title") %>
                                    </div>
                                    
                                    <div class="qaL_text">
										<%=qa.getString("cp_content") %>
                                    </div>
                                    
                                </div>
                                <%} %>
                                                                                                           
                            </div>  

                            <!--頁數列區塊-->
							<div class="number_pageArea">
							<%@include file="/WEB-INF/jspf/web/rwd_pager2.jspf"%>
							<form name="pageform" id="pageform" method="post" action="<%=request.getRequestURI()%>">
								<input type="hidden" name="npage" id="npage" value="<%=pageno %>" />
								<input type="hidden" name="dm_id" id="dm_id" value="<%=dm_id %>" />
								
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
