package com.genesis.filter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;


public class ParameterOverrideRequestWrapper extends HttpServletRequestWrapper {
    private final Map<String, String[]> additionalParams;

    public ParameterOverrideRequestWrapper(HttpServletRequest request, Map<String, String[]> additionalParams) {
        super(request);
        this.additionalParams = new HashMap<>();

        // 確保額外參數使用 UTF-8 進行解碼
        additionalParams.forEach((key, value) -> {
            String[] decodedValues = new String[value.length];
            for (int i = 0; i < value.length; i++) {
                decodedValues[i] = decode(value[i], StandardCharsets.UTF_8.name());
            }
            this.additionalParams.put(decode(key, StandardCharsets.UTF_8.name()), decodedValues);
        });
    }

    @Override
    public String getParameter(String name) {
        String decodedName = decode(name, StandardCharsets.UTF_8.name());
        if (additionalParams.containsKey(decodedName)) {
            return additionalParams.get(decodedName)[0];
        }
        return super.getParameter(decodedName);
    }

    @Override
    public Map<String, String[]> getParameterMap() {
        Map<String, String[]> combinedParams = new HashMap<>(super.getParameterMap());

        // 保證合併參數時也維持 UTF-8 解碼
        additionalParams.forEach((key, value) -> {
            if (!combinedParams.containsKey(key)) {
                combinedParams.put(key, value);
            }
        });

        return combinedParams;
    }

    @Override
    public String[] getParameterValues(String name) {
        String decodedName = decode(name, StandardCharsets.UTF_8.name());
        if (additionalParams.containsKey(decodedName)) {
            return additionalParams.get(decodedName);
        }
        return super.getParameterValues(decodedName);
    }

    // 工具方法，用於解碼參數
    private String decode(String value, String encoding) {
        try {
            return URLDecoder.decode(value, encoding);
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("UTF-8 解碼失敗", e);
        }
    }
}