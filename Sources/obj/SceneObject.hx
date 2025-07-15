package obj;

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
	public var id(default, never):Int;

	public var type(default, null):SceneObjectType;
	public var size(default, null):Vector2i;
	public var gridPosition(get, set):GridPos;
	public var worldPosition(get, set):WorldPos;
	public var altitude(default, default):Int;

	public var mesh(default, null):Mesh;
	public var color(default, null):Color;

	var aabb:AABB;

	public function new(size:Vector2i, position:GridPos, mesh:Mesh, color:Color) {
		this.type = size.x == 0 && size.y == 0 ? SceneObjectType.NONBLOCKING : SceneObjectType.BLOCKING;
		this.size = size;
		this.mesh = mesh;
		this.color = color;
		this.gridPosition = position;

		this.aabb = mesh.getAABB();
		this.aabb.translate(worldPosition.x, worldPosition.y);
	}

	public inline function update():Void {}

	inline function get_worldPosition():WorldPos
		return position;

	inline function set_worldPosition(value:WorldPos):WorldPos
		return position = value;

	inline function get_gridPosition():GridPos
		return worldPosition.toGridPos();

	inline function set_gridPosition(value:GridPos):GridPos {
		worldPosition = value.toWorldPos();
		return value;
	}

	public function getAABB():AABB
		return aabb;
}
