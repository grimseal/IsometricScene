package graphics.sprite;

import kha.arrays.Float32Array;
import graphics.sprite.Sprite;

// TODO remove
class SpriteStorage {
	public static inline var STRIDE = 8;
	public static var data:Float32Array;

	public static inline function getSprite(id:Int):Sprite
		return new Sprite(id);

	public function test() {
		var sprite:Sprite = getSprite(1);

		sprite.x = 12;
		sprite.y = 123;
		var id:Int = sprite.id;
	}
}
