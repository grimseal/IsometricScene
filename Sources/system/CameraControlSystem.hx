package system;

import kha.FastFloat;
import kha.math.FastVector2;
import core.System.ISystem;
import obj.Coords;
import obj.Scene;
import kha.math.Vector2i;
import kha.input.Mouse;

class CameraControlSystem implements ISystem {
	static inline final CAMERA_ZOOM_SPEED:FastFloat = 0.25;

	var cameraOrigin:FastVector2 = new FastVector2();
	var origin:Vector2i = new Vector2i();
	var position:Vector2i = new Vector2i();
	var isDragging:Bool;
	var mouse:Mouse;

	public function new() {}

	public function load() {}

	public function init() {
		mouse = Mouse.get();
		mouse.notify(onMouseDown, onMouseUp, onMouseMove, onMouseWheel);
	}

	public function update() {
		if (!isDragging)
			return;
		final diff = origin.sub(position);
		final zoom = Scene.current.camera.zoom;
		final pos = cameraOrigin.add(new FastVector2(diff.x * zoom, diff.y * zoom));
		final clamped = clampScenePosition(pos);
		Scene.current.camera.position = clamped;
	}

	public function clampScenePosition(world:WorldPos):WorldPos {
		final size = Scene.current.grid.size;
		var pos:GridPos = world.toGridPos();
		if (pos.x < 0)
			pos.x = 0;
		if (pos.x > size.x)
			pos.x = size.x;
		if (pos.y < 0)
			pos.y = 0;
		if (pos.y > size.y)
			pos.y = size.y;
		return pos.toWorldPos();
	}

	function onMouseDown(button:Int, x:Int, y:Int):Void {
		isDragging = true;
		cameraOrigin = Scene.current.camera.position;
		position.x = x;
		position.y = y;
		origin.x = x;
		origin.y = y;
	}

	function onMouseUp(button:Int, x:Int, y:Int):Void {
		isDragging = false;
		position.x = x;
		position.y = y;
	}

	function onMouseMove(x:Int, y:Int, xDelta:Int, yDelta:Int):Void {
		position.x = x;
		position.y = y;
	}

	function onMouseWheel(delta:Int) {
		Scene.current.camera.zoom += CAMERA_ZOOM_SPEED * delta;
	}
}
