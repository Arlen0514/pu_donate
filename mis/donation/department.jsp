<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	//基本參數
	String code = "department"; 					// 模組識別碼
	String show_title = "院系募款維護";				// 模組標題
	
	// 功能參數
	boolean list_switch = true;		// 是否開啟列表功能
	boolean sort_switch = true;		// 是否開啟排序功能
	boolean modify_switch = true;	// 是否開啟修改功能
	boolean search_switch = true;	// 是否開啟搜尋功能
	int page_items = 15; 			// 列表分頁筆數設定
	int add_num = -1;				// 設定可新增的資料筆數 , -1 為無限筆
	int del_num = -1;				// 設定少於幾筆不可刪除 , -1 為無限制
	int category_num = 2;		    // 設定類別層數 2層以上使用選擇器 一層使用下拉選單即可
/*--------------------------------------------------------------------------------------------*/
	Vector cps = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=?", new Object[] { code, lang }, "cp_showseq ASC , " + "cp_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,cps);
	// 當資料筆數小於設定可刪除的筆數時 , 隱藏刪除按鍵
	boolean delete_switch = num_check(del_num,cps);	
	
	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));
	String qcategory = StringTool.validString(request.getParameter("_qcategory"),"");
	String qupcategory = StringTool.validString(request.getParameter("_qupcategory"),"");
	
	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle", "_qcategory", "_qupcategory" };
	String[] values = new String[] { String.valueOf(pageno), qtitle, qcategory, qupcategory };

	// 當前搜尋類別標題
	String title1=app_sm.select(tbldm,qupcategory).getString("dm_title");
	String title2=app_sm.select(tbldm,qcategory).getString("dm_title");
		
	//所屬類別
	Vector<TableRecord> dms = app_sm.selectAll(tbldm, "dm_lang=? and dm_code=? and dm_category=?", new Object[]{ lang, code+"_category", "" } , "dm_showseq ASC , dm_createdate DESC");
	
	if (search_switch) {
		StringBuffer sb = new StringBuffer();
		Vector keys = new Vector();
		sb.append("cp_lang=? and cp_code=? and cp_category like ? and cp_title like ?");
		keys.add(lang);
		keys.add(code);
		keys.add("%" + qcategory + "%");	
		keys.add("%" + qtitle + "%");			
		cps = app_sm.selectAll(tblcp, sb.toString(), keys.toArray(), "cp_showseq ASC , cp_createdate DESC");
	}
	
	// 分頁
	out.write(HtmlCoder.getForm("pageform", request.getRequestURI(), names, values));
	// 分頁設定
	app_dp = new DataPager(cps, page_items);
	cps = app_dp.getPageContent(pageno);
	
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
	$("#dm_title").text("");
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
							<td align="center" colspan="3" class="information_title-1"><%=show_title%>&nbsp;&nbsp;
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

						<tr align="center" class="information_bk-2">
							<td colspan="3" align="center">條件值搜尋</td>
						</tr>
						<tr class="information_table-2-1">
							<td width="25%" align="center">所屬類別</td>
							<td width="55%" align="center">標題名稱</td>							
							<td width="20%" align="center">功能</td>
						</tr>
						
						<form name="list_sea" id="list_sea" method="post" action="<%=code %>.jsp" onsubmit="return checkform(this);">
						<tr class="information_table-2-1">
							<td align="center">
								<% if(category_num<=1){ %>
								<select name="_qcategory" id="_qcategory">
				    		            <option value="">全部</option>
			                  			<% 
				                  			for(int i=0; i<dms.size(); i++){
				                  				TableRecord dm = (TableRecord) dms.get(i);
				                  		%>
				                  		<option value="<%=dm.getString("dm_id") %>" <%=dm.getString("dm_id").equals(qcategory)?"selected":"" %>><%=dm.getString("dm_title") %></option>
				                  		<%} %>
					            </select>
							    <% }else{  //2層以上 類別選擇器 %>
								<span id="dm_title" style="color:#FA0300;"><%=!"".equals(qcategory)?title1+"--"+title2:""%></span>&nbsp;&nbsp;
	                  			<input type="hidden" name="_qupcategory" id="_qupcategory" value="<%=qupcategory%>" />
								<input type="hidden" name="_qcategory" id="_qcategory" value="<%=qcategory %>" />
	                  			<input type="button" value="選擇類別" onclick="window.open('../mis_tools/category_selector.jsp?Back_id=_qcategory&Back_category=_qupcategory&max_layer=<%=category_num %>&dm_code=<%=code%>_category&css_type=information','_blank','height=260,width=400,top=50,left=300,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');" />
								<% } %>
								<%-- 2層 optgroup
								<select name="_qcategory" id="_qcategory">
									<option value="">全部</option>
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
							<td align="center"><input name="_qtitle" id="_qtitle" type="text" value="<%=qtitle %>" size="30" /></td>							
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
						<%}else{ %>
						<tr>
							<td align="center" colspan="4" class="information_title-1"><%=show_title%>查詢列表&nbsp;&nbsp;
						</tr>
						<%} %>
						<tr align="center" class="information_bk-2">
							<td colspan="4" align="center">標題列表</td>
						</tr>
						<tr class="information_table-2-1">
							<td width="5%" align="center">項目</td>
							<td width="20%" align="center">所屬類別</td>
							<td width="55%" align="center">標題名稱</td>
							<%-- 
							<td width="20%" align="center">縮圖</td>	
							--%>					
							<td width="20%" align="center">功能</td>
						</tr>
						<%
							for (int i = 0; i < cps.size(); i++) {
								TableRecord cp = (TableRecord) cps.get(i);
						%>
						<form name="list<%=i + 1%>" id="list<%=i + 1%>" method="post">
						<tr class="information_table-2-1">
							<td align="center"><%=((pageno - 1) * page_items) + i + 1%></td>
							<td align="center"><%=app_sm.select(tbldm, cp.getString("cp_upcategory")).getString("dm_title")+"--"+app_sm.select(tbldm, cp.getString("cp_category")).getString("dm_title")%></td>
							<td align="center"><%=cp.getString("cp_title") %></td>							
							<%-- 
							<td align="center"><img src="<%=app_fetchpath+"/"+code+"/"+lang+"/"+cp.getString("cp_image")%>" width="168<%--100%-%>"></td>
							--%>
							<td align="center">
								<%=HtmlCoder.hiddenInputs(names, values)%>
								<input type="hidden" name="cp_id" id="cp_id" value="<%=cp.getString("cp_id")%>" />
								<%if (modify_switch) { %> 
								<input type="button" value="修改" onclick="goaction(this.form, '<%=code%>_c.jsp');" />&nbsp;
								<%} %>
								<%if (delete_switch) { %>
								<input type="button" value="刪除" onclick="godelete(this.form, '<%=code%>_update.jsp?action=D');" />
								<%} %>
							</td>
						</tr>
						</form>
						<%} %>

						<td class="information_bk-2" colspan="4" align="center" height="26px">
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