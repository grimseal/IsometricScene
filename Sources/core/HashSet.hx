package core;

class HashSet<T> {
	var map:haxe.ds.IntMap<T>;

	public function new() {
		map = new haxe.ds.IntMap<T>();
	}

	public function add(value:T):Void {
		map.set(getHash(value), value);
	}

	public function remove(value:T):Void {
		map.remove(getHash(value));
	}

	public function contains(value:T):Bool {
		return map.exists(getHash(value));
	}

	public function toArray():Array<T> {
		var result = [];
		for (key in map.keys()) {
			result.push(map.get(key));
		}
		return result;
	}

	inline function getHash(v:T):Int {
		return cast v;
	}
}
