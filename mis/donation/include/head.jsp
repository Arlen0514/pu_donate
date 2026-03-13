<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta name="theme-color" content="#666666">
<meta name="format-detection" content="telephone=no">
<%-- =============META============= --%>
<%--不允許檢索--%>
<%@include file="/WEB-INF/jspf/norobots.jspf"%>
<%-- =============CSS============= --%>
<%--後台用css--%>
<link rel="stylesheet" type="text/css" href="../css/adm_css.css" />
<link rel="stylesheet" type="text/css" href="../css/style.css" />
<link rel="stylesheet" type="text/css" href="../css/default_frame_css.css" />
<link rel="stylesheet" type="text/css" href="../css/default_content_css.css" />

<link href="https://fonts.googleapis.com/css2?family=Material+Icons"            rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js" type="text/javascript"></script>
<script src="https://code.jquery.com/jquery-migrate-3.4.0.min.js" type="text/javascript"></script>
<script src="../js/common.js" type="text/javascript"></script>

<link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<%-- =============SCRIPT============= --%>
<%--jquery--%>
<%@include file="../../../JQuery/jquery.jsp"%>
<%--萬年曆--%>
<%@include file="../../../JQuery/include_date.jsp"%>

<title><%=app_mistitle%></title>
    <style>
        /*全站共用樣式*/
        :root {
            --active_color:<%=app_ctmf.getString("mf_bgcolor2") %>; /*全站當前模式色碼*/
        }
    </style>
    