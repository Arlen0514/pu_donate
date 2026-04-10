<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	// 相關參數設定
	String code 		= "donate";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "捐款資訊管理";			// 功能標題
	int page_items		= 15;						// 列表分頁筆數設定
	String del_switch	= "on"; 					// 若不允許資料刪除 , 請設定 "off" 
	
	// Conditions.
	String qname = StringTool.validString(request.getParameter("_qname"));
	String qphone = StringTool.validString(request.getParameter("_qphone"));
	String qdhno = StringTool.validString(request.getParameter("_qdhno"));
	String qpayment = StringTool.validString(request.getParameter("_qpayment"),"");	
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"));
	String qposition = StringTool.validString(request.getParameter("_qposition"), "Y");
	String qcollect	 = StringTool.validString(request.getParameter("_qcollect"));

	String def_qrestdate = "2099/12/31" , def_qemitdate = DateTimeTool.dateString(DateTimeTool.getYear()-1,DateTimeTool.getMonth(),DateTimeTool.getDay());
	if("".equals(qemitdate)) {qemitdate = def_qemitdate;}
	if("".equals(qrestdate)) {qrestdate = def_qrestdate;}

	// Names and values.
	String[] names = new String[] { 
		"npage", "_qname", "_qphone", "_qdhno", "_qpayment", "_qemitdate", "_qrestdate", "_qposition", "_qcollect"
	};
	String[] values = new String[] { 
		String.valueOf(pageno), qname, qphone, qdhno, qpayment, qemitdate, qrestdate, qposition, qcollect
	};
	
	// Get records.
	StringBuffer sb = new StringBuffer();
	Vector keys = new Vector();
	
	sb.append("dh_code=? AND dh_lang=?");
	keys.add(code);
	keys.add(lang);
	sb.append(" and dh_no like ?");
	keys.add("%"+qdhno+"%");
	sb.append(" and dh_collect like ?");
	keys.add("%"+qcollect+"%");
	sb.append(" and dh_status like ? and dh_name like ?");
	keys.add("%"+qposition+"%");
	keys.add("%"+qname+"%");
	sb.append(" and dh_cellphone like ?");
	keys.add("%"+qphone+"%");
	sb.append("and dh_paymethod like ?");
	keys.add("%"+qpayment+"%");
	sb.append(" and !(dh_createdate>? || dh_createdate<?)");
	keys.add(qrestdate+" 24:00:00");
	keys.add(qemitdate);
	
	Vector dhs = app_sm.selectAll(tbldh, sb.toString(), keys.toArray() , "dh_createdate DESC");
	
	// 分頁
	out.write(HtmlCoder.getForm("pageform", request.getRequestURI(), names, values));
	app_dp = new DataPager(dhs,page_items);			// 設定資料分頁每頁筆數
	dhs = app_dp.getPageContent(pageno);
	
	// 付款方式
	Vector<TableRecord> payments = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=? and cp_display=?", 
			new Object[]{"guide", lang, "Y"}, "cp_showseq ASC, cp_createdate DESC");
	Map<String, String> payment_title_map = new HashMap<String, String>();
	
	for(TableRecord payment:payments) 
		payment_title_map.put(payment.getString("cp_category"),payment.getString("cp_title"));
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<!-- <link href="../css/adm_css.css" rel="stylesheet" type="text/css"> -->
<title><%=app_mistitle%></title>
<%@include file="include/head.jsp"%>
<%-- <%@include file="../../JQuery/jquery.jsp" %> --%>
<%-- <%@include file="../../JQuery/include_date.jsp" %> --%>
<%@include file="/WEB-INF/jspf/mis/pagerscript.jspf"%>
<%@include file="/WEB-INF/jspf/norobots.jspf"%>
<script language="JavaScript" type="text/JavaScript">
function checkform(F) {
    if (F._qemitdate.value > F._qrestdate.value) {
        alert("開始日期不得大於結束日期!!");
        return false;
    } else {
        return true;
    }
}
/*------------------------------------------------------------*/

function clearData(F){
	$("#_qname").val("");
	$("#_qphone").val("");
	$("#_qdhno").val("");
	$("#_qpayment").val("%");
	$("#_qemitdate").val("<%=def_qemitdate%>");
	$("#_qrestdate").val("<%=def_qrestdate%>");
	$("#_qposition").val("Y");
	$("#_qcollect").val("");
}

<%-- 捐款資料 CSV 匯出 --%>
function export_csv() {
	var theForm = document.form_search;
	if(!checkform(theForm)) return;

	var orgAction = theForm.action;
	var orgTarget = theForm.target;
	theForm.action = "export/donation_csv_export.jsp";
	theForm.target = "_blank";
	theForm.submit();
	theForm.action = orgAction;
	theForm.target = orgTarget;
}

<%-- 確認是否作廢捐款單 20221117 May --%>
function checkOrderDisable(F){
	if(confirm("確定要作廢捐款單？")){
		goaction(F.form, '<%=code %>_update.jsp?action=STATUS');
	}
}

<%-- 捐款資料CSV匯出 --%>
var timer;
// 啟動檔案匯出功能
function export_file() {
	var theForm = document.frm1;
	timer = window.setTimeout("exportProgress()", 1500);
	$(".block").show();

	// 查詢資料送出
	theForm.action="export/donate_export.jsp";
	theForm.target="_exportFrame";
	theForm.submit();
}

// 檢查檔案是否已經匯出完成
function exportProgress() {
	$.ajax({
		async: false,
		type: "GET",
		url: "export/exportcheck.jsp",
		data: { reportType:"donate_export" },
		success: function(res) {
			res = $.trim(res);
			
			if(res == "start") {
				$(".block").show();
				window.setTimeout("exportProgress()", 1500);
			} else if((res == "end") || (res == "no")) {
				$(".block").hide();
				clearProgress();
				if(res == "end") window.open("export/download.jsp?file=<%=app_account %>_donate_export.xlsx", "捐款查詢匯出" );
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
		data: { reportType:"clear_donate_export" },
		success: function(res) {
			clearTimeout(timer);
		}
	});
}

<%-- 出納系統 excel 匯出 --%>
var timer2;
// 啟動檔案匯出功能
function export_file2() {
	var theForm = document.frm1;
	timer2 = window.setTimeout("exportProgress2()", 1500);
	$(".block").show();

	// 查詢資料送出
	theForm.action="export/receipt_export.jsp";
	theForm.target="_exportFrame";
	theForm.submit();
}

// 檢查檔案是否已經匯出完成
function exportProgress2() {
	$.ajax({
		async: false,
		type: "GET",
		url: "export/exportcheck.jsp",
		data: { reportType:"receipt_export" },
		success: function(res) {
			res = $.trim(res);
			
			if(res == "start") {
				$(".block").show();
				window.setTimeout("exportProgress2()", 1500);
			} else if((res == "end") || (res == "no")) {
				$(".block").hide();
				clearProgress();
				if(res == "end") window.open("export/download.jsp?file=<%=app_account %>_receipt_export.xlsx", "出納查詢匯出" );
			} else if(res == null || res == "null") {
				alert("匯出失敗!!");
				$(".block").hide();
				clearProgress();
			}
		}
	});
}
// 清除檔案匯出完成後之 Session 值
function clearProgress2() {
	$.ajax({
		async:false,
		type:"GET",
		url: "export/exportcheck.jsp",
		data: { reportType:"clear_receipt_export" },
		success: function(res) {
			clearTimeout(timer2);
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
				<tr>
				<td class="system_bk-2bk">
				<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
					  <tr>
			    	    <td align="center" colspan="8" class="information_title-1">
			    		  <span><%=show_title %></span>&nbsp;&nbsp;
			    		  <span><input type="button" value="新增捐款單" onclick="javascript:location.href='<%=code %>_a.jsp'" /></span>&nbsp;
						  <span><input type="button" value="捐款單列表" onclick="javascript:location.href='<%=code %>.jsp'" /></span>&nbsp;
						  <span><input type="button" value="設定收件者" onclick="javascript:location.href='<%=code %>_pop.jsp'" /></span>	
						  <span><input type="button" value="批次匯入" onclick="javascript:location.href='<%=code %>_import.jsp'" /></span>&nbsp;
						  <span><input type="button" value="CSV匯入" onclick="javascript:location.href='<%=code %>_csv_import.jsp'" /></span>&nbsp;
					    </td>
				      </tr>         
			          <tr class="information_bk-2">
	                  	<td colspan="8" align="center"><%=show_title %>查詢</td>
	                  </tr>
					  <tr class="information_bk-2">
	                 	<td width="15%" align="center" class="tablebg">捐款人姓名</td>
<!-- 	                 	<td width="10%" align="center" class="tablebg">連絡電話</td> -->
	                 	<td width="14%" align="center" class="tablebg">捐款單編號</td>
	                 	<td width="20%" align="center" class="tablebg">付款方式</td>
	                 	<td width="20%" align="center" class="tablebg">日期區間</td>
	                 	<td width="8%" align="center" class="tablebg">捐款單狀態</td>
						<td width="8%" align="center">是否付款</td>
	                 	<td width="15%" align="center" class="tablebg">&nbsp;</td>
					  </tr>
					  
			  		  <form name="form_search" method="post" action="<%=code %>.jsp" onsubmit="return checkform(this);">          
		              	<tr class="information_table-2-1">
		                     <td align="center" class="tablebg">
		                     	<input name="_qname" id="_qname" type="text" value="<%=qname %>" size="8" />
		                     </td>
		                     <%-- 
		                     <td align="center" class="tablebg">
		                     	<input name="_qphone" id="_qphone" type="text" value="<%=qphone %>" size="5" />
		                     </td>
		                     --%>
		                     <td align="center" class="tablebg">
		                     	<input name="_qdhno" id="_qdhno" type="text" value="<%=qdhno %>" size="8" />
		                     </td>
		                     
		                     <td align="center">
								<select name="_qpayment" id="_qpayment">
									<option value="" <%="".equals(qpayment)?"selected='selected'":"" %>>全部</option>
									<%for(TableRecord payment:payments){ %>
									<option value="<%=payment.getString("cp_category") %>" <%=payment.getString("cp_category").equals(qpayment)?"selected='selected'":"" %>><%=payment.getString("cp_title") %></option>
									<%} %>
								</select>
							</td>

		                     <td align="center" class="tablebg">
		                     	<input name="_qemitdate" id="_qemitdate" value="<%=qemitdate %>" readonly type="text" size="5" />
		                     	~
		                       	<input name="_qrestdate" id="_qrestdate" value="<%=qrestdate %>" readonly type="text" size="5" />
		                    </td>
		                     <td align="center">
								<select name="_qposition" id="_qposition">
									<option value="Y" <%="Y".equals(qposition)?"selected='selected'":"" %>>正常</option>
									<option value="N" <%="N".equals(qposition)?"selected='selected'":"" %>>作廢</option>
									<option value="" <%="".equals(qposition)?"selected='selected'":"" %>>全部&emsp;</option>
								</select>
							</td>
							<td align="center">
								<select name="_qcollect" id="_qcollect">
									<option value="" <%="".equals(qcollect)?"selected='selected'":"" %>>全部</option>
									<option value="N" <%="N".equals(qcollect)?"selected='selected'":"" %>>未付款</option>
									<option value="Y" <%="Y".equals(qcollect)?"selected='selected'":"" %>>已付款</option>
								</select>
							</td>	
							
		                  	<td align="center" class="tablebg">
		                        <input name="query" type="submit" value="查詢">&nbsp;
		            			<input type="button" value="清除" onclick="clearData(this.form);" />
		            			<br /><br />
									<input type="button" value="CSV匯出" onclick="export_csv();">&nbsp;
									<input type="button" value="查詢匯出" onclick="export_file();">&nbsp;
									<input type="button" value="出納匯出" onclick="export_file2();">
		                  	</td>
		              	</tr>
			  		  </form>				  
			      <!-- InstanceEndEditable -->
				</table>
				</td>
				</tr>
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
						    <td colspan="9" align="center" class="information_title-1">查詢結果標題列表</td>
						  </tr>
						  <tr class="information_bk-2">
						    <td width="5%" align="center">項目</td>
						    <td width="20%" align="center">捐款人姓名</td>
						    <td width="10%" align="center">捐款金額</td>
						    <td width="14%" align="center">捐款單編號</td>
						    <td width="10%" align="center">付款方式</td>
						    <td width="10%" align="center">捐款日期</td>
						    <td width="8%" align="center">捐款單狀態</td>
		                 	<td width="8%" align="center" class="tablebg">是否付款</td>				
						    <td width="15%" align="center">功能</td>
						  </tr>
						  <%for(int i=0;i<dhs.size();i++){ 
								TableRecord dh = (TableRecord)dhs.get(i);
								boolean search_donate = "Y".equals(dh.getString("dh_status")) && !"Y".equals(dh.getString("dh_collect"));
								String dh_paymethod = payment_title_map.get(dh.getString("dh_paymethod"));
								String search_folder = "";								
								
								if(dh.getString("dh_paymethod").contains("pu")) search_folder = "pupay";
								search_donate = search_donate && !"".equals(search_folder) && !dh.getString("dh_paymethod").contains("regular");
						  %>
						  <form name="list<%=i+1 %>" id="list<%=i+1 %>" method="post">
						  <tr class="information_table-2-1">
							<td align="center"><%=((pageno-1) * page_items)+i+1 %></td>
						    <td align="left">&nbsp;&nbsp;<%=dh.getString("dh_name") %></td>
						    <td align="right"><%=app_df.format(dh.getInt("dh_total")) %>&nbsp;&nbsp;</td>
						    <td align="center"><%=dh.getString("dh_no") %></td>
						    <td align="center">
						    	<%=dh_paymethod %><br/>
						    	<span style="color: red;">
						    	<%if(dh.getString("dh_paymethod").contains("regular")){ %>
	                  			(第<%=("".equals(dh.getString("dh_main"))?0:dh.getInt("dh_regular_period")-dh.getInt("dh_remain_period"))+1 %>期)
	                  			<%} %>
	                  			</span>
						    </td>				    
						    <td align="center"><%=dh.getString("dh_donatedate") %></td>				    
						    <td align="center"><%="N".equals(dh.getString("dh_status"))?"作廢":"正常" %></td>
				    		<td align="center">
				    			<%if(dh.getString("dh_paymethod").contains("newebpay") || dh.getString("dh_paymethod").contains("pu")){ %>
				    			<input type="checkbox" value="Y" name="dh_collect" <%="Y".equals(dh.getString("dh_collect"))?"checked":"" %> disabled="disabled"/>
				    			<%}else{ %>
				    			<input type="checkbox" value="Y" name="dh_collect" <%="Y".equals(dh.getString("dh_collect"))?"checked":"" %> onclick="goaction(this.form, '<%=code %>_update.jsp?action=COLLECT');"/>
				    			<%} %>
				    		</td>						   
						    <td align="center">
								<input type="hidden" name="npage" id="npage" value="<%=pageno%>" />
								<input type="hidden" name="dh_id" id="dh_id" value="<%=dh.getString("dh_id") %>" />
								<input type="hidden" name="code" id="code" value="<%=code %>" />
								<%=HtmlCoder.hiddenInputs(names, values)%>
								<input type="button" name="m<%=i+1 %>" id="m<%=i+1 %>" value="檢視" onclick="goaction(this.form, '<%=code %>_b.jsp');" />&nbsp;
								<%if(!"off".equals(del_switch)) { %><input type="button" name="d<%=i+1 %>" id="d<%=i+1 %>" value="<%="N".equals(dh.getString("dh_status"))?"恢復捐款單":"捐款單作廢" %>" onclick="checkOrderDisable(this);"/> <%} %>
						    	<%if(search_donate){ %>
						    	<input type="button" name="s<%=i+1 %>" id="s<%=i+1 %>" value="付款查詢" onclick="goaction(this.form, '../../web/payment/<%=search_folder %>/check.jsp');" />&nbsp;
						    	<%} %>
						    </td>
						  </tr>
						  </form>
						  <%} %>
						  				
						  <tr class="information_bk-2" >  
							<td colspan="9" align="center" height="26px">
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
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>
