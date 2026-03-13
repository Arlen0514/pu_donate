<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/WEB-INF/jspf/mis/check.jspf"%>
<%@ page import="javax.imageio.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %> 
<%@ page import="java.util.regex.*" %>
<%@ include file="../../JQuery/jquery.jsp" %>
<%@page import="java.net.URLDecoder"%>
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/htmleditor/tinymce/jquery.tinymce.min.js"></script>
<script type="text/javascript">
var FileBrowserDialogue = {
    init : function () {
        // Here goes your code for setting your custom things onLoad.
    },
    mySubmit : function (URL) {
    	top.tinymce.activeEditor.windowManager.getParams().oninsert(URL);
        // close popup window
        parent.tinymce.activeEditor.windowManager.close();    	
    }
}
</script>
<%
//讓系統不會被cache
response.setHeader("Cache-Control", "private,no-cache,no-store"); // for HTTP 1.1 
%>
<%!
	//刪除檔案
	private void removefile( File directory ){
			if(directory.isDirectory()){
				deletelist(directory);
			}
			else{
				directory.delete();
			}
	}
 	//刪除資料夾下的內容
	private void deletelist( File directory ) {
      File[] children = directory.listFiles();
 	
		for ( int i = 0; i < children.length; i++ ) {
        // 刪除檔案
        	if ( children[i].isFile() )
            children[i].delete();
            // 刪除資料夾
        	if ( children[i].isDirectory() )
            this.deletelist( children[i] );
		}
 	
      // 上面的迴圈都跑完了, 表示所有的children都殺光了
      File m_parent = directory.getParentFile();
      directory.delete();
	}

	private File[] sortFiles(File[] files) {
        Vector vc = new Vector();
        for (int i = 0; i < files.length; i++) {
            File thefile = files[i];
            String filename = thefile.getName();
           	boolean set = false;
           	for (int j = 0; j < vc.size(); j++) {
               File tfile = (File)vc.get(j);
               if (filename.toLowerCase().compareTo(tfile.getName().toLowerCase()) < 0) {
                   vc.insertElementAt(thefile, j);
                   set = true;
                   break;
               }
            }
            if (!set) {
               vc.add(thefile);
            }
        }
        File[] rtnfiles = new File[files.length];
       	for (int i = 0; i < vc.size(); i++) {
           rtnfiles[i] = (File)vc.get(i);
       	}
       	return rtnfiles;
	}
	// 檔案重新命名
	private void renamefile( File old_file, File new_file){
		old_file.renameTo(new_file);
		// boolean new_file_is = new_file.exists();
	}
%>
<%
	// Context path 為網站名稱 ex:EcBuy
	String contextPath = request.getContextPath();
	  
	// 實際的網站根目錄(沒有後置斜線) ex:http://localhost:80/ecBuy 
	String siteroot = request.getScheme()+"://"+request.getServerName()+":"+request.getLocalPort()+contextPath;
	  
	// 存在本機tomcat下的實體目錄 ex:D:/Work/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/ecBuy 
	String diskroot = request.getRealPath("").replaceAll("\\\\", "/");
	
	//String editpath = diskroot+subpath;       // 網頁編輯器上傳檔案的根目錄絕對路徑
	  
	String xid =  StringTool.validString(request.getParameter("id"),"");
	
	//預設為uploads資料夾下的內容 多檔上傳不阻擋
	// String org_subpath = "/uploads/root"+(!"".equals(xid)?"/":"")+xid;
	String org_subpath = "/uploads/root";
 	String subpath = StringTool.validString(request.getParameter("path"),org_subpath);
	
	// 有問題才編碼
	boolean subpath_essyCo = java.nio.charset.Charset.forName("GBK").newEncoder().canEncode(subpath);
	
	if(subpath!=null && !subpath_essyCo)
	subpath = new String(subpath.getBytes("8859_1"),"UTF-8");
	if(subpath!=null)
	subpath = URLDecoder.decode(subpath,"UTF-8"); 
	//抓型態 是image或是media
	String type = request.getParameter("type");
	  
	//存檔案的實體路徑
	String path = diskroot + subpath;
	
	File xxx = new File(path);
	if(!xxx.exists()){
	xxx.mkdir();
	}
	//String fileName       // 判斷是否為上傳完成 是的話直接選定圖案
	String filename = StringTool.validString(request.getParameter("filename"),"");

	// 有問題才編碼
	boolean filename_essyCo = java.nio.charset.Charset.forName("GBK").newEncoder().canEncode(filename);
	
	if(filename!=null && !filename_essyCo)
		filename = new String(filename.getBytes("8859_1"),"UTF-8");
	if(filename!=null)
		filename = URLDecoder.decode(filename,"UTF-8");
	
	if(!filename.equals("")){
%>
<script type="text/javascript">
	   FileBrowserDialogue.mySubmit('<%=contextPath+subpath+"/"+filename %>');
</script>
<%
	}
	
	//刪除檔案&資料夾
	if (request.getParameter("delfile") != null)
	removefile(new File(path+"/"+request.getParameter("delfile")));
	
	//重新命名檔案&資料夾
	if (request.getParameter("oldname") != null) {
		String newname = request.getParameter("newname");
		
		renamefile(new File(path+"/"+request.getParameter("oldname")), new File(path+"/"+newname));	
	}
	  
	// 實際的檔案路徑
	File fDir = new File(path);
	File[] fAllFiles = sortFiles(fDir.listFiles());
	
	boolean have_back = false;
	// 要有回上一頁  跟回根目錄
	if(!org_subpath.equals(subpath)) have_back = true;
	String now_path = subpath.replace(org_subpath, "");
	if("".equals(now_path)) now_path = "/";
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=app_mistitle%></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/><!--讓ie在切換瀏覽器模式時 文件模式會使用最新的版本-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="Robots" content="none" /><!--不被搜尋引擎搜到-->

<!--RWD用-->
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<!--RWD用-->
<!--android 手機板主題顏色用 更改網址列顏色-->
<meta name="theme-color" content="#ee2a2a">
<!--android 手機板主題顏色用-->

<meta name="format-detection" content="telephone=no"><!--取消行動版 safari 自動偵測數字成電話號碼-->


<link rel="stylesheet" type="text/css" href="../../htmleditor/css/file_manage.css"/>
<!--google material icon-->
<link rel="stylesheet" href="../../htmleditor/icon_fonts/material_icons/material-icons.css">
<script src="../../htmleditor/js/jquery-1.10.2.min.js" type="text/javascript"></script>
<script src="../../htmleditor/js/jquery-migrate-1.2.1.min.js" type="text/javascript"></script>
<script src="../../htmleditor/js/common.js" type="text/javascript"></script><!--JavaScript共用區-->

<script defer type="text/javascript">

	var chk = /^[_a-zA-Z0-9\-\.]+$/;
	var chk_c = /^[\u4e00-\u9fa5_a-zA-Z0-9\-\.]+$/;
	
	function checkform1(F){
		var imagestr = F.image.value.split("\\");
		var uid = imagestr[imagestr.length-1];
		
		flag = true;
		var filenames = new Array();
		filenames = document.getElementsByName("filenames");
		if(filenames.length>0){
			for(i=0;i<filenames.length;i++){
				if(filenames[i].value.toLowerCase() == uid.toLowerCase()){
					if(confirm('檔案名稱重複 請問是否覆蓋')){
						flag = true;
					}
					else{
						flag = false;
					}	
				}
			}
		}
		if(F.image.value == ""){
			alert("請選擇欲上傳的圖檔！");
			flag = false;
		}/*else if(!chk_c.test(uid)){
			alert("您的檔案只能是數字、中英文字及「_」等符號,其他的符號都不能使用 !" );
			flag = false;
		}*/
		return flag;
	}

	function checkform2(F){
		var uid = F.folder.value;
		var flag = true;
		var foldernames = new Array();
		foldernames = document.getElementsByName("foldernames");
		if (foldernames.length > 0) {
			for (i = 0; i < foldernames.length; i++) {
				if (foldernames[i].value == uid) {
					alert('資料夾名稱重複');
					flag = false;
				}
			}
		}
		if (uid.length == 0) {
			alert("請輸入資料夾名稱！");
			flag = false;
		}/*else if(!chk_c.test(uid)){
			alert("您的檔案只能是數字、中英文字及「_」等符號,其他的符號都不能使用 !" );
			flag = false;
		}*/
		return flag;
	}

	//確定刪除
	function checkDel(name) {
		if (confirm('請問是否要刪除')){
			$("#delfile").val(name);
			document.getElementById("checkDel").submit();
		}
	}
	function post_name (name){
		$('#oldname').val(name);
		$('#newname').val(name);
	}
	function renameform(F){
		var newname = F.newname.value;
		var flag = true;
		var filenames = new Array();
		filenames = document.getElementsByName("filenames");
		
		if (newname.length == 0) {
			alert("請輸入新的名稱！");
			flag = false;
		} 
		if (filenames.length > 0) {
			for (i = 0; i < filenames.length; i++) {
				if (filenames[i].value == newname) {
					alert('名稱重複');
					flag = false;
				}
			}
		}
		return flag;
	}

</script>
</head>
<body>

    <!--背景-->
    <div class="file_manageBody">
    	<div class="fileManage_bodyIn">
            
            <!--網編器檔案管理區塊-->
            <div class="file_manageBg">
                <div class="file_manageArea">
                    
                    
                    <!--版頭-->
                    <div class="fileManage_headerArea">
                    	
                        <!--標題-->
              			<div class="header_titBg">
                        	<div class="header_titArea">
                            	<div class="header_titImg">
                                	<svg viewBox="0 0 40 40">
                                		<g fill-rule="evenodd">
                                			<path d="M3.908 4h10.104c1.163 0 1.582.073 2.032.229.45.156.838.395 1.179.728.34.333.593.675 1.113 1.716L19 8H0v-.092c0-.866.162-1.547.467-2.117a3.18 3.18 0 0 1 1.324-1.324C2.36 4.162 3.042 4 3.908 4zM0 8h34.872c1.783 0 2.43.186 3.082.534.652.349 1.163.86 1.512 1.512.348.652.534 1.299.534 3.082v17.744c0 1.783-.186 2.43-.534 3.082a3.635 3.635 0 0 1-1.512 1.512c-.652.348-1.299.534-3.082.534H5.128c-1.783 0-2.43-.186-3.082-.534a3.635 3.635 0 0 1-1.512-1.512C.186 33.302 0 32.655 0 30.872V8z">
                                			</path>
                                		</g>
                                		</svg>
                                </div>
                            	<div class="header_titContent">
                                	Files (<%=now_path %>)
                                </div>
                                
                                <div class="clearfloat">
                                </div>
                            </div>
                        </div>
                        
                        
                        <!--右側選項區塊-->
                        <div class="header_rightArea">
                        
                        	
                            <!--搜尋區塊-->
                            <div class="header_searchArea">
                                <div class="header_searchIn">
                                
                                	<!--欄位-->
                                	<div class="header_searchInput">
                                    	<input type="text" placeholder="Search" />
                                    </div>
                                    
                                    <!--icon-->
                                	<div class="header_searchIcon">
                                    	<svg width="24" height="24" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
											<path d="M15.907 17.319a8 8 0 1 1 1.412-1.412c.013.011.026.023.038.036l4.35 4.35a1 1 0 0 1-1.414 1.414l-4.35-4.35a1.016 1.016 0 0 1-.036-.038zM11 17a6 6 0 1 0 0-12 6 6 0 0 0 0 12z">
											</path>
                                        </svg>	
                                    </div>
                                    
                                </div>
                            </div>
                            
                        	
                            
                            	
<!--新增檔案與資料夾按鈕 下拉選單開關-->
<script type="text/javascript">
    $(function(){
        $("#header_add").click(function (e) {
            $("#addOpen").toggle();
            e.stopPropagation();
        });
    });
    
    $(window).click(function(e) {
        $("#addOpen").hide();
    });
</script>
                            
                            
                            <!--新增檔案與資料夾按鈕-->
                            <div class="header_addArea">
                                <button type="button" id="header_add">
                                    <svg width="24" height="24" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
										<path d="M13 11h6a1 1 0 0 1 0 2h-6v6a1 1 0 0 1-2 0v-6H5a1 1 0 0 1 0-2h6V5a1 1 0 0 1 2 0v6z">
										</path>
                                    </svg>
                                </button>
                                
                                <!--選單-->
                                <div class="header_addOpen" id="addOpen">
                                	<div class="headerAdd_openContent">
                                    	
                                        <!--清單項目-->
                                    	<div class="headerAdd_openList"  id="uploadfile_btn">
                                        	<a href="javascript:void(0);">
                                                <!--圖片-->
                                                <div class="headerAdd_openListImg">
                                                    <svg width="24" height="24" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                                        <path d="M18 19v-2a1 1 0 0 1 2 0v3a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1v-3a1 1 0 0 1 2 0v2h12zM11 6.414L8.707 8.707a1 1 0 0 1-1.414-1.414l4-4a1 1 0 0 1 1.414 0l4 4a1 1 0 1 1-1.414 1.414L13 6.414V16a1 1 0 0 1-2 0V6.414z">
                                                        </path>
                                                    </svg>
                                                </div>
                                                <!--標題-->
                                                <div class="headerAdd_openListTit"><!--Upload file-->
                                                    上傳檔案
                                                </div>
                                            </a>
                                        </div>
                                    	
                                        <!--清單項目-->
                                    	<div class="headerAdd_openList" id="addfile_btn">
                                        	<a href="javascript:void(0);">
                                                <!--圖片-->
                                                <div class="headerAdd_openListImg">
                                                    <svg width="24" height="24" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                                        <path d="M20 6h-8l-2-2H4c-1.11 0-1.99.89-1.99 2L2 18c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V8c0-1.11-.89-2-2-2zm-2 8h-2v2a1 1 0 0 1-2 0v-2h-2a1 1 0 0 1 0-2h2v-2a1 1 0 0 1 2 0v2h2a1 1 0 0 1 0 2z">
                                                        </path>
                                                    </svg>
                                                </div>
                                                <!--標題-->
                                                <div class="headerAdd_openListTit"><!--Upload file-->
                                                    建立資料夾
                                                </div>
                                            </a>
                                        </div>
     
                                    </div>
                                </div>
                            </div>
                            
                            
                            <div class="clearfloat">
                            </div>
                        </div>
                        
                        
                        <div class="clearfloat">
                        </div>
                	</div>
                    
                    
              		<!--手機版搜尋區塊-->
                    <div class="MBheader_searchArea">
                        <div class="header_searchIn">
                        
                            <!--欄位-->
                            <div class="header_searchInput">
                                <input type="text" placeholder="Search" />
                            </div>
                            
                            <!--icon-->
                            <div class="header_searchIcon">
                                <svg width="24" height="24" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M15.907 17.319a8 8 0 1 1 1.412-1.412c.013.011.026.023.038.036l4.35 4.35a1 1 0 0 1-1.414 1.414l-4.35-4.35a1.016 1.016 0 0 1-.036-.038zM11 17a6 6 0 1 0 0-12 6 6 0 0 0 0 12z">
                                    </path>
                                </svg>	
                            </div>
                            
                        </div>
                    </div>
              
                            
                            	
<!--新增檔案與資料夾按鈕 下拉選單開關-->
<script type="text/javascript">
    $(function(){
        $(".fileList_OtherBtn").click(function (e) {
			$(".fileList_OtherBtn").not(this).removeClass("active");
			$(".fileList_OtherBtn").not(this).children(".file_otherOpen").removeClass("active");
            $(this).toggleClass("active");
            $(this).children(".file_otherOpen").toggleClass("active");
			// $(".file_otherOpen").toggleClass("active");
			$("body").toggleClass("active");
            e.stopPropagation();
        });
    });
    
		
	$(window).click(function(e) {
		$(".fileList_OtherBtn").not(this).removeClass("active");
		$(".file_otherOpen").removeClass("active");
		$("body").removeClass("active");
		$(".menu_btn").removeClass("active");
	});
	
</script>
                                
                    
                    <!--內容-->
                    <div class="fileManage_mainArea">
                        <div class="fileManage_mainIn">
                        	
                            <!--檔案列表-->
                            <div class="file_listBg">
                            	<div class="file_listArea">
                            	
<%if(have_back){ %>
                                    <!--清單-->
                                    <div class="file_list">
                                    	<div class="file_listIn">
                                        	
                                            <!--圖片-->
                                            <div class="file_listImg">
                                            <%--<a href="lister.jsp?path=<%=URLDecoder.decode(subpath.substring(0, subpath.lastIndexOf("/")),"UTF-8") %>&type=<%=type%>&id=<%=xid %>"> --%>
                                                <a href="lister.jsp?path=<%=subpath.substring(0, subpath.lastIndexOf("/")) %>&type=<%=type%>&id=<%=xid %>">
                                                    <img src="./images/files_back.png" width="230" height="230" />
                                            	</a>
                                            </div>
                                            
                                            <!--下方區塊-->
                                            <div class="fileList_bottomArea">
                                            	
                                                <!--內容-->
                                            	<div class="fileList_name" style="padding-left:0px;">
                                            		<div class="fileList_nameIn">
                                                        回到上一頁
                                                    </div>
                                                </div>
                                                
                                            </div>
                                        </div>
                                    </div>
                            	
<%} %>

<%
	for (int i = 0; i < fAllFiles.length; i++) {
		if (fAllFiles[i].isDirectory()) {
%>                                	
                                    <!--清單-->
                                    <div class="file_list">
                                    	<div class="file_listIn">
                                        	
                                            <!--圖片-->
                                            <div class="file_listImg">
                                                <a href="lister.jsp?path=<%=subpath %>/<%=fAllFiles[i].getName()%>&type=<%=type%>&id=<%=xid %>">
                                                    <img src="./images/files.png" width="230" height="230" />
                                            	</a>
                                            	<input name="filenames" type="hidden" value="<%=fAllFiles[i].getName()%>" />
                                            </div>
                                            
                                            <!--下方區塊-->
                                            <div class="fileList_bottomArea">
                                            	
                                                <!--內容-->
                                            	<div class="fileList_name">
                                            		<div class="fileList_nameIn">
                                                       <%=fAllFiles[i].getName()%>
                                                    </div>
                                                </div>
                                                <!--其他按鈕-->
                                                <div class="fileList_OtherBtn">
                                                	<button type="button" class="otherBtn">
														<svg viewBox="0 0 24 24">
                                                            <path d="M6 10c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm12 0c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm-6 0c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z" fill-rule="nonzero">
                                                            </path>
                                                        </svg>
                                                    </button>
                                                   
                                                    <!--選單-->
                                                    <div class="file_otherOpen">
                                                        <div class="fileOther_OpenContent">
                                                            <!--清單項目-->
                                                            <div class="fileOther_openList">
                                                                <a href="javascript:void(0);" class="rename_btn" onclick="post_name('<%=fAllFiles[i].getName() %>');">
                                                                    <!--圖片-->
                                                                    <div class="fileOther_openListImg">
                                                                        <svg viewBox="0 0 24 24">
																			<path d="M12.19 3.734c.125-.292.315-.535.568-.729.253-.193.51-.322 1.256-.508L16 2v1.03l-1.744.437c-.565.14-.731.211-.89.333a.8.8 0 0 0-.259.33c-.08.185-.107.363-.107.946v13.848c0 .583.028.761.107.946a.8.8 0 0 0 .258.33c.16.122.326.192.891.333L16 20.97V22l-1.986-.497c-.747-.186-1.003-.315-1.256-.508a1.799 1.799 0 0 1-.569-.73c-.126-.292-.252-.292-.378 0a1.799 1.799 0 0 1-.57.73c-.252.193-.508.322-1.255.508L8 22v-1.03l1.744-.437c.565-.14.731-.211.89-.333a.8.8 0 0 0 .259-.33c.08-.185.107-.363.107-.946V5.076c0-.583-.028-.761-.107-.946a.8.8 0 0 0-.258-.33c-.16-.122-.326-.192-.891-.333L8 3.03V2l1.986.497c.747.186 1.003.315 1.256.508.253.194.443.437.569.73.126.292.252.292.378 0z" fill-rule="nonzero">
																			</path>
                                                                        </svg>
                                                                    </div>
                                                                    <!--標題-->
                                                                    <div class="fileOther_openListTit"><!--Upload file-->
                                                                        重新命名
                                                                    </div>
                                                                </a>
                                                            </div>
                                                            <!--清單項目-->
                                                            <div class="fileOther_openList">
                                                                <a href="javascript:checkDel('<%=fAllFiles[i].getName() %>');" class="delete_btn">
                                                                    <!--圖片-->
                                                                    <div class="fileOther_openListImg">
                                                                        <svg width="24" height="24" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
																			<path d="M17 6h3a1 1 0 0 1 0 2h-1v11a3 3 0 0 1-3 3H8a3 3 0 0 1-3-3V8H4a1 1 0 1 1 0-2h3V5a3 3 0 0 1 3-3h4a3 3 0 0 1 3 3v1zm-2 0V5a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v1h6zm2 2H7v11a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V8zm-8 3a1 1 0 0 1 2 0v6a1 1 0 0 1-2 0v-6zm4 0a1 1 0 0 1 2 0v6a1 1 0 0 1-2 0v-6z">
																			</path>
                                                                       	</svg>
                                                                    </div>
                                                                    <!--標題-->
                                                                    <div class="fileOther_openListTit"><!--Upload file-->
                                                                        刪除
                                                                    </div>
                                                                </a>
                                                            </div>
                                                            
                         
                                                        </div>
                                                    </div>
                                                    
                                                    
                                                </div>
                                            	
                                            </div>
                                        </div>
                                    </div>
<%}}%>
<%
for (int i = 0; i < fAllFiles.length; i++) {
	if (fAllFiles[i].isFile()) {
		boolean is_image = false; 
		String file_name = fAllFiles[i].getName().toLowerCase();
		int start_cte= file_name.indexOf(".");
		String fi_aname = "";
		if(start_cte>0)	fi_aname = file_name.substring(start_cte,file_name.length());				// 副檔名
		
		String[] imagType={".jpg",".png",".bmp",".gif"};
		List <String> imageTyepLists = Arrays.asList(imagType);
	    if (imageTyepLists.contains(fi_aname)) is_image = true;
		if(is_image){ 
%> 
                                    <!--清單-->
                                    <div class="file_list">
                                    	<div class="file_listIn" onClick="FileBrowserDialogue.mySubmit('<%=contextPath + subpath + "/" + fAllFiles[i].getName()%>');">
                                        	
                                            <!--圖片-->
                                            <div class="file_listImg">
                                            	<img src="<%=contextPath + subpath + "/" +  fAllFiles[i].getName() %>" width="440" height="293" />
                                            	<input name="filenames" type="hidden" value="<%=fAllFiles[i].getName()%>">
                                            </div>
                                            
                                            <!--下方區塊-->
                                            <div class="fileList_bottomArea">
                                                <!--內容-->
                                            	<div class="fileList_name">
                                            		<div class="fileList_nameIn">
                                                        <%=fAllFiles[i].getName()%>
                                                    </div>
                                                </div>
                                                
                                                <!--其他按鈕-->
                                                <div class="fileList_OtherBtn">
                                                	<button type="button" class="otherBtn">
														<svg viewBox="0 0 24 24">
                                                            <path d="M6 10c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm12 0c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm-6 0c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z" fill-rule="nonzero">
                                                            </path>
                                                        </svg>
                                                    </button>
                                                   
                                                    
                                                    <!--選單-->
                                                    <div class="file_otherOpen">
                                                        <div class="fileOther_OpenContent">
                                                            <!--清單項目-->
                                                            <div class="fileOther_openList">
                                                                <a href="javascript:void(0);" class="rename_btn" onclick="post_name('<%=fAllFiles[i].getName() %>');">
                                                                    <!--圖片-->
                                                                    <div class="fileOther_openListImg">
                                                                        <svg viewBox="0 0 24 24">
																			<path d="M12.19 3.734c.125-.292.315-.535.568-.729.253-.193.51-.322 1.256-.508L16 2v1.03l-1.744.437c-.565.14-.731.211-.89.333a.8.8 0 0 0-.259.33c-.08.185-.107.363-.107.946v13.848c0 .583.028.761.107.946a.8.8 0 0 0 .258.33c.16.122.326.192.891.333L16 20.97V22l-1.986-.497c-.747-.186-1.003-.315-1.256-.508a1.799 1.799 0 0 1-.569-.73c-.126-.292-.252-.292-.378 0a1.799 1.799 0 0 1-.57.73c-.252.193-.508.322-1.255.508L8 22v-1.03l1.744-.437c.565-.14.731-.211.89-.333a.8.8 0 0 0 .259-.33c.08-.185.107-.363.107-.946V5.076c0-.583-.028-.761-.107-.946a.8.8 0 0 0-.258-.33c-.16-.122-.326-.192-.891-.333L8 3.03V2l1.986.497c.747.186 1.003.315 1.256.508.253.194.443.437.569.73.126.292.252.292.378 0z" fill-rule="nonzero">
																			</path>
                                                                        </svg>
                                                                    </div>
                                                                    <!--標題-->
                                                                    <div class="fileOther_openListTit"><!--Upload file-->
                                                                        重新命名
                                                                    </div>
                                                                </a>
                                                            </div>
                                                            <!--清單項目-->
                                                            <div class="fileOther_openList">
                                                                <a href="javascript:checkDel('<%=fAllFiles[i].getName() %>');" class="delete_btn">
                                                                    <!--圖片-->
                                                                    <div class="fileOther_openListImg">
                                                                        <svg width="24" height="24" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
																			<path d="M17 6h3a1 1 0 0 1 0 2h-1v11a3 3 0 0 1-3 3H8a3 3 0 0 1-3-3V8H4a1 1 0 1 1 0-2h3V5a3 3 0 0 1 3-3h4a3 3 0 0 1 3 3v1zm-2 0V5a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v1h6zm2 2H7v11a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V8zm-8 3a1 1 0 0 1 2 0v6a1 1 0 0 1-2 0v-6zm4 0a1 1 0 0 1 2 0v6a1 1 0 0 1-2 0v-6z">
																			</path>
                                                                       	</svg>
                                                                    </div>
                                                                    <!--標題-->
                                                                    <div class="fileOther_openListTit"><!--Upload file-->
                                                                        刪除
                                                                    </div>
                                                                </a>
                                                            </div>
                                                            
                         
                                                        </div>
                                                    </div>
                                                </div>
                                            	
                                            </div>
                                        </div>
                                    </div>
<%}else { %>
                                    <!--清單-->
                                    <div class="file_list">
                                    	<div class="file_listIn" onClick="FileBrowserDialogue.mySubmit('<%=contextPath + subpath + "/" + fAllFiles[i].getName()%>')">
                                        	
                                            <!--圖片-->
                                            <div class="file_listImg">
                                                <a href="javascript:void(0)">
                                            		<img src="./images/file_simple.png" width="230" height="230" />
                                            		<input name="filenames" type="hidden" value="<%=fAllFiles[i].getName()%>">
                                                </a>
                                            </div>    
                                            
                                            <!--下方區塊-->
                                            <div class="fileList_bottomArea">
                                            	
                                                <!--內容-->
                                            	<div class="fileList_name">
                                            		<div class="fileList_nameIn">
                                                    	<%=fAllFiles[i].getName()%>
                                                    </div>
                                                </div>
                                                
                                                <!--其他按鈕-->
                                                <div class="fileList_OtherBtn">
                                                	<button type="button" class="otherBtn">
														<svg viewBox="0 0 24 24">
                                                            <path d="M6 10c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm12 0c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm-6 0c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z" fill-rule="nonzero">
                                                            </path>
                                                        </svg>
                                                    </button>
                                                   
                                                    
                                                    <!--選單-->
                                                    <div class="file_otherOpen">
                                                        <div class="fileOther_OpenContent">
                                                            <!--清單項目-->
                                                            <div class="fileOther_openList">
                                                                <a href="javascript:void(0);" class="rename_btn" onclick="post_name('<%=fAllFiles[i].getName() %>');">
                                                                    <!--圖片-->
                                                                    <div class="fileOther_openListImg">
                                                                        <svg viewBox="0 0 24 24">
																			<path d="M12.19 3.734c.125-.292.315-.535.568-.729.253-.193.51-.322 1.256-.508L16 2v1.03l-1.744.437c-.565.14-.731.211-.89.333a.8.8 0 0 0-.259.33c-.08.185-.107.363-.107.946v13.848c0 .583.028.761.107.946a.8.8 0 0 0 .258.33c.16.122.326.192.891.333L16 20.97V22l-1.986-.497c-.747-.186-1.003-.315-1.256-.508a1.799 1.799 0 0 1-.569-.73c-.126-.292-.252-.292-.378 0a1.799 1.799 0 0 1-.57.73c-.252.193-.508.322-1.255.508L8 22v-1.03l1.744-.437c.565-.14.731-.211.89-.333a.8.8 0 0 0 .259-.33c.08-.185.107-.363.107-.946V5.076c0-.583-.028-.761-.107-.946a.8.8 0 0 0-.258-.33c-.16-.122-.326-.192-.891-.333L8 3.03V2l1.986.497c.747.186 1.003.315 1.256.508.253.194.443.437.569.73.126.292.252.292.378 0z" fill-rule="nonzero">
																			</path>
                                                                        </svg>
                                                                    </div>
                                                                    <!--標題-->
                                                                    <div class="fileOther_openListTit"><!--Upload file-->
                                                                        重新命名
                                                                    </div>
                                                                </a>
                                                            </div>
                                                            <!--清單項目-->
                                                            <div class="fileOther_openList">
																<a href="javascript:checkDel('<%=fAllFiles[i].getName() %>');" class="delete_btn">
                                                                    <!--圖片-->
                                                                    <div class="fileOther_openListImg">
                                                                        <svg width="24" height="24" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
																			<path d="M17 6h3a1 1 0 0 1 0 2h-1v11a3 3 0 0 1-3 3H8a3 3 0 0 1-3-3V8H4a1 1 0 1 1 0-2h3V5a3 3 0 0 1 3-3h4a3 3 0 0 1 3 3v1zm-2 0V5a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v1h6zm2 2H7v11a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V8zm-8 3a1 1 0 0 1 2 0v6a1 1 0 0 1-2 0v-6zm4 0a1 1 0 0 1 2 0v6a1 1 0 0 1-2 0v-6z">
																			</path>
                                                                       	</svg>
                                                                    </div>
                                                                    <!--標題-->
                                                                    <div class="fileOther_openListTit"><!--Upload file-->
                                                                        刪除
                                                                    </div>
                                                                </a>
                                                            </div>
                                                            
                         
                                                        </div>
                                                    </div>
                                                </div>
                                            	
                                            </div>
                                        </div>
                                    </div>
	
<%} } }%>
                                    
                                </div>
                            </div>
                            
                            
                        </div>	      
                	</div>
                	
                </div>
        	</div>
            
                                           	    
                                           	
<script type="text/javascript">
	
    $(function(){
		//點擊上傳檔案選單後，打開上傳檔案視窗，關閉下拉選單
        $("#uploadfile_btn").click(function (e) {
            $("#uploadfile").show();
        	$("#addOpen").hide();	
            e.stopPropagation();
        });
        $("#uploadFile_cancel").click(function (e) {
        	$("#uploadfile").hide();	
            e.stopPropagation();
        });
		
		//點擊x按鈕後，關閉上傳檔案視窗
        $("#uploadFile_closeBtn").click(function (e) {
        	$("#uploadfile").hide();	
            e.stopPropagation();
        });
    });
    
</script>     
                    	
<script type="text/javascript">
	
    $(function(){
		
		//點擊建立資料夾選單後，打開建立資料夾視窗，關閉下拉選單
        $("#addfile_btn").click(function (e) {
            $("#addfile").show();
        	$("#addOpen").hide();	
            e.stopPropagation();
        });
		
        $("#addFile_cancel").click(function (e) {
        	$("#addfile").hide();	
            e.stopPropagation();
        });
		
		//點擊x按鈕後，關閉建立資料夾視窗
        $("#addFile_closeBtn").click(function (e) {
        	$("#addfile").hide();	
            e.stopPropagation();
        });
    });
    
</script>     
                                   	
<script type="text/javascript">
	
    $(function(){
		
		//點擊重新命名按鍵後，打開重新名視窗，關閉下拉選單
        $(".rename_btn").click(function (e) {
            $("#rename").show();
			$(".fileList_OtherBtn").removeClass("active");
			$(".file_otherOpen").removeClass("active");
            e.stopPropagation();
        });
		
        $("#reName_cancel").click(function (e) {
        	$("#rename").hide();	
            e.stopPropagation();
        });
		//點擊x按鈕後，關閉重新命名視窗
        $("#reName_closeBtn").click(function (e) {
        	$("#rename").hide();	
            e.stopPropagation();
        });
    });
	
</script>  
            
<form name="upload_actions" method="POST" action="lister_upload.jsp?code=A&path=<%=subpath %>" enctype="multipart/form-data" onsubmit="javascript:return checkform1(this);">
        	<!--上傳檔案區塊-->
            <div class="addFile_bg" id="uploadfile">
                <div class="addFile_area">
                    
                    <!--內容區塊-->
                    <div class="addFile_content">
                        
                        <!--版頭-->
                        <div class="addFile_headerArea">
                            <!--標題-->
                            <div class="addFile_headerTit">
                                上傳檔案
                            </div>
                            <!--關閉按鈕-->
                            <div class="addFile_headerClose" id="uploadFile_closeBtn">
                                <button type="button">
                                    <svg width="24" height="24" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                        <path d="M17.251 8.157L13.421 12l3.83 3.843a.996.996 0 0 1-1.408 1.408L12 13.421l-3.843 3.83a.996.996 0 0 1-1.408-1.408L10.579 12l-3.83-3.843A.996.996 0 0 1 8.157 6.75L12 10.579l3.843-3.83a.996.996 0 0 1 1.408 1.408z" fill-rule="evenodd">
                                        </path>
                                    </svg>
                                </button>
                            </div>
                            
                            
                            <div class="clearfloat">
                            </div>
                        </div>
                        
                        
                        <!--內容-->
                        <div class="addFile_mainArea">
                            <div class="addFile_mainIn">
                                <!--標題-->
                                <!--<div class="addFile_mainTit">
                                    檔案上傳
                                </div>-->
                                <!--欄位-->
                                <div class="addFile_mainInput">
                                    <input class="image" id="pd_group_image" type="file" name="image"  multiple="multiple" required/>
                                   	<input type="hidden" name="fileCount" id="fileCount" value="" />
                                </div>
                                
                            </div>
                        </div>
                        
                        
                        <!--版腳-->
                        <div class="addFile_footerArea">
                            <div class="addFile_footerIn">
                            	<!--確認按鈕-->
                                <div class="addFile_footerSubmit">
                                    <input type="submit" value="確定"/>
                                </div>
                                <!--取消按鈕-->
                                <div class="addFile_footerCancel">
                                    <input type="button" value="取消" id="uploadFile_cancel"/>
                                </div>
                                
                                <div class="clearfloat">
									<input type="hidden" name="action" value="upload" />
									<input type="hidden" name="path" value="<%=subpath %>" />
									<input type="hidden" name="type" value="<%=type%>" />
                                </div>
                            </div>
                            
                            <div class="clearfloat">
                            </div>
                        </div>
                    </div>
                    
                </div>
            </div>
</form>
<form name="create_actions" method="POST" action="upload.jsp" enctype="multipart/form-data" onsubmit="javascript:return checkform2(this);">
        	<!--建立資料夾區塊-->
            <div class="addFile_bg" id="addfile">
                <div class="addFile_area">
                    
                    <!--內容區塊-->
                    <div class="addFile_content">
                        
                        <!--版頭-->
                        <div class="addFile_headerArea">
                            <!--標題-->
                            <div class="addFile_headerTit">
                                建立資料夾
                            </div>
                            <!--關閉按鈕-->
                            <div class="addFile_headerClose" id="addFile_closeBtn">
                                <button type="button">
                                    <svg width="24" height="24" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                        <path d="M17.251 8.157L13.421 12l3.83 3.843a.996.996 0 0 1-1.408 1.408L12 13.421l-3.843 3.83a.996.996 0 0 1-1.408-1.408L10.579 12l-3.83-3.843A.996.996 0 0 1 8.157 6.75L12 10.579l3.843-3.83a.996.996 0 0 1 1.408 1.408z" fill-rule="evenodd">
                                        </path>
                                    </svg>
                                </button>
                            </div>
                            
                            
                            <div class="clearfloat">
                            </div>
                        </div>
                        
                        
                        <!--內容-->
                        <div class="addFile_mainArea">
                            <div class="addFile_mainIn">
                                <!--標題-->
                                <div class="addFile_mainTit">
                                    資料夾名稱
                                </div>
                                <!--欄位-->
                                <div class="addFile_mainInput">
                                    <input type="text" name="folder" />
                                </div>
                                
                            </div>
                        </div>
                        
                        
                        <!--版腳-->
                        <div class="addFile_footerArea">
                            <div class="addFile_footerIn">
                            	<!--確認按鈕-->
                                <div class="addFile_footerSubmit">
                                    <input type="submit" value="確定" />
                                </div>
                                <!--取消按鈕-->
                                <div class="addFile_footerCancel">
                                    <input type="button" value="取消" id="addFile_cancel"/>
                                </div>
                                
                                <div class="clearfloat">
									<input type="hidden" name="action" value="create" />
									<input type="hidden" name="path" value="<%=subpath %>" />
									<input type="hidden" name="type" value="<%=type %>" />
                                </div>
                            </div>
                            
                            <div class="clearfloat">
                            </div>
                        </div>
                    </div>
                    
                </div>
            </div>
</form>
<form name="modify_actions" method="POST" action="lister.jsp" onsubmit="javascript:return renameform(this);">
<%--重新命名區塊--%>
            <div class="addFile_bg" id="rename">
                <div class="addFile_area">
                    
                    <!--內容區塊-->
                    <div class="addFile_content">
                        
                        <!--版頭-->
                        <div class="addFile_headerArea">
                            <!--標題-->
                            <div class="addFile_headerTit">
                                重新命名
                            </div>
                            <!--關閉按鈕-->
                            <div class="addFile_headerClose" id="reName_closeBtn">
                                <button type="button">
                                    <svg width="24" height="24" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                        <path d="M17.251 8.157L13.421 12l3.83 3.843a.996.996 0 0 1-1.408 1.408L12 13.421l-3.843 3.83a.996.996 0 0 1-1.408-1.408L10.579 12l-3.83-3.843A.996.996 0 0 1 8.157 6.75L12 10.579l3.843-3.83a.996.996 0 0 1 1.408 1.408z" fill-rule="evenodd">
                                        </path>
                                    </svg>
                                </button>
                            </div>
                            
                            
                            <div class="clearfloat">
                            </div>
                        </div>
                        
                        
                        <!--內容-->
                        <div class="addFile_mainArea">
                            <div class="addFile_mainIn">
                                <!--標題-->
                                <div class="addFile_mainTit">
                                    檔案名稱
                                </div>
                                <!--欄位-->
                                <div class="addFile_mainInput">
                                    <input type="text" name="newname" id="newname" value="" />
                                </div>
                                
                            </div>
                        </div>
                        
                        <!--版腳-->
                        <div class="addFile_footerArea">
                            <div class="addFile_footerIn">
                            	<!--確認按鈕-->
                                <div class="addFile_footerSubmit">
                                    <input type="submit" value="確定" id="reName_submit" />
                                </div>
                                <!--取消按鈕-->
                                <div class="addFile_footerCancel">
                                    <input type="button" value="取消" id="reName_cancel" />
                                </div>
                                
                                <div class="clearfloat">
									<input name="path" type="hidden" value="<%=subpath %>" /> 
									<input name="id" type="hidden" value="<%=xid %>" /> 
									<input name="oldname" id="oldname" type="hidden" value="" />    
                                </div>
                            </div>
                            
                            <div class="clearfloat">
                            </div>
                        </div>
                    </div>
                    
                </div>
            </div>
</form>            
<%--重新命名區塊 --%>
            
                    
        </div>
    </div>
<form name="checkDel" id="checkDel" method="post" action="lister.jsp" >
	<%-- <input name="path" id="path" type="hidden" value="<%=URLDecoder.decode(subpath,"UTF-8") %>"/> --%>
	<input name="path" id="path" type="hidden" value="<%=subpath %>" /> 
	<input name="id" id="id" type="hidden" value="<%=xid %>" /> 
	<input name="delfile" id="delfile" type="hidden" value="" /> 
</form>
<%-- 
<form name="checkModify" id="checkModify" method="post" action="lister.jsp" >
<input name="path" id="path" type="hidden" value="<%=URLDecoder.decode(subpath,"UTF-8") %>"/>
	<input name="path" id="path" type="hidden" value="<%=subpath %>" /> 
	<input name="id" id="id" type="hidden" value="<%=xid %>" /> 
	<input name="rename" id="rename" type="hidden" value="" />
	<input name="oldname" id="oldname" type="hidden" value="" />  
</form>
 --%>
</body>
</html>
<%@include file="/WEB-INF/jspf/connclose.jspf"%>