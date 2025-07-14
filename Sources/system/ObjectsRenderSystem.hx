package system;

import obj.Scene;
import kha.Image;
import graphics.sprite.SpriteRenderer;
import kha.Color;
import kha.Assets;
import kha.Framebuffer;
import core.System.IRenderSystem;

using ext.FloatExt;
using ext.ArrayExt;

class ObjectsRenderSystem implements IRenderSystem {
	private static final bgColor:Color = kha.Color.fromBytes(0x26, 0, 0x4d);

	private var renderer:SpriteRenderer;
	private var image:Image;

	public function new() {}

	public function init() {
		renderer = new SpriteRenderer();
		image = Assets.images.get("objects");
	}

	public function render(framebuffer:Framebuffer) {
		var ctx = framebuffer.g4;

		ctx.begin();
		renderer.begin(framebuffer, ctx, image);

		for (object in Scene.current.objects) {
			final pos = object.position;
			renderer.draw(object.mesh, pos.x, pos.y, object.color);
		}

		renderer.end();

		ctx.end();
	}
}
