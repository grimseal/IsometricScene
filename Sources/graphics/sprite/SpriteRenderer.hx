package graphics.sprite;

import obj.Scene;
import kha.FastFloat;
import kha.Framebuffer;
import kha.Color;
import kha.Image;
import kha.Shaders;
import kha.arrays.Float32Array;
import kha.arrays.Uint32Array;
import kha.graphics4.CompareMode;
import kha.graphics4.BlendingFactor;
import kha.graphics4.VertexStructure;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexShader;
import kha.graphics4.Graphics;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.Usage;
import kha.math.FastMatrix4;
import graphics.mesh.Mesh;
import graphics.mesh.MeshStorage;

@:access(graphics.mesh.MeshStorage)
class SpriteRenderer {
	static inline final MAX_VERTICES:Int = 65536;

	// vertex structure names
	static inline final POSITION_NAME:String = "vertexPosition";
	static inline final UV_NAME:String = "vertexUV";
	static inline final COLOR_NAME:String = "vertexColor";

	// pipeline constant names
	static inline final TEXTURE_UNIT_NAME:String = "tex";
	static inline final PROJECTION_MATRIX_NAME:String = "projectionMatrix";

	static inline final VERTEX_INPUT_SIZE:Int = 16;
	static inline final VERTEX_OUTPUT_SIZE:Int = 32;
	static inline final FLOAT32_SIZE:Int = 4;

	// todo double buffer
	var g:Graphics;
	var pipeline:PipelineState;
	var vertexStructure:VertexStructure;
	var vertShader:VertexShader;
	var fragShader:FragmentShader;
	var tex:Image;
	var projectionMatrix:FastMatrix4;

	var vb:VertexBuffer;
	var vertices:Float32Array;
	var verticesCount:Int = 0;
	var verticesByteLength:Int = 0;
	var ib:IndexBuffer;
	var indices:kha.arrays.Uint32Array;
	var indicesCount:Int = 0;
	var indicesByteLength:Int = 0;

	public function new() {
		var layout = MeshLayout.Position2 | MeshLayout.UV | MeshLayout.Color;
		vertexStructure = layout.createStructure({
			position: POSITION_NAME,
			uv: UV_NAME,
			color: COLOR_NAME
		});
		vb = new VertexBuffer(MAX_VERTICES, vertexStructure, Usage.DynamicUsage);
		ib = new IndexBuffer(MAX_VERTICES, Usage.DynamicUsage);

		pipeline = new PipelineState();
		pipeline.vertexShader = Shaders.sprite_vert;
		pipeline.fragmentShader = Shaders.sprite_frag;
		pipeline.inputLayout = [vertexStructure];
		pipeline.blendSource = BlendingFactor.SourceAlpha;
		pipeline.blendDestination = BlendingFactor.InverseSourceAlpha;
		pipeline.depthMode = CompareMode.Always;
		pipeline.depthWrite = false;
		pipeline.compile();
	}

	public function begin(framebuffer:Framebuffer, graphics:Graphics, texture:Image) { // todo move pipeline here
		projectionMatrix = Scene.current.camera.updateProjectionMatrix(framebuffer.width, framebuffer.height);
		tex = texture;
		g = graphics;
		g.setPipeline(pipeline);
		g.setVertexBuffer(vb);
		g.setIndexBuffer(ib);
		g.setTexture(pipeline.getTextureUnit(TEXTURE_UNIT_NAME), tex);
		g.setMatrix(pipeline.getConstantLocation(PROJECTION_MATRIX_NAME), projectionMatrix);
		reset();
	}

	public function draw(mesh:Mesh, posX:FastFloat, posY:FastFloat, color:kha.Color):Void {
		final meshIndexCount = mesh.indicesCount;
		final meshVertexCount = mesh.verticesCount;

		if (indicesCount + meshIndexCount > MAX_VERTICES || verticesCount + meshVertexCount > MAX_VERTICES) {
			flush();
			reset();
		}

		var renderByteOffset = indicesByteLength;
		var meshByteOffset = mesh.indicesByteOffset;
		for (_ in 0...meshIndexCount) {
			indices.setUint32(renderByteOffset, verticesCount + MeshStorage.indices.getUint32(meshByteOffset));
			renderByteOffset += FLOAT32_SIZE;
			meshByteOffset += FLOAT32_SIZE;
		}

		indicesCount += meshIndexCount;
		indicesByteLength = renderByteOffset;

		renderByteOffset = verticesByteLength;
		meshByteOffset = mesh.verticesByteOffset;
		var meshOffset = mesh.verticesByteOffset / 4;

		for (_ in 0...meshVertexCount) {
			final x = MeshStorage.vertices.getFloat32(meshByteOffset);
			final y = MeshStorage.vertices.getFloat32(meshByteOffset + 4);
			final u = MeshStorage.vertices.getFloat32(meshByteOffset + 8);
			final v = MeshStorage.vertices.getFloat32(meshByteOffset + 12);
			final x1 = x + posX; // todo cache for optimization
			final y1 = y + posY;
			writeVertex(renderByteOffset, x1, y1, u, v, color);
			meshByteOffset += VERTEX_INPUT_SIZE;
			renderByteOffset += VERTEX_OUTPUT_SIZE;
		}
		verticesCount += meshVertexCount;
		verticesByteLength = renderByteOffset;
	}

	// todo respect mesh layout
	inline function writeVertex(offset:Int, x:Float, y:Float, u:Float, v:Float, color:kha.Color):Void {
		vertices.setFloat32(offset, x);
		vertices.setFloat32(offset + 4, y);

		vertices.setFloat32(offset + 8, u);
		vertices.setFloat32(offset + 12, v);
		vertices.setFloat32(offset + 16, color.R);
		vertices.setFloat32(offset + 20, color.G);
		vertices.setFloat32(offset + 24, color.B);
		vertices.setFloat32(offset + 28, color.A);
	}

	function flush() {
		vb.unlock();
		ib.unlock();

		if (verticesCount == 0)
			return;

		g.drawIndexedVertices(0, indicesCount);
	}

	function reset() {
		indicesCount = 0;
		verticesCount = 0;
		indicesByteLength = 0;
		verticesByteLength = 0;
		indices = ib.lock();
		vertices = vb.lock();
	}

	public function end()
		flush();
}
