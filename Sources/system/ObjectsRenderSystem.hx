package system;

import kha.Image;
import kha.Color;
import kha.Assets;
import graphics.RenderPassData;
import core.System.IRenderSystem;
#if !nodejs
import graphics.sprite.SpriteRenderer;
#end

class ObjectsRenderSystem implements IRenderSystem {
	private static final bgColor:Color = kha.Color.fromBytes(0x26, 0, 0x4d);

	#if !nodejs
	private var renderer:SpriteRenderer;
	#end
	private var image:Image;

	public function new() {}

	public function init() {
		#if !nodejs
		renderer = new SpriteRenderer();
		#end
		image = Assets.images.get("objects");
	}

	public function render(data:RenderPassData) {
		#if !nodejs
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
		#end
	}
}
