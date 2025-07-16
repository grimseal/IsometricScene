package graphics.mesh;

import kha.FastFloat;
import kha.Image;
import kha.math.FastVector2;
import core.AABB;
import graphics.mesh.Mesh.MeshLayout;

class MeshRaycast {
	static final bufferAABB:AABB = AABB.empty();

	public static inline function worldToLocal(point:FastVector2, meshPosition:FastVector2):FastVector2
		return new FastVector2(point.x - meshPosition.x, point.y - meshPosition.y);

	public inline static function hitTestWorld(point:FastVector2, meshPosition:FastVector2, mesh:Mesh, tex:Image, alphaThreshold:FastFloat = 0.1):Bool {
		return hitTest(worldToLocal(point, meshPosition), mesh, tex, alphaThreshold);
	}

	public static function hitTest(point:FastVector2, mesh:Mesh, tex:Image, alphaThreshold:FastFloat = 0.1):Bool {
		if (!MeshStorage.fillAABB(mesh, bufferAABB).contains(point.x, point.y))
			return false;

		final layout = MeshLayout.Position2 | MeshLayout.UV;
		final layoutSize = layout.getSize(); // 4 floats
		final layoutByteSyze = layoutSize * 4;
		final vertices = MeshStorage.vertices;
		final indices = MeshStorage.indices;
		final texW = tex.width;
		final texH = tex.height;
		final triCount = Std.int(mesh.indicesCount / 3);
		final vertexByteOffset = mesh.verticesByteOffset;
		var indexByteOffset = mesh.indicesByteOffset;

		for (_ in 0...triCount) {
			final i0 = indices.getUint32(indexByteOffset + 0);
			final i1 = indices.getUint32(indexByteOffset + 4);
			final i2 = indices.getUint32(indexByteOffset + 8);
			indexByteOffset += 12;

			final base0 = vertexByteOffset + i0 * layoutByteSyze;
			final base1 = vertexByteOffset + i1 * layoutByteSyze;
			final base2 = vertexByteOffset + i2 * layoutByteSyze;

			final ax = vertices.getFloat32(base0 + 0);
			final ay = vertices.getFloat32(base0 + 4);
			final bx = vertices.getFloat32(base1 + 0);
			final by = vertices.getFloat32(base1 + 4);
			final cx = vertices.getFloat32(base2 + 0);
			final cy = vertices.getFloat32(base2 + 4);

			final bary = computeBarycentric(point.x, point.y, ax, ay, bx, by, cx, cy);
			if (bary == null) {
				continue;
			}

			final u = bary.u;
			final v = bary.v;
			final w = 1.0 - u - v;

			final uv0x = vertices.getFloat32(base0 + 8);
			final uv0y = vertices.getFloat32(base0 + 12);
			final uv1x = vertices.getFloat32(base1 + 8);
			final uv1y = vertices.getFloat32(base1 + 12);
			final uv2x = vertices.getFloat32(base2 + 8);
			final uv2y = vertices.getFloat32(base2 + 12);

			final uvx = uv0x * w + uv1x * u + uv2x * v;
			final uvy = uv0y * w + uv1y * u + uv2y * v;

			final texX = Std.int(uvx * texW);
			final texY = Std.int(uvy * texH);

			if (texX < 0 || texY < 0 || texX >= texW || texY >= texH) {
				continue;
			}

			final pixel = tex.at(texX, texY);
			if (pixel.A >= alphaThreshold)
				return true;
		}
		return false;
	}

	static function computeBarycentric(px:FastFloat, py:FastFloat, ax:FastFloat, ay:FastFloat, bx:FastFloat, by:FastFloat, cx:FastFloat,
			cy:FastFloat):{u:FastFloat, v:FastFloat} {
		final v0x = bx - ax;
		final v0y = by - ay;
		final v1x = cx - ax;
		final v1y = cy - ay;
		final v2x = px - ax;
		final v2y = py - ay;

		final d00 = v0x * v0x + v0y * v0y;
		final d01 = v0x * v1x + v0y * v1y;
		final d11 = v1x * v1x + v1y * v1y;
		final d20 = v2x * v0x + v2y * v0y;
		final d21 = v2x * v1x + v2y * v1y;

		final denom = d00 * d11 - d01 * d01;
		if (denom == 0.0)
			return null;

		final invDenom = 1.0 / denom;
		final u = (d11 * d20 - d01 * d21) * invDenom;
		final v = (d00 * d21 - d01 * d20) * invDenom;

		if (u >= 0 && v >= 0 && (u + v) <= 1.0)
			return {u: u, v: v};
		else
			return null;
	}
}
