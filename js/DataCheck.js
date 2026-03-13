//<!--
/**
 * DataCheck.js
 * Check the data format.
 * 檢核各式資料格式 :身分證字號,統一編號,Email,日期,純數字,英數&底線,字串實際長度,是否為ASCII,電話.
 * @author Arlen Hsu
 * @date 2025/08/26 AM 10:10
 */

/**
 * Check the personal identifiction number. 身分證
 * 檢核台灣身份證字號
 * @param PID An personal identification number string.
 * @return true if is valid, false if is invalid.
 */
function checkPID(pid) {
//    pid = pid.toUpperCase();
    if (!/^[A-Z][12]\d{8}$/.test(pid)) return false; // 格式檢查

    // 字母對應數字 (用 index +10 方式)
    var letters = "ABCDEFGHJKLMNPQRSTUVWXYZIO"; 
    var code = letters.indexOf(pid[0]) + 10; 
    var sum = Math.floor(code / 10) * 1 + (code % 10) * 9;

    // 第二碼 ~ 第九碼
    for (var i = 1; i < 9; i++) {
        sum += parseInt(pid[i]) * (9 - i);
    }

    // 最後一碼
    sum += parseInt(pid[9]);

    return sum % 10 === 0;
}


/**
 * Check the uniform identifiction number. 統編
 * 檢核統一編編號格式是否正確.
 * @param UID An uniform identification number string.
 * @return true if is validated, false if is not validated.
 */
function checkTaiwanVAT(vat) {
    if (!/^\d{8}$/.test(vat)) return false;

    const weights = [1, 2, 1, 2, 1, 2, 4, 1];
    let sum = 0;

    for (let i = 0; i < 8; i++) {
        let product = parseInt(vat[i], 10) * weights[i];
        sum += Math.floor(product / 10) + (product % 10);
    }

    // 最新規則：可被5整除
    if (sum % 5 === 0) return true;

    // 第7位為7的特殊例外
    if (vat[6] === '7') {
        // 重新計算 sum'：將第7位拆成另一種可能
        let product7 = 7 * 4;
        let sumAlt = sum - (Math.floor(product7 / 10) + (product7 % 10)) + Math.floor(product7 / 10);
        if (sumAlt % 5 === 0) return true;
    }

    return false;
}

/**
 * 檢查 Email 地址是否符合嚴格規範
 * 
 * 規則：
 * 1. 帳號部分只能包含字母、數字、._%+-，且不能以特殊符號開頭或結尾
 * 2. 帳號部分不能有連續兩個點 '..'
 * 3. 網域部分每段只能包含字母、數字、-，且不能以 '-' 開頭或結尾
 * 4. 網域可以有多層子網域
 * 5. 頂級域名 (TLD) 至少兩個字母
 * 
 * 注意：
 * 這個函數只檢查格式，不保證 Email 真實存在
 * 
 * @param {string} email 要檢查的 Email 字串
 * @return {boolean} 格式正確回傳 true，否則回傳 false
 */
function isEmailStrict(email) {
    // 嚴格正則檢查基本格式
    var regex = /^[a-zA-Z0-9](?:[a-zA-Z0-9._%+-]*[a-zA-Z0-9])?@([a-zA-Z0-9]+(-?[a-zA-Z0-9]+)*\.)+[a-zA-Z]{2,}$/;
    
    if (!regex.test(email)) return false;

    // 檢查帳號部分是否有連續兩個點
    var localPart = email.split("@")[0];
    if (localPart.includes("..")) return false;

    // 檢查網域部分每段是否以 '-' 開頭或結尾
    var domainParts = email.split("@")[1].split(".");
    for (var i = 0; i < domainParts.length; i++) {
        var part = domainParts[i];
        if (part.startsWith("-") || part.endsWith("-")) return false;
    }

    return true;
}



/**
 * Check if the date is valid.
 * 檢核日期格式是否為YYYY/MM/DD.
 * @param DATE A date string.
 * @return true if is valid, false if is invalid.
 */
function validDate(DATE) { 
    // 格式必須是 YYYY/MM/DD
    var regex = /^\d{4}\/\d{2}\/\d{2}$/;
    if (!regex.test(DATE)) {
        return false;
    }

    var ymd = DATE.split("/");
    var year = parseInt(ymd[0], 10);
    var month = parseInt(ymd[1], 10);
    var day = parseInt(ymd[2], 10);

    // 年份限制 (可依需求調整)
    if (year < 1900 || year > 2100) {
        return false;
    }

    // 月份檢查
    if (month < 1 || month > 12) {
        return false;
    }

    // 使用 Date 物件確認是否為合法日期
    var d = new Date(year, month - 1, day);
    if (d.getFullYear() !== year || d.getMonth() + 1 !== month || d.getDate() !== day) {
        return false;
    }

    return true;
}


/**
 * Check if the input is all number.
 * 檢核字串是否為純數字,空字串也不行.
 * @param INPUT A number string.
 * @return ture if are all numerics
 */
function validNum(INPUT) {
    return /^\d+$/.test(INPUT);
}


/**
 * Check if the input is all number or letter or underscore.
 * 檢核字串,只允許字母、數字、底線，且至少一個字元.
 * @param INPUT A string to be checked.
 * @return ture if are all literals.
 */
function validLiteral(INPUT) {
    return /^\w+$/.test(INPUT);
}


/**
 * 計算字串實際長度（支援中英文混合、全形字元、特殊符號、emoji）。
 * - ASCII 字元（A-Z, a-z, 0-9, 標點符號等）算 1。
 * - 非 ASCII 字元（中文字、全形字元、emoji 等）算 BYTES。
 *
 * @param {string} STR   要檢查的字串。
 * @param {number} BYTES 非 ASCII 字元的長度（預設為 2）。
 * @return {number} 字串的總長度。
 */
function realLength(STR, BYTES = 2) {
    let len = 0;
    for (let ch of STR) { // ES6 自動正確拆分 Unicode 字元
        if (ch.charCodeAt(0) > 255) {
            len += BYTES;
        } else {
            len += 1;
        }
    }
    return len;
}

/**
 * 判斷字元是否為 ASCII。
 * - ASCII 文字範圍：0 ~ 255
 *
 * @param {string} BYTE 單一字元。
 * @return {boolean} 若為 ASCII 則回傳 true，否則 false。
 */
function isASCII(str) {
    for (let i = 0; i < str.length; i++) {
        if (str.charCodeAt(i) > 127) return false;
    }
    return true;
}


/**
 * Check if the cellphone number is valid (Taiwan)
 * - Supports two formats:
 *   1. Without dash: 0910123456
 *   2. With dash: 0910-123-456 (dash 必須在正確位置)
 *
 * @param {string} PHONE - cellphone number
 * @return {boolean} true if valid, false otherwise
 */
function validCellphone(PHONE) {
    if (PHONE.includes('-')) {
        // 必須是正確的 dash 位置
        var regexpDash = /^09\d{2}-\d{3}-\d{3}$/;
        return regexpDash.test(PHONE);
    } else {
        // 沒有 dash，必須是 10 碼 09 開頭
        var regexpNoDash = /^09\d{8}$/;
        return regexpNoDash.test(PHONE);
    }
}


/**
 * Check if the telephone number is valid (Taiwan landline)
 * - Format: 0AA-BBBB-CCCC or 0AAA-BBB-CCCC
 * @param {string} PHONE - telephone number
 * @return {boolean} true if valid, false otherwise
 */
function validTelephone(PHONE) {
    var regexp = /^0\d{1,2}-\d{2,4}-\d{4}$/;
    return regexp.test(PHONE);
}


/**
 * Check if the international telephone number is valid (Taiwan / general)
 * Supports formats:
 * 1. Without dash: +886225953226
 * 2. With dash: +886-2-2595-3226
 *
 * Rules:
 * - 國碼前必須有 '+'
 * - 區碼 1~3 碼
 * - 中段 2~4 碼
 * - 末段 4 碼
 *
 * @param {string} PHONE - international phone number
 * @return {boolean} true if valid, false otherwise
 */
function validIntlphone(PHONE) {
    if (PHONE.includes('-')) {
        // 嚴格檢查 dash 位置
        var regexpDash = /^\+\d{1,3}-\d{1,3}-\d{2,4}-\d{4}$/;
        return regexpDash.test(PHONE);
    } else {
        // 移除所有非數字（保留開頭的 +）
        var cleaned = PHONE.replace(/[^\d+]/g, '');
        // 必須 +開頭 + 國碼 1~3 碼 + 號碼 6~12 碼
        var regexpNoDash = /^\+\d{1,3}\d{6,12}$/;
        return regexpNoDash.test(cleaned);
    }
}


/**
 * Strictly check if a phone number is valid (Taiwan / international)
 * Supports:
 * 1. Taiwan cellphone: 0910123456 or 0910-123-456
 * 2. Taiwan landline: 02-2585-2998 or 037-123-4567
 * 3. International: +886-2-2595-3226 or +1-212-555-1234
 *
 * @param {string} PHONE - phone number
 * @return {boolean} true if valid, false otherwise
 */
function validTel(PHONE) {
    // 台灣手機
    if (/^09\d{8}$/.test(PHONE)) return true;               // 不帶 dash
    if (/^09\d{2}-\d{3}-\d{3}$/.test(PHONE)) return true;   // 帶 dash

    // 台灣市話
    if (/^0\d{1,2}-\d{2,4}-\d{4}$/.test(PHONE)) return true;

    // 國際電話
    if (/^\+\d{1,3}-\d{1,3}-\d{2,4}-\d{4}$/.test(PHONE)) return true;

    return false;
}
/**
 * Check if the phone number is valid (Taiwan mobile, landline, or international)
 *
 * @param {string} PHONE - phone number
 * @return {boolean} true if valid, false otherwise
 */
function validPhone(PHONE) {
    return validCellphone(PHONE) || validTelephone(PHONE) || validIntlphone(PHONE) || validTel(PHONE);
}

//-->