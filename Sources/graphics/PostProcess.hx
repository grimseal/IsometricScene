package graphics;

import kha.math.FastMatrix4;
import kha.Framebuffer;
import kha.graphics4.*;
import graphics.mesh.Mesh.MeshLayout;

abstract class PostProcess {
	static inline final PROJECTION_MATRIX_NAME:String = "projectionMatrix";
	static inline final POSITION_NAME:String = "position";
	static inline final UV_NAME:String = "uv";
	static inline final MAX_VERTICES:Int = 4;

	static var initialized:Bool;
	static var vertexStructure:VertexStructure;
	static var vb:VertexBuffer;
	static var ib:IndexBuffer;

	var pipeline:PipelineState;

	static function initInternal() {
		if (initialized)
			return;

		vertexStructure = (MeshLayout.Position2 | MeshLayout.UV).createStructure({
			position: POSITION_NAME,
			uv: UV_NAME
		});

		vb = new VertexBuffer(4, vertexStructure, Usage.StaticUsage);
		ib = new IndexBuffer(6, Usage.StaticUsage);

		var indices = ib.lock();
		indices[0] = 0;
		indices[1] = 1;
		indices[2] = 2;
		indices[3] = 0;
		indices[4] = 2;
		indices[5] = 3;
		ib.unlock();

		var vertices = vb.lock();
		vertices[0] = -1.0;
		vertices[1] = -1.0;
		vertices[2] = 0.0;
		vertices[3] = 1.0;
		vertices[4] = 1.0;
		vertices[5] = -1.0;
		vertices[6] = 1.0;
		vertices[7] = 1.0;
		vertices[8] = 1.0;
		vertices[9] = 1.0;
		vertices[10] = 1.0;
		vertices[11] = 0.0;
		vertices[12] = -1.0;
		vertices[13] = 1.0;
		vertices[14] = 0.0;
		vertices[15] = 0.0;
		vb.unlock();

		initialized = true;
	}

	public final function init(shader:Shader) {
		initInternal();

		pipeline = new PipelineState();
		pipeline.vertexShader = shader.vertexShader;
		pipeline.fragmentShader = shader.fragmentShader;
		pipeline.inputLayout = [vertexStructure];
		pipeline.blendSource = BlendingFactor.SourceAlpha;
		pipeline.blendDestination = BlendingFactor.InverseSourceAlpha;
		pipeline.depthMode = CompareMode.Always;
		pipeline.depthWrite = false;
		pipeline.compile();
	}

	public final function draw(framebuffer:Framebuffer, projectionMatrix:FastMatrix4) {
		var g = framebuffer.g4;
		g.begin();
		g.setPipeline(pipeline);
		g.setVertexBuffer(vb);
		g.setIndexBuffer(ib);
		g.setMatrix(pipeline.getConstantLocation(PROJECTION_MATRIX_NAME), projectionMatrix);
		prepare(g);
		g.drawIndexedVertices(0, 6);
		g.end();
	}

	abstract function prepare(g:Graphics):Void;
}
