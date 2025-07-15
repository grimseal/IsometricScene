package system;

import core.AABB;
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
		final queryAABB = camera.getViewportAABB(100);
		final objects = Scene.current.spatialGrid.query(queryAABB);

		g.begin(false);
		g.pushTransformation(getTransformation(framebuffer, camera));
		g.color = Color.Magenta;
		g.drawRect(queryAABB.minX, queryAABB.minY, queryAABB.width, queryAABB.height, camera.zoom);

		g.color = Color.Yellow;
		for (obj in objects) {
			final aabb = obj.getAABB();
			g.drawRect(aabb.minX, aabb.minY, aabb.width, aabb.height, camera.zoom);
		}
		g.popTransformation();
		g.end();
	}

	inline function getQueryAABB(framebuffer:Framebuffer, camera:Camera):AABB {
		final margin = 50.0;
		final halfWidth = (framebuffer.width * .5 - margin) * camera.zoom;
		final halfHeight = (framebuffer.height * .5 - margin) * camera.zoom;

		final x = camera.position.x;
		final y = camera.position.y;

		return new AABB(x - halfWidth, y - halfHeight, x + halfWidth, y + halfHeight);
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
