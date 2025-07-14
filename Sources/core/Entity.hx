package core;

import kha.math.FastVector2;

abstract class Entity {
	var _position:FastVector2 = new FastVector2();

	public var position(get, set):FastVector2;

	function get_position():FastVector2 {
		return _position;
	}

	function set_position(value:FastVector2):FastVector2 {
		return _position = value;
	}
}
