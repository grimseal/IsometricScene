package graphics;

import kha.Framebuffer;
import core.Camera;
import obj.SceneObject;

@:structInit
class RenderPassData {
	public var framebuffer:Framebuffer;
	public var camera:Camera;
	public var objects:Array<SceneObject>;

	public function new() {
		objects = new Array<SceneObject>();
	}

	public function clear():Void {
		framebuffer = null;
		camera = null;
		objects.resize(0);
	}
}
