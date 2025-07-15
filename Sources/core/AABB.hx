package core;

import kha.FastFloat;

@:structInit
class AABB {
	public var minX:FastFloat;
	public var minY:FastFloat;
	public var maxX:FastFloat;
	public var maxY:FastFloat;

	public var centerX(get, never):FastFloat;
	public var centerY(get, never):FastFloat;
	public var width(get, never):FastFloat;
	public var height(get, never):FastFloat;

	inline function get_centerX():FastFloat
		return (minX + maxX) * .5;

	inline function get_centerY():FastFloat
		return (minY + maxY) * .5;

	inline function get_width():FastFloat
		return maxX - minX;

	inline function get_height():FastFloat
		return maxY - minY;

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

	public static inline function empty():AABB {
		return new AABB(0, 0, 0, 0);
	}

	public inline function toString():String {
		return 'AABB($minX, $minY, $maxX, $maxY)';
	}
}
