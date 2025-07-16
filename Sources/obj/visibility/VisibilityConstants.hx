package obj.visibility;

import kha.math.Vector2i;
import obj.visibility.rules.*;

class VisibilityConstants {
	public static final cardinalDirs:Array<Vector2i> = [
		new Vector2i(0, -1), // down
		new Vector2i(0, 1), // up
		new Vector2i(-1, 0), // left
		new Vector2i(1, 0) // right
	];

	public static final rules:Array<IVisibilityRule> = [
		new BlockedByZoneRule(),
		new BlockedByNeighborRule(),
		new VisibleByFreeNeighborRule(),
		new VisibleBySameOccupiedNeighborRule(),
		new SemivisibleByOccupiedVisibleNeighborRule(),
		new SemivisibleBySameSemivisibleNeighborRule()
	];
}
