package system;

import kha.Color;
import kha.Framebuffer;
import kha.math.FastMatrix3;
import core.System;
import core.Camera;
import obj.Scene;

class AABBDebugSystem implements IRenderSystem {
	public function new() {}

	public function init() {}

	public function render(framebuffer:Framebuffer) {
		final g = framebuffer.g2;
		final camera = Scene.current.camera;
		g.begin(false);
		g.pushTransformation(getTransformation(framebuffer, camera));
		g.color = Color.Yellow;
		for (obj in Scene.current.objects) {
			final aabb = obj.getAABB();
			g.drawRect(aabb.minX, aabb.minY, aabb.width, aabb.height, camera.zoom);
		}
		g.popTransformation();
		g.end();
	}

	inline function getTransformation(framebuffer:Framebuffer, camera:Camera):FastMatrix3 {
		final screenW = framebuffer.width;
		final screenH = framebuffer.height;
		final zoom = camera.zoom;
		final scale = 1.0 / zoom;
		final trCamera = FastMatrix3.translation(-camera.position.x, -camera.position.y);
		final scZoom = FastMatrix3.scale(scale, scale);
		final trScreen = FastMatrix3.translation(screenW / 2, screenH / 2);
		return trScreen.multmat(scZoom).multmat(trCamera);
	}
}
