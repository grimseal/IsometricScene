package graphics.mesh;

import core.AABB;
import kha.FastFloat;
import kha.arrays.Uint32Array;
import kha.arrays.Float32Array;
import graphics.mesh.Mesh;
import utils.ArrayUtil;

class MeshStorage {
	// TODO create collections over arrays
	static inline final ARRAY_SIZE:Int = 65536;
	static var meta:Uint32Array;
	static var meshCount:Int;
	static var aabb:Float32Array;
	static var indices:Uint32Array;
	static var indicesLength:Int;
	static var vertices:Float32Array;
	static var verticesLength:Int;
	static var names:Array<String>;

	public static function init() {
		meshCount = 0;
		meta = new Uint32Array(ARRAY_SIZE * MeshMeta.SIZE);
		aabb = new Float32Array(ARRAY_SIZE * 4);
		indices = new Uint32Array(ARRAY_SIZE);
		indicesLength = 0;
		vertices = new Float32Array(ARRAY_SIZE);
		verticesLength = 0;
		names = new Array<String>();
	}

	public static inline function getMesh(id:Int):Mesh {
		if (id < 0 || id > ARRAY_SIZE || MeshStorage.meta[id * MeshMeta.SIZE] == 0)
			throw 'mesh $id not exist';
		return new Mesh(id);
	}

	public static inline function getByName(name:String):Mesh {
		var index = names.indexOf(name);
		if (index < 0)
			throw 'mesh $name + not exist';
		return getMesh(index);
	}

	public static inline function getAABB(mesh:Mesh):AABB {
		return fillAABB(mesh, AABB.empty());
	}

	public static function fillAABB(mesh:Mesh, aabb:AABB):AABB {
		var offset:Int = mesh.id * 16;
		aabb.minX = MeshStorage.aabb.getFloat32(offset);
		aabb.minY = MeshStorage.aabb.getFloat32(offset + 4);
		aabb.maxX = MeshStorage.aabb.getFloat32(offset + 8);
		aabb.maxY = MeshStorage.aabb.getFloat32(offset + 12);
		return aabb;
	}

	public static function addMesh(name:String, layout:MeshLayout, indices:Uint32Array, vertices:Float32Array):Mesh {
		var indexStart = MeshStorage.indicesLength;
		var vertexStart = MeshStorage.verticesLength;
		var indexEnd = indexStart + indices.length;
		var vertexEnd = vertexStart + vertices.length;

		if (meshCount > ARRAY_SIZE || indexEnd > ARRAY_SIZE || vertexEnd > ARRAY_SIZE)
			throw "storage overflow";

		var indexCount = indices.length;
		var layoutSize = layout.getSize();
		var vertexCount:Int = cast vertices.length / layoutSize;

		var metaOffset = meshCount * MeshMeta.SIZE;
		MeshStorage.meta.set(metaOffset, layout);
		MeshStorage.meta.set(metaOffset + 1, indexStart);
		MeshStorage.meta.set(metaOffset + 2, indexCount);
		MeshStorage.meta.set(metaOffset + 3, vertexStart);
		MeshStorage.meta.set(metaOffset + 4, vertexCount);

		var step = layoutSize * 4;
		var byteOffset = 0;
		var aabbMinX:FastFloat = Math.POSITIVE_INFINITY;
		var aabbMinY:FastFloat = Math.POSITIVE_INFINITY;
		var aabbMaxX:FastFloat = Math.NEGATIVE_INFINITY;
		var aabbMaxY:FastFloat = Math.NEGATIVE_INFINITY;
		for (i in 0...vertexCount) {
			var x = vertices.getFloat32(byteOffset);
			var y = vertices.getFloat32(byteOffset + 4);
			if (x < aabbMinX)
				aabbMinX = x;
			if (y < aabbMinY)
				aabbMinY = y;
			if (x > aabbMaxX)
				aabbMaxX = x;
			if (y > aabbMaxY)
				aabbMaxY = y;
			byteOffset += step;
		}
		var aabbOffset:Int = meshCount * 4;
		MeshStorage.aabb.set(aabbOffset, aabbMinX);
		MeshStorage.aabb.set(aabbOffset + 1, aabbMinY);
		MeshStorage.aabb.set(aabbOffset + 2, aabbMaxX);
		MeshStorage.aabb.set(aabbOffset + 3, aabbMaxY);

		ArrayUtil.memcpy(indices, 0, MeshStorage.indices, indexStart * 4, indices.byteLength);
		ArrayUtil.memcpy(vertices, 0, MeshStorage.vertices, vertexStart * 4, vertices.byteLength);

		MeshStorage.indicesLength = indexEnd;
		MeshStorage.verticesLength = vertexEnd;

		names[meshCount] = name;

		var mesh = new Mesh(meshCount);
		meshCount++;
		return mesh;
	}

	// TODO remove mesh
}

@:access(graphics.mesh.MeshStorage)
abstract MeshMeta(Int) {
	public static inline final SIZE:Int = 5;

	public inline function new(index:Int)
		this = index * SIZE;

	public var layout(get, never):MeshLayout;

	inline function get_layout():MeshLayout
		return cast MeshStorage.meta[this];

	public var indexOffset(get, never):Int;

	inline function get_indexOffset():Int
		return MeshStorage.meta[this + 1];

	public var indexCount(get, never):Int;

	inline function get_indexCount():Int
		return MeshStorage.meta[this + 2];

	public var vertexOffset(get, never):Int;

	inline function get_vertexOffset():Int
		return MeshStorage.meta[this + 3];

	public var vertexCount(get, never):Int;

	inline function get_vertexCount():Int
		return MeshStorage.meta[this + 4];

	@:to public function toString():String {
		var parts = [];
		parts.push(layout.toString());
		parts.push('index offset $indexOffset');
		parts.push('index count $indexCount');
		parts.push('vertex offset $vertexOffset');
		parts.push('vertex count $vertexCount');
		return parts.join("; ");
	}
}
