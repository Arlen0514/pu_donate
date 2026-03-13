<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.genesis.utils.StringTool"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/WEB-INF/jspf/csrf_token.jspf"%>
<%@ include file="/web/include/words.jsp"%>
<%!
public static String maskName(String name) {
    if (name == null || name.isEmpty()) {
        return "";
    }

    int len = name.length();

    if (len == 1) {
        return name;
    }

    if (len == 2) {
        return name.substring(0, 1) + "*";
    }

    // len > 2
    StringBuilder sb = new StringBuilder();
    sb.append(name.substring(0, 1));

    for (int i = 0; i < len - 2; i++) {
        sb.append("○");
    }

    sb.append(name.substring(len - 1));
    return sb.toString();
}

%>
<% 
	// 參數設定
	String page_code 	= "directory", 				  		// 頁面識別碼
		   banner_code	= "directory";						// banner識別碼
	int page_items		= 10;								// 列表分頁筆數設定
	
	// 資料編號
// 	String qcategory   = StringTool.validString(request.getParameter("_qcategory"));
// 	String qyear 	   = StringTool.validString(request.getParameter("_qyear"));
// 	String qmonth 	   = StringTool.validString(request.getParameter("_qmonth"));
// 	String qrest_year  = StringTool.validString(request.getParameter("_qrest_year"));
// 	String qrest_month = StringTool.validString(request.getParameter("_qrest_month"));
// 	String qname 	   = StringTool.validString(request.getParameter("_qname"));
	
	String qcategory   = "";
	String qyear 	   = "";
	String qmonth 	   = "";
	String qrest_year  = "";
	String qrest_month = "";
	String qname 	   = "";
	
	try {
		qcategory 	= StringTool.validString(request.getParameter("_qcategory"));
		qyear 		= StringTool.validString(request.getParameter("_qyear"));
		qmonth 		= StringTool.validString(request.getParameter("_qmonth"));
		qrest_year 	= StringTool.validString(request.getParameter("_qrest_year"));
		qrest_month = StringTool.validString(request.getParameter("_qrest_month"));
		qname 		= StringTool.validString(request.getParameter("_qname"));
	} catch(Exception e){
		response.setStatus(400);
 		response.setHeader("Location","/400.jsp");
 		response.setHeader("Connection", "close");
 		return;
	}

	/*-- 日期設定 --*/
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
	String qemitdate = "", qrestdate = "";
	Calendar emit_date = Calendar.getInstance();
	Calendar rest_date = Calendar.getInstance();
	boolean has_emit = !"".equals(qyear) && !"".equals(qmonth);
	boolean has_rest = !"".equals(qrest_year) && !"".equals(qrest_month);
	
	if(has_emit){
		try {
			int year = Integer.parseInt(qyear);
			int month = Integer.parseInt(qmonth);
			
			emit_date.set(Calendar.YEAR, year);
			emit_date.set(Calendar.MONTH, month-1);
			qemitdate = sdf.format(emit_date.getTime());
		} catch(Exception e){
			has_emit = false;
		}
	}
	
	if(has_rest){
		try {
			int year = Integer.parseInt(qrest_year);
			int month = Integer.parseInt(qrest_month);
			int day = 31;
			
			rest_date.set(Calendar.YEAR, year);
			rest_date.set(Calendar.MONTH, month-1);
			day = rest_date.getActualMaximum(Calendar.DATE);
			rest_date.set(Calendar.DATE, day);
			qrestdate = sdf.format(rest_date.getTime());
		} catch(Exception e){
			has_rest = false;
		}
	}
	
	String def_qrestdate = DateTimeTool.dateString(DateTimeTool.getYear(),DateTimeTool.getMonth(),DateTimeTool.getDay()) , 
		   def_qemitdate = DateTimeTool.dateString(DateTimeTool.getYear()-1,DateTimeTool.getMonth(),DateTimeTool.getDay());
	if("".equals(qemitdate)) {
		qemitdate = def_qemitdate;
		qyear = String.valueOf(DateTimeTool.getYear()-1);
		qmonth = String.valueOf(DateTimeTool.getMonth());
	}
	
	if("".equals(qrestdate)) {
		qrestdate = def_qrestdate;
		qrest_year = String.valueOf(DateTimeTool.getYear());
		qrest_month = String.valueOf(DateTimeTool.getMonth());
	}
	
	// Names and values.
	String[] names = new String[] { "_qcategory", "_qyear", "_qmonth", "_qrest_year", "_qrest_month", "_qname"};
	String[] values = new String[] { qcategory, qyear, qmonth, qrest_year, qrest_month, qname};	
	
	StringBuffer sb = new StringBuffer();
	Vector keys = new Vector();
	
	sb.append("dr_donate_item_title like ?");
	keys.add("%"+qcategory+"%");
	sb.append(" and !(dr_donatedate>? || dr_donatedate<?)");
	keys.add(qrestdate);
	keys.add(qemitdate);
	sb.append(" and dr_name like ?");
	keys.add("%"+qname+"%");	
	sb.append(" and dr_status = ?");
	keys.add("Y");
	sb.append(" and dr_code=?");
	keys.add(page_code);	
	sb.append(" and dr_lang=?");
	keys.add(lang);	
	
	Vector<TableRecord> drs = app_sm.selectAll(tbldr, sb.toString(), keys.toArray() , "dr_donatedate DESC");
	
	DecimalFormat df = new DecimalFormat("00");
	
	
	// 設定資料分頁每頁筆數
	page_items = "N".equals(SiteSetup.getValue("ss.pageno").trim()) ? 9999 : page_items;	   														// 預設列表分頁筆數設定
	app_dp = new DataPager(drs, page_items);
	drs = app_dp.getPageContent(pageno);
	String csrfToken = generateCSRFToken(session, "normalform");
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
	
	<link rel="stylesheet" href="../css/style_nav/style_directory/style_directory.css">

	<%-- 分頁處理 --%>
	<%@include file="/WEB-INF/jspf/mis/pagerscript.jspf"%>
	
	<script language="JavaScript" type="text/JavaScript">
		function checkform(F) {
		    if (F._qyear.value+F._qmonth.value > F._qrest_year.value+F._qrest_month.value) {
		        alert("請輸入完整日期,開始日期不得大於結束日期 !!");
		        return;
		    } else {
		    	F.submit();
		    }
		}
	</script>
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
                        
                        <span>捐款芳名錄</span> 
                        
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

                            <div class="leftList active">
                                <a href="../directory/directory.jsp">
                                    <!--功能名稱-->
                                    <div class="leftList_title">
                                        捐款明細
                                    </div>
                                </a>
                            </div>

                            <div class="leftList"><!-- 當前模式 class加上active -->
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
                    <div class="right "><!-- 無左側選單 -->
                        
                        <!--右側標題-->
                        <div class="right_title">
                            <h2>捐款芳名錄</h2>
                            <span class="enTit">Names of Donors</span><!-- modify by david 20220914  -->
                        </div>
                        
                        <form name="form0" id="form0" method="post" onsubmit="return checkform(this);">
                        <input type="hidden" name="csrfToken" value="<%=csrfToken %>" />
                        <div class="directory_filter_area">
						    
                            <!--勸募專案-->
                            <div class="form_list solicitationList"><!--一列兩個時class內加fLType2-->
                                <div class="fL_tit">
                                    勸募專案：
                                </div>
                                <div class="fL_info donationPurpose_info">
                                    <input class="info_other" type="text" name="_qcategory" id="_qcategory" placeholder="請自行輸入指定用途" value=""/>
                                </div>
                            </div>      
                            
                            <!--捐款日期-->
                            <div class="form_list solicitationList"><!--一列兩個時class內加fLType2-->
                                <div class="fL_tit">
                                    捐款日期：
                                </div>
                                <div class="fL_info courseDateRange">
                                    <div class="start">
                                        <select name="_qyear" id="_qyear">
                                        	<%for(int i=2010;i<=DateTimeTool.getYear();i++){ %>
                                            <option value="<%=i%>" <%=qyear.equals(i+"")?"selected":"" %>><%=i %>年</option>
                                        	<%} %>
                                        </select>
                                        <select name="_qmonth" id="_qmonth">
                                        	<%for(int i=1;i<=12;i++){ %>
                                            <option value="<%=df.format(i)%>" <%=qmonth.equals(df.format(i))?"selected":"" %>><%=i %>月</option>
                                        	<%} %>
                                        </select>
                                        <span>~</span>
                                    </div>
                                    <div class="finish">
                                        <!-- <span>截止時間</span> -->
                                        <select name="_qrest_year" id="_qrest_year">
                                        	<%for(int i=2010;i<=DateTimeTool.getYear();i++){ %>
                                            <option value="<%=i%>" <%=qrest_year.equals(i+"")?"selected":"" %>><%=i %>年</option>
                                        	<%} %>
                                        </select>
                                        <select name="_qrest_month" id="_qrest_month">
                                        	<%for(int i=1;i<=12;i++){ %>
                                            <option value="<%=df.format(i)%>" <%=qrest_month.equals(df.format(i))?"selected":"" %>><%=i %>月</option>
                                        	<%} %>
                                        </select>
                                    </div>
                                </div>
                            </div>   

                            <!--捐款人-->
                            <div class="form_list solicitationList actual_date"><!--一列兩個時class內加fLType2-->
                                <div class="fL_tit">
                                    捐款人：
                                    <!--必填icon-->
                                    <!-- <div class="requirde_icon">
                                        *
                                    </div>  -->
                                </div>
                                <div class="fL_info">
                                    <input type="text" name="_qname" id="_qname" placeholder="" value="<%=qname %>" class="" />
                                    <input type="button" name="" id="" placeholder="" value="查詢" class="newBtn" onclick="checkform(form0);"/>
                                </div>
                            </div> 
                        </div>
                        </form>

                        <div class="right_contentBg">
            
                            <!--表單區底-->
                            <div class="no_bg directoryArea">
                                
                                <table cellpadding="0" cellspacing="0" border="0">
                                        
                                    <thead>
                                        <tr>
                                            <th class="">
                                                捐贈日期
                                            </th>
                                            <th>
                                                捐贈人
                                            </th>
                                            <th>
                                                身分
                                            </th>
                                            <th>
                                                捐贈金額
                                            </th>
                                            <th>
                                                募款專案
                                            </th> 
                                        </tr>
                                    </thead>
                                
                                    <!-- 表身 -->
                                    <tbody>
                                		
                                		<%
                                		for(TableRecord dr:drs){ 
                                			TableRecord dh = app_sm.select(tbldh, dr.getString("dh_id"));
                                		%>
                                        <tr>
                                            <td data-name="捐贈日期：">
                                                <%=dr.getString("dr_donatedate") %>
                                            </td>
                                            <td data-name="捐贈人：" >
                                                <%="N".equals(dh.getString("dh_public"))?"熱心人士":maskName(dr.getString("dr_name")) %>
                                            </td>
                                            <td data-name="身分：">
                                                <%=dr.getString("dr_identity").replace("1", "靜宜校友").replace("2", "靜宜教職員").replace("3", "學生/家長").replace("4", "企業機構").replace("5", "社會人士") %>
                                            </td>
                                            <td data-name="捐贈金額">
                                                <%=dr.getString("dr_currency") %>.<%=app_df.format(dr.getInt("dr_total")) %>
                                            </td>
                                            <td data-name="募款專案">
												<%=dr.getString("dr_donate_item_title") %>	
                                            </td>
                                        </tr>
                                        <%} %>
                                
                                    </tbody>
                                
                                </table>

                            </div>  

                            <!--頁數列區塊-->
				            <div class="number_pageArea">
				            	<!-- 分頁 -->
								<%@include file="/WEB-INF/jspf/web/rwd_pager2.jspf"%>
								<form name="pageform" id="pageform" method="post" action="<%=request.getRequestURI()%>">
									<input type="hidden" name="npage" id="npage" value="<%=pageno%>" />
									<%out.println(HtmlCoder.hiddenInputs(names, values)); %>
									<input type="hidden" name="csrfToken" value="<%=csrfToken %>" />
								</form>
								<!-- 分頁-END -->
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