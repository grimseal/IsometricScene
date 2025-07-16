package system;

import kha.input.Keyboard;
import core.Time;
import core.System;

class PauseSystem implements ISystem {
	static inline final PAUSE_KEY_CODE:Int = kha.input.KeyCode.Space;

	var keyboard:Keyboard;
	var pause:Bool;

	public function new() {}

	public function load() {}

	public function init() {
		keyboard = Keyboard.get();
		keyboard.notify(down);
	}

	public function update() {
		Time.timeScale = pause ? 0 : 1;
	}

	inline function down(key:Int) {
		pause = !pause;
	}
}
