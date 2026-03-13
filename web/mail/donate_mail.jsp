<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf" %>
<% 
	// 語系變數為 lang
	String page_code = "donate";				// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
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
		                	敬愛的捐款人：您好！<br/>
		                	&emsp;&emsp;誠摯感謝您對本校的慷慨捐助與支持。您的善心不僅展現了對教育的高度關懷，更是對本校校務推動的莫大鼓舞。您的捐款將會依指定用途妥善運用，再次感謝您與我們一同為靜宜大學的永續發展播下希望的種子。之後我們將寄送收據及專函申謝，敬祈續予指導與支持。謹此
							<br/><br/>
							敬祝<br/>
							闔家安康 萬事如意！<br/><br/>
							天主教靜宜大學校友中心 敬上
		                	<%if("pay.newebpay.vatm".equals(dh.getString("dh_paymethod"))){ %>
		                	<br/><br/>
		                	虛擬帳號，銀行代號(<%=ph.getString("ph_bank_no") %>):<%=ph.getString("ph_account") %>
		                	<%} %>
		                	<%-- <br/>
		                	捐款人:<%=dh.getString("dh_name") %>
		                	<br/> --%>
		                </td>
	              	</tr>
	              	
            	</table>
            	<br />
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