<%@ page language="java" contentType="text/csv; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@ include file="/web/include/encryption.jsp"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.Map" %>
<%!
	private String nvl(String value) {
		return value == null ? "" : value.trim();
	}

	private String csvEscape(String value) {
		String txt = nvl(value);
		if (txt.contains("\"")) txt = txt.replace("\"", "\"\"");
		if (txt.contains(",") || txt.contains("\"") || txt.contains("\n") || txt.contains("\r")) {
			txt = "\"" + txt + "\"";
		}
		return txt;
	}

	private String toRocDate(String source) {
		String src = nvl(source).replaceAll("[^0-9]", "");
		if (src.length() < 8) return "";
		try {
			int y = Integer.parseInt(src.substring(0, 4)) - 1911;
			String m = src.substring(4, 6);
			String d = src.substring(6, 8);
			return String.valueOf(y) + m + d;
		} catch (Exception e) {
			return "";
		}
	}

	private String mapIdentity(String identity) {
		String key = nvl(identity);
		if ("1".equals(key)) return "靜宜校友";
		if ("2".equals(key)) return "靜宜教職員";
		if ("3".equals(key)) return "學生/家長";
		if ("4".equals(key)) return "企業機構";
		if ("5".equals(key)) return "社會人士";
		return "";
	}

	private String mapPaymentDetail(String payMethodCode, String defaultTitle) {
		String code = nvl(payMethodCode);
		String title = nvl(defaultTitle);

		if ("1".equals(code) || code.contains("cash")) return "櫃台現金";
		if ("2".equals(code) || code.contains("atm") || code.contains("vatm")) return "匯款轉帳";
		if (code.contains("credit")) return "信用卡刷卡";
		if (code.contains("line")) return "LINE PAY";
		if (code.contains("jko")) return "街口支付";
		if (code.contains("regular")) return "定期定額";
		if ("".equals(title)) return code;
		return title;
	}
%>
<%
	String code = "donate";

	// Conditions. (沿用 donate.jsp / donate_export.jsp)
	String qname = StringTool.validString(request.getParameter("_qname"));
	String qphone = StringTool.validString(request.getParameter("_qphone"));
	String qdhno = StringTool.validString(request.getParameter("_qdhno"));
	String qpayment = StringTool.validString(request.getParameter("_qpayment"), "");
	String qemitdate = StringTool.validString(request.getParameter("_qemitdate"));
	String qrestdate = StringTool.validString(request.getParameter("_qrestdate"));
	String qposition = StringTool.validString(request.getParameter("_qposition"), "Y");
	String qcollect	 = StringTool.validString(request.getParameter("_qcollect"));

	String def_qrestdate = "2099/12/31";
	String def_qemitdate = DateTimeTool.dateString(DateTimeTool.getYear() - 1, DateTimeTool.getMonth(), DateTimeTool.getDay());
	if("".equals(qemitdate)) { qemitdate = def_qemitdate; }
	if("".equals(qrestdate)) { qrestdate = def_qrestdate; }

	// Query.
	StringBuffer sb = new StringBuffer();
	Vector keys = new Vector();
	sb.append("dh_code=? AND dh_lang=?");
	keys.add(code);
	keys.add(lang);
	sb.append(" and dh_no like ?");
	keys.add("%" + qdhno + "%");
	sb.append(" and dh_collect like ?");
	keys.add("%" + qcollect + "%");
	sb.append(" and dh_status like ? and dh_name like ?");
	keys.add("%" + qposition + "%");
	keys.add("%" + qname + "%");
	sb.append(" and dh_cellphone like ?");
	keys.add("%" + qphone + "%");
	sb.append("and dh_paymethod like ?");
	keys.add("%" + qpayment + "%");
	sb.append(" and !(dh_createdate>? || dh_createdate<?)");
	keys.add(qrestdate + " 24:00:00");
	keys.add(qemitdate);

	Vector<TableRecord> dhs = app_sm.selectAll(tbldh, sb.toString(), keys.toArray(), "dh_createdate DESC");

	// 付款方式對照
	Vector<TableRecord> payments = app_sm.selectAll(tblcp, "cp_code=? and cp_lang=? and cp_display=?",
			new Object[]{"guide", lang, "Y"}, "cp_showseq ASC, cp_createdate DESC");
	Map<String, String> paymentTitleMap = new LinkedHashMap<String, String>();
	for (TableRecord payment:payments) {
		paymentTitleMap.put(payment.getString("cp_category"), payment.getString("cp_title"));
	}

	response.reset();
	response.setCharacterEncoding("UTF-8");
	response.setContentType("text/csv; charset=UTF-8");
	response.setHeader("Content-Disposition", "attachment; filename=\"donation_export.csv\"; filename*=UTF-8''" + URLEncoder.encode("donation_export.csv", "UTF-8"));

	String[] headers = new String[]{
		"捐贈日期",
		"捐贈收據編號",
		"身份別:",
		"捐款人ID(不用隱碼)",
		"捐款人名稱",
		"捐款金額",
		"畢業年分",
		"班別",
		"辦理情況(指定捐贈用途)",
		"捐贈者全銜",
		"通訊地址",
		"匿名",
		"保留欄位",
		"受贈類別*現金",
		"保留欄位",
		"捐款單編號",
		"金額來源:(詳細付款方式)"
	};

	StringBuilder csv = new StringBuilder();
	for(int i=0;i<headers.length;i++) {
		if(i>0) csv.append(",");
		csv.append(csvEscape(headers[i]));
	}
	csv.append("\r\n");

	AESDataEncryption ade = new AESDataEncryption();
	for(TableRecord dh : dhs) {
		String payMethodCode = dh.getString("dh_paymethod");
		String payMethodTitle = paymentTitleMap.containsKey(payMethodCode) ? paymentTitleMap.get(payMethodCode) : "";
		String donateDate = toRocDate(dh.getString("dh_donatedate"));
		String receiptNo = nvl(dh.getString("rs_no"));
		if("".equals(receiptNo)) receiptNo = nvl(dh.getString("dr_no"));

		String donorId = nvl(dh.getString("dh_pid"));
		if(donorId.contains("==")) {
			try { donorId = nvl(ade.AESDecrypt(donorId)); } catch(Exception e) {}
		}

		String donorName = nvl(dh.getString("dh_name"));
		String amount = String.valueOf(dh.getInt("dh_total"));
		String identityYear = nvl(dh.getString("dh_identity_year"));
		String identityDept = nvl(dh.getString("dh_identity_dept"));
		String identity = mapIdentity(dh.getString("dh_identity"));
		String usage = nvl(dh.getString("dh_donate_project_title"));
		String usageMemo = nvl(dh.getString("dh_memo"));
		if(!"".equals(usageMemo)) usage = "".equals(usage) ? usageMemo : (usage + " / " + usageMemo);

		// 註：系統中無「捐贈者全銜」專用欄位，先以收據抬頭為主，無值則帶捐款人名稱。
		String donorFullName = nvl(dh.getString("dh_receipt_title"));
		if("".equals(donorFullName)) donorFullName = donorName;

		String address = nvl(dh.getString("dh_zipcode")) + nvl(dh.getString("dh_county")) + nvl(dh.getString("dh_city")) + nvl(dh.getString("dh_address"));
		String anonymous = "N".equals(nvl(dh.getString("dh_public"))) ? "匿名" : "不匿名";
		String donateNo = nvl(dh.getString("dh_no"));
		String paymentDetail = mapPaymentDetail(payMethodCode, payMethodTitle);

		String[] values = new String[]{
			donateDate,
			receiptNo,
			identity,
			donorId,
			donorName,
			amount,
			identityYear,
			identityDept,
			usage,
			donorFullName,
			address,
			anonymous,
			"",
			"現金",
			"",
			donateNo,
			paymentDetail
		};

		for(int i=0;i<values.length;i++) {
			if(i>0) csv.append(",");
			csv.append(csvEscape(values[i]));
		}
		csv.append("\r\n");
	}

	ServletOutputStream os = response.getOutputStream();
	os.write(new byte[]{(byte)0xEF, (byte)0xBB, (byte)0xBF}); // UTF-8 BOM
	os.write(csv.toString().getBytes("UTF-8"));
	os.flush();
	os.close();
%>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>
