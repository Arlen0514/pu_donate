<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%
	String type = StringTool.validString(request.getParameter("type"));				// 捐款類別類型
	String category = StringTool.validString(request.getParameter("category"));		// 捐款類別ID
	
	JSONObject json = new JSONObject();
	String options = "";
	boolean status = true;
	
	Vector<TableRecord> cps = new Vector<TableRecord>();
	
	/*-- 選項內容 --*/
	if("project".equals(type)){							// 募款計畫
		if(!"other".equals(category)) {
			cps = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=? and cp_category=?",
					new Object[]{"donate_project", lang, category}, "cp_showseq ASC, cp_createdate DESC");
			
			options += "<option value=''>請選擇</option>";
			for(TableRecord cp:cps) 
				options += "<option value='"+cp.getString("cp_id")+"'>"+cp.getString("cp_title")+"</option>";
		}
		options += "<option value='other'>其他</option>";
	} else if("department".equals(type)){				// 院系募款
		cps = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=? and cp_category=?",
				new Object[]{"department", lang, category}, "cp_showseq ASC, cp_createdate DESC");
		
		options += "<option value=''>請選擇計畫名稱</option>";
		for(TableRecord cp:cps) 
			options += "<option value='"+cp.getString("cp_id")+"'>"+cp.getString("cp_title")+"</option>";
		if(!"".equals(category)) options += "<option value='other'>其他</option>";
	}
	
	/*-- 回傳資料 --*/
	json.put("status", status);
	json.put("options", options);

	out.clear();
	out.println(json);
%>