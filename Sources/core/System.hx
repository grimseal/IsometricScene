package core;

import kha.Framebuffer;

interface IRenderSystem {
	function init():Void;
	function render(framebuffer:Framebuffer):Void;
}

interface ISystem {
	function load():Void;
	function init():Void;
	function update():Void;
}

@:access(SimulationSystems)
class System {
	public static function load() {
		for (system in SimulationSystems.simulationSystems)
			system.load();
	}

	public static function init() {
		for (system in SimulationSystems.simulationSystems)
			system.init();
		for (system in SimulationSystems.renderSystems)
			system.init();
	}

	public static function update() {
		for (system in SimulationSystems.simulationSystems)
			system.update();
	}

	public static function render(framebuffer:Framebuffer) {
		for (system in SimulationSystems.renderSystems)
			system.render(framebuffer);
	}
}
