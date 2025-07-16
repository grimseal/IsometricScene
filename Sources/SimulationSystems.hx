package;

import system.*;

class SimulationSystems {
	static var simulationSystems:Array<core.System.ISystem> = [new LoadSystem(), new PauseSystem(), new MoveSystem(), new CameraControlSystem()];
	static var renderSystems:Array<core.System.IRenderSystem> = [
		new DrawIsoGridSystem(),
		new ObjectsRenderSystem(),
		// new AABBDebugSystem(),
		// new DepthDebugSystem(),
		new DrawFpsSystem()
	];
}
