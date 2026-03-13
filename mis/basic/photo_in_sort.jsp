<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%

	// 上層基本參數
	String ap_category = StringTool.validString(request.getParameter("ap_category")); // 所屬上層相簿代號
	String back_code = "photo"; // 上層模組識別碼

	// 若無上層資訊 , 則自動回上層列表頁
	if("".equals(ap_category)){
		out.println("<script> location='"+back_code+".jsp'; </script>");
	}
	
	// 基本參數
	String code = "photo_in"; 									// 模組識別碼
	TableRecord apCode= app_sm.select(tblap,ap_category); 			// 所屬相簿資料
	String show_title = apCode.getString("ap_title")+"-相片";	// 模組標題	

	// 功能參數
	boolean list_switch = true;		// 是否開啟列表功能
	boolean sort_switch = true;		// 是否開啟排序功能
	int add_num = -1;				// 設定可新增的資料筆數 , -1 為無限筆
/*--------------------------------------------------------------------------------------------*/
	Vector aps = app_sm.selectAll(tblap, "ap_category=? and ap_code=? and ap_lang=?", new Object[] { ap_category, code, lang }, "ap_showseq ASC , ap_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,aps);
	
	// 跳頁參數
	String[] names = new String[] { "npage", "ap_category"};
	String[] values = new String[] { String.valueOf(pageno), ap_category};

	// 回列表頁
	out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
	// 回排序頁
	out.write(HtmlCoder.getForm("sortpage", code + "_sort.jsp", names, values));
	// 新增頁
	out.write(HtmlCoder.getForm("addpage", code + "_a.jsp", names, values));
	
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
				<td colspan="2" class="web_bk-2b">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td width="60" align="left" valign="middle"><img
					src="../images/web_icon_1.gif" width="55" height="48"></td>
				<td align="left" valign="middle" class="web_bigword"><%=show_title%></td>
			</tr>
			<tr>
				<td colspan="2">
				<hr size="1" noshade>
				</td>
			</tr>
			<tr>
				
				<td align="center" colspan="2">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<tr>
						<td class="system_bk-2bk">
						<table width="100%" border="0" align="center" cellpadding="3"
							cellspacing="1">
							<tr>
								<td align="center" colspan="3" class="web_title-1"><%=show_title%>&nbsp;&nbsp;
									<%if (add_switch) { %>
									<input type="button" value="新增相片" onclick="addpage.submit();" />&nbsp;
									<%} %>
									<%if (list_switch) { %>
									<input type="button" value="回到相片列表" onclick="listpage.submit()" />&nbsp;
									<%} %>
									<%if (sort_switch) { %>
									<input type="button" value="相片排序" onclick="sortpage.submit();" />
									<%} %>
								</td>
								<td align="center" class="web_title-1">
									<input type="button" value="回到相簿列表" onclick="javascript:location.href='<%=back_code%>.jsp'" />&nbsp;
								</td>
							</tr>
		
							<tr align="center" class="web_bk-2">
								<td colspan="4" align="center">標題順序調整</td>
							</tr>
							<tr class="web_table-2-1">
								<td width="85%" align="center">
									標題列表									
								</td>
								<td width="15%" align="center" colspan="3">功能</td>
							</tr>
							<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=S&ap_category=<%=ap_category %>" onsubmit="javascript:return checkformsequ(this);">
							<tr class="web_table-2-1">
								<td class="web_table-2-1" align="left"><select
									name="left_select" id="left_select" multiple="multiple"
									style="width: 660px;" size="15">
									<%
										for (int i = 0; i < aps.size(); i++) {
											TableRecord ap = (TableRecord) aps.get(i);
									%>
									<option value="<%=ap.getString("ap_id")%>"><%=ap.getString("ap_title")%></option>
									<%
										}
									%>
								</select></td>
								<td class="web_table-2-1" align="center" colspan="3">
									<input type="hidden" name="selData" id="selData" value=""> 
									<input type="button" id="select_up" value="↑↑上移↑↑" /><br /><br />
									<input type="button" id="select_down" value="↓↓下移↓↓" /><br /><br />
									<input type="button" id="all_down" value="至頂" /><br /><br />
									<input type="button" id="all_up" value="至底" /><br /><br />
									<input type="submit" value="儲存設定">
								</td>
							</tr>
							</form>
						</table>
						</td>
					</tr>
				</table>
				</td>	
				
			</tr>
			<tr>
				<td colspan="3">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="3" class="web_bk-2b">&nbsp;</td>
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