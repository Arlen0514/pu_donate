<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	// 相關參數設定
	String code 		= "thank";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "感謝狀批次列印";				// 功能標題
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
	String qcollect	 = StringTool.validString(request.getParameter("_qcollect"), "Y");
	String qidentity	 = StringTool.validString(request.getParameter("_qidentity"));

	String def_qrestdate = "2099/12/31" , def_qemitdate = DateTimeTool.dateString(DateTimeTool.getYear()-1,DateTimeTool.getMonth(),DateTimeTool.getDay());
	if("".equals(qemitdate)) {qemitdate = def_qemitdate;}
	if("".equals(qrestdate)) {qrestdate = def_qrestdate;}

	// Names and values.
	String[] names = new String[] { 
		"npage", "_qname", "_qphone", "_qdhno", "_qpayment", "_qemitdate", "_qrestdate", "_qposition", "_qcollect", "_qidentity"
	};
	String[] values = new String[] { 
		String.valueOf(pageno), qname, qphone, qdhno, qpayment, qemitdate, qrestdate, qposition, qcollect, qidentity
	};
	
	// Get records.
	StringBuffer sb = new StringBuffer();
	Vector keys = new Vector();
	
	sb.append("dh_code=? AND dh_lang=?");
	keys.add("donate");
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
	sb.append("and dh_identity_thank like ?");
	keys.add("%"+qidentity+"%");
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
	
	String[] titles =   new String[] {"個人","校友","公司","法人"};
	String[] categorys = new String[] {"person","alumni","company","organization"};
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
}

<%-- 捐款資料CSV匯出 --%>
var timer = "";
// 啟動檔案匯出功能
function export_file(dh_id) {
	var theForm = document.frm1;
	var action = "export/letter_export.jsp"; 
	
	if(dh_id != '') action += "?dh_id="+dh_id;
	timer = window.setTimeout("exportProgress()", 1500);
	$(".block").show();
	
	// 查詢資料送出
	theForm.action=action;
	theForm.target="_exportFrame";
	theForm.submit();
}

// 檢查檔案是否已經匯出完成
function exportProgress() {
	$.ajax({
		async: false,
		type: "GET",
		url: "export/exportcheck.jsp",
		data: { reportType:"letter_export" },
		success: function(res) {
			res = $.trim(res);
			console.log(res);
			
			if(res == "start") {
				$(".block").show();
				window.setTimeout("exportProgress()", 1500);
			} else if((res == "end") || (res == "no")) {
				$(".block").hide();
				clearProgress();
				if(res == "end") window.open("export/download.jsp?file=<%=app_account %>_thank_letter.docx", "感謝狀批次列印" );
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
		data: { reportType:"clear_letter_export" },
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
			    	    <td align="center" colspan="8" class="information_title-1">
			    		  <span><%=show_title %></span>&nbsp;&nbsp;
						  <span><input type="button" value="回到列表" onclick="javascript:location.href='<%=code %>.jsp'" /></span>&nbsp;
					    </td>
				      </tr>         
			          <tr class="information_bk-2">
	                  	<td colspan="8" align="center"><%=show_title %>查詢</td>
	                  </tr>
					  <tr class="information_bk-2">
	                 	<td width="15%" align="center" class="tablebg">捐款人姓名</td>
	                 	<td width="10%" align="center" class="tablebg">連絡電話</td>
	                 	<td width="14%" align="center" class="tablebg">捐款單編號</td>
	                 	<td width="20%" align="center" class="tablebg">付款方式</td>
	                 	<td width="10%" align="center" class="tablebg">日期區間</td>
	                 	<td width="16%" align="center" class="tablebg">贈與身分</td>
	                 	<td width="15%" align="center" class="tablebg">&nbsp;</td>
					  </tr>
					  
			  		  <form name="form_search" method="post" action="<%=code %>.jsp" onsubmit="return checkform(this);">          
		              	<tr class="information_table-2-1">
		                     <td align="center" class="tablebg">
		                     	<input name="_qname" id="_qname" type="text" value="<%=qname %>" size="16" />
		                     </td>
		                     <td align="center" class="tablebg">
		                     	<input name="_qphone" id="_qphone" type="text" value="<%=qphone %>" size="10" />
		                     </td>
		                     <td align="center" class="tablebg">
		                     	<input name="_qdhno" id="_qdhno" type="text" value="<%=qdhno %>" size="10" />
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
		                     	<input name="_qemitdate" id="_qemitdate" value="<%=qemitdate %>" readonly type="text" size="6" />
		                       	<input name="_qrestdate" id="_qrestdate" value="<%=qrestdate %>" readonly type="text" size="6" />
		                    </td>
		                     <td align="center">
								<select name="_qidentity" id="_qidentity">
									<option value="" <%="".equals(qidentity)?"selected='selected'":"" %>>全部&emsp;</option>
									<%for(int i = 0; i < titles.length; i++) { %>
									<option value="<%=categorys[i] %>" <%=categorys[i].equals(qidentity)?"selected='selected'":"" %>><%=titles[i] %></option>
									<%} %>
								</select>
							</td>
							
		                  	<td align="center" class="tablebg">
		                        <input name="query" type="submit" value="查詢">&nbsp;
		            			<input type="button" value="清除" onclick="clearData(this.form);" />
		            			<br /><br />
		            			<input type="button" value="查詢列印" onclick="export_file('');">
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
						    <td colspan="9" align="center" class="information_title-1">查詢結果標題列表</td>
						  </tr>
						  <tr class="information_bk-2">
						    <td width="5%" align="center">項目</td>
						    <td width="10%" align="center">捐款人姓名</td>
						    <td width="10%" align="center">連絡電話</td>
						    <td width="15%" align="center">捐款單編號</td>
						    <td width="20%" align="center">付款方式</td>
						    <td width="10%" align="center">捐款日期</td>
						    <td width="22%" align="center">贈與身分</td>
						    <td width="8%" align="center">功能</td>
						  </tr>
						  <%for(int i=0;i<dhs.size();i++){ 
								TableRecord dh = (TableRecord)dhs.get(i);
								String dh_paymethod = payment_title_map.get(dh.getString("dh_paymethod"));
						  %>
						  <form name="list<%=i+1 %>" id="list<%=i+1 %>" method="post">
						  <tr class="information_table-2-1">
							<td align="center"><%=((pageno-1) * page_items)+i+1 %></td>
						    <td align="left">&nbsp;&nbsp;<%=dh.getString("dh_name") %></td>
						    <td align="left">&nbsp;&nbsp;<%=dh.getString("dh_cellphone") %></td>
						    <td align="center"><%=dh.getString("dh_no") %></td>
						    <td align="center"><%=dh_paymethod %></td>				    
						    <td align="center"><%=dh.getString("dh_donatedate") %></td>				    
				    		<td align="center">
				    			<%for(int k = 0; k < titles.length; k++) { %>
				    			<label for="identity_<%=categorys[k] %>_<%=i+1 %>">
				    				<input type="radio" value="<%=categorys[k] %>" id="identity_<%=categorys[k] %>_<%=i+1 %>" name="dh_identity_thank" <%=categorys[k].equals(dh.getString("dh_identity_thank"))?"checked":"" %> onclick="goaction(this.form, '<%=code %>_update.jsp?action=IDENTITY');" />
				    				&nbsp;<%=titles[k] %>
				    			</label>
								<%} %>
				    		</td>						   
						    <td align="center">
								<input type="hidden" name="npage" id="npage" value="<%=pageno%>" />
								<input type="hidden" name="dh_id" id="dh_id" value="<%=dh.getString("dh_id") %>" />
								<input type="hidden" name="code" id="code" value="<%=code %>" />
								<%=HtmlCoder.hiddenInputs(names, values)%>
								<input type="button" name="m<%=i+1 %>" id="m<%=i+1 %>" value="列印" onclick="export_file('<%=dh.getString("dh_id") %>');" />&nbsp;
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
