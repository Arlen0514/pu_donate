<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%
	String page_code = "payment";														// 功能識別碼
	String paymethod = StringTool.validString(request.getParameter("paymethod"));		// 付款方式
	
	JSONObject json = new JSONObject();
	String payment_title = "", payment_notice = "";
	boolean status = true;
	
	/*-- 選項內容 --*/
	if(!"".equals(paymethod)){
		payment_notice = SiteSetup.getText("pay."+paymethod+"."+lang).replace(String.valueOf((char)13), "<br/>");	
		payment_title = paymethod.replace("credit", "線上刷卡").replace("regular", "信用卡定期定額扣款")
								 .replace("linepay", "LINE Pay").replace("vatm", "ATM匯款(虛擬帳號)")
								 .replace("cvspay", "超商繳費").replace("cash", "現金捐款").replace("2", "臨櫃匯款");
	} else {
		status = false;
	}
	
	/*-- 回傳資料 --*/
	json.put("payment_title", payment_title);
	json.put("payment_notice", payment_notice);
	json.put("status", status);

	out.clear();
	out.println(json);
%>