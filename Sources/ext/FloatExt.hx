package ext;

class FloatExt {
	public static inline function toFixed(f:Float, digits:Int):String {
		final pow = Math.pow(10, digits);
		return Std.string(Math.round(f * pow) / pow);
	}

	public static inline function round(f:Float):Float {
		return Math.round(f);
	}
}
