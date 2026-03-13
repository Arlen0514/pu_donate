<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.security.*" %>
<%@ page import="org.apache.commons.codec.digest.DigestUtils" %>
<%@ include file="config.jsp"%>
<% 
	// 藍新定期定額-回傳處理程式(此程式是 定期定額確認收款完後會回傳的資料)
	String page_code 		= "newebpay_regular";							// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	
	/*------------------------------------接收藍新回傳的交易結果參數 ----------------------------------------------------*/

	// 基本商店參數
	String	MerchantID 		= SiteSetup.getText("newebpay.MerchantID"),		// 特店代碼	 	
			HashKey 		= SiteSetup.getText("newebpay.HashKey"),		// 驗證碼			
			HashIV 			= SiteSetup.getText("newebpay.HashIV");			// 驗證碼2		
	
	String Period			= StringTool.validString(request.getParameter("Period"));
			
	// 防止 multipart/form-data
	if(Period.isEmpty()){
		String contentType = request.getContentType();
		String dir = app_uploadpath+"/temp";
		DiskFileUpload fu = new DiskFileUpload();
		fu.setHeaderEncoding("UTF-8");		// 亂碼關鍵(1)
		fu.setSizeMax(4*1024*1024); 		// 設置文件大小
		fu.setSizeThreshold(4*1024); 		// 設置緩衝大小
		fu.setRepositoryPath(dir); 			// 設置臨時目錄     
        List<FileItem> formItems = fu.parseRequest(request);
        for(FileItem fi:formItems) {
        	if("Period".equals(fi.getFieldName()) || "period".equals(fi.getFieldName())){
        		System.out.println("前台 定期定額資料 contentType="+contentType);
        		Period = fi.getString();
        		break;
        	}
        }
	}
	
	try {
		String data 			= decryptAES(HashKey, HashIV, Period);
		JSONObject jsonObj_rep	= new JSONObject(data);
		
		String Status			= jsonObj_rep.getString("Status");
		String Message			= jsonObj_rep.getString("Message");
		JSONObject result 		= jsonObj_rep.getJSONObject("Result");
		
		System.out.println("NOTIFY");
		System.out.println("前台 定期定額資料 Period="+Period);
		System.out.println("前台 定期定額資料 jsonObj_rep="+jsonObj_rep);
		System.out.println("前台 定期定額資料 result="+result);
		
		if(!"SUCCESS".equals(Status)){										// 交易失敗
			
			String MerchantOrderNo = jsonObj_rep.getString("MerchantOrderNo");		// 商店訂單編號
			// System.out.print("data="+data);
			
			//更新or新增訂單資料 (捐款當月為更新 之後皆為新增)
			TableRecord dh = app_sm.select(tbldh, "dh_no = ?", new Object[]{MerchantOrderNo});
			int dh_regular_period = dh.getInt("dh_regular_period");					// 定期定額總期數
			int dh_remain_period  = dh.getInt("dh_remain_period");					// 定期定額剩餘期數
			boolean first_period  = dh.getString("dh_donatedate").equals(app_today);
			
			if(first_period){
				dh.setValue("dh_collect","N"); 								// 未收款
				app_sm.update(dh);
				
				// 付款記錄更新
				TableRecord ph = app_sm.select(tblph, "data_id=?", new Object[]{dh.getString("dh_id")});
				
				if(!"".equals(ph.getString("ph_id"))) {
					ph.setValue("ph_paydate", app_today);
					ph.setValue("ph_return_no",Status);
				    ph.setValue("ph_return_msg",Message);
				    ph.setValue("ph_note", jsonObj_rep.toString());
				    ph.setValue("ph_memo", "Status="+Status +"|Message"+Message+"|data="+jsonObj_rep.toString());
					ph.setUpdate("newebpay_regular");
					app_sm.update(ph);
				}
			} else {
				dh_remain_period--;
				dh.setValue("dh_remain_period", dh_remain_period);
				dh.setUpdate("regular_notify");
				app_sm.update(dh);
				
				// 新增捐款紀錄
				dh.setValue("dh_status", "N");
				dh.setValue("dh_collect", "N");
				dh.setValue("dh_calculate", "N");
				dh.setValue("dh_donatedate", app_today);
				dh.setValue("dh_main", dh.getString("dh_id"));
				dh.setValue("dh_no", IDTool.getUID("donate", DateTimeTool.dateString(""), 4));
				dh.setInsert("regular_notify");
				app_sm.insert(dh);
				
				// 新增付款紀錄
				TableRecord ph = new TableRecord (tblph);
				ph.setValue("data_id", dh.getString("dh_id"));
				ph.setValue("ph_paydate", app_today);
				ph.setValue("ph_payment", dh.getString("dh_paymethod"));
				ph.setValue("ph_amount", dh.getInt("dh_total"));
				ph.setValue("ph_status","N");
				ph.setValue("ph_return_no",Status);
			    ph.setValue("ph_return_msg",Message);
			    ph.setValue("ph_note", jsonObj_rep.toString());
				ph.setValue("ph_memo", "Status="+Status +"|Message"+Message+"|data="+jsonObj_rep);
				ph.setValue("ph_code", "payment");
				ph.setInsert("regular_notify");
				app_sm.insert(ph);
				
				// 建立沖銷紀錄(一筆訂單只會對應一筆沖銷紀錄)
				TableRecord wh = new TableRecord(tblwh);
				wh.setValue("wh_status", "N");				// 未沖銷
				wh.setValue("wh_total", dh.getInt("dh_total"));
				wh.setValue("data_id", dh.getString("dh_id"));
				wh.setValue("wh_payment", dh.getString("dh_paymethod"));
				wh.setValue("wh_code", "credit_regular");
				wh.setInsert("regular_notify");
				app_sm.insert(wh);
			}
			
			System.out.println(projectName+" 定期定額收款失敗，單號:"+MerchantOrderNo+"|日期："+app_today);
			
		}else if("SUCCESS".equals(Status)){
			
			String MerchantOrderNo		= result.getString("MerchantOrderNo");		// 商店訂單編號(原訂單編號_第幾次)
			String TradeNo 				= result.getString("TradeNo");				// 藍新金流交易序號
			String RespondCode 			= result.getString("RespondCode");			// 銀行回應碼
			String PeriodNo 			= result.getString("PeriodNo");				// 定期定額委託單號
			String dh_no 				= MerchantOrderNo.split("_")[0];
			
			/*
			String PeriodType 			= result.getString("PeriodType");			// 藍新金流交易序號
			int PeriodAmt				= result.getInt("PeriodAmt");				// 交易金額
			int AuthTimes 				= result.getInt("AuthTimes");				// 授權次數
			String AuthTime 			= result.getString("AuthTime");	
			String DateArray 			= result.getString("DateArray");			// 授權排程日期
			String CardNo 				= result.getString("CardNo");				// 卡號前六後四碼
			String EscrowBank			= result.getString("EscrowBank");			// 款項保管銀行
			String AuthBank				= result.getString("AuthBank");				// 收單機構
			*/
			
			// 更新or新增訂單資料(捐款當月為更新 之後皆為新增)
			TableRecord dh = app_sm.select(tbldh, "dh_no = ?", new Object[]{dh_no});
			int dh_regular_period = dh.getInt("dh_regular_period");					// 定期定額總期數
			int dh_remain_period  = dh.getInt("dh_remain_period");					// 定期定額剩餘期數
			boolean first_period  = dh.getString("dh_donatedate").equals(app_today);
			
			if(first_period){
				dh.setValue("dh_collect", "Y");
				app_sm.update(dh);
				
				// 付款記錄更新
				TableRecord ph = app_sm.select(tblph, "data_id=?", new Object[]{dh.getString("dh_id")});
				
				if(!"".equals(ph.getString("ph_id"))) {
					ph.setValue("ph_status", "Y");
// 					ph.setValue("ph_bank_no", CardNo);
					ph.setValue("ph_paydate", app_today);
					ph.setValue("ph_return_no",Status);
				    ph.setValue("ph_return_msg",Message);
				    ph.setValue("ph_note", jsonObj_rep.toString());
				    ph.setValue("ph_memo", data);
					ph.setUpdate("regular_notify");
					app_sm.update(ph);
					
					// 沖銷記錄更新
					TableRecord wh = app_sm.select(tblwh, "data_id=?", new Object[]{dh.getString("dh_id")});
					
					if(!"".equals(wh.getString("wh_id"))) {
						String wh_pay_date = app_today;
						String wh_pay_time = "00:00:00";
						
						wh.setValue("wh_status", "Y");
						wh.setValue("wh_account", TradeNo);
						wh.setValue("wh_pay_date", wh_pay_date);
						wh.setValue("wh_pay_time", wh_pay_time);
						wh.setUpdate("regular_notify");
						app_sm.update(wh);
					}
				}
			} else {
				dh_remain_period--;
				dh.setValue("dh_remain_period", dh_remain_period); 			// 未收款
				dh.setUpdate("regular_notify");
				app_sm.update(dh);
				
				// 新增捐款紀錄
				dh.setValue("dh_status", "Y");
				dh.setValue("dh_collect", "Y");
				dh.setValue("dh_calculate", "N");
				dh.setValue("dh_donatedate", app_today);
				dh.setValue("dh_main", dh.getString("dh_id"));
				
				
				String new_dh_no = "";

				String idHead = "1044001";	
				String seq = IDTool.getUID("donate", DateTimeTool.dateString(""), 4);
				Random rand = new Random(); 
				int randomDigit = rand.nextInt(10);
				
				new_dh_no = idHead + seq + randomDigit ;
				
				
// 				dh.setValue("dh_no", IDTool.getUID("donate", DateTimeTool.dateString(""), 4));
				dh.setValue("dh_no", new_dh_no);

				dh.setInsert("regular_notify");
				app_sm.insert(dh);
				
				// 新增付款紀錄
				TableRecord ph = new TableRecord (tblph);
				ph.setValue("data_id", dh.getString("dh_id"));
				ph.setValue("ph_paydate", app_today);
				ph.setValue("ph_payment", dh.getString("dh_paymethod"));
				ph.setValue("ph_amount", dh.getInt("dh_total"));
				ph.setValue("ph_status","Y");
// 				ph.setValue("ph_bank_no", CardNo);
				ph.setValue("ph_return_no",Status);
			    ph.setValue("ph_return_msg",Message);
			    ph.setValue("ph_note", jsonObj_rep.toString());
				ph.setValue("ph_memo", "Status="+Status +"|Message"+Message+"|data="+jsonObj_rep);
				ph.setValue("ph_code", "payment");
				ph.setInsert("regular_notify");
				app_sm.insert(ph);
				
				// 建立沖銷紀錄(一筆訂單只會對應一筆沖銷紀錄)
				TableRecord wh = new TableRecord(tblwh);
				wh.setValue("wh_status", "Y");				// 未沖銷
				wh.setValue("wh_total", dh.getInt("dh_total"));
				wh.setValue("data_id", dh.getString("dh_id"));
				wh.setValue("wh_payment", dh.getString("dh_paymethod"));
				wh.setValue("wh_code", "credit_regular");
				wh.setInsert("regular_notify");
				app_sm.insert(wh);
			}
			
			// 芳名錄
			TableRecord dr = app_sm.select(tbldr, "dh_id=?", new Object[]{dh.getString("dh_id")});
			
			if("".equals(dr.getString("dr_id"))) {
				TableRecord donate_category = app_sm.select(tbldm, dh.getString("dh_donate_project_category"));
				boolean is_other   = "".equals(donate_category.getString("dm_id"));
				boolean is_public  = "Y".equals(dh.getString("dh_public"));
				boolean is_foreign = !"TWD".equals(dh.getString("dh_currency"));
				
				dr = new TableRecord(tbldr);
				dr.setValue("dh_id", dh.getString("dh_id"));
				dr.setValue("dh_no", dh.getString("dh_no"));
				dr.setValue("dr_no", IDTool.getUID("record", "DR"+DateTimeTool.dateString(""), 6));
				dr.setValue("dr_name", is_public?dh.getString("dh_name"):"熱心人士");
				dr.setValue("dr_identity", dh.getString("dh_identity"));
				dr.setValue("dr_donatedate", dh.getString("dh_donatedate"));
				dr.setValue("dr_donate_item_category", is_other?"其他":donate_category.getString("dm_title"));
				dr.setValue("dr_donate_item", dh.getString("dh_donate_project"));
				dr.setValue("dr_donate_item_title", dh.getString("dh_donate_project_title"));
				dr.setValue("dr_currency", dh.getString("dh_currency"));
				dr.setValue("dr_total", dh.getInt(is_foreign?"dh_foreign_total":"dh_total"));
				dr.setValue("dr_status", "Y");
				dr.setValue("dr_code", "directory");
				dr.setValue("dr_lang", lang);
				dr.setInsert("newebpay_regular");
				app_sm.insert(dr);
				
				dh.setValue("dr_id", dr.getString("dr_id"));
				dh.setValue("dr_no", dr.getString("dr_no"));	// dh寫入收據編號
				app_sm.update(dh);
			}
			
			System.out.println(projectName+" 定期定額收款成功，單號:"+MerchantOrderNo+"|日期："+app_today);
		}
	} catch(Exception e){
		System.out.println("Project:" + projectName + ", Error info:[" + e.getMessage() + "], File: web/donate/donate_update.jsp for [" + page_code + "], Time:[" + DateTimeTool.dateTimeString() + "]");
		return;
	}

%>