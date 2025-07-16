package ext;

import kha.FastFloat;
import kha.math.FastVector2;

class FastVector2Ext {
	public static inline function lerp(a:FastVector2, b:FastVector2, t:FastFloat):FastVector2 {
		return new FastVector2(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t);
	}

	public static inline function clampXY(v:FastVector2, xMin:FastFloat, xMax:FastFloat, yMin:FastFloat, yMax:FastFloat):FastVector2 {
		var result = new FastVector2();
		result.setFrom(v);
		result.x = utils.Math.clampFast(result.x, xMin, xMax);
		result.y = utils.Math.clampFast(result.y, yMin, yMax);
		return result;
	}

	public static inline function clamp(v:FastVector2, min:FastFloat, max:FastFloat):FastVector2 {
		var result = new FastVector2();
		result.setFrom(v);
		result.x = utils.Math.clampFast(result.x, min, max);
		result.y = utils.Math.clampFast(result.y, min, max);
		return result;
	}
}
