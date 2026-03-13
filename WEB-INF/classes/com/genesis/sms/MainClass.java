package com.genesis.sms;
import com.genesis.sms.SMSHttpService;

public class MainClass {

	/**
	 * @param args
	 * @return 
	 * @return 
	 * @return 
	 */
	public String getPost(String userID, String password, String subject, String content, String mobile, String sendTime, String fuction){
	// TODO Auto-generated method stub
		SMSHttpService sms=new SMSHttpService();
		
		String sendresult ="";
		
		if(fuction.equals("credit")) {
			if(sms.getCredit(userID, password)){
				//System.out.println(new StringBuffer("取得餘額成功，餘額：").append(String.valueOf(sms.getCreditValue())).toString());
				sendresult ="發送簡訊查詢成功，餘額："+String.valueOf(sms.getCreditValue()).toString();
			}else{
				//System.out.println(new StringBuffer("取得餘額失敗，失敗原因：").append(sms.getProcessMsg()).toString());
				sendresult ="發送簡訊查詢失敗，原因："+String.valueOf(sms.getProcessMsg()).toString();
			}
		}else if(fuction.equals("sms")) {
			if(sms.sendSMS(userID, password, subject, content, mobile, sendTime)){
				//System.out.println(new StringBuffer("發送簡訊成功，餘額：").append(String.valueOf(sms.getCreditValue())).append("，簡訊批號：").append(sms.getBatchID()).toString());
				sendresult ="發送簡訊成功，餘額："+String.valueOf(sms.getCreditValue()).toString()+"，簡訊批號："+(sms.getBatchID()).toString();
			}else{
				//System.out.println(new StringBuffer("發送簡訊失敗，失敗原因：").append(sms.getProcessMsg()).toString());
				sendresult ="發送簡訊失敗，失敗原因："+String.valueOf(sms.getProcessMsg()).toString();
			}
		}
		return sendresult ; 
	  }
}
