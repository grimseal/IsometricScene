package obj.visibility.rules;

import obj.IsoGrid;
import obj.Cell;

class VisibleBySameOccupiedNeighborRule implements IVisibilityRule {
	public function new() {}

	public function apply(cell:Cell, grid:IsoGrid):Bool {
		if (!cell.isOccupied)
			return false;

		for (dir in VisibilityConstants.cardinalDirs) {
			final n = grid.getCellByCoords(cell.position.x + dir.x, cell.position.y + dir.y);
			if (n != null && n.state.has(CellState.Occupied | CellState.Visible) && n.content == cell.content) {
				cell.state = cell.state.remove(CellState.Invisible).add(CellState.Visible);
				return true;
			}
		}
		return false;
	}
}
