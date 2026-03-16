# 弱點掃描修補報告

**專案：** `Arlen0514/pu_donate`  
**修補分支：** `security/weakscan-fixes-20260313`  
**修補日期：** 2026-03-13  
**報告日期：** 2026-03-16  
**修補人員：** GitHub Copilot Coding Agent  

---

## 目錄

1. [修補摘要](#一修補摘要)
2. [弱點一：缺少 CSRF Token（Absence of Anti-CSRF Tokens）](#二弱點一缺少-csrf-tokenabsence-of-anti-csrf-tokens)
3. [弱點二：反射型 XSS（Reflected XSS）](#三弱點二反射型-xssreflected-xss)
4. [弱點三：Spring4Shell 參數注入](#四弱點三spring4shell-參數注入)
5. [弱點四：未設定 CSP Header](#五弱點四未設定-csp-header)
6. [改動檔案清單](#六改動檔案清單)
7. [驗證方式](#七驗證方式)
8. [後續建議](#八後續建議)

---

## 一、修補摘要

| 項次 | 弱點類型 | 風險等級 | 狀態 |
|------|----------|----------|------|
| 1 | 缺少 CSRF Token | 高 | ✅ 已修補 |
| 2 | 反射型 XSS（qa.jsp dm_id） | 高 | ✅ 已修補 |
| 3 | Spring4Shell 參數注入（class.module.classLoader） | 高 | ✅ 已修補 |
| 4 | 未設定 CSP Header（全站） | 中 | ✅ 已修補 |

---

## 二、弱點一：缺少 CSRF Token（Absence of Anti-CSRF Tokens）

### 問題描述

弱掃工具偵測到以下頁面的表單**未加入 CSRF Token**，攻擊者可誘使已登入使用者瀏覽惡意連結，藉此偽造捐款或其他敏感操作（CSRF 攻擊）。

**受影響頁面（weakscan 回報）：**

| 頁面路徑 | 說明 |
|----------|------|
| `/web/directory/directory.jsp` | 芳名錄查詢與分頁表單 |
| `/web/donate/donate.jsp` | 捐款主表單 |
| `/web/fundraiser/fundraiser.jsp` | 勸募活動捐款表單 |
| `/web/news/news.jsp` | 消息分頁表單 |
| `/web/photo/photo.jsp` | 相片分頁表單 |
| `/web/qa/qa.jsp` | 常見問題分頁表單（含 `?dm_id=...`） |

**受影響提交端（未做 CSRF 驗證）：**

| 提交端路徑 | 說明 |
|----------|------|
| `/web/donate/donate_update.jsp` | 實際寫入捐款紀錄 |
| `/web/fundraiser/donate_update.jsp` | 勸募活動捐款寫入 |

### 修補方式

**新增 CSRF Helper 檔案：** `WEB-INF/jspf/csrf_token.jspf`

- `generateCSRFToken(session, "normalform")`：以 UUID 產生 Token，存入 Session（key：`csrfToken_n`）；若 Session 已有有效 Token 則重複使用（支援多分頁/上一頁操作）。
- `validateCSRFToken(session, token, "normalform")`：以 `MessageDigest.isEqual()` 做**常數時間比較**，防止時序攻擊（Timing Attack）。

**表單頁（6 個）統一加入：**

```jsp
<%@ include file="/WEB-INF/jspf/csrf_token.jspf" %>
<%
    String csrfToken = generateCSRFToken(session, "normalform");
%>
...
<form method="post" action="...">
    <input type="hidden" name="csrfToken" value="<%=csrfToken %>" />
    ...
</form>
```

**提交端（2 個）統一加入：**

1. 限制只允許 POST 方法：

```jsp
<%@ include file="/WEB-INF/jspf/csrf_token.jspf" %>
<%
if (!"POST".equalsIgnoreCase(request.getMethod())) {
    response.sendError(405, "Method Not Allowed");
    return;
}
```

2. CSRF Token 驗證（驗證失敗回傳 HTTP 403）：

```jsp
if (!validateCSRFToken(session, request.getParameter("csrfToken"), "normalform")) {
    response.sendError(403, "CSRF token validation failed");
    return;
}
```

---

## 三、弱點二：反射型 XSS（Reflected XSS）

### 問題描述

弱掃工具以下列 Payload 測試，發現 `dm_id` 參數未經過濾直接輸出至 HTML，造成反射型 XSS 漏洞：

```
/web/qa/qa.jsp?dm_id="><script>alert(1)</script>
```

### 修補方式

**修改檔案：** `web/qa/qa.jsp`

對 `dm_id` 參數套用**白名單（Allowlist）驗證**，只允許英數字、連字號（`-`）、底線（`_`）：

```java
// 修補前
String dm_id = StringTool.validString(request.getParameter("dm_id"), "");

// 修補後
// XSS防護：dm_id 僅允許英數字與連字號，防止反射型 XSS
String dm_id_raw = StringTool.validString(request.getParameter("dm_id"), "");
String dm_id = dm_id_raw.matches("[A-Za-z0-9\\-_]*") ? dm_id_raw : "";
```

不符合格式的值一律重設為空字串，頁面自動回退至第一個分類，**不回顯任何危險字元**。

---

## 四、弱點三：Spring4Shell 參數注入

### 問題描述

弱掃工具以下列 URL 測試，試圖透過 Java class 物件的 classLoader 屬性進行參數注入（CVE-2022-22965 Spring4Shell）：

```
/web/directory/directory.jsp?class.module.classLoader.DefaultAssertionStatus=nonsense
/web/directory/directory_download.jsp?class.module.classLoader.DefaultAssertionStatus=nonsense
```

### 修補方式

**新增全站 Servlet Filter：** `WEB-INF/classes/com/genesis/filter/ClassLoaderProtectionFilter.java`

過濾邏輯：

- 檢查所有 Request Parameter 名稱，若名稱以 `class.` 開頭，或包含 `classloader`，直接回傳 **HTTP 400**。
- 另外對 Query String 原始字串做額外檢查，涵蓋 URL 編碼變體（如 `%63lass`、`%2e` 搭配 `classloader`）。

```java
private boolean isDangerousParamName(String name) {
    if (name == null) return false;
    String lower = name.toLowerCase();
    return lower.startsWith("class.")
            || lower.contains("classloader");
}

private boolean isDangerousQueryString(String queryString) {
    if (queryString == null) return false;
    String lower = queryString.toLowerCase();
    return lower.contains("class.")
            || lower.contains("classloader")
            || lower.contains("%63lass")
            || (lower.contains("%2e") && lower.contains("classloader"));
}
```

**在 `WEB-INF/web.xml` 中全站套用：**

```xml
<filter>
    <filter-name>ClassLoaderProtectionFilter</filter-name>
    <filter-class>com.genesis.filter.ClassLoaderProtectionFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>ClassLoaderProtectionFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

---

## 五、弱點四：未設定 CSP Header

### 問題描述

弱掃工具偵測到全站 Response 均未包含 `Content-Security-Policy` HTTP Header，使得瀏覽器無法限制資源載入來源，提升 XSS 被利用的風險。

### 修補方式

**啟用既有但被註解掉的 CSP Filter：** `com.genesis.filter.cspFilter`（已存在於 `WEB-INF/classes/`）

在 `WEB-INF/web.xml` 中取消註解並改為全站套用（`/*`）：

```xml
<!-- 設定 CSP 20230530 Miles / 20260313 enabled -->
<filter>
    <filter-name>ContentSecurityPolicyFilter</filter-name>
    <filter-class>com.genesis.filter.cspFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>ContentSecurityPolicyFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

Filter 設定的 CSP Header 範例（fallback 預設值）：

```
default-src 'self' https://cdn.jsdelivr.net https://fonts.googleapis.com ...;
script-src 'self' ... 'unsafe-inline' 'unsafe-eval';
style-src 'self' ... 'unsafe-inline';
img-src *;
frame-ancestors 'self';
frame-src 'self';
```

> ⚠️ **注意：** 目前 `script-src` 和 `style-src` 包含 `'unsafe-inline'`，係因專案尚有 inline script/style 無法立即移除。建議後續分批將 inline 程式碼遷移為外部檔案或改用 CSP nonce，以進一步強化 CSP 效果。

---

## 六、改動檔案清單

| 檔案路徑 | 類型 | 說明 |
|----------|------|------|
| `WEB-INF/jspf/csrf_token.jspf` | 新增 | CSRF Token 產生/驗證 Helper |
| `WEB-INF/classes/com/genesis/filter/ClassLoaderProtectionFilter.java` | 新增 | Spring4Shell 防護 Filter（原始碼） |
| `WEB-INF/classes/com/genesis/filter/ClassLoaderProtectionFilter.class` | 新增 | Spring4Shell 防護 Filter（編譯後） |
| `WEB-INF/web.xml` | 修改 | 啟用 CSP Filter 與 ClassLoaderProtection Filter |
| `web/qa/qa.jsp` | 修改 | XSS 修補（dm_id 白名單驗證）、加入 CSRF Token |
| `web/donate/donate.jsp` | 修改 | 加入 CSRF Token 至捐款主表單 |
| `web/fundraiser/fundraiser.jsp` | 修改 | 加入 CSRF Token 至勸募表單 |
| `web/directory/directory.jsp` | 修改 | 加入 CSRF Token 至查詢與分頁表單 |
| `web/news/news.jsp` | 修改 | 加入 CSRF Token 至分頁表單 |
| `web/photo/photo.jsp` | 修改 | 加入 CSRF Token 至分頁表單 |
| `web/donate/donate_update.jsp` | 修改 | 加入 CSRF 驗證 + POST 限制 |
| `web/fundraiser/donate_update.jsp` | 修改 | 加入 CSRF 驗證 + POST 限制 |

---

## 七、驗證方式

### 弱點一 CSRF — 驗證步驟

1. 開啟捐款頁面 `web/donate/donate.jsp`，以開發者工具確認 `<form>` 內存在：
   ```html
   <input type="hidden" name="csrfToken" value="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" />
   ```
2. 直接用 GET 存取 `web/donate/donate_update.jsp?action=add` → 預期回傳 **HTTP 405**。
3. 以 POST 不帶 `csrfToken` 送出 → 預期回傳 **HTTP 403**。
4. 以 POST 帶正確 token 送出 → 預期正常處理。

### 弱點二 XSS — 驗證步驟

存取以下 URL，確認頁面**不回顯**任何 script 標籤，且正常顯示第一個分類內容：

```
/web/qa/qa.jsp?dm_id=%22%3E%3Cscript%3Ealert(1)%3C/script%3E
```

### 弱點三 Spring4Shell — 驗證步驟

存取以下 URL，預期回傳 **HTTP 400**，不得有任何參數被回顯：

```
/web/directory/directory.jsp?class.module.classLoader.DefaultAssertionStatus=nonsense
/web/directory/directory_download.jsp?class.module.classLoader.DefaultAssertionStatus=nonsense
```

### 弱點四 CSP — 驗證步驟

存取任意頁面，以瀏覽器開發者工具或 curl 確認 Response Header 包含：

```
Content-Security-Policy: default-src 'self' ...
```

---

## 八、後續建議

| 項目 | 說明 | 優先度 |
|------|------|--------|
| 移除 CSP `'unsafe-inline'` | 逐步將 inline script/style 遷移至外部檔案或改用 CSP nonce，收緊 CSP 策略 | 中 |
| 啟用 SQL Injection Filter | `WEB-INF/web.xml` 中已有 `SqlInjectionFilter` 程式碼但被註解，建議評估後啟用 | 中 |
| 啟用錯誤頁面對應 | `WEB-INF/web.xml` 中 `<error-page>` 區塊被註解，建議啟用以避免伺服器錯誤訊息洩漏 | 低 |
| CSRF Token 一次性（One-time token）策略 | 目前 Token 為 Session 級別重複使用，可依需求改為每次提交後輪換（防重放） | 低 |
| 定期弱掃複驗 | 建議每次版本更新後重新執行 weakscan，確保新功能無新增漏洞 | 持續 |
