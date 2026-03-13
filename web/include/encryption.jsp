<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Base64" %>
<%@ page import="java.security.*" %>
<%@ page import="javax.crypto.*" %>
<%@ page import="javax.crypto.Cipher"%>
<%@ page import="javax.crypto.spec.SecretKeySpec"%>
<%@ page import="javax.crypto.spec.IvParameterSpec" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%!
	// AES 資料加密
	class AESDataEncryption {
		private final String key = "c}+e+o'eB]d,YF96faj{O[N9MESb)8>Z";
		private final String iv = "$4)b~fk,=pL+I\\rf";
		
		// 加密
		public String AESEncrypt(String plainStr) {
	        try {
	            SecretKeySpec secretKeySpec = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "AES");
	            IvParameterSpec ivSpec = new IvParameterSpec(iv.getBytes(StandardCharsets.UTF_8));
	            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
	            cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivSpec);
	            byte[] encryptedBytes = cipher.doFinal(plainStr.getBytes(StandardCharsets.UTF_8));
	            return Base64.getEncoder().encodeToString(encryptedBytes);
	        } catch (Exception e) {
	            e.printStackTrace();
	            return null;
	        }
	    }
		
		// 解密
		public String AESDecrypt(String encryptStr) {
	        try {
	            SecretKeySpec secretKeySpec = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "AES");
	            IvParameterSpec ivSpec = new IvParameterSpec(iv.getBytes(StandardCharsets.UTF_8));
	            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
	            cipher.init(Cipher.DECRYPT_MODE, secretKeySpec, ivSpec);
	            byte[] encryptedBytes = Base64.getDecoder().decode(encryptStr);
	            byte[] decryptedBytes = cipher.doFinal(encryptedBytes);
	            return new String(decryptedBytes, StandardCharsets.UTF_8);
	        } catch (Exception e) {
	            e.printStackTrace();
	            return null;
	        }
	    }
	}
%>