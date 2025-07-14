package obj;

import core.Rect;
import core.Sprite;
import kha.Image;
import haxe.io.Int32Array;

// TODO remove
// import kha.arrays.Int32Array;
class SpriteAtlas {
	public var image:Image;
	public var rects:Array<Rect>;
	public var sprites:Array<Sprite>;

	public function new(image:Image, rects:Array<Rect>) {
		this.image = image;
		this.rects = rects;
	}

	public static function createFromSprites(sprites:Array<Sprite>):SpriteAtlas {
		var atlas = new SpriteAtlas(null, null);
		atlas.sprites = sprites;
		return atlas;
	}

	// public var x(get, set):Int;
	// inline function get_x() return this.get(0);
	// inline function set_x(v:Int):Int return this.set(0, v);
	// public var y(get, set):Int;
	// inline function get_y() return this.get(1);
	// inline function set_y(v:Int):Int return this.set(1, v);
	// public var z(get, set):Int;
	// inline function get_z() return this.get(2);
	// inline function set_z(v:Int):Int return this.set(2, v);
	// public var w(get, set):Int;
	// inline function get_w() return this.get(3);
	// inline function set_w(v:Int):Int return this.set(3, v);
}
