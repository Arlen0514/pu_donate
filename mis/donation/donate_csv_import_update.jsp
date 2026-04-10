<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@ include file="/web/include/encryption.jsp"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Random" %>
<%@ page import="java.io.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%! 
	private String nvl(String val) { return val == null ? "" : val.trim(); }

	private java.util.List<String> parseCsvRecords(String content) {
		java.util.List<String> rows = new ArrayList<String>();
		StringBuilder sb = new StringBuilder();
		boolean inQuotes = false;
		for (int i = 0; i < content.length(); i++) {
			char c = content.charAt(i);
			if (c == '\"') {
				if (inQuotes && i + 1 < content.length() && content.charAt(i + 1) == '\"') {
					sb.append(c);
					sb.append(content.charAt(i + 1));
					i++;
				} else {
					inQuotes = !inQuotes;
					sb.append(c);
				}
			} else if ((c == '\n' || c == '\r') && !inQuotes) {
				if (c == '\r' && i + 1 < content.length() && content.charAt(i + 1) == '\n') i++;
				rows.add(sb.toString());
				sb.setLength(0);
			} else {
				sb.append(c);
			}
		}
		if (sb.length() > 0) rows.add(sb.toString());
		return rows;
	}

	private java.util.List<String> parseCsvRow(String row) {
		java.util.List<String> values = new ArrayList<String>();
		StringBuilder sb = new StringBuilder();
		boolean inQuotes = false;
		for (int i = 0; i < row.length(); i++) {
			char c = row.charAt(i);
			if (c == '\"') {
				if (inQuotes && i + 1 < row.length() && row.charAt(i + 1) == '\"') {
					sb.append('\"');
					i++;
				} else {
					inQuotes = !inQuotes;
				}
			} else if (c == ',' && !inQuotes) {
				values.add(sb.toString());
				sb.setLength(0);
			} else {
				sb.append(c);
			}
		}
		values.add(sb.toString());
		return values;
	}

	private String rocToAdDate(String roc) {
		String src = nvl(roc).replaceAll("[^0-9]", "");
		if (src.length() < 7) return "";
		try {
			String y = src.substring(0, src.length() - 4);
			String m = src.substring(src.length() - 4, src.length() - 2);
			String d = src.substring(src.length() - 2);
			int adYear = Integer.parseInt(y) + 1911;
			return adYear + "/" + m + "/" + d;
		} catch(Exception e) {
			return "";
		}
	}

	private String mapIdentityCode(String identity) {
		String val = nvl(identity);
		if ("靜宜校友".equals(val)) return "1";
		if ("靜宜教職員".equals(val)) return "2";
		if ("學生/家長".equals(val)) return "3";
		if ("企業機構".equals(val)) return "4";
		if ("社會人士".equals(val)) return "5";
		return "";
	}

	private String mapPayMethodCode(String pay) {
		String val = nvl(pay).toLowerCase();
		if ("".equals(val)) return "";
		if (val.contains("櫃台現金")) return "1";
		if (val.contains("信用卡")) return "newebpay.credit";
		if (val.contains("匯款") || val.contains("轉帳")) return "2";
		if (val.contains("line")) return "line";
		if (val.contains("街口")) return "jko";
		if (val.contains("定期")) return "newebpay.regular";
		return "";
	}
%>
<%
	String code = "donate";
	String show_title = "捐款CSV匯入結果";
	String[] requiredHeaders = new String[]{
		"捐贈日期","捐贈收據編號","身份別:","捐款人ID(不用隱碼)","捐款人名稱","捐款金額","畢業年分","班別",
		"辦理情況(指定捐贈用途)","捐贈者全銜","通訊地址","匿名","保留欄位","受贈類別*現金","保留欄位","捐款單編號","金額來源:(詳細付款方式)"
	};

	int totalCount = 0, updateSuccess = 0, insertSuccess = 0, failCount = 0;
	java.util.List<String> failDetails = new ArrayList<String>();
	java.util.List<String> notes = new ArrayList<String>();
	notes.add("欄位「通訊地址」目前僅先寫入 dh_address，未拆解 dh_zipcode / dh_county / dh_city。");
	notes.add("欄位「辦理情況(指定捐贈用途)」先對應 dh_donate_project_title。");
	notes.add("欄位「受贈類別*現金」為固定值，匯入時不回寫資料表。");

	byte[] uploadData = null;
	String fileName = "";
	try {
		DiskFileUpload fu = new DiskFileUpload();
		fu.setHeaderEncoding("UTF-8");
		fu.setSizeMax(10485760);
		java.util.List fileItems = fu.parseRequest(request);
		Iterator iter = fileItems.iterator();
		while(iter.hasNext()) {
			FileItem fi = (FileItem) iter.next();
			if(!fi.isFormField()) {
				fileName = nvl(fi.getName());
				uploadData = fi.get();
				break;
			}
		}
	} catch(Exception e) {
		failDetails.add("檔案上傳解析失敗：" + e.getMessage());
	}

	if(uploadData == null || uploadData.length == 0) {
		failDetails.add("未讀取到上傳檔案內容");
	} else if(!fileName.toLowerCase().endsWith(".csv")) {
		failDetails.add("僅接受 .csv 檔案");
	} else if(uploadData.length < 3 || (uploadData[0] & 0xFF) != 0xEF || (uploadData[1] & 0xFF) != 0xBB || (uploadData[2] & 0xFF) != 0xBF) {
		failDetails.add("檔案編碼必須為 UTF-8 BOM");
	} else {
		String content = new String(uploadData, 3, uploadData.length - 3, "UTF-8");
		java.util.List<String> rows = parseCsvRecords(content);
		if(rows.size() == 0) {
			failDetails.add("CSV 無資料列");
		} else {
			java.util.List<String> headers = parseCsvRow(rows.get(0));
			boolean headerOk = headers.size() == requiredHeaders.length;
			if(headerOk) {
				for(int i=0;i<requiredHeaders.length;i++) {
					if(!requiredHeaders[i].equals(nvl(headers.get(i)))) {
						headerOk = false;
						break;
					}
				}
			}
			if(!headerOk) {
				failDetails.add("CSV 標題列與匯出格式不一致，請使用系統匯出格式");
			} else {
				for(int r=1;r<rows.size();r++) {
					String rowText = rows.get(r);
					java.util.List<String> cols = parseCsvRow(rowText);
					boolean isBlankRow = true;
					for(int i=0;i<cols.size();i++){
						if(!"".equals(nvl(cols.get(i)))) { isBlankRow = false; break; }
					}
					if(isBlankRow) continue; // 空白列略過

					totalCount++;
					if(cols.size() < requiredHeaders.length) {
						failCount++;
						failDetails.add("第" + (r+1) + "列失敗：欄位數不足");
						continue;
					}

					String donateDateRoc = nvl(cols.get(0));
					String rsNo = nvl(cols.get(1));
					String identityText = nvl(cols.get(2));
					String donorIdRaw = nvl(cols.get(3));
					String donorName = nvl(cols.get(4));
					String amountText = nvl(cols.get(5));
					String identityYear = nvl(cols.get(6));
					String identityDept = nvl(cols.get(7));
					String donateUsage = nvl(cols.get(8));
					String donorFullName = nvl(cols.get(9));
					String address = nvl(cols.get(10));
					String anonymousText = nvl(cols.get(11));
					String donateNo = nvl(cols.get(15));
					String payDetailText = nvl(cols.get(16));

					String donateDate = rocToAdDate(donateDateRoc);
					if(!"".equals(donateDateRoc) && "".equals(donateDate)) {
						failCount++;
						failDetails.add("第" + (r+1) + "列失敗：捐贈日期格式錯誤");
						continue;
					}

					int amount = 0;
					try {
						if(!"".equals(amountText)) amount = Integer.parseInt(amountText.replaceAll(",", ""));
					} catch(Exception e) {
						failCount++;
						failDetails.add("第" + (r+1) + "列失敗：捐款金額格式錯誤");
						continue;
					}

					String identityCode = mapIdentityCode(identityText);
					String payMethodCode = mapPayMethodCode(payDetailText);
					String publicCode = "匿名".equals(anonymousText) ? "N" : "Y";
					String donorIdEncrypt = "".equals(donorIdRaw) ? "" : new AESDataEncryption().AESEncrypt(donorIdRaw);

					try {
						if(!"".equals(donateNo)) {
							TableRecord dh = app_sm.select(tbldh, "dh_code=? and dh_lang=? and dh_no=?", new Object[]{code, lang, donateNo});
							if("".equals(dh.getString("dh_id"))) {
								failCount++;
								failDetails.add("第" + (r+1) + "列失敗：捐款單編號不存在");
								continue;
							}
							dh.setValue("rs_no", rsNo);
							dh.setUpdate(app_account);
							app_sm.update(dh);
							updateSuccess++;
						} else {
							TableRecord dh = new TableRecord(tbldh);

							String idHead = "1044001";
							String seq = IDTool.getUID("donate", DateTimeTool.dateString(""), 4);
							int randomDigit = new Random().nextInt(10);
							String newDonateNo = idHead + seq + randomDigit;

							dh.setValue("dh_no", newDonateNo);
							dh.setValue("dh_donatedate", "".equals(donateDate) ? app_today : donateDate);
							dh.setValue("dh_name", "".equals(donorName) ? "善心人士" : donorName);
							dh.setValue("dh_pid", donorIdEncrypt);
							dh.setValue("dh_total", amount);
							dh.setValue("dh_identity", identityCode);
							dh.setValue("dh_identity_year", identityYear);
							dh.setValue("dh_identity_dept", identityDept);
							dh.setValue("dh_donate_project_title", donateUsage);
							dh.setValue("dh_receipt_title", "".equals(donorFullName) ? donorName : donorFullName);
							dh.setValue("dh_address", address);
							dh.setValue("dh_public", publicCode);
							dh.setValue("dh_paymethod", payMethodCode);
							dh.setValue("rs_no", rsNo);

							dh.setValue("dh_currency", "TWD");
							dh.setValue("rs_status", "N");
							dh.setValue("dh_mis", "Y");
							dh.setValue("dh_status", "Y");
							dh.setValue("dh_collect", "N");
							dh.setValue("dh_calculate", "N");
							dh.setValue("dh_lang", lang);
							dh.setValue("dh_code", code);
							dh.setInsert(app_account);
							app_sm.insert(dh);
							insertSuccess++;
						}
					} catch(Exception e) {
						failCount++;
						failDetails.add("第" + (r+1) + "列失敗：" + e.getMessage());
					}
				}
			}
		}
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><%=app_mistitle%></title>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/norobots.jspf"%>
</head>
<body class="default_body">
<div class="pageContent default_pageContent">
<div align="center" class="default_area">
  <table class="default_table" border="0" cellpadding="0" cellspacing="0">
    <tr><td colspan="2"><table border="0" cellspacing="0" cellpadding="0"><%@include file="/WEB-INF/jspf/mis/top.jspf"%></table></td></tr>
    <tr class="default_table_bottom page_mis">
      <td width="" align="center" valign="top" class="system_bk-2"><table width="100%" border="0" cellspacing="0" cellpadding="0"><%@include file="../leftmenu.jsp"%></table></td>
      <td width="99%" align="center" valign="top" class="system_bk-2p right_content_style">
        <table width="99%" border="0" cellspacing="0" cellpadding="0">
          <tr><td colspan="2" class="information_bk-2b">&nbsp;</td></tr>
          <tr><td colspan="2">&nbsp;</td></tr>
          <tr>
            <td width="60" align="left" valign="middle"><img src="../images/information_icon_1.gif" width="55" height="48"></td>
            <td align="left" valign="middle" class="information_bigword"><%=show_title %></td>
          </tr>
          <tr><td colspan="2"><hr size="1" noshade></td></tr>
          <tr>
            <td align="center" colspan="2">
              <table width="95%" border="0" cellspacing="1" cellpadding="0">
                <tr><td class="system_bk-2bk">
                  <table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
                    <tr><td align="center" class="information_title-1">CSV匯入結果</td></tr>
                    <tr class="information_table-2-1"><td>
                      總筆數：<%=totalCount%><br/>
                      成功更新筆數：<%=updateSuccess%><br/>
                      成功新增筆數：<%=insertSuccess%><br/>
                      失敗筆數：<%=failDetails.size()%><br/>
                    </td></tr>
                    <tr class="information_bk-2"><td>失敗明細</td></tr>
                    <tr class="information_table-2-1"><td>
                      <% if(failDetails.size()==0){ %>
                      	無
                      <% } else { for(String err : failDetails){ %>
                      	<%=err %><br/>
                      <% }} %>
                    </td></tr>
                    <tr class="information_bk-2"><td>欄位對應備註</td></tr>
                    <tr class="information_table-2-1"><td>
                      <% for(String note : notes){ %>
                      	<%=note %><br/>
                      <% } %>
                    </td></tr>
                    <tr class="information_table-2-1"><td align="center">
                      <input type="button" value="回CSV匯入頁" onclick="location.href='<%=code%>_csv_import.jsp';" />
                      <input type="button" value="回捐款列表" onclick="location.href='<%=code%>.jsp';" />
                    </td></tr>
                  </table>
                </td></tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</div>
</div>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>
