<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	//基本參數
	String code = "donate_attribute"; 		// 模組識別碼
	String show_title = "捐款屬性維護";		// 模組標題
	
	// 功能參數
	boolean list_switch = true;		// 是否開啟列表功能
	boolean sort_switch = true;		// 是否開啟排序功能
	boolean modify_switch = true;	// 是否開啟修改功能	
	int add_num = -1;				// 設定可新增的資料筆數 , -1 為無限筆
	int del_num = -1;				// 設定少於幾筆不可刪除 , -1 為無限制
	int level_number = 1;			// 類別層數
/*--------------------------------------------------------------------------------*/	
    // 讀取上層類別 ID
	String qcategory = StringTool.validString(request.getParameter("_qcategory"));
	// 當前類別層數
	int now_level 	 = Integer.parseInt(StringTool.validString(request.getParameter("now_level"), "1")); // 當前類別層數
	
	Vector dms = app_sm.selectAll(tbldm,"dm_code=? and dm_lang=? and dm_category=?", new Object[] { code, lang ,qcategory },"dm_showseq ASC , dm_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,dms);
	// 當資料筆數小於設定可刪除的筆數時 , 隱藏刪除按鍵
	boolean delete_switch = num_check(del_num,dms);
	
	// 上層類別
	String up_name = "";
	if (!"".equals(qcategory)) up_name = app_sm.select(tbldm, qcategory).getString("dm_title") + "&nbsp;&nbsp;所屬類別&nbsp;&nbsp;";	
	TableRecord now_category = app_sm.select(tbldm, qcategory);
	
	// 跳頁參數
	String[] names = new String[] { "npage", "_qcategory", "now_level" };
	String[] values = new String[] { String.valueOf(pageno), qcategory, String.valueOf(now_level)};
	// 回列表頁
	out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
	
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="include/head.jsp"%>
<script>
function goaction(F,JSP){
	//驗證副檔名
	var file_chk = /([^\/]+\.(?:jpg|jpeg|gif|png))/;
	//驗證中文
	var chnese_chk = /[\u4e00-\u9fa5]/;
	
	if (F.dm_title.value == ""){
	   	alert("請輸入類別名稱!!");
	   	F.dm_title.focus();
	}else{
		F.action = JSP;
		F.submit();
	}
    
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
				<td colspan="2" class="information_bk-2b">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td width="60" align="left" valign="middle">
					<img src="../images/information_icon_1.gif" width="55" height="48" />
				</td>
				<td align="left" valign="middle" class="information_bigword">
					<%=show_title%>
				</td>
			</tr>
			<tr>
				<td colspan="2">
				<hr size="1" noshade>
				</td>
			</tr>
			<tr align="center">
				<td colspan="2">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<tr>
						<td class="system_bk-2bk">
						<table width="100%" border="0" align="center" cellpadding="3"
							cellspacing="1">
							<tr align="center">
								<td colspan="<%="".equals(qcategory)?"3":"2"%>" class="information_title-1">
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
								<td colspan="3" align="center" class="tablebg"><%=up_name + show_title%>列表</td>
							</tr>
							<tr align="center" class="information_table-2-1">
								<td width="10%" align="center">編號</td>
								<td width="70%" align="center"><%=show_title%>名稱</td>								
								<td width="20%" align="center">功能</td>
							</tr>
							<%if (add_switch) { %>
							<form name="formA" method="post">
							<tr class="information_table-2-1">
								<td align="center"></td>
								<td align="left">
								<div align="center">
									<input name="dm_title" type="text" value="" size="50" maxlength="120"/>
									<input name="dm_category" type="hidden" value="<%=qcategory%>" />
								</div>
								</td>
								<td align="left">
								<div align="center">
									<input name="add" type="button" value="新增" onClick="goaction(this.form, '<%=code%>_update.jsp?action=A&_qcategory=<%=qcategory %>&now_level=<%=now_level%>');">
								</div>
								</td>
							</tr>
							</form>
							<%} %>
							<%
								for (int i = 0; i < dms.size(); i++) {
									TableRecord dm = (TableRecord) dms.get(i);
									Vector<TableRecord> subs = app_sm.selectAll(tbldm, "dm_category=?", new Object[]{ dm.getString("dm_id") });
							%>
							<form name="form<%=i + 1%>" method="post">
								<tr class="information_table-2-1">
									<td align="center"><%=i + 1%></td>
									<td align="left">
										<div align="center">
											<input name="dm_title" type="text" value="<%=dm.getString("dm_title")%>" size="50" maxlength="120"/>
											<input name="dm_category" type="hidden" value="<%=qcategory%>"/>
										</div>
									</td>
									<td align="left">
										<div align="center">
										<%if (now_level<level_number) { %>
											<input type="button" value="下層類別" onclick="javascript:location.href='<%=code%>.jsp?_qcategory=<%=dm.getString("dm_id")%>&now_level=<%=now_level+1%>'">&nbsp;&nbsp;&nbsp;&nbsp;
										<%} %>
										<%if (modify_switch) { %>
											<input name="modify<%=i + 1%>" type="button" value="修改" onClick="goaction(this.form, '<%=code%>_update.jsp?action=M&dm_id=<%=dm.getString("dm_id")%>&_qcategory=<%=qcategory%>&now_level=<%=now_level%>');">
										<%} %>
										<%if (delete_switch) { %>
											<%if(subs.size() == 0) { %>
											<input name="delete<%=i + 1%>" type="button" value="刪除" onClick="godelete(this.form, '<%=code%>_update.jsp?action=D&dm_id=<%=dm.getString("dm_id")%>&_qcategory=<%=qcategory%>&now_level=<%=now_level%>');">
											<%} else { %>
											<input name="delete<%=i + 1%>" type="button" value="刪除" onClick="alert('下層類別有資料，故無法刪除。');" />
											<%} %>
										<%} %>
										</div>
									</td>
								</tr>
							</form>
							<%} %>
						</table>
						</td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2" class="information_bk-2b">&nbsp;</td>
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