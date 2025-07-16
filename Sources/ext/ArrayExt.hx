package ext;

class ArrayExt {
	public static inline function first<T>(a:Array<T>):T {
		if (a.length == 0)
			throw 'Array is empty';
		return a[0];
	}

	public static inline function firstOrDefault<T>(a:Array<T>, d:T):T {
		return a.length != 0 ? a[0] : d;
	}

	public static inline function last<T>(a:Array<T>):T {
		if (a.length == 0)
			throw 'Array is empty';
		return a[a.length - 1];
	}

	public static inline function lastOrDefault<T>(a:Array<T>, d:T):T {
		return a.length != 0 ? a[a.length - 1] : d;
	}
}
