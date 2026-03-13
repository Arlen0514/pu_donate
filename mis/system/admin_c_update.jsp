<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="/WEB-INF/jspf/sha256.jspf"%>
<jsp:useBean id='aub' class='local.beans.AdminUserBean'>
  	<jsp:setProperty name='aub' property='*'/>
</jsp:useBean>
<%
   	// Query conditions.
   	String qaccount = StringTool.validString(request.getParameter("_qaccount"));
   	String qname = StringTool.validString(request.getParameter("_qname"));
   	String qmfid = StringTool.validString(request.getParameter("_qmfid"));

   	// Input data.
   	TableRecord au = new TableRecord(aub);
   	boolean ch_pwd = !au.getString("au_password").isEmpty();
   	
	String au_password = sha256(au.getString("au_password"));

   	// Original data.
   	Vector aus = app_sm.selectAll("admin_user", "au_id=?", new Object[] { au.getValue("au_id") });
   	TableRecord oau = (aus.size() > 0) ? (TableRecord) aus.get(0) : new TableRecord("admin_user");
    if(ch_pwd) oau.setValue("au_password", au_password);
    
   	oau.setValue("au_email", au.getValue("au_email"));
   	oau.setValue("au_modifyuser", app_user.getValue("au_account"));
   	oau.setValue("au_modifydate", DateTimeTool.dateString());

   	// Update record.
   	app_sm.update(oau, new String[] { "au_id" });

   	// Delete authorities.
   	app_sm.delete("admin_map_function", "au_id=?", new Object[]{ au.getValue("au_id") });

   	// Insert authorities.
   	if (app_sm.success()) {
       	// Authorities.
       	Vector mfs = app_sm.selectAll("mis_function", "mf_priority");
       	for (int i = 0; i < mfs.size(); i++) {
           	TableRecord mf = (TableRecord)mfs.get(i);
           	String mfid = mf.getString("mf_id");

           	// authority setting.
           	if (request.getParameter(mfid) != null) {
               	TableRecord amf = new TableRecord("admin_map_function");
               	amf.setValue("amf_id", IDTool.getUID("AMF"));
               	amf.setValue("au_id", au.getString("au_id"));
               	amf.setValue("mf_id", mfid);
               	amf.setValue("amf_createdate",DateTimeTool.dateString());
               	amf.setValue("amf_createuser",app_user.getValue("au_account"));
               	app_sm.insert(amf);
           	}
       	}
   	}
%>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>
<form name="lastpage" method="post" action="admin_b_1.jsp">
  	<input type="hidden" name="node" value="<%=node%>">
  	<input type="hidden" name="npage" value="<%=pageno%>">
	<input type="hidden" name="_qaccount" value="<%=qaccount%>">
  	<input type="hidden" name="_qname" value="<%=qname%>">
  	<input type="hidden" name="_qmfid" value="<%=qmfid%>">
	<input type="submit" style="display:none">
</form>
<%
   	if (app_sm.success()) {
       	out.println("<script> alert('資料修改成功!!'); lastpage.submit(); </script>");
   	} else {
		out.println("<script> alert('修改失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
   	}
%>