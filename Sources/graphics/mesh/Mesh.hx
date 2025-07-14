package graphics.mesh;

import kha.graphics5_.VertexData;
import kha.graphics4.VertexStructure;
import kha.arrays.Float32Array;
import kha.arrays.Uint32Array;
import graphics.mesh.MeshStorage;

using utils.StringUtil;

@:access(graphics.mesh.MeshStorage)
abstract Mesh(Int) {
	public inline function new(id:Int)
		this = id;

	public var id(get, never):Int;

	inline function get_id():Int
		return this;

	public var layout(get, never):MeshLayout;

	var meta(get, never):MeshMeta;

	inline function get_meta():MeshMeta
		return new MeshMeta(this);

	inline function get_layout():MeshLayout
		return meta.layout;

	public var indices(get, never):Uint32Array;

	function get_indices():Uint32Array {
		var start = meta.indexOffset;
		var end = start + meta.indexCount;
		return MeshStorage.indices.subarray(start, end);
	}

	public var indicesCount(get, never):Int;

	inline function get_indicesCount():Int {
		return meta.indexCount;
	}

	public var indicesByteOffset(get, never):Int;

	inline function get_indicesByteOffset():Int {
		return meta.indexOffset * 4;
	}

	public var indicesByteLength(get, never):Int;

	inline function get_indicesByteLength():Int {
		return meta.indexCount * 4;
	}

	public var vertices(get, never):Float32Array;

	inline function get_vertices():Float32Array {
		var start = meta.vertexOffset;
		var end = start + meta.vertexCount * meta.layout.getSize();
		return MeshStorage.vertices.subarray(start, end);
	}

	public var verticesByteOffset(get, never):Int;

	inline function get_verticesByteOffset():Int {
		return meta.vertexOffset * 4;
	}

	public var verticesByteLength(get, never):Int;

	inline function get_verticesByteLength():Int {
		return meta.vertexCount * meta.layout.getSize() * 4;
	}

	public var verticesCount(get, never):Int;

	inline function get_verticesCount():Int {
		return meta.vertexCount;
	}

	public var name(get, never):String;

	inline function get_name():String {
		return MeshStorage.names[this];
	}

	@:from public static inline function toMesh(int:Int):Mesh
		return cast int;

	@:to public inline function toString():String {
		return 'Mesh[$name]';
	}
}

enum abstract MeshLayout(Int) {
	public var None = 0;
	public var Position2 = 0x01;
	public var Position3 = 0x02;
	public var UV = 0x04;
	public var Normal = 0x08;
	public var Color = 0x10;

	public inline function has(flag:MeshLayout):Bool {
		return (this & cast flag) != 0;
	}

	public inline function add(flag:MeshLayout):MeshLayout {
		return cast(this | cast flag);
	}

	public inline function remove(flag:MeshLayout):MeshLayout {
		return cast(this & ~(cast flag));
	}

	@:op(A | B) public static inline function or(a:MeshLayout, b:MeshLayout):MeshLayout
		return orInternal(cast a, cast b);

	static inline function orInternal(a:Int, b:Int):MeshLayout
		return cast(a | b);

	@:op(A & B) public static inline function and(a:MeshLayout, b:MeshLayout):MeshLayout
		return andInternal(cast a, cast b);

	static inline function andInternal(a:Int, b:Int):MeshLayout
		return cast(a & b);

	@:op(~A) public static inline function not(a:MeshLayout):MeshLayout
		return cast(~cast a);

	@:from public static inline function fromInt(value:Int):MeshLayout
		return cast value;

	@:to public inline function toInt():Int
		return cast this;

	public inline function createStructure(names:{
		var position:String;
		var ?uv:String;
		var ?normal:String;
		var ?color:String;
	}):VertexStructure {
		var structutre = new VertexStructure();
		if (has(Position2)) {
			if (StringUtil.nullOrEmpty(names.position))
				throw "position is null or empty";
			structutre.add(names.position, VertexData.Float32_2X);
		}
		if (has(Position3)) {
			if (StringUtil.nullOrEmpty(names.position))
				throw "position is null or empty";
			structutre.add(names.position, VertexData.Float32_3X);
		}

		if (has(UV)) {
			if (StringUtil.nullOrEmpty(names.uv))
				throw "uv is null or empty";
			structutre.add(names.uv, VertexData.Float32_2X);
		}
		if (has(Normal)) {
			if (StringUtil.nullOrEmpty(names.normal))
				throw "normal is null or empty";
			structutre.add(names.normal, VertexData.Float32_3X);
		}
		if (has(Color)) {
			if (StringUtil.nullOrEmpty(names.color))
				throw "color is null or empty";
			structutre.add(names.color, VertexData.Float32_4X);
		}
		return structutre;
	}

	// TODO if to array
	public inline function getSize():Int {
		var size:Int = 0;
		if (has(Position2))
			size += 2;
		if (has(Position3))
			size += 3;
		if (has(UV))
			size += 2;
		if (has(Normal))
			size += 3;
		if (has(Color))
			size += 4;
		return size;
	}

	@:to public function toString():String {
		var parts = [];
		if (has(Position2))
			parts.push("Position2");
		if (has(Position3))
			parts.push("Position3");
		if (has(UV))
			parts.push("UV");
		if (has(Normal))
			parts.push("Normal");
		if (has(Color))
			parts.push("Color");
		if (parts.length == 0)
			return "None";
		return parts.join(" | ");
	}
}
