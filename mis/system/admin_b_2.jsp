<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	String code	= "admin_b";				// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用

   // Query conditions.
   String qaccount = StringTool.validString(request.getParameter("_qaccount"));
   String qname = StringTool.validString(request.getParameter("_qname"));
   String qmfid = StringTool.validString(request.getParameter("_qmfid"));
   // Selected record id.
   String auid = StringTool.validString(request.getParameter("au_id"));
   // Get record.
   Vector aus = app_sm.selectAll("admin_user", "au_id=?", new Object[] { auid });
   TableRecord au = (aus.size() > 0) ? (TableRecord)aus.get(0) : new TableRecord("admin_user");
   // Authorities.
   Vector amfs = app_sm.selectAll("admin_map_function", "au_id=?", new Object[] { auid });
   Vector mfids = new Vector();
   for (int i = 0; i < amfs.size(); i++) {
       TableRecord amf = (TableRecord)amfs.get(i);
       mfids.add(amf.getString("mf_id"));
   }
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@include file="include/head.jsp"%>
<script language="JavaScript" type="text/JavaScript">
	/*-- --*/
</script>
<link href="../css/adm_css.css" rel="stylesheet" type="text/css">
</head>
<%-- 20250331 modify Miles top menu.jsp  改成 RWD --%>    
<body class="default_body">
<div class="pageContent default_pageContent">
<div align="center" class="default_area">
  <table class="default_table" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td colspan="2">
      	<table border="0" cellspacing="0" cellpadding="0">       
			<%@include file="/WEB-INF/jspf/mis/top.jspf"%>
      </table>
      </td>
    </tr>
    
    <tr class="default_table_bottom page_mis">
    
      <td width="" align="center" valign="top" class="system_bk-2">
      		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<%@include file="../leftmenu.jsp"%>          
      		</table>
      	</td>
      
      		<td width="99%" align="center" valign="top" class="system_bk-2p right_content_style"><table width="99%" border="0" cellspacing="0" cellpadding="0">
<%-- 20250331 modify Miles top menu.jsp  改成 RWD --%>      		
      		
          <tr>
            <td colspan="2" class="system_bk-2b">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td width="60" align="left" valign="middle"><img src="../images/system_icon_1.gif" width="55" height="48"></td>
            <td align="left" valign="middle" class="system_bigword">帳號權限設定</td>
          </tr>
          <tr>
            <td colspan="2"><hr size="1" noshade></td>
          </tr>
          <tr align="center">
            <td colspan="2"><table width="95%"  border="0" cellspacing="1" cellpadding="0">
                <tr>
                  <td class="system_bk-2bk">                    <table width="100%" border="0" align="center" cellpadding="2" cellspacing="1">
                      <tr align="center" class="system_title-1">
                        <td colspan="4" class="titlebg"><span class="system_title-1">帳號權限設定－查閱</span></td>
                      </tr>
                      <tr class="system_table-2-1">
                        <td width="15%" align="right" class="tablebg">帳號</td>
                        <td width="23%" align="left" class="tablebg"><%=au.getString("au_account")%></td>
                        <td width="15%" align="left" class="tablebg"><div align="right">姓名</div></td>
                        <td width="28%" align="left" class="tablebg"><%=au.getString("au_name")%></td>
                      </tr>
                      <tr class="system_table-2-1">
                        <td align="right" class="tablebg">E-MAIL</td>
                        <td colspan="3" align="left" class="tablebg"><%=au.getString("au_email")%></td>
                      </tr>
                      <tr class="system_table-2-1">
                        <td align="right" class="tablebg">權限設定</td>
                        <td colspan="3" align="left" class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
<% // First level functions.
   for (int i = 0; i < app_tmfs.size(); i++) {
       TableRecord tmf = (TableRecord)app_tmfs.get(i);
%>
                        <tr class="system_table-2-1">
                          <td width="20" align="left" class="system_table-2-1"><input type="checkbox" name="<%=tmf.getString("mf_id")%>" value="1" disabled <%=(StringTool.indexOf(tmf.getString("mf_id"), mfids)>=0)?"checked":""%>></td>
                          <td colspan="3" align="left" class="system_table-2-1"><%=tmf.getString("mf_name")%></td>
                        </tr>
<% // Second level functions.
   Vector mfs2 = app_sm.selectAll("mis_function", "mf_status='N' and mf_upfunction=? and mf_type='2'", new Object[] { tmf.getValue("mf_id") }, "mf_priority");
   for (int j = 0; j < mfs2.size(); j++) {
       TableRecord mf2 = (TableRecord)mfs2.get(j);
%>
                        <tr class="system_table-2-1">
                          <td align="left" class="system_table-2-1">&nbsp;</td>
                          <td width="20" align="left" class="system_table-2-1"><input type="checkbox" name="<%=mf2.getString("mf_id")%>" value="2" disabled <%=(StringTool.indexOf(mf2.getString("mf_id"), mfids)>=0)?"checked":""%>></td>
                          <td colspan="2" align="left" class="system_table-2-1"><%=mf2.getString("mf_name")%></td>
                        </tr>
<% // Third level functions.
   Vector mfs3 = app_sm.selectAll("mis_function", "mf_status='N' and mf_upfunction=? and mf_type='3'", new Object[] { mf2.getValue("mf_id") }, "mf_priority");
   for (int k = 0; k < mfs3.size(); k++) {
       TableRecord mf3 = (TableRecord)mfs3.get(k);
%>
                        <tr class="system_table-2-1">
                          <td align="left" class="system_table-2-1">&nbsp;</td>
                          <td align="left" class="system_table-2-1">&nbsp;</td>
                          <td width="20" align="left" class="system_table-2-1"><input type="checkbox" name="<%=mf3.getString("mf_id")%>" value="3" disabled <%=(StringTool.indexOf(mf3.getString("mf_id"), mfids)>=0)?"checked":""%>></td>
                          <td align="left" class="system_table-2-1"><%=mf3.getString("mf_name")%></td>
                        </tr>
<% } %>
<% } %>
<% } %>
                        </table></td>
                      </tr>
                      <tr class="system_table-2-1">
                        <td align="right" class="tablebg">最後修改人員</td>
                        <td align="left" class="tablebg"><%=au.getString("au_modifyuser")%></td>
                        <td align="right" class="tablebg">最後修改日期</td>
                        <td align="left" class="tablebg"><%=au.getString("au_modifydate")%></td>
                      </tr>
                    </table>                  </td>
                </tr>
            </table>
            <br>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <input name="previous" type="button"  value="回上一頁" onClick="lastpage.submit()"></td>
          </tr>
          <tr align="center">
            <td colspan="2"><p>              <br>
</p>
            </td>
          </tr>
          <tr>
            <td colspan="2" class="system_bk-2b">&nbsp;</td>
          </tr>
        </table>
        <p>&nbsp;</p>
      <!-- InstanceEndEditable --></td>
    </tr>
  </table>
</div>
</div>
</body>
<!-- InstanceEnd --></html>
<form name="lastpage" method="post" action="admin_b_1.jsp">
  <input type="hidden" name="node" value="<%=node%>">
  <input type="hidden" name="npage" value="<%=pageno%>">
  <input type="hidden" name="_qaccount" value="<%=qaccount%>">
  <input type="hidden" name="_qname" value="<%=qname%>">
  <input type="hidden" name="_qmfid" value="<%=qmfid%>">
</form>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>