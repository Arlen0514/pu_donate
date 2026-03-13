<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@ page import="java.net.*,java.io.*,org.json.JSONObject" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@include file="/web/include/encryption.jsp"%>
<%@include file="get_token.jsp"%>
<%

/*------------設定------------------------------*/
String api_status = "online";					// 金流環境設定(test:測試/online:正式)
boolean is_test  = true;						// 是否為本機測試
boolean printLog  = false;						// 是否為本機測試


/*-----------API資料-----------------------------------------------*/
String api_url = "https://ezpy.pu.edu.tw/dataTrans/index.php/";				//正式網址
if(is_test) api_url = "https://ezpy-ts1.pu.edu.tw/dataTrans/index.php/";	//測試網址

if(printLog) System.out.println("api_url---"+api_url);

String secret = "b2l0cy10by1wdWdpdmU=";  									//key
String idHead = "1044001";													//消帳編號開頭

%>
<%
    // 呼叫共用方法
//     String token = "";
//     try {
//         token = getToken(secret, is_test, printLog);
//         session.setAttribute("pu_token", token); // 存到 session 共用
//     } catch(Exception e) {
//         e.printStackTrace();
//     }
%>