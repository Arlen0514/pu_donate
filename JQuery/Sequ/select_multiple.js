$(function(){
   $("#left_select option:first,#right_select option:first").attr("selected",true);
  
   $("#left_select").dblclick(function(){
     var alloptions = $("#left_select option");
     var so = $("#left_select option:selected");

     so.get(so.length-1).index == alloptions.length-1?so.prev().attr("selected",true):so.next().attr("selected",true);
    
     $("#right_select").append(so);
   });
  
   $("#right_select").dblclick(function(){
     var alloptions = $("#right_select option");
     var so = $("#right_select option:selected");
    
     so.get(so.length-1).index == alloptions.length-1?so.prev().attr("selected",true):so.next().attr("selected",true);
    
     $("#left_select").append(so);
   });
  
   $("#add").click(function(){
     var alloptions = $("#left_select option");
     var so = $("#left_select option:selected");

     so.get(so.length-1).index == alloptions.length-1?so.prev().attr("selected",true):so.next().attr("selected",true);
    
     $("#right_select").append(so);
   });
  
   $("#remove").click(function(){
     var alloptions = $("#right_select option");
     var so = $("#right_select option:selected");
    
     so.get(so.length-1).index == alloptions.length-1?so.prev().attr("selected",true):so.next().attr("selected",true);
    
     $("#left_select").append(so);
   });
  
   $("#addall").click(function(){
     $("#right_select").append($("#left_select option").attr("selected",true));
   });
  
   $("#removeall").click(function(){
     $("#left_select").append($("#right_select option").attr("selected",true));
   });
  
   $("#left_selectup").click(function(){
     var so = $("#left_select option:selected");
     if(so.get(0).index!=0){
       so.each(function(){
           $(this).prev().before($(this));
       });
     }
   });
  
   $("#left_selectdown").click(function(){
     var alloptions = $("#left_select option");
     var so = $("#left_select option:selected");
    
     if(so.get(so.length-1).index!=alloptions.length-1){
       for(i=so.length-1;i>=0;i--)
       {
         var item = $(so.get(i));
         item.insertAfter(item.next());
       }
     }
   });
  
   $("#right_selectup").click(function(){
     var so = $("#right_select option:selected");
     if(so.get(0).index!=0){
       so.each(function(){
           $(this).prev().before($(this));
       });
     }
   });
  
   $("#right_selectdown").click(function(){
     var alloptions = $("#right_select option");
     var so = $("#right_select option:selected");
    
     if(so.get(so.length-1).index!=alloptions.length-1){
       for(i=so.length-1;i>=0;i--)
       {
         var item = $(so.get(i));
         item.insertAfter(item.next());
       }
     }
   });
});