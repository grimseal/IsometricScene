package core;

import kha.Framebuffer;
import graphics.RenderPassData;
import obj.Scene;

interface IRenderSystem {
	function init():Void;
	function render(data:RenderPassData):Void;
}

interface ISystem {
	function load():Void;
	function init():Void;
	function update():Void;
}

@:access(SimulationSystems)
class System {
	static final passData:RenderPassData = new RenderPassData();

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
		preparePassData(framebuffer);
		for (system in SimulationSystems.renderSystems)
			system.render(passData);
		clearPassData();
	}

	static inline function preparePassData(framebuffer:Framebuffer) {
		passData.framebuffer = framebuffer;
		passData.camera = Scene.current.camera;
		passData.camera.updateProjectionMatrix(framebuffer.width, framebuffer.height);
		final queryAABB = passData.camera.getViewportAABB();
		Scene.current.spatialGrid.query(queryAABB, passData.objects);
	}

	static inline function clearPassData()
		passData.clear();
}
