<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	// 相關參數設定
	String code 		= "accumulate";				// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "捐款金額累計";				// 功能標題
	int page_items		= 30;						// 列表分頁筆數設定
	String del_switch	= "on"; 					// 若不允許資料刪除 , 請設定 "off" 
	
	// Conditions.
	String qname = StringTool.validString(request.getParameter("_qname"));
	String qphone = StringTool.validString(request.getParameter("_qphone"));
	String qemail = StringTool.validString(request.getParameter("_qemail"));
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"));
	
	String def_qrestdate = "2099/12/31" , def_qemitdate = DateTimeTool.dateString(DateTimeTool.getYear()-1,DateTimeTool.getMonth(),DateTimeTool.getDay());
	if("".equals(qemitdate)) {qemitdate = def_qemitdate;}
	if("".equals(qrestdate)) {qrestdate = def_qrestdate;}
	
	// Names and values.
	String[] names = new String[] { 
		"npage", "_qname", "_qphone", "_qemail", "_qemitdate", "_qrestdate"
	};
	String[] values = new String[] { 
		String.valueOf(pageno), qname, qphone, qemail, qemitdate, qrestdate
	};
	
	// Get records.
	// 會員資料
	StringBuffer sb = new StringBuffer();
	Vector keys = new Vector();
	
	sb.append("mp_code=? and mp_name like ? ");
	keys.add("member");
	keys.add("%"+qname+"%");
	sb.append("and mp_email like ? and mp_cellphone like ?");
	keys.add("%"+qemail+"%");
	keys.add("%"+qphone+"%");
	
	Vector<TableRecord> mps = app_sm.selectAll(tblmp, sb.toString(), keys.toArray() , "mp_total DESC, mp_createdate DESC");
	Map<String, TableRecord> member_info_map = new HashMap<String, TableRecord>();
	
	for(TableRecord mp:mps) member_info_map.put(mp.getString("mp_id"), mp);
	
	// 捐款資料
	StringBuffer sb2 = new StringBuffer();
	Vector keys2 = new Vector();
	
	sb2.append("dh_code=? AND dh_lang=? ");
	keys2.add("donate");
	keys2.add(lang);
	sb2.append("and dh_collect=? and dh_status=? ");
	keys2.add("Y");
	keys2.add("Y");
	sb2.append("and dh_donate_project_category !='' ");
	sb2.append("and !(dh_createdate>? || dh_createdate<?)");
	keys2.add(qrestdate+" 24:00:00");
	keys2.add(qemitdate);
	
	Vector<TableRecord> dhs = app_sm.selectAll(tbldh, sb2.toString(), keys2.toArray() , "dh_donatedate ASC, dh_createdate DESC");

	// 統計資料
	Map<String, JSONObject> donate_info_map = new HashMap<String, JSONObject>();
	Vector<String> key_set = new Vector<String>();
	
	for(TableRecord dh:dhs){
		JSONObject donate_info = new JSONObject();
		String key = dh.getString("mp_id");
		boolean in_list = member_info_map.containsKey(key);
		
		if(in_list){
			int dh_total = dh.getInt("dh_total");
			
			if(donate_info_map.containsKey(key)) {
				donate_info = donate_info_map.get(key);
				dh_total += donate_info.getInt("dh_total");
			} else {
				donate_info.put("mp_id", key);
				key_set.add(key);
			}
			donate_info.put("dh_total", dh_total);
			donate_info_map.put(key, donate_info);
		}
		
		
		System.out.println(dh.getString("dh_id")+"---on list--"+in_list);
		
	}
	
	key_set.sort(Comparator.comparingInt(key -> donate_info_map.get(key).getInt("dh_total")).reversed()
	    				   .thenComparing(key -> donate_info_map.get(key).getString("mp_id")));
	
	// 等級顏色
	Map<Integer, String> color_range_type = new HashMap<Integer, String>();
	Map<Integer, String> color_range_name = new HashMap<Integer, String>();
	String[] color_types = {"market", "basic", "system", "web"};
	String[] tag_names = {"1000W", "500W", "100W", "10W"};
	int[] total_range = {1000, 500, 100, 10};						// 要先乘以10000再判斷
	
	for(int i=0;i<total_range.length;i++) {
		color_range_type.put(total_range[i], color_types[i]);
		color_range_name.put(total_range[i], tag_names[i]);
	}
	
	/*
	// 分頁
	out.write(HtmlCoder.getForm("pageform", request.getRequestURI(), names, values));
	app_dp = new DataPager(mps,page_items);			// 設定資料分頁每頁筆數
	mps = app_dp.getPageContent(pageno);
	*/
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<!-- <link href="../css/adm_css.css" rel="stylesheet" type="text/css"> -->
<title><%=app_mistitle%></title>
<%@include file="include/head.jsp"%>
<%-- <%@include file="../../JQuery/jquery.jsp" %> --%>
<%-- <%@include file="../../JQuery/include_date.jsp" %> --%>
<%-- <%@include file="/WEB-INF/jspf/mis/pagerscript.jspf"%> --%>
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
	$("#_qemail").val("");
	$("#_qemitdate").val("<%=def_qemitdate%>");
	$("#_qrestdate").val("<%=def_qrestdate%>");
}

<%-- 更新捐款累計金額 
function update_donate_total(){
	let url = '../servlet/calculate_donate_total.jsp';
	let data = {
			async: false,
	};	
	
	$.post(url, data, function(res){
		let jsonObj = JSON.parse(res);
		
		if(jsonObj.status){
			alert('捐款累計金額更新完成!!');
			location.reload();
		}
	});
}

$(document).ready(function(){
	$('#update_donate_total').on('click', update_donate_total);
})
--%>

<%-- 捐款資料CSV匯出 --%>
var timer;
// 啟動檔案匯出功能
function export_file() {
	var theForm = document.frm1;
	timer = window.setTimeout("exportProgress()", 1500);
	$(".block").show();

	// 查詢資料送出
	theForm.action="export/accumulate_export.jsp";
	theForm.target="_exportFrame";
	theForm.submit();
}

// 檢查檔案是否已經匯出完成
function exportProgress() {
	$.ajax({
		async: false,
		type: "GET",
		url: "export/exportcheck.jsp",
		data: { reportType:"accumulate_export" },
		success: function(res) {
			res = $.trim(res);
			
			if(res == "start") {
				$(".block").show();
				window.setTimeout("exportProgress()", 1500);
			} else if((res == "end") || (res == "no")) {
				$(".block").hide();
				clearProgress();
				if(res == "end") window.open("export/download.jsp?file=<%=app_account %>_accumulate_export.xlsx", "捐款累計查詢匯出" );
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
		data: { reportType:"clear_accumulate_export" },
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
	                 	<td width="20%" align="center" class="tablebg">捐款人姓名</td>
	                 	<td width="20%" align="center" class="tablebg">連絡電話</td>
	                 	<td width="20%" align="center" class="tablebg">電子信箱</td>
	                 	<td width="20%" align="center" class="tablebg">日期範圍</td>
	                 	<td width="20%" align="center" class="tablebg">&nbsp;</td>
					  </tr>
					  
			  		  <form name="form_search" method="post" action="<%=code %>.jsp" onsubmit="return checkform(this);">          
		              	<tr class="information_table-2-1">
		                    <td align="center" class="tablebg">
		                     	<input name="_qname" id="_qname" type="text" value="<%=qname %>" size="20" />
		                    </td>
		                    <td align="center" class="tablebg">
		                     	<input name="_qphone" id="_qphone" type="text" value="<%=qphone %>" size="20" />
		                    </td>
		                    <td align="center" class="tablebg">
		                     	<input name="_qemail" id="_qemail" type="text" value="<%=qemail %>" size="20" />
		                    </td>
		                     
		                    <td align="center" class="tablebg">
		                     	<input name="_qemitdate" id="_qemitdate" value="<%=qemitdate %>" readonly type="text" size="6" /> ~
		                       	<input name="_qrestdate" id="_qrestdate" value="<%=qrestdate %>" readonly type="text" size="6" />
		                    </td>
		                     
		                  	<td align="center" class="tablebg">
		                        <input name="query" type="submit" value="查詢">&nbsp;
		            			<input type="button" value="清除" onclick="clearData(this.form);" />&nbsp;
		            			<input type="button" value="查詢匯出" onclick="export_file();">
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
						    <td width="15%" align="center">捐款人姓名</td>
						    <td width="20%" align="center">連絡電話</td>
						    <td width="20%" align="center">電子信箱</td>
						    <td width="20%" align="center">累計金額</td>
						  </tr>
						  <%for(int i=0;i<key_set.size();i++){ 
								String key = key_set.get(i);
								JSONObject donate_info = donate_info_map.get(key);
								TableRecord mp = member_info_map.get(key);
								String color_str = "information", tag_str = "";
								int total = donate_info.getInt("dh_total");
								
								for(int k=0;k<total_range.length;k++){
									if(total >= (total_range[k]*10000)){
										color_str = color_types[k];
										tag_str = "("+tag_names[k]+"達標)";
										break;
									}
								}
						  %>
						  <form name="list<%=i+1 %>" id="list<%=i+1 %>" method="post">
						  <tr class="<%=color_str %>_table-2-1">
							<td align="center"><%=((pageno-1) * page_items)+i+1 %></td>
						    <td align="left">
						    	&nbsp;&nbsp;<%=mp.getString("mp_name") %>&nbsp;
						    	<span style="color: red;"><%=tag_str %></span>
						    </td>
						    <td align="center"><%=mp.getString("mp_cellphone") %></td>
						    <td align="center"><%=mp.getString("mp_email") %></td>
				    		<td align="center"><%=app_df.format(total) %></td>						   
						  </tr>
						  </form>
						  <%} %>
						  
						  <%-- 
						  <tr class="information_bk-2" >  
							<td colspan="9" align="center" height="26px">
								<input type="button" id="update_donate_total" value="捐款累計金額更新" />
							</td>
						  </tr>
						  				
						  <tr class="information_bk-2" >  
							<td colspan="9" align="center" height="26px">
							  <%@include file="/WEB-INF/jspf/mis/pager.jspf"%>
							</td>
						  </tr>
						  --%>
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
