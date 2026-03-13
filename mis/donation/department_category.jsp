<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 基本參數
	String code = "department_category"; 		// 模組識別碼
	String show_title = "院系募款系所維護";			// 模組標題
	
	// 功能參數
	boolean list_switch = true;		// 是否開啟列表功能
	boolean sort_switch = true;		// 是否開啟排序功能
	boolean modify_switch = true;	// 是否開啟修改功能
	boolean search_switch = true;	// 是否開啟搜尋功能
	int page_items = 15; 			// 列表分頁筆數設定
	int add_num = -1;				// 設定可新增的資料筆數 , -1 為無限筆
	int del_num = -1;				// 設定少於幾筆不可刪除 , -1 為無限制
	int level_number = 2;			// 項目層數
/*--------------------------------------------------------------------------------------------*/
    // 讀取上層項目 ID
	String qcategory = StringTool.validString(request.getParameter("_qcategory"));
	// 當前項目層數
	int now_level 	 = Integer.parseInt(StringTool.validString(request.getParameter("now_level"), "1")); // 當前項目層數

	Vector dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=?", new Object[] { code, lang }, "dm_showseq ASC , " + "dm_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,dms);
	// 當資料筆數小於設定可刪除的筆數時 , 隱藏刪除按鍵
	boolean delete_switch = num_check(del_num,dms);	
	
	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));

	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle" };
	String[] values = new String[] { String.valueOf(pageno), qtitle};

	if (search_switch) {
		StringBuffer sb = new StringBuffer();
		Vector keys = new Vector();
		sb.append("dm_lang=? and dm_code=? and dm_title like ?");
		keys.add(lang);
		keys.add(code);
		keys.add("%" + qtitle + "%");	
		sb.append("and dm_category=?");
		keys.add(qcategory);
		
		dms = app_sm.selectAll(tbldm, sb.toString(), keys.toArray(), "dm_showseq ASC , dm_createdate DESC");
	}
	
	// 上層項目名稱
	String up_name = "";
	if (!"".equals(qcategory)) up_name = app_sm.select(tbldm, qcategory).getString("dm_title") + "&nbsp;&nbsp;所屬項目&nbsp;&nbsp;";	
	// 當前項目
	TableRecord now_category = app_sm.select(tbldm, qcategory);
	// 分頁
	out.write(HtmlCoder.getForm("pageform", request.getRequestURI(), names, values));
	// 分頁設定
	app_dp = new DataPager(dms, page_items);
	dms = app_dp.getPageContent(pageno);	
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/pagerscript.jspf"%>
<script>
function checkform(F) {
//     if (F._qemitdate.value > F._qrestdate.value) {
//         alert("開始日期不得大於結束日期!!");
//         return false;
//     } else {
        return true;
   // }
}
function clearData(){
	$("#_qtitle").val("");
	$("#_qcategory").val("");
	//$("#_qemitdate").val("<%=DateTimeTool.getYear() - 1 + DateTimeTool.dateString().substring(4)%>");
	//$("#_qrestdate").val("<%=DateTimeTool.getYear() + 1 + DateTimeTool.dateString().substring(4)%>");
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
			<%if(search_switch){ %>
			<tr>
				<td align="center" colspan="2">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<td class="system_bk-2bk">
					<table width="100%" border="0" align="center" cellpadding="3"
						cellspacing="1">
						<tr>
							<td align="center" colspan="2" class="information_title-1"><%=show_title%>&nbsp;&nbsp;
								<%if (add_switch) { %>
								<input type="button" value="新增資料" onclick="javascript:location.href='<%=code%>_a.jsp?_qcategory=<%=qcategory%>&now_level=<%=now_level%>'" />&nbsp;
								<%} %>
								<%if (list_switch) { %>
								<input type="button" value="回到列表" onclick="javascript:location.href='<%=code%>.jsp?_qcategory=<%=qcategory%>&now_level=<%=now_level%>'" />&nbsp;
								<%} %>
								<%if (sort_switch) { %>
								<input type="button" value="資料排序" onclick="javascript:location.href='<%=code%>_sort.jsp?_qcategory=<%=qcategory%>&now_level=<%=now_level%>'" />&nbsp;
								<%} %>
								<%if (!"".equals(qcategory)) { %>
								<input type="button" value="回上層系所列表" onclick="javascript:location.href='<%=code%>.jsp?_qcategory=<%=now_category.getString("dm_category")%>&now_level=<%=now_level-1%>'" />
								<%} %>
							</td>
						</tr>

						<tr align="center" class="information_bk-2">
							<td colspan="2" align="center">條件值搜尋</td>
						</tr>
						<tr class="information_table-2-1">
							<td width="80%" align="center">系所名稱</td>								
							<td width="20%" align="center">功能</td>
						</tr>
						
						<form name="list_sea" id="list_sea" method="post" action="<%=code %>.jsp" onsubmit="return checkform(this);">
						<tr class="information_table-2-1">
							
							<td align="center"><input name="_qtitle" id="_qtitle" type="text" value="<%=qtitle %>" size="80" /></td>							
		                    <td align="center">
		                        <input name="query" type="submit" value="查詢">&nbsp;
		            			<input type="button" value="清除" onclick="clearData();" />
		                    </td>
						</tr>
						</form>

					</table>
					</td>
				</table>
				</td>
			</tr>
			<%} %>
			<tr>
				<td align="center" colspan="2">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<td class="system_bk-2bk">
					<table width="100%" border="0" align="center" cellpadding="3"
						cellspacing="1">
						<%if(!search_switch){ %>
						<tr>
							<td align="center" colspan="4" class="information_title-1"><%=show_title%>&nbsp;&nbsp;
								<%if (add_switch) { %>
								<input type="button" value="新增資料" onclick="javascript:location.href='<%=code%>_a.jsp?_qcategory=<%=qcategory%>&now_level=<%=now_level%>'" />&nbsp;
								<%} %>
								<%if (list_switch) { %>
								<input type="button" value="回到列表" onclick="javascript:location.href='<%=code%>.jsp?_qcategory=<%=qcategory%>&now_level=<%=now_level%>'" />&nbsp;
								<%} %>
								<%if (sort_switch) { %>
								<input type="button" value="資料排序" onclick="javascript:location.href='<%=code%>_sort.jsp?_qcategory=<%=qcategory%>&now_level=<%=now_level%>'" />&nbsp;
								<%} %>
								<%if (!"".equals(qcategory)) { %>
								<input type="button" value="回上層系所列表" onclick="javascript:location.href='<%=code%>.jsp?_qcategory=<%=now_category.getString("dm_category")%>&now_level=<%=now_level-1%>'" />
								<%} %>
							</td>
						</tr>
						<%}else{ %>
						<tr>
							<td align="center" colspan="5" class="information_title-1"><%=show_title%>查詢列表&nbsp;&nbsp;
						</tr>
						<%} %>
						<tr align="center" class="information_bk-2">
							<td colspan="5" align="center">標題列表</td>
						</tr>
						<tr class="information_table-2-1">
							<td width="10%" align="center">項目</td>
							<%if(now_level==1){ %>
							<td width="30%" align="center">系所代表圖</td>				
							<td width="40%" align="center">系所名稱</td>
							<%} else { %>
							<td width="70%" align="center">系所名稱</td>
							<%} %>
							<td width="20%" align="center">功能</td>
						</tr>
						<%
							for (int i = 0; i < dms.size(); i++) {
								TableRecord dm = (TableRecord) dms.get(i);
								Vector<TableRecord> subs = app_sm.selectAll(tbldm, "dm_category=?", new Object[]{ dm.getString("dm_id") });
						%>
						<form name="list<%=i + 1%>" id="list<%=i + 1%>" method="post">
						<tr class="information_table-2-1">
							<td align="center"><%=((pageno - 1) * page_items) + i + 1%></td>						
							<%if(now_level==1){ %>
							<td align="center"><img src="<%=app_fetchpath+"/"+code+"/"+lang+"/"+dm.getString("dm_image")%>" width="79"></td>
							<%} %>												
							<td align="center"><%=dm.getString("dm_title") %></td>	
							<td align="center">
								<%=HtmlCoder.hiddenInputs(names, values)%>
								<input type="hidden" name="dm_id" id="dm_id" value="<%=dm.getString("dm_id")%>" />
								<%if (now_level<level_number) { %>
									<input type="button" value="下層類別" onclick="javascript:location.href='<%=code%>.jsp?_qcategory=<%=dm.getString("dm_id")%>&now_level=<%=now_level+1%>'">&nbsp;&nbsp;&nbsp;&nbsp;
								<%} %>
								<%if (modify_switch) { %> 
								<input type="button" value="修改" onclick="goaction(this.form, '<%=code%>_c.jsp?_qcategory=<%=qcategory%>&now_level=<%=now_level%>');" />&nbsp;
								<%} %>
								<%if (delete_switch) { %>
									<%if(subs.size() == 0) { %>
									<input name="delete<%=i + 1%>" type="button" value="刪除" onclick="godelete(this.form, '<%=code%>_update.jsp?action=D&_qcategory=<%=qcategory%>&now_level=<%=now_level%>');" />
									<%} else { %>
									<input name="delete<%=i + 1%>" type="button" value="刪除" onClick="alert('下層系所有資料，故無法刪除。');" />
									<%} %>
								<%} %>
							</td>
						</tr>
						</form>
						<%} %>

						<td class="information_bk-2" colspan="5" align="center" height="26px">
							<%@include file="/WEB-INF/jspf/mis/pager.jspf"%>
						</td>

					</table>
					</td>
				</table>
				</td>
			</tr>
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