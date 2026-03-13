<!DOCTYPE html>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	// 相關參數設定
	String code 		= "donate";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "捐款紀錄管理";				// 功能標題
	String src = StringTool.validString(request.getParameter("src"));
	
	// 設定預設值
	// Tiltes.
	String[] titles = new String[] { show_title+"通知正本收件者",show_title+"通知副本收件者" };
	// Keywords.
	String[] keywords = new String[] { "original" , "duplicate" };
	// Get records.
	Vector misimages = new Vector();
	for (int i = 0; i < titles.length; i++) {
	   TableRecord ss = SiteSetup.getSetup(keywords[i]+"."+code+"."+lang);
	   if (ss.getString("ss_id").equals("")) {
	       ss = new TableRecord(tblss);
	       ss.setInsert(app_account);
	       ss.setValue("ss_title", titles[i]);
	       ss.setValue("ss_keyword", keywords[i]+"."+code+"."+lang);
	       app_sm.insert(ss);
	   }
	   misimages.add(ss);
	}
%>
<html lang="<%=encoded %>">
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
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
				<form name="frm" id="frm" method="post" action="<%=code%>_update.jsp?action=POP3&code=<%=code %>" onsubmit="javascript:return checkform(this);">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<tr>
						<td class="system_bk-2bk">
						<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
							<tr>
								<td align="center" colspan="4" class="information_title-1"><%=show_title%>&nbsp;&nbsp;
								<input type="button" value="新增捐款單" onclick="javascript:location.href='<%=code%>_a.jsp'" />&nbsp;
								<input type="button" value="捐款單列表" onclick="javascript:location.href='<%=code%>.jsp'" />&nbsp;
								<%if("".equals(src)){ %>
							    <input type="button" value="設定收件者" onclick="javascript:location.href='<%=code %>_pop.jsp'" />
							    <%} %>
								</td>
							</tr>							
							<tr align="center" class="information_bk-2">
								<td colspan="4" align="center">收件者設定</td>
							</tr>
							
							<tr class="information_table-2-1">
							  	<td width="10%" align="center">
									正本
							  	</td>
							 	<td align="center">
									<textarea name="original" id="original" cols="70%" rows="2"><%=SiteSetup.getValue("original."+code+"."+lang) %></textarea>
								</td>
							</tr>
							<%--
							<tr class="information_table-2-1-2-1">
								<td align="center">
									副本
								</td>
								<td align="center">
									<textarea name="duplicate" id="duplicate" cols="70%" rows="2"><%=SiteSetup.getValue("duplicate."+code+"."+lang) %></textarea>
								</td>
							</tr>
							--%>
							<tr class="information_table-2-1">
							  	<td colspan="4" align="center" ><B>請以逗號 『 ， 』作收件人區分設定 : 例:123@gmail.com , abc@gmail.com</B></td>
							</tr>

						</table>
						</td>
					</tr>
					<tr align="center">
						<td colspan="4" align="center"><br />
						<input type="submit" value="確定送出" />&nbsp;
					</td>
					</tr>
				</table>
				</form>
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
</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>