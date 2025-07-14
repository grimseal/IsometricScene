package;

import kha.System;
import kha.Scheduler;
import kha.Assets;
import kha.Framebuffer;
import core.Time;
import obj.Scene;

class Simulation {
	public function new() {}

	public function load():Void {
		Assets.loadEverything(init);
	}

	public function init():Void {
		Time.init();
		core.System.load();
		core.System.init();
		Scheduler.addTimeTask(step, 0, Settings.simulationFramerate);
		System.notifyOnFrames(render);
	}

	public function step():Void {
		Time.fixedStep();
		Scene.current.update();
		core.System.update();
	}

	function render(frames:Array<Framebuffer>) {
		Time.update();
		core.System.render(frames[0]);
	}
}
