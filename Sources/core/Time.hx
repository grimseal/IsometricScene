package core;

import kha.System;

class Time {
	private static var _time:Float = 0.0;
	private static var _unscaledTime:Float = 0.0;

	private static var _deltaTime:Float = 0.0;
	private static var _unscaledDeltaTime:Float = 0.0;

	private static var _fixedDeltaTime:Float = 0.0;
	private static var _unscaledFixedDeltaTime:Float = 0.0;

	private static var _lastRenderTime:Float = 0.0;
	private static var _lastFixedTime:Float = 0.0;

	public static var timeScale:Float = 1.0;

	public static var time(get, never):Float;

	inline static function get_time():Float
		return _time;

	public static var unscaledTime(get, never):Float;

	inline static function get_unscaledTime():Float
		return _unscaledTime;

	public static var deltaTime(get, never):Float;

	inline static function get_deltaTime():Float
		return _deltaTime;

	public static var unscaledDeltaTime(get, never):Float;

	inline static function get_unscaledDeltaTime():Float
		return _unscaledDeltaTime;

	public static var fixedDeltaTime(get, never):Float;

	inline static function get_fixedDeltaTime():Float
		return _fixedDeltaTime;

	public static var unscaledFixedDeltaTime(get, never):Float;

	inline static function get_unscaledFixedDeltaTime():Float
		return _unscaledFixedDeltaTime;

	//

	public static function init():Void {
		var now = System.time;
		_lastRenderTime = now;
		_lastFixedTime = now;
	}

	//

	public static function fixedStep():Void {
		var now = System.time;
		_unscaledFixedDeltaTime = now - _lastFixedTime;
		_fixedDeltaTime = _unscaledFixedDeltaTime * timeScale;
		_lastFixedTime = now;
	}

	//

	public static function update():Void {
		var now = System.time;
		_unscaledDeltaTime = now - _lastRenderTime;
		_deltaTime = _unscaledDeltaTime * timeScale;
		_unscaledTime += _unscaledDeltaTime;
		_time += _deltaTime;
		_lastRenderTime = now;
	}
}
