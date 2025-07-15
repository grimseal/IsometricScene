package system;

import kha.Shaders;
import kha.Framebuffer;
import kha.graphics4.*;
import kha.math.FastVector2;
import kha.math.FastVector4;
import core.System.IRenderSystem;
import graphics.PostProcess;
import graphics.RenderPassData;
import obj.Scene;

using ext.FloatExt;
using ext.ArrayExt;

class DrawIsoGridSystem implements IRenderSystem {
	var postProcess:IsoGridPostProcess;

	public function new() {}

	public function init() {
		postProcess = new IsoGridPostProcess();
		postProcess.init({
			vertexShader: Shaders.iso_grid_vert,
			fragmentShader: Shaders.iso_grid_frag
		});
	}

	public function render(data:RenderPassData) {
		postProcess.draw(data.framebuffer);
	}
}

class IsoGridPostProcess extends PostProcess {
	static inline final VIEW_MATRIX_NAME:String = "inverseProjectionMatrix";
	static inline final GRID_SIZE_NAME:String = "gridSize";
	static inline final IN_GRID_COLOR_NAME:String = "inGridColor";
	static inline final OUT_GRID_COLOR_NAME:String = "outGridColor";

	static final IN_GRID_COLOR:FastVector4 = new FastVector4(0, 1, 0, 1);
	static final OUT_GRID_COLOR:FastVector4 = new FastVector4(0, 0, 1, 1);

	public function new() {}

	function prepare(framebuffer:Framebuffer, g:Graphics, pipeline:PipelineState) {
		// todo replace with RenderPassData
		var matrix = Scene.current.camera.getInverseProjectionMatrix();
		var size = Scene.current.grid.size;
		g.setMatrix(pipeline.getConstantLocation(VIEW_MATRIX_NAME), matrix);
		g.setVector2(pipeline.getConstantLocation(GRID_SIZE_NAME), new FastVector2(size.x, size.y));
		g.setVector4(pipeline.getConstantLocation(IN_GRID_COLOR_NAME), IN_GRID_COLOR);
		g.setVector4(pipeline.getConstantLocation(OUT_GRID_COLOR_NAME), OUT_GRID_COLOR);
	}
}
