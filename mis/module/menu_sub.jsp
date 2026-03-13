<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	String code			= "menu_sub";			// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "系統功能設定";		// 功能標題
	String mf_upfunction = StringTool.validString(request.getParameter("mf_upfunction"));
	if("".equals(mf_upfunction)){
		out.println("<script> location='menu.jsp'; </script>");
	}
	int mf_type = Integer.parseInt(StringTool.validString(request.getParameter("mf_type"),"0"))+1;
	
	Vector mfs = app_sm.selectAll(tblmf, "mf_upfunction=? AND mf_type=?", new String[]{mf_upfunction, String.valueOf(mf_type)}, "mf_priority");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@include file="include/head.jsp"%>
<script language="JavaScript" type="text/JavaScript">
function checkform(F) {

	if($("#mf_name").val() == "") {
        alert("請輪入選單標籤名稱!!");
        F.mf_name.focus();
        return false;
    <%if(mf_type==3){%>    
	} else if($("#mf_url").val() == "") {
        alert("請輪入程式檔案名稱!!");
        F.mf_url.focus();
        return false; 
    <%}%>
	} else {
		return true;
	}
	
}

function goaction(FORM,JSP){
    FORM.action = JSP;
    FORM.submit();
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
            <td width="60" align="left" valign="middle"><img src="../images/system_icon_1.gif" width="55" height="48"></td>
            <td align="left" valign="middle" class="system_bigword"><%=show_title %></td>
          </tr>
          <tr>
            <td colspan="2"><hr size="1" noshade></td>
          </tr>
          <tr align="center">
            <td colspan="2"><table width="95%"  border="0" cellspacing="1" cellpadding="0">
                <tr>
                  <td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="2" cellspacing="1">
                      <tr align="center" class="system_title-1">
                        <td colspan="5" class="titlebg">
                        	<span class="system_title-1"><%=show_title %></span>&nbsp;&nbsp;
                        	<span><input type="button" value="<%=(2==mf_type)?"回選單標籤設定":"回上層選單設定" %>" onclick="javascript:location.href='<%=(2 == mf_type)?"menu.jsp":"menu_sub.jsp?mf_upfunction="+app_sm.select(tblmf,mf_upfunction).getString("mf_upfunction")+"&mf_type="+String.valueOf(mf_type-2) %>'" /></span>&nbsp;
            				<span><input type="button" value="列表" onclick="javascript:location.href='menu_sub.jsp?mf_upfunction=<%=mf_upfunction %>&mf_type=<%=mf_type-1 %>'" /></span>&nbsp;
							<input type="button" value="排序" onclick="javascript:location.href='menu_sort.jsp?code=<%=code %>&mf_upfunction=<%=mf_upfunction %>&mf_type=<%=mf_type-1 %>'" />
                        </td>
                      </tr>
                      <tr align="center" class="system_bk-2">
                        <td width="5%" class="tablebg">項次</td>
                        <td width="20%" class="tablebg">選單功能名稱</td>
                        <td width="30%" class="tablebg">程式檔案名稱</td>
                        <td width="15%" class="tablebg">顯示狀態</td>
                        <td width="30%"  class="tablebg"><div align="center">功能</div></td>
                      </tr>
                      
					<form name="form0" method="post" enctype="multipart/form-data" action="menu_update.jsp?action=A&code=<%=code %>" onsubmit="javascript:return checkform(this);">
                    <tr align="center" class="system_table-2-1">
                      <td align="center" ></td>
                        <td class="tablebg">&nbsp;<input name="mf_name" id="mf_name" type="text" value="" size="20" /></td>
                        <td class="tablebg">&nbsp;<input name="mf_url" id="mf_url" type="text" value="" size="36" /></td>
                        <td class="tablebg">
                        	<input type="radio" name="mf_status" value="N" checked />顯示
							<input type="radio" name="mf_status" value="H" />隱藏
						</td>
                      <td align="left" ><div align="center">
  						<input type="hidden" name="mf_upfunction" value="<%=mf_upfunction %>">
  						<input type="hidden" name="mf_type" value="<%=mf_type %>">
                        <input type="submit" value="新增" >
                      </div></td>
                    </tr>
					</form>                       
                      
					  <%for (int i = 0; i < mfs.size(); i++) {
					       TableRecord mf = (TableRecord)mfs.get(i);
					  %>
					  <script language="JavaScript" type="text/JavaScript">
					  <!--
					  function checkform<%=i+1 %>(F) {
						if($("#mf_name<%=i+1 %>").val() == "") {
					        alert("請輪入選單標籤名稱!!");
					        F.mf_name<%=i+1 %>.focus();
					        return false;
					    <%if(mf_type==3){%>    
						} else if($("#mf_url<%=i+1 %>").val() == "") {
					        alert("請輪入程式檔案名稱!!");
					        F.mf_url<%=i+1 %>.focus();
					        return false;
					    <%}%>
						} else {
							return true;
						}
					  }
					  //-->
					  </script>
					  <form name="form<%=i+1%>" method="post" action="menu_update.jsp?action=MS&code=<%=code %>" onsubmit="javascript:return checkform<%=i+1 %>(this);">
  						<input type="hidden" name="mf_id" value="<%=mf.getString("mf_id") %>">
  						<input type="hidden" name="code" value="<%=code %>">
                      <tr align="center" class="system_table-2-1">
                        <td class="tablebg"><%=i+1 %></td>
                        <td class="tablebg">&nbsp;<input name="mf_name" id="mf_name<%=i+1 %>" type="text" value="<%=mf.getString("mf_name") %>" size="20" /></td>
                        <td class="tablebg">&nbsp;<input name="mf_url" id="mf_url<%=i+1 %>" type="text" value="<%=mf.getString("mf_url") %>" size="36" /></td>
                        <td class="tablebg">
                        	<input type="radio" name="mf_status" value="N" <%="N".equals(mf.getString("mf_status"))?"checked":"" %> />顯示
							<input type="radio" name="mf_status" value="H" <%="H".equals(mf.getString("mf_status"))?"checked":"" %> />隱藏
						</td>
                        <td class="tablebg"><div align="center">
                          <input name="detail<%=i+1%>" type="<%=(mf_type==3)?"hidden":"button" %>"  value="下層選單設定" onClick="goaction(this.form, 'menu_sub.jsp?mf_upfunction=<%=mf.getString("mf_id") %>&mf_type=<%=mf_type %>');"  <%="".equals(mf.getString("mf_url"))?"":"Disabled" %>>                            
                          <input name="modify<%=i+1%>" type="submit"  value="修改" >                            
                          <input name="delete<%=i+1%>" type="button"  value="刪除" onClick="godelete(this.form, 'menu_update.jsp?action=D');">
                        </div></td>
                      </tr>
					  </form>
					  <% } %>
					  
                  </table></td></tr>
            </table>
            </td>
          </tr>
          <tr>
            <td colspan="2"><div align="center">
                <br>
</div></td>
          </tr>
          <tr>
            <td colspan="2" class="system_bk-2b">&nbsp;</td>
          </tr>
        </table>
        <p>&nbsp;</p>
      <!-- InstanceEndEditable --></td>
    </tr>
  </table>
</div>
</body>
<!-- InstanceEnd --></html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>