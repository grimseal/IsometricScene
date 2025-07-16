package system;

import kha.Color;
import kha.Assets;
import kha.Image;
import kha.math.Vector2;
import kha.FastFloat;
import kha.math.FastVector2;
import core.System.ISystem;
import obj.Coords;
import obj.Scene;
import kha.math.Vector2i;
import kha.input.Mouse;

class ObjectInputSystem implements ISystem {
	static inline final CURSOR_MOVE_THRESHOLD:FastFloat = 2;
	static inline final CURSOR_MOVE_THRESHOLD_SQ:FastFloat = CURSOR_MOVE_THRESHOLD * CURSOR_MOVE_THRESHOLD;

	var isDown:Bool = false;
	var isMoving:Bool = false;
	var isClicked:Bool = false;
	var mouse:Mouse;
	var downPosition:Vector2i = new Vector2i();
	var clickPosition:Vector2i = new Vector2i();
	var tex:Image;

	public function new() {}

	public function load() {}

	public function init() {
		mouse = Mouse.get();
		mouse.notify(onMouseDown, onMouseUp, onMouseMove);
		tex = Assets.images.get("objects");
	}

	public function handleClick(screenPosition:Vector2i) {
		var worldPos = Scene.current.camera.screenToWorld(screenPosition.x, screenPosition.y);
		var obj = Scene.current.raycast(worldPos, tex);
		if (obj == null)
			return;

		Scene.current.removeObj(obj);
	}

	public function update() {
		if (!isClicked)
			return;
		isClicked = false;
		handleClick(clickPosition);
	}

	function onMouseDown(button:Int, x:Int, y:Int):Void {
		if (button != 0)
			return;
		isDown = true;
		isMoving = false;
		isClicked = false;
		downPosition.x = x;
		downPosition.y = y;
	}

	function onMouseUp(button:Int, x:Int, y:Int):Void {
		if (button != 0)
			return;
		if (isDown && !isMoving) {
			clickPosition.x = x;
			clickPosition.y = y;
			isClicked = true;
		}
		isDown = false;
		isMoving = false;
	}

	function onMouseMove(x:Int, y:Int, xDelta:Int, yDelta:Int):Void {
		if (isDown && !isMoving && getLengthSq(downPosition, x, y) >= CURSOR_MOVE_THRESHOLD_SQ)
			isMoving = true;
	}

	function getLengthSq(v:Vector2i, x:Int, y:Int):FastFloat {
		var dx:FastFloat = v.x - x;
		var dy:FastFloat = v.y - y;
		return dx * dx + dy * dy;
	}
}
