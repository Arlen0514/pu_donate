package com.genesis.filter;

import java.io.IOException;
import java.util.Enumeration;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;

/**
 * Spring4Shell (CVE-2022-22965) 防護過濾器
 * 攔截所有含有 class. / classLoader / module.classLoader 的請求參數名稱
 * url-pattern: /* (全站)
 * @date 2026-03-17
 */
public class Spring4ShellFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletResponse httpResponse = (HttpServletResponse) response;

        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String name = paramNames.nextElement();
            if (name != null && isDangerous(name)) {
                httpResponse.sendError(400, "Bad Request");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    private boolean isDangerous(String name) {
        return name.startsWith("class.")
                || name.contains("classLoader");
    }

    @Override
    public void destroy() {
    }
}
