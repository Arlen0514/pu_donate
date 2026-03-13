<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
// 適用於無限層類別選擇器 Design by Marco 20150302 
// 引用範例 window.open('category_selector.jsp?Back_id=_qposition&max_layer=2','_blank','height=260,width=400,top=50,left=300,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');" 


// 以下參數依專案需求可調整預設類別管理的資料表、欄位，以及回傳父表單的相關欄位
String DBName = StringTool.validString(request.getParameter("DBName"),"down_menu");						// 類別管理存取的資料表
String DBId = StringTool.validString(request.getParameter("DBId"),"dm");								// 類別管理存取的資料表欄位前綴詞
String Back_id = StringTool.validString(request.getParameter("Back_id"),"dm_id");						// 回傳至父視窗的類別 ID 承接欄位名稱
String Back_title = StringTool.validString(request.getParameter("Back_title"),"dm_title");				// 回傳至父視窗的類別 title 承接欄位名稱
String Back_category = StringTool.validString(request.getParameter("Back_category"));					// 回傳至父視窗的上層類別 ID 承接欄位名稱

// 一般性常用參數
String dm_code 		= StringTool.validString(request.getParameter("dm_code"),"product_category");		// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
String now_categary	= StringTool.validString(request.getParameter("now_categary"));						// 目前顯示類別的所屬上層類別 ID
String up_categary	= StringTool.validString(request.getParameter("up_categary"));						// 目前顯示類別的所屬上上層類別 ID ， 以利回上層類別時使用
Integer now_layer	= Integer.parseInt(StringTool.validString(request.getParameter("now_layer"),"1"));	// 目前顯示類別所在的層級數
Integer max_layer	= Integer.parseInt(StringTool.validString(request.getParameter("max_layer"),"2"));	// 設定最大層級數 , 預設值為 2 層
String event_code 	= StringTool.validString(request.getParameter("event_code"));						// 事件代碼 , (U:回到上一層類別  D:到下一層類別  R:重新查詢)
String css_type 	= StringTool.validString(request.getParameter("css_type"), "web");					// 本視窗引用的底色 CSS

// 讀取目前層級欲顯示的所有類別資料
Vector dms = app_sm.selectAll(DBName, DBId+"_code=? AND "+DBId+"_lang=? AND "+DBId+"_category=?", new Object[]{ dm_code , lang , now_categary }, DBId+"_showseq ASC, "+DBId+"_createdate DESC");
if("U".equals(event_code)) {
	TableRecord dm = (TableRecord) dms.get(0);
	up_categary = dm.getString(DBId+"_category");
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=app_mistitle %></title>
<link rel="stylesheet" type="text/css" href="../css/adm_css.css" />
<%@include file="../../../JQuery/jquery.jsp" %>
<script language="JavaScript" type="text/JavaScript">
function changebutton(val) {
	<%=(now_layer != max_layer)?"document.frm.down.disabled = '';":"" %>
	<%=(now_layer == max_layer)?"document.frm.pick.disabled = ''":"" %>

	<%
	for(int i = 0; i < dms.size(); i++) {
		TableRecord dm = (TableRecord) dms.get(i);
		Integer chk_size = app_sm.selectAll(DBName, DBId+"_code=? AND "+DBId+"_lang=? AND "+DBId+"_category=?", 
				new Object[]{ dm_code , lang , dm.getString(DBId+"_id") }).size();
		if(chk_size == 0) {
	%>	
	if(val == "<%=dm.getString(DBId+"_id") %>") {
		document.frm.down.disabled = "disabled"; 
		return;
	}
	<%
		}
	}
	%>
}

function goUp(F) {
	document.frm.event_code.value = "U";
	document.frm.now_categary.value = "<%=up_categary %>";
	document.frm.now_layer.value = "<%=now_layer - 1 %>";
	F.submit();	
}

function goDown(F) {
	document.frm.event_code.value = "D";
	document.frm.now_categary.value = document.frm.select_id.value;
	document.frm.up_categary.value = "<%=now_categary %>";
	document.frm.now_layer.value = "<%=now_layer + 1 %>";
	F.submit();
}

function goPick(F) {
	<%
	TableRecord category1 = app_sm.select(DBName, DBId+"_code=? AND "+DBId+"_lang=? AND "+DBId+"_id=?",
			new Object[]{ dm_code , lang , now_categary }, DBId+"_showseq ASC, "+DBId+"_createdate DESC");
	
	String title1=category1.getString(DBId+"_title");
	%>
	window.opener.$("#<%=Back_title %>").html('<%=title1%>--'+$("#select_id :selected").text());
	window.opener.$("#<%=Back_id%>").val($("#select_id").val());
	<%-- 用來判斷是否需回傳上層目錄代號的值 --%>
	<%if(!"".equals(Back_category)) { %>
	window.opener.$("#<%=Back_category %>").val('<%=now_categary %>');
	<%} %>
	self.close();
}

function goReload(F) {
	document.frm.event_code.value = "R";
	document.frm.now_categary.value = "";
	document.frm.up_categary.value = "";
	document.frm.now_layer.value = "1";
	F.submit();
}
</script>
</head>
<body class="<%=css_type%>_table-2-1">
<form name="frm" id="frm" method="post" action="<%=request.getRequestURI()%>">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
  		<tr class="<%=css_type%>_table-2-1" height="10px"> </tr>
  		<tr class="<%=css_type%>_table-2-1">
    		<td width="2%"> </td>
    		<td width="72%" align="center">
    			<select id="select_id" size="12" style="width:100%;" onchange="changebutton(this.value);" >
    				<%
    				for(int i=0; i<dms.size(); i++){
	            		TableRecord dm = (TableRecord) dms.get(i);
	      			%>
	    			<option value="<%=dm.getString(DBId+"_id") %>"><%=dm.getString(DBId+"_title") %></option>
	     			<%} %>
    			</select>
    		</td>
    		<td width="2%"></td>
    		<td width="20%" align="center">
        		<input type="hidden" name="DBName" id="DBName" value="<%=DBName %>" />
        		<input type="hidden" name="DBId" id="DBId" value="<%=DBId %>" />
        		<input type="hidden" name="Back_id" id="Back_id" value="<%=Back_id %>" />
        		<input type="hidden" name="Back_title" id="Back_title" value="<%=Back_title %>" />
        		<input type="hidden" name="Back_category" id="Back_category" value="<%=Back_category %>" />
     			<input type="hidden" name="dm_code" id="dm_code" value="<%=dm_code %>" />
     			<input type="hidden" name="event_code" id="event_code" value="<%=event_code %>" />
       			<input type="hidden" name="now_categary" id="now_categary" value="<%=now_categary %>" />
       			<input type="hidden" name="up_categary" id="up_categary" value="<%=up_categary %>" />
       			<input type="hidden" name="now_layer" id="now_layer" value="<%=now_layer %>" />
       			<input type="hidden" name="max_layer" id="max_layer" value="<%=max_layer %>" />
				<input type="hidden" name="css_type" id="css_type" value="<%=css_type %>" />

				<input name="up" type="button" value="↑↑上層↑↑" <%=(now_layer == 1)?"disabled":"" %> onclick="goUp(this.form);"><br/><br/>
				<input name="down" type="button" value="↓↓下層↓↓" disabled onclick="goDown(this.form);"><br/><br/>
				<input name="pick" type="button" value="選取類別" disabled onclick="goPick(this.form);" ><br/><br/><br/><br/>
				<input name="reload" type="button" value="重新查詢" <%=(now_layer == 1)?"disabled":"" %> onclick="goReload(this.form);" ><br/><br/>
				<input name="close" type="button" value="關閉視窗" onclick="window.close();">
    		</td>
    		<td width="2%"></td>
  		</tr>
  		<tr class="<%=css_type%>_table-2-1">
    		<td width="2%"> </td>
    		<td align="left" style="font-size: 8px;"><br/>目前為第 <%=now_layer %> / <%=max_layer %> 層</td>
  		</tr>
	</table>
</form>
</body>
</html>