<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	//基本參數
	String code = "default"; 					// 模組識別碼
	
	session.setAttribute("node", "0");
	// Selected record id.
	String mfid = StringTool.validString(request.getParameter("mfid"));
	// Get record.
	Vector cmfs = app_sm.selectAll("mis_function", "mf_id=?", new Object[] { mfid });
	// Current top function.
	app_ctmf = (cmfs.size() > 0) ? (TableRecord)cmfs.get(0) : (TableRecord)session.getAttribute("current_top");
	session.setAttribute("current_top", app_ctmf);   
%>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>
<html lang="<%=encoded %>">
<head>
<title><%=app_mistitle%></title>

    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="theme-color" content="#666666">
    <meta name="format-detection" content="telephone=no">
    <link rel="shortcut icon" href="../web/images/favicon.png" />
    <link rel="apple-touch-icon" href="../web/images/icon.png" />
    <link rel="apple-touch-icon" sizes="72x72" href="../web/images/icon-72.png" />
    <link rel="apple-touch-icon" sizes="114x114" href="../web/images/icon@2.png" />
    <link rel="stylesheet" type="text/css" href="css/style.css" />
    <link rel="stylesheet" type="text/css" href="css/default_frame_css.css" />
    <link rel="stylesheet" type="text/css" href="css/default_content_css.css" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Icons"            rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" type="text/javascript"></script>
    <script src="https://code.jquery.com/jquery-migrate-3.4.0.min.js" type="text/javascript"></script>
    <script src="js/common.js" type="text/javascript"></script>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">

</head>

<body class="default_body">

    <style>
        /*全站共用樣式*/
        :root {
            --active_color:<%=app_ctmf.getString("mf_bgcolor2") %>; /*全站當前模式色碼*/
        }
    </style>

    <!--內頁內容區塊-->
    <div class="pageContent default_pageContent">
        <div align="center" class="default_area">
            <table class="default_table" cellpadding="0" cellspacing="0" border="0">
                <tbody>
				        <!-- Top Start -->
                    <tr class="default_table_top">
                        <td align="left" colspan="1" class="bk-1" style="">
                            <table cellpadding="0" cellspacing="0" border="0">
                                <tbody>
                                
<%
	// 版本字串
	String version_str = "Ver25.0328";
	// Begin year
	String beginyear = "2025";
	// End year
	String endyear = String.valueOf(DateTimeTool.getYear());
	
	// 取得語系設定 
	String[] ss_lang_text = app_sm.select(tblss, "ss_title=? AND ss_keyword=?", new Object[]{ "可用語言版本", "web.language.offer" }).getString("ss_text").split(";");
	String[] ss_lang_value = app_sm.select(tblss, "ss_title=? AND ss_keyword=?", new Object[]{ "可用語言版本", "web.language.offer" }).getString("ss_value").split(";");

	// 重新抓取當前程式所在頁籤模組id
	TableRecord left_topmf;
	String left_topmfid="";
	String left_mispage = request.getServletPath();
	String left_misurl  = left_mispage.substring(left_mispage.lastIndexOf("/mis/")+5);
	if(left_misurl.equals("default.jsp")) {
		left_topmfid = StringTool.validString(request.getParameter("mfid"));
		left_topmf = app_sm.select(tblmf,left_topmfid);
	} else {
		String left_mffolder = left_misurl.substring(0, left_misurl.indexOf("/"));
		String left_mfurl = left_misurl.substring(left_misurl.indexOf("/") + 1);
		left_topmf = app_sm.select(tblmf, "mf_folder=?", new Object[]{ left_mffolder });
		left_topmfid = left_topmf.getString("mf_id");
	}
	
	// 重新塞入所屬頁籤模組
	if(!left_topmf.getString("mf_id").isEmpty()) {
		session.setAttribute("current_top", left_topmf);
	}

   	// Current top function.
   	TableRecord ses_ctmf = (TableRecord) session.getAttribute("current_top");

	// 倒數分鐘數
	int timeout = (int) session.getMaxInactiveInterval();	// 抓取 session存在時間
	int back_time = timeout / 60;
	
%>
		<script type="text/javascript">
			document.addEventListener("leftmenuLoaded", function(){
				<%if(left_misurl.equals("default.jsp")) { %>
				document.getElementById("show").src="leftmenu.jsp?mf_top=<%=left_topmfid %>&node=<%=node%>"
				<%} else { %>
				document.getElementById("show").src="../leftmenu.jsp?mf_top=<%=left_topmfid %>&node=<%=node%>"
				<%} %>
			});
		
			var _outcount = <%=back_time %>;
			var _outflag = setTimeout("_out_timedCount()",1000*60);
			function _out_timedCount() {
				document.getElementById('_outtime').innerHTML=_outcount;
				document.getElementById('_outtime2').innerHTML=_outcount;
				_outcount 	= _outcount - 1;
				if(_outcount > 0) {
					_outflag	= setTimeout("_out_timedCount()",1000*60);
				} else {
					clearTimeout(_outflag);
					document.location.href="<%=request.getContextPath()%>/mis/logout.jsp";
				}
			}
		</script>                                
<%-- top nemu --%>
                                    <tr class="admin_info_header">
                                        <td>
                                            <div class="logo" >
                                                <img src="images/logo_01.png" alt="logo">
                                            </div>
                                            <!--手機menu按鍵-->
                                            <div class="menu_btn">
                                                <span>
                                                </span>
                                                <span>
                                                </span>
                                                <span>
                                                </span>
                                            </div>
                                        </td>
                                        
                                        <td>
                                            <div class="user_session_info pc">
                                                <ul>
                                                    <li data-info="目前管理語系：" class="language">
                                                    
                                                        <div class="language_select">
<%if(ss_lang_value.length > 1) { 
	String now_mislang=(String)session.getAttribute("language");
%>
														<form name="change_mislang" method="post" action="<%=code %>.jsp">                                                        
                                                        
                                                            <select name="mis_language" id="mis_language" onchange="change_mislang.submit();">
                                                            <%for(int i = 0; i < ss_lang_value.length; i++) {  %>
																<option value="<%=ss_lang_value[i] %>" <%=now_mislang.equals(ss_lang_value[i])?"selected":""%> ><%=ss_lang_text[i] %></option>
															<%} %>
                                                            </select>
														</form>                                                            
<%}else {
	
// 	System.out.println((String)session.getAttribute("language_str"));
	%>
															<%=(String)session.getAttribute("language_str")%>
<%} %>                                                                
                                                        </div>       
                                                        
                                                                                                     
                                                    </li>
                                                    <li data-info="系統將於" data-info2="分後自動登出 " class="time"><strong id="_outtime"><%=back_time %></strong></li>
                                                    <li data-info="登入者:"><%=app_user.getString("au_name")%></li>
                                                    <li data-info="登入時間:"><%=thislogin.getString("al_logdate")%></li>
                                                    <li data-info="登入IP:"><%=thislogin.getString("al_remoteip")%></li>
                                                    <li data-info="上次登入:"><%=lastlogin.getString("al_logdate")%></li>
                                                    <li data-info="系統版本別:"><%=version_str %></li>
                                                    <li class="signOut_m">
                                                        <a href="<%=request.getContextPath()%>/mis/logout.jsp">
                                                            <i class="material-symbols-outlined">
                                                                logout
                                                            </i>
                                                            <span class="">
                                                                登出
                                                            </span>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr class="admin_navbar">
                                        <td>
                                            <div class="leave_blank_area"></div>
                                            <div class="header_rightArea default_tab_area">

                                                <!--主按鍵 navbar-->
                                                <div class="navbar">
					<%
   					for(int i = 0; i < app_tmfs.size(); i++) {
       					TableRecord _mf = (TableRecord)app_tmfs.get(i);
       					boolean is_function = _mf.getString("mf_id").equals(ses_ctmf.getString("mf_id"));
					%>
                                                    <!-- 系統管理模組 -->
                                                    <div class="nav<%=is_function?" active":"" %>" > 
                                                        <a href="<%=request.getContextPath()%>/mis/default.jsp?mfid=<%=_mf.getString("mf_id")%>" <%=is_function?" style='background-color:var(--active_color);'":"" %>> 
                                                            <%=_mf.getString("mf_name") %>
                                                        </a>
                                                    </div>
					<%} %>
                                                    
                                                    <!-- 登出 -->
                                                    <div class="nav">
                                                        <a href="<%=request.getContextPath()%>/mis/logout.jsp">
                                                            登出
                                                        </a>
                                                    </div>

                                                </div>

                                                <div class="user_session_info mobile">
                                                    <ul>
                                                        <li data-info="目前管理語系：" class="language">
                                                            <div class="language_select">
<%if(ss_lang_value.length > 1) { 
	String now_mislang=(String)session.getAttribute("language");
%>                                                            
														<form name="change_mislang_mob" method="post" action="<%=code %>.jsp">                                                        
                                                        
                                                            <select name="mis_language" id="mis_language_mob" onchange="change_mislang_mob.submit();">
                                                            <%for(int i = 0; i < ss_lang_value.length; i++) {  %>
																<option value="<%=ss_lang_value[i] %>" <%=now_mislang.equals(ss_lang_value[i])?"selected":""%> ><%=ss_lang_text[i] %></option>
															<%} %>
                                                            </select>
														</form>
<%}else{ %>
<%=(String)session.getAttribute("language_str")%>
<%} %>                                                                    
                                                            </div>                                                    
                                                        </li>
                                                        <li data-info="系統將於" data-info2="分後自動登出 " class="time"><strong id="_outtime2"><%=back_time %></strong></li>
                                                        <li data-info="登入者："><%=app_user.getString("au_name")%></li>
                                                        <li data-info="登入時間："><%=thislogin.getString("al_logdate")%></li>
                                                        <li data-info="登入IP："><%=thislogin.getString("al_remoteip")%></li>
                                                        <li data-info="上次登入："><%=lastlogin.getString("al_logdate")%></li>
                                                        <li data-info="系統版本別："><%=version_str %></li>

                                                        <li class="copyright mobile">
                                                            <p>© <%=beginyear%><%=(endyear.equals(beginyear))?"":"-"+endyear%> Greatest Idea Strategy Co.,Ltd All rights reserved.</p>
                                                        </li>
                                                    </ul>
                                                </div>

                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
				        <!-- Top End -->                  
                    
                    <tr class="default_table_bottom page_mis">


<%-- 舊版左側選單  包 leftmenu 的地方  --%>                    
                        <td width="" align="center" valign="top" class="system_bk-2">
<%-- left_menu end --%>                  
<%
// Current top function record.
TableRecord ctmf = (TableRecord)session.getAttribute("current_top");
Vector <TableRecord> _clmfs = null;

// Current left function records(level 2).
_clmfs = app_sm.selectAll("mis_function", "mf_status='N' and mf_upfunction=?", new Object[] { ctmf.getValue("mf_id") }, "mf_priority");

String drf_upfunction = StringTool.validString((String)session.getAttribute("upfunction"),"");
String upfunction = StringTool.validString(request.getParameter("upfunction"),drf_upfunction);
session.setAttribute("upfunction", upfunction);

%>
        
                            <!--左側-->
                            <div class="left_mis">

                                <!-- 分類切換按鈕 -->
                                <div class="category_changeButton">
                                    <a href="javascript:void(0);">
                                        <%=app_ctmf.getString("mf_name") %>
                                    </a>
                                </div>
                                
                                <!--左側選單列表-->	
                                <div class="leftListArea">
<%
//有第二層 
for (TableRecord  _clmf: _clmfs) {
	boolean have_first = false;
 	Vector <TableRecord> amf_lefts = app_sm.selectAll("admin_map_function", "au_id=? and mf_id=?", new Object[] { app_user.getValue("au_id"), _clmf.getString("mf_id") });
	if (amf_lefts.size() > 0 || app_user.getString("au_account").equals("root")) have_first = true;
	if (have_first){ 
		// 確認是否有下一層
		boolean have_second = false;
		Vector <TableRecord> second_lmfs = app_sm.selectAll("mis_function", "mf_status='N' and mf_upfunction=?", new Object[] { _clmf.getString("mf_id") }, "mf_priority");
		if (second_lmfs.size() > 0 ) have_second = true;
		
		boolean onpen_list = _clmf.getString("mf_id").equals(upfunction);
	if(have_second){ 
%>
                                    <div class="leftList<%=onpen_list?" active":"" %>"><!-- 當前模式 class加上active -->
                                        
                                        <!--功能名稱-->
                                        <div class="leftList_title">
                                            
                                            <a href="javascript:void(0);">
                                                 <%=_clmf.getString("mf_name") %>
                                            </a>
                                            <!--方向標誌-->
                                            <div class="leftList_icon direction">
                                                <!--方向標誌_向下展開-->
                                                <i class="material-icons down">keyboard_arrow_down</i>
                                                <!--方向標誌_向上收合-->
                                                <i class="material-icons up">keyboard_arrow_up</i>
                                            </div>
                                        </div>
                                        
                                        <!--展開選單-->
                                        <div class="leftList_open<%=onpen_list?" active":"" %>"><!-- 當前模式 class加上active -->
			<%for(TableRecord second_lmf : second_lmfs){
				Vector check_second_lmfs = app_sm.selectAll("admin_map_function", "au_id=? and mf_id=?",
						new Object[] { app_user.getValue("au_id"), second_lmf.getString("mf_id") });
				if (check_second_lmfs.size() > 0 || app_user.getString("au_account").equals("root")) {
			%>    	                            
                                            <div class="leftList_open_list<%=onpen_list?" active":"" %>"><!-- 當前模式 class加上active -->
                                                
                                                <div class="leftList_sec_area">
                                                    <div class="leftList_sec_title<%=onpen_list?" active":"" %>"><!-- 當前模式 class加上active -->
                                                        <a href="./<%=ctmf.getString("mf_folder") %>/<%=second_lmf.getString("mf_url") %>?upfunction=<%=_clmf.getString("mf_id") %>" >
                                                            <%=second_lmf.getString("mf_name") %>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
			<%} %>
		<%} %>                            
                            

                                        </div>
                                    </div>
		<%}else if(!have_second && have_first){ %> 
                                    <div class="leftList">                                        
                                        <!--功能名稱-->
                                        <div class="leftList_title">                                            
                                            <a href="./<%=ctmf.getString("mf_folder") %>/<%=_clmf.getString("mf_url") %>?upfunction=0">
                            						<%=_clmf.getString("mf_name") %>
                                            </a>
                                        </div>
                                    </div>
		<%}%>
	<%} %>
<%} %>	
                                    
                                </div>

                            </div>
<%-- left_menu end --%>                             
                        </td>
                        
             
                        
                        
                        <td width="" align="center" valign="top" class="system_bk-2p">
                            <div class="right_mis">

                                <!--右側內頁內容區塊-->
                                <div class="right_contentBg" style="border-color: var(--active_color);">

                                    <div class="right_content">
                                        <div class="right_content_in scroll">
                                            <!-- <img src="images/demo.png" alt="bg" title="bg" width="2000" height="auto"> -->
                                            <!-- <img src="images/login_bg.webp" alt="bg" title="bg" width="100%" height="auto"> -->
											<table width="357" height="269" border="0" align="center" cellpadding="0" cellspacing="0">
									              <tr>
									                <td width="176">
									                	<br/ >
									                </td>
									                <td width="181">
									                	<span class="style7"><br><br><br><br><br><br>
									                		<%=app_user.getString("au_account")%> <br />
															您已成功進入本單元系統
														</span>
													 </td>
									              </tr>
								            </table>
                                        </div>
                                    </div>
                                </div>
.



<%--


                                <div class="copyright pc">
                                    <p>© <%=beginyear%><%=(endyear.equals(beginyear))?"":"-"+endyear%>Greatest Idea Strategy Co.,Ltd All rights reserved.</p>
                                    <p>網站管理系統</p>
                                </div>
 --%>                                
                                
                                
                                
                                

                            </div>
                            
                            
                            
                            
                            
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

</body>

</html>