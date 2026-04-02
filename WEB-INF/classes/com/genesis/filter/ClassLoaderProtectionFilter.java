/*
   ClassLoader Protection Filter
   Blocks Spring4Shell-style parameter injection (class.module.classLoader.*)
   @version 1.0
   @date 2026-03-13
*/
package com.genesis.filter;

import java.io.IOException;
import java.util.Enumeration;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ClassLoaderProtectionFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void destroy() {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        Enumeration<String> paramNames = httpRequest.getParameterNames();
        while (paramNames != null && paramNames.hasMoreElements()) {
            String name = paramNames.nextElement();
            if (isDangerousParamName(name)) {
                System.out.println("[Security] Blocked dangerous parameter from " + httpRequest.getRemoteAddr());
                httpResponse.sendError(400, "Illegal request parameter");
                return;
            }
        }

        // Also check the raw query string for encoded variants
        String queryString = httpRequest.getQueryString();
        if (queryString != null && isDangerousQueryString(queryString)) {
            System.out.println("[Security] Blocked dangerous query string from "
                    + httpRequest.getRemoteAddr());
            httpResponse.sendError(400, "Illegal request parameter");
            return;
        }

        chain.doFilter(request, response);
    }

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
}
