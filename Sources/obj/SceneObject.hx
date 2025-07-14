package obj;

import kha.Color;
import kha.math.Vector2i;
import graphics.mesh.Mesh;
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

	public function new(size:Vector2i, position:GridPos, mesh:Mesh, color:Color) {
		this.type = size.x == 0 && size.y == 0 ? SceneObjectType.NONBLOCKING : SceneObjectType.BLOCKING;
		this.size = size;
		this.mesh = mesh;
		this.color = color;
		this.gridPosition = position;
	}

	public inline function update():Void {}

	public inline function get_worldPosition():WorldPos
		return position;

	public inline function set_worldPosition(value:WorldPos):WorldPos
		return position = value;

	public inline function get_gridPosition():GridPos
		return cast worldPosition;

	public inline function set_gridPosition(value:GridPos):GridPos {
		worldPosition = cast value;
		return value;
	}
}
