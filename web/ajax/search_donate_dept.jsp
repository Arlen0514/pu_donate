<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%
	String college = StringTool.validString(request.getParameter("college"));		// 院系
	
	JSONObject json = new JSONObject();
	String options = "";
	boolean status = true;
	
    Vector<TableRecord> dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category=? and dm_category<>?", 
    		new Object[] { "department_category", lang, college, "" }, "dm_showseq ASC, dm_createdate DESC");
	
	/*-- 選項內容 --*/
	options += "<option value=''>請選擇系所</option>";
	for(TableRecord dm:dms) 
		options += "<option value='"+dm.getString("dm_id")+"'>"+dm.getString("dm_title")+"</option>";
		
	/*-- 回傳資料 --*/
	json.put("status", status);
	json.put("options", options);

	out.clear();
	out.println(json);
%>