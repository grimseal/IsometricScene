package obj;

import obj.IsoAABB;
import haxe.ds.Map;

class IsoSortManager {
	var nodes:Array<IsoAABB> = [];
	var graph:Map<IsoAABB, Array<IsoAABB>> = new Map();
	var indegree:Map<IsoAABB, Int> = new Map();
	var sorted:Array<IsoAABB> = [];
	var dirty:Bool = true;

	public var isDirty(get, never):Bool;

	public function new() {}

	inline function get_isDirty():Bool
		return dirty;

	public function addObject(obj:IsoAABB):Void {
		if (graph.exists(obj))
			return;
		graph.set(obj, []);
		indegree.set(obj, 0);

		for (other in nodes) {
			if (isBehind(obj, other)) {
				graph.get(obj).push(other);
				indegree.set(other, indegree.get(other) + 1);
			} else if (isBehind(other, obj)) {
				graph.get(other).push(obj);
				indegree.set(obj, indegree.get(obj) + 1);
			}
		}

		nodes.push(obj);
		dirty = true;
	}

	public function removeObject(obj:IsoAABB):Void {
		if (!graph.exists(obj))
			return;

		for (source in graph.keys()) {
			if (source == obj)
				continue;
			var edges = graph.get(source);
			if (edges.remove(obj)) {
				indegree.set(obj, indegree.get(obj) - 1);
			}
		}

		for (target in graph.get(obj)) {
			indegree.set(target, indegree.get(target) - 1);
		}

		graph.remove(obj);
		indegree.remove(obj);
		nodes.remove(obj);
	}

	public function getSorted():Array<IsoAABB> {
		if (!dirty)
			return sorted;

		var result:Array<IsoAABB> = [];
		var tempIndegree = new Map<IsoAABB, Int>();
		for (n in nodes)
			tempIndegree.set(n, indegree.get(n));

		var queue:Array<IsoAABB> = [];
		for (n in nodes)
			if (tempIndegree.get(n) == 0)
				queue.push(n);

		while (queue.length > 0) {
			var current = queue.shift();
			result.push(current);
			for (next in graph.get(current)) {
				tempIndegree.set(next, tempIndegree.get(next) - 1);
				if (tempIndegree.get(next) == 0)
					queue.push(next);
			}
		}

		sorted = result;
		dirty = false;
		return sorted;
	}

	inline function isBehind(a:IsoAABB, b:IsoAABB):Bool
		return a.xMin < b.xMax && a.yMin < b.yMax;
}
