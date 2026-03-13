<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
   	// For sharing program.
   	String type = StringTool.validString(request.getParameter("type"), "web");
   	// For position.
   	String pos = StringTool.validString(request.getParameter("pos"));
   	// miles modify for 加價購
   	String code = StringTool.validString(request.getParameter("code"),"product");
   	String num  = StringTool.validString(request.getParameter("num"),"0");
	// miles modify end
   
   	// Get default category.
   	Vector xdpcs = app_sm.selectAll(tbldm, "dm_category='' AND dm_code='product_category' AND dm_lang=?", new Object[] { lang }, "dm_showseq ASC, dm_createdate DESC");
   	TableRecord defpc = (TableRecord) xdpcs.get(0);
   	// Upper id.
   	String upid = StringTool.validString(request.getParameter("pd_id"), "");
   
   	Vector dpcs = new Vector();
   	// Only display categories which has products.
   	for(int i = 0; i < xdpcs.size(); i++) {
		TableRecord app_pc = (TableRecord)xdpcs.get(i);
		boolean exists = (app_sm.selectAll(tbldm, "dm_category=?", new Object[]{ app_pc.getString("dm_id") }).size() > 0);
        if(exists) {
			dpcs.add(app_pc);
        }
   	}

   	// Categories in this category.
	if(!"".equals(upid)) {
		dpcs.clear();
		xdpcs = app_sm.selectAll(tbldm, "dm_category=? AND dm_code='product' AND dm_lang=?", new Object[]{ upid, lang }, "dm_showseq ASC, dm_createdate DESC");
		// Only display categories which has products.
		for(int i = 0; i < xdpcs.size(); i++) {
			TableRecord app_pc = (TableRecord)xdpcs.get(i);
			boolean exists = (app_sm.selectAll(tblpd, "pd_category=?", new Object[]{ app_pc.getString("dm_id") }).size() > 0);
			if(exists) {
				dpcs.add(app_pc);
			}
    	}
   	}

	// display categories which has category.
   	// Products.
   	// miles modify for 加價購
   	Vector pds = app_sm.selectAll(tblpd, "pd_category=? and pd_code=?", new Object[]{ upid, code }, "pd_showseq ASC, pd_createdate DESC");
	// miles modify end

   	// Product numbers.
   	String[] pdnos = new String[pds.size()];
   	// Product names.
   	String[] pdnames = new String[pds.size()];
   	// Product categories.
   	String[] pcnames = new String[pds.size()];
   	// Product category ids
   	String[] pcids = new String[pds.size()];
   	for(int i = 0; i < pds.size(); i++) {
		TableRecord pd = (TableRecord)pds.get(i);
       	pdnos[i] = pd.getString("pd_no");
       	pdnames[i] = pd.getString("pd_title").replace("'", "’");
       	TableRecord pc = app_sm.select(tbldm, "dm_id=?", new Object[]{ pd.getValue("pd_category") });
       	pcnames[i] = pc.getString("dm_title").replace("'", "’");
       	pcids[i] = pc.getString("dm_id");
   	}
%>
<html>
<head>
<%@include file="/WEB-INF/jspf/norobots.jspf"%>
<title><%=app_mistitle%></title>
<link href="../css/adm_css.css" rel="stylesheet" type="text/css">
</head>
<%@include file="../../../JQuery/jquery.jsp" %>
<script>
function godown(F) {
    if (F.pd_id.value == "" ) {
        alert("請選擇商品名稱！");
    } else {
        F.submit();
    }
}

function gostatus(F) {
    if (F.pd_id.value == "" ) {
        alert("請選擇商品名稱！");
    } else {
        var idx = F.pd_id.selectedIndex;
        if(F.pick != null) {
            if(F.pd_id[idx].value.substring(0,2) == "PD") {
                F.pick.disabled = "";
            } else if(F.pd_id[idx].value.substring(0,2) == "PC") {
                F.pick.disabled = "disabled";
            }
        }
    }
}

function gopick(F) {
    if(F.pd_id.value == "") {
        alert("請選擇商品！");
    } else {
		<%if("increase".equals(code)) { %>
		var url="../basic/addIncrease.jsp";	
		var id = $("#pd_id").val();
		var num = $("#num").val(window.opener.$("#num_increase").val());
		num = $("#num").val();
		$.post(url, {id:id,num:num}, showIncrease);
		<%} else { %>
		window.opener.$("#pdname").val($("#pd_id :selected").text());
		window.opener.$("#pd_id").val(F.pd_id.value);
		self.close();
		<%} %>
	}
}

function showIncrease(data) {
	var num_i = parseInt($("#num").val()) + 1;
	window.opener.$("#more").append(data);
	window.opener.$("#num_increase").val(num_i);
	self.close();
}
</script>
<body>
<div align="center">
  	<table width="100" border="0" cellspacing="0" cellpadding="0">
<form name="form0" method="post" action="<%=request.getRequestURI()%>">
  	<input type="hidden" name="type" value="<%=type %>">
  	<input type="hidden" name="pos" value="<%=pos %>">
		<!-- miles modify for 加價購 -->
  		<input type="hidden" name="code" value="<%=code %>">
  		<input type="hidden" name="num" id="num" value="<%=num %>">
		<!-- miles modify end -->
    	<tr>
      		<td class="system_bk-2bk"><table width="240" border="0" align="center" cellpadding="3" cellspacing="1">
          		<tr>
            		<td colspan="2" align="center" class="<%=type%>_title-1">請選擇</td>
          		</tr>
          		<tr>
            		<td align="center" class="<%=type%>_table-2-1">
              			<select name="pd_id" id="pd_id" size="10" onchange="gostatus(this.form);">
							<%
   							for(int i = 0; i < dpcs.size(); i++) {
       							TableRecord pc = (TableRecord)dpcs.get(i);
							%>
                			<option value="<%=pc.getValue("dm_id")%>"><%=pc.getValue("dm_title")%></option>
							<%} %>

							<%
   							for (int i = 0; i < pds.size(); i++) {
       							TableRecord pd = (TableRecord)pds.get(i);
							%>
                			<option value="<%=pd.getValue("pd_id")%>"><%=pd.getValue("pd_title")%></option>
							<%} %>
              			</select>
            		</td>
          		</tr>
          		<tr>
            		<td colspan="2" align="center" class="<%=type%>_table-2-1">
            			<input name="requery" type="button" value="重新查詢" onclick="location='<%=request.getRequestURI()%>?type=<%=type%>&pos=<%=pos%>&code=<%=code %>';">&nbsp;
						<%if(!defpc.getString("dm_category").equals(upid)) { %>
            			<input name="uplevel" type="button" value="上層" onclick="javascript:history.go(-1);">&nbsp;
						<%} %>
						<%if(dpcs.size() > 0) { %>
              			<input name="down" type="button"  value="下層" onClick="godown(this.form);">
						<%} %>
						<%if (/*dpcs.size() == 0 &&*/ pds.size() > 0) { %>
              			<input name="pick" type="button"  value="選取" onclick="gopick(this.form);" disabled>
						<%} %>
              			<input name="close" type="button"  value="關閉" onclick="self.close();">
            		</td>
          		</tr>
      		</table></td>
    	</tr>
</form>
  	</table>
</div>
</body>
</html>