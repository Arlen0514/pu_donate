package com.genesis.utils;
import com.genesis.chinese.Translator;
import java.security.MessageDigest;
import java.util.Arrays;
import java.util.Random;
import java.util.Vector;
import java.util.List;

/*Modify 20191107 Miles Chang for prevent XXS */

public final class StringTool {
	public static String validString(String originalString) {
		return validString(originalString, "");
	}

	public static String validString(String originalString, String defaultValue) {
		String[] invalid_string_arr = {"<",">","+","!","--","*","|",")",";","and","between",".","!s","!n","script","alert","AND","OR","\'","\"",".jsp","select","xsl"};
		List<String> invlaid_string_list = Arrays.asList(invalid_string_arr);
		
		String str = defaultValue;
		if (originalString != null) {
			str = originalString;
			// for XXS 
			String check_str = originalString.toLowerCase();
			
			for(String invalid_str:invalid_string_arr) {
				if(check_str.indexOf(invalid_str) > -1) {
					System.out.println("invalid string");
					int i = Integer.parseInt("");
				}
			}
		
			if(check_str.length() > 100) {
				System.out.println("too long");
				int i = Integer.parseInt("");
			}
			/*
			if ( (check_str.indexOf(")") > -1) || (check_str.indexOf("(") > -1) || (check_str.indexOf("script") > -1) || (check_str.indexOf("alert")>-1)) {
				int i = Integer.parseInt("");
			}
			if ((check_str.indexOf("<") > -1) || (check_str.indexOf(">") > -1) || (check_str.indexOf("+") > -1) || (check_str.indexOf("!") > -1) || 
		      (check_str.indexOf("--") > -1) || (check_str.indexOf("*") > -1) || (check_str.indexOf("|") > -1) || 
		      (check_str.indexOf(")") > -1) || (check_str.indexOf(";") > -1) || (check_str.indexOf("and") > -1) || 
		      (check_str.indexOf("between") > -1) || (check_str.indexOf(".") > -1)){
		      int i = Integer.parseInt("");
			 }
			 */
		}
		return str;
	}

	public static int validInt(String originalString) {
		return validInt(originalString, 0);
	}

	public static int validInt(String originalString, int defaultValue) {
		int rtn = defaultValue;
		if (originalString != null) {
			rtn = Integer.parseInt(originalString);
		}
		return rtn;
	}

	public static String[] toStrings(Vector vc) {
		String[] strs = new String[vc.size()];
		vc.copyInto(strs);
		return strs;
	}

	public static String toUpperCase(String str, int from, int to) {
		String head = str.substring(0, from);
		String mid = str.substring(from, to).toUpperCase();
		String tail = str.substring(to);
		return head + mid + tail;
	}

	public static int maxLength(String[] strs) {
		int maxlength = 0;
		for (int i = 0; i < strs.length; i++) {
			if (strs[i].length() > maxlength) {
				maxlength = strs[i].length();
			}
		}
		return maxlength;
	}

	public static String spaces(int spclength) {
		return replicate("", " ", spclength);
	}

	public static String replicate(String origin, String repeat, int times) {
		StringBuffer sb = new StringBuffer(origin);
		for (int i = 0; i < times; i++) {
			sb.append(repeat);
		}
		return sb.toString();
	}

	public static int indexOf(String keyName, String[] source) {
		int index = -1;
		for (int i = 0; i < source.length; i++) {
			if (keyName.equals(source[i])) {
				index = i;
				break;
			}
		}
		return index;
	}

	public static int indexOf(String keyName, Vector source) {
		String[] names = toStrings(source);
		return indexOf(keyName, names);
	}

	public static String h2t(String htmltext) {
		StringBuffer sb = new StringBuffer();
		String str = htmltext;
		while (!str.equals("")) {
			int idx = str.indexOf(">");
			str = str.substring(idx + 1);
			int last = str.indexOf("<");
			if (last == -1) {
				sb.append(str);
			} else {
				sb.append(str.substring(0, last));
			}
			if ((last == str.length()) || (last == -1)) {
				break;
			}
			str = str.substring(last);
		}
		return sb.toString().replaceAll("&lt;", "<").replaceAll("&gt;", ">");
	}

	public static String convert(String s) {
		return convert(s, "ISO8859-1", "MS950");
	}

	public static String convert(String s, String toLocale) {
		return convert(s, "ISO8859-1", toLocale);
	}

	public static String convert(String s, String fromLocale, String toLocale) {
		if ((s == null) || (s.length() == 0)) {
			return "";
		}
		try {
			return new String(s.getBytes(fromLocale), toLocale);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}

	public static String utf8String(String str) {
		return convert(str, "UTF-8");
	}

	public static String escapeQuotes(String str) {
		String[] reps = { "\"", "'" };
		String[] escs = { "&#34;", "&#39;" };
		String rtn = str;
		for (int i = 0; i < escs.length; i++) {
			rtn = rtn.replaceAll(reps[i], escs[i]);
		}
		return rtn;
	}

	public static String firstChar(String tableName) {
		String[] str = tableName.split("_");
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < str.length; i++) {
			sb.append(str[i].substring(0, 1));
		}
		return sb.toString();
	}

	public static String toLocaleString(String str, String locale) {
		return locale.equals("gb") ? Translator.toGB2312(str) : str;
	}

	public static String encrypt(String str) {
		String encrypt = "";
		try {
			encrypt = toHexString(digest(str));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return encrypt;
	}

	public static byte[] digest(String x) throws Exception {
		MessageDigest d = null;
		d = MessageDigest.getInstance("SHA-1");
		d.reset();
		d.update(x.getBytes());
		return d.digest();
	}

	public static String toHexString(String s) {
		byte[] b = s.getBytes();
		return toHexString(b);
	}

	public static String toHexString(byte[] b) {
		StringBuffer sb = new StringBuffer(b.length * 2);
		for (int i = 0; i < b.length; i++) {
			int v = b[i] & 0xFF;
			if (v < 16) {
				sb.append('0');
			}
			sb.append(Integer.toHexString(v));
		}
		return sb.toString().toUpperCase();
	}

	public static byte[] toByteArray(String s) {
		byte[] b = new byte[s.length() / 2];
		for (int i = 0; i < b.length; i++) {
			int index = i * 2;
			int v = Integer.parseInt(s.substring(index, index + 2), 16);
			b[i] = ((byte) v);
		}
		return b;
	}

	public static String randmPassword(int len) {
		int letters = 26;
		String pswd = "";
		Random rand = new Random();
		for (int i = 0; i < len; i++) {
			int next = rand.nextInt(letters * 2);
			char base = next < letters ? 'a' : 'A';
			int offset = next < letters ? next : next - letters;
			char b = (char) (base + offset);
			pswd = pswd + new Character(b);
		}
		return pswd;
	}

	public static String beanName(String tableName) {
		StringBuffer sb = new StringBuffer();
		String[] strs = tableName.split("_");
		for (int i = 0; i < strs.length; i++) {
			sb.append(toUpperCase(strs[i], 0, 1));
		}
		return sb.toString();
	}
}
