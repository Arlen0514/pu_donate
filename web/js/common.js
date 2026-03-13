// JavaScript共用區
//20160921 by kevin

	var winHeight    = $(window).height();          //螢幕高度
	var win_W		 = $(window).width();			//螢幕寬度
	var hederHeight  = $(".header").innerHeight();;	//版頭高度
	var footerHeight = $(".footer").innerHeight();;	//版腳高度

	//浮動式top鍵
	$(window).load(function(){
		$(window).bind('scroll resize', function(){
			var $this = $(this);
			var $this_Top=$this.scrollTop();
			
			//當高度小於100時，關閉區塊 
			if($this_Top < 100){
				$('.topBtn').stop().animate({bottom:"-70px"});
			}
			if($this_Top > 100){
				$('.topBtn').stop().animate({bottom:"133px"});
			}
			
			
			//當視窗卷軸滑動時，版頭下緣陰影會有顯示、隱藏的動作
			//當高度小於55時，關閉區塊 
			if($this_Top < 55){
				$('.header , .headerArea').stop().removeClass("fixed");
			}
			if($this_Top > 55){
				$('.header , .headerArea').stop().addClass("fixed");
			}
		}).scroll();
	});
	
	//錨點平滑滾動效果
	$(function(){
		$('a[href*=#]').click(function() {
			if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {
				var $target = $(this.hash);
				$target = $target.length && $target || $('[name=' + this.hash.slice(1) + ']');
				if ($target.length) {
					var targetOffset = $target.offset().top;
					$('html,body').animate({
						scrollTop: targetOffset
					},
					1000);
					return false;
				}
			}
		});
	});
	


	
	//----------------------------------將主體添加最小高度 & 修正 Banner 位置----------------------------------
    
    let lastWindowWidth = window.innerWidth;
    let resizeTimer;

    function fixMainPadding() {
        window.requestAnimationFrame(() => {
            const header = document.querySelector('.header');
            const footer = document.querySelector('.footer');
            const main = document.querySelector('.main'); // 修正：你的 HTML 是 .main 不是 .inmain

            // ✅ 安全檢查
            if (!header || !footer || !main) return;

            const headerHeight = header.offsetHeight;
            const footerHeight = footer.offsetHeight;
            const windowW = window.innerWidth;

            // 1. 設定 main 的 min-height (讓 footer 置底)
            main.style.minHeight = (window.innerHeight - 0 - footerHeight) + 'px';

            // 2. 修正 padding-top (解決 Banner 上方多出一塊的問題)
            // 如果你的 Header 是 fixed (浮動)，內容需要往下推，否則會被擋住。
            
            if (windowW <= 990) {
                // 【手機版設定】
                // 如果手機版 Banner 上方多出一塊，通常是因為這裡推太多了。
                // 試著將這裡設為 0，讓 CSS 控制，或是只推一點點。
                
                main.style.paddingTop = '0px'; 
                
                // 如果設為 0px Banner 被 Header 擋住，請改用下面這行 (推開 Header 的高度)：
                // main.style.paddingTop = headerHeight + 'px'; 
                
            } else {
                // 【電腦版設定】
                // 電腦版通常需要推開 Header 高度
                main.style.paddingTop = 0 + 'px';
            }
        });
    }

    // ✅ 頁面載入時執行 (多次執行確保抓到圖片載入後的高度)
    window.addEventListener('load', () => {
        fixMainPadding();
        setTimeout(fixMainPadding, 100); 
        setTimeout(fixMainPadding, 500); 
    });

    // ✅ 視窗縮放時執行
    window.addEventListener('resize', () => {
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(() => {
            fixMainPadding();
        }, 50); // 縮短延遲讓反應更靈敏
    });

	
	
	
	







	//----------------------------------將主體添加最小高度 讓footer置底----------------------------------
	// function mainH() {
	// 	winHeight    = $(window).height();
	// 	hederHeight  = $(".header").innerHeight();
	// 	footerHeight = $(".footer").innerHeight();
		
	// 	$(".main").css({
	// 		'min-height': winHeight-hederHeight-footerHeight-0+'px'		//"-30"這要隨每個案子不同調整
	// 	})
	// }
	
	// mainH();
	
	// setTimeout(function(){
	// 	mainH();
	// },300)
	
	// $(window).resize(function(e) {
	// 	setTimeout(function(){
	// 		mainH();
	// 	},300)
	// });
	
	
	//----------------------------------手機版主按鍵收合----------------------------------
	$(function(){

		$(".menu_btn").click(function(e) {
            $(this).toggleClass("active");
			// $(this).addClass("active cd-btn cd-modal-trigger");
			$(".headerRight").toggleClass("active");
			$("body").toggleClass("active");
			e.stopPropagation();
        });

		$(window).resize(function(e) {
			var win_W		 = $(window).width();			//螢幕寬度
            if ( win_W > 990 ) {
				$(".headerRight").removeClass("active");
				$("body").removeClass("active");
				$(".menu_btn").removeClass("active");	
			}			
        });

		$(".headerRight").click(function(e) {
            e.stopPropagation();
        });
		
		$(window).click(function(e) {
            $(".headerRight").removeClass("active");
			$("body").removeClass("active");
			$(".menu_btn").removeClass("active");
        });
	});
	
	




	
	//----------------------------------主按鍵收合----------------------------------
	$(function(){
		$(".nav").children(".nav_title").children(".navOpen_icon").click(function(e) {
			$(this).parent().parent(".nav").children(".navOpen.mobile").slideToggle("fast");
			$(".nav").children(".nav_title").children(".navOpen_icon").not(this).parent(".nav_title").siblings(".navOpen.mobile").slideUp("fast");            
			e.stopPropagation();
        });
		
		$(".navOpen_icon").click(function(e) {
            e.stopPropagation();
        });	

		$(window).click(function(e) {
            $(".navOpen.mobile").slideUp("fast");
        });


		// $(".nav").children("a").click(function(e) {
        //     $(this).siblings(".navOpen.mobile").slideToggle("fast");
		// 	$(".nav").children("a").not(this).siblings(".navOpen.mobile").slideUp("fast");
			
		// 	e.stopPropagation();
        // });
		
		// $(".navOpen.mobile").click(function(e) {
        //     e.stopPropagation();
        // });
		
		// $(window).click(function(e) {
        //     $(".navOpen.mobile").slideUp("fast");
        // });
		
		//nav手機箭頭
		if ( win_W <= 990 ) {
			$(".nav").children(".nav_title").children(".navOpen_icon").click(function(e) {
				$(this).toggleClass("show");
				$(".nav").children(".nav_title").children(".navOpen_icon").not(this).removeClass("show");
				e.stopPropagation();
			});
		}
	
	});		
	







	//----------------------------------手機板左選單收合----------------------------------
	$(function(){
		$(".left_title").click(function(e) {		
			if ( $(window).width() <= 990 ) { // Eric修改-手機版時才有收合效果 860隨每個案子修改
			$(this).toggleClass("active");
				
				$(".leftListArea").slideToggle("slow");
				$("body").toggleClass("active");
				e.stopPropagation();
            }
        });
        

		//  Eric 20190529修改 判斷當前左選單是否為手機版
		var mobile_left = false;
		$(window).load(function(){
			if ( $(window).width() <= 990 ) { 
				mobile_left = true;
            }
		});
        // Eric 20180314 返回pc時 左選單選單回覆展開狀態 20190529修改
       	$(window).resize(function(e) {
			//  860隨每個案子修改
			if ( $(window).width() > 990 ) { 
				$(".left_title").removeClass("active");
				$(".leftListArea").show();
				$("body").removeClass("active");
				mobile_left = false;
			}
			// Eric修改-手機版時才有收合效果 767隨每個案子修改 
			if ( $(window).width() <= 990) { 
				if(!mobile_left){ // Eric 20190529 增加判斷當前左選單是否為手機版
					$(".leftListArea").hide();
				}
				mobile_left = true;
				/*$(this).toggleClass("active");*/
				/*$(".leftListArea").slideToggle("slow");*/
				/*$("body").toggleClass("active");*/
            }
			e.stopPropagation();
     	});

	
	});


	//----------------------------------左選單第二層收合----------------------------------
	$(function(){
		$(".leftList").children("a").click(function(e) {
			$(".leftList").children("a").not(this).parent(".leftList").removeClass("active");
			$(this).parent(".leftList").toggleClass("active");
			
			$(".leftList").children("a").not(this).siblings(".leftList_open").slideUp();
            $(this).siblings(".leftList_open").slideToggle();
        });
	})	
	





	

  //------------------------ 使手機版LINE 另開手機預設瀏覽器 20181226 -------------------
	if (/Line/.test(navigator.userAgent)) {
		var str=location.href
		if(str.indexOf("?")>-1)location.href =  location.href + '&openExternalBrowser=1';
		else location.href =  location.href + '?openExternalBrowser=1';
	}
 
 





//	//----------------------------------測試時隱藏連結用----------------------------------
$(function(){
	//$(".nav a").attr("href" , "javascript:void(0)");
	//$(".nav:first a").attr("href" , "javascript:void(0)");
	//$(".nav:nth-child(2) > a").attr("href" , "javascript:void(0)");
	//$(".nav:nth-child(3) a").attr("href" , "javascript:void(0)");
	//$(".nav:nth-child(4) a").attr("href" , "javascript:void(0)");
	//$(".nav:nth-child(5) a").attr("href" , "javascript:void(0)");
	//$(".nav:nth-child(6) a").attr("href" , "javascript:void(0)");
	//$(".nav:nth-child(7) a").attr("href" , "javascript:void(0)");
	//$(".nav:nth-child(8) a").attr("href" , "javascript:void(0)");
	//$(".nav:nth-child(9) a").attr("href" , "javascript:void(0)");
	//$(".nav:nth-child(10) a").attr("href" , "javascript:void(0)");
	//$(".nav:nth-child(11) a").attr("href" , "javascript:void(0)");		
	//$(".nav:nth-child(12) a").attr("href" , "javascript:void(0)");		
	//$(".nav:nth-child(13) a").attr("href" , "javascript:void(0)");	
			
	//$(".mLI_btn input").attr("onclick" , "location='javascript:void(0)'");		
	//$(".htLink:nth-child(1) a").attr("href" , "javascript:void(0)");
	//$(".indexDonateProjectBg a").attr("href" , "javascript:void(0)");


	//$(".sitemapArea a").attr("href" , "javascript:void(0)");
	//$(".index_news:first a").attr("href" , "javascript:void(0)");
	//$(".index_newsArea:eq(4) a").attr("href" , "javascript:void(0)");
	//$(".index_news.index_news2 a").attr("href" , "javascript:void(0)");
	//$(".index_newsBg .index_news:eq(4) a").attr("href" , "javascript:void(0)");
	//$(".index_news.index_course #tab2 a").attr("href" , "javascript:void(0)");


	
	
	//$(".index_addBg a ").attr("href" , "javascript:void(0)");
	//$(".footer_navbar a , .footer_link a").attr("href" , "javascript:void(0)");
	//$(".footer_navbar a").attr("href" , "javascript:void(0)");
	//$(".footer_nav:nth-child(5) a , .footer_nav:nth-child(7) a , .footer_nav:nth-child(8) a , .footer_nav:nth-child(9) a").attr("href" , "javascript:void(0)");
	//$(".main a").attr("href" , "javascript:void(0)");

});	


 


$(function(){
});