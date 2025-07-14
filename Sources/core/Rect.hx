package core;

class Rect {
	public var x:Float;
	public var y:Float;
	public var w:Float;
	public var h:Float;
	public var flipped:RectOrientation;

	public function new(x:Float, y:Float, w:Float, h:Float, ?o:RectOrientation) {
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		this.flipped = o;
	}
}

enum abstract RectOrientation(Int) {
	var Default = 0;
	var Flipped = 1;

	@:from
	public static inline function fromBool(b:Bool):RectOrientation {
		return b ? Flipped : Default;
	}

	@:to
	public inline function toBool():Bool {
		return this == 1 ? true : false;
	}
}
