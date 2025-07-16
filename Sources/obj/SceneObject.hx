package obj;

import obj.Cell.CellState;
import kha.math.FastVector2;
import kha.Color;
import kha.math.Vector2i;
import graphics.mesh.Mesh;
import core.AABB;
import core.Entity;
import obj.Coords;

enum abstract SceneObjectType(Int) from Int to Int {
	var BLOCKING = 1;
	var NONBLOCKING = 2;
}

class SceneObject extends Entity {
	public var id(default, null):Int;

	public var type(default, null):SceneObjectType;
	public var size(default, null):Vector2i;
	public var gridPosition(get, set):GridPos;
	public var worldPosition(get, set):WorldPos;
	public var altitude(get, set):Int;

	public var mesh(default, null):Mesh;
	public var color(default, default):Color;

	public var depth:Int;

	public var isoAABB:IsoAABB;

	var _worldPosition:WorldPos = new WorldPos();
	var _altitude:Int;
	var aabb:AABB;
	var aabbHeightOffset:Float;

	function get_altitude():Int
		return _altitude;

	function set_altitude(val:Int):Int {
		if (_altitude == val)
			return _altitude;
		final newAabbHeightOffset = val * -Settings.CELL_ALTITUDE;
		final offsetDiff = newAabbHeightOffset - aabbHeightOffset;
		aabb.translate(0, offsetDiff);
		aabbHeightOffset = newAabbHeightOffset;
		_position.x = _worldPosition.x;
		_position.y = _worldPosition.y + aabbHeightOffset;
		return _altitude = val;
	}

	public function new(id:Int, size:Vector2i, position:GridPos, mesh:Mesh, color:Color) {
		this.id = id;
		this.type = size.x == 0 && size.y == 0 ? SceneObjectType.NONBLOCKING : SceneObjectType.BLOCKING;
		this.size = size;
		this.mesh = mesh;
		this.color = color;
		this.gridPosition = type == SceneObjectType.BLOCKING ? position : position.add(new FastVector2(.5, .5));
		this.depth = 0;
		this.aabb = mesh.getAABB();
		this.aabb.translate(worldPosition.x, worldPosition.y);
		_altitude = 0;
		aabbHeightOffset = 0;
	}

	inline function get_worldPosition():WorldPos
		return _worldPosition;

	inline function set_worldPosition(value:WorldPos):WorldPos {
		_position.x = value.x;
		_position.y = value.y + aabbHeightOffset;
		_worldPosition.setFrom(value);
		var meshAabb = mesh.getAABB();
		meshAabb.translate(_worldPosition.x, worldPosition.y + aabbHeightOffset);
		this.aabb = meshAabb;
		return _worldPosition;
	}

	inline function get_gridPosition():GridPos
		return worldPosition.toGridPos();

	inline function set_gridPosition(value:GridPos):GridPos {
		worldPosition = value.toWorldPos();
		return value;
	}

	public function getAABB():AABB
		return aabb;

	public function applyVisibilityState(state:CellState) {
		if (state.has(CellState.Locked))
			color = Settings.LOCKED_COLOR;
		else if (state.has(CellState.Visible))
			color = Settings.VISIBLE_COLOR;
		else if (state.has(CellState.Semivisible))
			color = Settings.SEMIVISIBLE_COLOR;
		else
			color = Settings.INVISIBLE_COLOR;
	}

	var prevCell:Cell;
	var prevState:CellState;

	public function test(cell:Cell) {
		if (prevState == cell.state)
			return;
		applyVisibilityState(cell.state);
		prevCell = cell;
		prevState = cell.state;
	}
}
