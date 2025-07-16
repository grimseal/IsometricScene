package system;

import kha.graphics4.TextureFormat;
import haxe.io.Bytes;
import kha.math.Vector2i;
import obj.IsoAABB;
import kha.Image;
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
		postProcess = new IsoGridPostProcess(createMask(Scene.current.grid.size, Scene.current.grid.locked));
		postProcess.init({
			vertexShader: Shaders.iso_grid_vert,
			fragmentShader: Shaders.iso_grid_frag
		});
	}

	function createMask(size:Vector2i, rects:Array<IsoAABB>):Image {
		final pixelCount = size.x * size.y;
		final pixelBytes = Bytes.alloc(pixelCount * 4);

		for (rect in rects)
			for (y in rect.yMin...rect.yMax)
				for (x in rect.xMin...rect.xMax) {
					var idx = (y * size.x + x) * 4;
					pixelBytes.set(idx + 0, 255);
					pixelBytes.set(idx + 1, 255);
					pixelBytes.set(idx + 2, 255);
					pixelBytes.set(idx + 3, 255);
				}

		return Image.fromBytes(pixelBytes, size.x, size.y, TextureFormat.RGBA32, Usage.StaticUsage, false);
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
	static inline final LOCK_GRID_COLOR_NAME:String = "lockGridColor";
	static inline final LOCK_MASK_NAME:String = "lockMaskTex";

	static final IN_GRID_COLOR:FastVector4 = new FastVector4(0, 1, 0, 1);
	static final OUT_GRID_COLOR:FastVector4 = new FastVector4(0, 0, 1, 1);
	static final LOCK_GRID_COLOR:FastVector4 = new FastVector4(1, 0, 0, 1);

	public var lockedMaskImage:Image;

	public function new(lockedMaskImage:Image) {
		this.lockedMaskImage = lockedMaskImage;
	}

	function prepare(framebuffer:Framebuffer, g:Graphics, pipeline:PipelineState) {
		// todo replace with RenderPassData
		var matrix = Scene.current.camera.getInverseProjectionMatrix();
		var size = Scene.current.grid.size;
		g.setTexture(pipeline.getTextureUnit(LOCK_MASK_NAME), lockedMaskImage);
		g.setMatrix(pipeline.getConstantLocation(VIEW_MATRIX_NAME), matrix);
		g.setVector2(pipeline.getConstantLocation(GRID_SIZE_NAME), new FastVector2(size.x, size.y));
		g.setVector4(pipeline.getConstantLocation(IN_GRID_COLOR_NAME), IN_GRID_COLOR);
		g.setVector4(pipeline.getConstantLocation(OUT_GRID_COLOR_NAME), OUT_GRID_COLOR);
		g.setVector4(pipeline.getConstantLocation(LOCK_GRID_COLOR_NAME), LOCK_GRID_COLOR);
	}
}
