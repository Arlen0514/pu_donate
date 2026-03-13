<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date"%>
<%@ include file="config.jsp"%>
<% 
	// 藍新定期定額-送出處理程式
	String page_code 		= "newebpay_regular";
	String company			= SiteSetup.getSetup("cp.company" + "." + lang).getString("ss_text");
	
	// 訂單相關資料	
	String 	dh_id 			= StringTool.validString(request.getParameter("dh_id"));
	TableRecord dh			= app_sm.select(tbldh,dh_id);
	if(dh.getString("dh_id").isEmpty()) {
		out.println("<script> alert('無此捐款單!!'); location='../../../home.jsp'; </script>");
		return;
	}
	//Server name.	
	String servername = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
	if(request.getServerPort() == 80 || request.getServerPort() == 443){
		servername = request.getScheme()+"://"+request.getServerName();
	} 
		String localname = request.getScheme()+"://"+request.getLocalName()+":"+request.getLocalPort();
		String url = servername + request.getContextPath() + "/web";
		
	// 藍新訂期定額
	// 週期搭配周其授權時間  有很多種方式，詳細請看定期定額文件
	// PeriodType:  D/每天 W/每周 M/每月 Y/每年
	// PeriodPoint  當週期參數為D時，此欄位值限為數字2~999，幾天授權一次。
	// PeriodPoint  當週期參數為W時，此欄位值限為數字1~7，數字1~7表示每週一~週日。
	// 				當週期參數為M時，此欄位值限為數字01~31，數字01~31表示每月1號~31號。
	// 				當週期參數為Y時，此欄位值格式為MMDD
	// 如果已上必須 種規則  要傳  次   EX  每周   3  6   都要收款  變成 ：
	// PeriodType:W PeriodPoint:3   一張單
	// PeriodType:W PeriodPoint:6   一張單
	// PeriodTimes
	// 20200709 先用每月一捐  捐12個月   當天為第一次捐款 
	
	String cycle = "M";
	
	Date D = new Date();
	/* 參數 */
					
	// URL轉送位置 正式為 	 	  https://core.spgateway.com/MPG/period
	// URL轉送位置 測試為 	 	  https://ccore.spgateway.com/MPG/period
	String MerchantID 		= SiteSetup.getText("newebpay.MerchantID"),			// 特店代碼	 	MS111679673
			HashKey 		= SiteSetup.getText("newebpay.HashKey"),			// 驗證碼			98BKhumUAVXnDTAZ5TDree04poCqJsfh
			HashIV 			= SiteSetup.getText("newebpay.HashIV"),				// 驗證碼2		CA9DO0Yx63FWVzxP
			RespondType		= "JSON",											// 回傳格式  可以是 JSON AND String RespondType		= "JSON",										// 回傳格式  可以是 JSON AND String
			TimeStamp 		= String.valueOf(D.getTime()),						// EX:(TimeStamp = "1547708542934"), 
			Version 		= "1.0",											// 串接版本
			MerOrderNo		= dh.getString("dh_no"),							// 訂單編號
			ProdDesc 		= company + " 線上募款",
			PeriodType 		= dh.getString("dh_regular_type"), 					// 週期
						
			PeriodPoint		= "",												// 年 半年 季 月  各有不同設定  
			PeriodTimes		= String.valueOf(dh.getInt("dh_regular_period")),	// 授權期數
			
			PayerEmail		= dh.getString("dh_email"),
			ReturnURL		= url+"/payment/newebpay/regular_receive.jsp",				// 交易完成回傳網址
			NotifyURL 		= url+"/payment/newebpay/regular_notify.jsp";				// 每期交易完成給的參數 
			
			// 授權設定
			if ("M".equals(PeriodType)){			// 月捐  直接抓第一次捐款當下的日期  藍新設定，如果該月沒有該日期，則會是最後一天捐款
				PeriodPoint = app_today.replace("/", "").substring(6);
			} else if("Y".equals(PeriodType)) {		// 年捐，抓當下日期(格式：MMDD)
				PeriodPoint = app_today.replace("/", "").substring(4);
			}
			
	// 當天一次授權
	int	PeriodStartType 	= 2,												// 檢查卡號模式
		PeriodAmt			= dh.getInt("dh_total");							// 委託金額
	
	String temp_str = "RespondType="+RespondType+"&TimeStamp="+TimeStamp+
			"&Version="+Version+"&MerOrderNo="+MerOrderNo+"&ProdDesc="+ProdDesc+"&PeriodAmt="+String.valueOf(PeriodAmt)+
			"&PeriodType="+PeriodType+"&PeriodPoint="+PeriodPoint+"&PeriodTimes="+PeriodTimes+"&PeriodStartType="+PeriodStartType+"&PayerEmail="+PayerEmail+    
			"&ReturnURL="+ReturnURL+"&NotifyURL="+NotifyURL;
	
	if(is_local){
		temp_str = "RespondType="+RespondType+"&TimeStamp="+TimeStamp+
				"&Version="+Version+"&MerOrderNo="+MerOrderNo+"&ProdDesc="+ProdDesc+"&PeriodAmt="+String.valueOf(PeriodAmt)+
				"&PeriodType="+PeriodType+"&PeriodPoint="+PeriodPoint+"&PeriodTimes="+PeriodTimes+"&PeriodStartType="+PeriodStartType+"&PayerEmail="+PayerEmail+    
				"&ReturnURL="+ReturnURL;
	}
		
	// 測驗後正確
	String PostData_ = getAES(HashKey,HashIV,temp_str);
	
	// 建立並傳送post表單
	String[] names 	= {"MerchantID_", "PostData_"};
	String[] values = { MerchantID  ,  PostData_ };
	
	JSONObject post_json = new JSONObject();
	
	for(int i=0;i<names.length;i++) post_json.put(names[i], values[i]);
	post_json.put("temp_str", temp_str);									// 押碼字串
	
	// 新增付款紀錄
	TableRecord ph = new TableRecord (tblph);
	ph.setValue("data_id", dh.getString("dh_id"));
	ph.setValue("ph_post", post_json.toString());						// 儲存送出參數
	ph.setValue("ph_payment", dh.getString("dh_paymethod"));
	ph.setValue("ph_amount", PeriodAmt);
	ph.setValue("ph_status","N");
	ph.setValue("ph_code", "payment");
	ph.setInsert("regular_post");
	app_sm.insert(ph);
	
	// 建立沖銷紀錄(一筆訂單只會對應一筆沖銷紀錄)
	TableRecord wh = new TableRecord(tblwh);
	wh.setValue("wh_status", "N");				// 未沖銷
	wh.setValue("wh_total", PeriodAmt);
	wh.setValue("data_id", dh.getString("dh_id"));
	wh.setValue("wh_payment", dh.getString("dh_paymethod"));
	wh.setValue("wh_code", "credit_regular");
	wh.setInsert("regular_post");
	app_sm.insert(wh);
	
	if("test".equals(api_status)) {
	   	out.println(HtmlCoder.form("regular_post", "https://ccore.newebpay.com/MPG/period", names,values ));   	// 測試位置
	} else if("online".equals(api_status)) {
		out.println(HtmlCoder.form("regular_post", "https://core.newebpay.com/MPG/period", names,values ));  	// 正式位置	
	}
 	out.println("<script> regular_post.submit(); </script>");
 	
%>