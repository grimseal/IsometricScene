package system;

import kha.Image;
import kha.Color;
import kha.Assets;
import graphics.RenderPassData;
import graphics.sprite.SpriteRenderer;
import core.System.IRenderSystem;

class ObjectsRenderSystem implements IRenderSystem {
	private static final bgColor:Color = kha.Color.fromBytes(0x26, 0, 0x4d);

	private var renderer:SpriteRenderer;
	private var image:Image;

	public function new() {}

	public function init() {
		renderer = new SpriteRenderer();
		image = Assets.images.get("objects");
	}

	public function render(data:RenderPassData) {
		final objects = data.objects;
		final g = data.framebuffer.g4;

		g.begin();
		renderer.begin(data.framebuffer, g, image);

		for (object in objects) {
			final pos = object.position;
			renderer.draw(object.mesh, pos.x, pos.y, object.color);
		}

		renderer.end();

		g.end();
	}
}
