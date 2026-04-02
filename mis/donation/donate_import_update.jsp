<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@ include file="/web/include/encryption.jsp"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<%@ page import="java.util.List" %>
<%!
    private static List<String> parseCsvLine(String line) {
        List<String> fields = new ArrayList<String>();
        if (line == null) return fields;
        StringBuilder field = new StringBuilder();
        boolean inQuotes = false;
        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);
            if (inQuotes) {
                if (c == '"') {
                    if (i + 1 < line.length() && line.charAt(i + 1) == '"') {
                        field.append('"');
                        i++;
                    } else {
                        inQuotes = false;
                    }
                } else {
                    field.append(c);
                }
            } else {
                if (c == '"') {
                    inQuotes = true;
                } else if (c == ',') {
                    fields.add(field.toString());
                    field = new StringBuilder();
                } else {
                    field.append(c);
                }
            }
        }
        fields.add(field.toString());
        return fields;
    }
%>
<%
    String code = "donate";
    String show_title = "捐款資訊匯入";
    String ul_file = "";

    try {
        String dir = app_uploadpath + "/import";
        DiskFileUpload fu = new DiskFileUpload();
        fu.setHeaderEncoding("UTF-8");
        fu.setSizeMax(4194304);
        fu.setSizeThreshold(4096);
        fu.setRepositoryPath(dir);
        List fileItems = fu.parseRequest(request);
        Iterator iter = fileItems.iterator();

        while (iter.hasNext()) {
            FileItem fi = (FileItem) iter.next();
            if (!fi.isFormField()) {
                int g = fi.getName().lastIndexOf("\\");
                String fileName = fi.getName();
                String fileName_1 = "";
                if (g < 0) {
                    fileName = fi.getName();
                    fileName_1 = fi.getName();
                } else {
                    fileName = fi.getName().substring(g);
                    fileName_1 = fileName.substring(1, fileName.length());
                }
                if (fileName != null && !"".equals(fileName)) {
                    fi.write(new File(dir, fileName_1));
                    ul_file = fileName_1;
                }
            }
        }
    } catch (Exception e) {
        System.out.println("Project:" + projectName + ", Error info:[" + e + "]File:donate_import_update.jsp Time:[" + DateTimeTool.dateTimeString() + "]");
        out.println("<script> alert('檔案上傳處理失敗，請與管理人員聯絡 !!'); history.back(); </script>");
    } finally {
        app_sm.close();
    }
%>
<html>
<head>
<%@include file="include/head.jsp"%>
<%@ include file="/WEB-INF/jspf/norobots.jspf" %>
<title><%=app_mistitle %></title>
<script language="JavaScript" type="text/JavaScript">
function checkform(F) { return true; }
</script>
</head>
<body class="default_body">
<div class="pageContent default_pageContent">
<div align="center" class="default_area">
  <table width="1280" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td colspan="2"><table width="1280" border="0" cellspacing="0" cellpadding="0">
        <%@ include file="/WEB-INF/jspf/mis/top.jspf" %>
      </table></td>
    </tr>
    <tr class="default_table_bottom page_mis">
      <td width="" align="center" valign="top" class="system_bk-2">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <%@include file="../leftmenu.jsp"%>
        </table>
      </td>
      <td width="99%" align="center" valign="top" class="system_bk-2p right_content_style">
        <table width="99%" border="0" cellspacing="0" cellpadding="0">
          <tr><td colspan="2" class="web_bk-2b">&nbsp;</td></tr>
          <tr><td colspan="2">&nbsp;</td></tr>
          <tr>
            <td width="8%" align="left" valign="middle"><img src="../images/web_icon_1.gif" width="55" height="48" /></td>
            <td width="92%" align="left" valign="middle" class="web_bigword"><%=show_title %></td>
          </tr>
          <tr><td colspan="2"><hr size="1" noshade></td></tr>
          <tr align="center">
            <td colspan="2"><table width="95%" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"><td class="web_title-1"><%=show_title %></td></tr>
                <tr class="web_bk-2"><td width="50%" align="center"><%=show_title %></td></tr>
                <tr class="web_table-2-1">
                    <td align="center">
                    <%
                    String csvFilePath = app_uploadpath + "/import/" + ul_file;
                    File csvFile = new File(csvFilePath);

                    String[] fieldname = {
                        "dh_donatedate","dh_total","dh_currency","dh_foreign_total",
                        "dh_donate_project_category","dh_donate_project","dh_donate_project_title",
                        "dh_donate_college","dh_donate_department","donate_project_dept","donate_project_dept_title",
                        "dh_donate_project_no","dh_donate_unit_title","dh_donate_attribute_title",
                        "dh_remark","dh_paymethod",
                        "dh_name","dh_pid","dh_cellphone","dh_phone","dh_foreign",
                        "dh_zipcode","dh_county","dh_city","dh_address","dh_email",
                        "dh_identity","dh_identity_year","dh_identity_dept","dh_identity_thank",
                        "dh_unit","dh_job",
                        "dh_receipt_status","dh_receipt_title","dh_receipt_zipcode",
                        "dh_receipt_county","dh_receipt_city","dh_receipt_address",
                        "dh_public","dh_tax"
                    };

                    String[] required_fields = { "dh_donatedate", "dh_total", "dh_paymethod", "dh_name" };

                    Map<String, Integer> headerIndex = new LinkedHashMap<String, Integer>();
                    String error_str = "";
                    int error_count = 0;
                    boolean all_can_into = true;
                    Vector<TableRecord> dhs = new Vector<TableRecord>();
                    Vector<TableRecord> rss = new Vector<TableRecord>();
                    int import_counter = 0;

                    if (!csvFile.exists()) {
                        error_str = "找不到上傳的 CSV 檔案。";
                        all_can_into = false;
                    } else {
                        InputStream fis2 = null;
                        InputStreamReader isr = null;
                        BufferedReader br = null;
                        try {
                            fis2 = new FileInputStream(csvFile);
                            fis2.mark(3);
                            byte[] bom = new byte[3];
                            int bomLen = fis2.read(bom);
                            if (!(bomLen == 3 && (bom[0] & 0xFF) == 0xEF && (bom[1] & 0xFF) == 0xBB && (bom[2] & 0xFF) == 0xBF)) {
                                fis2.reset();
                            }
                            isr = new InputStreamReader(fis2, "UTF-8");
                            br = new BufferedReader(isr);

                            String headerLine = br.readLine();
                            if (headerLine == null) {
                                error_str = "CSV 檔案為空。";
                                all_can_into = false;
                            } else {
                                List<String> headers = parseCsvLine(headerLine.trim());
                                for (int hi = 0; hi < headers.size(); hi++) {
                                    headerIndex.put(headers.get(hi).trim(), hi);
                                }

                                String csvLine;
                                int rowNum = 1;
                                while ((csvLine = br.readLine()) != null) {
                                    rowNum++;
                                    if (csvLine.trim().isEmpty()) continue;

                                    List<String> cols = parseCsvLine(csvLine);
                                    boolean hasData = false;
                                    for (String col : cols) {
                                        if (!col.trim().isEmpty()) { hasData = true; break; }
                                    }
                                    if (!hasData) continue;

                                    boolean has_error = false;
                                    Map<String, String> rowData = new HashMap<String, String>();
                                    for (String fn : fieldname) {
                                        Integer idx = headerIndex.get(fn);
                                        String val = "";
                                        if (idx != null && idx < cols.size()) {
                                            val = cols.get(idx).trim();
                                        }
                                        rowData.put(fn, val);
                                    }

                                    for (String reqF : required_fields) {
                                        if ("".equals(rowData.getOrDefault(reqF, ""))) {
                                            has_error = true;
                                            error_str += "第" + rowNum + "列，欄位 [" + reqF + "] 未填寫<br />";
                                        }
                                    }

                                    int dh_total_int = 0;
                                    String dh_total_str = rowData.getOrDefault("dh_total", "").replace(",", "");
                                    if (!"".equals(dh_total_str)) {
                                        try {
                                            dh_total_int = Integer.parseInt(dh_total_str);
                                        } catch (NumberFormatException nfe) {
                                            has_error = true;
                                            error_str += "第" + rowNum + "列，欄位 [dh_total] 不是有效數字<br />";
                                        }
                                    }

                                    if (has_error) {
                                        error_count++;
                                        continue;
                                    }

                                    import_counter++;

                                    TableRecord dh = new TableRecord(tbldh);
                                    for (String fn : fieldname) {
                                        if (!fn.startsWith("dh_")) continue;
                                        String val = rowData.getOrDefault(fn, "");
                                        if ("dh_pid".equals(fn) && !"".equals(val)) {
                                            val = new AESDataEncryption().AESEncrypt(val);
                                        }
                                        if ("dh_currency".equals(fn) && "".equals(val)) {
                                            val = "TWD";
                                        }
                                        if ("dh_receipt_status".equals(fn) && "".equals(val)) {
                                            val = "N";
                                        }
                                        dh.setValue(fn, val);
                                    }

                                    dh.setValue("dh_status", "Y");
                                    dh.setValue("dh_collect", "Y");
                                    dh.setValue("dh_lang", lang);
                                    dh.setValue("dh_code", code);
                                    dh.setValue("dh_no", IDTool.getUID(code, "M" + DateTimeTool.dateString(""), 4));
                                    // 收據 email 預設同聯絡 email（與原始匯入邏輯一致）
                                    if ("".equals(dh.getString("dh_receipt_email"))) {
                                        dh.setValue("dh_receipt_email", dh.getString("dh_email"));
                                    }

                                    try {
                                        String donatedate = dh.getString("dh_donatedate");
                                        String[] dateParts = donatedate.split("/");
                                        if (dateParts.length == 3) {
                                            int year1 = Integer.parseInt(dateParts[0]);
                                            String yearStr1 = String.format("%02d", year1 % 100);
                                            int month1 = Integer.parseInt(dateParts[1]);
                                            int day1 = Integer.parseInt(dateParts[2]);
                                            String mdStr1 = String.format("%02d%02d", month1, day1);
                                            String catId = dh.getString("dh_donate_project_category");
                                            TableRecord dm2 = catId.isEmpty() ? new TableRecord(tbldm) : app_sm.select(tbldm, catId);
                                            String catTitle = dm2.getString("dm_title");
                                            String key1 = catTitle + yearStr1 + mdStr1;
                                            String rs_no1 = IDTool.getUID("receipt", key1, 3);
                                            dh.setValue("rs_no", rs_no1);
                                        }
                                    } catch (Exception exRS) {}

                                    if ("Y".equals(dh.getString("dh_receipt_status"))) {
                                        dh.setValue("rs_status", "Y");
                                    }

                                    dh.setInsert(app_account);
                                    dhs.add(dh);

                                    if (!"".equals(dh.getString("rs_no"))) {
                                        TableRecord rs = new TableRecord(tblrs);
                                        String receiptTitle = dh.getString("dh_receipt_title");
                                        if ("".equals(receiptTitle)) receiptTitle = dh.getString("dh_name");
                                        rs.setValue("rs_no", dh.getString("rs_no"));
                                        rs.setValue("dh_order_name", receiptTitle);
                                        rs.setValue("dh_pid", dh.getString("dh_pid"));
                                        rs.setValue("dh_id", dh.getString("dh_id"));
                                        rs.setValue("dh_no", dh.getString("dh_no"));
                                        rs.setValue("dh_total", dh_total_int);
                                        rs.setValue("dh_order_county", dh.getString("dh_receipt_county"));
                                        rs.setValue("dh_order_city", dh.getString("dh_receipt_city"));
                                        rs.setValue("dh_order_zip_code", dh.getString("dh_receipt_zipcode"));
                                        rs.setValue("dh_order_address", dh.getString("dh_receipt_address"));
                                        rs.setValue("rs_donateitem", dh.getString("dh_donate_project_title"));
                                        rs.setValue("dh_donatedate", dh.getString("dh_donatedate"));
                                        rs.setValue("dh_receipt", dh.getString("dh_receipt_status"));
                                        rs.setValue("rs_status", "Y");
                                        String rs_type = dh.getString("dh_receipt_status").contains("single") ? "single" : "annual";
                                        rs.setValue("rs_type", rs_type);
                                        rs.setValue("rs_code", "receipt");
                                        try {
                                            TableRecord stamp = app_sm.select(tblcp, "cp_code=? and cp_lang=?", new Object[]{"receipt_stamp", lang});
                                            rs.setValue("rs_handle", stamp.getString("cp_content"));
                                            rs.setValue("rs_stamp", stamp.getString("cp_image"));
                                            rs.setValue("rs_stamp2", stamp.getString("cp_image2"));
                                            rs.setValue("rs_stamp3", stamp.getString("cp_image3"));
                                            rs.setValue("rs_stamp4", stamp.getString("cp_image4"));
                                        } catch (Exception exStamp) {}
                                        rs.setValue("rs_lang", lang);
                                        rs.setInsert(app_account);
                                        rss.add(rs);
                                        dh.setValue("rs_id", rs.getString("rs_id"));
                                        dh.setValue("rs_status", "Y");
                                    }
                                }
                            }
                        } catch (Exception ex3) {
                            error_str += "CSV 解析失敗：" + ex3.getMessage() + "<br />";
                            all_can_into = false;
                        } finally {
                            if (br != null) try { br.close(); } catch (Exception e2) {}
                            if (isr != null) try { isr.close(); } catch (Exception e2) {}
                            if (fis2 != null) try { fis2.close(); } catch (Exception e2) {}
                        }
                    }

                    error_str += "總錯誤筆數：" + error_count;
                    if (error_count > 0) all_can_into = false;

                    if (all_can_into) {
                        for (TableRecord dh : dhs) {
                            app_sm.insert(dh);
                            if ("single_e".equals(dh.getString("dh_receipt_status"))) {
                                TableRecord mr = new TableRecord(tblmr);
                                String subject = SiteSetup.getText("cp.company." + lang) + " 電子收據通知信";
                                mr.setValue("data_id", dh.getString("rs_id"));
                                mr.setValue("mr_recipient", dh.getString("dh_receipt_email"));
                                mr.setValue("mr_subject", subject);
                                mr.setValue("mr_status", "N");
                                mr.setValue("mr_mail", "R");
                                mr.setValue("mr_type", "A");
                                mr.setValue("mr_priority", "B");
                                mr.setValue("mr_code", "mail");
                                mr.setValue("mr_lang", lang);
                                mr.setInsert("Web_User");
                                app_sm.insert(mr);
                            }
                        }
                        for (TableRecord rs : rss) {
                            app_sm.insert(rs);
                        }
                    }

                    FileTool.deleteFile(app_uploadpath + "/import/" + ul_file);

                    String finish_str = "匯入處理完成，共匯入 " + import_counter + " 筆。";
                    if (!all_can_into) {
                        finish_str = "資料匯入失敗，請修正錯誤後重新上傳。";
                    }
                    %>
                    <br/><br/>
                    <span><B><%=finish_str %></B><br /><%=error_str %></span>
                    </td>
                </tr>
            </table></td>
          </tr>
          <tr><td colspan="2">&nbsp;</td></tr>
          <tr><td colspan="2" class="web_bk-2b"></td></tr>
        </table>
      </td>
    </tr>
  </table>
</div>
</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>
