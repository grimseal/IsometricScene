package obj;

class IsoDepthMap {
	static inline final DEPTH_STEP:Int = 2;
	static inline final EMPTY:Int = 0;

	final width:Int;
	final height:Int;
	final mapEmpty:Array<Int>;
	var map:Array<Int>;

	public function new(width:Int, height:Int) {
		this.width = width;
		this.height = height;
		this.map = new Array<Int>();
		this.mapEmpty = [for (i in 0...width * height) 0];
	}

	public function getDepth(x:Int, y:Int):Int
		return map[idx(x, y)];

	public function fill(objects:Array<IsoAABB>):Void {
		map = mapEmpty.copy();

		var depth:Int = 0;
		for (v in objects) {
			final xMax = v.x + v.width;
			final yMax = v.y + v.height;
			depth += DEPTH_STEP;
			for (y in v.y...yMax)
				for (x in v.x...xMax)
					map[idx(x, y)] = depth;
		}

		for (v in objects) {
			final xMax = v.x + v.width;
			final yMax = v.y + v.height;
			for (y in v.y...yMax)
				for (x in v.x...xMax)
					fillUntil(x, y);
		}

		fillBorder();
	}

	public function fillValue(rect:IsoAABB, val:Int):Void {
		for (y in rect.yMin...rect.yMax)
			for (x in rect.xMin...rect.xMax)
				map[idx(x, y)] = val;
	}

	inline function fillUntil(originX:Int, originY:Int):Void {
		var val = map[idx(originX, originY)];
		if (val == EMPTY)
			return;
		val--;
		var dy = originY - 1;
		var dx = originX;
		while (dy >= 0) {
			while (dx >= 0) {
				final i = idx(dx, dy);
				dx--;
				if (map[i] != EMPTY)
					break;
				map[i] = val;
			}
			dx = originX;
			dy--;
		}
		dy = originY;
		dx = originX - 1;
		while (dx >= 0) {
			final i = idx(dx, dy);
			dx--;
			if (map[i] != EMPTY)
				break;
			map[i] = val;
		}
	}

	inline function fillBorder():Void {
		final val = width * height * 2 - 1;

		var dx = width - 1;
		for (dy in 0...height) {
			while (dx >= 0) {
				final i = idx(dx, dy);
				dx--;
				if (map[i] != EMPTY)
					break;
				map[i] = val;
			}
			dx = width - 1;
		}
	}

	inline function idx(x:Int, y:Int):Int
		return y * width + x;
}
