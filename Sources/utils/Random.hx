package utils;

import Math;
import kha.FastFloat;
import kha.math.FastVector2;

@:forward
abstract Random(kha.math.Random) to kha.math.Random from kha.math.Random {
	public function new(seed:Int)
		this = new kha.math.Random(seed);

	public function getUnitCircleVector():FastVector2
		return getCircleVectorIn(0.0, 1.0);

	public function getCircleVectorIn(min:FastFloat, max:FastFloat):FastVector2 {
		var angle = this.GetFloatIn(0.0, Math.PI * 2);
		var radius = this.GetFloatIn(min, max);
		var x = Math.cos(angle) * radius;
		var y = Math.sin(angle) * radius;
		return new FastVector2(x, y);
	}

	public function getFastVector2In(xMin:FastFloat, xMax:FastFloat, yMin:FastFloat, yMax:FastFloat):FastVector2 {
		return new FastVector2(this.GetFloatIn(xMin, xMax), this.GetFloatIn(yMin, yMax));
	}

	public static function create():Random {
		return new Random(Std.int(Date.now().getTime() / 1000));
	}
}
