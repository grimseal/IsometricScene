package utils.atlasParser;

import kha.Blob;
import kha.arrays.Uint32Array;
import kha.arrays.Float32Array;
import graphics.mesh.Mesh;

interface IAtlasParser {
	public function parse(data:Blob):Array<MeshData>;
}

typedef MeshData = {
	var name:String;
	var layout:MeshLayout;
	var vertices:Float32Array;
	var indices:Uint32Array;
}
