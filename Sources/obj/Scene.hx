package obj;

import core.Camera;
import obj.SceneObject;
import obj.Cell;

class Scene {
	public static var current:Scene;

	public var objects(default, null):Array<SceneObject>;
	public var camera:Camera;
	public var grid:Grid;

	public function new(grid:Grid) {
		this.grid = grid;
		objects = [];
	}

	public function addObj(obj:SceneObject):Void {
		if (objects.contains(obj))
			throw "object already exists in scene";

		if (obj.type == SceneObjectType.NONBLOCKING) {
			objects.push(obj);
			return;
		}

		var cell:Cell = grid.getCellByPosition(obj.gridPosition);
		if (cell == null)
			throw 'cell not found ${obj.gridPosition}';
		if (cell.content != null)
			throw "cell already has content, we need to remove the old object first";

		cell.content = obj;
		objects.push(obj);
	}

	public function update():Void {
		for (object in objects)
			object.update();
	}

	public function removeObj(obj:SceneObject):Void {
		objects.remove(obj);
		var cell:Cell = grid.getCellByPosition(obj.position);
		if (cell.content == obj)
			cell.content = null;
	}
}
