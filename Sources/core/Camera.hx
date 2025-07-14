package core;

import kha.FastFloat;
import kha.math.FastMatrix4;
import kha.math.Matrix4;
import kha.math.FastVector2;

class Camera extends Entity {
	public var zoom(default, null):Float;

	public var matrix:FastMatrix4;

	final minZoom:Float = 0.25;
	final maxZoom:Float = 4.0;

	inline public function new() {
		zoom = 1.0;
		position = new FastVector2(0, 0);
		matrix = FastMatrix4.identity();
	}

	public function updateMatrix(width:Int, height:Int):FastMatrix4 {
		var origin = position;

		var halfWidth = width * 0.5 * zoom;
		var halfHeight = height * 0.5 * zoom;

		var left:FastFloat = origin.x - halfWidth,
			right:FastFloat = origin.x + halfWidth,
			bottom:FastFloat = origin.y + halfHeight,
			top:FastFloat = origin.y - halfHeight,
			zn:FastFloat = -1,
			zf:FastFloat = 1;

		var tx:FastFloat = -(right + left) / (right - left);
		var ty:FastFloat = -(top + bottom) / (top - bottom);
		var tz:FastFloat = -(zf + zn) / (zf - zn);

		matrix._00 = 2 / (right - left);
		matrix._30 = tx;
		matrix._11 = 2.0 / (top - bottom);
		matrix._31 = ty;
		matrix._22 = -2 / (zf - zn);
		matrix._32 = tz;
		matrix._33 = 1;

		return matrix;
	}
}
