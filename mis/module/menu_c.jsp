<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	String code			= "menu";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "系統功能設定";			// 功能標題
	
	String mf_id = StringTool.validString(request.getParameter("mf_id"));
	TableRecord mf = app_sm.select(tblmf, mf_id);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@include file="include/head.jsp"%>
<%-- 色片選擇器特效結束 --%>
<script language="JavaScript" type="text/JavaScript">
function checkform(F) {
	if($("#mf_name").val() == "") {
        alert("請輪入選單標籤名稱!!");
        F.mf_name.focus();
        return false;
	} else if($("#mf_folder").val() == "") {
        alert("請輪入工作資料夾!!");
        F.mf_folder.focus();
        return false;
	} else if($("#mf_bgcolor1").val() == "") {
        alert("請輪入背景顏色 1 !!");
        F.mf_bgcolor1.focus();
        return false;
	} else if($("#mf_bgcolor2").val() == "") {
        alert("請輪入背景顏色 2 !!");
        F.mf_bgcolor2.focus();
        return false;
	} else {
		return true;
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
            <td width="60" align="left" valign="middle"><img src="../images/system_icon_1.gif" width="55" height="48"></td>
            <td align="left" valign="middle" class="system_bigword"><%=show_title %></td>
          </tr>
          <tr>
            <td colspan="2"><hr size="1" noshade></td>
          </tr>
<form name="form0" method="post" enctype="multipart/form-data" action="menu_update.jsp?action=M&code=<%=code %>&mf_id=<%=mf_id %>" onsubmit="javascript:return checkform(this);">
          
          <tr align="center">
            <td colspan="2"><table width="95%"  border="0" cellspacing="1" cellpadding="0">
                <tr>
                  <td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
                       <tr align="center" class="system_title-1">
	                     <td colspan="5" class="titlebg">
	                      	<span class="system_title-1"><%=show_title %></span>&nbsp;&nbsp;
	                       	<span><input type="button" value="新增" onclick="javascript:location.href='menu_a.jsp'" /></span>&nbsp;
	            			<span><input type="button" value="列表" onclick="javascript:location.href='menu.jsp'" /></span>&nbsp;
							<input type="button" value="排序" onclick="javascript:location.href='menu_sort.jsp?code=<%=code %>'" />
	                     </td>
                       </tr>
                        
                        <tr>
                          <td colspan="4" align="center" class="admini_bk-2">修改</td>
                        </tr>
                        <tr class="system_table-2-1">
                          <td width="10%" align="right" class="admini_bk-2">選單標籤名稱 :</td>
                          <td width="40%" align="left" class="system_table-2-1">&nbsp;<input name="mf_name" id="mf_name" type="text" size="36" value="<%=mf.getString("mf_name") %>"/></td>
                          <td width="10%" align="right" class="admini_bk-2">顯示狀態：</td>
                          <td width="40%" align="left" class="system_table-2-1">&nbsp;
                        	<input type="radio" name="mf_status" value="N" <%="N".equals(mf.getString("mf_status"))?"checked":"" %> />顯示
							<input type="radio" name="mf_status" value="H" <%="H".equals(mf.getString("mf_status"))?"checked":"" %>/>隱藏
                          </td>
                        </tr>
                        <tr class="system_table-2-1">
                          <td width="10%" align="right" class="admini_bk-2">工作資料夾：</td>
                          <td width="90%" colspan="3" align="left" class="system_table-2-1">&nbsp;<input name="mf_folder" id="mf_folder" type="text" size="36" value="<%=mf.getString("mf_folder") %>"/></td>
                        </tr>
                        <tr class="system_table-2-1">
                          <td width="10%" align="right" class="admini_bk-2">所屬顏色 :</td>
                          <td width="40%" align="left" class="system_table-2-1" colspan="3">&nbsp;
                          	<input name="mf_bgcolor2" id="mf_bgcolor2" type="color" size="10" value="<%=mf.getString("mf_bgcolor2") %>" style="width:50px;"/>
                          </td>
                        </tr>
                                                
                  </table>
                  </td>
                </tr>
              </table><br>
              <input type="submit" value="確定送出">&nbsp;
              <input type="reset"  value="還原修改">
              <input type="button" value="回上一頁" onclick="history.back(1);">
              </td>
          </tr>
</form>
          <tr>
            <td colspan="2"><div align="center"><br>
			</div></td>
          </tr>
          <tr>
            <td colspan="2" class="system_bk-2b">&nbsp;</td>
          </tr>
        </table>
        <!-- InstanceEndEditable --></td>
    </tr>
  </table>
</div>
</div>
</body>
<!-- InstanceEnd --></html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>