package obj;

import kha.FastFloat;
import kha.math.FastVector2;

class Constants {
	public static inline final TILE_WIDTH:FastFloat = 48;
	public static inline final TILE_HEIGHT:FastFloat = 24;
}

@:forward
abstract GridPos(FastVector2) from FastVector2 to FastVector2 {
	public inline function new(x:FastFloat = 0, y:FastFloat = 0) {
		this = new FastVector2(x, y);
	}

	@:to public static inline function toWorldPos(grid:GridPos):WorldPos {
		final x = (grid.x - grid.y) * (Constants.TILE_WIDTH * 0.5);
		final y = (grid.x + grid.y) * (Constants.TILE_HEIGHT * 0.5);
		return new WorldPos(x, y);
	}
}

@:forward
abstract WorldPos(FastVector2) from FastVector2 to FastVector2 {
	public inline function new(x:FastFloat = 0, y:FastFloat = 0) {
		this = new FastVector2(x, y);
	}

	@:to public static inline function toGridPos(world:WorldPos):GridPos {
		final x = (world.x / (Constants.TILE_WIDTH * 0.5) + world.y / (Constants.TILE_HEIGHT * 0.5)) * 0.5;
		final y = (world.y / (Constants.TILE_HEIGHT * 0.5) - world.x / (Constants.TILE_WIDTH * 0.5)) * 0.5;
		return new GridPos(x, y);
	}
}
