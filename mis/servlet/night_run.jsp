<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@page import="javax.mail.*"%>
<%@page import="javax.mail.internet.*"%>
<%@page import="javax.activation.*"%>
<%@page import="java.net.ProtocolException"%>
<%!
class Execution extends TimerTask {

	protected Execution(String path)  {		
		url_str=path;
	}
	
	@Override
	public void run() {
		// TODO Auto-generated method stub
		clock5(url_str);
	}
	private void clock5(String s) {
		try {
			url=new URL(url_str);
			connection=(HttpURLConnection) url.openConnection();
			connection.setRequestMethod("POST");
			connection.setDoOutput(true);
			connection.connect();
			System.out.println("connection.getResponseCode()="+connection.getResponseCode());
			System.out.println("connection.getResponseMessage()="+connection.getResponseMessage());
			connection.disconnect();
		} catch (ProtocolException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	private HttpServletRequest request;
	private HttpServletResponse response;
	private URL url;
	private HttpURLConnection connection;
	private String url_str;

}
%>
<%
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

	Vector<TableRecord> nrs = app_sm.selectAll(tblnr, "nr_code=? and nr_status=?",
			new Object[]{ "run", "Y" }, "nr_createdate DESC");
	
	for(TableRecord nr:nrs) {	
		// site
		Timer timer = new Timer();

		String today = DateTimeTool.dateString()+" ";
		int interval = 300000;										// 重複時間毫秒數
		String path = nr.getString("nr_path");						// 程式路徑
		String schedule_patten = nr.getString("nr_patten");			// 模式  TS:在特定時間單次執行/TR:在特定時間後重複執行/DS:在特定delay後單次執行/DR:在特定delay後重複執行
		String schedule_patten_time = "00:00:00";					// 開始時間
		long schedule_patten_delay = 0;								// 延遲時間毫秒數

		if(!nr.getString("nr_day").isEmpty()) today = nr.getString("nr_day")+ " ";
		if(nr.getInt("nr_interval") > 0) interval = nr.getInt("nr_interval")*1000;
		if(nr.getInt("nr_delay") > 0) schedule_patten_delay = nr.getInt("nr_delay")*1000;
		if(!nr.getString("nr_time").isEmpty()) schedule_patten_time = nr.getString("nr_time");

		Execution exec = new Execution(path);

		if(schedule_patten.equals("TS")) {
			System.out.println("特定時間跑一次，超過時間會馬上跑，名稱："+nr.getString("nr_title")+"，日期時間:"+today+schedule_patten_time);
			timer.schedule(exec, new Date(today + schedule_patten_time));
		} else if(schedule_patten.equals("TR")) {
			Date use = sdf.parse(today + schedule_patten_time);
			Date new_ = new Date();

			if(new_.after(use)) {
				Calendar yesDate = Calendar.getInstance();
				yesDate.setTime(use);
				yesDate.add(Calendar.DAY_OF_MONTH, +1);
				use = yesDate.getTime();
			}
			System.out.println("特定時間開始，重複時間在跑一次，名稱："+nr.getString("nr_title")+"，日期時間:"+today+schedule_patten_time+"，重複毫秒："+interval);
			timer.schedule(exec, use, interval);
		} else if(schedule_patten.equals("DS")) {
			System.out.println("網站起動後延遲一定時間後跑一次，名稱："+nr.getString("nr_title")+"，延遲毫秒："+schedule_patten_delay+"，重複毫秒："+interval);
			timer.schedule(exec, schedule_patten_delay);
		} else {
			System.out.println("延遲一段時間後開始，重複時間在跑一次，名稱："+nr.getString("nr_title")+"，延遲毫秒："+schedule_patten_delay+"，重複毫秒："+interval);
			timer.schedule(exec, schedule_patten_delay, interval);
		}
	}
%>