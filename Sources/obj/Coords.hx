package obj;

import kha.FastFloat;
import kha.math.FastVector2;

class Constants {
	public static inline final TILE_WIDTH:FastFloat = 48;
	public static inline final TILE_HEIGHT:FastFloat = 24;

	public static inline final TILE_WIDTH_HALF:FastFloat = 24;
	public static inline final TILE_HEIGHT_HALF:FastFloat = 12;

	public static inline final TILE_WIDTH_HALF_RCP:FastFloat = 1.0 / TILE_WIDTH_HALF;
	public static inline final TILE_HEIGHT_HALF_RCP:FastFloat = 1.0 / TILE_HEIGHT_HALF;
}

@:forward
abstract GridPos(FastVector2) from FastVector2 to FastVector2 {
	public inline function new(x:FastFloat = 0, y:FastFloat = 0) {
		this = new FastVector2(x, y);
	}

	@:to public static inline function toWorldPos(grid:GridPos):WorldPos {
		final x = (grid.x - grid.y) * (Constants.TILE_WIDTH_HALF);
		final y = (grid.x + grid.y) * (Constants.TILE_HEIGHT_HALF);
		return new WorldPos(x, y);
	}
}

@:forward
abstract WorldPos(FastVector2) from FastVector2 to FastVector2 {
	public inline function new(x:FastFloat = 0, y:FastFloat = 0) {
		this = new FastVector2(x, y);
	}

	@:to public static inline function toGridPos(world:WorldPos):GridPos {
		final x = (world.x * Constants.TILE_WIDTH_HALF_RCP + world.y * Constants.TILE_HEIGHT_HALF_RCP) * 0.5;
		final y = (world.y * Constants.TILE_HEIGHT_HALF_RCP - world.x * Constants.TILE_WIDTH_HALF_RCP) * 0.5;
		return new GridPos(x, y);
	}
}
