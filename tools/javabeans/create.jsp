<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="com.genesis.util.*" %>
<%@ page import="java.io.*" %>
<!--
   @version 2.0
   @date 2005/07/29
   @author Kevin Koo
-->
<%
    // Server type
    // "0" for MySQL, "1" for MsSQL.
    String type = StringTool.validString(request.getParameter("type"), "0");
    int server = Integer.parseInt(type);
    // Java source path.
    String srcpath = request.getRealPath("");    
    srcpath = srcpath.substring(0, srcpath.lastIndexOf(File.separator))+File.separator+"src";
    // Create java bean sources.
    BeanCreator bc = new BeanCreator(srcpath, server);
    // Output the tables.
    out.println(bc.getOutput());
%>
<br>Beans creation completed!!