function mm_openbrwindow ( theurl, winname, features )
{
window.open( theurl, winname, features );
}
function check_uid ( uid )
{
	if( uid.length <= 0 )
		return( "請輸入帳號資料!\n" );
	if( uid.length <3 || uid.length> 16 )
		return( "您的帳號長度只能 3 至 16 個字元 !\n" );
	if ( !(uid.charAt(0)>= 'a' && uid.charAt(0) <= 'z') ) {
		return( "您的帳號第一字元只能為小寫字母 !\n" );
	}
	for( idx = 0 ; idx <uid.length ; idx++ )
	{
		if( uid.charAt(idx)>= 'A' && uid.charAt(idx) <= 'Z' )
			return( "帳號不可以含有大寫字元 !\n" );
		if( !( ( uid.charAt(idx)>= 'a' && uid.charAt(idx) <= 'z' ) || ( uid.charAt(idx)>= '0' && uid.charAt(idx) <= '9' ) || ( uid.charAt(idx) == '_' ) ) )
			return( "您的帳號只能是數字,英文字母及「_」等符號,其他的符號都不能使用 !\n" );
		if( uid.charAt(idx) == '_' && uid.charAt(idx-1) == '_' )
			return( "「_」符號不可相連 !\n" );
	}
	
	if( uid.charAt( uid.length - 1 ) == '_' )
		return( "「_」符號不可在最後 !\n" );
	return "";
}

function check_passwd ( pw1, pw2 )
{
	if( pw1 == '' ) {
		return ("請輸入密碼資料！\n");
	}
	for( var idx = 0 ; idx <pw1.length ; idx++ ){
		if( pw1.charAt(idx) == ' ' || pw1.charAt(idx) == '\"' )
			return ("密碼不可以含有空白或雙引號 !\n");
		if( pw1.length <6 || pw1.length> 32 )
			return( "密碼長度只能 6 到 32 個字母 !\n" );
		if( pw1 != pw2 )
			return("密碼二次輸入不一樣,請重新輸入 !\n");
		for( idx = 0 ; idx <pw1.length ; idx++ )		{
			if( pw1.charAt(idx)>= 'A' && pw1.charAt(idx) <= 'Z' )
				return( "密碼不可以含有大寫字元 !\n" );
			if( !( ( pw1.charAt(idx)>= 'a' && pw1.charAt(idx) <= 'z' ) || ( pw1.charAt(idx)>= '0' && pw1.charAt(idx) <= '9' ) || ( pw1.charAt(idx) == '_' ) ) )
				return( "您的密碼只能是數字,英文字母及「_」等符號,其他的符號都不能使用 !\n" );
		}
	}
	return "";
}
function check_ht ( ht )
{
if( ht == '' )
return( "密碼提示不可以空白 !\n" );
return "";
}
function check_telephonenumber ( number )
{
	var error = false;
	if( number.length <= 0 )
		return "您的通訊電話還沒填呢 !\n";
	for( idx = 0 ; idx <number.length ; idx++ ) {
		if( !( ( number.charAt(idx)>= '0' && number.charAt(idx) <= '9' ) || ( number.charAt(idx) == '-' ) ) ) {
			error = true;
			break;
		}
	}
	if( error == true )
		return "您的通訊電話只能是數字及'-'等符號, 其他的符號都不能使用 !\n";
	return "";
}


function check_email1 ( email )
{
	var len = email.length;
	if(len==0)
		return "請輸入E-Mail資料";
	for(var i=0;i<len;i++)
	{ 
		var c= email.charAt(i);
		if(!((c>="A"&&c<="Z")||(c>="a"&&c<="z")||(c>="0"&&c<="9")||(c=="-")||(c=="_")||(c==".")||(c=="@")))
			return "您的電子郵件地址只能是數字,英文字母及'-','_'等符號,其他的符號都不能使用 !\n";
	}
	if((email.indexOf("@")==-1)||(email.indexOf("@")==0)||(email.indexOf("@")==(len-1)))
		return "您的電子郵件地址不合法 !\n";
	if((email.indexOf("@")!=-1)&&(email.substring(email.indexOf("@")+1,len).indexOf("@")!=-1))
		return "您的電子郵件地址不合法 !\n";
	if((email.indexOf(".")==-1)||(email.indexOf(".")==0)||(email.lastIndexOf(".")==(len-1)))
		return "您的電子郵件地址不完全 !\n";
	return "";
}

function check_upload ( upstr )
{
	var len = upstr.length;
	if(len==0)
		return "請輸入檔案名稱資料";
	for(var i=0;i<len;i++)
	{ 
		var c= upstr.charAt(i);
		if(!((c>="A"&&c<="Z")||(c>="a"&&c<="z")||(c>="0"&&c<="9")||(c=="-")||(c=="_")||(c==".")))
			return "您的檔案名稱只能是數字,英文字母及 '.' , '-' , '_' 等符號,其他的符號都不能使用 !\n";
	}
	return "";
}

function check_identity ( id )
{
	if( id.length > 0  ) {
		var myid = id;
		myid = myid.toUpperCase();
		id = myid;
		if(myid.length>10)
			return "您的身分證字號超過10個字 !\n";
		if(myid.length<10)
			return "您的身分證字號不滿10個字 !\n";
		var c = myid.charAt(0);
		if(c<"A" || c> "Z")
			return "您的身分證字號第一碼必須是大寫的英文字母 !\n";
		c = myid.charAt(1);
		if(c!="1" && c!="2")
			return "您的身分證字號第二碼有問題 !\n";
		for(i=1;i<10;i++)
			if(isNaN(parseFloat(myid.charAt(i))))
				return "您的身分證字號第二到十碼有問題 !\n";
		var alph = new Array("A","B","C","D","E","F","G","H","J","K","L","M","N","P","Q","R","S","T","U","V","X","Y","W","Z","I","O");
		var num = new Array("10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35");
		var n=0;
		for(i=0;i<alph.length;i++)
			if(myid.charAt(0)==alph[i])
				n=i;
		var tot1 = parseFloat(num[n].charAt(0)) + (parseFloat(num[n].charAt(1)) * 9);
		var tot2 = 0;
		for(i=1;i<myid.length-1;i++)
			tot2 = tot2 + parseFloat(myid.charAt(i))*(9-i);
		var tot3 = parseFloat(myid.charAt(9));
		var tot4 = tot1 + tot2 + tot3;
		if((tot4 % 10)!=0)
			return "您的身分證字號有問題 !\n";
	} else {
			return "您的身分證字號還沒填呢 !\n";
	}
	return "";
}
function check_null ( column, name )
{
if( column.length == 0 )
return name + "不可以空白 !\n";
return "";
}
function check_select ( select, name )
{
if( select.options[0].selected == true )
return name + "必須選擇 !\n";
return "";
}
function check_radio ( radio, name )
{
var error = true;
for( i=0; i <radio.length; i++ )
if( radio[i].checked == true ) {
error = false;
break;
}
if( error == true )
return name + "必須選擇 !\n";
return "";
}
function check_birthday_year( year )
{
var error = false;
if( year.length != 4 )
return ("您的生日年份必須是四個數字, 例如 1980 年 !\n");
for( idx = 0 ; idx <year.length ; idx++ ) {
if( !( year.charAt(idx)>= '0' && year.charAt(idx) <= '9' ) ) {
error = true;
break;
}
}
if( error == true )
return ("您的生日年份必須是四個數字, 例如 1980 年 !\n");
return "";
}
function check_mobilephone ( number )
{
	var error = false;
	if( number.length > 0 ) {
		if( number.length >= 24 )
			return "您的行動電話有問題 !\n";
		for( idx = 0 ; idx <number.length ; idx++ ) {
			if( !( number.charAt(idx)>= '0' && number.charAt(idx) <= '9' ) && number.charAt(idx)!='-' && number.charAt(idx)!='+' ) {
				error = true;
				break;
			}
		}
	}
	if( error == true )
		return "您的行動電話只能是數字, 其他的符號都不能使用 !\n";
	else
		return "";
}
function delete_pid ( pid, done )
{
if( confirm( "您是否要刪除此網路身份?" ) )
location.href = 'ct?t=p&pid=' + pid + '&f=d&done=' + done;
}
