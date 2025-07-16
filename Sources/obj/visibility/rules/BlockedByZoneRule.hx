package obj.visibility.rules;

import obj.IsoGrid;
import obj.Cell;

class BlockedByZoneRule implements IVisibilityRule {
	public function new() {}

	public function apply(cell:Cell, grid:IsoGrid):Bool {
		if (cell.state.has(CellState.Locked))
			return true;
		return false;
	}
}
