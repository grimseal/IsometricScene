package obj;

@:structInit
class IsoAABB {
	static inline final HEIGHT_CONST:Int = 1;

	public var id:Int;
	public var x:Int;
	public var y:Int;
	public var width:Int;
	public var height:Int;

	public var xMin(get, never):Int;
	public var xMax(get, never):Int;
	public var yMin(get, never):Int;
	public var yMax(get, never):Int;

	public inline function new(id:Int, x:Int = 0, y:Int = 0, width:Int = 0, height:Int = 0):Void {
		this.id = id;
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}

	inline function get_xMin():Int
		return x;

	inline function get_xMax():Int
		return x + width;

	inline function get_yMin():Int
		return y;

	inline function get_yMax():Int
		return y + height;

	public inline function setFrom(v:IsoAABB):Void {
		this.x = v.x;
		this.y = v.y;
		this.width = v.width;
		this.height = v.height;
	}
}
