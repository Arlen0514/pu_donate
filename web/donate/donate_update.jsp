<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/web/include/encryption.jsp"%>
<%
	String page_code = "donate";														// 功能識別碼
	String action = StringTool.validString(request.getParameter("action"));
	
	try{
		AESDataEncryption ade = new AESDataEncryption();
		
		/*-- 新增捐款紀錄 --*/
		if("add".equals(action)){
			// A. 捐款項目
			String dh_total 				  = StringTool.validString(request.getParameter("dh_total"));
			String dh_donate_project_category = StringTool.validString(request.getParameter("dh_donate_project_category"));
			String dh_donate_project_title    = StringTool.validString(request.getParameter("dh_donate_project_title"));
			String dh_donate_project 		  = StringTool.validString(request.getParameter("dh_donate_project"));
			String dh_donate_college		  = StringTool.validString(request.getParameter("dh_donate_college"));
			String dh_donate_department		  = StringTool.validString(request.getParameter("dh_donate_department"));
			String dh_remark 				  = StringTool.validString(request.getParameter("dh_remark"));
			String dh_paymethod 			  = StringTool.validString(request.getParameter("dh_paymethod"));
			
			// 院系捐款  
			TableRecord department_index = app_sm.select(tbldm, "dm_code=? and dm_lang=? and dm_category=?",
		            new Object[]{"department_index", lang, ""}, "dm_showseq ASC, dm_createdate DESC");
			
			if(dh_donate_project_category.equals(department_index.getString("dm_id"))) {
				dh_donate_project = StringTool.validString(request.getParameter("donate_project_dept"));
				if("other".equals(dh_donate_project)) 
					dh_donate_project_title = StringTool.validString(request.getParameter("donate_project_dept_other"));
			}
			
			// B. 捐款人基本資料
			String dh_name 			= StringTool.validString(request.getParameter("dh_name"));
			String dh_pid 			= StringTool.validString(request.getParameter("dh_pid"));
			String dh_cellphone 	= StringTool.validString(request.getParameter("dh_cellphone"));
			String dh_phone 		= StringTool.validString(request.getParameter("dh_phone"));
			String dh_foreign 		= StringTool.validString(request.getParameter("dh_foreign"));
			String dh_county 		= StringTool.validString(request.getParameter("dh_county"));
			String dh_city 			= StringTool.validString(request.getParameter("dh_city"));
			String dh_zipcode 		= StringTool.validString(request.getParameter("dh_zipcode"));
			String dh_address 		= StringTool.validString(request.getParameter("dh_address"));
			String dh_email 		= StringTool.validString(request.getParameter("dh_email"));
			String dh_identity  	= StringTool.validString(request.getParameter("dh_identity"));
			String dh_identity_year = StringTool.validString(request.getParameter("dh_identity_year"));
			String dh_identity_dept = StringTool.validString(request.getParameter("dh_identity_dept"));
			String dh_unit  		= StringTool.validString(request.getParameter("dh_unit"));
			String dh_job  			= StringTool.validString(request.getParameter("dh_job"));
			
			
			//幣別
			String dh_currency  	= StringTool.validString(request.getParameter("dh_currency"));
			String dh_currency_other= StringTool.validString(request.getParameter("dh_currency_other"));
			//身份別
			String dh_identity_type = StringTool.validString(request.getParameter("dh_identity_type"));
			
			if(!"".equals(dh_pid)) dh_pid = ade.AESEncrypt(dh_pid);
			
			// C. 收據與芳名錄
			String dh_receipt_status  = StringTool.validString(request.getParameter("dh_receipt_status"));
			String dh_receipt_title   = StringTool.validString(request.getParameter("dh_receipt_title"));
			String dh_receipt_county  = StringTool.validString(request.getParameter("dh_receipt_county"));
			String dh_receipt_city 	  = StringTool.validString(request.getParameter("dh_receipt_city"));
			String dh_receipt_zipcode = StringTool.validString(request.getParameter("dh_receipt_zipcode"));
			String dh_receipt_address = StringTool.validString(request.getParameter("dh_receipt_address"));
			String dh_same_name  	  = StringTool.validString(request.getParameter("dh_same_name"));
			String dh_same_address    = StringTool.validString(request.getParameter("dh_same_address"));
			String dh_public 		  = StringTool.validString(request.getParameter("dh_public"));
			String dh_tax 		  	  = StringTool.validString(request.getParameter("dh_tax"), "N");
			
			if("Y".equals(dh_foreign)) {
				dh_county  = "";
				dh_city    = "";
				dh_zipcode = "";
				dh_receipt_county  = "";
				dh_receipt_city    = "";
				dh_receipt_zipcode = "";
			}
			
			// 檢核圖形驗証碼
			String r = StringTool.validString((String) session.getAttribute("rand"));
			String ind = StringTool.validString(request.getParameter("ind"));
			if(!r.equals(ind) || "".equals(r)) {
				out.println("<script> alert('您輸入的圖案文字錯誤 !!'); history.back(); </script>");
				return;
			}
			
			// 新增捐款紀錄
			TableRecord dh = new TableRecord(tbldh);
			
			dh.setValue("dh_donate_project_category", dh_donate_project_category);
			dh.setValue("dh_donate_college", dh_donate_college);
			dh.setValue("dh_donate_department", dh_donate_department);
			dh.setValue("dh_donate_project", dh_donate_project);
			dh.setValue("dh_donate_project_title", dh_donate_project_title);
			dh.setValue("dh_paymethod", dh_paymethod);
			dh.setValue("dh_remark", dh_remark);
			dh.setValue("dh_currency", dh_currency);
			dh.setValue("dh_currency_other", dh_currency_other);
			dh.setValue("dh_total", dh_total);
			dh.setValue("dh_identity_type", dh_identity_type);
			dh.setValue("dh_name", dh_name);
			dh.setValue("dh_pid", dh_pid);
			dh.setValue("dh_email", dh_email);
			dh.setValue("dh_phone", dh_phone);
			dh.setValue("dh_cellphone", dh_cellphone);
			dh.setValue("dh_foreign", dh_foreign);
			dh.setValue("dh_county", dh_county);
			dh.setValue("dh_city", dh_city);
			dh.setValue("dh_zipcode", dh_zipcode);
			dh.setValue("dh_address", dh_address);
			dh.setValue("dh_identity", dh_identity);
			dh.setValue("dh_unit", dh_unit);
			dh.setValue("dh_job", dh_job);
			dh.setValue("dh_receipt_status", dh_receipt_status);
			dh.setValue("dh_receipt_title", dh_receipt_title);
			dh.setValue("dh_receipt_county", dh_receipt_county);
			dh.setValue("dh_receipt_city", dh_receipt_city);
			dh.setValue("dh_receipt_zipcode", dh_receipt_zipcode);
			dh.setValue("dh_receipt_address", dh_receipt_address);
			dh.setValue("dh_same_name", dh_same_name);
			dh.setValue("dh_same_address", dh_same_address);
			dh.setValue("dh_public", dh_public);
			dh.setValue("dh_tax", dh_tax);
			
			// 定期定額
			if(dh_paymethod.contains("regular")){
				String dh_regular_type    = StringTool.validString(request.getParameter("dh_regular_type"));
				String dh_debit_due_year  = "", dh_debit_due_month = "";
				
				int debit_start_year  = DateTimeTool.getYear();							// 捐款起始年
				int debit_start_month = DateTimeTool.getMonth();						// 捐款起始月
				int debit_due_year    = DateTimeTool.getYear();							// 捐款結束年(預設當月)
				int debit_due_month   = DateTimeTool.getMonth();						// 捐款結束月(預設當年)
				int dh_regular_period = 0;
				
				if("".equals(dh_regular_type)) {
					out.println("<script> alert('定期定額類型有誤!!'); history.back(); </script>");
					return;
				}
				
				/*-- 計算期數：從捐款起始月開始算(最大99期，頭尾都要算) --*/
				DecimalFormat df = new DecimalFormat("00");
				
				switch(dh_regular_type){
					case "M":
						dh_debit_due_year  = StringTool.validString(request.getParameter("dh_debit_due_year"));
						dh_debit_due_month = StringTool.validString(request.getParameter("dh_debit_due_month"));
						if("".equals(dh_debit_due_year) || "".equals(dh_debit_due_month)){
							out.println("<script> alert('定期定額時間範圍有誤!!'); history.back(); </script>");
							return;
						}
						debit_due_year    = Integer.parseInt(dh_debit_due_year);			// 捐款結束年
						debit_due_month   = Integer.parseInt(dh_debit_due_month);			// 捐款結束月
						dh_regular_period = (debit_due_year-debit_start_year)*12 + (debit_due_month-debit_start_month) + 1;
						break;
					case "Y":
						dh_debit_due_year  = StringTool.validString(request.getParameter("dh_debit_due_year"));
						dh_debit_due_month = df.format(DateTimeTool.getMonth());
						if("".equals(dh_debit_due_year)){
							out.println("<script> alert('定期定額時間範圍有誤!!'); history.back(); </script>");
							return;
						}
						debit_due_year    = Integer.parseInt(dh_debit_due_year);			// 捐款結束年
						dh_regular_period = debit_due_year - debit_start_year + 1;
						break;
				}
				
				if(dh_regular_period > 99) {
					out.println("<script> alert('定期定額期數不可以超過 99 期!!'); history.back(); </script>");
					return;
				} else if(dh_regular_period <= 0) {
					out.println("<script> alert('定期定額期數至少要 1 期!!'); history.back(); </script>");
					return;
				}
				
				dh.setValue("dh_regular_type", dh_regular_type);
				dh.setValue("dh_debit_due_year", dh_debit_due_year);
				dh.setValue("dh_debit_due_month", dh_debit_due_month);
				dh.setValue("dh_regular_period", dh_regular_period);
				dh.setValue("dh_remain_period", dh_regular_period);
			}
			
			// 暫存
			session.removeAttribute("donate_form");
			session.setAttribute("donate_form", dh);
			
			out.println("<script> location='donate2.jsp'; </script>");
			return;
		
		/*-- 送出捐款紀錄 --*/
		} else if("donate".equals(action)){
			TableRecord dh = (TableRecord) session.getAttribute("donate_form");
			boolean has_filled = dh!=null;
			
			if(!has_filled){
				out.println("<script> alert('您尚未填寫捐款單 !!'); location='donate.jsp'; </script>");
				return;
			}
			
			// 捐款人資料新增
			TableRecord mp = app_sm.select(tblmp, "mp_personid=?", new Object[]{ dh.getString("dh_pid") });
			
			if("".equals(mp.getString("mp_id"))){
				mp = new TableRecord(tblmp);
				mp.setValue("mp_name", dh.getString("dh_name"));
				mp.setValue("mp_personid", dh.getString("dh_pid"));
				mp.setValue("mp_email", dh.getString("dh_email"));
				mp.setValue("mp_cellphone", dh.getString("dh_cellphone"));
				mp.setValue("mp_phone", dh.getString("dh_phone"));
				mp.setValue("mp_county", dh.getString("dh_county"));
				mp.setValue("mp_city", dh.getString("dh_city"));
				mp.setValue("mp_zipcode", dh.getString("dh_zipcode"));
				mp.setValue("mp_address", dh.getString("dh_address"));
				mp.setValue("mp_unit", dh.getString("dh_unit"));
				mp.setValue("mp_job", dh.getString("dh_job"));
				mp.setValue("mp_mail_status","Y");
				mp.setValue("mp_regcode", "OK");
				mp.setValue("mp_status", "Y");
				mp.setValue("mp_code", "member");
				mp.setInsert("Web_User");
				app_sm.insert(mp);
			} else {
				mp.setValue("mp_name", dh.getString("dh_name"));
				mp.setValue("mp_personid", dh.getString("dh_pid"));
				mp.setValue("mp_email", dh.getString("dh_email"));
				mp.setValue("mp_cellphone", dh.getString("dh_cellphone"));
				mp.setValue("mp_phone", dh.getString("dh_phone"));
				mp.setValue("mp_county", dh.getString("dh_county"));
				mp.setValue("mp_city", dh.getString("dh_city"));
				mp.setValue("mp_zipcode", dh.getString("dh_zipcode"));
				mp.setValue("mp_address", dh.getString("dh_address"));
				mp.setValue("mp_unit", dh.getString("dh_unit"));
				mp.setValue("mp_job", dh.getString("dh_job"));
				mp.setUpdate("Web_User");
				app_sm.update(mp);
			}
			
			// 捐款項目相關資訊
			if(!"other".equals(dh.getString("dh_donate_project"))) {
				TableRecord donate_project_cp = app_sm.select(tblcp, dh.getString("dh_donate_project"));
				
				if(!"".equals(donate_project_cp.getString("cp_id"))) {
					TableRecord donate_unit = app_sm.select(tbldm, donate_project_cp.getString("cp_usage"));	// 受贈單位
					TableRecord donate_attr = app_sm.select(tbldm, donate_project_cp.getString("cp_attr"));		// 捐款屬性
					
					String dh_donate_unit 			 = donate_unit.getString("dm_id");
					String dh_donate_unit_title 	 = donate_unit.getString("dm_title");
					String dh_donate_attribute 		 = donate_attr.getString("dm_id");
					String dh_donate_attribute_title = donate_attr.getString("dm_title");
					String dh_donate_project_no 	 = donate_project_cp.getString("cp_no");
					String dh_donate_project_title   = donate_project_cp.getString("cp_title");
					
					/*
					System.out.println("dh_donate_project_no="+dh_donate_project_no);
					System.out.println("dh_donate_project_title="+dh_donate_project_title);
					System.out.println("dh_donate_unit="+dh_donate_unit);
					System.out.println("dh_donate_unit_title="+dh_donate_unit_title);
					System.out.println("dh_donate_attribute="+dh_donate_attribute);
					System.out.println("dh_donate_attribute_title="+dh_donate_attribute_title);
					*/

					dh.setValue("dh_donate_project_no", dh_donate_project_no);
					dh.setValue("dh_donate_project_title", dh_donate_project_title);
					dh.setValue("dh_donate_unit", dh_donate_unit);
					dh.setValue("dh_donate_unit_title", dh_donate_unit_title);
					dh.setValue("dh_donate_attribute", dh_donate_attribute);
					dh.setValue("dh_donate_attribute_title", dh_donate_attribute_title);
				}
			}
			
			// 贈與身分(感謝狀)
			String dh_identity = dh.getString("dh_identity");
			String dh_identity_thank = "person";
			
			if("1".equals(dh_identity)) dh_identity_thank = "alumni";
			else if("4".equals(dh_identity)) dh_identity_thank = "company";
			
			/*------------------捐款編號 OrderID----------------------------------*/
			String dh_no = "";

			String idHead = "1044001";	
			String seq = IDTool.getUID("donate", DateTimeTool.dateString(""), 4);
			Random rand = new Random(); 
			int randomDigit = rand.nextInt(10);
			
			dh_no = idHead + seq + randomDigit ;	
			
			
			dh.setValue("mp_id", mp.getString("mp_id"));
// 			dh.setValue("dh_currency", "TWD");
			dh.setValue("dh_no", dh_no);
			dh.setValue("dh_mis", "N");
			dh.setValue("dh_status", "Y");
			dh.setValue("rs_status", "N");
			dh.setValue("dh_collect", "N");
			dh.setValue("dh_calculate", "N");
			dh.setValue("dh_donatedate", app_today);
			dh.setValue("dh_identity_thank", dh_identity_thank);
			dh.setValue("dh_code", "donate");
			dh.setValue("dh_lang", lang);
			dh.setInsert("Web_User");
			app_sm.insert(dh);
			
			session.removeAttribute("donate_form");
			
			/*-- 金流導向 --*/
			// 行動支付
			if("pay.pu".equals(dh.getString("dh_paymethod"))){
				out.println("<script> location='../payment/pupay/post.jsp?dh_id="+dh.getString("dh_id")+"'; </script>");	
// 			信用卡(定期定額)
			}else if("pay.newebpay.regular".equals(dh.getString("dh_paymethod"))){
				out.println("<script> location='../payment/newebpay/regular_post.jsp?dh_id="+dh.getString("dh_id")+"'; </script>");
//	 		信用卡(單筆)
			}else if("pay.newebpay.credit".equals(dh.getString("dh_paymethod"))){
				out.println("<script> location='../payment/newebpay/credit_post.jsp?dh_id="+dh.getString("dh_id")+"'; </script>");	

// 			// 信用卡(虛擬帳號)
			}else if("pay.newebpay.vatm".equals(dh.getString("dh_paymethod"))){
	 			out.println("<script> location='../payment/newebpay/vatm_post.jsp?dh_id="+dh.getString("dh_id")+"'; </script>");	
	 		// 其他：現金、匯款、支票
			}else{
				out.println("<script> location='donate_sendmail.jsp?dh_id="+dh.getString("dh_id")+"'; </script>");
			}
		}
	} catch(Exception e){
		System.out.println("Project:" + projectName + ", Error info:[" + e + "], File:web/donate/donate_update.jsp for [" + page_code + "], Time:[" + DateTimeTool.dateTimeString() + "]");
		out.println("<script> alert(' 系統發生錯誤,請聯繫客服人員 謝謝 !!'); history.back(); </script>");
		return;
	}
%>