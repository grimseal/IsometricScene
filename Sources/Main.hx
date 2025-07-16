package;

import kha.System;

class Main {
	public static function main() {
		System.start({
			title: Settings.APP_NAME,
			width: Settings.SCREEN_WIDTH,
			height: Settings.SCREEN_HEIGHT,
		}, _ -> new Simulation().start());
	}
}
