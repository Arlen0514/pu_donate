<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	
	// 基本參數
	String code = "currency"; 		// 模組識別碼
	String show_title = "捐款幣別設定";		// 模組標題
	
	// 功能參數
	boolean list_switch = true;		// 是否開啟列表功能
	boolean sort_switch = true;		// 是否開啟排序功能
	boolean modify_switch = true;	// 是否開啟修改功能
	int level_number =1;		    // 類別層數
/*--------------------------------------------------------------------------------*/		
	// 讀取上層類別 ID 、當前類別層數
	String qcategory = StringTool.validString(request.getParameter("_qcategory"));
	int now_level = Integer.parseInt(StringTool.validString(request.getParameter("now_level"), "1")); // 當前類別層數
	
	 // 上層類別
	String up_name = "";
	if (!"".equals(qcategory))up_name = app_sm.select(tbldm, qcategory).getString("dm_title") + "&nbsp;&nbsp;所屬類別&nbsp;&nbsp;";	
	TableRecord now_category = app_sm.select(tbldm, qcategory);
		
	Vector dms = app_sm.selectAll(tbldm, "dm_code=? and " + "dm_lang=? and dm_category=?", new Object[] { code, lang ,qcategory }, "dm_showseq ASC , " + "dm_createdate DESC");
	
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="include/head.jsp"%>
<script type="text/JavaScript">
$(document).ready(function() {
	$("#select_down").click(function() {
		var $op = $('#left_select option:selected'), $this = $(this);
		if ($op.length) {
			($this.val() == 'Up') ? $op.first().prev().before($op) : $op.last().next().after($op);
		}
	});
	$("#select_up").click(function() {
		var $op = $('#left_select option:selected'), $this = $(this);
		if ($op.length) {
			($this.val() == 'Down') ? $op.last().next().after($op) : $op.first().prev().before($op);
		}
	});
	$("#all_down").click(function(){
	    var $op = $('#left_select option:selected'),
	        $this = $(this);
	    if($op.length){
	    	$('#left_select option:selected').prependTo('#left_select')
	    }
	});
	$("#all_up").click(function(){
	    var $op = $('#left_select option:selected'),
	        $this = $(this);
	    if($op.length){
	    	$('#left_select option:selected').appendTo('#left_select')
	    }
	});	
});
function checkformsequ(F) {
	var varStr = "";
	$("#left_select option").each( function() {
		// add $(this).val() to your list
			varStr += $(this).val() + ",";
			//alert(  $(this).val());
		});
	//alert(varStr);
	$("#selData").val(varStr);
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
				<td colspan="2" class="information_bk-2b">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td width="60" align="left" valign="middle"><img
					src="../images/information_icon_1.gif" width="55" height="48"></td>
				<td align="left" valign="middle" class="information_bigword"><%=show_title%></td>
			</tr>
			<tr>
				<td colspan="2">
				<hr size="1" noshade>
				</td>
			</tr>

			<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=S&_qcategory=<%=qcategory%>&now_level=<%=now_level%>" onsubmit="javascript:return checkformsequ(this);">
			<td align="center" colspan="2">
			<table width="95%" border="0" cellspacing="1" cellpadding="0">
				<td class="system_bk-2bk">
				<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
					<tr align="center">
						<td colspan="<%="".equals(qcategory) ? "3" : "2"%>" class="information_title-1">
							<%=show_title%>&nbsp;&nbsp;
							<%if (list_switch) { %>
								<input type="button" value="<%=show_title%>列表" onclick="javascript:location.href='<%=code%>.jsp?_qcategory=<%=qcategory%>&now_level=<%=now_level%>'" />&nbsp;&nbsp;
							<%} %>
							<%if (sort_switch) { %>
							<input type="button" value="<%=show_title%>排序" onclick="javascript:location.href='<%=code%>_sort.jsp?_qcategory=<%=qcategory%>&now_level=<%=now_level%>'" />
							<%} %>
						</td>
						<%if (!"".equals(qcategory)) { %>
						<td class="information_title-1">
							<input type="button" value="回上層類別列表" onclick="javascript:location.href='<%=code%>.jsp?_qcategory=<%=now_category.getString("dm_category")%>&now_level=<%=now_level-1%>'" />
						</td>
						<%} %>
					</tr>
					<tr align="center" class="information_bk-2">
						<td colspan="4" align="center"><%=show_title%>順序調整</td>
					</tr>
					<tr class="information_table-2-1">
						<td width="85%" align="center"><%=up_name + show_title%>列表</td>
						<td width="15%" align="center" colspan="3">功能</td>
					</tr>
					<tr class="information_table-2-1">
						<td class="information_table-2-1" align="left">
							<select name="left_select" id="left_select" multiple="multiple" style="width: 660px;" size="15">
								<%
									for (int i = 0; i < dms.size(); i++) {
										TableRecord dm = (TableRecord) dms.get(i);
								%>
								<option value="<%=dm.getString("dm_id")%>"><%=dm.getString("dm_title")%></option>
								<%
									}
								%>
							</select>
						</td>
						<td class="information_table-2-1" align="center" colspan="3">
							<input type="hidden" name="selData" id="selData" value=""> 
							<input type="button" id="select_up" value="↑↑上移↑↑" /><br /><br />
							<input type="button" id="select_down" value="↓↓下移↓↓" /><br /><br />
							<input type="button" id="all_down" value="至頂" /><br /><br />
							<input type="button" id="all_up" value="至底" /><br /><br />
							<input type="submit" value="儲存設定">
						</td>
					</tr>
				</table>
				</td>
			</table>
			</td>

			</form>

			<tr>
				<td colspan="3">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="3" class="information_bk-2b">&nbsp;</td>
			</tr>

		</table>
		</td>
		</tr>
	</table>
		
</div>
</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>