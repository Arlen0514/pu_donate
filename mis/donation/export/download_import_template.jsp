<%@ page language="java" contentType="application/octet-stream" pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
    // 捐款單批次匯入 CSV 範本下載（UTF-8 with BOM）
    String fileName = "donate_import_template.csv";
    response.setContentType("text/csv; charset=UTF-8");
    response.setHeader("Content-Disposition",
        "attachment; filename=\"" + URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20") + "\"");

    StringBuilder sb = new StringBuilder();
    // 欄位標題列（對應 donate_a.jsp 表單欄位）
    sb.append("dh_donatedate,dh_total,dh_currency,dh_foreign_total,dh_donate_project_category,dh_donate_project,dh_donate_project_title,dh_donate_college,dh_donate_department,donate_project_dept,donate_project_dept_title,dh_donate_project_no,dh_donate_unit_title,dh_donate_attribute_title,dh_remark,dh_paymethod,dh_name,dh_pid,dh_cellphone,dh_phone,dh_foreign,dh_zipcode,dh_county,dh_city,dh_address,dh_email,dh_identity,dh_identity_year,dh_identity_dept,dh_identity_thank,dh_unit,dh_job,dh_receipt_status,dh_receipt_title,dh_receipt_zipcode,dh_receipt_county,dh_receipt_city,dh_receipt_address,dh_public,dh_tax\r\n");
    // 範例資料列
    sb.append("2025/04/01,10000,TWD,,DM_CAT_001,CP_PROJ_001,校務發展基金,,,,,,,,捐款備註,jko,王大明,A123456789,0912345678,0212345678,N,100,台北市,中正區,中正路一段1號,test@example.com,alumni,113,資訊工程學系,王大明先生,某公司,工程師,Y,王大明,100,台北市,中正區,中正路一段1號,Y,Y\r\n");

    OutputStream out2 = response.getOutputStream();
    // 寫 UTF-8 BOM
    out2.write(0xEF);
    out2.write(0xBB);
    out2.write(0xBF);
    out2.write(sb.toString().getBytes("UTF-8"));
    out2.flush();
    out2.close();
    out.clear();
    out = pageContext.pushBody();
%>
