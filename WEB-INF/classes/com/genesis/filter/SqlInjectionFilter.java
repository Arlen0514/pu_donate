package com.genesis.filter;

import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.Enumeration;
import java.util.Map;
import java.util.regex.Pattern;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 整合版安全過濾器
 * 1. SQL Injection
 * 2. XSS
 * 3. Path Traversal
 * 4. Spring4Shell 參數名稱攻擊檢查
 */
public class SqlInjectionFilter implements Filter {

    private Pattern sqlPattern;
    private Pattern xssPattern;
    private int maxLength;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

        // 常見 SQL Injection 型態
        String sqlRegex =
                "(?i).*(" +
                    "\\bunion\\b\\s+\\bselect\\b" +
                    "|" +
                    "\\bselect\\b\\s+.*\\bfrom\\b" +
                    "|" +
                    "\\binsert\\b\\s+\\binto\\b" +
                    "|" +
                    "\\bupdate\\b\\s+.+\\bset\\b" +
                    "|" +
                    "\\bdelete\\b\\s+\\bfrom\\b" +
                    "|" +
                    "\\bdrop\\b\\s+\\btable\\b" +
                    "|" +
                    "\\btruncate\\b" +
                    "|" +
                    "\\bexec\\b" +
                    "|" +
                    "\\bexecute\\b" +
                    "|" +
                    "\\bor\\b\\s+['\"0-9a-zA-Z_]+\\s*=\\s*['\"0-9a-zA-Z_]+" +
                    "|" +
                    "\\band\\b\\s+['\"0-9a-zA-Z_]+\\s*=\\s*['\"0-9a-zA-Z_]+" +
                    "|" +
                    "'\\s*or\\s*'1'='1" +
                    "|" +
                    "\"\\s*or\\s*\"1\"=\"1" +
                ").*";

        // 常見 XSS 型態
        String xssRegex =
                "(?i).*(" +
                    "<\\s*script" +
                    "|" +
                    "javascript\\s*:" +
                    "|" +
                    "onerror\\s*=" +
                    "|" +
                    "onload\\s*=" +
                    "|" +
                    "onmouseover\\s*=" +
                    "|" +
                    "alert\\s*\\(" +
                    "|" +
                    "document\\.cookie" +
                    "|" +
                    "<\\s*iframe" +
                ").*";

        this.sqlPattern = Pattern.compile(sqlRegex);
        this.xssPattern = Pattern.compile(xssRegex);
        this.maxLength = 4096;
    }

    /**
     * Decode 最多 2 次，避免雙重編碼攻擊
     * %252e%252e%252f -> %2e%2e%2f -> ../
     */
    private static String multiDecode(String s) {
        if (s == null) return null;

        String v = s;
        for (int i = 0; i < 2; i++) {
            try {
                String dec = URLDecoder.decode(v, StandardCharsets.UTF_8.name());
                if (dec.equals(v)) break;
                v = dec;
            } catch (Exception e) {
                break;
            }
        }
        return v;
    }

    /**
     * 額外補強一些簡單 XSS 判斷
     */
    private boolean containsEncodedXSS(String input) {
        if (input == null) return false;

        String lower = input.toLowerCase();

        return lower.contains("&lt;script")
                || lower.contains("&gt;")
                || lower.contains("<script")
                || lower.contains("</script>")
                || lower.contains("javascript:")
                || lower.contains("onerror=")
                || lower.contains("onload=");
    }

    /**
     * Path Traversal / Unix File Parameter Manipulation
     */
    private static boolean isPathTraversalLike(String input) {
        if (input == null) return false;

        String v = multiDecode(input);
        if (v == null) return false;

        String lower = v.toLowerCase();

        if (lower.contains("../")
                || lower.contains("..\\")
                || lower.contains("/..")
                || lower.contains("\\..")) {
            return true;
        }

        if (lower.matches(".*[a-z]:\\\\.*")) {
            return true;
        }

        if (lower.startsWith("\\\\")) {
            return true;
        }

        if (lower.contains("/etc/passwd")
                || lower.contains("web-inf")
                || lower.contains("meta-inf")) {
            return true;
        }

        return false;
    }

    /**
     * Spring4Shell / 危險參數名稱
     */
    private boolean isDangerousParamName(String name) {
        if (name == null) return false;

        String lower = multiDecode(name);
        if (lower == null) return false;

        lower = lower.toLowerCase();

        return lower.startsWith("class.")
                || lower.contains("classloader")
                || lower.contains("module.classloader");
    }

    private boolean isSqlInjection(String input) {
        if (input == null) return false;

        String value = multiDecode(input);
        if (value == null) return false;

        value = value.trim();
        if ("".equals(value)) return false;

        return this.sqlPattern.matcher(value).matches();
    }

    private boolean isXss(String input) {
        if (input == null) return false;

        String value = multiDecode(input);
        if (value == null) return false;

        value = value.trim();
        if ("".equals(value)) return false;

        return this.xssPattern.matcher(value).matches() || containsEncodedXSS(value);
    }

    /**
     * 統一擋下時的 log
     */
    private void block(HttpServletRequest request,
                       HttpServletResponse response,
                       String reason,
                       String paramName,
                       String paramValue) throws IOException {

        String uri = request.getRequestURI();
        String method = request.getMethod();
        String queryString = request.getQueryString();
        String ip = request.getRemoteAddr();

        System.out.println("==================================================");
        System.out.println("[SqlInjectionFilter] 已攔截可疑請求");
        System.out.println("原因        : " + reason);
        System.out.println("Method      : " + method);
        System.out.println("URI         : " + uri);
        System.out.println("IP          : " + ip);
        System.out.println("QueryString : " + (queryString == null ? "" : multiDecode(queryString)));
        System.out.println("Param Name  : " + (paramName == null ? "" : paramName));
        System.out.println("Param Value : " + (paramValue == null ? "" : paramValue));
        System.out.println("==================================================");

        response.sendError(400, "Bad Request");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        httpRequest.setCharacterEncoding("UTF-8");
        httpResponse.setCharacterEncoding("UTF-8");

        // 0. 先檢查 queryString 長度
        String queryString = httpRequest.getQueryString();
        String decodedQuery = multiDecode(queryString);

        if (decodedQuery != null && decodedQuery.length() > this.maxLength) {
            block(httpRequest, httpResponse, "queryString 過長", "queryString", decodedQuery);
            return;
        }

        // 1. 先檢查 queryString 是否有 Path Traversal
        if (isPathTraversalLike(decodedQuery)) {
            block(httpRequest, httpResponse, "queryString 含路徑穿越字樣", "queryString", decodedQuery);
            return;
        }

        // 2. 檢查 queryString 是否有 SQLi / XSS
        if (decodedQuery != null) {
            if (isSqlInjection(decodedQuery)) {
                block(httpRequest, httpResponse, "queryString 疑似 SQL Injection", "queryString", decodedQuery);
                return;
            }

            if (isXss(decodedQuery)) {
                block(httpRequest, httpResponse, "queryString 疑似 XSS", "queryString", decodedQuery);
                return;
            }
        }

        // 3. 檢查 parameter name / value
        Map<String, String[]> params = httpRequest.getParameterMap();
        if (params != null) {
            for (Map.Entry<String, String[]> entry : params.entrySet()) {

                String paramKey = entry.getKey();
                String decodedKey = multiDecode(paramKey);

                // 3-1. 檢查參數名稱長度
                if (decodedKey != null && decodedKey.length() > this.maxLength) {
                    block(httpRequest, httpResponse, "參數名稱過長", decodedKey, null);
                    return;
                }

                // 3-2. Spring4Shell / classLoader 類型攻擊
                if (isDangerousParamName(decodedKey)) {
                    block(httpRequest, httpResponse, "危險參數名稱(Spring4Shell特徵)", decodedKey, null);
                    return;
                }

                // 3-3. 參數名稱本身有 Path Traversal
                if (isPathTraversalLike(decodedKey)) {
                    block(httpRequest, httpResponse, "參數名稱含路徑穿越字樣", decodedKey, null);
                    return;
                }

                // 3-4. 參數名稱本身有 SQLi / XSS
                if (isSqlInjection(decodedKey)) {
                    block(httpRequest, httpResponse, "參數名稱疑似 SQL Injection", decodedKey, null);
                    return;
                }

                if (isXss(decodedKey)) {
                    block(httpRequest, httpResponse, "參數名稱疑似 XSS", decodedKey, null);
                    return;
                }

                String[] values = entry.getValue();
                if (values == null) continue;

                for (String value : values) {
                    if (value == null) continue;

                    String decodedValue = multiDecode(value);

                    // debug 用，可視需求保留或拿掉
//                    System.out.println("[SqlInjectionFilter] param key = " + decodedKey + ", value = [" + decodedValue + "]");

                    // 3-5. 值長度過長
                    if (decodedValue != null && decodedValue.length() > this.maxLength) {
                        block(httpRequest, httpResponse, "參數值過長", decodedKey, decodedValue);
                        return;
                    }

                    // 3-6. 值有 Path Traversal
                    if (isPathTraversalLike(decodedValue)) {
                        block(httpRequest, httpResponse, "參數值含路徑穿越字樣", decodedKey, decodedValue);
                        return;
                    }

                    // 3-7. 值有 SQLi
                    if (isSqlInjection(decodedValue)) {
                        block(httpRequest, httpResponse, "參數值疑似 SQL Injection", decodedKey, decodedValue);
                        return;
                    }

                    // 3-8. 值有 XSS
                    if (isXss(decodedValue)) {
                        block(httpRequest, httpResponse, "參數值疑似 XSS", decodedKey, decodedValue);
                        return;
                    }
                }
            }
        }

        // 4. 額外檢查 request.getParameterNames()，補強 Spring4Shell
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String name = paramNames.nextElement();
            if (isDangerousParamName(name)) {
                block(httpRequest, httpResponse, "危險參數名稱(Spring4Shell特徵)", name, null);
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // no-op
    }
}