package core;

abstract HashSet<T>(haxe.ds.IntMap<T>) {
	public inline function new()
		this = new haxe.ds.IntMap<T>();

	public inline function add(value:T):Void
		this.set(getHash(value), value);

	public inline function remove(value:T):Bool
		return this.remove(getHash(value));

	public inline function contains(value:T):Bool
		return this.exists(getHash(value));

	public inline function clear():Void
		this.clear();

	public function toArray():Array<T> {
		var result = [];
		for (key in this.keys()) {
			result.push(this.get(key));
		}
		return result;
	}

	inline function getHash(v:T):Int
		return cast v;
}
