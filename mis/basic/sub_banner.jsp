<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 基本參數
	String code = "sub_banner"; 			// 模組識別碼
	String show_title = "單元形象圖維護";		// 模組標題

	// 功能參數
	boolean add_switch = false;				// 是否開啟新增功能
	boolean list_switch = true;				// 是否開啟列表功能
	boolean sort_switch = false;			// 是否開啟排序功能
	boolean modify_switch = true;			// 是否開啟修改功能
	boolean delete_switch = false;			// 是否開啟刪除功能
	boolean search_switch = false;			// 是否開啟搜尋功能	
	int page_items = 15; 					// 列表分頁筆數設定
	int add_num = 0;						// 設定可新增的資料筆數 , -1 為無限筆
	int del_num = 0;						// 設定少於幾筆不可刪除 , -1 為無限制

	// 設定預設值
	String[] titles = new String[] {
		"靜宜概覽單元頁", "最新消息", "募款專案單元頁", "募款說明單元頁", "捐款芳名錄單元頁", "活動紀實單元頁",  "常見問題", "隱私權政策"
	};
	String[] categorys = new String[] {
		"about_content", "news", "donate_project", "guide", "directory", "photo",  "qa", "privacy"
	};
	for(int i = 0; i < titles.length; i++) {
		TableRecord ap = app_sm.select(tblap, "ap_title=? AND ap_lang=?", new Object[]{ titles[i], lang });
	 	if(ap.getString("ap_id").equals("")) {
	     	ap = new TableRecord(tblap);
	     	ap.setValue("ap_title", titles[i]);
	     	ap.setValue("ap_category", categorys[i]);
	     	ap.setValue("ap_showseq", i);
	     	ap.setValue("ap_code", code);	// 識別碼
	     	ap.setValue("ap_lang", lang);	// 語系
		 	ap.setInsert(app_account);
	     	app_sm.insert(ap);
	 	}
	}
/*--------------------------------------------------------------------------------------*/
	Vector aps = app_sm.selectAll(tblap, "ap_code=? and ap_lang=?", new Object[]{ code, lang }, "ap_showseq ASC, ap_createdate DESC");
	
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	add_switch = num_check(add_num,aps);
	
	// 當資料筆數小於設定可刪除的筆數時 , 隱藏刪除按鍵
	delete_switch = num_check(del_num,aps);

	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"), DateTimeTool.getYear() - 1 + DateTimeTool.dateString().substring(4));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"), DateTimeTool.getYear() + 1 + DateTimeTool.dateString().substring(4));

	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle", "_qemitdate", "_qrestdate" };
	String[] values = new String[] { String.valueOf(pageno), qtitle, qemitdate, qrestdate };	

	if(search_switch) {
		StringBuffer sb = new StringBuffer();
		Vector keys = new Vector();
		sb.append("ap_lang=? and ap_code=? and ap_title like ?");
		keys.add(lang);
		keys.add(code);
		keys.add("%" + qtitle + "%");
		sb.append(" and ap_emitdate>=? and ap_emitdate<=?");
		keys.add(qemitdate);
		keys.add(qrestdate);	
		aps = app_sm.selectAll(tblap, sb.toString(), keys.toArray(), "ap_showseq ASC , "+"ap_createdate DESC");
	}

	// 分頁
	out.write(HtmlCoder.getForm("pageform", request.getRequestURI(), names, values));
	
	// 分頁設定
	app_dp = new DataPager(aps, page_items);
	aps = app_dp.getPageContent(pageno);
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/pagerscript.jspf"%>
<script>
	function checkform(F) {
	    if(F._qemitdate.value > F._qrestdate.value) {
	        alert("開始日期不得大於結束日期!!");
	    } else {
	        return true;
	    }
        return false;
	}
	function clearData() {
		$("#_qtitle").val("");
		$("#_qemitdate").val("<%=DateTimeTool.getYear() - 1 + DateTimeTool.dateString().substring(4)%>");
		$("#_qrestdate").val("<%=DateTimeTool.getYear() + 1 + DateTimeTool.dateString().substring(4)%>");
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
					<td width="60" align="left" valign="middle"><img src="../images/web_icon_1.gif" width="55" height="48" /></td>
					<td align="left" valign="middle" class="web_bigword"><%=show_title%></td>
				</tr>
				
				<tr>
					<td colspan="2">
						<hr size="1" noshade />
					</td>
				</tr>
				
				<%if(search_switch) { %>
				<tr>
					<td align="center" colspan="2"><table width="95%" border="0" cellspacing="1" cellpadding="0">
						<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
							<tr>
								<td align="center" colspan="3" class="web_title-1"><%=show_title%>&nbsp;&nbsp;
									<%if(add_switch) { %>
									<input type="button" value="新增資料" onclick="javascript:location.href='<%=code%>_a.jsp'" />&nbsp;
									<%} %>
									<%if(list_switch) { %>
									<input type="button" value="回到列表" onclick="javascript:location.href='<%=code%>.jsp'" />&nbsp;
									<%} %>
									<%if(sort_switch) { %>
									<input type="button" value="資料排序" onclick="javascript:location.href='<%=code%>_sort.jsp'" />
									<%} %>
								</td>
							</tr>

							<tr align="center" class="web_bk-2">
								<td colspan="3" align="center">條件值搜尋</td>
							</tr>
							<tr class="web_table-2-1">
								<td width="50%" align="center">標題名稱</td>
								<td width="30%" align="center">上架時間</td>
								<td width="20%" align="center">功能</td>
							</tr>

<form name="list_sea" id="list_sea" method="post" action="<%=code %>.jsp" onsubmit="return checkform(this);">
							<tr class="web_table-2-1">
								<td align="center"><input name="_qtitle" id="_qtitle" type="text" value="<%=qtitle %>" size="70" /></td>
								<td align="center">
			                    	<input name="_qemitdate" id="_qemitdate" value="<%=qemitdate %>" readonly type="text" size="15" />
		                        		~
		                    		<input name="_qrestdate" id="_qrestdate" value="<%=qrestdate %>" readonly type="text" size="15" />
		                    	</td>
			                    <td align="center">
		                        	<input name="query" type="submit" value="查詢" />&nbsp;
		            				<input type="button" value="清除" onclick="clearData();" />
		                    	</td>
							</tr>
</form>

						</table></td>
					</table></td>
				</tr>
				<%} %>

				<tr>
					<td align="center" colspan="2"><table width="95%" border="0" cellspacing="1" cellpadding="0">
						<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
							<%if(!search_switch) { %>
							<tr>
								<td align="center" colspan="4" class="web_title-1"><%=show_title%>&nbsp;&nbsp;
									<%if(add_switch) { %>
									<input type="button" value="新增資料" onclick="javascript:location.href='<%=code%>_a.jsp'" />&nbsp;
									<%} %>
									<%if(list_switch) { %>
									<input type="button" value="回到列表" onclick="javascript:location.href='<%=code%>.jsp'" />&nbsp;
									<%} %>
									<%if(sort_switch) { %>
									<input type="button" value="資料排序" onclick="javascript:location.href='<%=code%>_sort.jsp'" />
									<%} %>
								</td>
							</tr>
							<%} else { %>
							<tr>
								<td align="center" colspan="4" class="web_title-1"><%=show_title%>查詢列表&nbsp;&nbsp;
							</tr>
							<%} %>
							
							<tr align="center" class="web_bk-2">
								<td colspan="4" align="center">標題列表</td>
							</tr>
							
							<tr class="web_table-2-1">
								<td width="5%" align="center">項目</td>
								<td width="30%" align="center">標題名稱</td>
								<td width="40%" align="center">圖片預覽</td>
								<td width="35%" align="center">功能</td>
							</tr>
							
							<%
							for(int i = 0; i < aps.size(); i++) {
								TableRecord ap = (TableRecord) aps.get(i);
							%>
<form name="list<%=i + 1%>" id="list<%=i + 1%>" method="post">
							<tr class="web_table-2-1">
								<td align="center"><%=((pageno - 1) * page_items) + i + 1 %></td>
								<td align="center"><%=ap.getString("ap_title") %></td>
								<td align="center">
									<%if(!"".equals(ap.getString("ap_image"))) { %>
									<img src="<%=app_fetchpath+"/"+code+"/"+lang+"/"+ap.getString("ap_image") %>" width="200px" />
									<%} %>
								</td>
								<td align="center">
									<%=HtmlCoder.hiddenInputs(names, values) %>
									<input type="hidden" name="ap_id" id="ap_id" value="<%=ap.getString("ap_id") %>" />
									<%if(modify_switch) { %> 
									<input type="button" value="修改" onclick="goaction(this.form, '<%=code %>_c.jsp');" />&nbsp;
									<%} %>
									<%if(delete_switch) { %>
									<input type="button" value="刪除" onclick="godelete(this.form, '<%=code %>_update.jsp?action=D');" />
									<%} %>
								</td>
							</tr>
</form>
							<%} %>

							<td class="web_bk-2" colspan="4" align="center" height="26px">
								<%@include file="/WEB-INF/jspf/mis/pager.jspf"%>
							</td>
						</table></td>
					</table></td>
				</tr>
				
				<tr>
					<td colspan="3">&nbsp;</td>
				</tr>
				
				<tr>
					<td colspan="3" class="web_bk-2b">&nbsp;</td>
				</tr>
			</table></td>
		</tr>
	</table>
</div>
</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>