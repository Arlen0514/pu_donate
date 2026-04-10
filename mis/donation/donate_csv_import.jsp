<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	String code = "donate";
	String show_title = "捐款CSV匯入";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><%=app_mistitle%></title>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/norobots.jspf"%>
<script type="text/javascript">
function checkForm() {
	var fileName = $("#import_file").val();
	if(fileName == "") {
		alert("請選擇 CSV 檔案");
		return false;
	}
	var file_chk = /([^\/]+\.(?:csv))$/i;
	if(!file_chk.test(fileName)) {
		alert("僅允許上傳 .csv 檔案");
		return false;
	}
	$("#submitBtn").prop("disabled", true);
	return true;
}
</script>
</head>
<body class="default_body">
<div class="pageContent default_pageContent">
<div align="center" class="default_area">
  <table class="default_table" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td colspan="2">
      	<table border="0" cellspacing="0" cellpadding="0">
			<%@include file="/WEB-INF/jspf/mis/top.jspf"%>
      	</table>
      </td>
    </tr>
    <tr class="default_table_bottom page_mis">
      <td width="" align="center" valign="top" class="system_bk-2">
      		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<%@include file="../leftmenu.jsp"%>
      		</table>
      </td>
      <td width="99%" align="center" valign="top" class="system_bk-2p right_content_style">
        <table width="99%" border="0" cellspacing="0" cellpadding="0">
          <tr><td colspan="2" class="information_bk-2b">&nbsp;</td></tr>
          <tr><td colspan="2">&nbsp;</td></tr>
          <tr>
            <td width="60" align="left" valign="middle"><img src="../images/information_icon_1.gif" width="55" height="48"></td>
            <td align="left" valign="middle" class="information_bigword"><%=show_title %></td>
          </tr>
          <tr><td colspan="2"><hr size="1" noshade></td></tr>
          <tr>
            <td align="center" colspan="2">
              <table width="95%" border="0" cellspacing="1" cellpadding="0">
                <tr><td class="system_bk-2bk">
                  <table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
                    <tr>
                      <td align="center" class="information_title-1"><%=show_title%></td>
                    </tr>
                    <tr class="information_bk-2">
                      <td align="center">匯入格式需與「CSV匯出」欄位順序完全一致，且需為 UTF-8 BOM</td>
                    </tr>
                    <tr class="information_table-2-1">
                      <td align="center">
                        <form name="form0" method="post" enctype="multipart/form-data" action="<%=code%>_csv_import_update.jsp" onsubmit="return checkForm();">
                          <input type="file" name="import_file" id="import_file" />
                          <input type="submit" id="submitBtn" value="開始匯入" />
                          <input type="button" value="回捐款列表" onclick="location.href='<%=code%>.jsp';" />
                        </form>
                      </td>
                    </tr>
                  </table>
                </td></tr>
              </table>
            </td>
          </tr>
          <tr><td colspan="2">&nbsp;</td></tr>
          <tr><td colspan="2" class="information_bk-2b">&nbsp;</td></tr>
        </table>
      </td>
    </tr>
  </table>
</div>
</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>
