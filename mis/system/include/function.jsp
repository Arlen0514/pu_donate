<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%!
public boolean num_check(int limit,Vector datas){
	if(limit < 0) return true;
	if(datas.size()<limit){
		return true;
	}else{
		return false;
	}
}
%>
