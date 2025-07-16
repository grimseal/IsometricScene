package core;

import core.type.*;
import kha.FastFloat;
import haxe.ds.IntMap;

typedef GridObject = IdObject & AABBObject;

class SpatialGrid<T:GridObject> {
	public var cellSize:Int;

	var grid:IntMap<Array<T>>;
	var objectCells:IntMap<Array<Int>>;

	var visitedBuffer:HashSet<Int> = new HashSet<Int>();

	public function new(cellSize:Int) {
		this.cellSize = cellSize;
		grid = new IntMap();
		objectCells = new IntMap();
	}

	inline function toCell(x:FastFloat, y:FastFloat):{cx:Int, cy:Int} {
		return {
			cx: Std.int(x / cellSize),
			cy: Std.int(y / cellSize)
		};
	}

	inline function cellKey(cx:Int, cy:Int):Int {
		return (cy << 16) | (cx & 0xFFFF);
	}

	public function insert(obj:T):Void {
		var aabb = obj.getAABB();
		var topLeft = toCell(aabb.minX, aabb.minY);
		var bottomRight = toCell(aabb.maxX, aabb.maxY);

		var keys = [];

		for (cy in topLeft.cy...bottomRight.cy + 1) {
			for (cx in topLeft.cx...bottomRight.cx + 1) {
				var key = cellKey(cx, cy);
				if (!grid.exists(key))
					grid.set(key, []);
				grid.get(key).push(obj);
				keys.push(key);
			}
		}

		objectCells.set(obj.id, keys);
	}

	public function remove(obj:T):Void {
		if (!objectCells.exists(obj.id))
			return;

		var keys = objectCells.get(obj.id);
		for (key in keys) {
			var list = grid.get(key);
			if (list != null) {
				list.remove(obj);
			}
		}
		objectCells.remove(obj.id);
	}

	public function update(obj:T):Void {
		remove(obj);
		insert(obj);
	}

	public function query(area:AABB, result:Array<T>):Array<T> {
		visitedBuffer.clear();

		var topLeft = toCell(area.minX, area.minY);
		var bottomRight = toCell(area.maxX, area.maxY);

		for (cy in topLeft.cy...bottomRight.cy + 1)
			for (cx in topLeft.cx...bottomRight.cx + 1) {
				var key = cellKey(cx, cy);
				if (!grid.exists(key))
					continue;
				for (obj in grid.get(key)) {
					if (visitedBuffer.contains(obj.id) || !obj.getAABB().intersects(area))
						continue;
					result.push(obj);
					visitedBuffer.add(obj.id);
				}
			}

		return result;
	}

	public function queryPoint(x:FastFloat, y:FastFloat, result:Array<T>):Array<T> {
		visitedBuffer.clear();

		var cell = toCell(x, y);
		var key = cellKey(cell.cx, cell.cy);

		if (!grid.exists(key))
			return result;

		for (obj in grid.get(key)) {
			if (visitedBuffer.contains(obj.id))
				continue;

			var aabb = obj.getAABB();
			if (x >= aabb.minX && x <= aabb.maxX && y >= aabb.minY && y <= aabb.maxY) {
				result.push(obj);
				visitedBuffer.add(obj.id);
			}
		}

		return result;
	}

	public function clear():Void {
		for (bucket in grid)
			bucket.resize(0);
		grid.clear();
		objectCells.clear();
	}
}
