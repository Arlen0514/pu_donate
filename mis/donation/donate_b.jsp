<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%@ include file="/web/include/encryption.jsp"%>
<%
	String code 		= "donate";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "捐款資訊管理";			// 功能標題

	String dh_id = StringTool.validString(request.getParameter("dh_id"));
	String src = StringTool.validString(request.getParameter("src"));
	TableRecord dh = app_sm.select(tbldh, dh_id);
	TableRecord ph = app_sm.select(tblph , "data_id=?" , new String[]{dh.getString("dh_id")});

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
	
	String qrlno	 = StringTool.validString(request.getParameter("_qrlno"));				// 收據單號
	String qrsstatus	= StringTool.validString(request.getParameter("_qrsstatus"));		// 收據開立狀態
	
	//Names and values.
	String[] names = new String[] { "npage", "_qposition", "_qname", "_qemitdate", "_qrestdate", "_qship", "_qcollect","_qphone","_qdhno","_qpayment","_qrlno","_qrsstatus"};
	String[] values = new String[] { String.valueOf(pageno), qposition, qname, qemitdate, qrestdate, qship, qcollect,qphone, qdhno,qpayment,qrlno ,qrsstatus};
	
	/*-- 捐款資訊 --*/
	// 捐款類別列表
	Vector<TableRecord> donate_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category=?"
			, new Object[]{"donate_category", lang, ""}, "dm_showseq ASC, dm_createdate DESC");
	// 院系捐款  
	TableRecord department_index = app_sm.select(tbldm, "dm_code=? and dm_lang=? and dm_category=?",
            new Object[]{"department_index", lang, ""}, "dm_showseq ASC, dm_createdate DESC");
	
	// 系所類別(第一層)
    Vector<TableRecord> dept_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category=? ", 
    		new Object[] { "department_category", lang, "" }, "dm_showseq ASC, dm_createdate DESC");
	// 系所類別(第二層)
    Vector<TableRecord> dept_sub_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category<>? ", 
    		new Object[] { "department_category", lang, "" }, "dm_showseq ASC, dm_createdate DESC");
	
	// 捐款專案
	Vector<TableRecord> pro_cps = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=?",
			new Object[]{"donate_project", lang}, "cp_showseq ASC, cp_createdate DESC");
	// 捐款專案(院系)
	Vector<TableRecord> dept_cps = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=?",
			new Object[]{"department", lang}, "cp_showseq ASC, cp_createdate DESC");
	
	//受贈單位
	Vector<TableRecord> usages = app_sm.selectAll(tbldm, "dm_lang=? and dm_code=? and dm_category=?", 
			new Object[]{ lang, "donate_usage", "" } , "dm_showseq ASC , dm_createdate DESC");
	
	//捐款屬性
	Vector<TableRecord> attributes = app_sm.selectAll(tbldm, "dm_lang=? and dm_code=? and dm_category=?", 
			new Object[]{ lang, "donate_attribute", "" } , "dm_showseq ASC , dm_createdate DESC");
	
	// 對照表
	Map<String, String> usage_title_map = new HashMap<String, String>();
	Map<String, String> attr_title_map = new HashMap<String, String>();
	
	for(TableRecord dm:usages) usage_title_map.put(dm.getString("dm_id"),dm.getString("dm_title"));
	for(TableRecord dm:attributes) attr_title_map.put(dm.getString("dm_id"),dm.getString("dm_title"));
	
	// 身分證字號/統編
	String dh_pid = new AESDataEncryption().AESDecrypt(dh.getString("dh_pid"));
	
	// 付款方式
	String dh_paymethod = app_sm.select(tblcp, "cp_category = ? and cp_code = ? and cp_lang = ? ", new Object[]{
    		dh.getString("dh_paymethod"), "guide", lang}).getString("cp_title");
	
	// 幣別
	boolean is_foreign = !"TWD".equals(dh.getString("dh_currency"));
%>
<!DOCTYPE html>
<html>
<head>
	<%@include file="include/head.jsp"%>
	<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>
	<script>
		function checkform(F) {
			let is_college = F.dh_donate_project_category.value.trim() == '<%=department_index.getString("dm_id") %>';
			let is_other = F.dh_donate_project.value.trim() == 'other';
			
			if(F.dh_donate_project_category.value.trim() == ''){
				alert('請選擇捐贈類別!!');
				F.dh_donate_project_category[0].focus();
			} else if(!is_college && F.dh_donate_project.value.trim() == ''){
				alert('請選擇指定捐贈用途!!');
				F.dh_donate_project.focus();
			} else if(!is_college && is_other && F.dh_donate_project_title.value.trim() == ''){
				alert('請輸入其他捐贈用途!!');
				F.dh_donate_project_title.focus();
			} else if(is_college && F.dh_donate_college.value.trim() == ''){
				alert('請選擇院所!!');
				F.dh_donate_college.focus();
			} else if(is_college && F.dh_donate_department.value.trim() == ''){
				alert('請選擇系所!!');
				F.dh_donate_college.focus();
			} else if(is_college && F.donate_project_dept.value.trim() == ''){
				alert('請選擇計畫名稱!!');
				F.donate_project_dept.focus();
			} else {
				$('#dh_donate_project_no').prop('disabled', false);
				$('#dh_donate_unit_title').prop('disabled', false);
				$('#dh_donate_attribute_title').prop('disabled', false);
				
				return true;
			}
		    
			return false;
		}
		function goaction(FORM,JSP) {
		    FORM.action = JSP;
		    FORM.submit();
		}

		<%-- 變更捐款項目 --%>
		function change_donate(item_category, item_id){
			
            switch(item_id){
                case 'dc0':									// 其他
                	$('#deptFund').hide();
                	$('#donate_project_area').show();
                	$('#dh_donate_project option[data-category=other]').show();
                	$('#dh_donate_project option[data-category!=other]').hide();
                	$('#dh_donate_project').val('other').change();
                	$(".donationPurpose_info .info_other").show(); 	// 關閉
                	$('#dh_donate_project_no').val('');
            		$('#dh_donate_project_no').prop('disabled', false);
    				$('#dh_donate_unit').val('');
            		$('#dh_donate_unit_title').val('');
                	$('#dh_donate_unit_title').prop('disabled', false);
            		$('#dh_donate_attribute').val('');
                	$('#dh_donate_attribute_title').val('');
            		$('#dh_donate_attribute_title').prop('disabled', false);
                	break;
                case 'dc4':									// 院系募款
                	$('#deptFund').show();
                	$('#donate_project_area').hide();
                	$('#dh_donate_college').val('').change();
                	$('#dh_donate_department').val('').change();
                	$('#donate_project_dept').val('').change();
                	$('#dh_donate_department option[data-category^=DM]').hide();
                	$('#donate_project_dept option[data-category^=DM]').hide();
                	$('#donate_project_dept option[data-category=other]').hide();
                	$('#dh_donate_project_no').val('');
            		$('#dh_donate_project_no').prop('disabled', true);
    				$('#dh_donate_unit').val('');
            		$('#dh_donate_unit_title').val('');
                	$('#dh_donate_unit_title').prop('disabled', true);
            		$('#dh_donate_attribute').val('');
                	$('#dh_donate_attribute_title').val('');
            		$('#dh_donate_attribute_title').prop('disabled', true);
                	break;
                default:
                	$('#deptFund').hide();
            		$('#donate_project_area').show();
	                $('#dh_donate_project option[data-category^=DM]').hide();
	    			$('#dh_donate_project option[data-category='+item_category+']').show();
	    			$('#dh_donate_project option').eq(0).show();
	    			$('#dh_donate_project').val('').change();
                	$(".donationPurpose_info .info_other").hide(); 	// 關閉
                	$('#dh_donate_project_no').val('');
            		$('#dh_donate_project_no').prop('disabled', true);
    				$('#dh_donate_unit').val('');
            		$('#dh_donate_unit_title').val('');
                	$('#dh_donate_unit_title').prop('disabled', true);
            		$('#dh_donate_attribute').val('');
                	$('#dh_donate_attribute_title').val('');
            		$('#dh_donate_attribute_title').prop('disabled', true);
					break;		                	
            }
		}
		
		<%-- 變更院系系所 --%>
		function change_dept(dept_type){
			let value = $('#dh_donate_'+dept_type).val();
			
			if(dept_type == 'department'){
				$('#donate_project_dept').val('').change();
	        	$('#donate_project_dept option[data-category^=DM]').hide();
	        	$('#donate_project_dept option').eq(0).show();
	        	if(value != '') {
		        	$('#donate_project_dept option[data-category=other]').show();
	        		$('#donate_project_dept option[data-category='+value+']').show();
	        	} else {
	        		$('#donate_project_dept option[data-category=other]').hide();
	        	}
			} else {
				$('#dh_donate_department').val('').change();
	        	$('#dh_donate_department option[data-category^=DM]').hide();
	        	$('#dh_donate_department option').eq(0).show();
				$('#donate_project_dept').val('').change();
	        	$('#donate_project_dept option[data-category^=DM]').hide();
	        	$('#donate_project_dept option[data-category=other]').hide();
	        	$('#donate_project_dept option').eq(0).show();
	        	if(value != '') $('#dh_donate_department option[data-category='+value+']').show();
            	
			}
			$('#dh_donate_project_no').val('');
			$('#dh_donate_unit').val('');
    		$('#dh_donate_unit_title').val('');
    		$('#dh_donate_attribute').val('');
        	$('#dh_donate_attribute_title').val('');
        	show_donate_field(false, 'department');
		}
		
		<%-- 變更捐款計畫 --%>
		function change_project(type) {
			let project = '';
			let no		= '';
			let usage   = '';
			let attr    = '';
			let title1  = '';
			let title2  = '';
			
			if(type == 'department') {
				project = $('#donate_project_dept').val();
				no	    = $('#donate_project_dept option:selected').data('no');
				usage   = $('#donate_project_dept option:selected').data('usage');
				attr    = $('#donate_project_dept option:selected').data('attr');
				title1  = $('#donate_project_dept option:selected').data('title1');
				title2  = $('#donate_project_dept option:selected').data('title2');
			} else if(type == 'project') {
				project = $('#dh_donate_project').val();
				no	    = $('#dh_donate_project option:selected').data('no');
				usage   = $('#dh_donate_project option:selected').data('usage');
				attr    = $('#dh_donate_project option:selected').data('attr');
				title1  = $('#dh_donate_project option:selected').data('title1');
				title2  = $('#dh_donate_project option:selected').data('title2');
			}
			
			if(project !== 'other') {
				$('#dh_donate_project_no').val(no);
				$('#dh_donate_unit').val(usage);
	    		$('#dh_donate_unit_title').val(title1);
	    		$('#dh_donate_attribute').val(attr);
	        	$('#dh_donate_attribute_title').val(title2);
			}
        	show_donate_field(project=='other', type);
		}
		
		<%-- 顯示填寫欄位 --%>
		function show_donate_field(can_show, type) {
			if(can_show) {
				if(type == 'department') $('#donate_project_dept_title').show();
				else $('#dh_donate_project_title').show();
	        	$('#dh_donate_project_no').prop('disabled', false);
	        	$('#dh_donate_unit_title').prop('disabled', false);
	    		$('#dh_donate_attribute_title').prop('disabled', false);
			} else {
				$('#donate_project_dept_title').hide();
				$('#dh_donate_project_title').hide();
	        	$('#dh_donate_project_no').prop('disabled', true);
	        	$('#dh_donate_unit_title').prop('disabled', true);
	    		$('#dh_donate_attribute_title').prop('disabled', true);
			}
		}
		
		<%-- 表單預設值 --%>
		function donate_init(){
        	$('#deptFund').hide();
        	$('#donate_project_area').hide();
        	$('#donate_project_dept_title').hide();
        	$('#dh_donate_project_title').hide();
        	$('#dh_donate_project_no').prop('disabled', true);
        	$('#dh_donate_unit_title').prop('disabled', true);
    		$('#dh_donate_attribute_title').prop('disabled', true);
        	
        	// 捐款類別
        	if($('[name=dh_donate_project_category]:checked').length>0) {
        		let item_category = $('[name=dh_donate_project_category]:checked').val().trim();
            	let item_id = $('[name=dh_donate_project_category]:checked').attr('id');
            	
            	switch(item_id){
	                case 'dc0':									// 其他
	                	$('#deptFund').hide();
	                	$('#donate_project_area').show();
	                	$('#dh_donate_project option[data-category=other]').show();
	                	$('#dh_donate_project option[data-category!=other]').hide();
	                	$('#dh_donate_project').val('other').change();
	                	$("#dh_donate_project_title").show();
	                	$(".info_other").show(); 	// 關閉
	                	$('#dh_donate_project_no').prop('disabled', false);
	    				$('#dh_donate_unit_title').prop('disabled', false);
	            		$('#dh_donate_attribute_title').prop('disabled', false);
	                	break;
	                case 'dc4':									// 院系募款
	                	let college = $('#dh_donate_college').val();
		                let dept = $('#dh_donate_department').val();
	                	
	                	$('#deptFund').show();
	                	$('#donate_project_area').hide();
	                	$('#dh_donate_department option[data-category^=DM]').hide();
	                	$('#donate_project_dept option[data-category^=DM]').hide();
	                	if(college != '' && dept != '') {
	                		$('#dh_donate_department option[data-category='+college+']').show();
	                		$('#donate_project_dept option[data-category='+dept+']').show();
	                	}
	                	$('#dh_donate_project_no').prop('disabled', true);
	    				$('#dh_donate_unit_title').prop('disabled', true);
	            		$('#dh_donate_attribute_title').prop('disabled', true);
	            		change_project('department');
	                	break;
	                default:
	                	$('#deptFund').hide();
	            		$('#donate_project_area').show();
		                $('#dh_donate_project option[data-category^=DM]').hide();
		    			$('#dh_donate_project option[data-category='+item_category+']').show();
	                	$(".info_other").hide(); 	// 關閉
	                	$('#dh_donate_project_no').prop('disabled', true);
	    				$('#dh_donate_unit_title').prop('disabled', true);
	            		$('#dh_donate_attribute_title').prop('disabled', true);
	            		change_project('project');
						break;		                	
	            }
        	}
		}
		
		$(document).ready(function(){
			donate_init();
			
			<%-- 變更捐款類別 --%>
			$("input[name='dh_donate_project_category']").change(function () { 
	            if (this.checked) {
	            	let dh_donate_item_category = $(this).val().trim();
	            	let item_id = $(this).attr('id');
	            	
	            	console.log('dh_donate_item_category', dh_donate_item_category);
	            	
	                $(".donateCategoryItem input.item_radio:radio").not(this).parent().siblings().removeClass("active");
	                $(".donateCategoryItem input.item_radio:radio").not(this).parent().siblings().children().attr("checked", false);
	                $(this).parent().toggleClass("active");
	                $(this).attr("checked", true);
	                $('#dh_donate_item_category').val(dh_donate_item_category);
	                
	                change_donate(dh_donate_item_category, item_id);
	            } else {
	                $(this).parent().removeClass("active");
	                $(this).attr("checked", false);
	            }
	        });
			
			<%-- 變更指定捐贈 --%>
			$("#dh_donate_project").change(function () {
				change_project('project');
            });
			
			<%-- 變更院系系所(第一層) --%>
			$('#dh_donate_college').on('change', function(){
				change_dept('college');
			});
			
			<%-- 變更院系系所(第二層) --%>
			$('#dh_donate_department').on('change', function(){
				change_dept('department');
			});
			
			<%-- 變更指定捐贈(院系) --%>
			$('#donate_project_dept').on('change', function(){
				change_project('department');
			});
		});
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
								<input type="button" value="新增捐款單" onclick="javascript:location.href='<%=code%>_a.jsp'" />&nbsp;
								<input type="button" value="捐款單列表" onclick="javascript:location.href='<%=code%>.jsp'" />&nbsp;
								<%if("".equals(src)){ %>
							    <input type="button" value="設定收件者" onclick="javascript:location.href='<%=code %>_pop.jsp'" />
							    <%} %>
								</td>
							</tr>

							<tr align="center" class="information_bk-2">
								<td colspan="4" align="center">檢視資訊</td>
							</tr>
						
						  	<tr class="information_table-2-1">
		                  		<td align="right" class="tablebg">捐款日期 ： </td>
		                 		<td align="left" class="tablebg"><%=dh.getString("dh_donatedate") %></td>
		                  		<td align="right" class="tablebg">捐款是否付款 ： </td>
		                 		<td align="left" class="tablebg"><%="Y".equals(dh.getString("dh_collect"))?"已付款":"未付款" %></td>		                 		                  	
						  	</tr>
		                  
		                  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right">捐款單編號 ： </td>
		                 		<td width="30%" align="left"><%=dh.getString("dh_no") %></td>
		                  		<td width="20%" align="right">捐款金額 ：  </td>
		                  		<td width="30%" align="left" >
		                  			<%if(is_foreign){ %>
		                  			<%=dh.getString("dh_currency_other") %>&nbsp;<%=app_df.format(dh.getInt("dh_total"))%>&nbsp;元
		                  			<%}else{ %>
		                  			TWD&nbsp;<%=app_df.format(dh.getInt("dh_total"))%>&nbsp;元
		                  			<%} %>
		                  		</td>		                 		
						  	</tr>
							<tr>
		                  		<td colspan="4" align="center" class="information_title-1">捐款資訊</td>
		                	</tr>
		                	
		                	<form name="form_donate" id="form_donate" method="post" action="<%=code %>_update.jsp?action=M&dh_id=<%=dh.getString("dh_id") %>&code=<%=code %>" enctype="multipart/form-data" onsubmit="return checkform(this);"> 
		                	<%=HtmlCoder.hiddenInputs(names, values)%>
		                	<tr class="information_table-2-1">
			                  	<td align="right"><font color='red'>＊</font>捐贈類別： </td>
		                 		<td align="left" colspan="3">
			                 		<%
			                 		// 捐款類別顯示
        							int project_count = donate_dms.size();
                                	int first_max = 3;
                                	boolean lower_three = project_count<3;
                                	
                                	if(lower_three) first_max = project_count;
			                 		%>
			                 		<%for (int i = 0; i < first_max; i++) {
		                                TableRecord dm = donate_dms.get(i);
		                            %>
			                 		<label for="dc<%=i+1 %>">
		                 				<input type="radio" name="dh_donate_project_category" id="dc<%=i+1 %>" value="<%=dm.getString("dm_id")%>" <%=dh.getString("dh_donate_project_category").equals(dm.getString("dm_id"))?"checked":"" %>> <%=dm.getString("dm_title")%>&nbsp;
			                 		</label>
			                 		<%} %>
									<%if(dept_dms.size()>0){ %>
									<label for="dc4">
			                 			<input type="radio" name="dh_donate_project_category" id="dc4" value="<%=department_index.getString("dm_id")%>" <%=dh.getString("dh_donate_project_category").equals(department_index.getString("dm_id"))?"checked":"" %>> 院系募款&nbsp;
									</label>
									<%} %>
									
									<%if(!lower_three){ %>
									<%for (int i = 3; i < project_count; i++) {
		                                TableRecord dm = donate_dms.get(i);
		                            %>
			                 		<label for="dc<%=i+2 %>">
		                 				<input type="radio" name="dh_donate_project_category" id="dc<%=i+2 %>" value="<%=dm.getString("dm_id")%>" <%=dh.getString("dh_donate_project_category").equals(dm.getString("dm_id"))?"checked":"" %>> <%=dm.getString("dm_title")%>&nbsp;
			                 		</label>
			                 		<%} %>
							 		<%} %>
									<label for="dc0">
			                 			<input class="item_radio" type="radio" name="dh_donate_project_category" id="dc0" value="other" <%=dh.getString("dh_donate_project_category").equals("other")?"checked":"" %>> 其他&nbsp;
			                 		</label>
		                 		</td>
		                 	</tr>

		                  	<tr class="information_table-2-1" id="donate_project_area">
		                  		<td width="20%" align="right">指定捐贈用途： </td>
		                 		<td width="30%" align="left" colspan="3">
		                          <select id="dh_donate_project" name="dh_donate_project">
			                          	<option value="">請選擇</option>
			                            <%for(TableRecord cp:pro_cps){ 
			                            	boolean has_attr  = attr_title_map.containsKey(cp.getString("cp_attr"));
			                            	boolean has_usage = usage_title_map.containsKey(cp.getString("cp_usage"));
			                            	String attr_title  = has_usage?attr_title_map.get(cp.getString("cp_attr")):"";
			                            	String usage_title = has_usage?usage_title_map.get(cp.getString("cp_usage")):"";
			                            %>
			                            <option value="<%=cp.getString("cp_id") %>" data-category="<%=cp.getString("cp_category") %>" data-no="<%=cp.getString("cp_no") %>" data-usage="<%=cp.getString("cp_usage") %>" data-attr="<%=cp.getString("cp_attr") %>" data-title1="<%=usage_title %>" data-title2="<%=attr_title %>" <%=cp.getString("cp_id").equals(dh.getString("dh_donate_project"))?"selected":"" %>><%=cp.getString("cp_title") %></option>
			                            <%} %>
			                            <option value="other" data-category="other" <%="other".equals(dh.getString("dh_donate_project"))?"selected":"" %>>其他</option>
		                          </select>
		                          <input class="info_other" type="text" name="dh_donate_project_title" id="dh_donate_project_title" placeholder="請自行輸入指定用途" value="<%="other".equals(dh.getString("dh_donate_project"))?dh.getString("dh_donate_project_title"):"" %>" />
		                 		</td>
						  	</tr>	     

		                  	<tr class="information_table-2-1" id="deptFund">
		                  		<td width="20%" align="right">院系募款 ： </td>
		                 		<td width="30%" align="left" colspan="3">
			                          <select name="dh_donate_college" id="dh_donate_college">
			                            <option value="">請選擇院所</option>
			                            <%for(TableRecord dm:dept_dms){ %>
			                            <option value="<%=dm.getString("dm_id") %>" <%=dm.getString("dm_id").equals(dh.getString("dh_donate_college"))?"selected":"" %>><%=dm.getString("dm_title") %></option>
			                            <%} %>
			                          </select>
			                          <select name="dh_donate_department" id="dh_donate_department">
			                            <option value="">請選擇系所</option>
			                            <%for(TableRecord dm:dept_sub_dms){ %>
			                            <option value="<%=dm.getString("dm_id") %>" data-category="<%=dm.getString("dm_category") %>" <%=dm.getString("dm_id").equals(dh.getString("dh_donate_department"))?"selected":"" %>><%=dm.getString("dm_title") %></option>
			                            <%} %>
			                          </select>
			                          <select name="donate_project_dept" id="donate_project_dept">
			                            <option value="">請選擇計畫名稱</option>
			                            <%for(TableRecord cp:dept_cps){ 
			                            	boolean has_attr  = attr_title_map.containsKey(cp.getString("cp_attr"));
			                            	boolean has_usage = usage_title_map.containsKey(cp.getString("cp_usage"));
			                            	String attr_title  = has_usage?attr_title_map.get(cp.getString("cp_attr")):"";
			                            	String usage_title = has_usage?usage_title_map.get(cp.getString("cp_usage")):"";
			                            %>
			                            <option value="<%=cp.getString("cp_id") %>" data-category="<%=cp.getString("cp_category") %>" data-no="<%=cp.getString("cp_no") %>" data-usage="<%=cp.getString("cp_usage") %>" data-attr="<%=cp.getString("cp_attr") %>" data-title1="<%=usage_title %>" data-title2="<%=attr_title %>" <%=cp.getString("cp_id").equals(dh.getString("dh_donate_project"))?"selected":"" %>><%=cp.getString("cp_title") %></option>
			                            <%} %>
			                            <option value="other" data-category="other" <%="other".equals(dh.getString("dh_donate_project"))?"selected":"" %>>其他</option>
			                          </select>
			                          <input class="info_other" type="text" name="donate_project_dept_title" id="donate_project_dept_title" placeholder="請自行輸入指定用途" value="<%=dh.getString("dh_donate_project_title") %>" style="margin-top: 5px;" size="50"/>
		                 		</td>
						  	</tr>	
							
							<tr class="information_table-2-1">
		                  		<td width="20%" align="right">計畫代碼 ： </td>
		                 		<td width="30%" align="left" colspan="3">
		                 			<input type="text" name="dh_donate_project_no" id="dh_donate_project_no" value="<%=dh.getString("dh_donate_project_no") %>"/>
		                 		</td>
						  	</tr>
							
							<tr class="information_table-2-1">		  
		                  		<td width="20%" align="right">受贈單位 ： </td>
		                 		<td width="30%" align="left">
		                 			<input type="hidden" name="dh_donate_unit" id="dh_donate_unit" value="<%=dh.getString("dh_donate_unit") %>"/>
		                 			<input type="text" name="dh_donate_unit_title" id="dh_donate_unit_title" value="<%=dh.getString("dh_donate_unit_title") %>"/>
		                 		</td> 
		                  		<td width="20%" align="right">捐款屬性 ：  </td>
		                  		<td width="30%" align="left">
		                  			<input type="hidden" name="dh_donate_attribute" id="dh_donate_attribute" value="<%=dh.getString("dh_donate_attribute") %>"/>
		                 			<input type="text" name="dh_donate_attribute_title" id="dh_donate_attribute_title" value="<%=dh.getString("dh_donate_attribute_title") %>"/>
		                  		</td>              		
						  	</tr>
							</form>
						  	
		                  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right">捐款用途備註說明 ： </td>
		                 		<td width="30%" align="left">
		                 			<%=dh.getString("dh_remark") %>
		                 		</td>
		                  		<td width="20%" align="right">付款方式 ：  </td>
		                  		<td width="30%" align="left" >
		                  			<%=dh_paymethod %>&nbsp;
		                  			<span style="color:red;">
		                  			<%if(dh.getString("dh_paymethod").contains("regular")){ %>
		                  			(第<%=("".equals(dh.getString("dh_main"))?0:dh.getInt("dh_regular_period")-dh.getInt("dh_remain_period"))+1 %>期)
		                  			<%} %>
		                  			</span>
		                  		</td>		                 		
						  	</tr>	

						  	<%if(dh.getString("dh_paymethod").contains("regular")){ 
						  		TableRecord dh_main = app_sm.select(tbldh, dh.getString("dh_main"));
						  		if("".equals(dh_main.getString("dh_id"))) dh_main = dh;
						  	%>
						  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right">定期定額設定 ：  </td>
		                  		<td width="30%" align="left" colspan="3">
                                  	自民國&nbsp;<%=Integer.parseInt(dh_main.getString("dh_donatedate").substring(0,4))-1911 %>
                                  	年&nbsp;<%=dh_main.getString("dh_donatedate").substring(5,7) %>&nbsp;月，至民國
                                  	<%=Integer.parseInt(dh_main.getString("dh_debit_due_year"))-1911 %>&nbsp;年
                                  	<%=dh_main.getString("dh_debit_due_month") %>&nbsp;月，每<%=dh.getString("dh_regular_type").replace("Y","年").replace("M","月") %>一次，共
                                  	<%=dh.getInt("dh_regular_period") %>&nbsp;期
		                  		</td>		                  				
						  	</tr>		
						  	<%} %>		  	
						  	
						  	<tr>
		                  		<td colspan="4" align="center" class="information_title-1">捐款人個人資料</td>
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
		                  		<td align="right">通訊地址 ： </td>
		                 		<td align="left"><%=dh.getString("dh_zipcode")+dh.getString("dh_county")+dh.getString("dh_city")+dh.getString("dh_address") %></td>
						  		<td width="20%" align="right">電子信箱 ： </td>
		                 		<td width="30%" align="left"><%=dh.getString("dh_email") %></td>
						  	</tr>
						  	
						  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right">身分 ： </td>
		                 		<td width="30%" align="left" colspan="3">
									<%=dh.getString("dh_identity").replace("1", "靜宜校友").replace("2", "靜宜教職員").replace("3", "學生/家長").replace("4", "企業機構").replace("5", "社會人士")%>
		                 			<%if("1".equals(dh.getString("dh_identity"))){ %>
		                 			<br/>
		                 			民國&nbsp;<%=dh.getString("dh_identity_year") %>&nbsp;年&nbsp;<%=dh.getString("dh_identity_dept") %>&nbsp;系/所/班 畢(結)業
		                 			<%} %>
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
							
							<tr class="information_table-2-1">				  
		                  		<td align="right">收據 ： </td>
		                 		<td align="left" colspan="3">
		                 			<%=dh.getString("dh_receipt_status").replace("Y", "寄收據").replace("N", "不寄收據") %>
								</td>			                 		
						  	</tr>
						  	
						  	<%if("Y".equals(dh.getString("dh_receipt_status"))){ %>
						  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right">收據姓名 ： </td>
		                 		<td width="30%" align="left"><%=dh.getString("dh_receipt_title") %></td>
		                 		<td align="right">收據地址 ： </td>
		                 		<td align="left"><%=dh.getString("dh_receipt_zipcode")+dh.getString("dh_receipt_county")+dh.getString("dh_receipt_city")+dh.getString("dh_receipt_address") %></td>
						  	</tr>
		                  	<%} %>
		                  	
						  	<tr class="information_table-2-1">				  
		                  		<td width="20%" align="right">公開 ： </td>
		                 		<td width="30%" align="left" colspan="3">
		                 			<%=dh.getString("dh_public").replace("Y", "公開").replace("N", "不公開") %>
		                 		</td>
<!-- 		                  		<td width="20%" align="right">上傳稅務機關 ： </td> -->
<!-- 		                 		<td width="30%" align="left"> -->
<%-- 		                 			<%=dh.getString("dh_tax").replace("Y", "上傳").replace("N", "不上傳") %> --%>
<!-- 		                 		</td>			                 			 -->
						  	</tr>	
						  	<tr class="information_table-2-1">				  
		                  		<td width="20%" align="right">備註說明 ： </td>
		                 		<td width="30%" align="left" colspan="3">
		                 			<%=dh.getString("dh_memo")%>
		                 		</td>
<!-- 		                  		<td width="20%" align="right">上傳稅務機關 ： </td> -->
<!-- 		                 		<td width="30%" align="left"> -->
<%-- 		                 			<%=dh.getString("dh_tax").replace("Y", "上傳").replace("N", "不上傳") %> --%>
<!-- 		                 		</td>			                 			 -->
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
							<input name="" type="button" value="確定送出"  onclick="$('#form_donate').submit();" />&nbsp;
							<input name="" type="button" value="捐款單列印"  onclick="window.open('../../web/receipt/donate_receipt.jsp?dh_id=<%=dh.getString("dh_id") %>', '_blank');"/>
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