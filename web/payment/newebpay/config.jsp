<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jspf/config.jspf"%>
<%@ page import="java.security.*" %>
<%@ page import="javax.crypto.*" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="javax.crypto.spec.IvParameterSpec" %>
<%@page import="java.security.MessageDigest"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%!
// AES加密
public static String getAES(String hashKey, String hashIv, String text) {
    try {
		SecretKeySpec skeySpec = new SecretKeySpec(hashKey.getBytes("UTF-8"), "AES");
        IvParameterSpec ivParameterSpec = new IvParameterSpec(hashIv.getBytes("UTF-8"));
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, skeySpec, ivParameterSpec);
        byte[] original = cipher.doFinal(text.getBytes("UTF-8"));
        return encode(original).toLowerCase();
    } catch (Exception e) {
        System.out.println("AES:"+e.getMessage());
    }
    return null;	
}

// AES解密
public static String decryptAES(String hashKey, String hashIv, String text) {
 	try {
     	SecretKeySpec skeySpec = new SecretKeySpec(hashKey.getBytes("UTF-8"), "AES");
     	IvParameterSpec ivParameterSpec = new IvParameterSpec(hashIv.getBytes("UTF-8"));
     	Cipher cipher = Cipher.getInstance("AES/CBC/NoPadding");
     	cipher.init(Cipher.DECRYPT_MODE, skeySpec, ivParameterSpec);
     	byte[]original  = hexToBytes(text); 
     	original = cipher.doFinal(original);
     	original = RemovePKCS7Padding(original);
     	return new String(original);
 	} catch (Exception e) {
     	System.out.println("decryptAES:"+e.getMessage());
 	}
 	return null;	
}

// 藍新回傳AES padding is pkcs7padding 
private static byte[] RemovePKCS7Padding(byte[] data) {
	int iLength = data[data.length - 1];
	byte[] output = new byte[data.length - iLength];
	System.arraycopy(data, 0, output, 0, output.length);
	return output;
}

// SHA256加密
public static String getHashSha256(String hashKey, String hashIv, String text) {
	String hashstring = "HashKey=" + hashKey + "&" + text + "&HashIV=" + hashIv;
	try {
		MessageDigest md = null;
		md = MessageDigest.getInstance("SHA-256");
		md.reset();
		md.update(hashstring.getBytes("UTF-8"));
		byte[] original = md.digest();  			// 將 byte 陣列加密
		return encode(original).toUpperCase();
    } catch (Exception e) {
        System.out.println("HashSha256"+e.getMessage());
    }
    return null;
}

//SHA256加密
public static String createCheckValue(String text) {
	try {
		MessageDigest md = null;
		md = MessageDigest.getInstance("SHA-256");
		md.reset();
		md.update(text.getBytes("UTF-8"));
		byte[] original = md.digest();  					// 將 byte 陣列加密
		return encode(original).toUpperCase();
	} catch (Exception e) {
	    System.out.println("HashSha256"+e.getMessage());
	}
	return null;
}

// 將byte陣列轉成16 進制
public static String encode(byte[] str) {
	byte[] bytes = str;
	StringBuilder sb = new StringBuilder(bytes.length * 2);
	for (int i = 0; i < bytes.length; i++) {
		if(Integer.toHexString(0xFF & bytes[i]).length() == 1) {
			sb.append("0").append(Integer.toHexString(0xFF & bytes[i]));
		} else {
			sb.append(Integer.toHexString(0xFF & bytes[i]));
		}
	}	
	return sb.toString();
}

// 將16進制轉成byte陣列
public static byte[] hexToBytes(String hexString) {
	char[] hex = hexString.toCharArray();
    int length = hex.length / 2;
    byte[] rawData = new byte[length];
    for (int i = 0; i < length; i++) {
      	int high = Character.digit(hex[i * 2], 16);
      	int low = Character.digit(hex[i * 2 + 1], 16);
      	int value = (high << 4) | low;
      	if (value > 127)
        	value -= 256;
		rawData [i] = (byte) value;
    }
    return rawData;
}
%>
<%
	String api_status = "test";					// 金流環境設定(test:測試/online:正式)
	boolean is_local  = false;						// 是否為本機測試
%>