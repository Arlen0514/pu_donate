<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%
	/*-- 計算捐款累計金額 --*/
	// 捐款人列表
	Vector<TableRecord> mps = app_sm.selectAll(tblmp, "mp_code=?", 
			new Object[]{"member"}, "mp_createdate ASC");
	// 捐款紀錄列表(尚未統計過)
	Vector<TableRecord> dhs = app_sm.selectAll(tbldh, "dh_code=? and dh_status=? and dh_collect=? and dh_calculate=?", 
			new Object[]{"donate", "Y", "Y", "N"}, "dh_createdate ASC");
	// 捐款紀錄列表(統計過但已作廢)
	Vector<TableRecord> cancel_dhs = app_sm.selectAll(tbldh, "dh_code=? and dh_status=? and dh_collect=? and dh_calculate=?", 
			new Object[]{"donate", "N", "Y", "Y"}, "dh_createdate ASC");
	Map<String, Integer> member_donate_map = new HashMap<String, Integer>();	
	
	// 計算尚未統計的金額
	for(TableRecord dh:dhs){
		String key = dh.getString("mp_id");
		boolean has_key = member_donate_map.containsKey(key);
		int donate_total = 0;
		
		if(has_key) donate_total = member_donate_map.get(key);
		donate_total += dh.getInt("dh_total");
		member_donate_map.put(key, donate_total);
		
		dh.setValue("dh_calculate", "Y");
		dh.setUpdate("donate_accumulate");
		app_sm.update(dh);
	}
	
	// 計算要被扣除的金額
	for(TableRecord dh:cancel_dhs){
		String key = dh.getString("mp_id");
		boolean has_key = member_donate_map.containsKey(key);
		int donate_total = 0;
		
		if(has_key) donate_total = member_donate_map.get(key);
		donate_total -= dh.getInt("dh_total");
		member_donate_map.put(key, donate_total);
		
		dh.setValue("dh_calculate", "N");
		dh.setUpdate("donate_accumulate");
		app_sm.update(dh);
	}
	
	// 更新累計金額
	for(TableRecord mp:mps){
		String key = mp.getString("mp_id");
		boolean has_key = member_donate_map.containsKey(key);
		int mp_total = mp.getInt("mp_total");
		
		if(has_key){
			mp_total += member_donate_map.get(key);
			
			mp.setValue("mp_total", mp_total);
			mp.setUpdate("donate_accumulate");
			app_sm.update(mp);
		}
	}
	app_sm.close();
	
	JSONObject obj = new JSONObject();
	
	obj.put("status", true);
	out.clear();
	out.println(obj);
	
	return;
%>