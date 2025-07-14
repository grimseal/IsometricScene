package core;

import kha.math.*;

class Transform {
	public var position:FastVector3;
	public var rotation:FastVector3;
	public var scale:FastVector3;

	public inline function new(?position:FastVector3, ?rotation:FastVector3, ?scale:FastVector3) {
		this.position = position != null ? position : new FastVector3(0, 0, 0);
		this.rotation = rotation != null ? rotation : new FastVector3(0, 0, 0);
		this.scale = scale != null ? scale : new FastVector3(1, 1, 1);
	}

	public inline function localToWorld():FastMatrix4 {
		var T = FastMatrix4.translation(position.x, position.y, position.z);
		var R = FastMatrix4.rotation(rotation.x, rotation.y, rotation.z);
		var S = FastMatrix4.scale(scale.x, scale.y, scale.z);
		return T.multmat(R).multmat(S);
	}

	public inline function worldToLocal():FastMatrix4 {
		return localToWorld().inverse();
	}
}
