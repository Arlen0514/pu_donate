<!DOCTYPE html>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	String code 		= "donate";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "捐款資訊管理";				// 功能標題
	String src = StringTool.validString(request.getParameter("src"));

    // 捐款項目
    Vector<TableRecord> donate_dms = app_sm.selectAll(tbldm,"dm_code=? and dm_lang=?",
			new Object[]{"donate_category",lang},"dm_showseq ASC,dm_createdate DESC");
    
	// 院系捐款  
	TableRecord department_index = app_sm.select(tbldm, "dm_code=? and dm_lang=? and dm_category=?",
            new Object[]{"department_index", lang, ""}, "dm_showseq ASC, dm_createdate DESC");
    
	// 系所類別(第一層)
    Vector<TableRecord> dept_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category=? ", 
    		new Object[] { "department_category", lang, "" }, "dm_showseq ASC, dm_createdate DESC");
	// 系所類別(第二層)
    Vector<TableRecord> dept_sub_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category<>? ", 
    		new Object[] { "department_category", lang, "" }, "dm_showseq ASC, dm_createdate DESC");
	
	// 付款方式
	Vector<TableRecord> payments = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=? ", 
			new Object[]{"guide", lang}, "cp_showseq ASC, cp_createdate DESC");
	
	// 捐款專案
	Vector<TableRecord> pro_cps = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=?",
			new Object[]{"donate_project", lang}, "cp_showseq ASC, cp_createdate DESC");
	// 捐款專案(院系)
	Vector<TableRecord> dept_cps = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=?",
			new Object[]{"department", lang}, "cp_showseq ASC, cp_createdate DESC");
	
	// 幣別設定(不含臺幣)
	Vector<TableRecord> currency = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category=? and dm_subtitle<>?",
			new Object[]{"currency", lang, "", "TWD"}, "dm_showseq ASC, dm_createdate DESC");
	
	//受贈單位
	Vector<TableRecord> usages = app_sm.selectAll(tbldm, "dm_lang=? and dm_code=? and dm_category=?", 
			new Object[]{ lang, "donate_usage", "" } , "dm_showseq ASC , dm_createdate DESC");
	
	//捐款屬性
	Vector<TableRecord> attributes = app_sm.selectAll(tbldm, "dm_lang=? and dm_code=? and dm_category=?", 
			new Object[]{ lang, "donate_attribute", "" } , "dm_showseq ASC , dm_createdate DESC");
	
	String[] titles =   new String[] {"個人","校友","公司","法人"};
	String[] categorys = new String[] {"person","alumni","company","organization"};
	
	// 對照表
	Map<String, String> usage_title_map = new HashMap<String, String>();
	Map<String, String> attr_title_map = new HashMap<String, String>();
	
	for(TableRecord dm:usages) usage_title_map.put(dm.getString("dm_id"),dm.getString("dm_title"));
	for(TableRecord dm:attributes) attr_title_map.put(dm.getString("dm_id"),dm.getString("dm_title"));
%>
<html lang="<%=encoded %>">
<head>
	<%@include file="include/head.jsp"%>
	<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>

	<script src="<%=request.getContextPath() %>/js/zip.js"></script>
	<script>
		<%-- 表單檢核 --%>
		function checkform(F) {
			let is_person = F.dh_identity.value.trim() != '4';
			let is_college = F.dh_donate_project_category.value.trim() == '<%=department_index.getString("dm_id") %>';
			let is_other = F.dh_donate_project.value.trim() == 'other';
			let is_regular = F.dh_paymethod.value.trim().indexOf('regular')>-1;
			let is_receipt = F.dh_receipt_status.value.trim() == 'Y';
			let is_foreign = F.dh_foreign.value.trim() == 'Y';
			let isEmail = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;  	// 驗證Email
			let isCellPhone = /^09\(?\d{2}\)?[\s\-]?\d{3}\-?\d{3}$/;						// 手機格式
			let isPid = /^[A-Z][12][0-9]{8}$/;												// 身分證格式
			let isComid = /^[0-9]{8}$/														// 統編格式
			let isForeign = F.dh_currency.value != '';
			
			F.button1.disabled = true;
			
			  var radios = F.dh_paymethod;
			    var checked = false;

			    for(var i=0; i<radios.length; i++){
			        if(radios[i].checked){
			            checked = true;
			            break;
			        }
			    }
			
			if(!$.isNumeric(F.dh_total.value.trim())){
				alert('請輸入正確的捐款金額(臺幣)!!');
				F.dh_total.focus();
			} else if(parseInt(F.dh_total.value.trim()==0){
				alert('捐款金額(臺幣)不可等於0元!!');
				F.dh_total.focus();
			} else if(!$.isNumeric(F.dh_foreign_total.value.trim())){
				alert('請輸入正確的捐款金額(外幣)!!');
				F.dh_foreign_total.focus();
			} else if(isForeign && parseInt(F.dh_foreign_total.value.trim())==0){
				alert('捐款金額(外幣)不可等於0元!!');
				F.dh_total.focus();
			} else if(F.dh_donate_project_category.value.trim() == ''){
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
			} else if(!checked){
				alert('請選擇付款方式!!');
				radios[0].focus();
			} else if(F.dh_name.value.trim() == ''){
				alert('請填寫姓名/機構名稱!!');
				F.dh_name.focus();
			} else if(F.dh_pid.value.trim() == ''){
				alert('請填寫身分證字號/統一編號!!');
				F.dh_pid.focus();
			} else if(F.dh_cellphone.value.trim() == ''){
				alert('請填寫正確的連絡電話!!');
				F.dh_cellphone.focus();
			} else if(!is_foreign && F.dh_county.value.trim() == ''){
				alert('請填寫通訊地址!!');
				F.dh_county.focus();
			} else if(!is_foreign && F.dh_city.value.trim() == ''){
				alert('請填寫通訊地址!!');
				F.dh_city.focus();
			} else if(!is_foreign && F.dh_zipcode.value.trim() == ''){
				alert('請填寫通訊地址!!');
				F.dh_zipcode.focus();
			} else if(F.dh_address.value.trim() == ''){
				alert('請填寫通訊地址!!');
				F.dh_address.focus();
			} else if(!isEmail.test(F.dh_email.value.trim())){
				alert('請填寫電子信箱!!');
				F.dh_email.focus();
			} else if(F.dh_identity.value.trim() == ''){
				alert('請選擇贈與身分!!');
				F.dh_identity[0].focus();
			} else if(is_person && !isPid.test(F.dh_pid.value.trim())){
				alert('請填寫正確的身分證字號!!');
				F.dh_pid.focus();
			} else if(!is_person && !isComid.test(F.dh_pid.value.trim())){
				alert('請填寫正確的統一編號!!');
				F.dh_pid.focus();
			} else if(F.dh_receipt_status.value.trim() == ''){
				alert('請選擇捐款收據!!');
// 				F.dh_receipt_status.focus();
			} else if(is_receipt && F.dh_receipt_title.value.trim() == ''){
				alert('請輸入收據抬頭!!');
				F.dh_receipt_title.focus();
			} else if(is_receipt && !is_foreign && F.dh_receipt_county.value.trim() == ''){
				alert('請填寫收據地址!!');
				F.dh_receipt_county.focus();
			} else if(is_receipt && !is_foreign && F.dh_receipt_city.value.trim() == ''){
				alert('請填寫收據地址!!');
				F.dh_receipt_city.focus();
			} else if(is_receipt && !is_foreign && F.dh_receipt_zipcode.value.trim() == ''){
				alert('請填寫收據地址!!');
				F.dh_receipt_zipcode.focus();
			} else if(is_receipt && F.dh_receipt_address.value.trim() == ''){
				alert('請填寫收據地址!!');
				F.dh_receipt_address.focus();
			} else if(F.dh_public.value.trim() == ''){
				alert('請選擇是否公開徵信!!');
				F.dh_public[0].focus();
			} else if(is_person && F.dh_tax.value.trim() == ''){
				alert('請選擇是否上傳稅務機關!!');
				F.dh_tax[0].focus();
			} else {
				$('#dh_donate_project_no').prop('disabled', false);
				$('#dh_donate_unit_title').prop('disabled', false);
				$('#dh_donate_attribute_title').prop('disabled', false);
				
				F.button1.disabled = false;
				return true;
			}
			
			F.button1.disabled = false;
		    return false;
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
    		
        	change_identity();					// 捐贈身分
        	change_receipt_type();				// 收據
        	change_address_type();				// 地址類型
		}
		
		<%-- 變更捐款身分 --%>
		function change_identity(){
			let value = $('[name=dh_identity]:checked').val();
			let thank = '';
			
			// 國稅局上傳
			$('[name=dh_tax]').prop('disabled', value == '4');
			$('[name=dh_tax]').prop('checked', false);
			
			// 贈與身分(感謝狀)
			thank = value=='4'?'company':value=='1'?'alumni':'person';
			$('[name=dh_identity_thank]').prop('checked', false);
			$('[name=dh_identity_thank][value='+thank+']').prop('checked', true);
		}
		
		<%-- 變更地址類型 --%>
		function change_address_type(){
			let value   = $('[name=dh_foreign]:checked').val();
			let receipt = $('[name=dh_receipt_status]:checked').val();
			
			if(value == 'Y') {
				$('#dh_county').hide();
				$('#dh_city').hide();
				$('#dh_zipcode').hide();
				
				if(receipt == 'Y') {
					$('#dh_receipt_county').hide();
					$('#dh_receipt_city').hide();
					$('#dh_receipt_zipcode').hide();
				}
			} else {
				$('#dh_county').show();
				$('#dh_city').show();
				$('#dh_zipcode').show();
				
				if(receipt == 'Y') {
					$('#dh_receipt_county').show();
					$('#dh_receipt_city').show();
					$('#dh_receipt_zipcode').show();
				}
			}
		}
		
		<%-- 變更收據類型 --%>
		function change_receipt_type(){
			let value   = $('[name=dh_receipt_status]:checked').val();
			let foreign = $('[name=dh_foreign]:checked').val();
			
			if(value == 'Y') {
				$('#receiptName').show();
				$('#receiptAddr').show();
				
				if(foreign == 'Y') {
					$('#dh_receipt_county').hide();
					$('#dh_receipt_city').hide();
					$('#dh_receipt_zipcode').hide();
				} else {
					$('#dh_receipt_county').show();
					$('#dh_receipt_city').show();
					$('#dh_receipt_zipcode').show();
				}
			} else {
				$('#receiptName').hide();
				$('#receiptAddr').hide();
			}
		}
		
		$(document).ready(function(){
			donate_init();
			
			<%-- 變更捐款類別 --%>
			$("input[name='dh_donate_project_category']").change(function () { 
	            if (this.checked) {
	            	let dh_donate_item_category = $(this).val().trim();
	            	let item_id = $(this).attr('id');
	            	
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
			
			<%-- 變更地址類型 --%>
			$('[name=dh_foreign]').on('change', change_address_type);
			
			<%-- 變更收據類型 --%>
			$("[name=dh_receipt_status]").on('change', change_receipt_type);
			
			<%-- 變更身分別 --%>
			$('[name=dh_identity]').on('change', change_identity);
			
			// 同捐款人
			$('#same_name').on('change', function(){
				if($(this).is(':checked')) {
					$('#dh_receipt_title').val($('#dh_name').val());
				}				
			});
			
			// 同地址
			$('#same_address').on('change', function(){
				if($(this).is(':checked')) {
					$('#receipt_county').val($('#county').val());
					$('#receipt_city').val($('#city').val());
					$('#dh_receipt_county').val($('#dh_county').val()).change();
					$('#dh_receipt_city').val($('#dh_city').val()).change();
					$('#dh_receipt_zipcode').val($('#dh_zipcode').val());
					$('#dh_receipt_address').val($('#dh_address').val());
				}				
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
		<!-- 建立新增表單 20221018 May -->
		<form name="form0" action="<%=code %>_update.jsp?action=A&code=<%=code %>" method="post" enctype="multipart/form-data" onsubmit="return checkform(this);">
		<table width="99%" border="0" cellspacing="0" cellpadding="0">
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
				<td align="left" valign="middle" class="information_bigword"><%=show_title %></td>
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
								<td colspan="4" align="center">新增資訊</td>
							</tr>
							
						  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right" class="tablebg">捐款日期 ： </td>
		                 		<td width="30%" align="left" class="tablebg">&nbsp;&nbsp;<%=DateTimeTool.dateTimeString() %></td>
		                  		<td width="20%" align="right" class="tablebg">捐款是否付款 ： </td>
		                 		<td width="30%" align="left" class="tablebg">&nbsp;&nbsp;已付款</td> 		                 		                  	
						  	</tr>

							<tr>
		                  		<td colspan="4" align="center" class="information_title-1">捐款資訊</td>
		                	</tr>
		                	
<!-- 							<tr class="information_table-2-1"> -->
<!-- 		                  		<td width="20%" align="right"><font color='red'>＊</font>捐款金額(臺幣) ：  </td>  -->
<!-- 		                  		<td width="30%" align="left"> -->
<!--                                     <input type="text" name="dh_total" id="dh_total" value="0" placeholder="TWD" size="10"/>&nbsp;元 -->
<!-- 		                  		</td> -->
<!-- 		                  		<td width="20%" align="right">捐款金額(外幣) ：  </td>  -->
<!-- 		                  		<td width="30%" align="left"> -->
<!-- 		                  			<select name="dh_currency" id="dh_currency"> -->
<!-- 		                  				<option value="">請選擇</option> -->
<%--                                    		<%for(TableRecord dm:currency){ %> --%>
<%--                                    		<option value="<%=dm.getString("dm_subtitle") %>"><%=dm.getString("dm_title") %></option> --%>
<%--                                    		<%} %> --%>
<!--                                    	</select> -->
<!--                                     &nbsp;&nbsp; -->
<!--                                     <input type="text" name="dh_foreign_total" id="dh_foreign_total" value="0" size="10" placeholder="外幣金額，如非外幣請填0"/>&nbsp;元 -->
<!-- 		                  		</td> -->
<!-- 		                 	</tr> -->
<tr class="information_table-2-1">
    <td width="20%" align="right">
        <font color='red'>＊</font>捐款幣別：
    </td>
    <td width="30%" align="left">
            <label class="item_Radio_list">
                <input
                    type="radio"
                    class="item_radio"
                    name="dh_currency"
                    value="TWD"
                />
                <span class="radio-text">台幣</span>
            </label>

            <label class="item_Radio_list">
                <input
                    type="radio"
                    class="item_radio"
                    name="dh_currency"
                    value="other"
                    id="currency_other_radio"
                />
                <span class="radio-text">其他</span>
            </label>

            <input
                type="text"
                class="info_other"
                id="currency_other_input"
                name="dh_currency_other"
                placeholder="請輸入幣別代碼"
                maxlength="3"
                style="display:none; width:150px; margin-left:10px;"
            />
    </td>

    <td width="20%" align="right">
        <font color='red'>＊</font>捐款金額：
    </td>
    <td width="30%" align="left">
        <input
            type="text"
            name="dh_total"
            id="dh_total"
            placeholder="請輸入金額"
            size="10"
        />&nbsp;元
    </td>
</tr>
		                 	
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
		                 				<input type="radio" name="dh_donate_project_category" id="dc<%=i+1 %>" value="<%=dm.getString("dm_id")%>" > <%=dm.getString("dm_title")%>&nbsp;
			                 		</label>
			                 		<%} %>
									<%if(dept_dms.size()>0){ %>
									<label for="dc4">
			                 			<input type="radio" name="dh_donate_project_category" id="dc4" value="<%=department_index.getString("dm_id")%>" > 院系募款&nbsp;
									</label>
									<%} %>
									
									<%if(!lower_three){ %>
									<%for (int i = 3; i < project_count; i++) {
		                                TableRecord dm = donate_dms.get(i);
		                            %>
			                 		<label for="dc<%=i+2 %>">
		                 				<input type="radio" name="dh_donate_project_category" id="dc<%=i+2 %>" value="<%=dm.getString("dm_id")%>" > <%=dm.getString("dm_title")%>&nbsp;
			                 		</label>
			                 		<%} %>
							 		<%} %>
									<label for="dc0">
			                 			<input class="item_radio" type="radio" name="dh_donate_project_category" id="dc0" value="other" > 其他&nbsp;
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
			                            <option value="<%=cp.getString("cp_id") %>" data-category="<%=cp.getString("cp_category") %>" data-no="<%=cp.getString("cp_no") %>" data-usage="<%=cp.getString("cp_usage") %>" data-attr="<%=cp.getString("cp_attr") %>" data-title1="<%=usage_title %>" data-title2="<%=attr_title %>"><%=cp.getString("cp_title") %></option>
			                            <%} %>
			                            <option value="other" data-category="other">其他</option>
		                          </select>
		                          <input class="info_other" type="text" name="dh_donate_project_title" id="dh_donate_project_title" placeholder="請自行輸入指定用途" value=""  size="50"/>
		                 		</td>
						  	</tr>	     

		                  	<tr class="information_table-2-1" id="deptFund">
		                  		<td width="20%" align="right">院系募款 ： </td>
		                 		<td width="30%" align="left" colspan="3">
			                          <select name="dh_donate_college" id="dh_donate_college">
			                            <option value="">請選擇院所</option>
			                            <%for(TableRecord dm:dept_dms){ %>
			                            <option value="<%=dm.getString("dm_id") %>"><%=dm.getString("dm_title") %></option>
			                            <%} %>
			                          </select>
			                          <select name="dh_donate_department" id="dh_donate_department">
			                            <option value="">請選擇系所</option>
			                            <%for(TableRecord dm:dept_sub_dms){ %>
			                            <option value="<%=dm.getString("dm_id") %>" data-category="<%=dm.getString("dm_category") %>"><%=dm.getString("dm_title") %></option>
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
			                            <option value="<%=cp.getString("cp_id") %>" data-category="<%=cp.getString("cp_category") %>" data-no="<%=cp.getString("cp_no") %>" data-usage="<%=cp.getString("cp_usage") %>" data-attr="<%=cp.getString("cp_attr") %>" data-title1="<%=usage_title %>" data-title2="<%=attr_title %>"><%=cp.getString("cp_title") %></option>
			                            <%} %>
			                            <option value="other" data-category="other">其他</option>
			                          </select>
			                          <input class="info_other" type="text" name="donate_project_dept_title" id="donate_project_dept_title" placeholder="請自行輸入指定用途" value="" style="margin-top: 5px;" size="50"/>
		                 		</td>
						  	</tr>	
						  	
						  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right">計畫代碼 ： </td>
		                 		<td width="30%" align="left" colspan="3">
		                 			<input type="text" name="dh_donate_project_no" id="dh_donate_project_no" />
		                 		</td>
						  	</tr>
						  	
						  	<tr class="information_table-2-1">		  
		                  		<td width="20%" align="right">受贈單位 ： </td>
		                 		<td width="30%" align="left">
		                 			<input type="hidden" name="dh_donate_unit" id="dh_donate_unit" />
		                 			<input type="text" name="dh_donate_unit_title" id="dh_donate_unit_title" />
		                 		</td> 
		                  		<td width="20%" align="right">捐款屬性 ：  </td>
		                  		<td width="30%" align="left">
		                  			<input type="hidden" name="dh_donate_attribute" id="dh_donate_attribute" />
		                 			<input type="text" name="dh_donate_attribute_title" id="dh_donate_attribute_title" />
		                  		</td>              		
						  	</tr>
		                 	
		                  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right">捐款用途備註說明 ： </td>
		                 		<td width="30%" align="left" colspan="3">
		                 			<input type="text" name="dh_remark" id="dh_remark" size="50"/>
		                 		</td>
						  	</tr>	         	

		                  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right">捐款方式 ： </td>
		                 		<td width="30%" align="left" colspan="3">
	                         	<%for(TableRecord payment : payments){ 
	                         		// 只顯示線下捐款方式
	                         		if(payment.getString("cp_category").contains("newebpay") || payment.getString("cp_category").contains("pu")) continue;
	                         	%>
	                         	<label for="<%=payment.getString("cp_category") %>">
									<input type="radio" name="dh_paymethod" id="<%=payment.getString("cp_category") %>" value="<%=payment.getString("cp_category") %>">&nbsp;<%=payment.getString("cp_title") %> &nbsp; 
	                            </label>
	                            <%} %>
		                 		</td>
						  	</tr>	

						  	<tr>
		                  		<td colspan="4" align="center" class="information_title-1">捐款人個人資料</td>
		                  	</tr>	
		                  
		                  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right"><font color='red'>＊</font>姓名/機構名稱 ：  </td>
		                  		<td width="30%" align="left" >
		                  			<input type="text" name="dh_name" id="dh_name" placeholder=""/>
		                  		</td>
		                  		<td width="20%" align="right"><font color='red'>＊</font>身份證字號/統一編號 ：  </td>
		                  		<td width="30%" align="left" >
		                  			<input type="text" name="dh_pid" id="dh_pid" maxlength="10"/>
		                  		</td>		                  		
						  	</tr>
						  	
		                  	<tr class="information_table-2-1">		
		                  		<td width="20%" align="right"><font color='red'>＊</font>聯絡電話 ：  </td>
		                  		<td width="30%" align="left" >
		                  			<input type="text" name="dh_cellphone" id="dh_cellphone" maxlength="50"/>
		                  		</td>			                  					  	
		                  		<td width="20%" align="right">電話 ：  </td>
			                  		<td width="30%" align="left" >
		                  			<input type="text" name="dh_phone" id="dh_phone" maxlength="50"/>
		                  		</td>						  	
						  	</tr>	
						  	
						  	<tr class="information_table-2-1">
		                  		<td align="right"><font color='red'>＊</font>通訊地址： </td>
		                 		<td align="left" colspan="3" >
		                 			<label for="internal">
                                    	<input type="radio" class="item_radio" name="dh_foreign" id="internal" value="N" checked />
                                     	國內&nbsp;
                                    </label>

                                    <label for="overseas">
                                        <input type="radio" class="item_radio" name="dh_foreign" id="overseas" value="Y" />
                                   		國外&nbsp;
                                    </label>
		                 			<input type="hidden" name="county" value="" />
                        			<input type="hidden" name="city" value="" />
                                    <select name="dh_county" id="dh_county" onchange="changeZone(form0.dh_county, form0.dh_city, form0.dh_zipcode, form0.county, form0.city)"></select>
                                    <select name="dh_city" id="dh_city" onchange="showZipCode(form0.dh_county, form0.dh_city, form0.dh_zipcode, form0.county, form0.city)"></select>
                                    <input type="text" class="fLRA_pdhtalCode" name="dh_zipcode" id="dh_zipcode" readonly size="5"/>
                                    <input type="text" class="address fLRA_address" name="dh_address" id="dh_address" size="30"/>
		                 		</td>
						  	</tr>
		                  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right"><font color='red'>＊</font>E-Mail ： </td>
		                 		<td width="30%" align="left" colspan="3">
		                 			<input type="text" name="dh_email"  id="dh_email" size="50"/>
		                 		</td>
						  	</tr>						  	
		                  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right"><font color='red'>＊</font>贈與身分 ： </td>
		                 		<td width="30%" align="left" colspan="3">
		                 			<label for="gi1">
		                 				<input type="radio" class="item_radio" name="dh_identity" id="gi1"  value="1" />
			                          	靜宜校友，民國&nbsp;
			                          	<input type="text" name="dh_identity_year" id="dh_identity_year" size="10"/>&nbsp;年&nbsp;
			                          	<input type="text" name="dh_identity_dept" id="dh_identity_dept" size="10"/>&nbsp;系/所/班 畢(結)業
			                        </label>
			                        <br/>
			                        <label for="gi2">
		                 				<input class="item_radio" type="radio" name="dh_identity" id="gi2" value="2"> 靜宜教職員&nbsp;
			                        </label> 
			                        <label for="gi3">
			                        	<input class="item_radio" type="radio" name="dh_identity" id="gi3" value="3"> 學生/家長&nbsp;
			                        </label> 
			                        <label for="gi4">
		                 				<input class="item_radio" type="radio" name="dh_identity" id="gi4" value="4"> 企業機構&nbsp;
			                        </label> 
			                        <label for="gi5">
		                 				<input class="item_radio" type="radio" name="dh_identity" id="gi5" value="5"> 社會人士
			                        </label>  
		                 		</td>
							</tr>
							<tr class="information_table-2-1">
		                  		<td width="20%" align="right"><font color='red'>＊</font>贈與身分(感謝狀) ： </td>
		                 		<td width="30%" align="left" colspan="3">
		                 			<%for(int k = 0; k < titles.length; k++) { %>
					    			<label for="identity_<%=categorys[k] %>">
					    				<input type="radio" value="<%=categorys[k] %>" id="identity_<%=categorys[k] %>" name="dh_identity_thank"  />
					    				&nbsp;<%=titles[k] %>
					    			</label>
									<%} %>
		                 		</td>
							</tr>
		                  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right">服務單位 ： </td>
		                 		<td width="30%" align="left" >
			                          <input type="text" name="dh_unit" id="dh_unit"/>
		                 		</td>
		                  		<td width="20%" align="right">職稱 ： </td>
		                 		<td width="30%" align="left" >
			                          <input type="text" name="dh_job" id="dh_job"/>
		                 		</td>		                 		
							</tr>	
													
						  	<tr class="information_table-2-1">				  
		                  		<td align="right"><font color='red'>＊</font>收據 ： </td>
		                 		<td align="left" colspan="3">
		                 			<label for="no_receipt">
		                 				<input type="radio" name="dh_receipt_status" id="no_receipt"  value="N"> 不寄收據
			                 		</label>
			                 		<label for="yes_receipt">
		                 				<input type="radio" name="dh_receipt_status" id="yes_receipt" value="Y"> 寄收據
									</label>
								</td>			                 		
						  	</tr>
						  	
						  	
						  	<tr class="information_table-2-1" id="receiptName">
		                  		<td width="20%" align="right"><font color='red'>＊</font>收據姓名 ： </td>
		                 		<td width="30%" align="left" colspan="3">
                                    <input type="text" name="dh_receipt_title" id="dh_receipt_title" placeholder="" />
		                 			&nbsp;
		                 			<label for="same_name"><!--未登入時顯示-->
                                        <input type="checkbox" id="same_name" name="dh_same_name" value="Y" >
                                        同捐款人
                                    </label>
		                 		</td>
						  	</tr>
						  	
						  	<tr class="information_table-2-1" id="receiptAddr">
		                 		<td align="right"><font color='red'>＊</font>收據地址 ： </td>
		                 		<td align="left" colspan="3">
		                 			<input type="hidden" id="receipt_county" name="receipt_county" >
			                        <input type="hidden" id="receipt_city" name="receipt_city" >     
			                        <select name="dh_receipt_county" id="dh_receipt_county" onchange="changeZone(form0.dh_receipt_county, form0.dh_receipt_city, form0.dh_receipt_zipcode, form0.receipt_county, form0.receipt_city)"></select>
			                        <select name="dh_receipt_city" id="dh_receipt_city" onchange="showZipCode(form0.dh_receipt_county, form0.dh_receipt_city, form0.dh_receipt_zipcode, form0.receipt_county, form0.receipt_city)"></select>
		                 			<input type="text" name="dh_receipt_zipcode" id="dh_receipt_zipcode" class="fLRA_postalCode" readonly size="5">
                                    <input type="text" name="dh_receipt_address" id="dh_receipt_address" class="address fLRA_address" placeholder="" size="30">	                  
		                 			&nbsp;
		                 			<label for="same_address"><!--未登入時顯示-->
                                        <input type="checkbox" id="same_address" name="dh_same_address" value="Y" >
                                        同通訊地址
                                    </label>
		                 		</td>
						  	</tr>
						  	
						  	<tr class="information_table-2-1">				  
		                  		<td width="20%" align="right"><font color='red'>＊</font>公開 ： </td>
		                 		<td width="30%" align="left">
		                 			<label for="show_name"><!--未登入時顯示-->
                                    	<input type="radio" name="dh_public" id="show_name" value="Y"> 公開&nbsp;
			                 		</label>
			                 		<label for="hide_name"><!--未登入時顯示-->
                                    	<input type="radio" name="dh_public" id="hide_name" value="N"> 不公開（註記為靜宜之友）&nbsp;
                                    </label>
		                 		</td>
		                  		<td width="20%" align="right"><font color='red'>＊</font>上傳稅務機關 ： </td>
		                 		<td width="30%" align="left">
			                 		<label for="has_tax"><!--未登入時顯示-->
                                    	<input type="radio" name="dh_tax" id="has_tax" value="Y"> 上傳&nbsp;
			                 		</label>
			                 		<label for="no_tax"><!--未登入時顯示-->
                                    	<input type="radio" name="dh_tax" id="no_tax" value="N"> 不上傳&nbsp;
			                 		</label>
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
								<td width="20%" align="right">建檔人員</td>
								<td width="30%" align="left"><%=app_account%></td>
								<td width="20%" align="right">建檔日期</td>
								<td width="30%" align="left"><%=app_today%></td>
							</tr>


						</table>
						</td> 
						
					</tr>
					<tr align="center">
						<td colspan="4" align="center"><br />
							<input type="submit" name="button1" id="button1" value="確定送出">&nbsp;
							<input type="reset" value="重新設定">&nbsp;
						</td>
					</tr>
					
				</table>
				</td>
						
			</tr>
			
			</form>
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
<script>
document.addEventListener("DOMContentLoaded", function () {
    const currencyRadios = document.querySelectorAll('input[name="dh_currency"]');
    const currencyOtherInput = document.getElementById("currency_other_input");

    function toggleCurrencyOther() {
        const checked = document.querySelector('input[name="dh_currency"]:checked');

        if (checked && checked.value === "other") {
            currencyOtherInput.style.display = "inline-block";
        } else {
            currencyOtherInput.style.display = "none";
            currencyOtherInput.value = "";
        }
    }

    for (let i = 0; i < currencyRadios.length; i++) {
        currencyRadios[i].addEventListener("change", toggleCurrencyOther);
    }

    toggleCurrencyOther();
});
</script>
<script> ResetAll(form0.dh_county, form0.dh_city, form0.dh_zipcode, form0.county, form0.city); </script>
<script> ResetAll(form0.dh_receipt_county, form0.dh_receipt_city, form0.dh_receipt_zipcode, form0.receipt_county, form0.receipt_city); </script>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>