package com.player03.layout.item;

import com.player03.layout.Scale;
import com.player03.layout.Resizable;

/**
 * @author Joseph Cloutier
 */
interface LayoutItem {
	var mask:LayoutMask;
	function apply(target:Resizable, area:Resizable, scale:Scale):Void;
}

abstract LayoutMask(Int) from Int to Int {
	/**
	 * The bits associated with the default method of masking.
	 */
	private static inline var DEFAULT_BITS:LayoutMask = AFFECTS_X | AFFECTS_Y | AFFECTS_WIDTH | AFFECTS_HEIGHT;
	/**
	 * This layout item conflicts with any other item that updates x.
	 */
	public static inline var AFFECTS_X:LayoutMask = 0x1;
	/**
	 * This layout item conflicts with any other item that updates y.
	 */
	public static inline var AFFECTS_Y:LayoutMask = 0x2;
	/**
	 * This layout item conflicts with any other item that updates width.
	 */
	public static inline var AFFECTS_WIDTH:LayoutMask = 0x4;
	/**
	 * This layout item conflicts with any other item that updates height.
	 */
	public static inline var AFFECTS_HEIGHT:LayoutMask = 0x8;
	
	/**
	 * The bits associated with the "edge" method of masking. If both
	 * masks have any of these bits, the default bits should be ignored.
	 * The Edge class is meant to conflict with both the Position and
	 * Size classes, but not with itself.
	 */
	private static inline var EDGE_BITS:LayoutMask = 0x10 | 0x20 | 0x40 | 0x80;
	/**
	 * This layout item conflicts with any other item that updates x or
	 * width, unless the other item specifically updates the right edge.
	 */
	public static inline var SETS_LEFT_EDGE:LayoutMask = 0x10 | AFFECTS_X | AFFECTS_WIDTH;
	/**
	 * This layout item conflicts with any other item that updates x or
	 * width, unless the other item specifically updates the left edge.
	 */
	public static inline var SETS_RIGHT_EDGE:LayoutMask = 0x20 | AFFECTS_X | AFFECTS_WIDTH;
	/**
	 * This layout item conflicts with any other item that updates y or
	 * height, unless the other item specifically updates the bottom edge.
	 */
	public static inline var SETS_TOP_EDGE:LayoutMask = 0x40 | AFFECTS_Y | AFFECTS_HEIGHT;
	/**
	 * This layout item conflicts with any other item that updates y or
	 * height, unless the other item specifically updates the top edge.
	 */
	public static inline var SETS_BOTTOM_EDGE:LayoutMask = 0x80 | AFFECTS_Y | AFFECTS_HEIGHT;
	
	/**
	 * This layout item changes the text size used by a text field.
	 */
	public static inline var AFFECTS_TEXT_SIZE:LayoutMask = 0x100;
	
	public static inline function hasConflict(maskA:Int, maskB:Int):Bool {
		if(setsEdge(maskA) && setsEdge(maskB)) {
			maskA = maskA & EDGE_BITS;
			maskB = maskB & EDGE_BITS;
		}
		return (maskA & maskB) != 0;
	}
	
	public static inline function setsEdge(mask:Int):Bool {
		return (mask & EDGE_BITS) != 0;
	}
}
