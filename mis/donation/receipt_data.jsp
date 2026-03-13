<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	// 相關參數設定
	String code 		= "order";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String rl_code 		= "receipt";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "收據匯出作業";			// 功能標題
	int page_items		= 15;						// 列表分頁筆數設定
	String del_switch	= "on"; 					// 若不允許資料刪除 , 請設定 "off" 
	
	
	// Conditions.
	String qpayment = StringTool.validString(request.getParameter("_qpayment"));
	String qdhno = StringTool.validString(request.getParameter("_qdhno"));
	String qname = StringTool.validString(request.getParameter("_qname"));
	
	String qgrade = StringTool.validString(request.getParameter("_qgrade"),"D");
	String qyear = StringTool.validString(request.getParameter("_qyear"),String.valueOf(DateTimeTool.getYear()));
	String qmonth = StringTool.validString(request.getParameter("_qmonth"),String.valueOf(DateTimeTool.getMonth()));
	String qday = StringTool.validString(request.getParameter("_qday"),String.valueOf(DateTimeTool.getDay()));
	
	
	String qrlno	 = StringTool.validString(request.getParameter("_qrlno"));
	String action = StringTool.validString(request.getParameter("action"));
	
	// Names and values.
	String[] names = new String[] { "npage",  "_qname", "_qdhno","_qpayment",  "_qgrade", "_qyear",  "_qmonth",  "_qday",  "_qrlno", "action"};
	String[] values = new String[] { String.valueOf(pageno), qname, qdhno, qpayment, qgrade,  qyear,  qmonth,  qday,  qrlno, action };
	
	Vector rss = app_sm.selectAll(tblrs , "rs_code=? AND rs_lang=?",  new Object[] { rl_code, lang });
	
	String s_m = qmonth, s_d = qday;
	
	// Get records.
	StringBuffer sb = new StringBuffer();
	Vector keys = new Vector();
	
	sb.append("rs_code=? AND rs_lang=?");
	keys.add(rl_code);
	keys.add(lang);
	sb.append(" and rs_status =  ?");		// 新增 收據狀態
	keys.add("Y");
	sb.append(" and dh_order_name like ?");
	keys.add("%"+qname+"%");
	sb.append(" and rs_no like ?");			//收據編碼
	keys.add("%"+qrlno+"%");
	if("Y".equals(qgrade)){
		sb.append(" and rs_createdate like ?");			//收據編碼
		keys.add(qyear+"/%");
	}else if("M".equals(qgrade)){
		if(qmonth.length()==1) s_m = "0"+qmonth;
		sb.append(" and rs_createdate like ?");			//收據編碼
		keys.add(qyear+"/"+s_m+"/%");
	}else {
		if(qmonth.length()==1) s_m = "0"+qmonth;
		if(qday.length()==1) s_d = "0"+s_d;
		sb.append(" and rs_createdate like ?");			//收據編碼
		keys.add(qyear+"/"+s_m+"/"+s_d+"%");
	}
	
	rss = app_sm.selectAll(tblrs, sb.toString(), keys.toArray() , "rs_createdate DESC");
	
	// 分頁
	out.write(HtmlCoder.getForm("pageform", request.getRequestURI(), names, values));
	app_dp = new DataPager(rss,page_items);			// 設定資料分頁每頁筆數
	rss = app_dp.getPageContent(pageno);
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><%=app_mistitle%></title>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/pagerscript.jspf"%>
<%@include file="/WEB-INF/jspf/norobots.jspf"%>
<script language="JavaScript" type="text/JavaScript">
function checkform(F) {
        return true;
}
/*------------------------------------------------------------*/

function clearData(F){
	$("#_qname").val("");
	$("#_qosno").val("");
	$("#_qpayment").val("");
	$("#_qphone").val("");
	$("#_qposition").val("Y");
	$("#_qcollect").val("");
	$("#_qship").val("");
	$("#_qbonus").val("");
	$("#_qrlno").val("");
}


<%-- 捐款資料CSV匯出 --%>
var timer = "";
// 啟動檔案匯出功能
function export_taxes() {
	var theForm = document.frm1;
	timer = window.setTimeout("exportProgress()", 1500);
	$(".block").show();

	// 查詢資料送出
	theForm.action="export/taxes_export.jsp";
	theForm.target="_exportFrame";
	theForm.submit();
}

// 檢查檔案是否已經匯出完成
function exportProgress() {
	$.ajax({
		async: false,
		type: "GET",
		url: "export/exportcheck.jsp",
		data: { reportType:"taxes_export" },
		success: function(res) {
			res = $.trim(res);
			if(res == "start") {
				$(".block").show();
				window.setTimeout("exportProgress()", 1500);
			} else if((res == "end") || (res == "no")) {
				$(".block").hide();
				clearProgress();
			} else if(res == null || res == "null") {
				alert("查詢匯出失敗!!");
				$(".block").hide();
				clearProgress();
			}
		}
	});
}
// 清除檔案匯出完成後之 Session 值
function clearProgress() {
	$.ajax({
		async:false,
		type:"GET",
		url: "export/exportcheck.jsp",
		data: { reportType:"clear_taxes_export" },
		success: function(res) {
			clearTimeout(timer);
		}
	});
}

function export_file() {
	var theForm = document.frm1;
	timer = window.setTimeout("exportProgress1()", 1500);
	$(".block").show();

	// 查詢資料送出
	theForm.action="export/receipt_export.jsp";
	theForm.target="_exportFrame";
	theForm.submit();
}
//檢查檔案是否已經匯出完成
function exportProgress1() {
	$.ajax({
		async: false,
		type: "GET",
		url: "export/exportcheck.jsp",
		data: { reportType:"receipt_export" },
		success: function(res) {
			res = $.trim(res);
			if(res == "start") {
				$(".block").show();
				window.setTimeout("exportProgress1()", 1500);
			} else if((res == "end") || (res == "no")) {
				$(".block").hide();
				clearProgress1();
			} else if(res == null || res == "null") {
				alert("查詢匯出失敗!!");
				$(".block").hide();
				clearProgress1();
			}
		}
	});
}
//清除檔案匯出完成後之 Session 值
function clearProgress1() {
	$.ajax({
		async:false,
		type:"GET",
		url: "export/exportcheck.jsp",
		data: { reportType:"clear_receipt_export" },
		success: function(res) {
			clearTimeout(timer);
		}
	});
}

</script>
</head>
<%-- 20250331 modify Miles top menu.jsp  改成 RWD --%>    
<body class="default_body">
<%-- 黑色遮蔽 --%>
<div class="block" style="width:100%; height:100%; position:fixed; color:#fff; display:none;">
	<img src="export/images/block_bg.png" width="100%" height="100%" style="position:fixed; z-index:99998;"/>
	<div style="margin: 0 auto;width: 400px;height: 50px;position: relative;top: 50%; z-index:99999; text-align:center;">
    	資料匯出準備中，請稍待片刻 ......
	</div>
</div>
<%-- 黑色遮蔽 --%>

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
            <td width="60" align="left" valign="middle"><img src="../images/information_icon_1.gif" width="55" height="48"></td>
            <td align="left" valign="middle" class="information_bigword"><%=show_title %></td>
          </tr>
          <tr>
            <td colspan="2"><hr size="1" noshade></td>
          </tr>
		  <tr>
			<td align="center" colspan="2">
			<table width="95%"  border="0" cellspacing="1" cellpadding="0">
				<td class="system_bk-2bk">
				<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
					  <tr>
			    	    <td align="center" colspan="5" class="information_title-1">
			    		  <span><%=show_title %></span>&nbsp;&nbsp;
					    </td>
				      </tr>         
			          <tr class="information_bk-2">
	                  	<td colspan="5" align="center"><%=show_title %>查詢</td>
	                  </tr>
					  <tr class="information_bk-2">
	                 	<td width="20%" align="center" class="tablebg">收據姓名</td>
	                 	<td width="15%" align="center" class="tablebg">收據編號</td>
	                 	<td width="10%" align="center" class="tablebg">匯出方式</td>
	                 	<td width="30%" align="center" class="tablebg">匯出條件</td>
	                 	<td width="25%" align="center" class="tablebg">&nbsp;</td>
					  </tr>
			  		  <form name="form_search" method="post" action="<%=rl_code %>_data.jsp" onsubmit="return checkform(this);">          
		              	<tr class="information_table-2-1">
		                     <td align="center" class="tablebg">
		                     	<input name="_qname" id="_qname" type="text" value="<%=qname %>" size="16" />
		                     </td>

		                     <td align="center" class="tablebg">
		                     	<input name="_qdhno" id="_qdhno" type="text" value="<%=qdhno %>" size="10" />
		                     </td>
		                     <td align="center" class="tablebg">
		                     	<select name="_qgrade">
		                     		<option value="D" <%="D".equals(qgrade)?"selected":"" %>>日</option>
		                     		<option value="M" <%="M".equals(qgrade)?"selected":"" %>>月</option>
		                     		<option value="Y" <%="Y".equals(qgrade)?"selected":"" %>>年</option>
		                     	</select>
		                     </td>		                     
		                     <td align="center" class="tablebg">
		                     	年：<select name="_qyear">
						           <%for(int i = DateTimeTool.getYear(),j=0 ; j <= 5 ; j++){ %>          	
		                     		<option value="<%=i-j %>" <%=qyear.equals(String.valueOf(i-j))?"selected":"" %>><%=i-j %></option>
		                     		<%} %>
		                     	   </select>
		                     
		                     	月：<select name="_qmonth">
						           <%for(int i = 1 ; i <= 12 ; i++){ %>          	
		                     		<option value="<%=i %>" <%=qmonth.equals(String.valueOf(i))?"selected":"" %>><%=i %></option>
		                     		<%} %>
		                     	   </select>          
		                     	日：<select name="_qday">
						           <%for(int i = 1 ; i <= 31 ; i++){ %>          	
		                     		<option value="<%=i %>" <%=qday.equals(String.valueOf(i))?"selected":"" %>><%=i %></option>
		                     		<%} %>
		                     	   </select>
		                     </td>			                     
		                     
		                     
		                  	<td align="center" class="tablebg">
		                        <input name="query" type="submit" value="查詢">&nbsp;
		            			<input type="button" value="清除" onclick="clearData(this.form);" />
		            			<br /><br />
		            			<input type="button" value="國稅局檔案匯出" onclick="export_taxes();">&nbsp;
		            			<input type="button" value="收據匯出" onclick="export_file();">		            			
		            			
		            			
		                  	</td>
		              	</tr>
		              	
		              	
		              		         
			  		  </form>				  
			
			      <!-- InstanceEndEditable -->
				</table>
				</td>
			</table>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
			<table width="95%"  border="0" cellspacing="1" cellpadding="0">
				<tr>
					<td class="system_bk-2bk">
					<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
						  <tr align="center">
						    <td colspan="6" align="center" class="information_title-1">查詢結果標題列表</td>
						  </tr>
						  <!-- 新增 收據狀態欄位 20221116 May -->
						  <tr class="information_bk-2">
						    <td width="5%" align="center">項目</td>
						    <td width="10%" align="center">收據姓名</td>
						    <td width="10%" align="center">收據編號</td>
						    <td width="10%" align="center">收據開立日期</td>
						    <td width="10%" align="center">收據金額</td>
						    <td width="25%" align="center">捐款項目</td>
						  </tr>
						  <%for(int i=0;i<rss.size();i++){ 
								TableRecord rs = (TableRecord)rss.get(i);
						  %>
						  <form name="list<%=i+1 %>" id="list<%=i+1 %>" method="post">
						  <tr class="information_table-2-1">
							<td align="center"><%=((pageno-1) * page_items)+i+1 %></td>
						    <td align="left">&nbsp;&nbsp;<%=rs.getString("dh_order_name") %></td>
						    <td align="left">&nbsp;&nbsp;<%=rs.getString("rs_no") %></td>
						    <td align="center"><%=rs.getString("rs_createdate") %></td>				    
						    <td align="center"><%=rs.getInt("dh_total") %></td>
						    <td align="center"><%=rs.getString("rs_donateitem") %></td>
						  </tr>
						  </form>
						  <%} %>
						<tr class="information_bk-2" >  
							<td colspan="6" align="center" height="26px">
							  <%@include file="/WEB-INF/jspf/mis/pager.jspf"%>
							</td>
						</tr>
				      <!-- InstanceEndEditable -->
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
			<td colspan="3" class="information_bk-2b">&nbsp;</td>
		</tr>
	
		</table>
	  </td>
     </tr>  
  </table>
</div>
<iframe name="_exportFrame" width="0" height="0" style="display:none"></iframe>
<%=HtmlCoder.getForm("frm1", request.getRequestURI(), names, values) %>
</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf" %>