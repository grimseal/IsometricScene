package obj;

import obj.visibility.IVisibilityRule;
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
	var visited:Map<Int, Bool>;
	var visitedNext:Map<Int, Bool>;
	var queue:List<Cell>;
	var queueNext:List<Cell>;

	var dirty:Bool;

	public var isDirty(get, never):Bool;

	inline function get_isDirty():Bool
		return dirty;

	public function new(size:Vector2i, locked:Array<IsoAABB>) {
		this.size = size;
		this.depthMap = new IsoDepthMap(size.x, size.y);
		this.sortManager = new IsoSortManager();
		this.cells = new Array<Cell>();
		this.locked = locked;
		this.visited = new Map<Int, Bool>();
		this.visitedNext = new Map<Int, Bool>();
		this.queue = new List<Cell>();
		this.queueNext = new List<Cell>();
		this.dirty = true;
		var index = 0;
		for (y in 0...size.y)
			for (x in 0...size.x)
				cells.push(new Cell(index++, new Vector2i(x, y)));
		for (lock in locked)
			setCellsLocked(lock);
	}

	public inline function setCellsContent(obj:SceneObject):Void
		setCellsContentInternal(obj, obj);

	public inline function clearCellsContent(obj:SceneObject):Void {
		setCellsContentInternal(obj, null);
		depthMap.fillValue(obj.isoAABB, obj.depth - 1);
	}

	function setCellsContentInternal(obj:SceneObject, content:SceneObject):Void {
		final rect = obj.isoAABB;
		for (y in rect.yMin...rect.yMax)
			for (x in rect.xMin...rect.xMax)
				if (contains(x, y))
					getCellByCoords(x, y).content = content;
		dirty = true;
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

	private inline static final CELL_SETTED_STATE_MASK:CellState = CellState.Invisible | CellState.Locked;

	public function propagateVisibility(sourcePosition:Vector2i):Bool {
		if (!dirty)
			return false;

		final source = getCellByCoords(sourcePosition.x, sourcePosition.y);

		for (cell in cells)
			cell.state = cell.state.remove(CellState.Visible).remove(CellState.Semivisible).add(CellState.Invisible);
		source.state = source.state.remove(CellState.Invisible).add(CellState.Visible);

		queue.add(source);
		visited.set(source.id, true);

		while (!queue.isEmpty()) {
			final current = queue.pop();
			current.state = current.state.remove(CellState.Invisible).add(CellState.Visible);
			visitedNext.set(current.id, true);

			for (dir in directions) {
				final nx = current.position.x + dir.x;
				final ny = current.position.y + dir.y;
				if (!contains(nx, ny))
					continue;

				final neighbor = getCellByCoords(nx, ny);
				if (visited.exists(neighbor.id))
					continue;

				visited.set(neighbor.id, true);

				if (neighbor.isOccupied || neighbor.state.has(CellState.Locked))
					queueNext.push(neighbor);
				else
					queue.add(neighbor);
			}
		}

		final t = this.queueNext;
		this.queueNext = queue;
		this.queue = t;

		final t2 = this.visitedNext;
		this.visitedNext = visited;
		this.visited = t2;

		while (!queue.isEmpty()) {
			final current = queue.pop();

			for (rule in visibilityRules)
				if (rule.apply(current, this))
					break;

			if (current.state.has(CELL_SETTED_STATE_MASK))
				continue;

			for (dir in directions) {
				final nx = current.position.x + dir.x;
				final ny = current.position.y + dir.y;

				if (!contains(nx, ny))
					continue;

				final neighbor = getCellByCoords(nx, ny);
				if (visited.exists(neighbor.id))
					continue;
				visited.set(neighbor.id, true);
				queue.add(neighbor);
			}

			if (current.isOccupied) {
				final rect = current.content.isoAABB;
				for (y in rect.yMin...rect.yMax)
					for (x in rect.xMin...rect.xMax) {
						final sibling = getCellByCoords(x, y);
						if (visited.exists(sibling.id))
							continue;
						sibling.state = current.state;
						visited.set(sibling.id, true);
						queue.add(sibling);
					}
			}
		}

		visited.clear();
		visitedNext.clear();
		queue.clear();
		queueNext.clear();

		dirty = false;
		return true;
	}
}
