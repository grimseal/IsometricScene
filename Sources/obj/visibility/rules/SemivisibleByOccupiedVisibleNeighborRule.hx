package obj.visibility.rules;

import obj.IsoGrid;
import obj.Cell;

class SemivisibleByOccupiedVisibleNeighborRule implements IVisibilityRule {
	public function new() {}

	public function apply(cell:Cell, grid:IsoGrid):Bool {
		for (dir in VisibilityConstants.cardinalDirs) {
			final n = grid.getCellByCoords(cell.position.x + dir.x, cell.position.y + dir.y);
			if (n != null && n.state.has(CellState.Occupied | CellState.Visible)) {
				cell.state = cell.state.remove(CellState.Invisible).add(CellState.Semivisible);
				return true;
			}
		}
		return false;
	}
}
