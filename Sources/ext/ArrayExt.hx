package ext;

class ArrayExt {
	public static inline function first<T>(a:Array<T>):T {
		return a[0];
	}

	public static inline function last<T>(a:Array<T>):T {
		return a[a.length - 1];
	}
}
