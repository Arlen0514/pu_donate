<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@ include file="/web/include/encryption.jsp"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<%@ page import="java.util.List" %>
<%
	String code 		= StringTool.validString(request.getParameter("code"));		// 識別碼
	String db_names 	= tbldh; 													// 使用哪張資料表
	String show_title 	= "感謝狀批次列印";												// 功能標題
	String src = StringTool.validString(request.getParameter("src"));
	src = "".equals(src)?"":"?src="+src;

	try {
		String action = StringTool.validString(request.getParameter("action"));		//A:新增,M:修改,D:刪除,S:排序
		String dh_id = StringTool.validString(request.getParameter("dh_id"));
	
		// Conditions.
		String qname = StringTool.validString(request.getParameter("_qname"));
		String qphone = StringTool.validString(request.getParameter("_qphone"));
		String qdhno = StringTool.validString(request.getParameter("_qdhno"));
		String qpayment = StringTool.validString(request.getParameter("_qpayment"),"");	
		String qemitdate = StringTool.validString(request.getParameter("_qemitdate"));
		String qrestdate = StringTool.validString(request.getParameter("_qrestdate"));
		String qposition = StringTool.validString(request.getParameter("_qposition"), "Y");
		String qcollect	 = StringTool.validString(request.getParameter("_qcollect"), "Y");
		String qidentity	 = StringTool.validString(request.getParameter("_qidentity"));
	
		// Names and values.
		String[] names = new String[] { 
			"npage", "_qname", "_qphone", "_qdhno", "_qpayment", "_qemitdate", "_qrestdate", "_qposition", "_qcollect", "_qidentity"
		};
		String[] values = new String[] { 
			String.valueOf(pageno), qname, qphone, qdhno, qpayment, qemitdate, qrestdate, qposition, qcollect, qidentity
		};
		
		// 變更贈與身分(感謝狀)
		if("IDENTITY".equals(action)){
			TableRecord dh = app_sm.select(db_names, "dh_id=?", new Object[]{dh_id});
			String dh_identity_thank = String.valueOf(request.getParameter("dh_identity_thank"));
			
			dh.setValue("dh_identity_thank", dh_identity_thank);
			dh.setUpdate(app_account);
			app_sm.update(dh);
			
			// 回列表頁
			out.write(HtmlCoder.getForm("listpage", code + ".jsp", names, values));
			out.println("<script> alert('贈與身分(感謝狀)修改成功!!');listpage.submit(); </script> ");
			return;		
		}	
	}catch(Exception e){
		System.out.println("Project" + projectName + ", Error info:["+e+"]File name edit.jsp for ["+code+"]Time:["+DateTimeTool.dateTimeString()+"]");
		out.println("<script> alert('處理失敗'); history.back(); </script>");
	}finally{app_sm.close();}
%>