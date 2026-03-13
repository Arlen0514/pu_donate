<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%

	// 上層基本參數
	String ap_category = StringTool.validString(request.getParameter("ap_category")); // 所屬上層相簿代號
	String back_code = "photo"; // 上層模組識別碼
	TableRecord apCode= app_sm.select(tblap,ap_category); 			// 所屬相簿資料

	// 若無上層資訊 , 則自動回上層列表頁
	if("".equals(ap_category)){
		out.println("<script> location='"+back_code+".jsp'; </script>");
	}
	
	// 基本參數
	String code = "photo_in"; 									// 模組識別碼
	String show_title = apCode.getString("ap_title")+"-相片";	// 模組標題	
	
	// 圖片建議尺寸
	String image_info = "(建議尺寸800px * 692px)";
	// 圖片建議尺寸
	//String mobile_info = "(建議尺寸830px * 1300px)";
	
	// 功能參數
	boolean list_switch = true;		// 是否開啟列表功能
	boolean sort_switch = true;		// 是否開啟排序功能
	boolean modify_switch = true;	// 是否開啟修改功能
	boolean search_switch = true;	// 是否開啟搜尋功能
	int page_items = 15; 			// 列表分頁筆數設定
	int add_num = -1;				// 設定可新增的資料筆數 , -1 為無限筆
	int del_num = -1;				// 設定少於幾筆不可刪除 , -1 為無限制
/*------------------------------------------------------------------------------------*/
	Vector aps = app_sm.selectAll(tblap, "ap_category=? and ap_code=? and ap_lang=?", new Object[] { ap_category, code, lang }, "ap_showseq ASC , ap_createdate DESC");
	// 當資料筆數小於設定可新增的筆數時 , 顯示新增按鍵
	boolean add_switch = num_check(add_num,aps);
	// 當資料筆數小於設定可刪除的筆數時 , 隱藏刪除按鍵
	boolean delete_switch = num_check(del_num,aps);
	
	// 搜尋欄位
	String qtitle = StringTool.validString(request.getParameter("_qtitle"));

	// 跳頁參數
	String[] names = new String[] { "npage", "_qtitle", "ap_category"};
	String[] values = new String[] { String.valueOf(pageno), qtitle, ap_category};

	// 回列表頁
	out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
	// 回排序頁
	out.write(HtmlCoder.getForm("sortpage", code + "_sort.jsp", names, values));
	// 新增頁
	out.write(HtmlCoder.getForm("addpage", code + "_a.jsp", names, values));
	
	
	if (search_switch) {
		StringBuffer sb = new StringBuffer();
		Vector keys = new Vector();
		sb.append("ap_category=? and ap_lang=? and ap_code=? and ap_title like ?");
		keys.add(ap_category);
		keys.add(lang);
		keys.add(code);
		keys.add("%" + qtitle + "%");		
		aps = app_sm.selectAll(tblap, sb.toString(), keys.toArray(), "ap_showseq ASC , ap_createdate DESC");
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
//     if (F._qemitdate.value > F._qrestdate.value) {
//         alert("開始日期不得大於結束日期!!");
//         return false;
//     } else {
        return true;
    //}
}
function clearData(){
	$("#_qtitle").val("");
	//$("#_qcategory").val("%");
	//$("#_qemitdate").val("<%=DateTimeTool.getYear() - 1 + DateTimeTool.dateString().substring(4)%>");
	//$("#_qrestdate").val("<%=DateTimeTool.getYear() + 1 + DateTimeTool.dateString().substring(4)%>");
}

function check_addform(F){	
	//驗證副檔名
	var file_chk = /([^\/]+\.(?:jpg|jpeg|gif|png|webp))/;
	//驗證中文
	var chnese_chk = /[\u4e00-\u9fa5]/;

	if (F.ap_image.value == "") {
		alert("請上傳圖檔!!");
		F.ap_image.focus();
	    return false;
	}	      
    var ap_images = F.ap_image.files;
    for(i = 0;i< ap_images.length;i++){
        var ap_image = ap_images[i].name;
        if(!file_chk.test(ap_image)){
        	alert("附檔名限為jpg|jpeg|gif|png|webp!!");
        	F.ap_image.value='';
        	F.ap_image.focus();
        	return false;
        }
    }
    return true;
    
	<%--
	if (F.ap_title.value == "") {
        alert("請輸入標題名稱!!");
        F.ap_title.focus();
	} else 	if (F.ap_image.value == "") {
       alert("請上傳圖檔!!");
       F.ap_image.focus();
	} else if (!file_chk.test(F.ap_image.value)) {
		alert("附檔名限為jpg|jpeg|gif|png!!");
		F.ap_image.focus();
    } else {
        return true;
    }
	return false;
	--%> 
	
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
			
			
			<%if(search_switch){ %>
			<tr>
				<td align="center" colspan="2">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<td class="system_bk-2bk">
					<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
						<tr>
							<td align="center" class="web_title-1"><%=show_title%>&nbsp;&nbsp;
								<%if (add_switch) { %>
								<input type="button" value="新增相片" onclick="addpage.submit();" />&nbsp;
								<%} %>
								<%if (list_switch) { %>
								<input type="button" value="回到相片列表" onclick="listpage.submit();" />&nbsp;
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
							<td colspan="2" align="center">相片搜尋</td>
						</tr>
						<tr class="web_table-2-1">
							<td width="80%" align="center">標題名稱</td>							
							<td width="20%" align="center">功能</td>
						</tr>
						
						<form name="list_sea" id="list_sea" method="post" action="<%=code %>.jsp" onsubmit="return checkform(this);">
						<tr class="web_table-2-1">
							<td align="center"><input name="_qtitle" id="_qtitle" type="text" value="<%=qtitle %>" size="123" /></td>							
		                    <td align="center">
		                        <input name="query" type="submit" value="查詢">&nbsp;
		                        <input type="hidden" name="ap_category" value="<%=ap_category %>"/>
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
			
			<%-- 表單新增相片區 --%>
			<tr>
				<td align="center" colspan="2">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<td class="system_bk-2bk">
					<table width="100%" border="0" align="center" cellpadding="3"
						cellspacing="1">

						<tr align="center" class="web_bk-2">
							<td colspan="3" align="center" class="web_title-1">批次新增相片</td>
						</tr>
						<tr class="web_table-2-1">
							<td width="30%" align="center">相片名稱</td>
							<td width="50%" align="center">圖檔</td>							
							<td width="20%" align="center">功能</td>
						</tr>
						
						<form name="photo_add" id="photo_add" method="post" enctype="multipart/form-data" action="<%=code %>_update.jsp?action=A&ap_category=<%=ap_category %>" onsubmit="return check_addform(this);">
						<tr class="web_table-2-1">
							<td align="center">
		                    	<input name="ap_title" id="ap_title" type="text" size="60">        
		                    </td>
		                    <td align="center">
		                    	<input name="ap_image" id="ap_image" type="file"  multiple="multiple" class="button" accept="image/*"> </br></br><%=image_info%> (可一次選多個圖檔)         
		                    </td>
		                    <td align="center">
		                        <input type="submit" value="確認送出">&nbsp;
		            			<input type="reset" value="清除" onclick="" />
		                    </td>
						</tr>
						</form>

					</table>
					</td>
				</table>
				</td>
			</tr>
			
			<tr>
				<td align="center" colspan="2">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<td class="system_bk-2bk">
					<table width="100%" border="0" align="center" cellpadding="3"
						cellspacing="1">
						<%if(!search_switch){ %>
						<tr>
							<td align="center" colspan="4" class="web_title-1"><%=show_title%>&nbsp;&nbsp;
								<%if (add_switch) { %>
								<input type="button" value="新增相片" onclick="addpage.submit();" />&nbsp;
								<%} %>
								<%if (list_switch) { %>
								<input type="button" value="回到相片列表" onclick="listpage.submit();" />&nbsp;
								<%} %>
								<%if (sort_switch) { %>
								<input type="button" value="相片排序" onclick="sortpage.submit();" />
								<%} %>
								<input type="button" value="回到相簿列表" onclick="javascript:location.href='<%=back_code%>.jsp'" />&nbsp;
							</td>
						</tr>
						<%}else{ %>
						<tr>
							<td align="center" colspan="4" class="web_title-1"><%=show_title%>查詢列表&nbsp;&nbsp;
						</tr>
						<%} %>
						<tr align="center" class="web_bk-2">
							<td colspan="4" align="center">相片列表</td>
						</tr>
						<tr class="web_table-2-1">
							<td width="5%" align="center">項目</td>
							<td width="20%" align="center">相片名稱</td>	
							<td width="55%" align="center">縮圖</td>					
							<td width="20%" align="center">功能</td>
						</tr>
						<%
							for (int i = 0; i < aps.size(); i++) {
								TableRecord data = (TableRecord) aps.get(i);
						%>
						<form name="list<%=i + 1%>" id="list<%=i + 1%>" method="post">
						<tr class="web_table-2-1">
							<td align="center"><%=((pageno - 1) * page_items) + i + 1%></td>
							<td align="center"><%=data.getString("ap_title") %></td>
							<td align="center"><img src="<%=app_fetchpath+"/"+code+"/"+lang+"/"+ap_category+"/"+data.getString("ap_image")%>" width="200px"></td>					
							<td align="center">
								<%=HtmlCoder.hiddenInputs(names, values)%>
								<input type="hidden" name="ap_id" id="ap_id" value="<%=data.getString("ap_id")%>" />
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

						<td class="web_bk-2" colspan="4" align="center" height="26px">
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