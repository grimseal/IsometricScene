package system;

import kha.graphics2.Graphics;
import kha.Color;
import kha.Font;
import kha.Assets;
import kha.Framebuffer;
import core.Time;
import core.System.IRenderSystem;
import graphics.RenderPassData;

using ext.FloatExt;
using ext.ArrayExt;

class DrawFpsSystem implements IRenderSystem {
	static var font:Font;

	public function new() {}

	public function init() {
		font = Assets.fonts.get(Assets.fonts.names.first());
	};

	public function render(data:RenderPassData) {
		final g = data.framebuffer.g2;
		g.begin(false);
		g.font = font;
		g.fontSize = 32;
		drawStringWithShadow(g, Std.string((1 / Time.deltaTime).round()), 0, 0, font, 32, Color.Orange);
		g.end();
	}

	public function drawStringWithShadow(g:Graphics, str:String, x:Float, y:Float, font:Font, fontSize:Int, color:Color = kha.Color.White,
			shadow:Color = kha.Color.Black) {
		g.color = shadow;
		g.drawString(str, x + 2, y + 2);
		g.color = color;
		g.drawString(str, x, y);
	}
}
