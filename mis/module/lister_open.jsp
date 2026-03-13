<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	// 基本參數
	String code 		= "redirect"; 			// 模組識別碼 , 於資料庫做資料識別用
	String page_code	= "redirect";			// 功能識別碼 , 於模組程式檔名用
	String show_title 	= "雲端硬碟維護";				// 功能標題

	Vector <TableRecord> rrs = app_sm.selectAll(tblrr, "rr_code = ? ", new Object[] { code }, "rr_createdate DESC");	

%>
<html>
<head>
<%@include file="include/head.jsp"%>
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
            <td width="60" align="left" valign="middle"><img src="../images/system_icon_1.gif" width="55" height="48" /></td>
            <td align="left" valign="middle" class="system_bigword"><%=show_title %></td>
          </tr>
          <tr>
            <td colspan="2"><hr size="1" noshade></td>
          </tr>
          <tr align="center">
            <td colspan="2"><table width="95%"  border="0" cellspacing="1" cellpadding="0">
              <tr>
                <td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
                    <tr align="center">
						<td colspan="4" class="system_title-1">
                      		<span><%=show_title %></span>&nbsp;&nbsp;
                      	</td>
                    </tr>
			          <tr>
			            <td colspan="2" class="system_bk-2b">&nbsp;</td>
			          </tr>
	                    <tr align="center">
							<td colspan="4" class="system_table-2-1">
								<a href="javascript:void(0);" onclick="window.open('../module/lister.jsp', 'Upload Page', 'width=800,height=600,top=0,left=150,scrollbars=yes,location=no');">
								<img src="../../htmleditor/icons/opened.gif"><span>點我開始上傳</span></a>
	                      	</td>
	                    </tr>
                </table></td>
              </tr>
            </table>
            </td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" class="system_bk-2b">&nbsp;</td>
          </tr>
        </table>
      <!-- InstanceEndEditable --></td>
    </tr>
  </table>
</div>
</body>
<!-- InstanceEnd --></html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>