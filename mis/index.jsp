<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%
	// Clear session
   	if(!session.isNew()) session.invalidate();
   	// Begin year
   	String beginyear = "2025";
   	// End year
   	String endyear = String.valueOf(DateTimeTool.getYear());
   	// 語系
   	// 讀取 site_setup 中的語系設定   Marco 20131101
   	String[] ss_lang_text = app_sm.select(tblss, "ss_title=? AND ss_keyword=?", new Object[]{"可用語言版本","web.language.offer"}).getString("ss_text").split(";");
   	String[] ss_lang_value = app_sm.select(tblss, "ss_title=? AND ss_keyword=?", new Object[]{"可用語言版本","web.language.offer"}).getString("ss_value").split(";");
%>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="Robots" content="none" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="theme-color" content="#666666">

    <meta name="format-detection" content="telephone=no">

    <title><%=app_mistitle%></title>
    <link rel="shortcut icon" href="../web/images/favicon.png" />
    <link rel="apple-touch-icon" href="../web/images/icon.png" />
    <link rel="apple-touch-icon" sizes="72x72" href="../web/images/icon-72.png" />
    <link rel="apple-touch-icon" sizes="114x114" href="../web/images/icon@2.png" />
    <link rel="stylesheet" type="text/css" href="css/style.css" />
    <link rel="stylesheet" type="text/css" href="css/login_css.css" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Icons"            rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <script src="https://code.jquery.com/jquery-3.7.1.min.js" type="text/javascript"></script>
    <script src="https://code.jquery.com/jquery-migrate-3.4.0.min.js" type="text/javascript"></script>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    
    
<script language="JavaScript" type="text/JavaScript">
	function check_account(INPUT) {
	    var litExp = /\W+/;
	    var invalid = litExp.test(INPUT);
	    return invalid;
	}
	
	function check_pwd(INPUT) {
		var litExp = /^.*(?=.{8,30}).*$/;

	    var invalid = litExp.test(INPUT);
	    return invalid;
	}
	function checkform(F) {
	    if (F.au_account.value == "" || check_account(F.au_account.value)) {
	        alert("請輸入有效的帳號資料");
	        F.au_account.focus();
	    } else if(F.au_password.value == "" || !check_pwd(F.au_password.value)) {
	        alert("請輸入有效的密碼資料(密碼長度需為 8-30 位)");
	        F.au_password.focus();
		} else if (F.ind.value == "") {
		    alert("請輸入圖案文字!!");
		    F.ind.focus();
	    } else {
	    	F.language_str.value = $("#language option:selected").text();
	        return true;
	    }
	    return false;
	}
	function loadimage() { 
		document.getElementById("randImage").src = "../comm/image.jsp?"+Math.random(); 
	}
</script>    
    
 
</head>

<body><!-- onload="loginForm.au_account.focus();" -->
    

        <!--內頁內容區塊-->
        <div class="pageContent loginImg" style="background-image: url(images/login_bg.webp); background-size: cover;background-repeat: no-repeat;background-position: left center;">

            <div class="wrap">
                
                <div class="login_in">

                    <div class="login_area">

                        <div class="right_side">                            
                            <img class="logoImg" src="images/logo_01.png" alt="">
                        </div>
<form name="loginForm" method="post" action="login.jsp" onsubmit="return checkform(this);">
                        <div class="input_list">   

                            <div class="input_in">
                                <div class="icon">
                                    <img src="images/avatar.svg" alt="">
                                </div> 
                                <input type="text" name="au_account" id="au_account" placeholder="帳號"> 
                            </div>
                            
                            <div class="input_in password">
                                <div class="icon">
                                    <img src="images/login_lock.svg" alt="" />
                                </div>                                
                                <i class="bi bi-eye-slash-fill" id="check_eye"></i>
                                <input type="password" name="au_password" id="au_password" placeholder="密碼" />
                            </div>
                            
                            
                            <div class="input_in" <%=(ss_lang_value.length == 1)?"style='display: none'":"" %>>
                                <div class="icon">
                                    <img src="images/login_language.svg" alt="">
                                </div> 
                                <select name="language" id="language">
       								<%for(int i=0 ; i < ss_lang_value.length; i++){ %>
										<option value="<%=ss_lang_value[i] %>" ><%=ss_lang_text[i] %></option>
									<%} %>
								</select>
                            </div>
                            <input name="language_str" id="language_str" type="hidden" value="" />     
                            
                            <div class="input_captcha">
                                <div class="captcha login_captcha">
                                <input name="ind" id="ind" type="text" placeholder="&nbsp;&nbsp;驗&nbsp;證&nbsp;碼" onfocus="javascript:loadimage();"/>
                                <img src="../comm/image.jsp" name="randImage" id="randImage" />
                                <span class="captcha_refresh">重取驗證碼</span>
	                                <a href="javascript:loadimage();">
	                                    <img src="images/arrowclockwise.svg" alt="" />
	                                </a>
                                </div>

                            </div>
        
                            <div class="loginBtn">                           
                                <button type="submit" class="submit">登入</button>        
                                <button type="reset" class="reset">重填</button>                         
                            </div>

                        </div>
</form>
                    </div>
                    
                </div>
                
                <div class="copyright">
                    <p>© <%=beginyear%><%=(endyear.equals(beginyear))?"":"-"+endyear%> Greatest Idea Strategy Co.,Ltd All rights reserved.</p>
                    <p>網站管理系統</p>
                </div>
            </div> 

        </div>
        
        <script>
            
        //------------------------ 會員登入_密碼欄位 顯示/不顯示小眼睛-------------------

        $(function(){
            $("#check_eye").click(function () {
                if($(this).hasClass('bi bi-eye-slash-fill')){
                    $("#au_password").attr('type', 'text');
                }else{
                    $("#au_password").attr('type', 'password');
                }
                $(this).toggleClass('bi-eye-slash-fill');
                $(this).toggleClass('bi-eye-fill');
            }); 
        });
        </script>

</body>

</html>