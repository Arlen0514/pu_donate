<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="/WEB-INF/jspf/sha256.jspf"%>
<jsp:useBean id='aub' class='local.beans.AdminUserBean'>
  	<jsp:setProperty name='aub' property='*'/>
</jsp:useBean>
<%
   	TableRecord tr = new TableRecord(aub);

	// 檢查帳號跟E-mail.
   	Vector trs = app_sm.selectAll("admin_user", "au_account=? ", new Object[]{ tr.getValue("au_account") });

   	if(trs.size() == 0) {
   		String au_password = sha256(tr.getString("au_password"));

   		// 新增帳號
		tr.setValue("au_id", IDTool.getUID("AU"));
		tr.setValue("au_password", au_password);
       	tr.setValue("au_createdate", DateTimeTool.dateString());
       	tr.setValue("au_createuser", app_user.getValue("au_account"));
       	tr.setValue("au_modifydate", DateTimeTool.dateString());
       	tr.setValue("au_modifyuser", app_user.getValue("au_account"));
       	app_sm.insert(tr);

       	if(app_sm.success()) {
           	// Authorities.
           	Vector mfs = app_sm.selectAll("mis_function", "mf_priority");
           	TableRecord mf = null;
           	String mfid = "";
           	TableRecord amf = null;

           	for(int i = 0; i < mfs.size(); i++) {
               	mf = (TableRecord)mfs.get(i);
               	mfid = mf.getString("mf_id");
               	// authority setting.
               	if(request.getParameter(mfid) != null) {
                   	amf = new TableRecord("admin_map_function");
                   	amf.setValue("amf_id", IDTool.getUID("AMF"));
                   	amf.setValue("au_id", tr.getString("au_id"));
                   	amf.setValue("mf_id", mfid);
                   	amf.setValue("amf_createdate",DateTimeTool.dateString());
                   	amf.setValue("amf_createuser",app_user.getValue("au_account"));
                   	app_sm.insert(amf);
               	}
           	}
       	}
   	}
%>
<form id="lastpage" name="lastpage" method="post" action="admin_a.jsp">
  	<input type="hidden" name="node" value="<%=node%>">
  	<input type="submit" style="display:none">
</form>
<%
	if (trs.size() > 0) {
       	out.println("<script> alert('帳號重複!!請重新輸入!!'); history.back(); </script>");
   	} else if (app_sm.success()) {
       	out.println("<script> alert('資料新增成功!!'); document.getElementById('lastpage').submit(); </script>");
   	} else {
		out.println("<script> alert('新增失敗，失敗原因："+app_sm.getMessage().replace("'", "\"")+"'); history.back(); </script>");
   	}
%>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>