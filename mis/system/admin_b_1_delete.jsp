<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
   // Query conditions.
   String qaccount = StringTool.validString(request.getParameter("_qaccount"));
   String qname = StringTool.validString(request.getParameter("_qname"));
   String qmfid = StringTool.validString(request.getParameter("_qmfid"));
   // Selected record id.
   String auid = StringTool.validString(request.getParameter("au_id"));
   // Delete record.
   app_sm.delete("admin_user", "au_id=?", new Object[] { auid });
   if (app_sm.success()) {
       app_sm.delete("admin_map_function", "au_id=?", new Object[] { auid });
   }
%>
<form name="lastpage" method="post" action="admin_b_1.jsp">
  <input type="hidden" name="node" value="<%=node%>">
  <input type="hidden" name="npage" value="<%=pageno%>">
  <input type="hidden" name="_qaccount" value="<%=qaccount%>">
  <input type="hidden" name="_qname" value="<%=qname%>">
  <input type="hidden" name="_qmfid" value="<%=qmfid%>">
	<input type="submit" style="display: none;">
</form>
<%
   	if (app_sm.success()) {
       	out.println("<script> alert('資料刪除成功!!'); lastpage.submit(); </script>");
   	} else {
		out.println("<script> alert('刪除失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
   	}
%>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>