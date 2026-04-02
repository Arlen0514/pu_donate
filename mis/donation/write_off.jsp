<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	// 相關參數設定
	String code 		= "write_off";				// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "捐款沖銷紀錄";				// 功能標題
	int page_items		= 15;						// 列表分頁筆數設定
	String del_switch	= "on"; 					// 若不允許資料刪除 , 請設定 "off" 
	
	int start_year		= 2023;
	
	DecimalFormat df = new DecimalFormat("00");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
	Calendar cal = Calendar.getInstance();
	
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"));				// 沖銷日期
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"));				// 沖銷日期
	String qcode 	 = StringTool.validString(request.getParameter("_qcode"));
	String qname 	 = StringTool.validString(request.getParameter("_qname"));
	String qitem 	 = StringTool.validString(request.getParameter("_qitem"));
	String qstatus 	 = StringTool.validString(request.getParameter("_qstatus"), "Y");
	String qposition = StringTool.validString(request.getParameter("_qposition"));
	
	// 預設查詢日期 20240524 May
	cal.setTime(sdf.parse(app_today));
	cal.add(Calendar.DATE, -30);
		
	String def_qrestdate = app_today , def_qemitdate = sdf.format(cal.getTime());
	
	if("".equals(qemitdate)) {qemitdate = def_qemitdate;}
	if("".equals(qrestdate)) {qrestdate = def_qrestdate;}
	
	// Names and values.
	String[] names = new String[] { 
			"npage", 				 "_qemitdate","_qrestdate", "_qcode",
			"_qname", "_qitem", "_qposition", "_qstatus"
	};
	String[] values = new String[] { 
			String.valueOf(pageno), qemitdate, qrestdate, qcode , 
			qname , qitem , qposition, qstatus
	};
	
	// Get records.
	StringBuffer sb = new StringBuffer();
	Vector keys = new Vector();
	
	sb.append("wh_code like ? and wh_status like ? ");
	keys.add("%"+qcode+"%");
	keys.add("%"+qposition+"%");
	sb.append("and wh_createdate<=? and wh_createdate>=? ");
	keys.add(qrestdate+" 23:59:59");
	keys.add(qemitdate);
	sb.append("and data_id in (select dh_id from "+tbldh+" where dh_name like ? and dh_status like ? and dh_no like ?) ");
	keys.add("%"+qname+"%");
	keys.add("%"+qstatus+"%");
	keys.add("%"+qitem+"%");
	
	Vector<TableRecord> whs = app_sm.selectAll(tblwh, sb.toString(), keys.toArray(), "wh_status ASC, wh_createdate DESC");
	
	// 分頁
	out.write(HtmlCoder.getForm("pageform", request.getRequestURI(), names, values));
	app_dp = new DataPager(whs, page_items);			// 設定資料分頁每頁筆數
	whs = app_dp.getPageContent(pageno);
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
</script>

<style>
	.item_title{
		padding-left: 10px;
		padding-right: 10px;
		line-height: 1.5;		
	}
</style>
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
	                 	<td width="15%" align="center" class="tablebg">沖銷類型</td>
	                 	<td width="20%" align="center" class="tablebg">捐款人姓名</td>
	                 	<td width="15%" align="center" class="tablebg">捐款單編號</td>
	                 	<td width="20%" align="center" class="tablebg">日期區間</td>
	                 	<td width="10%" align="center" class="tablebg">捐款狀態</td>
	                 	<td width="10%" align="center" class="tablebg">沖銷狀態</td>
	                 	<td width="10%" align="center" class="tablebg">&nbsp;</td>
					  </tr>
                      
					  
			  		  <form name="form_search" method="post" action="<%=code %>.jsp" onsubmit="return checkform(this);">          
		              	<tr class="information_table-2-1">
	                 	<td align="center" class="tablebg">
	                 		<select name="_qcode" id="_qcode">
								<option value="" <%="".equals(qcode)?"selected":"" %>>全部</option>
<%-- 								<option value="credit_card" <%="credit_card".equals(qcode)?"selected":"" %>>信用卡</option> --%>
								<option value="pu" <%="pu".equals(qcode)?"selected":"" %>>行動支付</option>
								<option value="virtual_account" <%="virtual_account".equals(qcode)?"selected":"" %>>虛擬帳號</option>
								<option value="credit_regular" <%="credit_regular".equals(qcode)?"selected":"" %>>信用卡定期定額</option>
							</select>
	                 	</td>
	                 	
	                 	<td align="center" class="tablebg">
	                     	<input name="_qname" id="_qname" type="text" value="<%=qname %>" size="20"/>
	                     </td>
	                     <td  align="center" class="tablebg">
	                 		<input type="text" name="_qitem" id="_qitem" value="<%=qitem %>" size="10" placeholder=""/>
	                 	</td>
	                 	
	                 	<td align="center" class="tablebg">
	                 		<input name="_qemitdate" id="_qemitdate" value="<%=qemitdate %>"  type="text" size="6" />
		                    	~
		                    <input name="_qrestdate" id="_qrestdate" value="<%=qrestdate %>"  type="text" size="6" />
	                 	</td>
	                 	<td align="center" class="tablebg">
	                 		<select name="_qstatus" id="_qstatus">
								<option value="Y" <%="Y".equals(qstatus)?"selected='selected'":"" %>>正常</option>
								<option value="N" <%="N".equals(qstatus)?"selected='selected'":"" %>>作廢</option>
								<option value="" <%="".equals(qstatus)?"selected='selected'":"" %>>全部&nbsp;&nbsp;</option>
							</select>
	                 	</td>
	                 	<td align="center" class="tablebg">
	                 		<select name="_qposition" id="_qposition">
								<option value="Y" <%="Y".equals(qposition)?"selected='selected'":"" %>>已沖銷</option>
								<option value="N" <%="N".equals(qposition)?"selected='selected'":"" %>>未沖銷</option>
								<option value="" <%="".equals(qposition)?"selected='selected'":"" %>>全部&nbsp;&nbsp;</option>
							</select>
	                 	</td>
	                 	<td align="center" class="tablebg">
	                 		<input type="submit" value="查詢" />
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
						  <tr class="information_table-2-1">
	                      	<td width="5%" align="center">序號</td>
	                        <td width="17%" align="center">捐款人姓名</td>
	                        <td width="13%" align="center">捐款單編號</td>
	                        <td width="15%" align="center">銷帳編號</td>
	                        <td width="10%" align="center">捐款金額</td>
	                        <td width="10%" align="center">付款方式</td>
	                        <td width="10%" align="center">付款日期</td>
	                        <td width="10%" align="center">捐款狀態</td>
	                        <td width="10%" align="center">沖銷狀態</td>
	                      </tr>
						  <%
							for(int i=0 ; i<whs.size() ;i++){
								TableRecord wh = whs.get(i);
								TableRecord dh = app_sm.select(tbldh, wh.getString("data_id"));
								String pay_date = wh.getString("wh_pay_date").replace("-","/"); 
								String dh_status = dh.getString("dh_status").replace("Y","正常").replace("N","作廢");
						  		String wh_status = wh.getString("wh_status").replace("Y","已沖銷").replace("N","未沖銷");
						  		String wh_code = wh.getString("wh_code").replace("credit_card","信用卡").replace("virtual_account","虛擬帳號").replace("credit_regular","信用卡定期定額").replace("pu","行動支付");
						  %>
						  <tr class="information_table-2-1">
							<td align="center"><%=((pageno-1) * page_items)+i+1 %></td>
	                        <td align="left" class="item_title"><%=dh.getString("dh_name") %></td>
	                        <td align="center"><%=dh.getString("dh_no") %></td>
	                        <td align="center"><%=wh.getString("wh_account") %></td>
	                        <td align="center"><%=app_df.format(wh.getInt("wh_total")) %></td>
	                        <td align="center"><%=wh_code %></td>
	                        <td align="center"><%=pay_date %></td>
	                        <td align="center"><%=dh_status %></td>
	                        <td align="center"><%=wh_status %></td>
	                      </tr>
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