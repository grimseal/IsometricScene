package system;

import obj.Cell;
import kha.audio2.ogg.vorbis.data.Setting;
import core.Time;
import kha.FastFloat;
import kha.math.FastVector2;
import utils.Random;
import core.System.ISystem;
import obj.SceneObject;
import obj.Scene;
import obj.Coords.GridPos;
import utils.Math;

using ext.FastVector2Ext;

class MoveSystem implements ISystem {
	static inline final MIN_TRAVEL_DISTANCE:Int = 50;
	static inline final MAX_TRAVEL_DISTANCE:Int = 200;
	static inline final MAX_MOVING_COUNT:Int = Settings.MAX_MOVING_OBJECT_COUNT;
	static inline final MIN_MOVING_DURATION:FastFloat = Settings.MIN_MOVING_DURATION;
	static inline final MAX_MOVING_DURATION:FastFloat = Settings.MAX_MOVING_DURATION;
	static inline final CANDIDATES_UPDATE_INTERVAL:FastFloat = 1.0;

	var movingObjects:Array<Move> = [];
	var movingCounters:Map<Int, Int> = new haxe.ds.Map<Int, Int>();
	var movingCount:Int = 0;
	var mapWidth:Float;
	var mapHeight:Float;
	var random:Random;
	var candidateUpdateTimer:FastFloat = 0.0;
	var cachedCandidates:Array<SceneObject> = [];

	public function new() {}

	public function load() {}

	public function init() {
		random = Random.create();
	}

	public function update() {
		final deltaTime = Time.deltaTime;
		final size = Scene.current.grid.size;
		final width:FastFloat = size.x;
		final height:FastFloat = size.y;
		final candidates = updateCandidatesIfNeeded(deltaTime);
		final range:Int = Std.int(Math.min(MAX_MOVING_COUNT - movingObjects.length, candidates.length));

		for (i in 0...range) {
			var obj = candidates[i];
			movingObjects.push(new Move(obj, obj.gridPosition, getRandomTarget(obj.gridPosition, width, height),
				random.GetFloatIn(MIN_MOVING_DURATION, MAX_MOVING_DURATION)));
			movingCounters[obj.id]++;
		}

		for (obj in movingObjects) {
			obj.updateTime(deltaTime);
			obj.sceneObj.gridPosition = obj.getCurrentPosition();
		}

		movingObjects = movingObjects.filter(o -> o.state != MoveState.Finished);
	}

	inline function updateCandidatesIfNeeded(deltaTime:FastFloat):Array<SceneObject> {
		candidateUpdateTimer += deltaTime;

		if (candidateUpdateTimer >= CANDIDATES_UPDATE_INTERVAL) {
			candidateUpdateTimer = 0;

			final allObjects = Scene.current.pointObjects;
			final grid = Scene.current.grid;
			cachedCandidates = allObjects.filter(a -> grid.getCellByPosition(a.gridPosition).state.has(CellState.Visible));
			cachedCandidates.sort((a, b) -> getMovingCount(a.id) - getMovingCount(b.id));
		}

		return cachedCandidates;
	}

	inline function getRandomTarget(origin:FastVector2, width:FastFloat, height:FastFloat):FastVector2 {
		return random.getCircleVectorIn(MIN_TRAVEL_DISTANCE, MAX_TRAVEL_DISTANCE).add(origin).clampXY(0, width - 1, 0, height - 1);
	}

	inline function getMovingCount(id:Int) {
		if (!movingCounters.exists(id))
			movingCounters[id] = 0;
		return movingCounters[id];
	}
}

class Move {
	public var sceneObj:SceneObject;
	public var origin:GridPos;
	public var target:FastVector2;
	public var duration:FastFloat;
	public var time:FastFloat;
	public var state:MoveState;

	public function new(obj:SceneObject, origin:GridPos, target:FastVector2, duration:FastFloat) {
		this.sceneObj = obj;
		this.origin = origin;
		this.target = target;
		this.duration = duration;
		this.time = 0;
		this.state = MoveState.ToTarget;
	}

	public function getCurrentPosition():FastVector2 {
		var t = time / duration;
		if (t > 1)
			t = 1;
		return (switch (state) {
			case MoveState.ToTarget: origin;
			case MoveState.ToOrigin: target;
			default: origin;
		}).lerp(switch (state) {
			case MoveState.ToTarget: target;
			case MoveState.ToOrigin: origin;
			default: origin;
		}, t);
	}

	public function updateTime(dt:Float) {
		if (state == MoveState.Finished)
			return;

		time += dt;
		if (time >= duration) {
			time = 0;
			state = switch (state) {
				case MoveState.ToTarget: MoveState.ToOrigin;
				case MoveState.ToOrigin: MoveState.Finished;
				default: MoveState.Finished;
			};
		}
	}
}

enum abstract MoveState(Int) {
	public var ToTarget = 0;
	public var ToOrigin = 1;
	public var Finished = 2;
}
