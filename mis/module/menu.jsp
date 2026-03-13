<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
	String code = "menu";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title = "系統功能設定";		// 功能標題

	// 在不是 root 帳號或是本機時無法登錄本功能
	if(!app_account.equals("root") && !request.getServerName().equals("localhost")) {
		out.write("<script>alert('無修改權限');history.back();</script>");
		return;
	}

	Vector mfs = app_sm.selectAll(tblmf, "mf_upfunction=? AND mf_type=?", new String[]{ "", "1" }, "mf_priority");
	
	// names.
	String[] names = new String[] { "" };

	// values.
	String[] values = new String[] { "" };
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@include file="include/head.jsp"%>
<script language="JavaScript" type="text/JavaScript">
	function goaction(FORM,JSP) {
	    FORM.action = JSP;
	    FORM.submit();
	}
	
	function godelete(FORM,JSP) {
	    if (confirm("確定刪除嗎？")) {
	        FORM.action = JSP;
	        FORM.submit();
	    }
	}
	
	<%-- 功能清單Excel匯出 --%>
	function export_file() {		<%-- 啟動檔案匯出功能 --%>
		$(".block").show();
		var theForm = document.frm1;
			theForm.action="export/menu_export.jsp";
			theForm.target="_exportFrame";
			theForm.submit();
	}
	function exportProgress() {   	<%-- 檢查檔案是否已經匯出完成 --%>
		$.ajax({
			async:false,
			type:"GET",
			url: "export/exportcheck.jsp",
			data: {reportType:"menu_export"},
			success: function(res) {
				res = $.trim(res);
				if(res == "start") {
					$(".block").show();
				} else if((res == "end") || (res == "no")) {
					$(".block").hide();
					clearProgress();
					if(res == "end") location.href = "<%=app_fetchpath+"/export/" + app_account + "_menu_export.xlsx"%>";
					else history.back();
				}
				window.setTimeout("exportProgress()",1500);
			}
		});
	}
	function clearProgress() {  	<%-- 清除檔案匯出完成後之 Session 值 --%>
		$.ajax({
			async:false,
			type:"GET",
			url: "export/exportcheck.jsp",
			data: {reportType:"clear_menu_export"},
			success: function(res) {
			}
		});
	}
	var timer = window.setTimeout("exportProgress()",1500);
</script>
</head>
<body class="default_body">
<%-- 黑色遮蔽 --%>
<div class="block" style="width:100%; height:100%; position:fixed; color:#fff; display:none;">
	<img src="export/images/block_bg.png" width="100%" height="100%" style="position:fixed; z-index:99998;"/>
	<div style="margin: 0 auto;width: 400px;height: 50px;position: relative;top: 50%; z-index:99999; text-align:center;">
		資料匯出準備中，請稍待片刻 ......
	</div>
</div>
<%-- 黑色遮蔽 --%>
<%-- 20250331 modify Miles top menu.jsp  改成 RWD --%>    

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
            		<td align="left" valign="middle" class="system_bigword"><%=show_title %></td>
          		</tr>
          		<tr>
            		<td colspan="2"><hr size="1" noshade></td>
          		</tr>
          		<tr align="center">
            		<td colspan="2"><table width="95%"  border="0" cellspacing="1" cellpadding="0">
                		<tr>
                  			<td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="2" cellspacing="1">
                      			<tr align="center" class="system_title-1">
                        			<td colspan="5" class="titlebg">
                        				<span class="system_title-1"><%=show_title %></span>&nbsp;&nbsp;
                        				<span><input type="button" value="新增" onclick="javascript:location.href='menu_a.jsp'" /></span>&nbsp;
            							<span><input type="button" value="列表" onclick="javascript:location.href='menu.jsp'" /></span>&nbsp;
										<span><input type="button" value="排序" onclick="javascript:location.href='menu_sort.jsp?code=<%=code %>'" /></span>&nbsp;
										<span><input type="button" value="功能清單匯出" onclick="export_file();" /></span>&nbsp;
                        			</td>
                      			</tr>

                      			<tr align="center" class="system_bk-2">
                        			<td width="5%" class="tablebg">項次</td>
                        			<td width="20%" class="tablebg">選單標籤名稱</td>
                        			<td width="30%" class="tablebg">標籤顏色</td>
                        			<td width="15%" class="tablebg">顯示狀態</td>
                        			<td width="30%"  class="tablebg"><div align="center">功能</div></td>
                      			</tr>

					  			<%
					  			for (int i = 0; i < mfs.size(); i++) {
					       			TableRecord mf = (TableRecord)mfs.get(i);
					  			%>
<form name="form<%=i+1%>" method="post">
  								<input type="hidden" name="mf_id" value="<%=mf.getString("mf_id") %>">
  								<input type="hidden" name="mf_type" value="<%=mf.getString("mf_type") %>">
  								<input type="hidden" name="code" value="<%=code %>">
                      			<tr align="center" class="system_table-2-1">
                        			<td class="tablebg"><%=i+1 %></td>
                        			<td class="tablebg"><%=mf.getString("mf_name")%></td>
                        			<td class="tablebg">
                        				 <input type="color" value="<%=mf.getString("mf_bgcolor2") %>" style="width:50px;" disabled>	
                        			</td>
                        			<td class="tablebg">
                        				<input type="radio" name="mf_status" value="N" <%="N".equals(mf.getString("mf_status"))?"checked":"" %> onclick="goaction(this.form, 'menu_update.jsp?action=REPLY');" />顯示
										<input type="radio" name="mf_status" value="H" <%="H".equals(mf.getString("mf_status"))?"checked":"" %> onclick="goaction(this.form, 'menu_update.jsp?action=REPLY');" />隱藏
									</td>
                        			<td class="tablebg"><div align="center">
                          				<input name="detail<%=i+1%>" type="button"  value="下層選單設定" onClick="goaction(this.form, 'menu_sub.jsp?mf_upfunction=<%=mf.getString("mf_id") %>');">                            
                          				<input name="modify<%=i+1%>" type="button"  value="修改" onClick="goaction(this.form, 'menu_c.jsp');">                            
                          				<input name="delete<%=i+1%>" type="button"  value="刪除" onClick="godelete(this.form, 'menu_update.jsp?action=D');">
                        			</div></td>
                      			</tr>
</form>
					  			<%} %>
                  			</table></td>
						</tr>
            		</table></td>
          		</tr>
          		<tr>
            		<td colspan="2">
            			<div align="center">
                			<br />
						</div>
					</td>
				</tr>
          		<tr>
					<td colspan="2" class="system_bk-2b">&nbsp;</td>
          		</tr>
        	</table>
        	<p>&nbsp;</p>
        	</td>
    	</tr>
  	</table>
</div>
</div>

<iframe name="_exportFrame" width="0" height="0" style="display:none"></iframe>
<%=HtmlCoder.getForm("frm1", request.getRequestURI(), names, values) %>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>