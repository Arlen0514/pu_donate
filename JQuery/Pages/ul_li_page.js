var a = document.getElementById("alls").getElementsByTagName("li"); 
var zz =new Array(a.length) 
for(var i=0;i <a.length;i++) 
{ zz[i]=a[i].innerHTML } //DVI的字符串數組付給zz
var pageno=1               //當前頁
var pagesize=10            //每頁多少筆訊息
if(zz.length%pagesize==0)
{var  pageall =zz.length/pagesize }
else
{var  pageall =parseInt(zz.length/pagesize)+1}//共多少頁 

function change(e){
pageno=e;
if(e<1)//如果輸入頁小於1
{ e=1;pageno=1}//就等於第1頁,當前頁為1
if(e>pageall)//如果輸入頁大於最大頁 
{e=pageall;pageno=pageall}//輸入頁和當前頁都等於最大頁
document.getElementById("alls").innerHTML=""//全部清空
for(var i=0;i<pagesize;i++)
 {
   var div =document.createElement("li")//建立DIV對象
   div.innerHTML=zz[(e-1)*pagesize+i]//建立顯示元素
   document.getElementById("alls").appendChild(div)//加入id(alls)中  
   if(zz[(e-1)*pagesize+i+1]==null)//超出範圍跳出
   break 
  }
var ye=""
for(var j=1;j<=pageall;j++)
{
  if(e==j)
  {ye=ye+"<span><a href='#"+j+"' onClick='change("+j+")' style='color:#FF0000'>"+j+"</a></span> "}
  else
  {ye=ye+"<a href='#"+j+"' onClick='change("+j+")'>"+j+"</a> "}
}
var nav = '<a href="#1" onClick="change(1)">第一頁</a>\n\<a href="#' + (pageno + 1) + '" onClick="change(' + (pageno + 1) + ')">下一頁</a>\n\<a href="#' + (pageno > 1 ? (pageno - 1) : 1) + '" onClick="change(' + (pageno - 1) + ')">上一頁</a>\n\<a href="#' + pageall + '" onClick="change(' + pageall + ')">最後頁</a>';
document.getElementById("a1").innerHTML=pageall
document.getElementById("a2").innerHTML=pageno
document.getElementById("a3").innerHTML=ye
document.getElementById("a5").innerHTML=nav;
}
var current_page = location.href.split('#');
current_page = current_page[1] ? parseInt(current_page[1], 10) : 1;
change(current_page);