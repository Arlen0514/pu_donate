<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@include file="/WEB-INF/jspf/mis/check.jspf"%>
<%
  	// Left side type.
  	String code 		= "donate"; 
	String page_code	= "donate_import";									// 頁面代碼
	String show_title 	= "捐款資訊匯入";										// 功能標題

	
	String batch = "", activity = "";
	// Names and values.
	String[] names = new String[] { "npage"                };
	String[] values = new String[] { String.valueOf(pageno)};
	
%>
<html><!-- InstanceBegin template="/Templates/market.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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
	$("#submit").prop("disabled", true);
	var file_chk = /([^\/]+\.(?:xls))/;		//驗證副檔名
	if($("#import_file").val()=="" || !(file_chk.test($("#import_file").val()))){
    	alert("請上傳 .xls 檔案 , 以利作業 !!");
    	$("#import_file").focus();
    	$("#submit").prop("disabled", false);
        return false;
	}else {
		return true;
	}
}


	<%-- 啟動檔案匯出功能 --%>
	function export_file() {
			$(".block").show();
			var theForm = document.frm1;
				theForm.action="export/donate_import_export.jsp";
				theForm.target="_exportFrame";
				theForm.submit();
	}

	function exportProgress(){   <%-- 檢查檔案是否已經匯出完成 --%>
		$.ajax({
			async:false,
			type:"GET",
		    url: "export/exportcheck.jsp",
		    data: {reportType:"donate_import_export"},
		    success: function(res){
		    	res = $.trim(res);
		    	// console.log(res);
		    	if(res == "start"){
		    		$(".block").show();
				}else if((res.indexOf("end")>-1) || (res == "no")){
					$(".block").hide();
					clearProgress();
					if(res.indexOf("end")>-1) {
						location.href = "<%=app_fetchpath+"/report/" + app_account + "_donate_import_export.xlsx" %>";
					}
					else history.back();
				}
		    	window.setTimeout("exportProgress()",1500);
		    }
		}); 		
	}

	function clearProgress(){  <%-- 清除檔案匯出完成後之 Session 值 --%>
		$.ajax({
			async:false,
			type:"GET",
		    url: "export/exportcheck.jsp",
		    data: {reportType:"clear_donate_import_export"},
		    success: function(res){
		    }
		}); 		
	}

	var timer = window.setTimeout("exportProgress()",1500);
/*------------------------------------------------------------*/
</script>
<!-- InstanceBeginEditable name="head" --><!-- InstanceEndEditable -->
</head>
<%-- 20250331 modify Miles top menu.jsp  改成 RWD --%>    
<body class="default_body">
<%-- 黑色遮蔽 --%>
<div class="block" style="width:100%; height:100%; position:fixed; color:#fff; display:none;">
	<img src="export/images/block_bg.png" width="100%" height="100%" style="position:fixed; z-index:99998;"/>
	<div style="margin: 0 auto;width: 400px;height: 50px;position: relative;top: 50%; z-index:99999; text-align:center;">
    	下載範本中，請稍待片刻 ......
	</div>
</div>
<%-- 黑色遮蔽 --%>
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
            <td colspan="3" class="web_bk-2b">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="3">&nbsp;</td>
          </tr>
          <tr>
            <td width="60" align="left" valign="middle">
					<img src="../images/web_icon_1.gif" width="55" height="48">
				</td>
				<td align="left" valign="middle" class="web_bigword"><%=show_title%></td>
          </tr>
          <tr>
            <td colspan="3"><hr size="1" noshade></td>
          </tr>
          <tr align="center">
            <td colspan="3"><table width="95%"  border="0" cellspacing="1" cellpadding="0">
            	<tr align="center">
                	<td class="web_title-1" colspan="3" height="24"><%=show_title %>
            	</tr>
            	
             	<tr class="web_bk-2">
                	<td align="center"  height="24">
                   		下載範本
                   	</td>
                </tr>
                
                 <tr class="web_table-2-1" height="30">
                	<td align="center" width="40%">
<!-- 						<input type="button" name="ex_donate_import" id="ex_donate_import" value="下載範本" onclick="export_file();"> -->
						<input type="button" id="ex_donate_import" name="ex_donate_import"  value="下載範本"
						        onclick="window.location.href='export/donate_import_export.xlsx';"/>
                 	</td>                   	                 	
              	</tr>   
              	 
            </table>
            </td>
          </tr>
          
<form name="form0" method="post" enctype="multipart/form-data" action="<%=page_code %>_update.jsp" onsubmit="return checkform(this.form);">
          <tr align="center">
            <td colspan="2"><table width="95%" border="0" cellspacing="1" cellpadding="0">

              	<tr class="web_table-2-1" height="40">
                	<td align="center" colspan="3">
                    	格式說明：<br/>
                    	必須是 xlsx 檔，副檔名為 {.xlsx}．<br/>
                     	
                 	</td>
              	</tr>            	
                   	
                <tr class="web_bk-2">   	
                	<td align="center" colspan="3" height="24">
                   		批次匯入
                   	</td>
				</tr>
				                  	             	
             	<tr class="web_table-2-1" height="30">
                	<td align="center" width="70%" colspan="2">
                    	<!-- 選擇你要導入的 xls 資料表：-->
                    	<input name="import_file" id="import_file" type="file" class="button" />
                  	</td>
               	</tr>

            </table>
                <br /><input type="submit" name="submit" id="submit" value="確定上傳" >
            </td>
          </tr>
</form>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" class="web_bk-2b">&nbsp;</td>
          </tr>
        </table>
      <!-- InstanceEndEditable --></td>
    </tr>
  </table>
</div>
<iframe name="_exportFrame" width="0" height="0" style="display:none"></iframe>
<form name="frm1" method="post"  action=" request.getRequestURI()" ></form>
</div>
</body>
<!-- InstanceEnd --></html>
<%@include file="/WEB-INF/jspf/connclose.jspf" %>