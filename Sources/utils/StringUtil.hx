package utils;

class StringUtil {
	public static inline function nullOrEmpty(str:String) {
		return str == null || str.length == 0;
	}
}
