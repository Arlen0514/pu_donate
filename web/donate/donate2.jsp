<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="javax.websocket.MessageHandler.Whole"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/web/include/words.jsp"%>
<%@ include file="/web/include/encryption.jsp"%>
<% 
	/*-- 參數設定 --*/
	String page_code 	= "donate", 				  			// 頁面識別碼
			banner_code	= "donate";								// banner識別碼
	
	/*-- 表單資訊 --*/
	TableRecord dh = (TableRecord) session.getAttribute("donate_form");
	
	if(dh == null) {
		out.println("<script> alert('您尚未填寫捐款單 !!'); location='donate.jsp'; </script>");
		return;
	}
	
	// 表單欄位
	Map<String, String> default_values = new HashMap<String, String>();
	String[] field_names = dh.fieldNames();
	
	for(String field_name:field_names) 
		default_values.put(field_name, String.valueOf(dh.getValue(field_name)));
	default_values.put("dh_pid", new AESDataEncryption().AESDecrypt(default_values.get("dh_pid")));
	
	// 院系捐款  
	TableRecord department_index = app_sm.select(tbldm, "dm_code=? and dm_lang=? and dm_category=?",
            new Object[]{"department_index", lang, ""}, "dm_showseq ASC, dm_createdate DESC");
		   
	// 數字格式
	DecimalFormat df = new DecimalFormat("00");
		  
	
	boolean same_name = default_values.get("dh_name").equals(default_values.get("dh_receipt_title"));
	
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
                        
                        <span>我要捐款</span> 
                        
                        <i class="material-icons">navigate_next</i>
                        
                        <span>捐款確認</span> 
                        
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
                            <h2>捐款確認</h2>
                            <span class="enTit">Donation confirmation</span><!-- modify by david 20220914  -->
                        </div>
                        
                        <div class="right_contentBg">
                            <div class="form_remark">
<!--                                 必填icon -->
                                <div class="requirde_icon">
                                    *
                                </div>
                                <span style="color:#c30000">
                                    請確認您的必填項目皆已完整填寫。
                                </span>
                            </div>
                        
                            <div class="valuationBg">

                                <!-- 選擇捐款金額 -->
                                <div class="valuationArea">

                                    <!--表單區-->
                                    <div class="form_area contact_area form_outcome">
                                        
                                        
                                         <!--幣別-->
                                        <div class="form_list">
                                            <div class="fL_tit">
                                                幣別
                                                <span class="en">Currency</span>
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                            </div> 
                                            <div class="fL_info no_input">
                                                <%="other".equals(default_values.get("dh_currency")) ? default_values.get("dh_currency_other") : default_values.get("dh_currency") %> 
                                                
                                                <!-- <input type="text" name="" id="" placeholder="" value="5000" disabled="">                                                 -->
                                            </div>
                                        </div>
                                        
                                        <!--捐贈金額-->
                                        <div class="form_list">
                                            <div class="fL_tit">
                                                捐贈金額
                                                <span class="en">Donation Amount</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                            </div> 
                                            <div class="fL_info no_input">
                                                <%=default_values.get("dh_total") %>                                 
                                            </div>
                                        </div>
                                        
                                        <!--捐贈類別-->
                                        <%if(default_values.get("dh_donate_project_category").equals(department_index.getString("dm_id"))){ 
                                        	String dh_donate_project_title = "";
    										if("other".equals(default_values.get("dh_donate_project"))){
    											dh_donate_project_title = default_values.get("dh_donate_project_title");
    										}else{
    											dh_donate_project_title = app_sm.select(tblcp, default_values.get("dh_donate_project")).getString("cp_title");
    										}
                                        %>
                                        <!--院系募款-->
                                        <div class="form_list deptFund" id="deptFund"><!--一列兩個時class內加fLType2-->
                                            <div class="fL_tit">
                                                <%= app_sm.select(tbldm, default_values.get("dh_donate_project_category")).getString("dm_title")%>
                                                <span class="en">Give to Colleges</span>
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                            </div>
                                            <div class="fL_info fL_infoThree no_input">
                                            	<%=app_sm.select(tbldm, default_values.get("dh_donate_college")).getString("dm_title")%>&nbsp;&nbsp;
                                            	<%=app_sm.select(tbldm, default_values.get("dh_donate_department")).getString("dm_title")%>&nbsp;&nbsp;
                                            	<%=dh_donate_project_title %> 
                                            </div>
                                        </div>  
                                        <%}else { %>
                                        <div class="form_list"><!--一列兩個時class內加fLType2-->
                                            <div class="fL_tit">
                                                捐贈類別
                                                <span class="en">Category of donation</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                            </div>
                                            <div class="fL_info no_input">
                                              <%= app_sm.select(tbldm, default_values.get("dh_donate_project_category")).getString("dm_title")%>
                                            </div>
                                        </div> 
										
										
										<%
										String dh_donate_project_title = "";
										if("other".equals(default_values.get("dh_donate_project"))){
											dh_donate_project_title = default_values.get("dh_donate_project_title");
										}else{
											dh_donate_project_title = app_sm.select(tblcp, default_values.get("dh_donate_project")).getString("cp_title");
										}
										%>
                                        <!--指定捐贈用途-->
                                        <div class="form_list"><!--一列兩個時class內加fLType2-->
                                            <div class="fL_tit">
                                                指定捐贈用途
                                                <span class="en">Purpose of donation</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                            </div>
                                            <div class="fL_info no_input">
                                                <%=dh_donate_project_title %>                                            
                                            </div>
                                        </div>    
                                        <%} %>     
                                         
                                        <%if(!default_values.get("dh_remark").equals("")){ %>
                                        <!--捐款用途備註說明-->
                                        <div class="form_list"><!--一列兩個時class內加fLType2-->
                                            <div class="fL_tit">
                                                捐款用途備註說明
                                                <span class="en">Donation Purpose Remark</span>
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                            </div>
                                            <div class="fL_info no_input">
                                                <%=default_values.get("dh_remark")%>     
                                                <!-- <input type="text" name="" id="" placeholder="" value="說明說明說明說明說明" disabled="">                                                 -->
                                            </div>
                                        </div>   
                                        <%} %>                                                                          

                                    </div>

                                </div>

                                <!-- 輸入基本資料 -->
                                <div class="valuationArea">

                                    <!--表單區-->
                                    <div class="form_area contact_area form_outcome">
                                        
                                        <!--付款方式-->
                                        <div class="form_list"><!--一列兩個時class內加fLType2-->
                                            <div class="fL_tit">
                                                付款方式
                                                <span class="en">Donation method</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                            </div>
                                            <div class="fL_info no_input">
                                                <%= app_sm.select(tblcp, "cp_category = ? and cp_code = ? and cp_lang = ? ", new Object[]{
                                                		default_values.get("dh_paymethod"), "guide", lang}).getString("cp_title")%>
                                            </div>
                                        </div> 
                                        
                                        <%if(default_values.get("dh_paymethod").contains("regular")) { %>
                                        <div class="form_list"><!--一列兩個時class內加fLType2-->
                                            <div class="fL_tit">
                                                扣款到期日
                                                <span class="en">Debit due date</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                            </div>
                                            <div class="fL_info no_input">
                                        		民國 <%=DateTimeTool.getYear()-1911 %> 年 <%=df.format(DateTimeTool.getMonth()) %> 月至民國 <%=Integer.parseInt(default_values.get("dh_debit_due_year"))-1911 %> 年 <%=default_values.get("dh_debit_due_month") %> 月
                                            </div>
                                        </div>
                                        <%} %>
                                       <!--捐款人-->
                                        <div class="form_list">
                                            <div class="fL_tit">
                                                身份別
                                                <span class="en">Identity</span>
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                            </div>
                                            <div class="fL_info no_input">
                                                <%=default_values.get("dh_identity_type")
                                                .replace("enterprise","企業")
                                                .replace("native","本國人")
                                                .replace("foreigner","外國人")%>
                                                <!-- <input type="text" name="" id="" placeholder="捐款人姓名或企業機構名稱" value="邱淑宜" disabled=""/> -->
                                            </div>
                                        </div>
                                        <!--捐款人-->
                                        <div class="form_list">
                                            <div class="fL_tit">
                                                姓名/機構名稱
                                                <span class="en">Name</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                            </div>
                                            <div class="fL_info no_input">
                                                <%=default_values.get("dh_name")%>
                                            </div>
                                        </div>  
 										<!--身分證字號/統一編號-->
                                        <div class="form_list">
                                            <div class="fL_tit">
                                                <!-- 身分證字號/統一編號 -->
                                                身分證字號/統一編號/居留證或護照
                                                <span class="en">ID number</span>
                                                <!--必填icon--> 
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                            </div>
                                            <div class="fL_info no_input">
                                                <%=default_values.get("dh_pid")%>
                                            </div>
                                        </div>  
                                        <div class="form_list">
                                            <div class="fL_tit">
                                                聯絡電話
                                                <span class="en">Cellphone</span><!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div>
                                            </div>
                                            <div class="fL_info no_input">   
                                                <%=default_values.get("dh_cellphone")%>                              
                                                <!-- <input type="tel" name="cu_phone" id="cu_phone" placeholder="格式：0911-111-111" value="0911-111-111" disabled/> -->
                                            </div>
                                        </div> 
                                        <%if(!default_values.get("dh_phone").equals("")){ %>
                                        <div class="form_list">
                                            <div class="fL_tit">
                                                電話
                                                <span class="en">Telephone</span><!--必填icon-->
                                            </div>
                                            <div class="fL_info no_input">   
                                                <%=default_values.get("dh_phone")%>                              
                                                <!-- <input type="tel" name="cu_phone" id="cu_phone" placeholder="格式：0911-111-111" value="0911-111-111" disabled/> -->
                                            </div>
                                        </div> 
                                        <%} %>
                                        
                                        
                                        <!--通訊地址-->
                                        <div class="form_list">
                                            <div class="fL_tit">
                                                通訊地址
                                                <span class="en">Correspondence address</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                            </div>
                                            <div class="fL_info no_input">
                                                <%=default_values.get("dh_zipcode")+" "+default_values.get("dh_county")+default_values.get("dh_city")+default_values.get("dh_address") %>
                                            </div>
                                        </div> 
                                        <!--電子郵件-->                                
                                        <div class="form_list">
                                            <div class="fL_tit">
                                                電子郵件
                                                <span class="en">E-mail</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div>
                                            </div>
                                            <div class="fL_info no_input">
                                                <%=default_values.get("dh_email")%>
                                            </div>
                                        </div> 
                                        
                                        <!-- 贈與身分  -->
                                        <div class="form_list"><!--一列兩個時class內加fLType2-->
                                            <div class="fL_tit">
                                                身分
                                                <span class="en">Identity</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                                <!--未登入時顯示-->
                                                <!-- <label class="cBT_checkbox">
                                                    <input type="checkbox" class="toggle_password_checkbox">                                                    
                                                </label> -->
                                            </div>                                            
                                            <div class="fL_info no_input">
                                                <%=default_values.get("dh_identity").replace("1", "靜宜校友").replace("2", "靜宜教職員").replace("3", "學生/家長").replace("4", "企業機構").replace("5", "社會人士")%>
                                            </div>
                                        </div> 
                                        <!--服務單位-->
                                        <div class="form_list">
                                            <div class="fL_tit">
                                                服務單位
                                                <span class="en">Employer</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <!-- <div class="requirde_icon">
                                                    *
                                                </div> --> 
                                            </div>
                                            <div class="fL_info no_input">
                                                <%=default_values.get("dh_unit")%>
                                            </div>
                                        </div>  
                                       
                                        <!--職稱-->
                                        <div class="form_list">
                                            <div class="fL_tit">
                                                職稱
                                                <span class="en">Job title</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <!-- <div class="requirde_icon">
                                                    *
                                                </div> --> 
                                            </div>
                                            <div class="fL_info no_input">
                                                <%=default_values.get("dh_job")%>
                                            </div>
                                        </div>  
                                        		
                                       
                                        <%if("Y".equals(default_values.get("dh_receipt_status"))){ %>
                                        <!--收據抬頭名稱-->
                                        <div class="form_list">
                                            <div class="fL_tit">
                                                收據抬頭名稱
                                                <span class="en">Name on receipt</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                                <label class="cBT_checkbox"><!--未登入時顯示-->
                                                    <input type="checkbox" class="toggle_password_checkbox" <%="Y".equals(default_values.get("dh_same_name"))?"checked":"" %> disabled >
                                                    同捐款人<span class="en">The same as ”Name”</span>
                                                </label>
                                            </div>
                                            <div class="fL_info no_input">
                                                <%=default_values.get("dh_receipt_title")%>
                                            </div>
                                        </div>  
                                        	
                                        <!--收據寄送地址-->
                                        <div class="form_list">
                                            <div class="fL_tit">
                                                收據寄送地址
                                                <span class="en">Receiver’s address</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                                <label class="cBT_checkbox"><!--未登入時顯示-->
                                                    <input type="checkbox" class="toggle_password_checkbox" <%="Y".equals(default_values.get("dh_same_address"))?"checked":"" %> disabled>
                                                    同通訊地址<span class="en">The same as “Correspondence address”</span>
                                                </label>
                                            </div>
                                            <div class="fL_info no_input">
                                                <%=default_values.get("dh_receipt_zipcode")+" "+default_values.get("dh_receipt_county")+default_values.get("dh_receipt_city")+default_values.get("dh_receipt_address") %>
                                            </div>
                                        </div> 
                                        <%} %>
                                        
                                        <!--是否公開-->
                                        <div class="form_list"><!--一列兩個時class內加fLType2-->
                                            <div class="fL_tit">
                                                是否公開
                                                <span class="en">Donor Disclosure Agreement</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                                <span class="notice">
                                                    *姓名、身份、捐款金額刊登於本校網站或刊物，以為公開徵信之用。
                                                    <span class="en ">
                                                        I agree to have my name and donation listed on relevant NTOU websites or in publications.
                                                    </span>
                                                </span>
                                            </div>
                                            <div class="fL_info no_input">                                                
                                                <%="Y".equals(default_values.get("dh_public"))?"公開":"不公開" %><!-- <input type="text" value="公開" disabled> -->
                                            </div>
                                        </div> 
                                        
                                        <!-- 上傳稅務機關 -->
<!--                                         <div class="form_list">一列兩個時class內加fLType2 -->
<!--                                             <div class="fL_tit"> -->
<!--                                                 上傳稅務機關 -->
<!--                                                 <span class="en">Upload to Tax Authority</span> -->
<!--                                                 必填icon -->
<!--                                                 <div class="requirde_icon"> -->
<!--                                                     * -->
<!--                                                 </div>  -->
<!--                                                 <span class="notice"> -->
<!--                                                     *是否提供給稅務稽徵機關作為當年度綜合所得稅捐贈資料之歸戶作業。 -->
<!--                                                     <span class="en ">The donation information is provided to tax authorities for the current year's income tax return.</span> -->
<!--                                                 </span> -->
<!--                                                 <span class="notice"> -->
<!--                                                     *公司行號/法人/一般團體(不提供上傳至稅務機關服務)。 -->
<!--                                                     <span class="en "> -->
<!--                                                         Does not provide assistance to Company/Legal Person/Organization for uploading to tax authorities. -->
<!--                                                     </span> -->
<!--                                                 </span> -->
<!--                                                 <span class="notice"> -->
<!--                                                     *捐款可100％自個人當年度綜合所得/企業營利所得總額中扣除。 -->
<!--                                                     <span class="en "> -->
<!--                                                         Donations can be 100% deducted from your total income or corporate profits for the current year. -->
<!--                                                     </span> -->
<!--                                                 </span> -->
<!--                                             </div>   -->
                                            
<!--                                             <div class="fL_info no_input">                                                    -->
<%--                                                 <%="Y".equals(default_values.get("dh_tax"))?"上傳":"不上傳" %> --%>
<!--                                             </div> -->

<!--                                         </div>  -->

                                    </div>

                                </div>

                            </div>

                            <!--表單區 按鍵區-->
                            <div class="btn_area one">
	                            <form name="form0" id="form0" method="post" action="donate_update.jsp?action=donate" onsubmit="return checkform(this);">                        
	                                <input type="button" value="返回修改" onclick="location='donate.jsp';"/>
	                                <input type="submit" value="確認送出"/>
	                                <div class="clearfloat">
	                                </div>
	                            </form>
                            </div>

                        </div>
                        
                    </div>
                    
                </div>
                
            </div>  
		
		<!-- InstanceEndEditable -->
        	
      	</div> 
        
    </main>  

	<%@include file="../include/copyright.jsp" %>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>