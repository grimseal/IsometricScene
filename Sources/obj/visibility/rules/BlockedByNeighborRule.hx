package obj.visibility.rules;

import obj.Cell.CellState;

class BlockedByNeighborRule implements IVisibilityRule {
	public function new() {}

	public function apply(cell:Cell, grid:IsoGrid):Bool {
		if (!cell.isOccupied)
			return false;

		for (dir in VisibilityConstants.cardinalDirs) {
			final n = grid.getCellByCoords(cell.position.x + dir.x, cell.position.y + dir.y);
			if (n != null && n.state.has(CellState.Occupied | CellState.Locked) && n.content == cell.content) {
				cell.state = cell.state.add(CellState.Locked);
				return true;
			}
		}
		return false;
	}
}
