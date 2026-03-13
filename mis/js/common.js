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
			

			//當高度小於100時，關閉區塊 
			// if($this_Top < 100){
			// 	$('.social_btn_area').stop().animate({bottom:"30px"});
			// }
			// if($this_Top > 100){
			// 	$('.social_btn_area').stop().animate({bottom:"185px"});
			// }
			
			
			
			//當視窗卷軸滑動時，版頭下緣陰影會有顯示、隱藏的動作
			//當高度小於55時，關閉區塊 
			if($this_Top < 55){
				$('.header').stop().removeClass("fixed");
			}
			if($this_Top > 55){
				$('.header').stop().addClass("fixed");
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
	
	//----------------------------------將主體添加最小高度 讓footer置底----------------------------------
	function mainH() {
		winHeight    = $(window).height();
		hederHeight  = $(".header").innerHeight();
		footerHeight = $(".footer").innerHeight();
		
		var default_table_topH = $(".default_table_top").innerHeight();
		var admin_navbarH = $(".admin_navbar").innerHeight();
		var system_bk2W = $(".page_mis .system_bk-2").width();
		var copyright_pcH = $(".copyright.pc").innerHeight();

		
		//console.log(copyright_pcH)

		$(".page_mis").css({
			'min-height': winHeight-default_table_topH-0+'px',		//"-30"這要隨每個案子不同調整
			//'padding-top': default_table_topH-0+'px'
		})

		if ( $(window).width() <=  990 ) {
			$(".header_rightArea").css({
				//'padding-top': default_table_topH-0+'px'
			})
			// $(".leftListArea").css({
			// 	'max-height': '',
			// })
			$(".right_content_in.scroll").css({
				'max-width':($(window).width() * 0.9) + 'px',
			})
		}else{
			$(".header_rightArea").css({
				//'padding-top': ''
			})
			$(".right_content_in.scroll").css({
				'max-width':'',
			})
			// $(".leftListArea").css({
			// 	'max-height': winHeight-default_table_topH-admin_navbarH-0+'px',
			// })
			// $(".right_content").css({
			// 	'max-width':'calc('+($(window).width() - system_bk2W)+'px - 20px - 2.5rem)',
			// 	'max-height':'calc('+(winHeight - default_table_topH - copyright_pcH)+'px - 20px - 2.5rem)',
			// })
		}

		// $(".id_offset").css({			
		// 	'transform': 'translateY(-'+hederHeight+'px)'
		// })
	}
	
	mainH();
	
	setTimeout(function(){
		mainH();
	},300)
	
	$(window).on("resize scroll", function (e) {
		setTimeout(function(){
			mainH();
		},300)
	});

	// $(window).resize(function(e) {
	// 	setTimeout(function(){
	// 		mainH();
	// 	},300)
	// });
	
	
	//----------------------------------手機版主按鍵收合----------------------------------
	$(function(){
		$(".menu_btn").click(function(e) {
            $(this).toggleClass("active");
			$(".header_rightArea").toggleClass("active");
			$("body").toggleClass("active");
			e.stopPropagation();
        });
		
		$(window).resize(function(e) {
			var win_W		 = $(window).width();			//螢幕寬度
            if ( win_W > 990 ) {
				$(".header_rightArea").removeClass("active");
				$("body").removeClass("active");
				$(".menu_btn").removeClass("active");
			}
        });
		
		$(".header_rightArea").click(function(e) {
            e.stopPropagation();
        });
		
		$(window).click(function(e) {
            $(".header_rightArea").removeClass("active");
			$("body").removeClass("active");
			$(".menu_btn").removeClass("active");
        });
	});
	
	







//----------------------------------主按鍵收合----------------------------------
$(function(){
	
	$(".nav").children(".navTitle").click(function(e) {			
		$(this).siblings(".navOpen.mobile").slideToggle("fast");
		$(".nav").children(".navTitle").not(this).siblings(".navOpen.mobile").slideUp("fast");

		$(this).parent().toggleClass("active");
		$(".nav").children(".navTitle").not(this).parent().removeClass("active");
		
		e.stopPropagation();
	});
	
	$(".navOpen.mobile").click(function(e) {
		e.stopPropagation();
	});
	
	$(window).click(function(e) {
		$(".navOpen.mobile").slideUp("fast");
	});


	// $(".nav").children("a").click(function(e) {
	// 	$(this).siblings(".navOpen.mobile").slideToggle("fast");
	// 	$(".nav").children("a").not(this).siblings(".navOpen.mobile").slideUp("fast");
		
	// 	e.stopPropagation();
	// });
	
	// $(".navOpen.mobile").click(function(e) {
	// 	e.stopPropagation();
	// });
	
	// $(window).click(function(e) {
	// 	$(".navOpen.mobile").slideUp("fast");
	// });
	

});		
	





	
	//----------------------------------mobile主按鍵第2層收合----------------------------------
	$(function(){
		$(".navOpen.mobile.sstc").find(".sstc_title").click(function(e) {
			$(this).toggleClass("active");
            $(this).siblings(".navOpen.mobile.sstc .sstc_m_bg").slideToggle("fast");
			$(".navOpen.mobile.sstc .sstc_title").not(this).siblings(".sstc_m_bg").slideUp("fast");
			$(".navOpen.mobile.sstc .sstc_title").not(this).removeClass("active");
			
			e.stopPropagation();
        });
		
		$(".navOpen.mobile.sstc .sstc_m_bg").click(function(e) {
            e.stopPropagation();
        });
		
		$(window).click(function(e) {
            $(".navOpen.mobile.sstc .sstc_m_bg").slideUp("fast");
        });
		// $(".navOpen.mobile.sstc").find(".sstc_title").children("a").click(function(e) {
        //     $(this).parent(".navOpen.mobile.sstc .sstc_list").siblings(".navOpen.mobile.sstc .sstc_m_bg").slideToggle("fast");
		// 	$(".navOpen.mobile.sstc .sstc_title").children("a").not(this).parent(".navOpen.mobile.sstc .sstc_list").siblings(".sstc_m_bg").slideUp("fast");
			
		// 	e.stopPropagation();
        // });
		
		// $(".navOpen.mobile.sstc .sstc_m_bg").click(function(e) {
        //     e.stopPropagation();
        // });
		
		// $(window).click(function(e) {
        //     $(".navOpen.mobile.sstc .sstc_m_bg").slideUp("fast");
        // });
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

		$(function(){
			$(".top_title").click(function(e) {
				$(".topListArea").toggleClass("show");
				$(".top_title").toggleClass("active");
			});
		})	
        

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


	$(function(){
		$(".category_changeButton").click(function(e) {		
			if ( $(window).width() <= 990 ) { // Eric修改-手機版時才有收合效果 860隨每個案子修改
			$(this).toggleClass("active");
				
				$(".leftListArea").slideToggle("slow").toggleClass("active");
				$("body").toggleClass("active");
				e.stopPropagation();
            }
        });

	
	});




	
	//----------------------------------左選單第二層收合----------------------------------
	// $(function(){
	// 	$(".leftList").children("a").click(function(e) {
	// 		$(".leftList").children("a").not(this).parent(".leftList").removeClass("active");
	// 		$(this).parent(".leftList").toggleClass("active");
			
	// 		$(".leftList").children("a").not(this).siblings(".leftList_open").slideUp();
    //         $(this).siblings(".leftList_open").slideToggle();
    //     });
	// })

	$(function(){
		$(".leftList").children(".leftList_title").click(function(e) {
			$(".leftList").children(".leftList_title").not(this).parent(".leftList").removeClass("active");
			$(this).parent(".leftList").toggleClass("active");

			$(".leftList").children(".leftList_title").not(this).siblings(".leftList_open").slideUp();
            $(this).siblings(".leftList_open").slideToggle();
        });
	})





	//----------------------------------左選單第三層收合----------------------------------
	$(function(){
		$(".leftList_sec_title").click(function(e) {			
			//$(".leftList_sec_title").not(this).removeClass("active");
			$(".leftList_sec_title").parent().parent().siblings().find('.leftList_sec_title').not(this).removeClass("active");
			$(this).toggleClass("active");
			
			$(".leftList_sec_title").not(this).siblings(".leftList_third_area").slideUp();
			$(this).siblings(".leftList_third_area").slideToggle();
		});
	})
	
	






//----------------------------------測試時隱藏連結用----------------------------------
//$(function() {
	//$(".navbar a ,  .mainContent a , .footer_navbar a").attr("href" , "javascript:void(0)");
	// $(".mLI_btn input").attr("onclick" , "location='javascript:void(0)'");

//	$(".leftList a").attr("href", "javascript:void(0)");
//});





	

  //------------------------ 使手機版LINE 另開手機預設瀏覽器 20181226 -------------------
	if (/Line/.test(navigator.userAgent)) {
		var str=location.href
		if(str.indexOf("?")>-1)location.href =  location.href + '&openExternalBrowser=1';
		else location.href =  location.href + '?openExternalBrowser=1';
	}
 
 

$(function(){
});