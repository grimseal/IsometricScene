package;

import system.*;

class SimulationSystems {
	static var simulationSystems:Array<core.System.ISystem> = [new LoadSystem(), new MoveSystem()];
	static var renderSystems:Array<core.System.IRenderSystem> = [new DrawIsoGridSystem(), new ObjectsRenderSystem(), new DrawFpsSystem()];
}
