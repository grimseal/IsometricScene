package utils.atlasParser;

import haxe.Json;
import kha.Blob;
import kha.arrays.Uint32Array;
import kha.arrays.Float32Array;
import graphics.mesh.Mesh;
import utils.atlasParser.AtlasParser;

using ext.FloatExt;

class TexturePackerArrayParser implements AtlasParser.IAtlasParser {
	public inline function new() {}

	public inline function parse(data:Blob):Array<MeshData>
		return parseInternal(Json.parse(data.toString()));

	private static function parseInternal(src:SpriteData):Array<MeshData> {
		var data = new Array<MeshData>();

		var layout = MeshLayout.Position2 | MeshLayout.UV;
		var size = layout.getSize();
		var sizeRcpW:Float = 1.0 / src.meta.size.w;
		var sizeRcpH:Float = 1.0 / src.meta.size.h;

		for (frame in src.frames) {
			var indices = new kha.arrays.Uint32Array(frame.triangles.length * 3);
			var i:Int = -1;
			for (triangle in frame.triangles)
				for (index in triangle)
					indices[++i] = index;

			// TODO remove debug
			var i0 = indices.get(0);
			var i1 = indices.get(1);
			var i2 = indices.get(2);

			var u0 = indices.getUint32(0);
			var u1 = indices.getUint32(4);
			var u2 = indices.getUint32(8);

			// round for pixel perfect

			var pivotX = 0.5;
			var pivotY = 0.5;

			if (frame.pivot != null) {
				pivotX = frame.pivot.x;
				pivotY = frame.pivot.y;
			}

			var positionOffsetX:Float = (-frame.sourceSize.w * pivotX).round();
			var positionOffsetY:Float = (-frame.sourceSize.h * pivotY).round();

			var vertices = new Float32Array(frame.vertices.length * size);
			var offset:Int = 0;
			for (vert in frame.vertices) {
				vertices[offset] = vert[0] + positionOffsetX;
				vertices[offset + 1] = vert[1] + positionOffsetY;
				offset += size;
			}
			offset = 2;
			for (uv in frame.verticesUV) {
				vertices[offset] = uv[0] * sizeRcpW;
				vertices[offset + 1] = uv[1] * sizeRcpH;
				offset += size;
			}

			data.push({
				name: frame.filename.substring(0, frame.filename.length - 4),
				layout: layout,
				indices: indices,
				vertices: vertices
			});
		}

		return data;
	}
}

typedef SpriteData = {
	var frames:Array<SpriteDataFrame>;
	var meta:SpriteDataMeta;
}

typedef SpriteDataFrame = {
	var filename:String;
	var frame:SpriteDataRect;
	var rotated:Bool;
	var trimmed:Bool;
	var spriteSourceSize:SpriteDataRect;
	var sourceSize:{w:Int, h:Int};
	var ?pivot:{x:Float, y:Float};
	var vertices:Array<Array<Int>>;
	var verticesUV:Array<Array<Int>>;
	var triangles:Array<Array<Int>>;
}

typedef SpriteDataMeta = {
	var app:String;
	var version:String;
	var image:String;
	var format:String;
	var size:{w:Int, h:Int};
	var scale:String;
	var smartupdate:String;
}

typedef SpriteDataRect = {
	x:Int,
	y:Int,
	w:Int,
	h:Int
}
