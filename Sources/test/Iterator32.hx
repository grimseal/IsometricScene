package test;

abstract Iterator32(Int) {
	public inline function new(from:Int, to:Int) {
		this = (from << 16) | (to & 0xFFFF);
	}

	public var current(get, set):Int;

	public inline function get_current():Int {
		return this >> 16;
	}

	public inline function set_current(value:Int):Int {
		this = (value << 16) | (this & 0xFFFF);
		return value;
	}

	public var to(get, never):Int;

	public inline function get_to():Int {
		return this & 0xFFFF;
	}

	public inline function hasNext() {
		return current < to;
	}

	public inline function next() {
		return this += 4;
	}
}
