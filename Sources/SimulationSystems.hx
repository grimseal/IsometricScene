package;

import system.*;

class SimulationSystems {
	static var simulationSystems:Array<core.System.ISystem> = [new LoadSystem(), new CameraControlSystem(), new MoveSystem()];
	static var renderSystems:Array<core.System.IRenderSystem> = [new DrawIsoGridSystem(), new ObjectsRenderSystem(), new DrawFpsSystem()];
}
