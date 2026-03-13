<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%@ include file="/web/include/encryption.jsp"%>
<%
	String code 		= "thing";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "捐物資訊管理";				// 功能標題

	String dh_id = StringTool.validString(request.getParameter("dh_id"));
	String src = StringTool.validString(request.getParameter("src"));
	TableRecord dh = app_sm.select(tbldh, dh_id);
	// Conditions.
	String qname = StringTool.validString(request.getParameter("_qname"));
	String qid = StringTool.validString(request.getParameter("_qid"));
	String qphone = StringTool.validString(request.getParameter("_qphone"));
	String qdhno = StringTool.validString(request.getParameter("_qdhno"));
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"));
	String qposition = StringTool.validString(request.getParameter("_qposition"));

	// Names and values.
	String[] names = new String[] { 
		"npage", "_qname", "_qid", "_qphone", "_qdhno", "_qemitdate", "_qrestdate", "_qposition"
	};
	String[] values = new String[] { 
		String.valueOf(pageno), qname, qid, qphone, qdhno,  qemitdate, qrestdate, qposition
	};
	
	String dh_pid = dh.getString("dh_pid");
	
	if(!"".equals(dh_pid) && dh_pid.contains("==")) dh_pid = new AESDataEncryption().AESDecrypt(dh_pid);
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
<script>
function checkform(F) {
	//驗證副檔名
	var file_chk = /([^\/]+\.(?:jpg|jpeg|gif|png))/;
	//驗證中文
	var chnese_chk = /[\u4e00-\u9fa5]/;
	
    return true;
}
function goaction(FORM,JSP) {
    FORM.action = JSP;
    FORM.submit();
}
</script>
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
				<td width="60" align="left" valign="middle">
					<img src="../images/information_icon_1.gif" width="55" height="48">
				</td>
				<td align="left" valign="middle" class="information_bigword"><%=show_title%></td>
			</tr>
			<tr>
				<td colspan="2">
				<hr size="1" noshade>
				</td>
			</tr>
			<tr>
				<td align="center" colspan="2">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<tr>
						<td class="system_bk-2bk">
						<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
							<tr>
								<td align="center" colspan="4" class="information_title-1"><%=show_title%>&nbsp;&nbsp;
									<input type="button" value="新增捐物單" onclick="javascript:location.href='<%=code%>_a.jsp'" />&nbsp;
									<input type="button" value="捐物單列表" onclick="javascript:location.href='<%=code%>.jsp'" />&nbsp;
								</td>
							</tr>

							<tr align="center" class="information_bk-2">
								<td colspan="4" align="center">檢視資訊</td>
							</tr>
							<tr>
		                  		<td colspan="4" align="center" class="information_title-1">捐物資訊</td>
		                	</tr>						
						  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right">捐物單編號 ： </td>
		                 		<td width="30%" align="left"><%=dh.getString("dh_no") %></td>						  	
		                  		<td align="right" class="tablebg">受贈日期 ： </td>
		                 		<td align="left" class="tablebg"><%=dh.getString("dh_donatedate") %></td>
						  	</tr>
		                  
		                  	<tr class="information_table-2-1">
								<td align="right" class="tablebg">財務屬性 ： </td>
		                 		<td align="left" class="tablebg">
		                 			<%=dh.getString("dh_donate_project_category").replace("1","財產").replace("2","非消耗品").replace("3","消耗品") %>
		                 		</td>
								<td align="right" class="tablebg">財務名稱 ： </td>
		                 		<td align="left" class="tablebg">
		                 			<%=dh.getString("dh_financialname") %>
		                 		</td>	                 		
						  	</tr>
		                  	<tr class="information_table-2-1">
								<td align="right" class="tablebg">數量  ： </td>
		                 		<td align="left" class="tablebg">
		                 			<%=dh.getString("dh_num")+" "+dh.getString("dh_num_unit") %>
		                 		</td>
								<td align="right" class="tablebg">型式規格 ： </td>
		                 		<td align="left" class="tablebg">
		                 			<%=dh.getString("dh_typespec") %>
		                 		</td>	                 		
						  	</tr>						  	
						  	
		                  	<tr class="information_table-2-1">
								<td align="right" class="tablebg">購置金額  ： </td>
		                 		<td align="left" class="tablebg">
		                 			<%=dh.getInt("dh_total") %>
		                 		</td>
								<td align="right" class="tablebg">購置日期 ： </td>
		                 		<td align="left" class="tablebg">
		                 			<%=dh.getString("dh_placedate") %>
		                 		</td>	                 		
						  	</tr>
		                  	<tr class="information_table-2-1">
								<td align="right" class="tablebg">放置地點  ： </td>
		                 		<td align="left" class="tablebg">
		                 			<%=dh.getString("dh_placelocaction") %>
		                 		</td>
								<td align="right" class="tablebg">捐贈用途 ： </td>
		                 		<td align="left" class="tablebg">
		                 			<%=dh.getString("dh_donate_project").replace("1","未指定").replace("2","指定單位").replace("3","指定用途") + " " + dh.getString("dh_donate_project_title") %>
		                 		</td>	                 		
						  	</tr>						  	
						  	
						  	

						  	<tr>
		                  		<td colspan="4" align="center" class="information_title-1">捐物人個人資料</td>
		                  	</tr>
		                  
		                  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right">姓名/機構名稱 ：  </td>
		                  		<td width="30%" align="left" ><%=dh.getString("dh_name") %>&nbsp;</td>
		                  		<td width="20%" align="right">身分證字號/統一編號： </td>
		                  		<td width="30%" align="left" ><%=dh_pid %>&nbsp;</td>		                  		
						  	</tr>
		                  
		                  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right">聯絡電話 ：  </td>
		                  		<td width="30%" align="left" ><%=dh.getString("dh_cellphone") %></td>
		                  		<td width="20%" align="right">電話 ：  </td>
		                  		<td width="30%" align="left" ><%=dh.getString("dh_phone") %></td>
						  	</tr>

						  	<tr class="information_table-2-1">
		                  		<td align="right">通訊地址： </td>
		                 		<td align="left"><%=dh.getString("dh_zipcode")+dh.getString("dh_county")+dh.getString("dh_city")+dh.getString("dh_address") %></td>
						  		<td width="20%" align="right">電子信箱 ： </td>
		                 		<td width="30%" align="left" ><%=dh.getString("dh_email") %></td>
						  	</tr>	
						  	
		                  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right">身分 ： </td>
		                 		<td width="30%" align="left" colspan="3">
									<%=dh.getString("dh_identity").replace("1", "靜宜校友").replace("2", "靜宜教職員").replace("3", "學生/家長").replace("4", "企業機構").replace("5", "社會人士")%>
		                 		</td>
							</tr>
		                  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right">服務單位 ： </td>
		                 		<td width="30%" align="left" >
		                 			<%=dh.getString("dh_unit") %>
		                 		</td>
		                  		<td width="20%" align="right">職稱 ： </td>
		                 		<td width="30%" align="left" >
		                 			<%=dh.getString("dh_job") %>
		                 		</td>		                 		
							</tr>							
						  	
						  	
						</table>
						</td>
					</tr> 		
		        </table>
				</td>
			</tr>

			<tr>
				<td align="center" colspan="2">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<tr>
						<td class="system_bk-2bk">
						<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">       

							<tr class="information_table-2-1">
								<td width="20%" align="right">最後修改人員</td>
								<td width="30%" align="left"><%=dh.getString("dh_modifyuser") %></td>
								<td width="20%" align="right">最後修改日期</td>
								<td width="30%" align="left"><%=dh.getString("dh_modifydate") %></td>
							</tr>

						</table>
						</td>
					</tr>
					<tr align="center">
						<td colspan="4" align="center"><br />
					<form name="form0" method="post"> 	 
						 <%=HtmlCoder.hiddenInputs(names, values)%>
						 <%if(!StringTool.validString(request.getParameter("rl_code")).equals("")){
							//code = "receipt";
							 code = StringTool.validString(request.getParameter("rl_code"));
						 }%>
						<input name="" type="button" value="回上一頁"  onclick="goaction(this.form, '<%=code+src %>.jsp');" />&nbsp;
						<input name="" type="button" value="捐物單列印"  onclick="window.open('../../web/receipt/thing_receipt.jsp?dh_id=<%=dh.getString("dh_id") %>', '_blank');"/>
					</form>

					</td>
					</tr>
				</table>
				</td>

			</tr>
			<tr>
				<td colspan="3">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="3" class="information_bk-2b">&nbsp;</td>
			</tr>

		</table>
		</td>
		</div>
	</tr>
</table>
</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>