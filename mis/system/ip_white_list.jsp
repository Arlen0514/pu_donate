<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	//基本參數
	String code = "ip_white_list"; 				// 模組識別碼
	String show_title = "登入IP白名單設定";		// 模組標題
	
	// 功能參數
	boolean list_switch = false;				// 是否開啟列表功能
	boolean sort_switch = false;				// 是否開啟排序功能
	boolean modify_switch = true;				// 是否開啟修改功能	
	int add_num = -1;							// 設定可新增的資料筆數 , -1 為無限筆
	int del_num = -1;							// 設定少於幾筆不可刪除 , -1 為無限制
/*--------------------------------------------------------------------------------*/
	Vector ics = app_sm.selectAll(tblic,"ic_code=?", new Object[]{ code }, "ic_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num, ics);
	// 當資料筆數小於設定可刪除的筆數時 , 隱藏刪除按鍵
	boolean delete_switch = num_check(del_num, ics);

	// 跳頁參數
	String[] names = new String[] { "npage" };
	String[] values = new String[] { String.valueOf(pageno) };

	// 回列表頁
	out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="include/head.jsp"%>
<script>
	function goaction(F, JSP) {
		if(F.ic_ip.value == "") {
		   	alert("請輸入IP位置!!");
		   	F.ic_ip.focus();
		} else {
			F.action = JSP;
			F.submit();
		}
	}
	function godelete(FORM, JSP) {
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
					<td width="60" align="left" valign="middle">
						<img src="../images/system_icon_1.gif" width="55" height="48" />
					</td>
					<td align="left" valign="middle" class="system_bigword">
						<%=show_title%>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<hr size="1" noshade />
					</td>
				</tr>
				<tr align="center">
					<td colspan="2"><table width="95%" border="0" cellspacing="1" cellpadding="0">
						<tr>
							<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
								<tr align="center">
									<td colspan="3" class="system_title-1">
										<%=show_title%>&nbsp;&nbsp;
										<%if (list_switch) { %>
										<input type="button" value="<%=show_title%>列表" onclick="javascript:location.href='<%=code%>.jsp'" />&nbsp;&nbsp;
										<%} %>
										<%if (sort_switch) { %>
										<input type="button" value="<%=show_title%>排序" onclick="javascript:location.href='<%=code%>_sort.jsp'" />
										<%} %>
										<input type="button" value="回到系統環境設定" onclick="javascript:location.href='websetup_c.jsp'" />&nbsp;&nbsp;
									</td>
								</tr>
								<tr align="center" class="system_bk-2">
									<td colspan="3" align="center" class="tablebg"><%=show_title %>列表</td>
								</tr>
								<tr align="center" class="system_table-2-1">
									<td width="10%" align="center">編號</td>
									<td width="70%" align="center"><%=show_title%>名稱</td>								
									<td width="20%" align="center">功能</td>
								</tr>
								<%if (add_switch) { %>
<form name="formA" method="post">
								<tr class="system_table-2-1">
									<td align="center"></td>
									<td align="left">
										<div align="center">
											<input name="ic_ip" type="text" value="" size="50" maxlength="120" />
										</div>
									</td>
									<td align="left">
										<div align="center">
											<input name="add" type="button" value="新增" onClick="goaction(this.form, '<%=code%>_update.jsp?action=A');" />
										</div>
									</td>
								</tr>
</form>
								<%} %>
								<%
								for (int i = 0; i < ics.size(); i++) {
									TableRecord ic = (TableRecord) ics.get(i);
								%>
<form name="form<%=i + 1%>" method="post">
								<tr class="system_table-2-1">
									<td align="center"><%=i + 1 %></td>
									<td align="left">
										<div align="center">
											<input name="ic_ip" type="text" value="<%=ic.getString("ic_ip") %>" size="50" maxlength="120" />
										</div>
									</td>
									<td align="left">
										<div align="center">
											<%if (modify_switch) { %>
											<input name="modify<%=i + 1%>" type="button" value="修改" onClick="goaction(this.form, '<%=code%>_update.jsp?action=M&ic_id=<%=ic.getString("ic_id")%>');">
											<%} %>
											<%if (delete_switch) { %>
											<input name="delete<%=i + 1%>" type="button" value="刪除" onClick="godelete(this.form, '<%=code%>_update.jsp?action=D&ic_id=<%=ic.getString("ic_id")%>');">
											<%} %>
										</div>
									</td>
								</tr>
</form>
								<%} %>
							</table></td>
						</tr>
					</table></td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2" class="system_bk-2b">&nbsp;</td>
				</tr>
			</table></td>
		</tr>
	</table>
</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>