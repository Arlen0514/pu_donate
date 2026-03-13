<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	// 相關參數設定
	String code 		= "donate";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String rl_code 		= "receipt_a";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String rl_code2 	= "receipt";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "單筆收據開立作業";			// 功能標題
	int page_items		= 15;						// 列表分頁筆數設定
	String del_switch	= "on"; 					// 若不允許資料刪除 , 請設定 "off" 
	
	
	// Conditions.
	String qposition 	= StringTool.validString(request.getParameter("_qposition"));
	String qcollect	 	= StringTool.validString(request.getParameter("_qcollect"));
	String qship	 	= StringTool.validString(request.getParameter("_qship"));
	String qpayment 	= StringTool.validString(request.getParameter("_qpayment"),"%");
	String qivoice 		= StringTool.validString(request.getParameter("_qivoice"));
	
	String qdhno 		= StringTool.validString(request.getParameter("_qdhno"));
	String qname 		= StringTool.validString(request.getParameter("_qname"));
	String qphone 		= StringTool.validString(request.getParameter("_qphone"));
	String qemitdate 	= StringTool.validString(request.getParameter("_qemitdate"));
	String qrestdate 	= StringTool.validString(request.getParameter("_qrestdate"));
	
	String qrlno	 	= StringTool.validString(request.getParameter("_qrlno"));
	String qrsstatus	= StringTool.validString(request.getParameter("_qrsstatus"));		// 收據開立狀態
	String action 		= StringTool.validString(request.getParameter("action"));
	
	if("".equals(qposition)) {qposition = "Y";}
	if("".equals(qcollect)) {qcollect = "%";}
	if("".equals(qship)) {qship = "%";}
	if("".equals(qrsstatus)) {qrsstatus = "N";}
	
	String def_qrestdate = "2099/12/31" , def_qemitdate = DateTimeTool.dateString(DateTimeTool.getYear()-1,DateTimeTool.getMonth(),DateTimeTool.getDay());
	if("".equals(qemitdate)) {qemitdate = def_qemitdate;}
	if("".equals(qrestdate)) {qrestdate = def_qrestdate;}
	
	qcollect = "Y";//避免未收款之捐款單誤觸
	// Names and values.
	String[] names = new String[] { "npage", "_qposition", "_qname", "_qemitdate", "_qrestdate", "_qship", "_qcollect","_qphone","_qdhno","_qpayment","_qivoice","_qrlno", "action", "_qrsstatus"};
	String[] values = new String[] { String.valueOf(pageno), qposition, qname, qemitdate, qrestdate, qship, qcollect,qphone, qdhno,qpayment,qivoice,qrlno, action, qrsstatus };
	
	Vector dhs = app_sm.selectAll(tbldh , "dh_code=? AND dh_lang=?",  new Object[] { code, lang });
	
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
	sb.append(" and rs_no like ?");		//收據編碼
	keys.add("%"+qrlno+"%");
	sb.append(" and dh_status like ?");
	keys.add("%"+qposition+"%");
	sb.append(" and dh_phone like ?");
	keys.add("%"+qphone+"%");
	sb.append(" and dh_paymethod like ?");
	keys.add("%"+qpayment+"%");
	if("all".equals(qrsstatus)) {			// 收據狀態-全部
		sb.append("and rs_no like ?");
		keys.add("%");
	} else if("Y".equals(qrsstatus)) {		// 收據狀態-已開立
		sb.append("and rs_no <> ?");
		keys.add("");
	} else if("N".equals(qrsstatus)) {		// 收據狀態-未開立
		sb.append("and rs_no = ?");
		keys.add("");
	}
// 	sb.append(" and dh_receipt_type<>? and dh_receipt_type<>?");
// 	keys.add("年度收據");
// 	keys.add("不開立收據");
	sb.append(" and !(dh_createdate>? || dh_createdate<?)");
	keys.add(qrestdate+" 24:00:00");
	keys.add(qemitdate);
	dhs = app_sm.selectAll(tbldh, sb.toString(), keys.toArray() , "dh_createdate DESC");
	
	// 分頁
	out.write(HtmlCoder.getForm("pageform", request.getRequestURI(), names, values));
	app_dp = new DataPager(dhs,page_items);			// 設定資料分頁每頁筆數
	dhs = app_dp.getPageContent(pageno);
	
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><%=app_mistitle%></title>
<%@include file="include/head.jsp"%>
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
	$("#_qdhno").val("");
	$("#_qpayment").val("%");
	$("#_qphone").val("");
	$("#_qemitdate").val("<%=def_qemitdate%>");
	$("#_qrestdate").val("<%=def_qrestdate%>");
	$("#_qposition").val("Y");
	$("#_qcollect").val("");
	$("#_qship").val("");
	$("#_qbonus").val("");
	$("#_qrlno").val("");
	$("#_qrsstatus").val("N");
}

//捐款編號
function goadd_rlno(FORM,JSP){
    var val = [];
    $(':checkbox:checked').each(function(i){
      val[i] = $(this).val();
    });
	if(val.length==0){
		alert('請至少選擇一項捐款單');
	}else{   
		$("#rs_no_add").val(val);
	    FORM.action = JSP;
	    FORM.submit();
	}
}
<%-- 啟動檔案匯出功能 --%>
function export_file() {
	$(".block").show();
	var theForm = document.frm1;
		theForm.action="export/detail_export.jsp";
		theForm.target="_exportFrame";
		theForm.submit();
}

function exportProgress(){   <%-- 檢查檔案是否已經匯出完成 --%>
$.ajax({
	async:false,
	type:"GET",
    url: "export/exportcheck.jsp",
    data: {reportType:"detail_export"},
    success: function(res){
    	res = $.trim(res);
    	// console.log(res);
    	if(res == "start"){
    		$(".block").show();
		}else if((res.indexOf("end")>-1) || (res == "no")){
			$(".block").hide();
			clearProgress();
			if(res.indexOf("end")>-1) {
				location.href = "<%=app_fetchpath+"/root/report/" + app_account + "_detail_export.xls" %>";
			}
			else history.back();
		}
    	window.setTimeout("exportProgress()",1500);
    }
}); 		
}

function clearProgress(){  <%-- 清除檔案匯出完成後之 Session 值 --%>
$.ajax({
	async:false,
	type:"GET",
    url: "export/exportcheck.jsp",
    data: {reportType:"clear_detail_export"},
    success: function(res){
    }
}); 		
}

var timer = window.setTimeout("exportProgress()",1500);

function search_local(){
	var url = "../ajax/change_data.jsp";
	$.post(url,{
		code : "sp",
		outcode:'id',
		qname : $("#qname").val()
	},function(data){
		var jsonObj = JSON.parse(data);  							// 將JSON格式資料轉為物件
		$("#_qname").html(jsonObj.data);
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
			    	    <td align="center" colspan="9" class="information_title-1">
			    		  <span><%=show_title %></span>&nbsp;&nbsp;
						  <span><input type="button" value="收據列表" onclick="javascript:location.href='<%=rl_code %>.jsp'" /></span>&nbsp;
					    </td>
				      </tr>         
			          <tr class="information_bk-2">
	                  	<td colspan="9" align="center"><%=show_title %>查詢</td>
	                  </tr>
					  <tr class="information_bk-2">
	                 	<td width="10%" align="center" class="tablebg">捐款人姓名</td>
	                 	<td width="10%" align="center" class="tablebg">手機</td>
	                 	<td width="10%" align="center" class="tablebg">捐款單編號</td>
	                 	<td width="15%" align="center" class="tablebg">付款方式</td>
	                 	<td width="10%" align="center" class="tablebg">日期區間</td>
	                 	<td width="10%" align="center" class="tablebg">捐款單狀態</td>
	                 	<td width="10%" align="center" class="tablebg">收據開立狀態</td>
						<td width="15%" align="center">收據編號</td>
	                 	<td width="10%" align="center" class="tablebg">&nbsp;</td>
					  </tr>
					  
			  		  <form name="form_search" method="post" action="<%=rl_code %>.jsp" onsubmit="return checkform(this);">          
		              	<tr class="information_table-2-1">
		                     <td align="center" class="tablebg">
		                     	<input name="_qname" id="_qname" type="text" value="<%=qname %>" size="10" />
		                     </td>
		                     <td align="center" class="tablebg">
		                     	<input name="_qphone" id="_qphone" type="text" value="<%=qphone %>" size="10" />
		                     </td>
		                     <td align="center" class="tablebg">
		                     	<input name="_qdhno" id="_qdhno" type="text" value="<%=qdhno %>" size="10" />
		                     </td>
		                     <td align="center">
								<select name="_qpayment" id="_qpayment">
									<option value="">全 &nbsp;部</option>
									<option value="2" <%="2".equals(qpayment)?"selected='selected'":"" %>>匯款轉帳</option>
									<option value="vatm" <%="vatm".equals(qpayment)?"selected='selected'":"" %>>虛擬帳號</option>
									<option value="regular" <%="regular".equals(qpayment)?"selected='selected'":"" %>>定期定額</option>
									<option value="credit" <%="credit".equals(qpayment)?"selected='selected'":"" %>>信用卡</option>
								</select>
							</td>		                     
		                     <td align="center" class="tablebg">
		                     	<input name="_qemitdate" id="_qemitdate" value="<%=qemitdate %>" readonly type="text" size="6" />
		                       	<input name="_qrestdate" id="_qrestdate" value="<%=qrestdate %>" readonly type="text" size="6" />
		                    </td>
		                     <td align="center">
								<select name="_qposition" id="_qposition">
									<option value="Y" <%="Y".equals(qposition)?"selected='selected'":"" %>>正常</option>
									<option value="N" <%="N".equals(qposition)?"selected='selected'":"" %>>作廢</option>
									<option value="%" <%="%".equals(qposition)?"selected='selected'":"" %>>全 &nbsp;部</option>
								</select>
							</td>
							<td align="center">
								<select name="_qrsstatus" id="_qrsstatus">
									<option value="N" <%="N".equals(qrsstatus)?"selected='selected'":"" %>>未開立</option>
									<option value="Y" <%="Y".equals(qrsstatus)?"selected='selected'":"" %>>已開立</option>
									<option value="all" <%="all".equals(qrsstatus)?"selected='selected'":"" %>>全 &nbsp;部</option>
								</select>
							</td>
							<td align="center">
								<input name="_qrlno" id="_qrlno" type="text" value="<%=qrlno %>" size="16" />
							</td>	
							
		                  	<td align="center" class="tablebg">
		                        <input name="query" type="submit" value="查詢">&nbsp;
		            			<input type="button" value="清除" onclick="clearData(this.form);" />
		            			
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
						    <td colspan="11" align="center" class="information_title-1">查詢結果標題列表</td>
						  </tr>
						  <tr class="information_bk-2">
						    <td width="5%" align="center">項目</td>
						    <td width="10%" align="center">捐款人姓名</td>
						    <td width="10%" align="center">手機</td>
						    <td width="10%" align="center">捐款單編號</td>
						    <td width="10%" align="center">付款方式</td>
						    <td width="10%" align="center">捐款日期</td>
						    <td width="10%" align="center">捐款單狀態</td>
						    <td width="10%" align="center">收據開立狀態</td>
		                 	<td width="10%" align="center" class="tablebg">收據編號</td>				
						    <td width="10%" align="center">功能</td>
						    <td width="5%" align="center">收據編號加入</td>
						  </tr>
						  <%for(int i=0;i<dhs.size();i++){ 
								TableRecord dh = (TableRecord)dhs.get(i);
								
								String dh_paymethod = dh.getString("dh_paymethod");
								String dh_paymethod_str = "";
								if("2".equals(dh_paymethod))dh_paymethod_str = "匯款轉帳";
								if("newebpay.credit".equals(dh_paymethod))dh_paymethod_str = "信用卡";
								if("newebpay.vatm".equals(dh_paymethod))dh_paymethod_str="虛擬帳號";
								if("newebpay.regular".equals(dh_paymethod))dh_paymethod_str = "定期定額";
								if("line".equals(dh_paymethod))dh_paymethod_str = "LinePay";
						  %>
						  <form name="list<%=i+1 %>" id="list<%=i+1 %>" method="post">
						  <tr class="information_table-2-1">
							<td align="center"><%=((pageno-1) * page_items)+i+1 %></td>
						    <td align="center"><%=dh.getString("dh_receipt_title") %></td>
						    <td align="center"><%=dh.getString("dh_phone") %></td>
						    <td align="center"><%=dh.getString("dh_no") %></td>
						    <td align="center"><%=dh_paymethod_str %></td>
						    <td align="center"><%=dh.getString("dh_createdate").subSequence(0, 10) %></td>
						    <td align="center"><%="N".equals(dh.getString("dh_status"))?"作廢":"正常" %></td>
						    <td align="center"><%=!"".equals(dh.getString("rs_no"))?"已開立":"未開立" %></td>
				    		<td align="center"><%=dh.getString("rs_no")%></td>						   
						    
						    <td align="center">
								<input type="hidden" name="npage" id="npage" value="<%=pageno%>" />
								<input type="hidden" name="dh_id" id="dh_id" value="<%=dh.getString("dh_id") %>" />
								<input type="hidden" name="code" id="code" value="<%=code %>" />
								<input type="hidden" name="rl_code" id="rl_code" value="<%=rl_code %>" />
								<%=HtmlCoder.hiddenInputs(names, values)%>
								<input type="button" name="m<%=i+1 %>" id="m<%=i+1 %>" value="檢視" onclick="goaction(this.form, '<%=code %>_b.jsp?rl_code=<%=rl_code %>');" />&nbsp;

						    </td>
						    <td  align="center">
								<% if("".equals(dh.getString("rs_no"))){%>
						    	<input type="checkbox" name="modadd" id="m<%=i + 1%>" value="<%=dh.getString("dh_id") %>"/>
						    	<%}%>
						    
						    </td>
						  </tr>
						  </form>
						  <%} %>
						
						<tr class="information_table-2-1">
							<td class="information_bk-2" colspan="11" align="center" height="26px">
							<form name="list" id="list" method="post">
								<input type="hidden" name="rs_no_add" id="rs_no_add" value="" />
								<%=HtmlCoder.hiddenInputs(names, values)%>
								<input type="button" name="add2" id="add2" value="批次開立收據(合併開立)" onclick="goadd_rlno(this.form,'<%=rl_code2%>_c.jsp?action=A');" />
								<input type="button" name="add" id="add" value="批次開立收據(單張分開)" onclick="goadd_rlno(this.form,'<%=rl_code2%>_update.jsp?action=A2');" />
							</form>
							</td>
						</tr>
						
						
						<tr class="information_bk-2" >  
							<td colspan="11" align="center" height="26px">
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
<%=HtmlCoder.getForm("frm1", request.getRequestURI(), names, values) %>
<iframe name="_exportFrame" width="0" height="0" style="display:none"></iframe>
</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf" %>