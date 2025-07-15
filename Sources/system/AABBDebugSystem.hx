package system;

import kha.Color;
import kha.Framebuffer;
import kha.math.FastMatrix3;
import graphics.RenderPassData;
import core.System;
import core.Camera;

class AABBDebugSystem implements IRenderSystem {
	public function new() {}

	public function init() {}

	public function render(data:RenderPassData) {
		final g = data.framebuffer.g2;
		g.begin(false);
		g.pushTransformation(getTransformation(data.framebuffer, data.camera));
		g.color = Color.Yellow;
		for (obj in data.objects) {
			final aabb = obj.getAABB();
			g.drawRect(aabb.minX, aabb.minY, aabb.width, aabb.height, data.camera.zoom);
		}
		g.popTransformation();
		g.color = Color.White;
		g.end();
	}

	inline function getTransformation(framebuffer:Framebuffer, camera:Camera):FastMatrix3 {
		final screenW = framebuffer.width;
		final screenH = framebuffer.height;
		final scale = 1.0 / camera.zoom;
		final trCamera = FastMatrix3.translation(-camera.position.x, -camera.position.y);
		final scZoom = FastMatrix3.scale(scale, scale);
		final trScreen = FastMatrix3.translation(screenW / 2, screenH / 2);
		return trScreen.multmat(scZoom).multmat(trCamera);
	}
}
