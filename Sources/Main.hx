package;

import kha.System;

class Main {
	public static function main() {
		System.start({
			title: Settings.appName,
			width: Settings.screenWidth,
			height: Settings.screenHeight,
		}, _ -> new Simulation().load());
	}
}
