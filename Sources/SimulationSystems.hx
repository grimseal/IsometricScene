package;

import system.*;

class SimulationSystems {
	static var simulationSystems:Array<core.System.ISystem> = [new LoadSystem(), new MoveSystem()];
	static var renderSystems:Array<core.System.IRenderSystem> = [new ObjectsRenderSystem(), new DrawIsoGridSystem(), new DrawFpsSystem()];
}
