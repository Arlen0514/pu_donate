<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.security.*" %>
<%@ page import="org.apache.commons.codec.digest.DigestUtils" %>
<%@ include file="config.jsp"%>
<% 
	// 藍新定期定額-回傳處理程式
	String page_code 			= "newebpay_regular";
	
	/*------------------------------------接收藍新回傳的交易結果參數 ----------------------------------------------------*/

	// 基本商店參數
	String		MerchantID 		= SiteSetup.getText("newebpay.MerchantID"),		// 特店代碼	 	MS111679673
				HashKey 		= SiteSetup.getText("newebpay.HashKey"),		// 驗證碼			98BKhumUAVXnDTAZ5TDree04poCqJsfh
				HashIV 			= SiteSetup.getText("newebpay.HashIV");			// 驗證碼2		CA9DO0Yx63FWVzxP
	
	// 如果成功建立委託單 Status  Message  Result 不會有值 ，只有 Period 會有值，如果失敗才會有值
	/*
	{
		"Status":"SUCCESS",
		"Message":"\u59d4\u8a17\u55ae\u6210\u7acb\uff0c\u4e14\u9996\u6b21\u6388\u6b0a\u6210\u529f",
		"Result":{
			"MerchantID":"MS111679673",
			"MerchantOrderNo":"DONATE202007090003",
			"PeriodType":"M",
			"PeriodAmt":"1200",
			"AuthTimes":12,
			"DateArray":"2020-08-01,2020-09-01,2020-10-01,2020-11-01,2020-12-01,2021-01-01,2021-02-01,2021-03-01,2021-04-01,2021-05-01,2021-06-01,2021-07-01",
			"TradeNo":"20071010291475308",
			"AuthCode":"906740",
			"RespondCode":"00",
			"AuthTime":"20200710102914",
			"CardNo":"400022******1111",
			"EscrowBank":"HNCB",
			"AuthBank":"KGI",
			"PeriodNo":"P200710102914zc6hx9"
		}
	}
*/				
	try {
		String Period			= StringTool.validString(request.getParameter("Period"));
		
		String data 			= decryptAES(HashKey, HashIV, Period);
		JSONObject jsonObj_rep	= new JSONObject(data);
		
		String Status			= jsonObj_rep.getString("Status");
		String Message			= jsonObj_rep.getString("Message");
		JSONObject result 		= jsonObj_rep.getJSONObject("Result");
		
		System.out.println("RECEIVE");
		System.out.println(projectName+" 前台 定期定額資料 Period="+Period);
		System.out.println(projectName+" 前台 定期定額資料 jsonObj_rep="+jsonObj_rep);
		System.out.println(projectName+" 前台 定期定額資料 result="+result);
		
		if(!"SUCCESS".equals(Status)){												// 交易失敗
			String MerchantOrderNo = result.getString("MerchantOrderNo");		// 商店訂單編號
			
			TableRecord dh = app_sm.select(tbldh, "dh_no = ?", new Object[]{MerchantOrderNo});
			dh.setValue("dh_collect","N"); 			// 未收款
			dh.setUpdate("newebpay_regular");
			app_sm.update(dh);
			
			// 付款記錄更新
			TableRecord ph = app_sm.select(tblph, "data_id=? and ph_status=?", new Object[]{dh.getString("dh_id"), "N"});
			
			if(!"".equals(ph.getString("ph_id"))){
				ph.setValue("ph_paydate", app_today);
				ph.setValue("ph_return_no",Status);
			    ph.setValue("ph_return_msg",Message);
			    ph.setValue("ph_note", jsonObj_rep.toString());
			    ph.setValue("ph_memo", "Status="+Status +"|Message"+Message+"|data="+jsonObj_rep.toString());
				ph.setUpdate("newebpay_regular");
				app_sm.update(ph);
			}
			
			out.println("<script> alert('信用卡定期定額設定付款失敗，失敗原因："+Message+"'); location='../../../home.jsp';</script>"); 
			return;
			
		}else if("SUCCESS".equals(Status)){
			
				String MerchantOrderNo		= result.getString("MerchantOrderNo");		// 商店訂單編號
				String PeriodType 			= result.getString("PeriodType");			// 藍新金流交易序號
				int PeriodAmt				= result.getInt("PeriodAmt");				// 交易金額
				int AuthTimes 				= result.getInt("AuthTimes");				// 授權次數
				String AuthTime 			= result.getString("AuthTime");	
				String DateArray 			= result.getString("DateArray");			// 授權排程日期
				String TradeNo 				= result.getString("TradeNo");				// 藍新金流交易序號
				String RespondCode 			= result.getString("RespondCode");			// 銀行回應碼
				String CardNo 				= result.getString("CardNo");				// 卡號前六後四碼
				
				String EscrowBank			= result.getString("EscrowBank");			// 款項保管銀行
				String AuthBank				= result.getString("AuthBank");				// 收單機構
				String PeriodNo 			= result.getString("PeriodNo");				// 定期定額委託單號
			
				TableRecord dh = app_sm.select(tbldh, "dh_no = ?", new Object[]{MerchantOrderNo});
				dh.setValue("dh_collect","Y"); 			// 未收款
				dh.setUpdate("newebpay_regular");
				app_sm.update(dh);
				
				// 付款記錄更新
				TableRecord ph = app_sm.select(tblph, "data_id=? and ph_status=?", new Object[]{dh.getString("dh_id"), "N"});
				
				if(!"".equals(ph.getString("ph_id"))){
					ph.setValue("ph_status", "Y");
					ph.setValue("ph_bank_no", CardNo);
					ph.setValue("ph_paydate", app_today);
					ph.setValue("ph_return_no",Status);
				    ph.setValue("ph_return_msg",Message);
				    ph.setValue("ph_note", jsonObj_rep.toString());
				    ph.setValue("ph_memo", data);
					ph.setUpdate("newebpay_regular");
					app_sm.update(ph);
					
					// 沖銷記錄更新
					TableRecord wh = app_sm.select(tblwh, "data_id=? and wh_status=?", new Object[]{dh.getString("dh_id"), "N"});
					
					if(!"".equals(wh.getString("wh_id"))) {
						String wh_pay_date = app_today;
						String wh_pay_time = "00:00:00";
						
						wh.setValue("wh_status", "Y");
						wh.setValue("wh_account", TradeNo);
						wh.setValue("wh_pay_date", wh_pay_date);
						wh.setValue("wh_pay_time", wh_pay_time);
						wh.setUpdate("regular_receive");
						app_sm.update(wh);
					}
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
				
				// 確認 session 
				TableRecord f_data = (TableRecord) session.getAttribute("donate_finish");
				if(f_data== null)session.setAttribute("donate_finish", dh);				// 將完成的資料放入 後面拿來驗證
				
				// out.println("<script> alert('信用卡定期定額預約單付款成功，'); location='../../step/step03.jsp?dh_id="+dh.getString("dh_id")+"'; </script>");
				out.println("<script> alert('信用卡定期定額設定付款成功'); </script>");
				out.println("<script> location='../../donate/donate_sendmail.jsp?dh_id="+dh.getString("dh_id")+"'; </script>");
				return;
		}
	} catch(Exception e){
		System.out.println("Project:" + projectName + ", Error info:[" + e.getMessage() + "], File: web/donate/donate_update.jsp for [" + page_code + "], Time:[" + DateTimeTool.dateTimeString() + "]");
		out.println("<script> alert('系統發生錯誤,請聯繫客服人員 謝謝 !!'); location='../../../home.jsp'; </script>");
		return;
	}
%>