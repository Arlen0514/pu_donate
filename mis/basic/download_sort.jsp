<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	//基本參數
	String code = "download"; 				// 模組識別碼
	String show_title = "表單下載維護";			// 模組標題
	
	// 功能參數
	boolean list_switch = true;		// 是否開啟列表功能
	boolean sort_switch = true;		// 是否開啟排序功能
	int add_num = -1;				// 設定可新增的資料筆數 , -1 為無限筆
	int category_num = 1;		    // 設定類別層數 2層以上使用選擇器 一層使用下拉選單即可
/*------------------------------------------------------------------------------------*/
	Vector fds = app_sm.selectAll(tblfd, "fd_code=? and fd_lang=?", new Object[] { code, lang }, "fd_showseq ASC , " + "fd_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,fds);
	
	// 搜尋欄位
	String qcategory = StringTool.validString(request.getParameter("_qcategory"));
	String qupcategory = StringTool.validString(request.getParameter("_qupcategory"));
	fds = app_sm.selectAll(tblfd, "fd_code=? and fd_lang=? and fd_category=?", new Object[] { code,lang,qcategory }, "fd_showseq ASC , fd_createdate DESC");
		
	//所屬類別系列標題
	String title1=app_sm.select(tbldm,qupcategory).getString("dm_title");
	String title2=app_sm.select(tbldm,qcategory).getString("dm_title");
	
	//所屬類別
	Vector<TableRecord> dms = app_sm.selectAll(tbldm, "dm_lang=? and dm_code=? and dm_category=?", new Object[]{ lang, code+"_category", "" } , "dm_showseq ASC , dm_createdate DESC");
	
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
								<td align="center" colspan="4" class="web_title-1"><%=show_title%>&nbsp;&nbsp;
									<%if (add_switch) { %>
									<input type="button" value="新增資料" onclick="javascript:location.href='<%=code%>_a.jsp'" />&nbsp;
									<%} %>
									<%if (list_switch) { %>
									<input type="button" value="回到列表" onclick="javascript:location.href='<%=code%>.jsp'" />&nbsp;
									<%} %>
									<%if (sort_switch) { %>
									<input type="button" value="資料排序" onclick="javascript:location.href='<%=code%>_sort.jsp'" />
									<%} %>
								</td>
							</tr>
		
							<tr align="center" class="web_bk-2">
								<td colspan="4" align="center">標題順序調整</td>
							</tr>
							<form name="form0" id="form0" method="post" action="<%=code%>_sort.jsp">
							<tr class="web_table-2-1">
								<td width="85%" align="center">		
											請選擇欲排序的類別&nbsp; : &nbsp;
										<% if(category_num<=1){ %>
										<select name="_qcategory" id="_qcategory" style="min-width: 100px;" onchange="form0.submit();">
											<%if("".equals(qcategory)) {%>
						    		        <option value="%">請選擇...</option>
						    		        <%} %>
				                  			<% 
				                  			for(int i=0; i<dms.size(); i++){
					                  			TableRecord dm = (TableRecord) dms.get(i);
					                  		%>
					                  		<option value="<%=dm.getString("dm_id") %>" <%=dm.getString("dm_id").equals(qcategory)?"selected":"" %>><%=dm.getString("dm_title") %></option>
				                	        <% } %>
				                	    </select>
					                	<% }else{  //2層以上 類別選擇器 %>
											<span id="dm_title" style="color:#FA0300;"><%=!"".equals(qcategory)?title1+"--"+title2:""%></span>&nbsp;&nbsp;
				                  			<input type="hidden" name="_qupcategory" id="_qupcategory" value="<%=qupcategory%>" />
											<input type="hidden" name="_qcategory" id="_qcategory" value="<%=qcategory %>" />
				                  			<input type="button" value="選擇類別" onclick="window.open('../mis_tools/category_selector.jsp?Back_id=_qcategory&Back_category=_qupcategory&max_layer=<%=category_num %>&dm_code=<%=code%>_category','_blank','height=260,width=400,top=50,left=300,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');" />
											<input type="submit" value="查詢">
										<% } %>
										<%--2層 optgroup
										 所屬類別：<select name="_qcategory" id="_qcategory" onchange="form0.submit();">
										<option value="">請選擇類別</option>
										<%for(TableRecord dm : dms){ %>
										<optgroup label="<%=dm.getString("dm_title")%>">
											<%
												Vector<TableRecord> sub_dms = app_sm.selectAll(tbldm,"dm_code=? and dm_lang=? and dm_category=?",new Object[]{code,lang,dm.getString("dm_id")});
												for(TableRecord sub_dm : sub_dms){ 
											%>
											<option value="<%=sub_dm.getString("dm_id")%>" <%=sub_dm.getString("dm_id").equals(qcategory)?"selected":"" %>><%=sub_dm.getString("dm_title")%></option>
											<%} %>
										</optgroup>
										<%} %>
									</select>
									--%>
								</td>
								<td width="15%" align="center" colspan="3">功能</td>
							</tr>
							</form>
							<form name="frm" id="frm" method="post" enctype="multipart/form-data" action="<%=code%>_update.jsp?action=S&_qcategory=<%=qcategory %>&_qupcategory=<%=qupcategory %>" onsubmit="javascript:return checkformsequ(this);">
							<tr class="web_table-2-1">
								<td class="web_table-2-1" align="left"><select
									name="left_select" id="left_select" multiple="multiple"
									style="width: 660px;" size="15">
									<%
										for (int i = 0; i < fds.size(); i++) {
											TableRecord fd = (TableRecord) fds.get(i);
									%>
									<option value="<%=fd.getString("fd_id")%>"><%=fd.getString("fd_title")%></option>
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