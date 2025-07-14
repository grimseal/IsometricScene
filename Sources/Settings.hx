package;

import kha.math.Vector2i;
import kha.FastFloat;

class Settings {
	public static final appName:String = "IsometricScene";
	public static final simulationFramerate:FastFloat = 1 / 60;
	public static final screenWidth:Int = 800;
	public static final screenHeight:Int = 600;
	public static final cameraZoom:FastFloat = 1.0;

	public static inline final CELL_WIDTH:Int = 48;
	public static inline final CELL_HEIGHT:Int = 24;
	public static final CELL_SIZE:Vector2i = new Vector2i(CELL_WIDTH, CELL_HEIGHT);
}
