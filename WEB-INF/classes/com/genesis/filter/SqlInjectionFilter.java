package com.genesis.filter;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
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

public class SqlInjectionFilter implements Filter {

    private Pattern sqlPattern;
    private Pattern xssPattern;
    private Pattern ognlPattern;
    private int maxLength;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

        String sqlRegex =
                "(?i).*(" +
                "\\bunion\\b\\s+\\bselect\\b" +
                "|\\bor\\b\\s+['\"0-9a-zA-Z_]+\\s*=\\s*['\"0-9a-zA-Z_]+" +
                "|\\band\\b\\s+['\"0-9a-zA-Z_]+\\s*=\\s*['\"0-9a-zA-Z_]+" +
                "|sleep\\s*\\(" +
                "|benchmark\\s*\\(" +
                "|waitfor\\s+delay" +
                "|;\\s*drop\\b" +
                "|;\\s*delete\\b" +
                "|;\\s*update\\b" +
                "|;\\s*insert\\b" +
                ").*";

        String xssRegex =
                "(?i).*(" +
                "<script" +
                "|</script" +
                "|javascript:" +
                "|vbscript:" +
                "|onerror\\s*=" +
                "|onload\\s*=" +
                "|onmouseover\\s*=" +
                "|onclick\\s*=" +
                "|<iframe" +
                "|<img" +
                "|<svg" +
                "|<object" +
                "|<embed" +
                ").*";

        String ognlRegex =
                "(?i).*(" +
                "\\$\\{" +
                "|%\\{" +
                "|#context" +
                "|#attr" +
                "|#application" +
                "|getWriter\\s*\\(" +
                "|getClass\\s*\\(" +
                "|classLoader" +
                "|newInstance\\s*\\(" +
                "|Runtime\\.getRuntime" +
                ").*";

        this.sqlPattern = Pattern.compile(sqlRegex);
        this.xssPattern = Pattern.compile(xssRegex);
        this.ognlPattern = Pattern.compile(ognlRegex);
        this.maxLength = 500;
    }

    private String decodeSafely(String input) {
        if (input == null) return null;

        try {
            return URLDecoder.decode(input, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            return input;
        } catch (IllegalArgumentException e) {
            return input;
        }
    }

    private boolean containsEncodedXSS(String input) {
        if (input == null) return false;

        String lower = input.toLowerCase();

        return lower.contains("&lt;script")
                || lower.contains("&gt;")
                || lower.contains("&lt;iframe")
                || lower.contains("&lt;img")
                || lower.contains("javascript:")
                || lower.contains("vbscript:")
                || lower.contains("onerror=")
                || lower.contains("onload=")
                || lower.contains("onmouseover=")
                || lower.contains("onclick=");
    }

    private boolean isIllegalLength(String input) {
        return input != null && input.length() > maxLength;
    }

    private boolean isMalicious(String input) {
        if (input == null || input.trim().isEmpty()) {
            return false;
        }

        return sqlPattern.matcher(input).matches()
                || xssPattern.matcher(input).matches()
                || ognlPattern.matcher(input).matches()
                || containsEncodedXSS(input);
    }

    private boolean shouldSkipParam(String paramName) {
        if (paramName == null) return false;

        return "lang".equalsIgnoreCase(paramName);
    }

    private boolean validateInput(String input, HttpServletResponse response, String label) throws IOException {
        if (input == null) {
            return false;
        }

        if (isIllegalLength(input)) {
            System.out.println("參數過長，被阻擋：" + label + " = " + input);
            response.sendError(400, "偵測到異常請求參數");
            return true;
        }

        String decoded = decodeSafely(input);

        if (isMalicious(input) || isMalicious(decoded)) {
            System.out.println("可疑請求，被阻擋：" + label + " = " + input);
            response.sendError(400, "偵測到異常請求參數");
            return true;
        }

        return false;
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        httpRequest.setCharacterEncoding("UTF-8");
        httpResponse.setCharacterEncoding("UTF-8");

        String queryString = httpRequest.getQueryString();
        if (queryString != null) {
            if (validateInput(queryString, httpResponse, "queryString")) {
                return;
            }
        }

        Map<String, String[]> paramMap = httpRequest.getParameterMap();
        for (Map.Entry<String, String[]> entry : paramMap.entrySet()) {
            String paramName = entry.getKey();

            if (shouldSkipParam(paramName)) {
                continue;
            }

            if (validateInput(paramName, httpResponse, "paramName")) {
                return;
            }

            String[] values = entry.getValue();
            if (values != null) {
                for (String value : values) {
                    if (validateInput(value, httpResponse, paramName)) {
                        return;
                    }
                }
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}