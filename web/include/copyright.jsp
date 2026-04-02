<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String copr_company = SiteSetup.getSetup("cp.company" + "." + lang).getString("ss_text"),
		copr_address = SiteSetup.getSetup("cp.address" + "." + lang).getString("ss_text"),
		copr_address_link = SiteSetup.getSetup("cp.address_link" + "." + lang).getString("ss_text"),
		copr_email = SiteSetup.getSetup("cp.email" + "." + lang).getString("ss_text"),
		copr_phone = SiteSetup.getSetup("cp.phone" + "." + lang).getString("ss_text"),
		copr_fax = SiteSetup.getSetup("cp.fax" + "." + lang).getString("ss_text"),
		web_alumni_center_url = SiteSetup.getSetup("web_alumni_center_url" + "." + lang).getString("ss_text"),
		campus_url = SiteSetup.getSetup("campus_url" + "." + lang).getString("ss_text"),
		library_url = SiteSetup.getSetup("library_url" + "." + lang).getString("ss_text"),
		sport_url = SiteSetup.getSetup("sport_url" + "." + lang).getString("ss_text"),
		web_alumni_center_title = SiteSetup.getSetup("web_alumni_center_title" + "." + lang).getString("ss_text"),
		campus_title = SiteSetup.getSetup("campus_title" + "." + lang).getString("ss_text"),
		library_title = SiteSetup.getSetup("library_title" + "." + lang).getString("ss_text"),
		sport_title = SiteSetup.getSetup("sport_title" + "." + lang).getString("ss_text"),
		privacy_url = SiteSetup.getSetup("cp.privacy_link" + "." + lang).getString("ss_text"),
		fb_url = SiteSetup.getSetup("cp.fb" + "." + lang).getString("ss_text"),
		yt_url = SiteSetup.getSetup("cp.yt" + "." + lang).getString("ss_text"),
		ig_url = SiteSetup.getSetup("cp.ig" + "." + lang).getString("ss_text"),
		td_url = SiteSetup.getSetup("cp.td" + "." + lang).getString("ss_text");

%>
<footer class="footer">
		<div class="CommunityBtn_area" style="bottom: 190px;">

            <!--右側浮動捐款-->
            <div class="donateBtn">
				<a target="_blank" href="../donate/donate.jsp">
                    <img src="../images/donate-01.webp" alt="donate" title="donate">
                </a>
                <div class="tab_description">
                    線上捐款
                </div>
            </div>
            <%if(!"".equals(download_file.getString("cp_image"))) { %>
            <div class="donateBtn">
				<a target="_blank" href="<%=app_fetchpath+"/donate_download/"+lang+"/"+download_file.getString("cp_image")%>">
                    <img src="../images/donate-02.webp" alt="download" title="download">
                </a>
                <div class="tab_description">
                    捐款單下載
                </div>
            </div>
            <%} %>
        </div>
    	<!--浮動top鍵--><!--js在common.js內-->
        <div class="topBtn">
            <a href="#top">
            	<span>TOP</span>
            </a>
        </div>
    	
        
        <!--版腳內容區塊-->
       	<div class="footer_content">
        	<div class="wrap">  

                <div class="footer_navbar">

                    <!--右側導覽列-->
                    <%if (!"".equals(web_alumni_center_url)) { %>
                    <div class="fR_nav fR_nav2">                    
                        <span>
                            <a href="<%=web_alumni_center_url %>" target="_blank">
                            	<%=web_alumni_center_title %>
                            </a>
                        </span>
                    </div>
                    <%} %>
                    <%if (!"".equals(campus_url)) { %>
                    <div class="fR_nav fR_nav2">                    
                        <span>
                            <a href="<%=campus_url %>" target="_blank">
                            	<%=campus_title %>
                            </a>
                        </span>
                    </div>
                    <%} %>
                    <%if (!"".equals(library_url)) { %>
                    <div class="fR_nav fR_nav2">                    
                        <span>
                            <a href="<%=library_url %>" target="_blank">
                            	<%=library_title %>
                            </a>
                        </span>
                    </div>
                    <%} %>
                    <%if (!"".equals(sport_url)) { %>
                    <div class="fR_nav fR_nav2">                    
                        <span>
                            <a href="<%=sport_url %>" target="_blank">
                            	<%=sport_title %>
                            </a>
                        </span>
                    </div>    
					<%} %>  

                    <div class="clearfloat">
                    </div>

                </div>

                

                <div class="footer_bottom">
                    <div class="footer_contentIn"> 
                        <div class="footer_contentItem">        
                            <%if (!"".equals(copr_company)) { %>
		                    <h3><%=copr_company %>
		                    </h3>
		                    <%} %>
                            <%if (!"".equals(copr_address)) { %>
		                    <h3>
		                        <i class="bi bi-geo-alt-fill"></i>
		                        <a href="<%=copr_address_link %>" target="_blank">
		                            地址：<%=copr_address %>
		                        </a>
		                    </h3>
		                    <%} %>                  
                            <%if (!"".equals(copr_email)) { %>
		                    <h3>
		                        <i class="bi bi-envelope-fill"></i>
		                        <a href="mailto:<%=copr_email %>" target="_blank">
		                            E-Mail：<%=copr_email %>
		                        </a>
		                    </h3>
		                    <%} %>
                            <%if (!"".equals(copr_phone)) { %>
		                    <h3>
		                        <i class="bi bi-chat-dots-fill"></i>
		                        <a href="tel:<%=copr_phone %>">電話：<%=copr_phone %>
		                        </a>
		                    </h3>
		                    <%} %>
		                    <%if (!"".equals(copr_fax)) { %>
		                    <h3>
		                        <i class="bi bi-printer-fill"></i>
		                        <a href="tel:<%=copr_fax %>">傳真：<%=copr_fax %>
		                        </a>
		                    </h3>
		                    <%} %>
                            <!-- <h3>
                                <i class="bi bi-printer-fill"></i>
                                <a href="tel:2-2462-2192">傳真：+886-2-2463-4096</a>
                            </h3> -->
                        </div>  

                        
                    </div>

                    <!--版權宣告-->
                    <div class="copyright">
                        <!-- <div class="wrap"> -->
                            © <%=DateTimeTool.getYear() + " "%> <a href="https://www.geneinfo.com.tw" target="_blank">Greatest Idea Strategy Co.,Ltd</a> All rights reserved.
                            <a class="privacy_policy" href="<%=privacy_url %>" target="_blank">隱私權聲明</a>
                    </div>

                    <div class="sns_linkBg">
                            <%if (!"".equals(fb_url)) { %>
                            <div class="list fb_link">
                                <a href="<%=fb_url %>" target="_blank">
                                    <img src="../images/fb_icon.svg" alt="facebook" title="facebook">
                                </a>
                            </div>
                            <%} %>
                           
                            <%if (!"".equals(ig_url)) { %>
                            <div class="list yt_link">
                                <a href="<%=ig_url %>" target="_blank">
                                    <img src="../images/ig_icon.svg" alt="instagram" title="instagram">
                                </a>
                            </div>
                            <%} %>
                            <%if (!"".equals(td_url)) { %>
                            <div class="list yt_link">
                                <a href="<%=td_url %>" target="_blank">
                                    <img src="../images/threads_icon.svg" alt="threads" title="threads">
                                </a>
                            </div>
                        	<%} %>
                        	
                        	 <%if (!"".equals(yt_url)) { %>
                            <div class="list yt_link">
                                <a href="<%=yt_url %>" target="_blank">
                                    <img src="../images/yt_icon.svg" alt="youtube" title="youtube">
                                </a>
                            </div>
                            <%} %>
							
                    </div>
                </div>
                
                
            </div>
        </div>
        
    </footer>
    
     <!--每滑到該區域重複執行-->   
    <script type="text/javascript" src="../js/aos/aos.js"></script> 
    <script>
      AOS.init();
    </script>   

    <!-- InkDrops水墨按鍵效果js -->
    <script type="text/javascript" src="../js/inkbtn/ink.js"></script>
    <!-- https://github.com/akhilarjun/InkDrops -->

    <!-- Ink Transition Effect水墨過度 -->
    <!-- <script type="text/javascript" src="web/js/ink_transition_effect/js/ink_transition_effec_main.js"></script>
    <script type="text/javascript" src="web/js/ink_transition_effect/js/modernizr.js"></script> -->