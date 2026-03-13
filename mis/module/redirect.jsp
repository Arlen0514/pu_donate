<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	// 基本參數
	String code 		= "redirect"; 			// 模組識別碼 , 於資料庫做資料識別用
	String page_code	= "redirect";			// 功能識別碼 , 於模組程式檔名用
	String show_title 	= "短網址設定";				// 功能標題

	Vector <TableRecord> rrs = app_sm.selectAll(tblrr, "rr_code = ? ", new Object[] { code }, "rr_createdate DESC");
%>
<html>
<head>
<%@include file="include/head.jsp"%>
<script language="JavaScript" type="text/JavaScript">
function checkform(F) {
		//驗證中文
		var chnese_chk = /[\u4e00-\u9fa5]/;
		
		if(F.rr_title == ""){
			alert("請輸入短網址代號 !");
			F.rr_title.focus();
		<%--
		}else if(chnese_chk.test(F.rr_title.value)){
			alert("短網址代號請勿使用中文 !");
			F.rr_title.focus();
		--%>
		}else if(F.rr_url == ""){
			alert("請輸入短網址欲對應網址 !");
			F.rr_url.focus();
		}else {
			return true;
		}
        return false;
}

function goaction(FORM,JSP){
	//驗證中文
	var chnese_chk = /[\u4e00-\u9fa5]/;
	
	if(FORM.rr_title.value == ""){
		alert("請輸入短網址代號 !");
		FORM.rr_title.focus();
	<%--
	}else if(chnese_chk.test(FORM.rr_title.value)){
		alert("短網址代號請勿使用中文 !");
		FORM.rr_title.focus();
	--%>		
	}else if(FORM.rr_url.value == ""){
		alert("請輸入短網址欲對應網址 !");
		FORM.rr_url.focus();
	}else {
	    FORM.action = JSP;
	    FORM.submit();
	}
    return false;
}

function godelete(FORM,JSP){
    if (confirm("確定刪除嗎？")) {
        FORM.action = JSP;
        FORM.submit();
    }
}
</script>
</head>
<%-- 20250331 modify Miles top menu.jsp  改成 RWD --%>    
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
      
      		<td width="99%" align="center" valign="top" class="system_bk-2p right_content_style"><table width="99%" border="0" cellspacing="0" cellpadding="0">
<%-- 20250331 modify Miles top menu.jsp  改成 RWD --%>      		
          <tr>
            <td colspan="2" class="system_bk-2b">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td width="60" align="left" valign="middle"><img src="../images/system_icon_1.gif" width="55" height="48" /></td>
            <td align="left" valign="middle" class="system_bigword"><%=show_title %></td>
          </tr>
          <tr>
            <td colspan="2"><hr size="1" noshade></td>
          </tr>
          <tr align="center">
            <td colspan="2"><table width="95%"  border="0" cellspacing="1" cellpadding="0">
              <tr>
                <td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
                    <tr align="center">
						<td colspan="4" class="system_title-1">
                      		<span><%=show_title %></span>&nbsp;&nbsp;
                      	</td>
                    </tr>
                    <tr align="center" class="system_table-2-1">
                      <td colspan="6" class="system_table-2-1"><strong><%=show_title %>說明</strong>（當使用者輸入 <B>www.domain.com.tw / 短網址代號</B> 時，則自動轉址至對應網址 ）</td>
                    </tr>                    
                    <tr align="center" class="system_bk-2">
                      <td colspan="4" align="center" class="tablebg"><%=show_title %>列表</td>
                    </tr>
                    <tr align="center" class="system_table-2-1">
                      <td width="10%" align="center">編號</td>
					  <td width="15%" align="center">短網址代號</td>
                      <td width="55%" align="center">欲對應網址</td>
                      <td width="20%" align="center">功能</td>
                    </tr>
                    
<form name="formA" method="post">
  <input type="hidden" name="rr_code" value="<%=code %>">
                    <tr class="system_table-2-1">
                      <td align="center"></td>
                      <td align="center">
                      	<input name="rr_title" type="text" value="" size="10"/>
                      </td>
                      <td align="center">
                      	<input name="rr_url" type="text" value="" size="70"/>
                      </td>                      
                      <td align="center">
                        <input name="add" type="button" value="新增" onClick="goaction(this.form, '<%=page_code%>_update.jsp?action=A');">
                      </td>
                    </tr>
</form>                    
<%for (int i = 0; i < rrs.size(); i++) {
       TableRecord rr = rrs.get(i);
%>
<form name="form<%=i+1%>" method="post">
  <input type="hidden" name="rr_id" value="<%=rr.getString("rr_id")%>">
  <input type="hidden" name="rr_code" value="<%=rr.getString("rr_code")%>">
                    <tr class="system_table-2-1">
                      <td align="center"><%=i+1 %></td>
                      <td align="center">
                      		<input name="rr_title" type="text" value="<%=rr.getString("rr_title")%>" size="10"/>
                      </td>
                      <td align="center">
                      		<input name="rr_url" type="text" value="<%=rr.getString("rr_url")%>" size="70"/>
                      </td>
                      <td align="center" >
                        <input name="modify<%=i+1%>" type="button" value="修改" onClick="goaction(this.form, '<%=page_code%>_update.jsp?action=M');">
                        <input name="modify<%=i+1%>" type="button" value="刪除" onClick="godelete(this.form, '<%=page_code%>_update.jsp?action=D');">
                      </td>
                    </tr>
</form>
<% } %>
                </table></td>
              </tr>
            </table>
            </td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" class="system_bk-2b">&nbsp;</td>
          </tr>
        </table>
      <!-- InstanceEndEditable --></td>
    </tr>
  </table>
</div>
</body>
<!-- InstanceEnd --></html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>