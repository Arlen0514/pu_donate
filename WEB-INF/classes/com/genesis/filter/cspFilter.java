/*
   @version 1.0
   @date 2022/11/10
   @author Miles Chang
*/
package com.genesis.filter;

import com.genesis.config.*;
import java.io.IOException;
import javax.servlet.*;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class cspFilter implements Filter {
	// FilterConfig�i�Ω�X��Filter���t�m��T
	private FilterConfig config;
	private String cspString;
	// �갵��l��
	public void init(FilterConfig config) {
		this.config = config;
		this.cspString = AppConfig.getProperty("csp.string.default") + AppConfig.getProperty("csp.string.script")
				+ AppConfig.getProperty("csp.string.style") +
				AppConfig.getProperty("csp.string.img") + AppConfig.getProperty("csp.string.frame")  + AppConfig.getProperty("csp.string.frameSrc") + AppConfig.getProperty("require.trusted.types.for");
		System.out.println("cspString: " + cspString);
		if (this.cspString == null) {
			this.cspString = "default-src 'self' https://cdn.jsdelivr.net https://fonts.googleapis.com https://fonts.gstatic.com https://www.youtube.com https://googleads.g.doubleclick.net https://www.google-analytics.com/ https://www.googletagmanager.com https://unpkg.com https://cdnjs.cloudflare.com https://maps.googleapis.com ; "
					+
					"script-src 'self' https://cdnjs.cloudflare.com https://code.jquery.com https://www.google-analytics.com/ https://www.googletagmanager.com https://unpkg.com https://maps.googleapis.com 'unsafe-inline' 'unsafe-eval' ; "
					+
					"style-src 'self' https://cdn.jsdelivr.net https://fonts.googleapis.com https://cdnjs.cloudflare.com https://unpkg.com 'unsafe-inline' ; "
					+
					"img-src * ;" +
					"frame-ancestors 'self';" +
					"frame-src 'self' ;";
		}
	}

	// �갵�P��
	public void destroy() {
		this.config = null;
	}

	// ����L�o���֤ߤ�k
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		HttpServletResponse httpResponse = (HttpServletResponse) response;
		httpResponse.setHeader("Content-Security-Policy", cspString);
		httpResponse.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
		httpResponse.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains; preload");
		httpResponse.setHeader("Permissions-Policy", "geolocation=(), microphone=()");
        httpResponse.setHeader("X-Content-Type-Options", "nosniff");
        httpResponse.setHeader("SET-COOKIE", "HttpOnly; Secure");
        httpResponse.setHeader("Frame-Options", "DENY");
        httpResponse.setHeader("X-Frame-Options", "DENY");
        httpResponse.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, private");
        httpResponse.setHeader("Pragma", "no-cache"); 
        httpResponse.setHeader("Expires", "0");  
		/*	
		// �Ҧ� cookie �]�w 20240125 May
		*/
		HttpServletRequest httpRequest = (HttpServletRequest) request;

		Cookie[] cookies = httpRequest.getCookies();
		if (cookies != null) {
			for (Cookie cookie : cookies) {
                String name = cookie.getName();
                String value = cookie.getValue();
                if("JSESSIONID".equals(name)) {
                	httpResponse.setHeader("Set-Cookie", name+"="+value + "; Path=/; SameSite=Lax; HttpOnly; Secure");
                }else {
                	httpResponse.setHeader("Set-Cookie", name+"="+value + "; Path=/; SameSite=Lax; HttpOnly; Secure");
                }
            }
		}else {
	        // �p�G�S������ Cookie�A�B�z���ε{�����ڥؿ��X��
	        String JSESSIONID =  httpRequest.getSession().getId();
	        httpResponse.setHeader("Set-Cookie", "JSESSIONID="+JSESSIONID+"; Path=/; SameSite=Lax; Secure; HttpOnly");
	    }
		
		
		chain.doFilter(request, response);
	}
}
