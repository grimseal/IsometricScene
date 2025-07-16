package obj.visibility.rules;

import obj.IsoGrid;
import obj.Cell;

class VisibleByFreeNeighborRule implements IVisibilityRule {
	public function new() {}

	public function apply(cell:Cell, grid:IsoGrid):Bool {
		for (dir in VisibilityConstants.cardinalDirs) {
			final n = grid.getCellByCoords(cell.position.x + dir.x, cell.position.y + dir.y);
			if (n != null && !n.isOccupied && n.state.has(CellState.Visible)) {
				cell.state = cell.state.remove(CellState.Invisible).remove(CellState.Semivisible).add(CellState.Visible);
				return true;
			}
		}
		return false;
	}
}
