<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>

<%
String dh_no = "";

String idHead = "1044001";	
String seq = IDTool.getUID("donate", DateTimeTool.dateString(""), 4);
Random rand = new Random(); 
int randomDigit = rand.nextInt(10);

dh_no = idHead + seq + randomDigit ;

System.out.println("dh_no :"+dh_no);
%> 