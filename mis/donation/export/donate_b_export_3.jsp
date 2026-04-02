<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@ include file="/web/include/encryption.jsp"%>
<%@ page import="java.util.List"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.io.*"%>
<%
// 以利前端檢查時，了解正在進行檔案匯出的工作
session.setAttribute("donate_b_export_3_file","start");

String code = "donate";
String fileLocation = app_uploadpath + "/root/report/";
String fileName = app_account + "_donate_b_export_3.csv";

// Conditions.
String qname    = StringTool.validString(request.getParameter("_qname"));
String qphone   = StringTool.validString(request.getParameter("_qphone"));
String qdhno    = StringTool.validString(request.getParameter("_qdhno"));
String qpayment = StringTool.validString(request.getParameter("_qpayment"),"");
String qemitdate = StringTool.validString(request.getParameter("_qemitdate"));
String qrestdate = StringTool.validString(request.getParameter("_qrestdate"));
String qposition = StringTool.validString(request.getParameter("_qposition"));
String qcollect  = StringTool.validString(request.getParameter("_qcollect"));

// Get records.
StringBuffer sb = new StringBuffer();
Vector keys = new Vector();
sb.append("dh_code=? AND dh_lang=?");
keys.add(code);
keys.add(lang);
sb.append(" and dh_no like ?");
keys.add("%"+qdhno+"%");
sb.append(" and dh_collect like ?");
keys.add("%"+qcollect+"%");
sb.append(" and dh_status like ? and dh_name like ?");
keys.add("%"+qposition+"%");
keys.add("%"+qname+"%");
sb.append(" and dh_cellphone like ?");
keys.add("%"+qphone+"%");
sb.append(" and dh_paymethod like ?");
keys.add("%"+qpayment+"%");
sb.append(" and !(dh_createdate>? || dh_createdate<?)");
keys.add(qrestdate+" 24:00:00");
keys.add(qemitdate);

Vector<TableRecord> dhs = app_sm.selectAll(tbldh, sb.toString(), keys.toArray(), "dh_createdate DESC");

if (dhs == null || dhs.size() == 0) {
out.write("<script>alert('查無資料可供匯出！');</script>");
session.setAttribute("donate_b_export_3_file", "no");
return;
}

// 付款方式對照表
Vector<TableRecord> payments = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=?",
new Object[]{"guide", lang}, "cp_showseq ASC, cp_createdate DESC");
Map<String, String> payment_title_map = new HashMap<String, String>();
for (TableRecord payment : payments)
payment_title_map.put(payment.getString("cp_category"), payment.getString("cp_title"));

// 受贈類別對照表
Vector<TableRecord> dms = app_sm.selectAll(tbldm, "dm_code=? and dm_lang=?",
new Object[]{"donate_category", lang}, "dm_showseq ASC, dm_createdate DESC");
Map<String, String> dm_title_map = new HashMap<String, String>();
for (TableRecord dm : dms)
dm_title_map.put(dm.getString("dm_id"), dm.getString("dm_title"));

File outputFolder = new File(fileLocation);
if (!outputFolder.exists()) outputFolder.mkdir();
File outputFile = new File(outputFolder, fileName);
if (outputFile.exists()) outputFile.delete();

FileOutputStream fos = new FileOutputStream(outputFile);
fos.write(0xEF); fos.write(0xBB); fos.write(0xBF);
OutputStreamWriter ow = new OutputStreamWriter(fos, "UTF-8");

// CSV B套欄位標題
String[] titles = {
"捐贈日期", "捐贈收據編號", "身份別:", "捐款人ID(不用隱碼)", "捐款人名稱",
"捐款金額", "畢業年分", "班別", "辦理情況(指定捐贈用途)", "捐贈者全銜",
"通訊地址", "匿名", "保留欄位", "受贈類別", "保留欄位",
"捐款單編號", "金額來源:(詳細付款方式)"
};

// 寫標題列
StringBuilder headerSb = new StringBuilder();
for (int t = 0; t < titles.length; t++) {
if (t > 0) headerSb.append(",");
headerSb.append("\"").append(titles[t].replace("\"", "\"\"")).append("\"");
}
ow.write(headerSb.toString());
ow.write("\r\n");

// 寫資料（欄位值使用雙引號包覆，內含雙引號以 "" 跳脫）
for (TableRecord dh : dhs) {
String dh_pid_plain = "";
try {
dh_pid_plain = new AESDataEncryption().AESDecrypt(dh.getString("dh_pid"));
} catch (Exception ep) { dh_pid_plain = ""; }

String paymethod_title = payment_title_map.containsKey(dh.getString("dh_paymethod"))
? payment_title_map.get(dh.getString("dh_paymethod")) : dh.getString("dh_paymethod");

String cat_title = dm_title_map.containsKey(dh.getString("dh_donate_project_category"))
? dm_title_map.get(dh.getString("dh_donate_project_category")) : dh.getString("dh_donate_project_category");

String address = dh.getString("dh_zipcode")
+ dh.getString("dh_county")
+ dh.getString("dh_city")
+ dh.getString("dh_address");

String anonymous = "Y".equals(dh.getString("dh_public")) ? "1" : "0";

String receipt_title = dh.getString("dh_receipt_title");
if ("".equals(receipt_title)) receipt_title = dh.getString("dh_name");

String[] values = {
dh.getString("dh_donatedate"),
dh.getString("rs_no"),
dh.getString("dh_identity"),
dh_pid_plain,
dh.getString("dh_name"),
String.valueOf(dh.getInt("dh_total")),
dh.getString("dh_identity_year"),
dh.getString("dh_identity_dept"),
dh.getString("dh_donate_project_title"),
receipt_title,
address,
anonymous,
"",
cat_title,
"",
dh.getString("dh_no"),
paymethod_title
};

StringBuilder rowSb = new StringBuilder();
for (int v = 0; v < values.length; v++) {
if (v > 0) rowSb.append(",");
String val = values[v] == null ? "" : values[v];
rowSb.append("\"").append(val.replace("\"", "\"\"")).append("\"");
}
ow.write(rowSb.toString());
ow.write("\r\n");
}

ow.flush();
ow.close();

// 下載 CSV
if (outputFile.exists() && outputFile.isFile()) {
try {
String mimetype = getServletConfig().getServletContext().getMimeType(fileLocation + fileName);
response.setContentType((mimetype != null) ? mimetype : "application/octet-stream");
response.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20") + "\"");
OutputStream output = response.getOutputStream();
InputStream in = new FileInputStream(outputFile);
byte[] b = new byte[2048];
int len;
while ((len = in.read(b)) > 0) output.write(b, 0, len);
in.close();
output.flush();
output.close();
out.clear();
out = pageContext.pushBody();
} catch (Exception ex) {
out.println("<script> alert('檔案處理失敗'); history.back(); </script>");
return;
}
} else {
out.println("<script> alert('此檔案不存在'); history.back(); </script>");
return;
}

// 以利前端檢查時，了解已完成檔案匯出的工作
session.setAttribute("donate_b_export_3_file", "end");
%>
