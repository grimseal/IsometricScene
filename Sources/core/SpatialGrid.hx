package core;

import core.type.*;
import kha.FastFloat;
import haxe.ds.IntMap;

typedef GridObject = IdObject & AABBObject;

class SpatialGrid {
	public var cellSize:Int;

	var grid:IntMap<Array<GridObject>>;
	var objectCells:IntMap<Array<Int>>;

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

	public function insert(obj:GridObject):Void {
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

	public function remove(obj:GridObject):Void {
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

	public function update(obj:GridObject):Void {
		remove(obj);
		insert(obj);
	}

	public function query(area:AABB):Array<GridObject> {
		var result:Array<GridObject> = [];
		var visited = new HashSet<Int>();

		var topLeft = toCell(area.minX, area.minY);
		var bottomRight = toCell(area.maxX, area.maxY);

		for (cy in topLeft.cy...bottomRight.cy + 1)
			for (cx in topLeft.cx...bottomRight.cx + 1) {
				var key = cellKey(cx, cy);
				if (grid.exists(key)) {
					for (obj in grid.get(key)) {
						if (!visited.contains(obj.id)) {
							if (obj.getAABB().intersects(area)) {
								result.push(obj);
								visited.add(obj.id);
							}
						}
					}
				}
			}

		return result;
	}

	public function clear():Void {
		for (bucket in grid) {
			bucket.resize(0);
		}
		grid.clear();
		objectCells.clear();
	}
}
