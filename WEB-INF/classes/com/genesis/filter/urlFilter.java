/*
   @version 1.0
   @date 2020/07/01
   @author Miles Chang
*/
package com.genesis.filter;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.genesis.sql.*;

public class urlFilter implements Filter {
	// FilterConfig可用於訪問Filter的配置資訊
	private FilterConfig config;

	// 實做初始化
	public void init(FilterConfig config) {
		this.config = config;
	}

	// 實做銷毀
	public void destroy() {
		this.config = null;
	}

	// 執行過濾的核心方法
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		// ---------下面程式碼用於對使用者請求執行預處理---------
		// 獲取ServletContext物件，用於記錄日誌
		ServletContext context = this.config.getServletContext();
		long before = System.currentTimeMillis();
		// System.out.println("開始過濾...");
		// 將請求轉換成HttpServletRequest請求
		HttpServletRequest hrequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;
		String urlPath = hrequest.getServletPath().substring(1); // 第一個字原是 / 
		String redirectPath = "";
		// 記錄日誌
		SqlManager app_sm = new SqlManager();
		
		TableRecord rr = app_sm.select("redirect_record", "rr_code = ? and rr_title = ?",
				new Object[] {"redirect", urlPath});
		if(!"".equals(rr.getString("rr_id"))) {
			context.log("Filter已經截獲到使用者的請求地址： " + urlPath);
			redirectPath = rr.getString("rr_url");
			httpResponse.sendRedirect(redirectPath);
			context.log("Filter已經重新導向到使用者的請求地址： " + redirectPath);
		}else {
		// 	Filter只是鏈式處理，請求依然放行到目的地址
			chain.doFilter(request, response);
		}
		/*
			// ---------下面程式碼用於對伺服器響應執行後處理---------
			long after = System.currentTimeMillis();
			// 記錄日誌
			context.log("過濾結束");
			// 再次記錄日誌
			context.log("請求被定位到" + hrequest.getRequestURI() + "所花的時間為: " + (after - before));
		*/
	}
}