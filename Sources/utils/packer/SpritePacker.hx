package utils.packer;

import kha.math.FastMatrix3;
import kha.Color;
import kha.FastFloat;
import kha.Image;
import binpacking.MaxRectsPacker;
import binpacking.Rect;
import obj.SpriteAtlas;

@:structInit
class SpritePackerOptions {
	public var width:Int = -1;
	public var height:Int = -1;
	public var allowFlip:Bool = false;
	public var padding:Int = 0;
}

class SpritePacker {
	static inline final ANGLE_90_RAD:FastFloat = 3.1415926535897932384626433832795 / 2;

	public static function createAtlas(options:SpritePackerOptions, images:Array<Image>):SpriteAtlas {
		var packer = new MaxRectsPacker(options.width, options.height, false /* bug in packer */);
		var dynamicImage = kha.Image.createRenderTarget(options.width, options.height);
		var g2 = dynamicImage.g2;
		var rects:Array<core.Rect> = [];
		var renderImages:Array<Image> = [];

		// TODO replace rect with sprite

		g2.begin();
		g2.clear(Color.Transparent);
		for (image in images) {
			var rect = pack(getSize(image, options), packer);
			if (tryDrawAtlasImage(image, rect, g2))
				rects.push(rect);
		}
		g2.end();

		return new SpriteAtlas(dynamicImage, rects);
	}

	static function tryDrawAtlasImage(image:Image, rect:core.Rect, g2:kha.graphics2.Graphics):Bool {
		if (rect == null)
			return false;

		g2.color = Color.White;
		if (rect.flipped) {
			var cx = rect.x + rect.w / 2;
			var cy = rect.y + rect.h / 2;
			var translateToCenter = FastMatrix3.translation(cx, cy);
			var rotate90 = FastMatrix3.rotation(ANGLE_90_RAD);
			var finalTransform = translateToCenter.multmat(rotate90);
			g2.pushTransformation(finalTransform);
			g2.drawImage(image, 0, 0);
			g2.popTransformation();

			g2.color = Color.Magenta;
		} else {
			g2.color = Color.White;
			g2.drawImage(image, rect.x, rect.y);

			g2.color = Color.Yellow;
		}

		g2.drawRect(rect.x, rect.y, rect.w, rect.h);
		g2.font = Simulation.font;
		g2.fontSize = 14;
		g2.drawString('w: ${image.width} h: ${image.height} \nw: ${rect.w} h: ${rect.h}', rect.x, rect.y);

		g2.color = Color.White;
		return true;
	}

	static function getSize(image:Image, options:SpritePackerOptions):{w:Int, h:Int} {
		return {
			w: image.width + options.padding,
			h: image.height + options.padding
		};
	}

	static function pack(size:{w:Int, h:Int}, packer:MaxRectsPacker):core.Rect {
		var node:binpacking.Rect = packer.insert(size.w, size.h, FreeRectChoiceHeuristic.BestAreaFit);
		if (node == null) {
			trace("image not fit");
			return null;
		}

		if (node.flipped) {
			return new core.Rect(node.x, node.y, node.height, node.width, true);
		}

		return new core.Rect(node.x, node.y, node.width, node.height, false);
	}

	static function rotateImage90(src:Image):Image {
		var w = src.width;
		var h = src.height;
		var target = Image.createRenderTarget(h, w);

		var g2 = target.g2;
		g2.begin();

		g2.pushRotation(ANGLE_90_RAD, 0, 0);
		g2.translate(0, -h);
		g2.drawImage(src, 0, 0);
		g2.popTransformation();

		g2.end();
		return target;
	}
}
