package;

import kha.math.Vector2i;
import kha.FastFloat;
import kha.Color;

class Settings {
	public static final APP_NAME:String = "IsometricScene";
	public static final SIMULAION_FRAMERATE:FastFloat = 1 / 60;

	public static final SCREEN_WIDTH:Int = 800;
	public static final SCREEN_HEIGHT:Int = 600;
	public static final CAMERA_ZOOM:FastFloat = 1.0;

	public static inline final MAX_MOVING_OBJECT_COUNT:Int = 20;
	public static inline final MIN_MOVING_DURATION:FastFloat = 2;
	public static inline final MAX_MOVING_DURATION:FastFloat = 10;

	public static inline final CELL_WIDTH:Int = 48;
	public static inline final CELL_HEIGHT:Int = 24;
	public static inline final CELL_ALTITUDE:Int = 96;
	public static final CELL_SIZE:Vector2i = new Vector2i(CELL_WIDTH, CELL_HEIGHT);

	public static inline final VISIBLE_COLOR:Color = 0xffffffff;
	public static inline final SEMIVISIBLE_COLOR:Color = 0xff77a7ff;
	public static inline final INVISIBLE_COLOR:Color = 0xff7a7a7a;
	public static inline final LOCKED_COLOR:Color = 0xffff8383;
}
