package obj.visibility.rules;

import obj.IsoGrid;
import obj.Cell;

class SemivisibleBySameSemivisibleNeighborRule implements IVisibilityRule {
	public function new() {}

	public function apply(cell:Cell, grid:IsoGrid):Bool {
		if (!cell.isOccupied)
			return false;

		for (dir in VisibilityConstants.cardinalDirs) {
			final n = grid.getCellByCoords(cell.position.x + dir.x, cell.position.y + dir.y);
			if (n != null && n.isOccupied && n.state.has(CellState.Occupied | CellState.Semivisible) && n.content == cell.content) {
				cell.state = cell.state.remove(CellState.Invisible).add(CellState.Semivisible);
				return true;
			}
		}
		return false;
	}
}
