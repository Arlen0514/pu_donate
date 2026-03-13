<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	String code	= "admin_b";				// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	int page_items = 15; 					// 列表分頁筆數設定
	
   // Query conditions.
   String qaccount = StringTool.validString(request.getParameter("_qaccount"));
   String qname = StringTool.validString(request.getParameter("_qname"));
   String qmfid = StringTool.validString(request.getParameter("_qmfid"));
   // Get matched records.
   StringBuffer sb = new StringBuffer();
   if (qmfid.equals("")) {
       sb.append("select * from admin_user where au_account like '%"+qaccount+"%' and au_name like '%"+qname+"%' and au_account != 'root' order by au_account");
   } else {
       sb.append("select a.* from admin_user as a, admin_map_function as b where ");
       sb.append(" b.mf_id='"+qmfid+"' and b.au_id = a.au_id and ");
       sb.append("a.au_account like '%"+qaccount+"%' and a.au_name like '%"+qname+"%' and a.au_account != 'root' order by a.au_account");
   }
   Vector vc = app_sm.queryResult(sb.toString());
   // Data paging.
   app_dp = new DataPager(vc , page_items);
   vc = app_dp.getPageContent(pageno);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@include file="include/head.jsp"%>
<script language="JavaScript" type="text/JavaScript">
	/*-- --*/
</script>
<%@include file="/WEB-INF/jspf/mis/pagerscript.jspf"%>
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
                  <td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="2" cellspacing="1">
                    <tr align="center" class="system_title-1">
                        <td colspan="3" class="titlebg"><span class="system_title-1">帳號權限設定－查詢列表</span></td>
                      </tr>
                      <tr align="center" class="system_bk-2">
                        <td width="227" class="tablebg">帳號</td>
                        <td class="tablebg">姓名</td>
                        <td width="247" class="tablebg"><div align="center">功能</div></td>
                      </tr>
<%
   for (int i = 0; i < vc.size(); i++) {
       QueryResult qr = (QueryResult)vc.get(i);
%>
<form name="form<%=i+1%>" method="post">
  <input type="hidden" name="node" value="<%=node%>">
  <input type="hidden" name="npage" value="<%=pageno%>">
  <input type="hidden" name="_qaccount" value="<%=qaccount%>">
  <input type="hidden" name="_qname" value="<%=qname%>">
  <input type="hidden" name="_qmfid" value="<%=qmfid%>">
  <input type="hidden" name="au_id" value="<%=qr.getString("au_id")%>">
                      <tr align="center" class="system_table-2-1">
                        <td class="tablebg"><%=qr.getString("au_account")%></td>
                        <td width="201" class="tablebg"><%=qr.getString("au_name")%></td>
                        <td class="tablebg"><div align="center">
                          <input name="detail<%=i+1%>" type="button"  value="查閱" onClick="goaction(this.form, 'admin_b_2.jsp');">                            
                          <input name="modify<%=i+1%>" type="button"  value="修改" onClick="goaction(this.form, 'admin_c.jsp');">                            
                          <input name="delete<%=i+1%>" type="button"  value="刪除" onClick="godelete(this.form, 'admin_b_1_delete.jsp');">
                        </div></td>
                      </tr>
</form>
<% } %>
                  </table></td></tr>
            </table>
<!-- 分頁 -->
				  <%@include file="/WEB-INF/jspf/mis/pager.jspf"%>
            </td>
          </tr>
          <tr>
            <td colspan="2"><div align="center">
                <br>
</div></td>
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
<form name="pageForm" method="post" action="admin_b_1.jsp">
  <input type="hidden" name="node" value="<%=node%>">
  <input type="hidden" name="npage" value="<%=pageno%>">
  <input type="hidden" name="_qaccount" value="<%=qaccount%>">
  <input type="hidden" name="_qname" value="<%=qname%>">
  <input type="hidden" name="_qmfid" value="<%=qmfid%>">
</form>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>