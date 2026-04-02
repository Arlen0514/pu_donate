<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/config.jspf" %>
<%@ include file="/WEB-INF/jspf/csrf_token.jspf" %>
<%@ include file="/web/include/encryption.jsp"%>
<%

String page_code = "donate_project";
String code = "activity_donate";

String dm_id = StringTool.validString(request.getParameter("dm_id"),"");
String cp_id = StringTool.validString(request.getParameter("cp_id"),"");

System.out.println("cp_id :"+cp_id);
TableRecord cp = app_sm.select(tblcp, cp_id);


// 輪播圖
Vector<TableRecord> banner_aps = app_sm.selectAll(tblap, "ap_code=? AND ap_category =?  AND ap_lang =? AND NOT(ap_emitdate>? OR ap_restdate<?)",
        new Object[]{"activity_banner", cp_id, lang, app_today, app_today}, "ap_showseq ASC , ap_createdate DESC");

//捐款單下載檔案
TableRecord download_file = app_sm.select(tblcp, "cp_code = ? AND cp_lang = ?", new Object[]{"donate_download",lang});

/*-----------------------表單資訊---------------------------------------*/


	/*-- 表單資訊 --*/
	TableRecord dh = (TableRecord) session.getAttribute("donate_form");
	boolean is_filled = true;
	
	if(dh == null) {
		is_filled = false;
		dh = new TableRecord(tbldh);
	}
			
	// 表單欄位
	Map<String, String> default_values = new HashMap<String, String>();
	String[] field_names = dh.fieldNames();
	
	for(String field_name:field_names) 
		default_values.put(field_name, String.valueOf(dh.getValue(field_name)));
	if(is_filled) default_values.put("dh_pid", new AESDataEncryption().AESDecrypt(dh.getString("dh_pid")));
	if(!is_filled) default_values.put("dh_regular_type", "M");
	
	/*-- 頁面資訊區 --*/
	// 捐款類別列表
	Vector<TableRecord> donate_project_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category=?"
			, new Object[]{"donate_category", lang, ""}, "dm_showseq ASC, dm_createdate DESC");
	// 院系捐款  
	TableRecord department_index = app_sm.select(tbldm, "dm_code=? and dm_lang=? and dm_category=?",
            new Object[]{"department_index", lang, ""}, "dm_showseq ASC, dm_createdate DESC");
	
	// 付款方式
	Vector<TableRecord> payments = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=? and cp_display=?", 
			new Object[]{"guide", lang, "Y"}, "cp_showseq ASC, cp_createdate DESC");
	
	// 預設專案類型
// 	String donate_id = cp_id;
	
// 	if(donate_id.startsWith("DM")){				// 募款專案
// 		default_values.put("dh_donate_project_category", donate_id);
// 	} else if(donate_id.startsWith("CP")){		// 院系捐款
// 		TableRecord project_cp = app_sm.select(tblcp, donate_id);
	
// 		default_values.put("dh_donate_project_category", department_index.getString("dm_id"));
// 		default_values.put("dh_donate_college", project_cp.getString("cp_upcategory"));
// 		default_values.put("dh_donate_department", project_cp.getString("cp_category"));
// 		default_values.put("dh_donate_project", donate_id);
// 	}
	
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
	
	// 計畫選項預設
	String project_category = default_values.get("dh_donate_project_category");
	boolean is_dept = project_category.equals(department_index.getString("dm_id"));
	boolean has_category = !"".equals(project_category);
	
	if(has_category) {
		if(is_dept){
			String project_college = default_values.get("dh_donate_college");
			String project_dept = default_values.get("dh_donate_department");
			
			dept_sub_dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category=? ", 
		    		new Object[] { "department_category", lang, project_college }, "dm_showseq ASC, dm_createdate DESC");
			dept_cps = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=? and cp_category=?",
					new Object[]{"department", lang, project_dept}, "cp_showseq ASC, cp_createdate DESC");
		} else {
			pro_cps = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=? and cp_category=?",
					new Object[]{"donate_project", lang, project_category}, "cp_showseq ASC, cp_createdate DESC");
		}
	}

	
	// 數字格式
	DecimalFormat df = new DecimalFormat("00");
	
	String csrfToken = generateCSRFToken(session, "normalform");

%>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
       
       
       
<title><%=cp.getString("cp_webtitle")%></title>
<%@include file="../include/head.jsp" %>

        <!-- Varela Round字體 -->
        <link href="https://fonts.googleapis.com/css2?family=Varela+Round&display=swap" rel="stylesheet" />
        <link rel="stylesheet" type="text/css" href="../css/style_nav/style_fundraiser/fundraiser.css" />

        <link rel="stylesheet" href="../css/style_nav/style_donate/style_donate.css" />
        
  <%-- SEO 讀取關鍵字設定值 (讀取首頁共用值) --%>
<meta name="Robots" content="<%=cp.getString("cp_robots") %>" />
<meta name="revisit-after" content="<%=cp.getString("cp_revisit_after") %> days" />
<meta name="keywords" content="<%=cp.getString("cp_keywords") %>" />
<meta name="copyright" content="<%=cp.getString("cp_copyright") %>" />
<meta name="description" content="<%=cp.getString("cp_description") %>" />
<%-- 追蹤碼 --%><%=cp.getString("cp_seo_head_track") %>
<!-- Facebook og 設定 -->
<meta property="og:url" content="<%=request.getRequestURL()+(request.getQueryString()!=null&&!request.getQueryString().isEmpty()?"?"+request.getQueryString():"") %>" />
<meta property="og:type" content="website" />
<meta property="og:title" content="<%=app_webtitle %>" />
<meta property="og:description" content="<%=SiteSetup.getText("seo.description."+lang) %>" />
     	<%--資料檢核 --%>
     <script src="<%=request.getContextPath() %>/js/DataCheck.js"></script>
     
     <script type="text/javascript">
		<%-- 表單檢核 --%>
		function checkform(F) {
			let is_person = F.dh_identity.value.trim() != '4';
			let is_foreigner = F.dh_identity_type.value.trim() != 'foreigner';
<%-- 			let is_college = F.dh_donate_project_category.value.trim() == '<%=department_index.getString("dm_id") %>'; --%>
			let is_other = F.dh_donate_project.value.trim() == 'other';
			let is_regular = F.dh_paymethod.value.trim().indexOf('regular')>-1;
			let is_year	= '';
			if(is_regular){
				is_year	= F.dh_regular_type.value.trim() == 'Y';
			}			let is_receipt = F.dh_receipt_status.value.trim() == 'Y';
			let is_foreign = F.dh_foreign.value.trim() == 'Y';
			
			
			if(!$.isNumeric(F.dh_total.value.trim())){
				alert('請輸入正確的捐款金額!!');
				F.dh_total.focus();
			} else if(parseInt(F.dh_total.value.trim())==0){
				alert('捐款金額不可等於0元!!');
				F.dh_total.focus();
// 			} else if(F.dh_donate_project_category.value.trim() == ''){
// 				alert('請選擇捐贈類別!!');
// 				F.dh_donate_project_category[0].focus();
// 			} else if(!is_college && F.dh_donate_project.value.trim() == ''){
// 				alert('請選擇指定捐贈用途!!');
// 				F.dh_donate_project.focus();
// 			} else if(!is_college && is_other && F.dh_donate_project_title.value.trim() == ''){
// 				alert('請輸入其他捐贈用途!!');
// 				F.dh_donate_project_title.focus();
// 			} else if(is_college && F.dh_donate_college.value.trim() == ''){
// 				alert('請選擇院所!!');
// 				F.dh_donate_college.focus();
// 			} else if(is_college && F.dh_donate_department.value.trim() == ''){
// 				alert('請選擇系所!!');
// 				F.dh_donate_college.focus();
// 			} else if(is_college && F.donate_project_dept.value.trim() == ''){
// 				alert('請選擇計畫名稱!!');
// 				F.donate_project_dept.focus();
			} else if(F.dh_paymethod.value.trim() == ''){
				alert('請選擇付款方式!!');
				F.dh_paymethod.focus();
				<%--
			} else if(is_regular && (F.dh_expiration_year.value.trim() =='' || F.dh_expiration_month.value.trim() == '') && !isDateValid(F.dh_expiration_year.value.trim(), F.dh_expiration_month.value.trim())){
				alert('請選擇正確的扣款起始日!!');
				F.dh_expiration_year.focus();
				--%>
			} else if(is_regular && F.dh_debit_due_year.value.trim() == ''){
				alert('請選擇扣款到期日年份!!');
				F.dh_debit_due_year.focus();
			} else if(is_regular && !is_year && F.dh_debit_due_month.value.trim() == ''){
				alert('請選擇扣款到期日月份!!');
				F.dh_debit_due_month.focus();
			} else if(is_regular && !is_year && !isDateValid(F.dh_debit_due_year.value.trim(), F.dh_debit_due_month.value.trim())) {
				alert('請選擇正確的扣款到期日!!');
				F.dh_debit_due_year.focus();
			} else if(F.dh_identity_type.value.trim() == ''){
				alert('請選擇身分別!!');
				F.dh_identity_type[0].focus();
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
			} else if(!isEmailStrict(F.dh_email.value.trim())){
				alert('請填寫電子信箱!!');
				F.dh_email.focus();
			} else if(F.dh_identity.value.trim() == ''){
				alert('請選擇贈與身分!!');
				F.dh_identity[0].focus();
			} else if(is_person && !checkPID(F.dh_pid.value.trim())){
				alert('請填寫正確的身分證字號!!');
				F.dh_pid.focus();
			} else if(!is_person && !checkTaiwanVAT(F.dh_pid.value.trim())){
				alert('請填寫正確的統一編號!!');
				F.dh_pid.focus();
			} else if(is_foreigner && !checkArcOrPassport(F.dh_pid.value.trim())){//居留證或護照
				alert('請填寫正確的居留證或護照!!');
				F.dh_pid.focus();
			} else if(F.dh_receipt_status.value.trim() == ''){
				alert('請選擇捐款收據!!');
				F.dh_receipt_type[0].focus();
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
// 			} else if(is_person && F.dh_tax.value.trim() == ''){
// 				alert('請選擇是否上傳稅務機關!!');
// 				F.dh_tax[0].focus();
			} else if(F.ind.value.trim() == ''){
				alert('請填寫驗證碼!!');
				F.ind.focus();
			} else if(!$('#agree').is(':checked')){
				alert('請勾選我已詳閱、同意接受《個人資料事項告知暨使用同意書》!!');
				$('#agree').focus();
			} 
			else {
				return true;
			}
			
		    return false;
		}
		
		function checkArcOrPassport(val) {//居留證或護照格式
		    if (!val) return false;

		    val = val.trim().toUpperCase();

		    // 外國人居留證：1 英文 + 9 數字
		    const arcRegex = /^[A-Z][0-9]{9}$/;

		    // 護照：6~9 碼英數
		    const passportRegex = /^[A-Z0-9]{6,9}$/;

		    return arcRegex.test(val) || passportRegex.test(val);
		}
		
		
		<%-- 日期檢查 --%>
		function isDateValid(year, month){
			// 獲取當前日期的年份和月份
		    var currentDate = new Date();
		    var currentYear = currentDate.getFullYear();
		    var currentMonth = currentDate.getMonth() + 1; // 月份從 0 開始計算，所以要加 1
		    var compareYear = parseInt(year);
		    var compareMonth = parseInt(month);
		    
		    return compareYear > currentYear || compareYear === currentYear && compareMonth >= currentMonth;
		}

		<%-- 表單預設值 --%>
		function donate_init(){
			$('#deptFund').hide();
        	$('#donate_project_area').hide();
        	$('.donatePay_text li').hide();
        	
        	// 捐款金額
        	<%if(is_filled){%>
        	if($('[name=donate_amount]:checked').length==0) {
        		$('#d_a_other').parent().addClass('active');
        	}
        	<%}%>
        	
        	// 捐款類別
//         	if($('[name=dh_donate_project_category]:checked').length>0) {
//         		let item_category = $('[name=dh_donate_project_category]:checked').val().trim();
//             	let item_id = $('[name=dh_donate_project_category]:checked').attr('id');
            	
//             	switch(item_id){
// 	                case 'dc0':									// 其他
// 	                	$('#deptFund').hide();
// 	                	$('#donate_project_area').show();
// 	                	$(".donationPurpose_info .info_other").show(); 	// 關閉
// 	                	break;
// 	                case 'dc4':									// 院系募款
// 	                	$('#deptFund').show();
// 	                	$('#donate_project_area').hide();
// 	                	if($('#donate_project_dept').val() == 'other') {
// 	                		$("#donate_project_dept_other").css({
// 	                            "grid-column": "1 / 4",
// 	                            "display": "grid",
// 	                        });
// 	                	}
// 	                	break;
// 	                default:
// 	                	$('#deptFund').hide();
// 	            		$('#donate_project_area').show();
// 	                	$(".donationPurpose_info .info_other").hide(); 	// 關閉
// 						break;		                	
// 	            }
//         	}
        	
        	// 付款方式
        	if($('[name=dh_paymethod]:checked').length>0) {
        		let paymethod = $('[name=dh_paymethod]:checked').val();
        		
                $('.donatePay_text li[id="'+paymethod+'_text"]').show();
                $('.donatePay_text li[id="'+paymethod+'_text"]').css('display', 'flex');
                
                // 定期定額
                if(paymethod.indexOf('regular')>-1){
                	$('.regular_fields').show();
                	change_regular_type();
                } else {
                	$('.regular_fields').hide();
                }
        	}
        	
        	change_identity();					// 捐贈身分
        	change_receipt_type();				// 收據類型
        	change_address_type();				// 地址類型
		}
		
		<%-- 變更捐款項目 --%>
// 		function change_donate(item_category, item_id){
			
//             switch(item_id){
//                 case 'dc0':									// 其他
//                 	$('#deptFund').hide();
//                 	$('#donate_project_area').show();
//                 	$(".donationPurpose_info .info_other").show(); 	// 關閉
//                 	search_donate_project('project', item_category);
//                 	break;
//                 case 'dc4':									// 院系募款
//                 	$('#deptFund').show();
//                 	$('#donate_project_area').hide();
//                 	$('#dh_donate_college').val('').change();
//                 	change_dept('college');
//                 	break;
//                 default:
//                 	$('#deptFund').hide();
//             		$('#donate_project_area').show();
//                 	$(".donationPurpose_info .info_other").hide(); 	// 關閉
//                 	search_donate_project('project', item_category);
// 					break;		                	
//             }
// 		}
		
		<%-- 變更院系系所 --%>
// 		function change_dept(dept_type){
// 			let value = $('#dh_donate_'+dept_type).val();
			
// 			if(dept_type == 'department'){
// 				search_donate_project('department', value);
// 			} else {
// 				let url = '../ajax/search_donate_dept.jsp';
// 				let data = {
// 						async: false,
// 						college: value
// 				};
				
// 				$.post(url, data, function(res){
// 					let jsonObj = JSON.parse(res);
					
// 					if(jsonObj.status){
// 						$('#dh_donate_department').html(jsonObj.options);
// 						search_donate_project('department', value);
// 					}
// 				});
// 			}
// 		}
		
		<%-- 取得捐款計畫 --%>
// 		function search_donate_project(category_type, category_id) {
// 			let url = '../ajax/search_donate_project.jsp';
// 			let data = {
// 					async: false,
// 					type: category_type,
// 					category: category_id
// 			};
			
// 			$.post(url, data, function(res){
// 				let jsonObj = JSON.parse(res);
				
// 				if(jsonObj.status){
// 					if(category_type == 'project')
// 						$('#dh_donate_project').html(jsonObj.options);
// 					else if(category_type == 'department')
// 						$('#donate_project_dept').html(jsonObj.options);
// 				}
// 			});
// 		}
		
		<%-- 變更地址類型 --%>
		function change_address_type(){
			let value   = $('[name=dh_foreign]:checked').val();
			let receipt = $('[name=dh_receipt_status]:checked').val();
			
			if(value == 'Y') {
				$('#dh_county').hide();
				$('#dh_city').hide();
				$('#dh_zipcode').hide();
				$('#dh_address').parent('div').removeClass('fLR_address');
				
				if(receipt == 'Y') {
					$('#dh_receipt_county').hide();
					$('#dh_receipt_city').hide();
					$('#dh_receipt_zipcode').hide();
					$('#dh_receipt_address').parent('div').removeClass('fLR_address');
				}
			} else {
				$('#dh_county').show();
				$('#dh_city').show();
				$('#dh_zipcode').show();
				$('#dh_address').parent('div').addClass('fLR_address');
				
				if(receipt == 'Y') {
					$('#dh_receipt_county').show();
					$('#dh_receipt_city').show();
					$('#dh_receipt_zipcode').show();
					$('#dh_receipt_address').parent('div').addClass('fLR_address');
				}
			}
		}
		
		<%-- 變更定期定額類型 --%>
		function change_regular_type(){
			let value = $('[name=dh_regular_type]:checked').val();
			
			switch(value){
				case 'Y':					// 每年
					$('#debit_start_month').prop('disabled', true);
					$('#dh_debit_due_month').prop('disabled', true);
					$('#dh_debit_due_month').val('<%=df.format(DateTimeTool.getMonth()) %>').change();
					break;
				case 'M':					// 每月
					$('#debit_start_month').prop('disabled', false);
					$('#dh_debit_due_month').prop('disabled', false);
					$('#dh_debit_due_month').val('').change();
					break;
			}
		}
		
		<%-- 變更捐款身分 --%>
		function change_identity(){
			let value = $('[name=dh_identity]:checked').val();
			
			if(value == '4') $('#tax_upload').hide();
			else $('#tax_upload').show();
			$('[name=dh_tax]').prop('disabled', value == '4');
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
					$('#dh_receipt_address').parent('div').removeClass('fLR_address');
				} else {
					$('#dh_receipt_county').show();
					$('#dh_receipt_city').show();
					$('#dh_receipt_zipcode').show();
					$('#dh_receipt_address').parent('div').addClass('fLR_address');
				}
			} else {
				$('#receiptName').hide();
				$('#receiptAddr').hide();
			}
		}
		
		<%-- 載入驗證碼 --%>
		function loadimage() {
			document.getElementById("randImage").src = "../../comm/image.jsp?"+Math.random(); 
		}
		
		$(document).ready(function(){
			donate_init();
			
			<%-- 變更捐款金額 --%>
			$(".donateAmount_info input.item_radio:radio").change(function () {
	            if (this.checked) {
	           	 	$(".donateAmountItem input.item_radio:radio").not(this).parent()
	                    .siblings().removeClass("active");
	                $(".donateAmountItem input.item_radio:radio").not(this).parent()
	                    .siblings().children().attr("checked", false);
	                $(this).parent().toggleClass("active");
	                $(this).attr("checked", true);
	                $('#dh_total').val($(this).val().trim());
	            } else {
	                $(this).parent().removeClass("active");
	                $(this).attr("checked", false);
	            }
	        });
			
			<%-- 變更捐款類別 --%>
// 			$(".donateCategoryItem input.item_radio:radio").change(function () { 
// 	            if (this.checked) {
// 	            	let dh_donate_project_category = $(this).val().trim();
// 	            	let item_id = $(this).attr('id');
	            	
// // 	            	console.log('dh_donate_project_category', dh_donate_project_category);
	            	
// 	                $(".donateCategoryItem input.item_radio:radio").not(this).parent().siblings().removeClass("active");
// 	                $(".donateCategoryItem input.item_radio:radio").not(this).parent().siblings().children().attr("checked", false);
// 	                $(this).parent().toggleClass("active");
// 	                $(this).attr("checked", true);
	                
// 	                change_donate(dh_donate_project_category, item_id);
// 	            } else {
// 	                $(this).parent().removeClass("active");
// 	                $(this).attr("checked", false);
// 	            }
// 	        });
			
			<%-- 變更指定捐贈 --%>
// 			$('#dh_donate_project').on('change', function(){
// 				if($(this).val() == 'other')
// 					$('#dh_donate_project_title').show();
// 				else
// 					$('#dh_donate_project_title').hide();
// 			});
			
			<%--
			$(".donationPurpose_info select").change(function () {
              // 當checkbox框有變動(change/勾選或取消勾選)時
              if (this.value === "other") {
                $(".donationPurpose_info .info_other").show(); //打開
              } else {
                $(".donationPurpose_info .info_other").hide(); //關閉
              }
            });
            --%>
			
			<%-- 變更院系募款 --%>
// 			$('#donate_project_dept').on('change', function(){
// 				if($(this).val() == 'other') {
// 					$("#donate_project_dept_other").css({
//                         "grid-column": "1 / 4",
//                         "display": "grid",
//                     });
// // 					$('#donate_project_dept_other').show();
// 				} else {
// 					$('#donate_project_dept_other').hide();
// 				}
					
// 			});
			
			<%-- 變更院系系所(第一層) --%>
// 			$('#dh_donate_college').on('change', function(){
// 				change_dept('college');
// 			});
			
			<%-- 變更院系系所(第二層) --%>
// 			$('#dh_donate_department').on('change', function(){
// 				change_dept('department');
// 			});
			
			<%-- 變更付款方式 --%>
			$(".donatePayItem input.item_radio:radio").change(function() {
	            if (this.checked) {
	            	let paymethod = $(this).val().trim();
	            	
// 	            	console.log('$(".donatePayItem input.item_radio:radio").not(this).parent().siblings()', $(".donatePayItem input.item_radio:radio").not(this).parent().siblings());
// 	            	console.log('$(".donatePayItem input.item_radio:radio").not(this).parent().siblings() has class', $(".donatePayItem input.item_radio:radio").not(this).parent().siblings().hasClass('active'));
	            	
					$('.donatePayItem').removeClass('active');
					$('.donatePayItem').children().attr("checked", false);
	                $(this).parent().addClass("active");
	                $(this).attr("checked", true);					
// 	                $(".donatePayItem input.item_radio:radio").parent().siblings().removeClass("active");
// 	                $(".donatePayItem input.item_radio:radio").parent().siblings().children().attr("checked", false);
// 	                $(this).parent().toggleClass("active");
// 	                $(this).attr("checked", true);
	                
	                $('.donatePay_text li').hide();
	                $('.donatePay_text li[id="'+paymethod+'_text"]').show();
	                $('.donatePay_text li[id="'+paymethod+'_text"]').css('display', 'flex');
	                
	                // 定期定額
	                if(paymethod.indexOf('regular')>-1){
	                	$('.regular_fields').show();
	                	change_regular_type();
	                } else {
	                	$('.regular_fields').hide();
	                }
	                
	            } else {
	                $(this).parent().removeClass("active");
	                $(this).attr("checked", false);
	            }
	        });
			
			<%-- 變更定期定額類型 --%>
			$('[name=dh_regular_type]').on('change', change_regular_type);
			
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
	<%-- 地址用 --%>
	<script src="<%=request.getContextPath() %>/js/zip.js"></script> 
    </head>

    <body class="body_in">
    
    
        <%-- 追蹤碼 --%><%=cp.getString("cp_seo_body_track") %>
    

        <div class="headertop" id="top"></div>

        <header class="headerArea">
            <!--版頭-->
            <div class="header">
                <div class="wrap">
                    <!--手機menu按鍵-->
                    <div id="menu_btn" class="menu_btn">
                        <span></span>
                        <span></span>
                        <span></span>
                    </div>

                    <!--logo-->
                    <h1 class="logo">
                        <a href="../../home.jsp">
                            <img src="../images/logo.svg" alt="logo_pic" class="" />
                            <!-- <img src="web/images/logo.svg"  class="pc"/>
                        <img src="web/images/logo2.svg" class="mobile"/> -->
                        </a>
                    </h1>

                    <div class="headerRight">
                        <!-- 版頭右側_上方區塊 -->
                        <ul class="headerRight_topArea">
                            <!--活動介紹-->
                            <li class="">
                                <a href="fundraiser.jsp#about1" target="_blank" tabindex="4">活動介紹</a>
                            </li>

                            <!--前往捐款-->
                            <li class="">
                                <a href="fundraiser.jsp#about2" target="_blank" tabindex="5">前往捐款</a>
                            </li>
                        </ul>
                    </div>

                    <!-- <div class="clearfloat">
                </div> -->
                </div>
            </div>
        </header>

        <!--主內容區塊-->
        <main class="main inmain">
<div class="indexBannerArea">

            <!--輪播--><!-- 只放Banner圖與效果，放下面 -->
            <%
            
//             System.out.println(banner_aps.size());
            
            if (banner_aps.size() > 0) { %>
            <div class="banner banner_down">

                <div class="swiper-button-prev" role="button" aria-label="上一張輪播" aria-controls="swiper-wrapper-1426590ce514d65e" tabindex="28"></div>
                <div class="swiper-button-next" role="button" aria-label="下一張輪播" aria-controls="swiper-wrapper-1426590ce514d65e" tabindex="29"></div>

                <div id="particles-js"><canvas class="particles-js-canvas-el" width="1850" height="740" style="width: 100%; height: 100%;"></canvas></div>   
                
                <!-- Swiper -->
                <div class="swiper mySwiper swiper-container_down">
                    <div class="swiper-wrapper" >
                    <%
	                        for (TableRecord banner : banner_aps) {
	                            String banner_url = "javascript:void(0)";
	                            String banner_target = banner.getString("ap_target");
	                            boolean isLink = false;
	                            if (!banner.getString("ap_desc").equals("") && !banner.getString("ap_url").equals("") && !"none".equals(banner_target)) {
	                                isLink = true;
	                            }
	                            
	                            if(!"none".equals(banner_target)) banner_url = banner.getString("ap_url");
                                else banner_target = "";
	                %>
                    <div class="swiper-slide" >
                            <div class="indexBannerList">
                                <%if (isLink) {%>
                                <a href="<%=banner_url %>" tabindex="25" target="<%=banner_target %>">
								<%} %>
                                    <div class="pcBanner" style="background-image:url('<%=app_fetchpath+"/"+"activity_banner"+"/"+lang+"/"+banner.getString("ap_image")%>');">                                    
                                        
										
	                                    <div class="indexBannerIn">
	                                        <!--首頁banner列表標題-->
	                                        <h2 class="indexBanner_title">
	                                            <%=banner.getString("ap_desc")%>
	                                        </h2>
	
	                                        <!--首頁banner列表文字-->
	                                        <div class="indexBanner_remark">
	                                            <%=banner.getString("ap_content")%>
	                                        </div>
											<%if (isLink) {%>
	                                        <!--首頁banner列表按鍵-->
	                                        <div class="btn">
	                                            <label><strong>了解更多</strong></label>
	                                        </div>
	                                        <%}%> 
	                                    </div>
	                                                                           
                                    </div>



                                    <div class="mobileBanner" style="background-image:url('<%=app_fetchpath+"/"+"activity_banner"+"/"+lang+"/"+banner.getString("ap_mobile")%>');">                                    
                                    
                                        
	                                    <div class="indexBannerIn">
	                                        <!--首頁banner列表標題-->
	                                        <h2 class="indexBanner_title">
	                                            <%=banner.getString("ap_desc")%>
	                                        </h2>
	
	                                        <!--首頁banner列表文字-->
	                                        <div class="indexBanner_remark">
	                                            <%=banner.getString("ap_content")%>
	                                        </div>
										<%if (isLink) {%>
	                                        <!--首頁banner列表按鍵-->
	                                        <div class="btn">
	                                            <label><strong>了解更多</strong></label>
	                                        </div>
	                                   <%}%>
	                                    </div>
	                                    
                                    
                                    </div>

								<%if (isLink) {%>
                                </a>
                                <%} %>

                            </div>
                        </div>
						<%} %>
                                                
                        </div>
                    <!-- <div class="swiper-button-prev"></div>
                    <div class="swiper-button-next"></div>
                    <div class="swiper-pagination"></div> -->                    
                <span class="swiper-notification" ></span></div>

            </div>
			<%} %>
            <!-- Initialize Swiper -->
            <script>
                var swiper_down = new Swiper(".swiper-container_down", {
                    //輪播一次顯示幾張
                    slidesPerView: 1,
                    
                    //輪播位置啟始值為置中
                    centeredSlides: true,
                    
                    //自動輪播
                    // autoplay: {
                    //     delay: 5000,
                    //     disableOnInteraction: false,
                    // },
                    
                    //無限循環
                    loop: true,

                    //高度自適應
                    autoHeight: true,

                    speed: 1500,
                    
                    //視差效果
                    parallax : true,

                    //手動滑動
                    //allowTouchMove: true,  

                    // grabCursor: true,

                    //輪播點點顯示
                    // pagination: {
                    //     el: ".swiper-container_pc .swiper-pagination",
                    //     clickable: true,
                    // },
                    //左右按鍵點擊效果
                    navigation: {
                        nextEl: '.indexBannerArea .swiper-button-next',
                        prevEl: '.indexBannerArea .swiper-button-prev',
                    },
                    on: {
                        init: function () {
                        fixPaginationFocus();
                        },
                        slideChange: function () {
                        fixPaginationFocus();
                        },
                        paginationUpdate: function () {
                        fixPaginationFocus();
                        }
                    }

                });

                // 專門處理 pagination 可聚焦
                function fixPaginationFocus() {
                const bullets = document.querySelectorAll('.indexmain .banner .swiper-pagination .swiper-pagination-bullet');
                bullets.forEach((bullet, index) => {
                    bullet.setAttribute('tabindex', '0'); // 保證可以 Tab
                    bullet.setAttribute('role', 'button');
                    bullet.setAttribute('aria-label', `跳至第 ${index + 1} 張輪播`);
                });
                }
            </script>

            <script type="text/javascript" src="web/js/particles_master/particles.js"></script>
            <script type="text/javascript" src="web/js/particles_master/app.js"></script><!-- 速度1.5 -->

        </div>
            <!--首頁內容區塊-->
            <div class="pageContent">
                <div class="page">
                    <!--右側-->
                    <div class="right no_left">
                        <!-- 無左側選單 -->
                        <div id="about1" class="id_offset3"></div>
                        <div class="right_contentBg">
                            <!-- 活動捐款介紹 -->
                            <div
                                class="index_NAbg"
                                style="
                                    background-image: linear-gradient(
                                            to left,
                                            #ffffff00 0%,
                                            #ffffff6e 20%,
                                            #ffffffc7 50%,
                                            #ffffff 100%
                                        ),
                                        url(images/pic01.webp);
                                "
                            >
                                <div class="wrap">
                                    <!-- 首頁標題 -->
                                    <div class="index_tit">
                                        <div class="index_tit_icon">
                                            <!-- <i class="icon bi bi-megaphone"></i> -->
                                        </div>
                                        <h2>活動捐款介紹</h2>
                                    </div>

                                    <div class="index_NAarea">
                                        <div class="pI_top">
                                            <!--商品內頁商品圖-->
                                            <div class="product_in_img">
                                                <span>
                                                    <img src="<%=app_fetchpath+"/"+code+"/"+lang+"/"+cp.getString("cp_image")%>" alt="" srcset="" />
                                                </span>
                                            </div>

                                            <!--產品內頁上右-->
                                            <div class="pIT_right">
                                                <div class="pITR_tit">
                                                    <h2><%=cp.getString("cp_title") %></h2>
                                                </div>

                                                <!-- 簡述 -->
                                                <div class="pITR_remark">                                            
		                                            <%=cp.getString("cp_desc") %>
		                                        </div>
                                            </div>
                                        </div>
                                        <div class="pI_bottom">
                                            <!--網編區塊-->
                                            <section class="text_area">
                                                <%=cp.getString("cp_content") %> 
                                            </section>
                                        </div>
                                    </div>
                                </div>
                                <%if("Y".equals(cp.getString("cp_show_goal")) && cp.getInt("cp_goal")!=0){
                                	int numberOfDonate = 0;					//捐款人數量
                                	int totalOfDonate = 0;					//總捲款金額
                                	int donateGoal = cp.getInt("cp_goal");	//募款目標
                                	int progress_percentage = 0;			//進度條%數
                                	
                                	/*--------------進度條計算------------------*/
                                	Vector<TableRecord> dhs = app_sm.selectAll(tbldh, 
                                			"dh_donate_project = ? AND dh_status = ? AND dh_collect = ?",
                                			new Object[]{cp_id, "Y", "Y"}
                                			);
                                	
                                	if(dhs.size()>0){
                                		numberOfDonate = dhs.size();
                                		
                                		//統計捐款總金額
                                		for(TableRecord dh_count : dhs){
                                			totalOfDonate += dh_count.getInt("dh_total");
                                			
                                		}
                                		if(totalOfDonate < donateGoal){
                                			progress_percentage = totalOfDonate*100 / donateGoal;
                                		}else{
                                			progress_percentage = 100;  //防止超過100
                                		}
                                		
                                		if (progress_percentage > 0 && progress_percentage < 3) {
                                			progress_percentage = 3; 									// 最小顯示 3%
                                		}
                                		progress_percentage = Math.min(progress_percentage, 100);
                                	}
                                	%>
                                <div class="fundraising_progress_section">
                                        <div class="wrap">
                                            <div class="progress_card">
                                                <div class="progress_info_header">
                                                    <h3 class="project_target_name">募款進度</h3>
                                                    <div class="donor_count">
                                                        <i class="bi bi-person-fill"></i>
<!--                                                         人數 -->
                                                        <span><%=numberOfDonate %></span>
                                                    </div>
                                                </div>

                                                <div class="progress_bar_row">
                                                    <div class="progress_track">
                                                        <div class="progress_fill" style="width: <%=progress_percentage %>%"></div>
                                                    </div>
<!--                                                     完成進度 -->
                                                    <div class="progress_percentage"><%=progress_percentage %>%</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <%} %>
                                
                            </div>

                            <!-- 線上捐款區塊 -->
                            <div id="about2" class="id_offset3"></div>
                            <div class="donateContent_bg">
                                <div class="wrap">
                                    <div class="right_title">
                                        <h2>線上捐款</h2>
                                        <!-- <span class="enTit">Donate Now</span> -->
                                    </div>
                                    
                                    
                                      
						<form name="form0" id="form0" method="post" action="donate_update.jsp?action=add" onsubmit="return checkform(this);">                        
<!--                         <form name="form0" id="form0" method="post" enctype="multipart/form-data" action="donate_update.jsp?action=add" onsubmit="return checkform(this);">                         -->
                        <input type="hidden" name="csrfToken" value="<%=csrfToken %>" />
                        <div class="right_contentBg">
            
                            <div class="form_remark">
                                <!--必填icon-->
                                <div class="requirde_icon">
                                    *
                                </div>
                                <span style="color:#c30000">
                                    請確認您的必填項目皆已完整填寫。
                                </span>
                            </div> 
                        
                            <div class="valuationBg">

                                <!-- 選擇捐款金額 -->
                                <div class="valuationArea">

                                    <!--內頁標題樣式4-->
                                    <div class="right_title4">
                                        <span>Step 1</span>
                                        <h2>選擇捐款金額</h2>
                                    </div>

                                    <!--表單區-->
                                    <div class="form_area contact_area">
                                    	
                                    	<input type="hidden" name="dh_donate_project" value="<%=cp.getString("cp_id")%>"/>
                                    	<input type="hidden" name="dh_donate_project_title" value="<%=cp.getString("cp_title")%>"/>
                                        
                                        
                                        <!--付款方式-->
                                        <div class="form_list"><!--一列兩個時class內加fLType2-->
                                            <div class="fL_tit">
                                                付款方式
                                                <span class="en">Donation method</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                            </div>
                                            <div class="fL_info donatePay_info">
                                            	<%for(TableRecord payment : payments){ %>
												 <div class="donatePayItem <%=payment.getString("cp_category").equals(default_values.get("dh_paymethod"))?"active":"" %>">
                                                    <input class="item_radio" type="radio" name="dh_paymethod" id="<%=payment.getString("cp_category") %>" value="<%=payment.getString("cp_category") %>" <%=payment.getString("cp_category").equals(default_values.get("dh_paymethod"))?"checked":"" %>>
                                                    <label class="" for="<%=payment.getString("cp_category") %>">                                                        
                                                        <img src="<%=app_fetchpath+"/"+"guide"+"/"+lang+"/"+payment.getString("cp_image")%>" alt="">
                                                        <h3><%=payment.getString("cp_title") %></h3>
                                                        <span class="en"><%=payment.getString("cp_name") %></span>
                                                    </label>
                                                </div>
                                                <%} %>
                                            </div>

                                            <!-- 付款方式說明文字區 -->
                                            <ul class="donatePay_text">

                                            	<%for(TableRecord payment : payments){ %>
                                                <li class="donatePay_text credit_card_one" id="<%=payment.getString("cp_category") %>_text">

                                                    <!--右側標題-->
                                                    <div class="right_title3">
                                                        <h2><%=payment.getString("cp_title") %></h2>
                                                    </div>

                                                    <!--簡述區塊-->
                                                    <section class="remark">
                                                       <%=payment.getString("cp_desc") %>
													</section>
													
                                                	<%if(payment.getString("cp_category").equals("pay.newebpay.regular")){ %>
                                                    <div class="form_list" id="regular_fields">
                                                        <!--一列兩個時class內加fLType2-->
                                                        <div class="fL_tit">
                                                            扣款到期日
                                                            <span class="en">Debit due date</span>
                                                            <!--必填icon-->
                                                            <div class="requirde_icon">
                                                                *
                                                            </div>
                                                        </div>
                                                        
                                                        <div class="fL_info item_RadioCheckArea debitDueDate">
                                                            
                                                            <label class="item_Radio_list">
                                                                <input type="radio" class="item_radio" name="dh_regular_type" value="Y" <%="Y".equals(default_values.get("dh_regular_type"))?"checked":"" %> />
                                                                <div class="custom-radio">
                                                                    <div class="inner-circle"></div>
                                                                </div>
                                                                <span class="radio-text">
                                                                    每年
                                                                </span>
                                                            </label>
                                                            <label class="item_Radio_list">
                                                                <input type="radio" class="item_radio" name="dh_regular_type" value="M" <%="M".equals(default_values.get("dh_regular_type"))?"checked":"" %> />
                                                                <div class="custom-radio">
                                                                    <div class="inner-circle"></div>
                                                                </div>
                                                                <span class="radio-text">
                                                                    每月
                                                                </span>
                                                            </label>
                                                            
                                                        </div>
                                                        
                                                        <div class="fL_info birthday">
                                                            自民國                                                                   
                                                			<select name="debit_start_year" id="debit_start_year">
																<option value="<%=DateTimeTool.getYear() %>">
							                                    	<%=DateTimeTool.getYear()-1911 %>
							                                    </option>
                                                            </select>
                                                			<span class="birthday_year">年</span>
                                                			<select name="debit_start_month" id="debit_start_month">
							                                    <option value="<%=df.format(DateTimeTool.getMonth()) %>">
							                                    	<%=df.format(DateTimeTool.getMonth()) %>
							                                    </option>
                                                            </select>
                                                            <span class="birthday_month">月，至民國</span>
                                                			<select name="dh_debit_due_year" id="dh_debit_due_year">
                                                                <option value="" <%="".equals(default_values.get("dh_debit_due_year"))?"selected":"" %>>
                                                                    請選擇
                                                                </option>
				                                    			<%for(int i=DateTimeTool.getYear();i<=2099;i++){ %>   
																<option value="<%=i %>" <%=String.valueOf(i).equals(default_values.get("dh_debit_due_year"))?"selected":"" %>>
							                                    	<%=i-1911 %>
							                                    </option>
																<%} %>
                                                            </select>
                                                            <span>年</span>                                                           
                                                			<select name="dh_debit_due_month" id="dh_debit_due_month">
                                                    			<option value="" <%="".equals(default_values.get("dh_debit_due_month"))?"selected":"" %>>
                                                                    請選擇
                                                                </option>
							                                    <%for(int i=1;i<=12;i++){
																	String teos = df.format(i);
																%>
																<option value="<%=teos %>" <%=df.format(i).equals(default_values.get("dh_debit_due_month"))?"selected":"" %>>
							                                    	<%=teos %>
							                                    </option>
																<%} %>                                            
                                                			</select>
                                                            <span class="birthday_month">月</span>
                                                        </div>
                                                    </div>
                                                <%} %>
                                                </li>
                                                <%}%>
                                            </ul>
                                        </div> 
                                        
                                        <!-- 幣別 -->
                                            <div class="form_list">
                                                <div class="fL_tit">
                                                    幣別
                                                    <span class="en">Currency</span>
                                                    <div class="requirde_icon">*</div>
                                                </div>
                                                <div class="fL_info item_RadioCheckArea currency_info">
                                                    <label class="item_Radio_list">
                                                        <input
                                                            type="radio"
                                                            class="item_radio"
                                                            name="dh_currency"
                                                            value="TWD"
                                                            <%="TWD".equals(default_values.get("dh_currency"))?"checked":"" %>
                                                        />
                                                        <div class="custom-radio">
                                                            <div class="inner-circle"></div>
                                                        </div>
                                                        <span class="radio-text">台幣</span>
                                                    </label>

                                                    <label class="item_Radio_list">
                                                        <input
                                                            type="radio"
                                                            class="item_radio"
                                                            name="dh_currency"
                                                            value="other"
                                                            id="currency_other_radio"
                                                            <%="other".equals(default_values.get("dh_currency"))?"checked":"" %>
                                                        />
                                                        <div class="custom-radio">
                                                            <div class="inner-circle"></div>
                                                        </div>
                                                        <span class="radio-text">其他</span>
                                                    </label>

                                                    <input
                                                        type="text"
                                                        class="info_other"
                                                        id="currency_other_input"
                                                        name="dh_currency_other"
                                                        placeholder="請輸入幣別代碼"
                                                        maxlength="3"
                                                        style="display: none; width: 150px; margin-left: 10px"
                                                        value="<%=default_values.get("dh_currency_other") %>"
                                                    />
                                                </div>
                                            </div>
                                    	<!--捐贈金額-->
	                                    <div class="form_list">
	                                        <div class="fL_tit">
	                                            捐贈金額
	                                            <span class="en">Donation Amount</span><!-- modify by david 20220913  -->
	                                            <!--必填icon-->
	                                            <div class="requirde_icon">
	                                                *
	                                            </div> 
	                                        </div> 
	                                        <div class="fL_info donateAmount_info">
												<div class="donateAmountItem <%="1000".equals(default_values.get("dh_total"))?"active":"" %>">
	                                                <input class="item_radio" type="radio" name="donate_amount" id="d_a4" value="1000" <%="1000".equals(default_values.get("dh_total"))?"checked":"" %>>
	                                                <label class="" for="d_a4">
	                                                    1000
	                                                </label>
	                                            </div>
	                                            
	                                            <div class="donateAmountItem <%="5000".equals(default_values.get("dh_total"))?"active":"" %>">
	                                                <input class="item_radio" type="radio" name="donate_amount" id="d_a1" value="5000" <%="5000".equals(default_values.get("dh_total"))?"checked":"" %>>
	                                                <label class="" for="d_a1">
	                                                    5000
	                                                </label>
	                                            </div>
	                                            
	                                            <div class="donateAmountItem <%="10000".equals(default_values.get("dh_total"))?"active":"" %>">
	                                                <input class="item_radio" type="radio" name="donate_amount" id="d_a2" value="10000" <%="10000".equals(default_values.get("dh_total"))?"active":"" %>>
	                                                <label class="" for="d_a2">
	                                                    10000
	                                                </label>
	                                            </div>
	                                            
	                                            <div class="donateAmountItem <%="30000".equals(default_values.get("dh_total"))?"active":"" %>">
	                                                <input class="item_radio" type="radio" name="donate_amount" id="d_a3" value="30000" <%="30000".equals(default_values.get("dh_total"))?"active":"" %>>
	                                                <label class="" for="d_a3">
	                                                    30000
	                                                </label>
	                                            </div>
	                                            
	                                            <div class="donateAmountItem">
	                                                <input class="item_radio d_a_other" type="radio" name="donate_amount" id="d_a_other" value="">
	                                                <label class="" for="d_a_other">
	                                                    其他金額
	                                                </label>
	                                                <input type="text" name="dh_total" id="dh_total" placeholder="請自行輸入金額" value="<%=default_values.get("dh_total") %>" class="otherAmount"/>
	                                            </div>
	                                        </div>
	                                    </div>
                                        
                                        <!--捐款用途備註說明-->
                                        <div class="form_list deptFund" id="deptFundMemo"><!--一列兩個時class內加fLType2-->
                                            <div class="fL_tit">
                                                捐款用途備註說明 
                                                <span class="en"> Donation Purpose Remark</span>
                                            </div>
                                            
                                            <div class="fL_info">
					                          	<input type="text" name="dh_remark" id="dh_remark" value="<%=default_values.get("dh_remark") %>" />
					                        </div>
                                        </div> 
                                	</div> 

                                </div>

                                
                                <!-- 輸入基本資料 -->
                                <div class="valuationArea">

                                    <!--內頁標題樣式4-->
                                    <div class="right_title4">
                                        <span>Step 2</span>
                                        <h2>輸入基本資料</h2>
                                    </div>

                                    <!--表單區-->
                                    <div class="form_area contact_area">
                                        
                                        
                                        
                                        <!-- 身份別  -->
                                            <div class="form_list">
                                                <!--一列兩個時class內加fLType2-->
                                                <div class="fL_tit">
                                                    身份別
                                                    <span class="en">Identity</span>
                                                    <!--必填icon-->
                                                    <div class="requirde_icon">*</div>
                                                    <!--未登入時顯示-->
                                                    <!-- <label class="cBT_checkbox">
                                                    <input type="checkbox" class="toggle_password_checkbox">                                                    
                                                </label> -->
                                                </div>
                                                <!-- 單選radio和複選Check父層樣式 -->
                                                <!-- 附加item_RadioCheckColumnIn為內部垂直 -->
                                                <div class="fL_info item_RadioCheckArea">
                                                    <label class="item_Radio_list">
                                                        <input type="radio" class="item_radio" name="dh_identity_type" value="enterprise" <%="enterprise".equals(default_values.get("dh_identity_type"))?"checked":"" %>/>
                                                        <div class="custom-radio">
                                                            <div class="inner-circle"></div>
                                                        </div>
                                                        <span class="radio-text">企業</span>
                                                    </label>

                                                    <label class="item_Radio_list">
                                                        <input type="radio" class="item_radio" name="dh_identity_type" value="native" <%="native".equals(default_values.get("dh_identity_type"))?"checked":"" %> />
                                                        <div class="custom-radio">
                                                            <div class="inner-circle"></div>
                                                        </div>
                                                        <span class="radio-text">本國人</span>
                                                    </label>
                                                    <label class="item_Radio_list">
                                                        <input type="radio" class="item_radio" name="dh_identity_type" value="foreigner" <%="foreigner".equals(default_values.get("dh_identity_type"))?"checked":"" %>/>
                                                        <div class="custom-radio">
                                                            <div class="inner-circle"></div>
                                                        </div>
                                                        <span class="radio-text">外國人</span>
                                                    </label>
                                                </div>
                                            </div>
                                       
                                        <!--捐款人-->
                                        <div class="form_list">
                                            <div class="fL_tit">
                                                姓名/機構名稱
                                                <span class="en">Name</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                            </div>
                                            <div class="fL_info">
                                                <input type="text" name="dh_name" id="dh_name" placeholder="姓名/機構名稱"  value="<%=default_values.get("dh_name") %>"/>
                                            </div>
                                        </div>                                      
 										<!--捐款人-->
                                        <div class="form_list">
                                            <div class="fL_tit">
                                                身分證字號/統一編號/居留證或護照
                                                <span class="en">ID number</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                            </div>
                                            <div class="fL_info">
                                                <input type="text" name="dh_pid" id="dh_pid" placeholder="" value="<%=default_values.get("dh_pid") %>"/>
                                            </div>
                                        </div>    
                                        <!--行動電話-->                                   
                                        <div class="form_list fLType2 cellphone">
                                            <div class="fL_tit">
                                                聯絡電話
                                                <span class="en">Cellphone</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div>
                                            </div>
                                            <div class="fL_info">
                                                <input type="tel" name="dh_cellphone" id="dh_cellphone" placeholder="" value="<%=default_values.get("dh_cellphone") %>"/>
                                            </div>
                                        </div> 
                                        <div class="form_list fLType2 telephone">
                                            <div class="fL_tit">                                                
                                                電話
                                                <span class="en">Telephone</span>
                                            </div>
                                            <div class="fL_info">
                                                <input type="tel" name="dh_phone" id="dh_phone" placeholder="" value="<%=default_values.get("dh_phone") %>"/>
                                            </div>
                                        </div> 
                                        
                                       
                                        <!--通訊地址-->
                                        <div class="form_list">
                                            <div class="fL_tit">
                                                通訊地址
                                                <span class="en">Correspondence address</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                            </div>
                                            
                                            <div class="fL_info item_RadioCheckArea correspondenceAddress">
                                                
                                                <label class="item_Radio_list">
                                                    <input type="radio" class="item_radio" name="dh_foreign" value="N" <%="N".equals(default_values.get("dh_foreign"))?"checked":"" %> />
                                                    <div class="custom-radio">
                                                        <div class="inner-circle"></div>
                                                    </div>
                                                    <span class="radio-text">
                                                        國內
                                                    </span>
                                                </label>

                                                <label class="item_Radio_list">
                                                    <input type="radio" class="item_radio" name="dh_foreign" value="Y" <%="Y".equals(default_values.get("dh_foreign"))?"checked":"" %> />
                                                    <div class="custom-radio">
                                                        <div class="inner-circle"></div>
                                                    </div>
                                                    <span class="radio-text">
                                                        國外
                                                    </span>
                                                </label>
                                            </div>
                                            
                                            <div class="fL_info fLR_address">
						                        <input type="hidden" id="county" name="county" value="<%=default_values.get("dh_county") %>">
						                        <input type="hidden" id="city" name="city" value="<%=default_values.get("dh_city") %>">     
						                        <select name="dh_county" id="dh_county" onchange="changeZone(form0.dh_county, form0.dh_city, form0.dh_zipcode, form0.county, form0.city)"></select>
						                        <select name="dh_city" id="dh_city" onchange="showZipCode(form0.dh_county, form0.dh_city, form0.dh_zipcode, form0.county, form0.city)"></select>
                                                <input type="text" name="dh_zipcode" id="dh_zipcode" class="fLRA_postalCode" readonly="" value="<%=default_values.get("dh_zipcode") %>">
                                                <input type="text" name="dh_address" id="dh_address" class="address fLRA_address" placeholder="" value="<%=default_values.get("dh_address") %>">
                                            </div>                                           
                                        </div> 	
                                        <script> ResetAll(form0.dh_county, form0.dh_city, form0.dh_zipcode, form0.county, form0.city); </script>
                                        
                                        <!--電子郵件-->                                
                                        <div class="form_list">
                                            <div class="fL_tit">
                                                電子信箱
                                                <span class="en">E-mail</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div>
                                            </div>
                                            <div class="fL_info">
                                            <input type="email" name="dh_email" id="dh_email" value="<%=default_values.get("dh_email") %>"/>
                                            </div>
                                        </div> 

                                        <!-- 贈與身分  -->
                                        <div class="form_list"><!--一列兩個時class內加fLType2-->
                                            <div class="fL_tit">
                                                身分
                                                <span class="en">Identity</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                            </div>                                            
                                            <div class="fL_info item_RadioCheckArea">
                                            	<label class="item_Radio_list">
                                                    <input type="radio" class="item_radio" name="dh_identity" id="gi1"  value="1" <%="1".equals(default_values.get("dh_identity"))?"checked":"" %>/>
                                                    <div class="custom-radio">
                                                        <div class="inner-circle"></div>
                                                    </div>
                                                    <span class="radio-text other">靜宜校友，民國
                                                    <input type="text" name="dh_identity_year" id="dh_identity_year" value="<%=default_values.get("dh_identity_year") %>"/>年
                                                    <input type="text" name="dh_identity_dept" id="dh_identity_dept" value="<%=default_values.get("dh_identity_dept") %>"/>系/所/班 畢(結)業</span>
                                                </label>
                                            	<label class="item_Radio_list">
                                                    <input class="item_radio" type="radio" name="dh_identity" id="gi2" value="2" <%="2".equals(default_values.get("dh_identity"))?"checked":"" %>>
                                                    <div class="custom-radio">
                                                        <div class="inner-circle"></div>
                                                    </div>
                                                    <span class="radio-text">靜宜教職員</span>
                                                </label>
                                            	<label class="item_Radio_list">
                                                    <input class="item_radio" type="radio" name="dh_identity" id="gi3" value="3" <%="3".equals(default_values.get("dh_identity"))?"checked":"" %>>
                                                    <div class="custom-radio">
                                                        <div class="inner-circle"></div>
                                                    </div>
                                                    <span class="radio-text">
                                                        學生/家長
                                                    </span>
                                                </label>
                                            	<label class="item_Radio_list">
                                                    <input class="item_radio" type="radio" name="dh_identity" id="gi4" value="4" <%="4".equals(default_values.get("dh_identity"))?"checked":"" %>>
                                                    <div class="custom-radio">
                                                        <div class="inner-circle"></div>
                                                    </div>
                                                    <span class="radio-text">
                                                        企業機構
                                                    </span>
                                                </label>
                                            	<label class="item_Radio_list">
                                                    <input class="item_radio" type="radio" name="dh_identity" id="gi5" value="5" <%="5".equals(default_values.get("dh_identity"))?"checked":"" %>>
                                                    <div class="custom-radio">
                                                        <div class="inner-circle"></div>
                                                    </div>
                                                    <span class="radio-text">
                                                        社會人士
                                                    </span>
                                                </label>
                                            </div>
                                        </div> 
                                       
                                        <!--服務單位-->
                                        <div class="form_list fLType2">
                                            <div class="fL_tit">
                                                服務單位
                                                <span class="en">Employer</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <!-- <div class="requirde_icon">
                                                    *
                                                </div> --> 
                                            </div>
                                            <div class="fL_info">
                                                <input type="text" name="dh_unit" id="dh_unit" placeholder="" value="<%=default_values.get("dh_unit") %>"/>
                                            </div>
                                        </div>  
                                       
                                        <!--職稱-->
                                        <div class="form_list fLType2">
                                            <div class="fL_tit">
                                                職稱
                                                <span class="en">Job title</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <!-- <div class="requirde_icon">
                                                    *
                                                </div> --> 
                                            </div>
                                            <div class="fL_info">
                                                <input type="text" name="dh_job" id="dh_job" placeholder="" value="<%=default_values.get("dh_job") %>"/>
                                            </div>
                                        </div>  
                                        	
                                        <!-- 收據  -->
                                        <div class="form_list"><!--一列兩個時class內加fLType2-->
                                            <div class="fL_tit">
                                                收據
                                                <span class="en">Receipt</span>
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                            </div>  
                                            <!-- 單選radio和複選Check父層樣式 -->
                                            <!-- 附加item_RadioCheckColumnIn為內部垂直 -->
                                            <div class="fL_info item_RadioCheckArea ">
                                                
                                                <label class="item_Radio_list">
                                                    <input type="radio" class="item_radio" name="dh_receipt_status" value="N" <%="N".equals(default_values.get("dh_receipt_status"))?"checked":"" %>  />
                                                    <div class="custom-radio">
                                                        <div class="inner-circle"></div>
                                                    </div>
                                                    <span class="radio-text">不寄收據</span>
                                                </label>

                                                <label class="item_Radio_list">
                                                    <input type="radio" class="item_radio" name="dh_receipt_status"  value="Y"  <%="Y".equals(default_values.get("dh_receipt_status"))?"checked":"" %>/>
                                                    <div class="custom-radio">
                                                        <div class="inner-circle"></div>
                                                    </div>
                                                    <span class="radio-text">
                                                        寄收據
                                                    </span>
                                                </label>

                                            </div>

                                        </div> 
                                        
                                        <!--收據抬頭名稱-->
                                        <div class="form_list"  id="receiptName" style="display: none;">
                                            <div class="fL_tit">
                                                收據抬頭名稱
                                                <span class="en">Name on receipt</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                                <label class="cBT_checkbox"><!--未登入時顯示-->
                                                    <input type="checkbox" class="toggle_password_checkbox" id="same_name" name="dh_same_name" value="Y" <%="Y".equals(default_values.get("dh_same_name"))?"checked":"" %>>
                                                    同捐款人<span class="en">The same as ”Name”</span><!-- modify by david 20220913  -->(捐款可100%自個人當年度綜合所得/企業營利所得總額中扣除。)
                                                </label>
                                            </div>
                                            <div class="fL_info">
                                                <input type="text" name="dh_receipt_title" id="dh_receipt_title" placeholder="" value="<%=default_values.get("dh_receipt_title") %>"/>
                                            </div>
                                        </div>  

                                        <!--收據寄送地址-->
                                        <div class="form_list" id="receiptAddr" style="display: none;">
                                            <div class="fL_tit">
                                                收據寄送地址
                                                <span class="en">Receiver’s address</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                                <label class="cBT_checkbox"><!--未登入時顯示-->
                                                    <input type="checkbox" class="toggle_password_checkbox" id="same_address" name="dh_same_address" value="Y" <%="Y".equals(default_values.get("dh_same_address"))?"checked":"" %>>
                                                    同通訊地址
                                                    <span class="en">The same as “Correspondence address”</span><!-- modify by david 20220913  -->
                                                </label>
                                                <div class="fL_info fLR_address">
							                        <input type="hidden" id="receipt_county" name="receipt_county" value="<%=default_values.get("dh_receipt_county") %>">
							                        <input type="hidden" id="receipt_city" name="receipt_city" value="<%=default_values.get("dh_receipt_city") %>">     
							                        <select name="dh_receipt_county" id="dh_receipt_county" onchange="changeZone(form0.dh_receipt_county, form0.dh_receipt_city, form0.dh_receipt_zipcode, form0.receipt_county, form0.receipt_city)"></select>
							                        <select name="dh_receipt_city" id="dh_receipt_city" onchange="showZipCode(form0.dh_receipt_county, form0.dh_receipt_city, form0.dh_receipt_zipcode, form0.receipt_county, form0.receipt_city)"></select>
	                                                <input type="text" name="dh_receipt_zipcode" id="dh_receipt_zipcode" class="fLRA_postalCode" readonly="" value="<%=default_values.get("dh_receipt_zipcode") %>">
	                                                <input type="text" name="dh_receipt_address" id="dh_receipt_address" class="address fLRA_address" placeholder="" value="<%=default_values.get("dh_receipt_address") %>">	                                                
                                            	</div>
                                            </div>
                                        </div> 
                                        <script> ResetAll(form0.dh_receipt_county, form0.dh_receipt_city, form0.dh_receipt_zipcode, form0.receipt_county, form0.receipt_city); </script>
                                        
                                        <!--是否公開-->
                                        <div class="form_list"><!--一列兩個時class內加fLType2-->
                                            <div class="fL_tit">
                                                是否公開
                                                <span class="en">Donor Disclosure Agreement</span><!-- modify by david 20220913  -->
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div> 
                                                <span class="notice">
                                                    *姓名、身份、捐款金額刊登於本校網站或刊物，以為公開徵信之用。
                                                    <span class="en "> I agree to have my name and donation listed on relevant NTOU websites or in publications.</span>
                                                </span>
                                            </div>
                                            <div class="fL_info item_RadioCheckArea">
                                                <label class="item_Radio_list">
                                                    <input class="item_radio" type="radio" name="dh_public" id="yes_public" value="Y" <%="Y".equals(default_values.get("dh_public"))?"checked":"" %>>
                                                    <div class="custom-radio">
                                                        <div class="inner-circle"></div>
                                                    </div>
                                                    <span class="radio-text">
                                                        <!-- 全名公開徵信 -->
                                                        公開
                                                    </span>
                                                </label>
                                                <label class="item_Radio_list">
                                                    <input class="item_radio" type="radio" name="dh_public" id="no_public" value="N" <%="N".equals(default_values.get("dh_public"))?"checked":"" %>>
                                                    <div class="custom-radio">
                                                        <div class="inner-circle"></div>
                                                    </div>
                                                    <span class="radio-text">
                                                        <!-- 全名公開徵信 -->
                                                        不公開（統一以「靜宜之友」公告）
                                                    </span>
                                                </label>
                                            </div>
                                        </div> 
<!--   										<div class="form_list" id="tax_upload">一列兩個時class內加fLType2 -->
<!--                                             <div class="fL_tit"> -->
<!--                                                 上傳稅務機關 -->
<!--                                                 <span class="en">Upload to Tax Authority </span> -->
<!--                                                 必填icon -->
<!--                                                 <div class="requirde_icon"> -->
<!--                                                     * -->
<!--                                                 </div>  -->
<!--                                                 <span class="notice"> -->
<!--                                                     *是否提供給稅務稽徵機關作為當年度綜合所得稅捐贈資料之歸戶作業。 -->
<!--                                                     <span class="en ">The donation information is provided to tax authorities for the current year's income tax return.</span> -->
<!--                                                 </span> -->
<!--                                                 <span class="notice"> -->
<!--                                                     *公司行號/法人/一般團體(不提供上傳至稅務機關服務)。 -->
<!--                                                     <span class="en "> -->
<!--                                                         Does not provide assistance to Company/Legal Person/Organization for uploading to tax authorities. -->
<!--                                                     </span> -->
<!--                                                 </span> -->
<!--                                                 <span class="notice"> -->
<!--                                                     *捐款可100％自個人當年度綜合所得/企業營利所得總額中扣除。 -->
<!--                                                     <span class="en "> -->
<!--                                                         Donations can be 100% deducted from your total income or corporate profits for the current year. -->
<!--                                                     </span> -->
<!--                                                 </span> -->
<!--                                             </div>   -->
<!--                                             單選radio和複選Check父層樣式 -->
<!--                                             附加item_RadioCheckColumnIn為內部垂直 -->
<!--                                             <div class="fL_info item_RadioCheckArea "> -->
                                                
<!--                                                 <label class="item_Radio_list"> -->
<%--                                                     <input class="item_radio" type="radio" name="dh_tax" id="yes_tax" value="Y" <%="Y".equals(default_values.get("dh_tax"))?"checked":"" %>> --%>
<!--                                                     <div class="custom-radio"> -->
<!--                                                         <div class="inner-circle"></div> -->
<!--                                                     </div> -->
<!--                                                     <span class="radio-text"> -->
<!--                                                         協助上傳國稅局 -->
<!--                                                         上傳 -->
<!--                                                     </span> -->
<!--                                                 </label> -->

<!--                                                 <label class="item_Radio_list"> -->
<%--                                                     <input class="item_radio" type="radio" name="dh_tax" id="no_tax" value="N" <%="N".equals(default_values.get("dh_tax"))?"checked":"" %>> --%>
<!--                                                     <div class="custom-radio"> -->
<!--                                                         <div class="inner-circle"></div> -->
<!--                                                     </div> -->
<!--                                                     <span class="radio-text"> -->
<!--                                                         不需上傳國稅局 -->
<!--                                                         不上傳 -->
<!--                                                     </span> -->
<!--                                                 </label> -->
                                                
<!--                                             </div> -->

<!--                                         </div>  -->
                                        <!--驗證碼-->
                                        <div class="form_list">
                                            <div class="fL_tit">
                                                驗證碼
                                                <!--必填icon-->
                                                <div class="requirde_icon">
                                                    *
                                                </div>
                                            </div>
                                            <div class="fL_info captcha no_border">
                                                <input type="text" name="ind" id="ind"/>
                                                <img src="../../comm/image.jsp"  name="randImage" id="randImage" width="72" height="27" />
                                                
                                                <a href="javascript:loadimage();">
                                                    重取驗證碼
                                                </a>
                                                <span>
                                                    (請注意英文字母大小寫！)
                                                </span>
                                            </div>
                                        </div>

                                    </div>

                                </div>
                                
                            </div>

                            <!--同意書區塊_按鈕區-->
                            <div class="agreeToTerms agree">

                                <div class="agreeList">                        
                                    <input type="checkbox" class="" id="agree" placeholder="">
                                    <label for="agree" class="">我已詳閱、同意接受<a href="../privacy/privacy.jsp" target="_blank">《個人資料事項告知暨使用同意書》</a></label>
                                </div>

                            </div>   

                            <!--表單區 按鍵區-->
                            <div class="btn_area one disAbled">
                                <input type="submit" value="確認送出" >
                                <div class="clearfloat">
                                </div>
                            </div>

                            <!--同意書_按鈕區.js-->
                            <script type="text/javascript">
                            
                                $(function(){

                                    $("#agree").attr("checked",false);
                                    $(".btn_area input").attr("disabled", true);

                                    $('#agree').on('change', function () {  // 當checkbox框有變動(change/勾選或取消勾選)時
                                        $(".btn_area").toggleClass("disAbled")
                                        $(".btn_area input").attr("disabled", false);
                                    })
                                });
                            </script>
                            <!-- 幣別.js -->
                <script type="text/javascript">
                    $(function () {
                        // 1. 控制輸入框顯示/隱藏
                        $('input[name="dh_currency"]').change(function () {
                            var inputField = $("#currency_other_input");

                            if ($(this).val() === "other") {
                                inputField.show(); // 顯示輸入框
                                inputField.focus(); // 自動聚焦
                            } else {
                                inputField.hide(); // 隱藏輸入框
                                inputField.val(""); // 清空內容
                            }
                        });

                        // 2. 限制只能輸入英文 (自動轉大寫，過濾非英文字元)
                        $("#currency_other_input").on("input", function () {
                            var val = $(this).val();
                            // 使用正規表達式將非英文字母替換為空字串
                            var filtered = val.replace(/[^a-zA-Z]/g, "");

                            // 如果有變更 (例如轉大寫或刪除非英文)，則更新欄位值
                            if (val !== filtered.toUpperCase()) {
                                $(this).val(filtered.toUpperCase());
                            }
                        });
                    });
                </script>
                        </div>
                    	</form>    
                    
                                    
                                    
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 幣別.js -->
                    <script type="text/javascript">
                        $(function () {
                            // 1. 控制輸入框顯示/隱藏
                            $('input[name="currency_type"]').change(function () {
                                var inputField = $("#currency_other_input");

                                if ($(this).val() === "other") {
                                    inputField.show(); // 顯示輸入框
                                    inputField.focus(); // 自動聚焦
                                } else {
                                    inputField.hide(); // 隱藏輸入框
                                    inputField.val(""); // 清空內容
                                }
                            });

                            // 2. 限制只能輸入英文 (自動轉大寫，過濾非英文字元)
                            $("#currency_other_input").on("input", function () {
                                var val = $(this).val();
                                // 使用正規表達式將非英文字母替換為空字串
                                var filtered = val.replace(/[^a-zA-Z]/g, "");

                                // 如果有變更 (例如轉大寫或刪除非英文)，則更新欄位值
                                if (val !== filtered.toUpperCase()) {
                                    $(this).val(filtered.toUpperCase());
                                }
                            });
                        });
                    </script>
                    <!--捐贈類別.js-->
                    <script type="text/javascript">
                        $(function () {
                            $(".donateCategoryItem input.item_radio:radio").change(function () {
                                //當checkbox框有變動(change/勾選或取消勾選)時

                                if (this.checked) {
                                    $(".donateCategoryItem input.item_radio:radio")
                                        .not(this)
                                        .parent()
                                        .siblings()
                                        .removeClass("active");
                                    $(".donateCategoryItem input.item_radio:radio")
                                        .not(this)
                                        .parent()
                                        .siblings()
                                        .children()
                                        .attr("checked", false);
                                    $(this).parent().toggleClass("active");
                                    $(this).attr("checked", true);
                                } else {
                                    $(this).parent().removeClass("active");
                                    $(this).attr("checked", false);
                                }
                            });
                        });
                    </script>

                    <!--指定捐贈用途.js  20250610-->
                    <script type="text/javascript">
                        $(function () {
                            $(".donationPurpose_info select#donateUse").change(function () {
                                //當checkbox框有變動(change/勾選或取消勾選)時

                                if (this.value === "其他") {
                                    //console.log("選到了");
                                    $("#donateUse").siblings(".info_other").show(0); //打開
                                    //$(".donationPurpose_info .info_other").show(0);   //打開
                                } else {
                                    //console.log("沒選到");
                                    //$(".donationPurpose_info .info_other").hide(0);   //關閉
                                    $("#donateUse").siblings(".info_other").hide(0); //關閉
                                }
                            });
                        });
                    </script>

                    <!--請選擇計畫名稱_其他.js 20250610-->
                    <script type="text/javascript">
                        $(function () {
                            $(".donationPurpose_info select#donateProjName").change(function () {
                                //當checkbox框有變動(change/勾選或取消勾選)時

                                if (this.value === "其他") {
                                    //console.log("選到了2");
                                    $("#donateProjName").siblings(".info_other").css({
                                        "grid-column": "1 / 4",
                                        display: "grid",
                                    });
                                    //$(".donationPurpose_info .info_other").show(0);   //打開
                                } else {
                                    //console.log("沒選到2");
                                    $("#donateProjName").siblings(".info_other").hide(0); //關閉
                                }
                            });
                        });
                    </script>

                    <!--捐贈金額.js-->
                    <script type="text/javascript">
                        $(function () {
                            $(".donateAmount_info input.item_radio:radio").change(function () {
                                //當checkbox框有變動(change/勾選或取消勾選)時
                                if (this.checked) {
                                    $(".donateAmountItem input.item_radio:radio")
                                        .not(this)
                                        .parent()
                                        .siblings()
                                        .removeClass("active");
                                    $(".donateAmountItem input.item_radio:radio")
                                        .not(this)
                                        .parent()
                                        .siblings()
                                        .children()
                                        .attr("checked", false);
                                    $(this).parent().toggleClass("active");
                                    $(this).attr("checked", true);
                                } else {
                                    $(this).parent().removeClass("active");
                                    $(this).attr("checked", false);
                                }
                            });
                        });
                    </script>

                    <!--付款方式和付款方式的說明文字切換.js-->
                    <script type="text/javascript">
                        $(function () {
                            // 預先隱藏所有付款方式說明
                            const payTextItems = document.querySelectorAll(".donatePay_text .donatePay_text_item");
                            payTextItems.forEach((item) => {
                                item.style.display = "none";
                            });

                            // 切換付款方式後要執行的動作
                            function donateChoose(selectedId) {
                                // 再次隱藏全部（避免未點選前其他預設顯示）
                                payTextItems.forEach((item) => {
                                    item.style.display = "none";
                                });

                                // 根據 radio id 顯示對應說明區塊
                                if (selectedId === "credit_card_one") {
                                    //信用卡(單筆)
                                    document.getElementById("paymentCardOne").style.display = "flex"; //為了垂直的樣式
                                } else if (selectedId === "credit_card") {
                                    //信用卡(定期定額 )
                                    document.getElementById("dueDate").style.display = "flex";
                                } else if (selectedId === "online_account") {
                                    //虛擬帳號
                                    document.getElementById("online_account_text").style.display = "flex";
                                } else if (selectedId === "bank_wire_transfer") {
                                    //銀行匯款
                                    document.getElementById("bankCntr").style.display = "flex";
                                } else if (selectedId === "postal_transfer") {
                                    //郵政劃撥
                                    document.getElementById("postalTransfer_text").style.display = "flex";
                                } else if (selectedId === "cash") {
                                    //現金
                                    document.getElementById("cash_text").style.display = "flex";
                                } else if (selectedId === "cheque") {
                                    //支票
                                    document.getElementById("cheque_text").style.display = "flex";
                                }
                            }

                            $(".donatePayItem input.item_radio:radio").change(function () {
                                //當checkbox框有變動(change/勾選或取消勾選)時

                                if (this.checked) {
                                    $(".donatePayItem input.item_radio:radio")
                                        .not(this)
                                        .parent()
                                        .siblings()
                                        .removeClass("active");
                                    $(".donatePayItem input.item_radio:radio")
                                        .not(this)
                                        .parent()
                                        .siblings()
                                        .children()
                                        .attr("checked", false);
                                    $(this).parent().toggleClass("active");
                                    $(this).attr("checked", true);

                                    //console.log("目前選擇的是：", this.id);
                                    donateChoose(this.id); // 把 id 傳入 donateChoose()
                                } else {
                                    $(this).parent().removeClass("active");
                                    $(this).attr("checked", false);
                                }
                            });
                        });
                    </script>

                    <!--收據.js-->
                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            const radios = document.querySelectorAll('input[name="send_receipt"]');
                            const receiptName = document.getElementById("receiptName");
                            const receiptAddr = document.getElementById("receiptAddr");

                            function toggleReceiptFields() {
                                const selectedValue = document.querySelector(
                                    'input[name="send_receipt"]:checked'
                                ).value;
                                if (selectedValue === "yes") {
                                    receiptName.style.display = "block";
                                    receiptAddr.style.display = "block";
                                } else {
                                    receiptName.style.display = "none";
                                    receiptAddr.style.display = "none";
                                }
                            }

                            radios.forEach((radio) => {
                                radio.addEventListener("change", toggleReceiptFields);
                            });

                            // 預設初始化一次
                            toggleReceiptFields();
                        });
                    </script>

                    <!--扣款到期日 每年 或 每月 單選框.js  20250619-->
                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            const radiosDebitDueDate = document.querySelectorAll('input[name="yrly_mnth"]'); //國內+國外radio
                            const yrly = document.getElementById("yrly"); // 每年 填寫欄位
                            const mnth = document.getElementById("mnth"); // 每月 填寫欄位

                            function toggleDebitDueDate(value) {
                                if (value === "每月") {
                                    mnth.style.display = "flex";
                                    yrly.style.display = "none";
                                } else if (value === "每年") {
                                    mnth.style.display = "none";
                                    yrly.style.display = "flex";
                                }
                            }

                            // 初始化設定（根據 checked 的值）
                            //一開始頁面載入後，就根據目前 checked 的選項，去做初次顯示切換
                            const checkedDebitDueDate = document.querySelector('input[name="yrly_mnth"]:checked');
                            if (checkedDebitDueDate) {
                                //如果找到了有被選中的 radio（不是 null），才執行後面的動作
                                toggleDebitDueDate(checkedDebitDueDate.value);
                            }

                            // 綁定事件監聽
                            radiosDebitDueDate.forEach(function (radio) {
                                radio.addEventListener("change", function () {
                                    toggleDebitDueDate(this.value);
                                });
                            });
                        });
                    </script>

                    <!--國內 或 國外 地址 單選框.js  20250619-->
                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            const radiosAddress = document.querySelectorAll('input[name="domestic_international"]'); //國內+國外radio
                            const domesticArea = document.getElementById("addressDomestic"); //國內地址填寫欄位
                            const internationalArea = document.getElementById("addressInternational"); //國外地址填寫欄位

                            function toggleAddressFields(value) {
                                if (value === "國內") {
                                    domesticArea.style.display = "grid";
                                    internationalArea.style.display = "none";
                                } else if (value === "國外") {
                                    domesticArea.style.display = "none";
                                    internationalArea.style.display = "block";
                                }
                            }

                            // 初始化設定（根據 checked 的值）
                            const checkedRadioAddress = document.querySelector(
                                'input[name="domestic_international"]:checked'
                            );
                            if (checkedRadioAddress) {
                                toggleAddressFields(checkedRadioAddress.value);
                            }

                            // 綁定事件監聽
                            radiosAddress.forEach(function (radio) {
                                radio.addEventListener("change", function () {
                                    toggleAddressFields(this.value);
                                });
                            });
                        });
                    </script>
                    
                    <!-- 幣別.js -->
                <script type="text/javascript">
                    $(function () {
                        // 1. 控制輸入框顯示/隱藏
                        $('input[name="dh_currency"]').change(function () {
                            var inputField = $("#currency_other_input");

                            if ($(this).val() === "other") {
                                inputField.show(); // 顯示輸入框
                                inputField.focus(); // 自動聚焦
                            } else {
                                inputField.hide(); // 隱藏輸入框
                                inputField.val(""); // 清空內容
                            }
                        });

                        // 2. 限制只能輸入英文 (自動轉大寫，過濾非英文字元)
                        $("#currency_other_input").on("input", function () {
                            var val = $(this).val();
                            // 使用正規表達式將非英文字母替換為空字串
                            var filtered = val.replace(/[^a-zA-Z]/g, "");

                            // 如果有變更 (例如轉大寫或刪除非英文)，則更新欄位值
                            if (val !== filtered.toUpperCase()) {
                                $(this).val(filtered.toUpperCase());
                            }
                        });
                    });
                </script>
                <!-- 20260330新增 當點選現金or支票時，下方幣別的其他選項才會顯示 start  -->
                <script>
                    document.addEventListener("DOMContentLoaded", function () {
                        const payRadios = document.querySelectorAll('input[name="dh_paymethod"]');
                        const otherRadio = document.getElementById("currency_other_radio");
                        const otherInput = document.getElementById("currency_other_input");

                        function toggleCurrencyOther(selectedValue) {
                            if (selectedValue === "pay.cash" || selectedValue === "pay.cheque") {
                                // 顯示「其他」選項
                                otherRadio.parentElement.style.display = "inline-flex";
                            } else {
                                // 隱藏並清空
                                otherRadio.parentElement.style.display = "none";
                                otherRadio.checked = false;
                                otherInput.style.display = "none";
                                otherInput.value = "";
                            }
                        }

                        // 監聽付款方式變更
                        payRadios.forEach(radio => {
                            radio.addEventListener("change", function () {
                                toggleCurrencyOther(this.value);
                            });
                        });

                        // 控制「其他 input」顯示
                        otherRadio.addEventListener("change", function () {
                            if (this.checked) {
                                otherInput.style.display = "inline-block";
                            } else {
                                otherInput.style.display = "none";
                            }
                        });

                        // 預設隱藏（頁面載入時）
                        otherRadio.parentElement.style.display = "none";
                    });
                </script>

                </div>
            </div>
        </main>

        <!--版腳-->
		<%@include file="../include/copyright.jsp" %>
		
    </body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf" %>