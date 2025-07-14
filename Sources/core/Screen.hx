package core;

import kha.System;
import kha.math.Vector2i;

@:allow(Simulation)
class Screen {
	public static var size(default, null):Vector2i = new Vector2i();

	static function update() {
		size.x = System.windowWidth();
		size.y = System.windowHeight();
	}
}
