package obj;

import kha.math.Vector2i;
import obj.Coords;

class Cell {
	public var state:CellState;

	var _content:SceneObject;

	public var id(default, null):Int;
	public var position(default, null):Vector2i;
	public var content(get, set):SceneObject;
	public var isOccupied(get, never):Bool;

	public function new(id:Int, position:Vector2i) {
		this.id = id;
		this.position = position;
	}

	inline function get_content():SceneObject
		return _content;

	inline function set_content(val:SceneObject):SceneObject {
		val == null ? state.remove(CellState.Occupied) : state.add(CellState.Occupied);
		return _content = val;
	}

	public inline function get_isOccupied():Bool
		return content != null;

	@:to public function toString():String {
		return 'Cell($id)';
	}
}

enum abstract CellState(Int) from Int to Int {
	var Empty = 0x00;
	var Occupied = 0x01;

	var Visible = 0x02;
	var Semivisible = 0x04;
	var Invisible = 0x08;
	var Blocked = 0x10;

	public inline function has(flag:CellState):Bool {
		return (this & cast flag) != 0;
	}

	public inline function add(flag:CellState):CellState {
		return cast(this | cast flag);
	}

	public inline function remove(flag:CellState):CellState {
		return cast(this & ~(cast flag));
	}

	@:op(A | B) public static inline function or(a:CellState, b:CellState):CellState
		return orInternal(cast a, cast b);

	static inline function orInternal(a:Int, b:Int):CellState
		return cast(a | b);

	@:op(A & B) public static inline function and(a:CellState, b:CellState):CellState
		return andInternal(cast a, cast b);

	static inline function andInternal(a:Int, b:Int):CellState
		return cast(a & b);

	@:op(~A) public static inline function not(a:CellState):CellState
		return cast(~cast a);

	@:from public static inline function fromInt(value:Int):CellState
		return cast value;

	@:to public inline function toInt():Int
		return cast this;

	@:to public function toString():String {
		var parts = [];
		if (has(Occupied))
			parts.push("Occupied");
		else
			parts.push('Empty');
		if (has(Visible))
			parts.push("Visible");
		if (has(Semivisible))
			parts.push("Semivisible");
		if (has(Invisible))
			parts.push("Invisible");
		if (has(Blocked))
			parts.push("Blocked");
		return parts.join(" | ");
	}
}

enum abstract CellOccupation(Int) from Int to Int {
	var Empty = 0;
	var Occupied = 1;
}

enum abstract CellVisibility(Int) from Int to Int {
	var None = 0;
	var Visible = 1;
	var SemiVisible = 2;
	var Invisible = 3;
}
