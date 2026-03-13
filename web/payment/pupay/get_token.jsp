<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.net.ssl.*,java.security.cert.X509Certificate,java.io.*,java.net.*,org.json.*" %>
<%! 
    // 共用方法：取 token
    public String getToken(String secret, boolean isTest, boolean printLog) throws Exception {
        URL url = new URL("https://ezpy.pu.edu.tw/dataTrans/index.php/auth/token");
        if(isTest) url = new URL("https://ezpy-ts1.pu.edu.tw/dataTrans/index.php/auth/token");
        
        HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();

        if (isTest) {
            TrustManager[] trustAllCerts = new TrustManager[]{
                new X509TrustManager() {
                    public X509Certificate[] getAcceptedIssuers() { return new X509Certificate[0]; }
                    public void checkClientTrusted(X509Certificate[] certs, String authType) {}
                    public void checkServerTrusted(X509Certificate[] certs, String authType) {}
                }
            };
            SSLContext sc = SSLContext.getInstance("TLSv1.2");
            sc.init(null, trustAllCerts, new java.security.SecureRandom());
            conn.setSSLSocketFactory(sc.getSocketFactory());
            conn.setHostnameVerifier((hostname, session) -> true);
        }

        conn.setRequestMethod("GET");
        conn.setConnectTimeout(15000);
        conn.setReadTimeout(15000);
        conn.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
        conn.setRequestProperty("Accept", "application/json;charset=UTF-8");
        conn.setRequestProperty("secret", secret);

        int responseCode = conn.getResponseCode();
        BufferedReader br = (responseCode == 200)
            ? new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"))
            : new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));

        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            sb.append(line);
        }
        br.close();

        String responseStr = sb.toString();
        if (printLog) System.out.println("API response：" + responseStr);

        JSONObject json = new JSONObject(responseStr);
//         if (json.getInt("success") == 1) {
            String token = json.getString("token");
            if (printLog) System.out.println("TOKEN：" + token);
            return token;
//         } else {
//             throw new RuntimeException("取 token 失敗: " + responseStr);
//         }
    }
%>

