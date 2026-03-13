<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
// 相關參數設定
String code 		= "donate";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
String rl_code 		= "receipt";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
String show_title 	= "單筆收據開立作業";			// 功能標題
int page_items		= 15;						// 列表分頁筆數設定
String del_switch	= "on"; 					// 若不允許資料刪除 , 請設定 "off" 


// Conditions.
String qposition = StringTool.validString(request.getParameter("_qposition"));
String qcollect	 = StringTool.validString(request.getParameter("_qcollect"));
String qship	 = StringTool.validString(request.getParameter("_qship"));
String qpayment = StringTool.validString(request.getParameter("_qpayment"));
String qivoice = StringTool.validString(request.getParameter("_qivoice"));

String qdhno = StringTool.validString(request.getParameter("_qdhno"));
String qname = StringTool.validString(request.getParameter("_qname"));
String qphone = StringTool.validString(request.getParameter("_qphone"));
String qemitdate = StringTool.validString(request.getParameter("_qemitdate"));
String qrestdate = StringTool.validString(request.getParameter("_qrestdate"));

String qrlno	 = StringTool.validString(request.getParameter("_qrlno"));
String action = StringTool.validString(request.getParameter("action"));

if("".equals(qposition)) {qposition = "Y";}
if("".equals(qcollect)) {qcollect = "%";}
if("".equals(qship)) {qship = "%";}
/*
if("".equals(qrlno)) {qrlno = "%";}
*/

String def_qrestdate = "2099/12/31" , def_qemitdate = DateTimeTool.dateString(DateTimeTool.getYear()-1,DateTimeTool.getMonth(),DateTimeTool.getDay());
if("".equals(qemitdate)) {qemitdate = def_qemitdate;}
if("".equals(qrestdate)) {qrestdate = def_qrestdate;}

// Names and values.
String[] names = new String[] { "npage", "_qposition", "_qname", "_qemitdate", "_qrestdate", "_qship", "_qcollect","_qdhno","_qpayment","_qivoice","_qrlno", "action"};
String[] values = new String[] { String.valueOf(pageno), qposition, qname, qemitdate, qrestdate, qship, qcollect, qdhno,qpayment,qivoice,qrlno, action };

Vector dhs = app_sm.selectAll(tbldh , "dh_code=? AND dh_lang=?",  new Object[] { code, lang });

// Get records.
StringBuffer sb = new StringBuffer();
Vector keys = new Vector();

sb.append("dh_code=? AND dh_lang=?");
keys.add(code);
keys.add(lang);
sb.append(" and dh_no like ?");
keys.add("%"+qdhno+"%");
sb.append(" and dh_collect like ? ");
keys.add("%"+qcollect+"%");
sb.append(" and rs_no like ?");//收據編碼
keys.add("%"+qrlno+"%");
sb.append(" and dh_status like ? ");//and dh_receipt_title like ?
keys.add("%"+qposition+"%");
// keys.add("%"+qname+"%");
sb.append(" and dh_phone like ?");
keys.add("%"+qphone+"%");
sb.append("and dh_paymethod like ?");
keys.add("%"+qpayment+"%");
// sb.append(" and dh_receipt_type<>? and dh_receipt_type<>?");
// keys.add("年度收據");
// keys.add("不開立收據");

sb.append("and rs_no like ?");
keys.add("%"+qrlno+"%");
sb.append(" and !(dh_createdate>? || dh_createdate<?)");
keys.add(qrestdate+" 24:00:00");
keys.add(qemitdate);
dhs = app_sm.selectAll(tbldh, sb.toString(), keys.toArray() , "dh_createdate DESC");

// 分頁
out.write(HtmlCoder.getForm("pageform", request.getRequestURI(), names, values));
app_dp = new DataPager(dhs,page_items);			// 設定資料分頁每頁筆數
dhs = app_dp.getPageContent(pageno);

String rs_no_add = StringTool.validString(request.getParameter("rs_no_add"),"");
String [] rl_add_id = rs_no_add.split(",");


int all_money = 0;				//護持項目費用總計
String rs_donateitem = "";		//護持項目

String one_id = "";
for(int i=0;i<rl_add_id.length;i++){
	if(i==0){
		one_id = rl_add_id[i];//第一筆的id
	}
	String dhid = rl_add_id[i];
	TableRecord dh = app_sm.select(tbldh, dhid);
	if(dh.getString("dh_collect").equals("N"))out.println("<script>alert('提醒!收據標號內有未尚未付款之捐款單-捐款單編號:"+dh.getString("dh_no")+"');history.back();;</script>");
	all_money += dh.getInt("dh_total");
	//護持項目
	TableRecord dh_donateitem = app_sm.select(tbldm, dh.getString("dh_donate_item"));
	rs_donateitem = rs_donateitem + dh_donateitem.getString("dm_title") +" ";
}

//第一筆預設帶值用
TableRecord dh = app_sm.select(tbldh , "dh_id=? and dh_lang=? and dh_code=?",new Object[] {one_id, lang , code});
   
%>
<html><!-- InstanceBegin template="/Templates/basic.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/norobots.jspf"%>
<!-- InstanceBeginEditable name="doctitle" -->
<title><%=app_mistitle%></title>
<!-- InstanceEndEditable -->
<script language="JavaScript" type="text/JavaScript">

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function checkform(F) {
	var isEmail = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;  // 使用 isEmail.test(欄位名稱) 檢查 E-Mail 是否格式正確 , 正確為 true

	if (F.dh_order_county.value == "") {
	    alert("請輸入縣市!!");
	    F.dh_order_county.focus();
	    return false;
	} else if (F.dh_order_city.value == "") {
        alert("請輸入鄉鎮區市!!");
        F.dh_order_city.focus();
        return false; 
	} else if (F.dh_order_zipcode.value == "") {
        alert("請輸入郵遞區號!!");
        F.dh_order_zipcode.focus();
        return false;
    } else if (F.dh_order_address.value == "") {
        alert("請輸入地址!!");
        F.dh_order_address.focus();
        return false;
    } else if (F.dh_order_name.value == "") {
        alert("請輸入收據姓名!!");
        F.dh_order_name.focus();
        return false;    
    }else if (F.dh_total.value == "") {
        alert("請輸入收據金額!!");
        F.dh_total.focus();
        return false;
    } else if (F.dh_total1.value == "") {
        alert("請輸入收據金額(中文)!!");
        F.dh_total1.focus();
        return false;
    } else if (F.rs_donateitem.value == "") {
        alert("請輸入捐款項目!!");
        F.rs_donateitem.focus();
        return false;
    }else {
        return true;
    }
}

</script>
<script src="<%=request.getContextPath() %>/js/zip.js"></script>
<!-- InstanceBeginEditable name="head" -->
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>
<!-- InstanceEndEditable -->
</head>
<%-- 20250331 modify Miles top menu.jsp  改成 RWD --%>    
<body class="default_body">
<div class="pageContent default_pageContent">
<div align="center" class="default_area">
  <table class="default_table" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td colspan="2">
      	<table border="0" cellspacing="0" cellpadding="0">       
			<%@include file="/WEB-INF/jspf/mis/top.jspf"%>
      </table>
      </td>
    </tr>
    
    <tr class="default_table_bottom page_mis">
    
      <td width="" align="center" valign="top" class="system_bk-2">
      		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<%@include file="../leftmenu.jsp"%>          
      		</table>
      	</td>
      
      		<td width="99%" align="center" valign="top" class="system_bk-2p right_content_style"><table width="99%" border="0" cellspacing="0" cellpadding="0">
<%-- 20250331 modify Miles top menu.jsp  改成 RWD --%>
          <tr>
            <td colspan="2" class="information_bk-2b">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td width="8%" align="left" valign="middle"><img src="../images/information_icon_1.gif" width="55" height="48" /></td>
            <td width="92%" align="left" valign="middle" class="information_bigword">收據資料維護</td>
          </tr>
          <tr>
            <td colspan="2"><hr size="1" noshade></td>
          </tr>
<form name="form0" method="post" action="<%=rl_code %>_update.jsp?action=A"  onsubmit="return checkform(this);">
<input type="hidden" name="rs_no_add" value="<%=rs_no_add%>">
<input type="hidden" name="dh_receipt_type" value="<%=dh.getString("dh_receipt_type") %>">

          <tr align="center">
            <td colspan="2"><table width="95%"  border="0" cellspacing="1" cellpadding="0">
              <tr>
                <td class="system_bk-2bk"><table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
                    <tr align="center">
                      <td colspan="4" class="information_title-1"> 收據資料維護&nbsp;
                      </td>
                    </tr>
                    <tr align="center" class="information_bk-2">
                      <td colspan="4">收據資料－填入</td>
                    </tr>
                    
                    <tr align="center">
                      <td class="information_table-2-1"><div align="right"><span class="style1">＊</span>收據地址</div></td>
                      <td colspan="3" class="information_table-2-1" align="left">
                        <input type="hidden" name="county" value="<%=dh.getString("dh_receipt_county")%>">
                        <input type="hidden" name="city" value="<%=dh.getString("dh_receipt_city")%>">
                        縣市<select name="dh_order_county" id="dh_order_county" onchange="changeZone(form0.dh_order_county, form0.dh_order_city, form0.dh_order_zipcode, form0.county, form0.city)"></select>
                        鄉鎮區市<select name="dh_order_city" id="dh_order_city" onchange="showZipCode(form0.dh_order_county, form0.dh_order_city, form0.dh_order_zipcode, form0.county, form0.city)"></select>
                        郵遞區號<input type="text" name="dh_order_zipcode" id="dh_order_zipcode" size="1" value="<%=dh.getString("dh_receipt_zipcode")%>" readonly>
                        <input name="dh_order_address" type="text" value="<%=dh.getString("dh_receipt_address")%>" size="60" maxlength='50'>
                        </td>
                    </tr>
                    
                    <tr align="center">
                      <td width="160" class="information_table-2-1" align="right"><span class="style1">＊</span>收據抬頭</td>
                      <td width="340" class="information_table-2-1" align="left">
                      	<input name="dh_order_name" value="<%=dh.getString("dh_receipt_title")%>" type="text" size="20" maxlength="15">  
                      </td>
                      <td width="160" class="information_table-2-1" align="right">收據身份字號/統編/居留證號</td>
                      <td width="340" class="information_table-2-1" align="left">
                        <input name="dh_pid" value="<%=dh.getString("dh_pid")%>" type="text" size="30" maxlength="50">
                      </td>
                    </tr>
<%--                    
                    <tr align="center">
                      <td class="information_table-2-1" align="right">收據營利事業統一編號</td>
                      <td colspan="3" class="information_table-2-1" align="left">
                        <input name="dh_compid" value="<%=dh.getString("dh_compid")%>" type="text" value="" size="20">
                      </td>
                    </tr>
--%>               
                    <tr align="center">
                      <td width="160" class="information_table-2-1" align="right"><span class="style1">＊</span>收據金額</td>
                      <td colspan="3" width="340" class="information_table-2-1" align="left">
                      	<input name="os_total" value="<%=all_money %>" type="number" min="0" size="20" maxlength="15">  
                      </td>
                      <%--
                      <td width="160" class="information_table-2-1" align="right">收據金額(中文)</td>
                      <td width="340" class="information_table-2-1" align="left">
                        <input name="os_total_cn" value="<%=os.getString("os_total_cn")%>" type="text" size="50" maxlength="255">
                      </td>
                      --%>
                    </tr>
                   <tr class="information_table-2-1">
                 	<td align="right" class="tablebg"><span class="style1">＊</span>捐款項目</td>
                 	<td  colspan="3" align="left" class="tablebg">
						<textarea rows="3" cols="120" name="rs_donateitem"><%=rs_donateitem %></textarea>
					</td>
				  </tr> 
	                                               
                </table></td>
              </tr>
            </table> <br>
            <input type="submit" value="確定送出">&nbsp;
            </td>
          </tr>
</form>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" class="information_bk-2b">&nbsp;</td>
          </tr>
        </table>
      <!-- InstanceEndEditable --></td>
    </tr>
  </table>
</div>
<script> ResetAll(form0.dh_order_county, form0.dh_order_city, form0.dh_order_zipcode, form0.county, form0.city); </script>
<%=HtmlCoder.getForm("lastpage", request.getHeader("referer"), names, values)%>
</div>
</body>
<!-- InstanceEnd --></html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>