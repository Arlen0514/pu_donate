<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
// 語系切換  - 繁中  英文  簡中
	Map<String, String> show_str = new HashMap();

//	show_str.put("loading.tw","讀取中");
//	show_str.put("loading.en","Loading");
//	show_str.put("loading.cn","读取中");

	//主功能選單
	show_str.put("about.tw","關於我們");
	show_str.put("about.en","About us");
	show_str.put("about.cn","关于我们");

	show_str.put("news.tw","最新消息");
	show_str.put("news.en","News");
	show_str.put("news.cn","最新新闻");
	
	show_str.put("product.tw","產品介紹");
	show_str.put("product.en","Product");
	show_str.put("product.cn","产品介绍");	
	
	show_str.put("contact.tw","聯絡我們");
	show_str.put("contact.en","Contact Us");
	show_str.put("contact.cn","联络我们");
	
	//最新消息
	show_str.put("goback.tw","回上一頁");
	show_str.put("goback.en","BACK");	
	
	//產品介紹
	show_str.put("dm.tw","型錄下載");
	show_str.put("dm.en","Catalog download");		
	
	show_str.put("download.tw","立即下載");
	show_str.put("download.en","Download");	
	
	show_str.put("pd_desc.tw","產品說明");
	show_str.put("pd_desc.en","Description");		
	
	show_str.put("pd_spec.tw","產品規格");
	show_str.put("pd_spec.en","Specification");	
	
	show_str.put("pd_img.tw","產品圖片");
	show_str.put("pd_img.en","Product Image");		
	
	show_str.put("pd_film.tw","產品影片");
	show_str.put("pd_film.en","Product film");	
	
	show_str.put("pd_file.tw","檔案下載");
	show_str.put("pd_file.en","File download");		
	

	// 版尾資訊
	show_str.put("address.tw","公司地址");
	show_str.put("address.en","Company address");
	show_str.put("address.cn","公司地址");

	show_str.put("companyno.tw","統一編號");
	show_str.put("companyno.en","Editor");
	show_str.put("companyno.cn","统编");
	
//	show_str.put("confirm.tw","請確認您的必填項目皆已完整填寫。");
//	show_str.put("confirm.en","Please confirm that all required items have been filled out.");
//	show_str.put("confirm.cn","请确认您的必填项目皆已完整填写。");
	
//	show_str.put("recap.tw","重取驗證碼");
//	show_str.put("recap.en","Recap verification code");
//	show_str.put("recap.cn","重取验证码");
	
//	show_str.put("attention.tw","(請注意英文字母大小寫！)");
//	show_str.put("attention.en","(Please pay attention to the English letter case!)");
//	show_str.put("attention.cn","(请注意英文字母大小写！)");
	
Map<String, String> field_str = new HashMap <String, String> ();

	field_str.put("submit.tw","確認送出");
	field_str.put("submit.en","Submit");
	field_str.put("submit.cn","确认送出");

	field_str.put("reset.tw","重新填寫");
	field_str.put("reset.en","Reset");
	field_str.put("reset.cn","重新填写");

	field_str.put("name.tw","姓名：");
	field_str.put("name.en","Name：");
	field_str.put("name.cn","姓名：");
	
	field_str.put("phone.tw","聯絡電話：");
	field_str.put("phone.en","Phone：");
	field_str.put("phone.cn","连络电话：");
	
	
	field_str.put("cellphone.tw","聯絡手機：");
	field_str.put("cellphone.en","Cellphone：");
	
	field_str.put("title.tw","主旨：");
	field_str.put("title.en","Subject：");

	//field_str.put("email.tw","Email：");
	//field_str.put("email.en","Email：");
	//field_str.put("email.cn","Email：");
	
	//field_str.put("category.tw","產品項目");
	//field_str.put("category.en","Product item");
	//field_str.put("category.cn","产品项目");
	
	field_str.put("content.tw","訊息內容：");
	field_str.put("content.en","Content：");
	field_str.put("content.cn","讯息内容：");

	field_str.put("code.tw","驗證碼");
	field_str.put("code.en","Verification Code");
	field_str.put("code.cn","验证码");
   
	//field_str.put("choose.tw","請選擇");
	//field_str.put("choose.en","Please choose");
	//field_str.put("choose.cn","请选择");
	
	field_str.put("contact.us.tw","聯絡我們通知信");
	field_str.put("contact.us.en","Contact us notification letter");
	field_str.put("contct.us.cn","联络我们通知信");

Map<String, String> alert_str = new HashMap <String, String> ();

	alert_str.put("name.tw","請輸入您的姓名 !!");
	alert_str.put("name.en","Please enter your name !!");
	alert_str.put("name.cn","请输入您的姓名 !!");

	alert_str.put("phone.tw","請輸入正確的聯絡電話 !!");
	alert_str.put("phone.en","Please enter a valid contact phone !!");
	alert_str.put("phone.cn","请输入正确的联络电话 !!");

	alert_str.put("cellphone.tw","請輸入正確的手機電話 !!");
	alert_str.put("cellphone.en","Please enter a valid contact cellphone !!");
	alert_str.put("cellphone.cn","请输入正确的联络电话 !!");
	
	alert_str.put("email.tw","請輸入正確的 E-Mail !!");
	alert_str.put("email.en","Please enter the correct E-Mail !!");
	alert_str.put("email.cn","请输入正确的 E-Mail !!");
	
	//alert_str.put("category.tw","請選擇產品項目 !!");
	//alert_str.put("category.en","Please select a product item !!");
	//alert_str.put("category.cn","请选择产品项目 !!");	

	alert_str.put("subject.tw","請輸入主旨 !!");
	alert_str.put("subject.en","Please enter the subject !!");
	
	alert_str.put("content.tw","請輸入訊息內容 !!");
	alert_str.put("content.en","Please enter the content !!");
	alert_str.put("content.cn","请输入讯息内容 !!");	
	
	alert_str.put("code.tw","請輸入驗證碼 !!");
	alert_str.put("code.en","Please enter verification code !!");
	alert_str.put("code.cn","请输入验证码 !!");

	alert_str.put("code_error.tw","您輸入的圖案文字錯誤 !!");
	alert_str.put("code_error.en","The text you entered is wrong");
	alert_str.put("code_error.cn","您输入的图案文字错误");	

	alert_str.put("system_error.tw","已完成您訊息的登錄，但系統發生通知信件發送失敗!!");
	alert_str.put("system_error.en","Your message has been completed login, file system failure occurrence notification letter sent!!");
	alert_str.put("system_error.cn","已完成您讯息的登录，档系统发生通知信件发送失败!!");	
	
	alert_str.put("system_bug.tw","系統發生異常，請聯絡管理者 !!");
	alert_str.put("system_bug.en","An error has occurred in the system. Please contact the administrator!!");
	alert_str.put("system_bug.cn","系统发生异常，请联络管理者 !!");	
	
	alert_str.put("contact.us.tw","您好，我們已收到您的訊息，以下為您填寫的資料，我們將會有專員儘速和您聯絡!");
	alert_str.put("contact.us.en","Hello, We've received your message. Here's the information you've filled out. We'll get someone to contact you as soon as possible.");
	alert_str.put("contact.us.cn","您好，我们已收到您的讯息，以下为您填写的资料，我们将会有专员尽速和您联络!");	
	
	alert_str.put("contact.alert.tw","此封信為系統自動寄發，請勿直接回信!!");
	alert_str.put("contact.alert.en","This message is automatically sent to the system, do not directly reply!!");
	alert_str.put("contact.alert.cn","此封信为系统自动寄发，请勿直接回信!!");	
	
	alert_str.put("contact.prompt.tw","感謝您的來信");
	alert_str.put("contact.prompt.en","Thank you for your letter");
	alert_str.put("contact.prompt.cn","感谢您的来信");	
	
%>
