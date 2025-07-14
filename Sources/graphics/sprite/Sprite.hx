package graphics.sprite;

// TODO remove
abstract Sprite(Int) {
	public var id(get, never):Int;
	public var x(get, set):Float;
	public var y(get, set):Float;

	public inline function new(v:Int)
		this = v;

	@:from
	public static inline function fromInt(i:Int):Sprite
		return new Sprite(i);

	@:to
	public inline function toInt():Int
		return this;

	inline function get_id():Int
		return this;

	inline function get_x():Float
		return SpriteStorage.data[this * SpriteStorage.STRIDE + 0];

	inline function set_x(v:Float):Float {
		SpriteStorage.data[this * SpriteStorage.STRIDE + 0] = v;
		return v;
	}

	inline function get_y():Float
		return SpriteStorage.data[this * SpriteStorage.STRIDE + 1];

	inline function set_y(v:Float):Float {
		SpriteStorage.data[this * SpriteStorage.STRIDE + 1] = v;
		return v;
	}
}
