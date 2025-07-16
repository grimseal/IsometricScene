package utils;

import obj.Coords.GridPos;
import core.Camera;
import kha.Color;
import graphics.mesh.MeshStorage;
import kha.math.FastVector2;
import kha.math.Vector2i;
import haxe.Json;
import obj.*;
import kha.Blob;

class SceneLoader {
	public inline function new() {}

	public function load(data:Blob):Scene {
		var sceneData = parse(data);
		var size = new Vector2i(sceneData.width, sceneData.height);
		var grid = new IsoGrid(size);
		var scene = new Scene(grid, new Vector2i(sceneData.visibility_source.x, sceneData.visibility_source.y));

		for (object in sceneData.objects) {
			var mesh = MeshStorage.getByName('${object.w}x${object.h}');
			var sceneObject = new SceneObject(scene.getNextObjId(), new Vector2i(object.w, object.h), new FastVector2(object.x, object.y), mesh, Color.White);
			scene.addObj(sceneObject);
		}

		scene.camera = new Camera();
		scene.camera.position = (new GridPos(sceneData.visibility_source.x, sceneData.visibility_source.y)).toWorldPos();

		return scene;
	}

	public inline function parse(data:Blob):SceneData {
		return Json.parse(data.toString());
	}
}

typedef SceneData = {
	var width:Int;
	var height:Int;
	var objects:Array<{
		x:Int,
		y:Int,
		w:Int,
		h:Int
	}>;
	var lock_zones:Array<{
		x:Int,
		y:Int,
		w:Int,
		h:Int
	}>;
	var visibility_source:{x:Int, y:Int};
};
