package system;

import kha.Color;
import kha.Font;
import kha.Assets;
import kha.Framebuffer;
import kha.math.FastMatrix3;
import kha.graphics2.Graphics;
import core.System;
import core.Camera;
import graphics.RenderPassData;

using ext.ArrayExt;

class DepthDebugSystem implements IRenderSystem {
	static var font:Font;

	public function new() {}

	public function init() {
		font = Assets.fonts.get(Assets.fonts.names.first());
	}

	public function render(data:RenderPassData) {
		final g = data.framebuffer.g2;
		g.begin(false);
		g.pushTransformation(getTransformation(data.framebuffer, data.camera));
		g.font = font;
		g.fontSize = 20;
		g.color = Color.Magenta;
		for (obj in data.objects) {
			final aabb = obj.getAABB();
			g.drawString('${obj.depth}', aabb.minX, aabb.minY);
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

	public function drawStringWithShadow(g:Graphics, str:String, x:Float, y:Float, color:Color = kha.Color.White, shadow:Color = kha.Color.Black) {
		g.color = shadow;
		g.drawString(str, x + 2, y + 2);
		g.color = color;
		g.drawString(str, x, y);
	}
}
