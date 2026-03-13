<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	//相關參數設定
	String code 		= "receipt";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "收據管理作業";				// 功能標題
	
	// Conditions.
	String qposition = StringTool.validString(request.getParameter("_qposition"));
	String qcollect	 = StringTool.validString(request.getParameter("_qcollect"));
	String qship	 = StringTool.validString(request.getParameter("_qship"));
	String qpayment = StringTool.validString(request.getParameter("_qpayment"));
	String qivoice = StringTool.validString(request.getParameter("_qivoice"));
	
	String qdhno = StringTool.validString(request.getParameter("_qdhno"));
	String qname = StringTool.validString(request.getParameter("_qname"));
	String qphone = StringTool.validString(request.getParameter("_qphone"));
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"));
	
	String qrlno	 = StringTool.validString(request.getParameter("_qrlno"));
	String action = StringTool.validString(request.getParameter("action"));
	
	// Names and values.
	String[] names = new String[] { "npage", "_qposition", "_qname", "_qemitdate", "_qrestdate", "_qship", "_qcollect","_qdhno","_qpayment","_qivoice","_qrlno", "action"};
	String[] values = new String[] { String.valueOf(pageno), qposition, qname, qemitdate, qrestdate, qship, qcollect, qdhno,qpayment,qivoice,qrlno, action };
	
   // Selected id.
   String rs_id = StringTool.validString(request.getParameter("rs_id"));
   // Get record.
   TableRecord rs = app_sm.select(tblrs, rs_id);
   
   // 收據列印模板
   String[] receipt_types = "single;annual;annual2".split(";");
   String[] receipt_pages = "receipt;annual_receipt;annual_receipt2".split(";");
   Map<String, String> receipt_page_map = new HashMap<>();
   
   for(int i=0;i<receipt_types.length;i++) receipt_page_map.put(receipt_types[i], receipt_pages[i]);
   
   String rs_type = rs.getString("rs_type");
   if("".equals(rs_type)) rs_type = "single";
%>
<html>
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/norobots.jspf"%>
<!-- InstanceBeginEditable name="doctitle" -->
<title><%=app_mistitle%></title>
<!-- InstanceEndEditable --><script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>
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
            <td colspan="2" class="information_bk-2b">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td width="8%" align="left" valign="middle"><img src="../images/information_icon_1.gif" width="55" height="48" /></td>
            <td width="92%" align="left" valign="middle" class="information_bigword"><%=show_title %>維護</td>
          </tr>
          <tr>
            <td colspan="2"><hr size="1" noshade></td>
          </tr>
          <tr align="center">
            <td colspan="2"><table width="95%"  border="0" cellspacing="1" cellpadding="0">
              <tr>
                <td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
                    <tr align="center">
                      <td colspan="4" class="information_title-1"> <%=show_title %>維護&nbsp;

                      </td>
                    </tr>
                    <tr align="center" class="information_bk-2">
                      <td colspan="4"><%=show_title %>檢視</td>
                    </tr>
                    <tr align="center">
                      <td class="information_table-2-1" align="right">捐款單編號</td>
                      <td colspan="3" class="information_table-2-1" align="left"><%=rs.getString("dh_no").replaceAll("(;)", "<br />") %></td>
                    </tr>
                    <tr align="center">
                      <td class="information_table-2-1" align="right">收據地址</td>
                      <td colspan="3" class="information_table-2-1" align="left"><%=rs.getString("dh_order_county")+rs.getString("dh_order_zip_code")+rs.getString("dh_order_city")+rs.getString("dh_order_address")%></td>
                    </tr>
                    <tr align="center">
                      <td width="120" class="information_table-2-1" align="right">收據姓名</td>
                      <td width="200" class="information_table-2-1" align="left"><%=rs.getString("dh_order_name")%></td>
                      <td width="120" class="information_table-2-1" align="right">收據身份字號</td>
                      <td width="200" class="information_table-2-1" align="left"><%=rs.getString("dh_pid")%></td>
                    </tr>
                    <tr align="center">
                      <td class="information_table-2-1" align="right">收據營利事業統一編號</td>
                      <td colspan="3" class="information_table-2-1" align="left">
                        <%=rs.getString("dh_compid")%>
                      </td>
                    </tr>
  
                    <tr align="center">
                      <td class="information_table-2-1" align="right">收據金額</td>
                      <td colspan="3" class="information_table-2-1" align="left"><%=rs.getInt("dh_total")%></td>
                      <%--
                      <td class="information_table-2-1" align="right">收據金額(中文)</td>
                      <td class="information_table-2-1" align="left"><%=rs.getString("dh_total_cn")%></td>
                      --%>
                    </tr>
                    
                    <tr class="information_table-2-1">
	                 	<td align="right" class="tablebg">捐款項目 ： </td>
	                 	<td  colspan="3" align="left" class="tablebg">
							<%=rs.getString("rs_donateitem") %>
						</td>
					  </tr>
                    
                    
                    <tr align="center">
                      <td class="information_table-2-1" align="right">最後修改人員</td>
                      <td class="information_table-2-1" align="left"><%=rs.getString("rs_modifyuser")%></td>
                      <td class="information_table-2-1" align="right">最後修改日期</td>
                      <td class="information_table-2-1" align="left"><%=rs.getString("rs_modifydate")%></td>
                    </tr>
                </table></td>
              </tr>
            </table>              <br>
            <input name="previous" type="button" value="回上一頁" onClick="lastpage.submit();">&nbsp;
            <input type="button" value="列印收據" onclick="window.open('../../web/receipt/<%=receipt_page_map.get(rs_type) %>.jsp?rs_id=<%=rs.getString("rs_id")%>')" />&nbsp;
            <%-- 
            <input type="button" value="列印年度收據" onclick="window.open('../../web/receipt/annual_receipt.jsp?rs_id=<%=rs.getString("rs_id")%>')" />&nbsp;
            <input type="button" value="列印年度收據2" onclick="window.open('../../web/receipt/annual_receipt2.jsp?rs_id=<%=rs.getString("rs_id")%>')" />
            --%>
            </td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" class="information_bk-2b">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</div>
<%=HtmlCoder.form("lastpage", code + ".jsp", names, values)%>
</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>