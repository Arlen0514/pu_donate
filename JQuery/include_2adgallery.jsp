<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/JQuery/2ad-gallery/ad-gallery.css" />
<style type="text/css">
.demo{width:660px; margin:20px auto;}
#gallery {padding:30px;background:#;}
</style>
<script type="text/javascript" src="<%=request.getContextPath()%>/JQuery/2ad-gallery/jquery.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/JQuery/2ad-gallery/jquery.ad-gallery.js"></script>
<script type="text/javascript">
$(function(){
    $('.ad-gallery').adGallery();
});
</script>
