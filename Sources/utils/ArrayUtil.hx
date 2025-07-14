package utils;

import kha.arrays.ByteArray;

class ArrayUtil {
	public static function memcpy(src:ByteArray, srcOffset:Int, dest:ByteArray, destOffset:Int, length:Int):Void {
		if (srcOffset < 0 || destOffset < 0 || length < 0) {
			throw 'Negative offset or length in memcpy';
		}
		if (srcOffset + length > src.byteLength) {
			throw 'Source buffer overflow in memcpy';
		}
		if (destOffset + length > dest.byteLength) {
			throw 'Destination buffer overflow in memcpy';
		}

		#if js
		var srcBuf = cast(src.buffer, js.lib.ArrayBuffer);
		var destBuf = cast(dest.buffer, js.lib.ArrayBuffer);
		var srcView = new js.lib.Uint8Array(srcBuf, srcOffset, length);
		var destView = new js.lib.Uint8Array(destBuf);
		destView.set(srcView, destOffset);
		#else
		for (i in 0...length) {
			dest.setUint8(destOffset + i, src.getUint8(srcOffset + i));
		}
		#end
	}
}
