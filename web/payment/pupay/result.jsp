<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.json.*" %>
<%@ page import="java.io.*" %>
<%@include file="config.jsp"%>
<%
    // 1. 先拿 request 參數
    String requestJson = StringTool.validString(request.getParameter("request"));
    System.out.println("RAW requestJson: " + requestJson);

    // 2. 防呆：空值
    if(requestJson == null || requestJson.trim().isEmpty()){
        out.print("{\"success\":-1,\"message\":\"沒有收到 request 參數或空值\"}");
        return;
    }

    // 3. 解析 JSON
    JSONObject jsonObj = null;
    try {
        jsonObj = new JSONObject(requestJson);
    } catch(Exception e){
        e.printStackTrace();
        out.print("{\"success\":-1,\"message\":\"JSON 格式不合法: " + e.getMessage() + "\"}");
        return;
    }

    // 4. 取各欄位
    String payment_time = jsonObj.optString("payment_time", "");
    int amount = jsonObj.optInt("amount", -1);
    String card_last4 = jsonObj.optString("card_last4", "");
    String order_id = jsonObj.optString("order_id", "");
    String status = jsonObj.optString("status", "");
    String message = jsonObj.optString("message", "");
    String method = jsonObj.optString("method", "");

    // 5. 防呆檢查
    if(payment_time.isEmpty() || amount <= 0 || order_id.isEmpty() || status.isEmpty() || method.isEmpty()){
        out.print("{\"success\":-1,\"message\":\"缺少必要欄位或資料不合法\"}");
        return;
    }

    // 6. 付款方式檢查
    if(!("信用卡".equalsIgnoreCase(method) || "LINEPAY".equalsIgnoreCase(method) || "TAIWAN PAY".equalsIgnoreCase(method))){
        out.print("{\"success\":-1,\"message\":\"付款方式不合法\"}");
        return;
    }

    // 7. 交易狀態檢查
    if(!("SUCCESS".equalsIgnoreCase(status) || "FAIL".equalsIgnoreCase(status))){
        out.print("{\"success\":-1,\"message\":\"交易狀態不合法\"}");
        return;
    }

    // 8. TODO: 寫入資料庫
    // insert into payment_log(payment_time, amount, card_last4, order_id, status, message, method)
    
    
    if("".equals(order_id.trim())){
    	System.out.println("訂單 :"+order_id+"遺失");
    	
    }else{
    	
    	TableRecord ph = app_sm.select(tblph, "ph_no = ?",
				new Object[]{order_id});
    	ph.setUpdate("pu_receive");
    	
        ph.setValue("ph_bank_no",card_last4);
        ph.setValue("ph_payment",method);
        ph.setValue("ph_status",status);
        ph.setValue("ph_return_msg",message);
        ph.setValue("ph_paydate",payment_time);
    	
		if(!"".equals(ph.getString("ph_id"))){
        	
        	app_sm.update(ph);
        	
        }else{
        	TableRecord dh = app_sm.select(tbldh,"dh_no = ?", new Object[]{order_id});
        	ph.setValue("data_id",dh.getString("dh_id"));
        	app_sm.insert(ph);
        }    	
    	
    	/*-------------------更新dh--------------------------*/
    	TableRecord dh = app_sm.select(tbldh,ph.getString("data_id"));
    	dh.setUpdate("pupay");
        dh.setValue("dh_collect", "Y");
//         dh.setValue("dh_payno", outNo); // 建議存金流交易單號
        app_sm.update(dh);
    	
    }
    
    

    // 9. 成功回應
    out.print("{\"success\":1,\"message\":\"資料接收成功\"}");
%>
