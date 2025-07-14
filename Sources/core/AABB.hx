package core;

import kha.FastFloat;

@:structInit
class AABB {
	public var minX(default, null):FastFloat;
	public var minY(default, null):FastFloat;
	public var maxX(default, null):FastFloat;
	public var maxY(default, null):FastFloat;

	public function new(minX:FastFloat, minY:FastFloat, maxX:FastFloat, maxY:FastFloat) {
		this.minX = minX;
		this.minY = minY;
		this.maxX = maxX;
		this.maxY = maxY;
	}

	public inline function contains(x:FastFloat, y:FastFloat):Bool {
		return x >= minX && x <= maxX && y >= minY && y <= maxY;
	}

	public inline function intersects(other:AABB):Bool {
		return !(other.minX > maxX || other.maxX < minX || other.minY > maxY || other.maxY < minY);
	}

	public inline function translate(x:FastFloat, y:FastFloat) {
		minX += x;
		maxX += x;
		minY += y;
		maxY += y;
	}

	public inline function toString():String {
		return 'AABB($minX, $minY, $maxX, $maxY)';
	}
}
