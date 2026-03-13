<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
// 相關參數設定
String code = StringTool.validString(request.getParameter("code"));	// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用

String mf_upfunction = StringTool.validString(request.getParameter("mf_upfunction"));
int mf_type = Integer.parseInt(StringTool.validString(request.getParameter("mf_type"),"0"))+1;

String show_title 	= "系統功能設定";			// 功能標題
/*
if ("".equals(mf_upfunction)) {
	show_title += "標籤";
}
*/

Vector mfs = app_sm.selectAll(tblmf, "mf_upfunction=? AND mf_type=?", new String[]{mf_upfunction, String.valueOf(mf_type)}, "mf_priority");

%>
<html>
<head>
<%@include file="include/head.jsp"%>
<script language="JavaScript" type="text/JavaScript">
function checkform(F) {
	// var file_chk = /([^\/]+\.(?:jpg|jpeg|gif|png))/;//驗證副檔名

	return true;
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
          
<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="menu_update.jsp?action=S&code=<%=code %>&mf_upfunction=<%=mf_upfunction %>&mf_type=<%=mf_type-1 %>" onsubmit="javascript:return checkformsequ(this);">

		<td align="center" colspan="2"><table width="95%"  border="0" cellspacing="1" cellpadding="0">
			<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
				  <tr>
		    	    <td align="center" colspan="4" class="system_title-1">
                    	<span class="system_title-1"><%=show_title %></span>&nbsp;&nbsp;
                    	<%if ("".equals(mf_upfunction)) { %>
	                        <span><input type="button" value="新增" onclick="javascript:location.href='menu_a.jsp'" /></span>&nbsp;
	            			<span><input type="button" value="列表" onclick="javascript:location.href='menu.jsp'" /></span>&nbsp;
							<input type="button" value="排序" onclick="javascript:location.href='menu_sort.jsp?code=<%=code %>'" />
						<%} else { %>
                        	<span><input type="button" value="<%=(2==mf_type)?"回選單標籤設定":"回上層選單設定" %>" onclick="javascript:location.href='<%=(2 == mf_type)?"menu.jsp":"menu_sub.jsp?mf_upfunction="+app_sm.select(tblmf,mf_upfunction).getString("mf_upfunction")+"&mf_type="+String.valueOf(mf_type-2) %>'" /></span>&nbsp;
            				<span><input type="button" value="列表" onclick="javascript:location.href='menu_sub.jsp?mf_upfunction=<%=mf_upfunction %>&mf_type=<%=mf_type-1 %>'" /></span>&nbsp;
							<input type="button" value="排序" onclick="javascript:location.href='menu_sort.jsp?code=<%=code %>&mf_upfunction=<%=mf_upfunction %>&mf_type=<%=mf_type-1 %>'" />
						<%} %>
				    </td>
			       </tr>         
		

				  <tr align="center" class="system_bk-2">
				    <td colspan="4" align="center">選單順序調整</td>
				  </tr>
				  <tr class="system_table-2-1">
				    <td width="85%" align="center">選單功能名稱列表</td>
				    <td width="15%" align="center" colspan="3">功能</td>
				  </tr>
				  <tr class="system_table-2-1">
				    <td class="system_table-2-1" align="left">
					    <select name="left_select" id="left_select" multiple="multiple" style="width: 660px;" size="15">
					    <%for(int i=0;i<mfs.size();i++){ 
					    	TableRecord mf = (TableRecord)mfs.get(i);%>
					    	<option value="<%=mf.getString("mf_id") %>"><%=mf.getString("mf_name") %></option>
					    <%} %>
					    </select>
				    </td>
				    <td class="system_table-2-1" align="center" colspan="3">
				    	<input type="hidden" name="selData" id="selData" value="" >
				    	<input type="button" id="select_up" value="↑↑上移↑↑" /><br /><br />
						<input type="button" id="select_down" value="↓↓下移↓↓" /><br /><br />
						<input type="submit" value="儲存設定"></td>
				  </tr>
				<script type="text/JavaScript">
				$(document).ready(function(){
				    $("#select_down").click(function(){
				        var $op = $('#left_select option:selected'),
				            $this = $(this);
				        if($op.length){
				            ($this.val() == 'Up') ? 
				                $op.first().prev().before($op) : 
				                $op.last().next().after($op);
				        }
				    });
				    $("#select_up").click(function(){
				        var $op = $('#left_select option:selected'),
				            $this = $(this);
				        if($op.length){
				            ($this.val() == 'Down') ?                
				                $op.last().next().after($op):
				                $op.first().prev().before($op);
				        }
				    });    
				});
				
				function checkformsequ(F){
					var varStr = ""; 
					$("#left_select option").each(function(){
					varStr += $(this).val() + ",";
					});
					$("#selData").val(varStr);
				}
				</script>
		      <!-- InstanceEndEditable -->
			</table></td>
		</table></td>

</form>

		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3" class="system_bk-2b">&nbsp;</td>
		</tr>

</table></td>
</div>
</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>
