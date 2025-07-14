package system;

import kha.Assets;
import obj.Scene;
import utils.SceneLoader;
import graphics.mesh.MeshStorage;
import utils.atlasParser.TexturePackerArrayParser;
import kha.Blob;
import core.System.ISystem;

class LoadSystem implements ISystem {
	inline static final MESH_DATA_NAME:String = "objects_json";
	inline static final SCENE_DATA_NAME:String = "sceneTestSample_json";

	public function new() {}

	public function init():Void {}

	public function update():Void {}

	public function load():Void {
		MeshStorage.init(); // todo move to another place
		loadMeshes(Assets.blobs.get(MESH_DATA_NAME));
		loadScene(Assets.blobs.get(SCENE_DATA_NAME));
	}

	function loadMeshes(data:Blob) {
		var parser = new TexturePackerArrayParser();
		var meshes = parser.parse(data);
		for (mesh in meshes)
			MeshStorage.addMesh(mesh.name, mesh.layout, mesh.indices, mesh.vertices);
	}

	function loadScene(data:Blob) {
		var parser = new SceneLoader();
		Scene.current = parser.load(data);
	}
}
