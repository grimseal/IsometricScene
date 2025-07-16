package obj;

import kha.math.FastVector2;
import graphics.mesh.MeshRaycast;
import kha.Image;
import kha.FastFloat;
import core.AABB;
import core.SpatialGrid;
import core.Camera;
import obj.SceneObject;
import obj.Cell;

using ext.ArrayExt;

class Scene {
	public static var current:Scene;

	var objectIdSeq:Int = -1;

	public var objects(default, null):Array<SceneObject>;
	public var pointObjects(default, null):Array<SceneObject>;

	public var camera:Camera;
	public var grid:IsoGrid;

	public var spatialGrid:SpatialGrid<SceneObject>;

	var heightDepthOffset:Int;
	var raycastBuffer:Array<SceneObject> = new Array<SceneObject>();

	public function new(grid:IsoGrid) {
		this.grid = grid;
		spatialGrid = new SpatialGrid(100);
		objects = [];
		pointObjects = [];
		heightDepthOffset = grid.size.x * grid.size.y * 2;
	}

	public inline function getNextObjId():Int
		return ++objectIdSeq;

	public function addObj(obj:SceneObject):Void {
		if (objects.contains(obj))
			throw "object already exists in scene";

		if (obj.type == SceneObjectType.NONBLOCKING) {
			pointObjects.push(obj);
			spatialGrid.insert(obj);
			return;
		}

		final pos = obj.gridPosition;
		final x:Int = Std.int(pos.x);
		final y:Int = Std.int(pos.y);
		final isoAABB = new IsoAABB(obj.id, x, y, obj.size.x, obj.size.y);
		obj.isoAABB = isoAABB;

		grid.setCellsContent(obj);
		grid.sortManager.addObject(isoAABB);

		objects.push(obj);
		spatialGrid.insert(obj);
	}

	public function removeObj(obj:SceneObject):Void {
		if (pointObjects.remove(obj)) {
			spatialGrid.remove(obj);
			return;
		}

		if (!objects.remove(obj))
			return;

		grid.clearCellsContent(obj);
		grid.sortManager.removeObject(obj.isoAABB);
		spatialGrid.remove(obj);
	}

	public function update():Void {
		if (grid.sortManager.isDirty) {
			grid.depthMap.fill(grid.sortManager.getSorted());
			for (obj in objects) {
				final pos = obj.gridPosition;
				final x:Int = Std.int(pos.x);
				final y:Int = Std.int(pos.y);
				obj.depth = grid.depthMap.getDepth(x, y);
			}
		}

		for (obj in pointObjects) {
			final pos = obj.gridPosition;
			final x:Int = Std.int(pos.x);
			final y:Int = Std.int(pos.y);
			final depth:Int = grid.depthMap.getDepth(x, y);
			final altitude:Int = 1 - (depth & 1);
			obj.altitude = altitude;
			obj.depth = depth + heightDepthOffset * altitude;
			spatialGrid.update(obj);
		}
	}

	public function raycastAABB(aabb:AABB, result:Array<SceneObject>):Void {
		spatialGrid.query(aabb, result);
		result.sort(depthSort);
	}

	public function raycast(point:FastVector2, tex:Image):SceneObject {
		raycastBuffer.resize(0);
		spatialGrid.queryPoint(point.x, point.y, raycastBuffer);
		raycastBuffer.sort(depthSortRevert);
		for (obj in raycastBuffer)
			if (MeshRaycast.hitTestWorld(point, obj.position, obj.mesh, tex))
				return obj;
		return null;
	}

	static inline function depthSort(a:SceneObject, b:SceneObject):Int
		return a.depth != b.depth ? a.depth - b.depth : a.position.y < b.position.y ? -1 : 1;

	static inline function depthSortRevert(a:SceneObject, b:SceneObject):Int
		return b.depth != a.depth ? b.depth - a.depth : b.position.y < a.position.y ? -1 : 1;
}
