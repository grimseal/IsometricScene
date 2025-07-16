package utils;

import kha.FastFloat;
import kha.math.FastVector2;

class Math {
	public inline static function clampFast(v:FastFloat, min:FastFloat, max:FastFloat):FastFloat {
		if (v < min)
			v = min;
		if (v > max)
			v = max;
		return v;
	}
}
