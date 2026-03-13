// Marco 20140507 修正預設 "請選擇" 的值為空字串
// Eebyjo 20161130 更新為中華郵政103.12.25版
// Miles 20170803 更新為中華郵政 106年6月
// Eric 20171122 修正新竹市
// Eric 20180306 修正嘉義市
// Nilson 20220113 新增英文版 更新版本為中華郵政 109.10.22版
// May 20241120 處理地址修改後，鄉鎮市區選項無法變更問題
// May 20241209 新增輸入郵遞區號取得地址所屬位置功能
//==================== for zip code begin =========================
County = new Array("Please Select", "Taipei City", "Keelung City", "New Taipei City", "Yilan County", "Hsinchu City",
		"Hsinchu County", "Taoyuan City", "Miaoli County", "Taichung City", "Changhua County", "Nantou County", " Chiayi City", 
		"Chiayi County", "Yunlin County", "Tainan City", "Kaohsiung City", "Penghu County", "Pingtung County", "Taitung County",
		"Hualien County", "Kinmen County", "Lienchiang County", "Nanhai Islands");

Zone = new Array(25);
Zone[0] = new Array("              ");
// for "臺北市"
Zone[1] = new Array("Please Select", "Zhongzheng Dist", "Datong Dist", "Zhongshan Dist", "Songshan Dist", "Da’an Dist",
					"Wanhua Dist", "Xinyi Dist", "Shilin Dist" ,"Beitou Dist", "Neihu Dist", "Nangang Dist" ,"Wenshan Dist");
// for "基隆市"
Zone[2] = new Array("Please Select", "Ren’ai Dist", "Xinyi Dist", "Zhongzheng Dist", "Zhongshan Dist", "Anle Dist",
					"Nuannuan Dist", "Qidu Dist");
// for "新北市"
Zone[3] = new Array("Please Select", "Wanli Dist", "Jinshan Dist", "Banqiao Dist", "Xizhi Dist", "Shenkeng Dist", "Shiding Dist",
					"Ruifang Dist", "Pingxi Dist", "Shuangxi Dist", "Gongliao Dist", "Xindian Dist", "Pinglin Dist", "Wulai Dist",
					"Yonghe Dist", "Zhonghe Dist", "Tucheng Dist", "Sanxia Dist", "Shulin Dist", "Yingge Dist", "Sanchong Dist",
					"Xinzhuang Dist", "Taishan Dist", "Linkou Dist", "Luzhou Dist", "Wugu Dist", "Bali Dist", "Tamsui Dist",
					"Sanzhi Dist", "Shimen Dist");
// for "宜蘭縣"
Zone[4] = new Array("Please Select", "Yilan City", "Toucheng Township", "Jiaoxi Township", "Zhuangwei Township", "Yuanshan Township",
					"Luodong Township", "Sanxing Township", "Datong Township", "Wujie Township" ,"Dongshan Township",
					"Su’ao Township", "Nan’ao Township");
// for "新竹市"
Zone[5] = new Array("Please Select", "East Dist", "North Dist", "Xiangshan Dist");
// for "新竹縣"
Zone[6] = new Array("Please Select", "East Dist", "North Dist", "Xiangshan Dist", "Xinpu Township", "Guanxi Township",
					"Qionglin Township", "Baoshan Township", "Zhudong Township", "Wufeng Township", "Hengshan Township",
					"Jianshi Township", "Beipu Township", "Emei Township");
// for "桃園市"
Zone[7] = new Array("Please Select", "Zhongli Dist", "Pingzhen Dist", "Longtan Dist", "Yangmei Dist", "Xinwu Dist",
					"Guanyin Dist", "Taoyuan Dist", "Guishan Dist", "Bade Dist", "Daxi Dist", "Fuxing Dist",
					"Dayuan Dist" ,"Luzhu Dist");
// for "苗栗縣"
Zone[8] = new Array("Please Select", "Zhunan Township", "Toufen City", "Sanwan Township", "Nanzhuang Township", "Shitan Township",
					"Houlong Township", "Tongxiao Township", "Yuanli Township", "Miaoli City", "Zaoqiao Township", "Touwu Township",
					"Gongguan Township", "Dahu Township", "Tai’an Township", "Tongluo Township", "Sanyi Township", "Xihu Township",
					"Zhuolan Township");
// for "臺中市"
Zone[9] = new Array("Please Select", "Central Dist", "East Dist", "South Dist", "West Dist", "North Dist", "Beitun Dist",
					"Xitun Dist", "Nantun Dist", "Taiping Dist", "Dali Dist", "Wufeng Dist", "Wuri Dist", "Fengyuan Dist",
					"Houli Dist", "Shigang Dist", "Dongshi Dist", "Heping Dist", "Xinshe Dist", "Tanzi Dist", "Daya Dist",
					"Shengang Dist", "Dadu Dist", "Shalu Dist", "Longjing Dist", "Wuqi Dist", "Qingshui Dist", "Dajia Dist",
					"Waipu Dist", "Da’an Dist");
// for "彰化縣"
Zone[10] = new Array("Please Select", "Changhua City", "Fenyuan Township", "Huatan Township", "Xiushui Township", "Lukang Township",
					"Fuxing Township", "Xianxi Township", "Hemei Township", "Shengang Township", "Yuanlin City", "Shetou Township",
					"Yongjing Township", "Puxin Township", "Xihu Township", "Dacun Township", "Puyan Township", "Tianzhong Township",
					"Beidou Township", "Tianwei Township", "Pitou Township", "Xizhou Township", "Zhutang Township", "Erlin Township",
					"Dacheng Township", "Fangyuan Township", "Ershui Township");
// for "南投縣"
Zone[11] = new Array("Please Select", "Nantou City", "Zhongliao Township", "Caotun Township", "Guoxing Township", "Puli Township",
					"Ren’ai Township", "Mingjian Township", "Jiji Township", "Shuili Township", "Yuchi Township", "Xinyi Township",
					"Zhushan Township", "Lugu Township");
// for "嘉義市"
Zone[12] = new Array("Please Select","East Dist", "West Dist");
// for "嘉義縣"
Zone[13] = new Array("Please Select", "Fanlu Township", "Meishan Township", "Zhuqi Township", "Alishan Township", "Zhongpu Township",
					"Dapu Township", "Shuishang Township", "Lucao Township", "Taibao City", "Puzi City", "Dongshi Township",
					"Liujiao Township", "Xingang Township", "Minxiong Township", "Dalin Township", "Xikou Township", "Yizhu Township",
					"Budai Township");
// for "雲林縣"
Zone[14] = new Array("Please Select", "Dounan Township", "Dapi Township", "Huwei Township", "Tuku Township", "Baozhong Township",
					"Dongshi Township", "Taixi Township", "Lunbei Township", "Mailiao Township", "Douliu City", "Linnei Township",
					"Gukeng Township", "Citong Township", "Xiluo Township", "Erlun Township", "Beigang Township", "Shuilin Township",
					"Kouhu Township", "Sihu Township", "Yuanzhang Township");
// for "臺南市"
Zone[15] = new Array("Please Select", "West Central Dist", "East Dist", "South Dist", "North Dist", "Anping Dist", "Annan Dist",
					"Yongkang Dist", "Guiren Dist", "Xinhua Dist", "Zuozhen Dist", "Yujing Dist", "Nanxi Dist", "Nanhua Dist",
					"Rende Dist", "Guanmiao Dist", "Longqi Dist", "Guantian Dist", "Madou Dist", "Jiali Dist", "Xigang Dist",
					"Qigu Dist", "Jiangjun Dist", "Xuejia Dist", "Beimen Dist", "Xinying Dist", "Houbi Dist", "Baihe Dist",
					"Dongshan Dist", "Liujia Dist", "Xiaying Dist", "Liuying Dist", "Yanshui Dist", "Shanhua Dist",
					"Danei Dist", "Shanshang Dist", "Xinshi Dist", "Anding Dist");
// for "高雄市"
Zone[16] = new Array("Please Select", "Xinxing Dist", "Qianjin Dist", "Lingya Dist", "Yancheng Dist", "Gushan Dist", "Qijin Dist",
					"Qianzhen Dist", "Sanmin Dist", "Nanzi Dist", "Xiaogang Dist", "Zuoying Dist", "Renwu Dist", "Dashe Dist",
					"Gangshan Dist", "Luzhu Dist", "Alian Dist", "Tianliao Dist", "Yanchao Dist", "Qiaotou Dist", "Ziguan Dist",
					"Mituo Dist", "Yong’an Dist", "Hunei Dist", "Fengshan Dist", "Daliao Dist", "Linyuan Dist", "Niaosong Dist",
					"Dashu Dist", "Qishan Dist", "Meinong Dist", "Liugui Dist", "Neimen Dist", "Shanlin Dist", "Jiaxian Dist",
					"Taoyuan Dist", "Namaxia Dist", "Maolin Dist", "Qieding Dist");
// for "澎湖縣"
Zone[17] = new Array("Please Select", "Magong City", "Xiyu Township", "Wang’an Township", "Qimei Township", "Baisha Township",
					"Huxi Township");
// for "屏東縣"
Zone[18] = new Array("Please Select", "Pingtung City", "Sandimen Township", "Wutai Township", "Majia Township", "Jiuru Township",
					"Ligang Township", "Gaoshu Township", "Yanpu Township", "Changzhi Township", "Linluo Township", "Zhutian Township",
					"Neipu Township", "Wandan Township", "Chaozhou Township", "Taiwu Township", "Laiyi Township", "Wanluan Township",
					"Kanding Township", "Xinpi Township", "Nanzhou Township", "Linbian Township", "Donggang Township", "Liuqiu Township",
					"Jiadong Township", "Xinyuan Township", "Fangliao Township", "Fangshan Township", "Chunri Township", "Shizi Township",
					"Checheng Township", "Mudan Township", "Hengchun Township", "Manzhou Township");
// for "臺東縣"
Zone[19] = new Array("Please Select", "Taitung City", "Ludao Township", "Lanyu Township", "Yanping Township", "Beinan Township",
					"Luye Township", "Guanshan Township", "Haiduan Township", "Chishang Township", "Donghe Township", "Chenggong Township",
					"Changbin Township", "Taimali Township", "Jinfeng Township", "Dawu Township", "Daren Township");
// for "花蓮縣"
Zone[20] = new Array("Please Select", "Hualien City", "Xincheng Township", "Xiulin Township", "Ji’an Township", "Shoufeng Township",
					"Fenglin Township", "Guangfu Township", "Fengbin Township", "Ruisui Township", "Wanrong Township",
					"Yuli Township", "Zhuoxi Township", "Fuli Township");
// for "金門縣"
Zone[21] = new Array("Please Select", "Jinsha Township", "Jinhu Township", "Jinning Township", "Jincheng Township",
					"Lieyu Township", "Wuqiu Township");
// for "連江縣"
Zone[22] = new Array("Please Select", "Nangan Township", "Beigan Township", "Juguang Township", "Dongyin Township");
// for "南海諸島"
Zone[23] = new Array("Please Select", "Dongsha Islands", "Nansha Islands");

ZipCode = new Array(25);
ZipCode[0] = new Array("");
// for "臺北市"
ZipCode[1] = new Array("", "100", "103", "104", "105", "106", "108", "110",
		"111", "112", "114", "115", "116");
// for "基隆市"
ZipCode[2] = new Array("", "200", "201", "202", "203", "204", "205", "206");
// for "新北市"
ZipCode[3] = new Array("", "207", "208", "220", "221", "222", "223", "224",
		"226", "227", "228", "231", "232", "233", "234", "235", "236", "237",
		"238", "239", "241", "242", "243", "244", "247", "248", "249", "251",
		"252", "253");
// for "宜蘭縣"
ZipCode[4] = new Array("", "260", "261", "262", "263", "264", "265", "266",
		"267", "268", "269", "270", "272");
// for "新竹市"
ZipCode[5] = new Array("","300","300","300");
// for "新竹縣"
ZipCode[6] = new Array("", "302", "303", "304", "305", "306", "307", "308",
		"310", "311", "312", "313", "314", "315");
// for "桃園市"
ZipCode[7] = new Array("", "320", "324", "325", "326", "327", "328", "330",
		"333", "334", "335", "336", "337", "338");
// for "苗栗縣"
ZipCode[8] = new Array("", "350", "351", "352", "353", "354", "356", "357",
		"358", "360", "361", "362", "363", "364", "365", "366", "367", "368",
		"369");
// for "臺中市"
ZipCode[9] = new Array("", "400", "401", "402", "403", "404", "406", "407",
		"408", "411", "412", "413", "414", "420", "421", "422", "423", "424",
		"426", "427", "428", "429", "432", "433", "434", "435", "436", "437",
		"438", "439");
// for "彰化縣"
ZipCode[10] = new Array("", "500", "502", "503", "504", "505", "506", "507",
		"508", "509", "510", "511", "512", "513", "514", "515", "516", "520",
		"521", "522", "523", "524", "525", "526", "527", "528", "530");
// for "南投縣"
ZipCode[11] = new Array("", "540", "541", "542", "544", "545", "546", "551",
		"552", "553", "555", "556", "557", "558");
// for "嘉義市"
ZipCode[12] = new Array("","600","600");
// for "嘉義縣"
ZipCode[13] = new Array("", "602", "603", "604", "605", "606", "607", "608",
		"611", "612", "613", "614", "615", "616", "621", "622", "623", "624",
		"625");
// for "雲林縣"
ZipCode[14] = new Array("", "630", "631", "632", "633", "634", "635", "636",
		"637", "638", "640", "643", "646", "647", "648", "649", "651", "652",
		"653", "654", "655");
// for "臺南市"
ZipCode[15] = new Array("", "700", "701", "702", "704", "708", "709", "710",
		"711", "712", "713", "714", "715", "716", "717", "718", "719","720",
		"721", "722", "723", "724", "725", "726", "727", "730", "731","732",
		"733", "734", "735", "736", "737", "741", "742", "743", "744","745");
// for "高雄市"
ZipCode[16] = new Array("", "800", "801", "802", "803", "804", "805", "806",
		"807", "811", "812", "813", "814", "815", "820", "821", "822", "823",
		"824", "825", "826", "827", "828", "829", "830", "831", "832", "833",
		"840", "842", "843", "844", "845", "846", "847", "848", "849", "851",
		"852");
// for "澎湖縣"
ZipCode[17] = new Array("", "880", "881", "882", "883", "884", "885");
// for "屏東縣"
ZipCode[18] = new Array("", "900", "901", "902", "903", "904", "905", "906",
		"907", "908", "909", "911", "912", "913", "920", "921", "922", "923",
		"924", "925", "926", "927", "928", "929", "931", "932", "940", "941",
		"942", "943", "944", "945", "946", "947");
// for "臺東縣"
ZipCode[19] = new Array("", "950", "951", "952", "953", "954", "955", "956",
		"957", "958", "959", "961", "962", "963", "964", "965", "966");
// for "花蓮縣"
ZipCode[20] = new Array("", "970", "971", "972", "973", "974", "975", "976",
		"977", "978", "979", "981", "982", "983");
// for "金門縣"
ZipCode[21] = new Array("", "890", "891", "892", "893", "894", "896");
// for "連江縣"
ZipCode[22] = new Array("", "209", "210", "211", "212");
// for "南海諸島"
ZipCode[23] = new Array("", "817", "819");

let currentCountyIndex = 0;
let currentZoneIndex = 0;

function initCounty(countyInput, defaultcity) {
	countyInput.length = County.length;
	for (i = 0; i < County.length; i++) {
		if (i == 0)
			countyInput.options[i].value = "";
		else
			countyInput.options[i].value = County[i];
		countyInput.options[i].text = County[i];
		if (defaultcity.value != "") {
			if (countyInput.options[i].value == defaultcity.value) {
				countyInput.options[i].selected = true;
			}
		}
	}
	// countyInput.selectedIndex = 0;
}

function initZone(countyInput, zoneInput, post, defaultcity, defaulttown) {
	changeZone(countyInput, zoneInput, post, defaultcity, defaulttown);
}

function changeZone(countyInput, zoneInput, post, defaultcity, defaulttown) {
	selectedCountyIndex = countyInput.selectedIndex;
	selectedZoneIndex = zoneInput.selectedIndex;			// 抓 index
	
	// 變更縣市 => 鄉鎮市區選項歸零
	if(currentCountyIndex != selectedCountyIndex && currentCountyIndex > 0) selectedZoneIndex = 0;
	currentCountyIndex = selectedCountyIndex;
	currentZoneIndex = selectedZoneIndex;
	
	zoneInput.length = Zone[selectedCountyIndex].length;
	for (i = 0; i < Zone[selectedCountyIndex].length; i++) {
		if (i == 0)
			zoneInput.options[i].value = "";
		else
			zoneInput.options[i].value = Zone[selectedCountyIndex][i];
		zoneInput.options[i].text = Zone[selectedCountyIndex][i];
		if (defaulttown.value != "") {
			if(selectedZoneIndex>-1) {
				zoneInput.options[selectedZoneIndex].selected = true;
			} else if (zoneInput.options[i].value == defaulttown.value) {
				zoneInput.options[i].selected = true;
			}
		}
	}
	showZipCode(countyInput, zoneInput, post, defaultcity, defaulttown);
}

function showZipCode(countyInput, zoneInput, post, defaultcity, defaulttown) {
	post.value = ZipCode[countyInput.selectedIndex][zoneInput.selectedIndex];
	// updateaddress(countyInput, zoneInput, address, countyindex);
}

function updateaddress(countyInput, zoneInput, defaultcity, defaulttown) {
	defaultcity.value = countyInput.options[countyInput.selectedIndex].text
			+ zoneInput.options[zoneInput.selectedIndex].text;
	defaulttown.value = countyInput.selectedIndex + 1;
}

function showLocation(countyInput, zoneInput, post, defaultcity, defaulttown){
	let zipCode = post.value;
	let countyIndex = findLocation(zipCode);			// 取得縣市
	
	if(countyIndex>-1) {
		let zoneIndex = ZipCode[countyIndex].indexOf(zipCode);		// 取得鄉鎮市區
		
		// 1. 設定地址預設值
		currentCountyIndex = countyIndex;
		currentZoneIndex = zoneIndex;
		defaultcity.value = County[countyIndex];
		defaulttown.value = Zone[countyIndex][zoneIndex];
		
		// 2. 設定地址
		ResetAll(countyInput, zoneInput, post, defaultcity, defaulttown);			// 設定地址
		zoneInput.options[zoneIndex].selected = true;								// 指定鄉鎮市區
		showZipCode(countyInput, zoneInput, post, defaultcity, defaulttown);		// 顯示郵遞區號
	}
}

function findLocation(zipCode) {
    return ZipCode.findIndex(zone => zone.includes(zipCode));
}

// ==================== for zip code end =========================

function ResetAll(county, city, zip, defcounty, defcity) {
	initCounty(county, defcounty);
	initZone(county, city, zip, defcounty, defcity);
}