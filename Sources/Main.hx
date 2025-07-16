package;

import kha.System;

class Main {
	public static function main() {
		System.start({
			title: Settings.APP_NAME
		}, _ -> new Simulation().start());
	}
}
