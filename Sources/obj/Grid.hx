package obj;

import obj.Cell;
import obj.Coords;
import kha.math.Vector2i;

class Grid {
	public var size(default, null):Vector2i;

	var cells(default, null):Array<Cell>;

	public function new(size:Vector2i) {
		this.size = size;
		cells = new Array<Cell>();
		var index = 0;
		for (y in 0...size.y) {
			for (x in 0...size.x) {
				var cell = new Cell(index, new GridPos(x, y));
				cells.push(cell);
				index++;
			}
		}
	}

	public function getCellById(id:Int):Cell {
		if (id < 0 || id >= cells.length)
			return null;
		return cells[id];
	}

	public function getCellByPosition(position:GridPos):Cell {
		if (position.x < 0 || position.x >= size.x || position.y < 0 || position.y >= size.y)
			return null;
		return cells[Std.int(position.y * size.x + position.x)];
	}

	public function getCellByCoords(x:Int, y:Int):Cell {
		if (x < 0 || x >= size.x || y < 0 || y >= size.y)
			return null;
		return cells[y * size.x + x];
	}
}
