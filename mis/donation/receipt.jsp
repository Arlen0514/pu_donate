<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	// 相關參數設定
	String code 		= "order";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String rl_code 		= "receipt";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "收據管理作業";			// 功能標題
	int page_items		= 15;						// 列表分頁筆數設定
	String del_switch	= "on"; 					// 若不允許資料刪除 , 請設定 "off" 
	
	
	// Conditions.
	String qposition = StringTool.validString(request.getParameter("_qposition"));
	String qcollect	 = StringTool.validString(request.getParameter("_qcollect"));
	String qship	 = StringTool.validString(request.getParameter("_qship"));
	String qpayment = StringTool.validString(request.getParameter("_qpayment"));
	String qivoice = StringTool.validString(request.getParameter("_qivoice"));
	
	String qdhno = StringTool.validString(request.getParameter("_qdhno"));
	String qname = StringTool.validString(request.getParameter("_qname"));
	String qphone = StringTool.validString(request.getParameter("_qphone"));
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"));
	
	String qrlno	 = StringTool.validString(request.getParameter("_qrlno"));
	String action = StringTool.validString(request.getParameter("action"));
	
	if("".equals(qposition)) {qposition = "Y";}
// 	if("".equals(qcollect)) {qcollect = "%";}
// 	if("".equals(qship)) {qship = "%";}
	/*
	if("".equals(qrlno)) {qrlno = "%";}
	*/
	
	String def_qrestdate = "2099/12/31" , def_qemitdate = DateTimeTool.dateString(DateTimeTool.getYear()-1,DateTimeTool.getMonth(),DateTimeTool.getDay());
	if("".equals(qemitdate)) {qemitdate = def_qemitdate;}
	if("".equals(qrestdate)) {qrestdate = def_qrestdate;}
	
	// Names and values.
	String[] names = new String[] { "npage", "_qposition", "_qname", "_qemitdate", "_qrestdate", "_qship", "_qcollect","_qdhno","_qpayment","_qivoice","_qrlno", "action"};
	String[] values = new String[] { String.valueOf(pageno), qposition, qname, qemitdate, qrestdate, qship, qcollect, qdhno,qpayment,qivoice,qrlno, action };
	
	Vector rss = app_sm.selectAll(tblrs , "rs_code=? AND rs_lang=?",  new Object[] { rl_code, lang });
	
	// Get records.
	StringBuffer sb = new StringBuffer();
	Vector keys = new Vector();
	
	sb.append("rs_code=? AND rs_lang=?");
	keys.add(rl_code);
	keys.add(lang);
	sb.append(" and rs_status like ?");	// 新增 收據狀態
	keys.add("%"+qposition+"%");
// 	sb.append(" and dh_order_name like ?");
// 	keys.add("%"+qname+"%");
	sb.append(" and rs_no like ?");//收據編碼
	keys.add("%"+qrlno+"%");
	sb.append(" and !(rs_createdate>? || rs_createdate<?)");
	keys.add(qrestdate+" 24:00:00");
	keys.add(qemitdate);
	rss = app_sm.selectAll(tblrs, sb.toString(), keys.toArray() , "rs_createdate DESC");
	
	
	
	
	
	System.out.println("rl_code :"+rl_code);
	System.out.println("lang :"+lang);
	System.out.println("qposition :"+qposition);
	System.out.println("rs_no :"+qrlno);
	System.out.println("qrestdate :"+qrestdate);
	System.out.println("qemitdate :"+qemitdate);
	
	
	
	
	// 分頁
	out.write(HtmlCoder.getForm("pageform", request.getRequestURI(), names, values));
	app_dp = new DataPager(rss,page_items);			// 設定資料分頁每頁筆數
	rss = app_dp.getPageContent(pageno);
	
   // 收據列印模板
   String[] receipt_types = "single;annual;annual2".split(";");
   String[] receipt_pages = "單筆;年度;年度2".split(";");
   Map<String, String> receipt_page_map = new HashMap<>();
   
   for(int i=0;i<receipt_types.length;i++) receipt_page_map.put(receipt_types[i], receipt_pages[i]);

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<!-- <link href="../css/adm_css.css" rel="stylesheet" type="text/css"> -->
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
	$("#_qpayment").val("");
	$("#_qphone").val("");
	$("#_qemitdate").val("<%=def_qemitdate%>");
	$("#_qrestdate").val("<%=def_qrestdate%>");
	$("#_qposition").val("Y");
	$("#_qcollect").val("");
	$("#_qship").val("");
	$("#_qbonus").val("");
	$("#_qrlno").val("");
}

//收據匯出
function export_receipt() {
	var theForm = document.frm1;
		theForm.action="export/receipt_fill.jsp";
		//theForm.target="_exportFrame";
		theForm.submit();
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
            <td width="60" align="left" valign="middle"><img src="../images/web_icon_1.gif" width="55" height="48"></td>
            <td align="left" valign="middle" class="web_bigword"><%=show_title %></td>
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
			    	    <td align="center" colspan="5" class="web_title-1">
			    		  <span><%=show_title %></span>&nbsp;&nbsp;
						  <span><input type="button" value="收據列表" onclick="javascript:location.href='<%=rl_code %>.jsp'" /></span>&nbsp;
						  <span><input type="button" value="新增單筆收據" onclick="javascript:location.href='<%=rl_code %>_a.jsp'" /></span>&nbsp;
						  <span><input type="button" value="新增年度收據" onclick="javascript:location.href='annual_<%=rl_code %>_a.jsp'" /></span>&nbsp;
						  <span><input type="button" value="新增年度收據2" onclick="javascript:location.href='annual_<%=rl_code %>_a2.jsp'" /></span>
					    </td>
				      </tr>         
			          <tr class="web_bk-2">
	                  	<td colspan="5" align="center"><%=show_title %>查詢</td>
	                  </tr>
					  <tr class="web_bk-2">
	                 	<td width="15" align="center" class="tablebg">收據姓名</td>
	                 	<td width="15%" align="center" class="tablebg">收據編號</td>
	                 	<td width="20%" align="center" class="tablebg">收據開立日期區間</td>
	                 	<td width="10%" align="center" class="tablebg">收據狀態</td>
	                 	<td width="15%" align="center" class="tablebg">&nbsp;</td>
					  </tr>
					  
			  		  <form name="form_search" method="post" action="<%=rl_code %>.jsp" onsubmit="return checkform(this);">          
		              	<tr class="web_table-2-1">
		                     <td align="center" class="tablebg">
		                     	<input name="_qname" id="_qname" type="text" value="<%=qname %>" size="16" />
		                     </td>

		                     <td align="center" class="tablebg">
		                     	<input name="_qrlno" id="_qrlno" type="text" value="<%=qrlno %>" size="10" />
		                     </td>
		                     <td align="center" class="tablebg">
		                     	<input name="_qemitdate" id="_qemitdate" value="<%=qemitdate %>" readonly type="text" size="6" />
		                     		~
		                       	<input name="_qrestdate" id="_qrestdate" value="<%=qrestdate %>" readonly type="text" size="6" />
		                    </td>
		                    <td align="center">
								<select name="_qposition" id="_qposition">
									<option value="Y" <%="Y".equals(qposition)?"selected='selected'":"" %>>正常</option>
									<option value="N" <%="N".equals(qposition)?"selected='selected'":"" %>>作廢</option>
									<option value="" <%="".equals(qposition)?"selected='selected'":"" %>>全 &nbsp;部</option>
								</select>
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
						    <td colspan="7" align="center" class="web_title-1">查詢結果標題列表</td>
						  </tr>
						  <!-- 新增 收據狀態欄位 20221116 May -->
						  <tr class="web_bk-2">
						    <td width="5%" align="center">項目</td>
						    <td width="10%" align="center">收據姓名</td>
						    <td width="10%" align="center">收據編號</td>
						    <td width="10%" align="center">收據開立日期</td>
						    <td width="10%" align="center">收據類型</td>
						    <td width="5%" align="center">收據狀態</td>
						    <td width="10%" align="center">功能</td>
						  </tr>
						  <%for(int i=0;i<rss.size();i++){ 
								TableRecord rs = (TableRecord)rss.get(i);
								String rs_type = rs.getString("rs_type").trim();
								
								if("".equals(rs_type)) rs_type = "single";
						  %>
						  <form name="list<%=i+1 %>" id="list<%=i+1 %>" method="post">
						  <tr class="web_table-2-1">
							<td align="center"><%=((pageno-1) * page_items)+i+1 %></td>
						    <td align="left">&nbsp;&nbsp;<%=rs.getString("dh_order_name") %></td>
						    <td align="left">&nbsp;&nbsp;<%=rs.getString("rs_no") %></td>
						    <td align="center"><%=rs.getString("rs_createdate").subSequence(0, 10) %></td>				    
						    <td align="center"><%=receipt_page_map.get(rs_type) %></td>				    
						    <td align="center"><%="N".equals(rs.getString("rs_status"))?"作廢":"正常" %></td>
						    <td align="center">
								<input type="hidden" name="npage" id="npage" value="<%=pageno%>" />
								<input type="hidden" name="code" id="code" value="<%=code %>" />
								<input type="hidden" name="rl_code" id="rl_code" value="<%=rl_code %>" />
								<input type="hidden" name="rs_id" id="rs_id" value="<%=rs.getString("rs_id") %>" />
								<%=HtmlCoder.hiddenInputs(names, values)%>
								<input type="button" name="m<%=i+1 %>" id="m<%=i+1 %>" value="檢視" onclick="goaction(this.form, '<%=rl_code %>_b.jsp?rl_code=<%=rl_code %>');" />&nbsp;
						    </td>
						  </tr>
						  </form>
						  <%} %>
						<tr class="web_bk-2" >  
							<td colspan="7" align="center" height="26px">
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
			<td colspan="3" class="web_bk-2b">&nbsp;</td>
		</tr>
	
		</table>
	  </td>
     </tr>  
  </table>
</div>
<%=HtmlCoder.getForm("frm1", request.getRequestURI(), names, values) %>
</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf" %>