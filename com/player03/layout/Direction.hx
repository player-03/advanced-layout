package com.player03.layout;

/**
 * The cardinal directions.
 * @author Joseph Cloutier
 */
enum abstract Direction(Int) {
	var LEFT = 0;
	var RIGHT = 1;
	var TOP = 2;
	var BOTTOM = 3;
	
	/**
	 * @return True if `LEFT` or `RIGHT`, false if `TOP` or `BOTTOM`.
	 */
	public inline function isHorizontal():Bool {
		return (this & 2) == 0;
	}
	
	/**
	 * @return True if `TOP` or `BOTTOM`, false if `LEFT` or `RIGHT`.
	 */
	public inline function isVertical():Bool {
		return (this & 2) == 2;
	}
	
	/**
	 * @return True if `TOP` or `LEFT`, false if `BOTTOM` or `RIGHT`.
	 */
	public inline function isTopLeft():Bool {
		return (this & 1) == 0;
	}
	
	/**
	 * @return True if `BOTTOM` or `RIGHT`, false if `TOP` or `LEFT`.
	 */
	public inline function isBottomRight():Bool {
		return (this & 1) == 1;
	}
}

class DirectionUtils {
}
