package core;

import kha.FastFloat;
import kha.math.FastMatrix4;
import kha.math.FastVector2;
import kha.math.FastVector4;

// TODO refactor matrix
class Camera extends Entity {
	static inline final minZoom:FastFloat = 0.5;
	static inline final maxZoom:FastFloat = 2.0;

	public var matrix:FastMatrix4;

	var _zoom:FastFloat = 1.0;

	public var zoom(get, set):FastFloat;

	inline function get_zoom():FastFloat
		return _zoom;

	inline function set_zoom(val:FastFloat):FastFloat {
		if (val < minZoom)
			val = minZoom;
		if (val > maxZoom)
			val = maxZoom;
		return _zoom = val;
	}

	public inline function new() {
		zoom = 1.0;
		position = new FastVector2(0, 0);
		matrix = FastMatrix4.identity();
	}

	public function screenToWorld(x:Int, y:Int):FastVector2 {
		var invMatrix = getInverseProjectionMatrix();
		var ndcX:FastFloat = (x / Screen.size.x) * 2.0 - 1.0;
		var ndcY:FastFloat = 1.0 - (y / Screen.size.y) * 2.0;
		var screenPos = new FastVector4(ndcX, ndcY, 0, 1);
		var worldPos = invMatrix.multvec(screenPos);
		return new FastVector2(worldPos.x, worldPos.y);
	}

	public function getInverseProjectionMatrix():FastMatrix4 {
		var origin = position;

		var halfWidth = Screen.size.x * 0.5 * zoom;
		var halfHeight = Screen.size.y * 0.5 * zoom;

		var left:FastFloat = origin.x - halfWidth,
			right:FastFloat = origin.x + halfWidth,
			bottom:FastFloat = origin.y + halfHeight,
			top:FastFloat = origin.y - halfHeight,
			zn:FastFloat = -1,
			zf:FastFloat = 1;

		var m = FastMatrix4.identity();

		m._00 = (right - left) / 2.0;
		m._11 = (top - bottom) / 2.0;
		m._22 = (zf - zn) / -2.0;

		m._30 = (right + left) / 2.0;
		m._31 = (top + bottom) / 2.0;
		m._32 = (zf + zn) / 2.0;

		return m;
	}

	public function updateProjectionMatrix(width:Int, height:Int):FastMatrix4 {
		var halfWidth = width * 0.5 * zoom;
		var halfHeight = height * 0.5 * zoom;

		var left:FastFloat = position.x - halfWidth,
			right:FastFloat = position.x + halfWidth,
			bottom:FastFloat = position.y + halfHeight,
			top:FastFloat = position.y - halfHeight,
			zn:FastFloat = -1,
			zf:FastFloat = 1;

		var tx:FastFloat = -(right + left) / (right - left);
		var ty:FastFloat = -(top + bottom) / (top - bottom);
		var tz:FastFloat = -(zf + zn) / (zf - zn);

		matrix._00 = 2.0 / (right - left);
		matrix._30 = tx;
		matrix._11 = 2.0 / (top - bottom);
		matrix._31 = ty;
		matrix._22 = -2.0 / (zf - zn);
		matrix._32 = tz;
		matrix._33 = 1;

		return matrix;
	}
}
