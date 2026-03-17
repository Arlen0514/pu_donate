<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jspf/config.jspf"%>
<%@ include file="/WEB-INF/jspf/csrf_token.jspf"%>
<%
	// CSRF 驗證（分頁表單以 POST 提交）
	if ("POST".equalsIgnoreCase(request.getMethod())) {
		String _submittedCsrf = request.getParameter("csrfToken");
		if (!validateCSRFToken(session, _submittedCsrf, "normalform")) {
			response.sendError(403, "CSRF token validation failed");
			return;
		}
	}
	String _csrfToken = generateCSRFToken(session, "normalform");
%>
<%
	// 參數設定
	String page_code 	= "photo_in", 				  			// 頁面識別碼
		   banner_code	= "photo";							// banner識別碼
	String ap_category = StringTool.validString(request.getParameter("ap_category")); // 所屬上層相簿代號

	
	TableRecord photo = app_sm.select(tblap,ap_category);
	
	// 資料
	Vector<TableRecord> aps = app_sm.selectAll(tblap, "ap_category = ? and ap_code=? and ap_lang=?", new Object[] {ap_category, page_code, lang }, "ap_showseq ASC , ap_createdate DESC");
		   
	
	
	//換頁
	int page_items=12;
	app_dp = new DataPager(aps,page_items);    							//設定資料分頁每頁筆數
	aps = app_dp.getPageContent(pageno);
	
%>
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/in.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<%@include file="../include/head.jsp" %>
	
	<title><%=photo.getString("ap_webtitle")%></title>
	
    <%-- SEO --%>
    <meta name="Robots" content="<%=photo.getString("ap_robots")%>" />
    <meta name="revisit-after" content="<%=photo.getString("ap_revisit_after")%> days" />
    <meta name="keywords" content="<%=photo.getString("ap_keywords")%>" />
    <meta name="copyright" content="<%=photo.getString("ap_copyright")%>" />
    <meta name="description" content="<%=photo.getString("ap_description")%>" />
    <%-- 追蹤碼 --%><%=photo.getString("ap_seo_head_track")%>

    <%-- og 設定 --%>
	<%
	// Server name.	
	String servername = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
	if(request.getServerPort() == 80 || request.getServerPort() == 443) {
		servername = request.getScheme()+"://"+request.getServerName();
	}
	String localname = request.getScheme()+"://"+request.getLocalName()+":"+request.getLocalPort();
	String url = servername + request.getContextPath();
	%>
	<meta property="og:url" content="<%=request.getRequestURL()+(request.getQueryString()!=null&&!request.getQueryString().isEmpty()?"?"+request.getQueryString():"") %>" />
	<meta property="og:type" content="website" />
	<meta property="og:title" content="<%=app_webtitle %>" />
	<meta property="og:description" content="<%=SiteSetup.getText("seo.description."+lang) %>" />
	<meta property="og:image" content="<%=url+"/web/images/logo.png" %>" /></head>
<!-- InstanceBeginEditable name="head" -->
 <link rel="stylesheet" href="../css/style_nav/style_photo/style_photo_in.css">
  <%@include file="/WEB-INF/jspf/mis/pagerscript.jspf"%>
<!-- InstanceEndEditable -->
</head>

<body class="body_in">
    
    
<%=photo.getString("ap_seo_body_track") %>
<%@include file="../include/top_menu.jsp" %>      
    <!--主內容區塊-->
    <main class="main inmain">
        
        <!--內頁banner-->
        <div class="inbanner" style="background-image:url('<%=bannerImg%>');"   
        title="<%=ap_banner_alt%>">
        </div>
        <!--內頁內容_上方區塊-->
        <div class="pageContent_topArea">
        	<div class="wrap">     
               
            	<!--麵包屑-->
                <div class="crumb_bg">
                    <div class="crumb_area">
                    
                        <i class="material-icons">home</i>
                        
                        <span>
                            <a href="../../home.jsp">
                                首頁
                            </a>
                        </span>
						
						<i class="material-icons">navigate_next</i>
						
						<!-- InstanceBeginEditable name="crumb" -->
						
                        <span>
                            <a href="photo.jsp">活動紀實</a>
                        </span>   
                        
                        <i class="material-icons">navigate_next</i>
                        
                        <span><%=photo.getString("ap_title") %></span> 
						
						<!-- InstanceEndEditable --> 
                        
                    </div>
                </div>
                
        		<!--<div class="clearfloat">
                </div>-->
            </div>    
        </div>                        
                        
                        
         <!--首頁內容區塊-->
        <div class="pageContent">
			
			<!-- InstanceBeginEditable name="pageContent" -->
			
			
            <div class="wrap">
                
                <div class="page">
                    
                    <!--右側-->
                    <div class="right no_left">
                        
                        <!--右側標題-->
                        <div class="right_title">
                            <h2><%=photo.getString("ap_title") %></h2>
                        </div>
                        
                        <div class="right_contentBg">

                            <!-- 案例展示 -->
                            <ul class="album_area album_area2" id="my-gallery">
                                <%for(TableRecord ap:aps){ %>
                                <!-- 案例展示_列表 -->
                                <li>
                                    <div class="album_list">
                                        <a href="<%=app_fetchpath+"/"+page_code+"/"+lang+"/"+ap_category+"/"+ap.getString("ap_image")%>"    data-pswp-width=""
                                                                        data-pswp-height=""
                                                                        target="_blank">
                                            <!-- 案例展示_列表_圖 -->
                                            <div class="album_img">                                                
                                                <img src="<%=app_fetchpath+"/"+page_code+"/"+lang+"/"+ap_category+"/"+ap.getString("ap_image")%>" alt="<%=ap.getString("ap_title")%>">                                                    
                                            </div>
                                        </a>
                                    </div>
                                </li>
                                <%} %>

                                <!-- 案例展示_列表 -->
                                
                            </ul>

                            <!--頁數列區塊-->

							<div class="number_pageArea">
							<%@include file="/WEB-INF/jspf/web/rwd_pager2.jspf"%>
							<form name="pageform" id="pageform" method="post" action="<%=request.getRequestURI()%>">
								<input type="hidden" name="npage" id="npage" value="<%=pageno %>" />
								<input type="hidden" name="ap_category" id="ap_category" value="<%=ap_category %>" />
								<input type="hidden" name="csrfToken" value="<%=_csrfToken%>" />
							</form>
							</div>         
                        </div>
                        
                    </div>
                
                </div>
                
            </div>  




        <!-- 獲取列表的圖片"Intrinsic size"（固有尺寸），再植入列表的"data-pswp-width"和"data-pswp-height"屬性 -->
        <script>
            var preloadedImages = [];

            // 預先載入圖片
            function preloadImage(url) {
                return new Promise((resolve, reject) => {
                    var img = new Image();
                    img.onload = resolve;
                    img.onerror = reject;
                    img.src = url;
                    preloadedImages.push(img);
                });
            }

            // 設置 data-pswp-width 和 data-pswp-height 屬性的函式
            function setDimensions(element, imageElement) {
                var album_width = imageElement.naturalWidth;
                var album_height = imageElement.naturalHeight;

                element.setAttribute("data-pswp-width", album_width);
                element.setAttribute("data-pswp-height", album_height);
            }

            // 遍歷第一個圖片庫中的每張圖片，並預先載入圖片
            var gallerySlides1 = document.querySelectorAll(".album_area .album_list");
            gallerySlides1.forEach(function (gallery_slide) {
                var imageElement = gallery_slide.querySelector(".album_area .album_list .album_img img");
                preloadImage(imageElement.src)
                    .then(() => setDimensions(gallery_slide.querySelector("a"), imageElement))
                    .catch(error => console.error("圖片載入錯誤:", error));
            });
        </script>


        <!-- 相簿主圖燈箱套件_效果區塊-第一塊 start-->
        <link rel="stylesheet" href="../js/photoswipe/photoswipe.css">

        <script type="module">
            import PhotoSwipeLightbox from 'https://unpkg.com/photoswipe@5.3.4/dist/photoswipe-lightbox.esm.js';
            import PhotoSwipe from 'https://unpkg.com/photoswipe@5.3.4/dist/photoswipe.esm.js';

            const options = {
                gallery: '#my-gallery',
                children: 'a', // 對應 HTML 結構中的 <a> 標籤
                pswpModule: PhotoSwipe,
            };

            const lightbox = new PhotoSwipeLightbox(options);

            // 註冊 UI 元素 (自訂說明文字)
            lightbox.on('uiRegister', function() {
                lightbox.pswp.ui.registerElement({
                    name: 'custom-caption',
                    order: 9,
                    isButton: false,
                    appendTo: 'root',
                    html: '', // 初始為空
                    onInit: (el, pswp) => {
                        // 監聽 slide 切換事件
                        pswp.on('change', () => {
                            const currSlideElement = pswp.currSlide.data.element;
                            let captionHTML = '';

                            if (currSlideElement) {
                                // 嘗試找尋隱藏的 caption 區塊
                                const hiddenCaption = currSlideElement.querySelector('.hidden-caption-content');
                                
                                if (hiddenCaption) {
                                    captionHTML = hiddenCaption.innerHTML;
                                } else {
                                    // 如果沒有隱藏區塊，則抓取 img 的 alt 屬性
                                    const img = currSlideElement.querySelector('img');
                                    if (img) {
                                        captionHTML = img.getAttribute('alt');
                                    }
                                }
                            }
                            
                            // 將文字填入 UI
                            el.innerHTML = captionHTML || '';
                            
                            // 如果有文字就顯示，沒文字就隱藏
                            if(captionHTML){
                                el.style.display = 'block';
                            } else {
                                el.style.display = 'none';
                            }
                        });
                    }
                });
            });

            lightbox.init();
        </script>
        <!-- 相簿主圖燈箱套件_效果區塊-第一塊 end-->

        <!-- 附加aos動畫 -->
        <script>

            document.querySelectorAll('.album_area .album_list').forEach(function(el, index) {
                var id = 'album_' + (index + 1);
                var delay = 500 + index * 100;

                el.id = id;
                el.setAttribute('data-aos', 'fade-right');
                el.setAttribute('data-aos-delay', delay.toString());
                el.setAttribute('data-aos-duration', '1000');
                el.setAttribute('data-aos-anchor', '#' + id);
                el.setAttribute('data-aos-anchor-placement', 'bottom');
                el.setAttribute('data-aos-once', 'true');
                el.setAttribute('data-aos-easing', 'ease-in-sine');
            });


        </script>




			<!-- InstanceEndEditable -->
			
      	</div> 
        
    </main>  
 <%@include file="../include/copyright.jsp" %> 


    <!--版腳-->


</body>
<!-- InstanceEnd --></html>
<%@include file="/WEB-INF/jspf/connclose.jspf" %>
