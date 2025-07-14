package obj;

import obj.Coords;

class Cell {
	public var id(default, null):Int;
	public var position(default, null):GridPos;
	public var visibility:CellVisibility;
	public var content:SceneObject;

	public var isOccupied(get, never):Bool;

	public inline function get_isOccupied():Bool
		return content != null;

	public function new(id:Int, position:GridPos) {
		this.id = id;
		this.position = position;
		this.visibility = CellVisibility.Visible;
	}
}

enum abstract CellVisibility(Int) from Int to Int {
	var None = 0;
	var Visible = 1;
	var SemiVisible = 2;
	var Invisible = 3;
}
