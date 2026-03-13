<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%
	String reportType = request.getParameter("reportType");
	String sessionKey = null;
	// 若有多檔需下載 , 可以識別字做為區分

	// 捐款紀錄匯出
	if("donate_export".equals(reportType)){ sessionKey = "donate_file";  }
	if("clear_donate_export".equals(reportType)){ session.setAttribute("donate_file","");  }
	
	// 捐物紀錄匯出
	if("thing_export".equals(reportType)){ sessionKey = "thing_file";  }
	if("clear_thing_export".equals(reportType)){ session.setAttribute("thing_file","");  }

	// 出納系統匯出
	if("receipt_export".equals(reportType)){ sessionKey = "receipt_file";  }
	if("clear_receipt_export".equals(reportType)){ session.setAttribute("receipt_file","");  }
	
	// 感謝狀批次列印
	if("letter_export".equals(reportType)){ sessionKey = "letter_file";  }
	if("clear_letter_export".equals(reportType)){ session.setAttribute("letter_file","");  }
	
	// 捐款累計匯出
	if("accumulate_export".equals(reportType)){ sessionKey = "accumulate_file";  }
	if("clear_accumulate_export".equals(reportType)){ session.setAttribute("accumulate_file","");  }
	
	// 回傳前端 Ajax Session 的狀態值
	Object res = session.getAttribute(sessionKey);
	out.print(res);
%>