package system;

import graphics.PostProcess;
import kha.Shaders;
import kha.Framebuffer;
import kha.graphics4.*;
import core.System.IRenderSystem;
import graphics.mesh.Mesh.MeshLayout;

using ext.FloatExt;
using ext.ArrayExt;

class DrawIsoGridSystem implements IRenderSystem {
	static inline final POSITION_NAME:String = "vertexPosition";
	static inline final UV_NAME:String = "vertexUV";
	static inline final MAX_VERTICES:Int = 4;

	var pipeline:PipelineState;
	var vertexStructure:VertexStructure;
	var vb:VertexBuffer;
	var ib:IndexBuffer;

	var postProcess:IsoGridPostProcess;

	public function new() {}

	public function init() {
		postProcess = new IsoGridPostProcess();
		postProcess.init({
			vertexShader: Shaders.iso_grid_vert,
			fragmentShader: Shaders.iso_grid_frag
		});
	}

	public function render(framebuffer:Framebuffer) {
		var g = framebuffer.g4;
		g.begin();

		g.setPipeline(pipeline);

		// g.drawRect(0, 0, framebuffer.width, framebuffer.height);
		g.end();
	}
}

class IsoGridPostProcess extends PostProcess {
	public function new() {}

	function prepare(g:Graphics) {}
}
