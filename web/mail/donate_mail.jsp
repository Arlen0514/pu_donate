<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf" %>
<% 
	// 語系變數為 lang
	String page_code = "donate_mail_content";				// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	lang = StringTool.validString(request.getParameter("lang"));
	
	String dh_id	 = StringTool.validString(request.getParameter("dh_id"));
	TableRecord dh	 = app_sm.select(tbldh, dh_id);
	TableRecord ph   = app_sm.select(tblph, "data_id=?", new Object[]{dh.getString("dh_id")});
	
	// Server name.	
	String servername = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
	if(request.getServerPort()== 80 || request.getServerPort()== 443) {
		servername = request.getScheme()+"://"+request.getServerName();
	} 
	String localname = request.getScheme()+"://"+request.getLocalName()+":"+request.getLocalPort();
	String url = servername + request.getContextPath() + "/web/mail";
	
	TableRecord mail_content = app_sm.select(tblcp, "cp_code = ?", new Object[]{page_code});
	
	TableRecord payment_info = app_sm.select(tblcp, "cp_category = ? and cp_code = ? and cp_lang = ? ", new Object[]{
    		dh.getString("dh_paymethod"), "guide", lang});
	
	
	
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>捐款通知信</title>
</head>
<body>
	<table width="730" border="0" cellpadding="0" cellspacing="0">
		<tr>
        	<td>
	        	<img src="<%=url %>/images/top.png" width="730" style="display:block; border:none;" />
        	</td>
      	</tr>
      	<tr style="background:url(<%=url %>/images/main.png) top left repeat-y;">
	        <td align="center">
	        	<table width="571" border="0" cellpadding="8" cellspacing="0" style="font-size:12px; line-height:20px; margin-top:10px; margin-bottom:10px;">
	              	<tr>
	                	<td colspan="2" align="center" style="padding-left:6px; padding-right:6px; padding-bottom:10px;">
		               		<img src="<%=url %>/images/logo.png" width="180" />
	                	</td>
	              	</tr>
	              	
	              	<tr>
		                <td colspan="2" align="center" style="font-size:15px; color: #000; letter-spacing:1.3px; line-height:24px; padding-left:6px; padding-right:6px; padding-bottom:10px; padding-top:10px; border-bottom: solid 1px #ccc;">
	                		<strong>- 捐款通知信 -</strong>
	                	</td>
	              	</tr>
	              	
		                <td align="left" valign="top" colspan="2">
		                	<%=mail_content.getString("cp_content") %>
		                	
		                	<%if("pay.newebpay.vatm".equals(dh.getString("dh_paymethod"))){ %>
		                	<br/><br/>
		                	虛擬帳號，銀行代號(<%=ph.getString("ph_bank_no") %>):<%=ph.getString("ph_account") %>
		                	<%} %>
		                	
		                	
		                	<br/>
		                	<%=payment_info.getString("cp_desc") %>
		                	
		                	<%-- <br/>
		                	捐款人:<%=dh.getString("dh_name") %>
		                	<br/> --%>
		                	
<%-- 		                	<%if("pay.pu".equals(dh.getString("dh_paymethod"))){ %> --%>
<%-- 		                	<a href="<%=servername + request.getContextPath()%>/web/payment/pupay/get_url.jsp?dh_id=<%=dh_id%>" target="_blank">前往繳款</a> --%>
<%--                             <%} %> --%>
		                </td>
	              	</tr>
	              	
	              	
            	</table>
            	<br />
            	<br />
				<table width="571px" border="0" cellpadding="8" cellspacing="0" style="font-size:12px; line-height:20px; margin-top:10px; margin-bottom:10px;">	
	              	  <tr style="background:#F2EFE9;">
		                <td width="22%" align="right" valign="top">捐款單編號：</td>
		                <td width="78%" align="left" valign="top"><%=dh.getString("dh_no") %></td>
		              </tr>
		              <tr>
		                <td width="22%" align="right" valign="top">捐款日期：</td>
		                <td width="78%" align="left" valign="top"><%=dh.getString("dh_donatedate") %></td>
		              </tr>
		              <tr style="background:#F2EFE9;">
		                <td align="right" valign="top">捐款貴賓：</td>
		                <td align="left" valign="top"><%=dh.getString("dh_name") %></td>
		              </tr>
		              
		              <tr >
		                <td align="right" valign="top">捐款金額：</td>
		                <td align="left" valign="top"><%=dh.getInt("dh_total") %></td>
		              </tr>
		              
		              <tr style="background:#F2EFE9;">
		                <td align="right" valign="top">捐款指定用途：</td>
		                <td align="left" valign="top"><%=dh.getString("dh_donate_project_title") %></td>
		              </tr>
		              <tr >
		                <td align="right" valign="top">付款方式：</td>
		                <td align="left" valign="top">
		                <%=app_sm.select(tblcp, "cp_category = ? and cp_code = ? and cp_lang = ? ", new Object[]{
		                		dh.getString("dh_paymethod"), "guide", lang}).getString("cp_title")%>
		                <br/>
		                <%if(!dh.getString("dh_paymethod").contains("pu")){ %>
		                <%=app_sm.select(tblcp, "cp_category = ? and cp_code = ? and cp_lang = ? ", new Object[]{
		                		dh.getString("dh_paymethod"), "guide", lang}).getString("cp_desc")%>		
		                <%}else{ %>		
		                <a href="<%=servername + request.getContextPath()%>/web/payment/pupay/get_url.jsp?dh_id=<%=dh_id%>" target="_blank">前往繳款</a>
		               	 <%} %>	
		               	</td>
		              </tr>
		              <tr style="background:#F2EFE9;">
		                <td align="right" valign="top">是否開立收據：</td>
		                <td align="left" valign="top"><%="Y".equals(dh.getString("dh_receipt_status"))?"寄送收據":"不寄送收據" %></td>
		              </tr>
		              <%if("Y".equals(dh.getString("dh_receipt_status"))){%>
		              
		              <tr style="background:#F2EFE9;">
		                <td align="right" valign="top">收據抬頭：</td>
		                <td align="left" valign="top"><%=dh.getString("dh_receipt_title") %></td>
		              </tr>
		              <tr>
		                <td align="right" valign="top">收據地址：</td>
		                <td align="left" valign="top"><%=dh.getString("dh_receipt_zipcode")+dh.getString("dh_receipt_county")+dh.getString("dh_receipt_city")+dh.getString("dh_receipt_address") %></td>
		              </tr>
		              
		              <%} %>
	              	
            	</table>
            	<table width="571" border="0" cellspacing="0" cellpadding="0" style="font-size:11px; color:#666;">
              	<tr>
                	<td align="center" style="border-top: dashed 1px #999; line-height:30px;">- 此封信為系統自動寄發，請勿直接回信!! -</td>
              	</tr>
            </table></td>
      	</tr>
      	<tr>
	        <td>
        		<img src="<%=url %>/images/footer.png" width="730" style="display:block; border:none;" />
        	</td>
      	</tr>
    </table>
</body>
</html>
<%
// 關閉連線池
app_sm.close();
%>