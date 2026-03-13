<!DOCTYPE html>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@include file="include/function.jsp"%>
<%
	String code 		= "thing";					// 功能識別碼 , 於資料庫做資料識別及模組程式檔名用
	String show_title 	= "捐物資訊管理";				// 功能標題
	String src = StringTool.validString(request.getParameter("src"));

%>
<html lang="<%=encoded %>">
<head>
<%@include file="include/head.jsp"%>
<%@include file="/WEB-INF/jspf/mis/htmleditor.jspf"%>

<script src="<%=request.getContextPath() %>/js/zip.js"></script>
<script>
function checkform(F) {
	var isEmail = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;  	// 使用 isEmail.test(欄位名稱) 檢查 E-Mail 是否格式正確 , 正確為 true
	var isPid = /^[A-Z]\d{9}$/;  													// 使用驗證身分證格式
	var isCid = /^[0-9]{8}$/;  														// 使用驗證統一編號
	var num_chk = /^\d+$/;															// 驗證數字  
	var phone_chk = /^09[0-9]{8}$/;													// 驗證手機

	F.button1.disabled = true;

	if (F.dh_name.value == "") {
        alert("請輸入姓名!!");
        F.dh_name.focus();
	} else if(F.dh_pid.value.trim() == ''){
		alert('請填寫身分證字號/統一編號!!');
		F.dh_pid.focus();
	} else if (F.dh_cellphone.value == "") {
        alert("請輸入正確的連絡電話!!");
        F.dh_cellphone.focus();
	} else if(F.dh_county.value.trim() == ''){
		alert('請填寫通訊地址!!');
		F.dh_county.focus();
	} else if(F.dh_city.value.trim() == ''){
		alert('請填寫通訊地址!!');
		F.dh_city.focus();
	} else if(F.dh_zipcode.value.trim() == ''){
		alert('請填寫通訊地址!!');
		F.dh_zipcode.focus();
	} else if(F.dh_address.value.trim() == ''){
		alert('請填寫通訊地址!!');
		F.dh_address.focus();
	} else if(!isEmail.test(F.dh_email.value.trim())){
		alert('請填寫電子信箱!!');
		F.dh_email.focus();
	} else {
		F.button1.disabled = false;
        return true;
    }
	F.button1.disabled = false;
    return false;
}

</script>

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
		<!-- 建立新增表單 20221018 May -->
		<form name="form0" action="<%=code %>_update.jsp?action=A&code=<%=code %>" method="post" enctype="multipart/form-data" onsubmit="return checkform(this);">
		<table width="99%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2" class="information_bk-2b">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td width="60" align="left" valign="middle">
					<img src="../images/information_icon_1.gif" width="55" height="48">
				</td>
				<td align="left" valign="middle" class="information_bigword"><%=show_title %></td>
			</tr>
			<tr>
				<td colspan="2">
				<hr size="1" noshade>
				</td>
			</tr>
			<tr>
				<td align="center" colspan="2">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<tr>
						<td class="system_bk-2bk">
						<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
							<tr>
								<td align="center" colspan="4" class="information_title-1"><%=show_title%>&nbsp;&nbsp;
								<input type="button" value="新增捐物單" onclick="javascript:location.href='<%=code%>_a.jsp'" />&nbsp;
								<input type="button" value="捐物單列表" onclick="javascript:location.href='<%=code%>.jsp'" />&nbsp;
								</td>
							</tr>

							<tr align="center" class="information_bk-2">
								<td colspan="4" align="center">新增資訊</td>
							</tr>
							

							<tr>
		                  		<td colspan="4" align="center" class="information_title-1">捐物資訊</td>
		                	</tr>
						  	<tr class="information_table-2-1">
		                  		<td align="right" class="tablebg"><font color='red'>＊</font>受贈日期 ： </td>
		                 		<td align="left" class="tablebg">
		                 			<input type="text" name="dh_donatedate" id="_qemitdate" placeholder="" required readonly/>
								</td>
		                  		<td align="right" class="tablebg"><font color='red'>＊</font>財務屬性 ： </td>
		                 		<td align="left" class="tablebg">
		                 			<label for="property">
		                 				<input type="radio" name="dh_donate_project_category" value="1" id="property"> 財產 (單價超過台幣一萬元以上) <br />
		                 			</label>
		                 			<label for="non_consumables">
		                 				<input type="radio" name="dh_donate_project_category" value="2" id="non_consumables"> 非消耗品 (單價超過台幣一萬元以下) <br />
		                 			</label>
		                 			<label for="consumables">
		                 				<input type="radio" name="dh_donate_project_category" value="3" id="consumables"> 消耗品<br />
									</label>
								</td>								
						  	</tr>		                	

						  	<tr class="information_table-2-1">
		                  		<td align="right" class="tablebg"><font color='red'>＊</font>財務名稱： </td>
		                 		<td align="left" class="tablebg">
		                 			<input type="text" name="dh_financialname" id="dh_financialname" placeholder="" required/>
								</td>
		                  		<td align="right" class="tablebg"><font color='red'>＊</font>數量 ： </td>
		                 		<td align="left" class="tablebg">
		                 			<input type="number" name="dh_num" id="dh_num" value="0" min="0" max="9999999" required/>
		                 			<input type="text" name="dh_num_unit" id="dh_num_unit" value="單位" size="5" required/>
								</td>								
						  	</tr>
						  	<tr class="information_table-2-1">
		                  		<td align="right" class="tablebg"><font color='red'>＊</font>型式規格： </td>
		                 		<td align="left" class="tablebg">
		                 			<input type="text" name="dh_typespec" id="dh_typespec" placeholder="" required/>
								</td>
		                  		<td align="right" class="tablebg">購置金額 ： </td>
		                 		<td align="left" class="tablebg">
		                 			<input type="number" name="dh_total" id="dh_total" min="0" max="99999999" value="0"/>
								</td>								
						  	</tr>	
						  	<tr class="information_table-2-1">
		                  		<td align="right" class="tablebg">購置日期： </td>
		                 		<td align="left" class="tablebg">
		                 			<input type="text" name="dh_placedate" id="_qrestdate" placeholder="" readonly/>
								</td>
		                  		<td align="right" class="tablebg">放置地點： </td>
		                 		<td align="left" class="tablebg">
		                 		<input type="text" name="dh_placelocaction" id="dh_placelocaction" placeholder="" />
								</td>								
						  	</tr>
		                 
						  	<tr class="information_table-2-1">
		                  		<td align="right" class="tablebg"><font color='red'>＊</font>捐贈用途： </td>
		                 		<td align="left" class="tablebg">
		                 			<label for="no_assign">
		                 				<input type="radio" name="dh_donate_project" value="1" id="no_assign"> 未指定&nbsp;&nbsp;
		                 			</label>
		                 			<label for="unit_assign">
		                 				<input type="radio" name="dh_donate_project" value="2" id="unit_assign"> 指定單位&nbsp;&nbsp;
		                 			</label>
		                 			<label for="usage_assign">
		                 				<input type="radio" name="dh_donate_project" value="3" id="usage_assign"> 指定用途
									</label>
								</td>
		                  		<td align="right" class="tablebg">指定說明： </td>
		                 		<td align="left" class="tablebg">
		                 			<input type="text" name="dh_donate_project_title" id="dh_donate_project_title" placeholder="" />
								</td>								
						  	</tr>		                 


						  	<tr>
		                  		<td colspan="4" align="center" class="information_title-1">捐物人個人資料</td>
		                  	</tr>	
		                  
		                  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right"><font color='red'>＊</font>姓名/機構名稱 ：  </td>
		                  		<td width="30%" align="left" >
		                  			<input type="text" name="dh_name" id="dh_name" placeholder="" />
		                  		</td>
		                  		<td width="20%" align="right"><font color='red'>＊</font>身份證字號/統一編號 ：  </td>
		                  		<td width="30%" align="left" >
		                  			<input type="text" name="dh_pid" id="dh_pid" maxlength="10" />
		                  		</td>		                  		
						  	</tr>
		                  	<tr class="information_table-2-1">		
		                  		<td width="20%" align="right"><font color='red'>＊</font>聯絡電話 ：  </td>
		                  		<td width="30%" align="left" >
		                  			<input type="text" name="dh_cellphone" id="dh_cellphone" maxlength="50"/>
		                  		</td>			                  					  	
		                  		<td width="20%" align="right">電話 ：  </td>
			                  		<td width="30%" align="left" >
		                  			<input type="text" name="dh_phone" id="dh_phone" maxlength="50"/>
		                  		</td>						  	
						  	</tr>	
						  	
						  	<tr class="information_table-2-1">
		                  		<td align="right"><font color='red'>＊</font>通訊地址： </td>
		                 		<td align="left" colspan="3" >
		                 			<input type="hidden" name="county" value="" />
                        			<input type="hidden" name="city" value="" />
                                    <select name="dh_county" id="dh_county" onchange="changeZone(form0.dh_county, form0.dh_city, form0.dh_zipcode, form0.county, form0.city)"></select>
                                    <select name="dh_city" id="dh_city" onchange="showZipCode(form0.dh_county, form0.dh_city, form0.dh_zipcode, form0.county, form0.city)"></select>
                                    <input type="text" class="fLRA_pdhtalCode" name="dh_zipcode" id="dh_zipcode" readonly size="5"/>
                                    <input type="text" class="address fLRA_address" name="dh_address" id="dh_address" size="30"/>
		                 		</td>
						  	</tr>
		                  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right"><font color='red'>＊</font>E-Mail ： </td>
		                 		<td width="30%" align="left" colspan="3">
		                 			<input type="text" name="dh_email"  id="dh_email" size="50"/>
		                 		</td>
						  	</tr>						  	
		                  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right"><font color='red'>＊</font>身分 ： </td>
		                 		<td width="30%" align="left" colspan="3">
		                 			<label for="gi1">
		                 				<input type="radio" class="item_radio" name="dh_identity" id="gi1"  value="1" />
			                          	靜宜校友，民國&nbsp;
			                          	<input type="text" name="dh_identity_year" id="dh_identity_year"/>&nbsp;年&nbsp;
			                          	<input type="text" name="dh_identity_dept" id="dh_identity_dept"/>&nbsp;系/所/班 畢(結)業
			                        </label>
			                        <br/>
			                        <label for="gi2">
		                 				<input class="item_radio" type="radio" name="dh_identity" id="gi2" value="2"> 靜宜教職員&nbsp;
			                        </label> 
			                        <label for="gi3">
			                        	<input class="item_radio" type="radio" name="dh_identity" id="gi3" value="3"> 學生/家長&nbsp;
			                        </label> 
			                        <label for="gi4">
		                 				<input class="item_radio" type="radio" name="dh_identity" id="gi4" value="4"> 企業機構&nbsp;
			                        </label> 
			                        <label for="gi5">
		                 				<input class="item_radio" type="radio" name="dh_identity" id="gi5" value="5"> 社會人士
			                        </label>  
		                 		</td>
							</tr>
		                  	<tr class="information_table-2-1">
		                  		<td width="20%" align="right">服務單位 ： </td>
		                 		<td width="30%" align="left" >
			                        <input type="text" name="dh_unit" id="dh_unit"/>
		                 		</td>
		                  		<td width="20%" align="right">職稱 ： </td>
		                 		<td width="30%" align="left" >
			                    	<input type="text" name="dh_job" id="dh_job"/>
		                 		</td>		                 		
							</tr>							

						</table>
						</td>
					</tr>
		        </table>
				</td>
			</tr>

			<tr>
				<td align="center" colspan="2">
				<table width="95%" border="0" cellspacing="1" cellpadding="0">
					<tr>
						<td class="system_bk-2bk">
						<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">       

							<tr class="information_table-2-1">
								<td width="20%" align="right">建檔人員</td>
								<td width="30%" align="left"><%=app_account%></td>
								<td width="20%" align="right">建檔日期</td>
								<td width="30%" align="left"><%=app_today%></td>
							</tr>


						</table>
						</td> 
						
					</tr>
					<tr align="center">
						<td colspan="4" align="center"><br />
							<input type="submit" name="button1" id="button1" value="確定送出">&nbsp;
							<input type="reset" value="重新設定">&nbsp;
						</td>
					</tr>
					
				</table>
				</td>
						
			</tr>
			
			</form>
			<tr>
				<td colspan="3">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="3" class="information_bk-2b">&nbsp;</td>
			</tr>

		</table>
		</td>
		</div>
	</tr>
</table>
</div>
</body>
</html>
<script> ResetAll(form0.dh_county, form0.dh_city, form0.dh_zipcode, form0.county, form0.city); </script>
<script> ResetAll(form0.dh_receipt_county, form0.dh_receipt_city, form0.dh_receipt_zipcode, form0.county2, form0.city2); </script>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>