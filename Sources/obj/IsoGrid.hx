package obj;

import kha.math.Vector2i;
import obj.Cell;
import obj.Coords;
import obj.visibility.VisibilityConstants;

class IsoGrid {
	static final visibilityRules = VisibilityConstants.rules;
	static final directions = VisibilityConstants.cardinalDirs;

	public final size:Vector2i;
	public final sortManager:IsoSortManager;
	public final depthMap:IsoDepthMap;
	public final locked:Array<IsoAABB>;

	final cells:Array<Cell>;
	final visited:Map<Int, Bool>;
	final queue:List<Cell>;
	final queue2:List<Cell>;

	public function new(size:Vector2i, locked:Array<IsoAABB>) {
		this.size = size;
		this.depthMap = new IsoDepthMap(size.x, size.y);
		this.sortManager = new IsoSortManager();
		this.cells = new Array<Cell>();
		this.locked = locked;
		this.visited = new Map<Int, Bool>();
		this.queue = new List<Cell>();
		this.queue2 = new List<Cell>();
		var index = 0;
		for (y in 0...size.y)
			for (x in 0...size.x)
				cells.push(new Cell(index++, new Vector2i(x, y)));
		for (lock in locked)
			setCellsLocked(lock);
	}

	public inline function setCellsContent(obj:SceneObject):Void
		setCellsContentInternal(obj, obj);

	public inline function clearCellsContent(obj:SceneObject):Void
		setCellsContentInternal(obj, null);

	function setCellsContentInternal(obj:SceneObject, content:SceneObject):Void {
		final rect = obj.isoAABB;
		for (y in rect.yMin...rect.yMax)
			for (x in rect.xMin...rect.xMax)
				if (contains(x, y))
					getCellByCoords(x, y).content = content;
	}

	function setCellsLocked(rect:IsoAABB):Void {
		for (y in rect.yMin...rect.yMax)
			for (x in rect.xMin...rect.xMax)
				if (contains(x, y)) {
					final cell = getCellByCoords(x, y);
					cell.state = cell.state.add(CellState.Locked);
				}
	}

	public function contains(x:Int, y:Int):Bool {
		return !(x < 0 || y < 0 || x >= size.x || y >= size.y);
	}

	public function getCellById(id:Int):Cell {
		if (id < 0 || id >= cells.length)
			return null;
		return cells[id];
	}

	public function getCellByPosition(position:GridPos):Cell {
		if (position.x < 0 || position.x >= size.x || position.y < 0 || position.y >= size.y)
			return null;
		return cells[Std.int(position.y) * size.x + Std.int(position.x)];
	}

	public function getCellByCoords(x:Int, y:Int):Cell {
		if (x < 0 || x >= size.x || y < 0 || y >= size.y)
			return null;
		return cells[y * size.x + x];
	}

	public function propagateVisibility(source:Cell):Void {
		for (cell in cells)
			cell.state = cell.state.remove(CellState.Visible).remove(CellState.Semivisible).add(CellState.Invisible);
		source.state = source.state.remove(CellState.Invisible).add(CellState.Visible);

		queue.add(source);
		visited.set(source.id, true);

		// reveal empty visible cells
		while (!queue.isEmpty()) {
			final current = queue.pop();
			current.state = current.state.remove(CellState.Invisible).add(CellState.Visible);

			for (dir in directions) {
				final nx = current.position.x + dir.x;
				final ny = current.position.y + dir.y;
				if (!contains(nx, ny))
					continue;

				final neighbor = getCellByCoords(nx, ny);
				if (visited.exists(neighbor.id))
					continue;

				if (neighbor.isOccupied || neighbor.state.has(CellState.Locked))
					queue2.add(neighbor);
				else {
					visited.set(neighbor.id, true);
					queue.add(neighbor);
				}
			}
		}

		// apply neighbouring rules to the rest
		while (!queue2.isEmpty()) {
			final current = queue2.pop();

			for (dir in directions) {
				final nx = current.position.x + dir.x;
				final ny = current.position.y + dir.y;

				if (!contains(nx, ny))
					continue;

				final neighbor = getCellByCoords(nx, ny);
				if (visited.exists(neighbor.id))
					continue;

				for (rule in visibilityRules) {
					if (rule.apply(neighbor, this)) {
						queue2.add(neighbor);
						visited.set(neighbor.id, true);
						break;
					}
				}
			}
		}

		visited.clear();
		queue.clear();
		queue2.clear();
	}
}
