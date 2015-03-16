package layout.item;

import layout.area.IRectangle;
import layout.Direction;
import layout.item.LayoutItem.LayoutMask;
import layout.Scale;
import flash.display.DisplayObject;

using layout.Direction.DirectionUtils;

/**
 * Each Position value represents position along only one axis. You will
 * have to use two Position values if you want to fully specify an object's
 * position. It is strongly recommended that you apply size before position.
 */
class Position implements LayoutItem {
	public static function edge(edge:Direction):Position {
		switch(edge) {
			case LEFT:
				return new Position(true);
			case RIGHT:
				return new Percent(true, 1);
			case UP:
				return new Position(false);
			case DOWN:
				return new Percent(false, 1);
		}
	}
	
	public static inline function centerX():Position {
		return new Percent(true, 0.5);
	}
	public static inline function centerY():Position {
		return new Percent(false, 0.5);
	}
	public static inline function horizontalPercent(percent:Float):Position {
		return new Percent(true, percent);
	}
	public static inline function verticalPercent(percent:Float):Position {
		return new Percent(false, percent);
	}
	
	/**
	 * @param	offset A percent of the target object's width.
	 */
	public static inline function offsetFromCenterX(offset:Float):Position {
		return new PercentWithOffset(true, 0.5, offset);
	}
	/**
	 * @param	offset A percent of the target object's height.
	 */
	public static inline function offsetFromCenterY(offset:Float):Position {
		return new PercentWithOffset(false, 0.5, offset);
	}
	/**
	 * @param	offset A percent of the target object's width.
	 */
	public static inline function offsetFromHorizontalPercent(percent:Float, offset:Float):Position {
		return new PercentWithOffset(true, percent, offset);
	}
	/**
	 * @param	offset A percent of the target object's height.
	 */
	public static inline function offsetFromVerticalPercent(percent:Float, offset:Float):Position {
		return new PercentWithOffset(false, percent, offset);
	}
	/**
	 * @param	offset A percent of the target object's width or height.
	 */
	public static inline function offsetFromEdge(edge:Direction, offset:Float):Position {
		return new PercentWithOffset(edge.isHorizontal(), edge.isTopLeft() ? 0 : 1, offset);
	}
	
	/**
	 * Places the target next to the area, in the given direction.
	 * Affects only one axis. The margin will be multiplied by the
	 * current scale.
	 */
	public static inline function adjacent(margin:Float, direction:Direction):Position {
		return new Outside(margin, direction);
	}
	/**
	 * Places the target next to the area, in the given direction.
	 * Affects only one axis. The margin will NOT be multiplied by the
	 * current scale.
	 */
	public static inline function adjacentExact(margin:Float, direction:Direction):Position {
		return new OutsideExact(margin, direction);
	}
	
	/**
	 * Places the target inside the area, next to the given edge.
	 * The margin will be multiplied by the current scale.
	 */
	public static inline function inside(margin:Float, direction:Direction):Position {
		return new Inside(margin, direction);
	}
	/**
	 * Places the target inside the area, next to the given edge.
	 * The margin will NOT be multiplied by the current scale.
	 */
	public static inline function insideExact(margin:Float, direction:Direction):Position {
		return new InsideExact(margin, direction);
	}
	
	private var horizontal:Bool;
	public var mask:Int;
	
	public function new(horizontal:Bool) {
		this.horizontal = horizontal;
		mask = horizontal ? LayoutMask.AFFECTS_X : LayoutMask.AFFECTS_Y;
	}
	
	public function apply(target:DisplayObject, area:IRectangle, scale:Scale):Void {
		if(horizontal) {
			target.x = getCoordinate(area.x, area.width, target.width, scale.x);
		} else {
			target.y = getCoordinate(area.y, area.height, target.height, scale.y);
		}
	}
	
	private function getCoordinate(areaMin:Float, areaSize:Float, targetSize:Float, scale:Float):Float {
		return areaMin;
	}
}

/**
 * Define a location within the area as a percent of the distance from
 * the top/left to the bottom/right. For instance, new Percent(0.25)
 * will place the display object towards the top or the left (depending
 * on which access this is used for).
 * 
 * It's possible to define percentages beyond [0, 1], but this is
 * discouraged, as the object may not be placed where you might expect.
 */
private class Percent extends Position {
	private var percent:Float;
	
	public function new(horizontal:Bool, percent:Float) {
		super(horizontal);
		this.percent = percent;
	}
	
	private override function getCoordinate(areaMin:Float, areaSize:Float, targetSize:Float, scale:Float):Float {
		return percent * (areaSize - targetSize) + areaMin;
	}
}

/**
 * Like Percent, but adds the given offset afterwards. The offset is
 * multiplied by the size of the object.
 * 
 * For instance, new PercentWithOffset(true, 0.5, -0.5) will align the
 * object's right edge with the center of the screen. The offset (-0.5)
 * subtracts half the object's width from the object's x coordinate.
 */
private class PercentWithOffset extends Position {
	private var percent:Float;
	private var offset:Float;
	
	public function new(horizontal:Bool, percent:Float, offset:Float) {
		super(horizontal);
		this.percent = percent;
		this.offset = offset;
	}
	
	private override function getCoordinate(areaMin:Float, areaSize:Float, targetSize:Float, scale:Float):Float {
		return percent * (areaSize - targetSize) + offset * targetSize + areaMin;
	}
}

/**
 * Places the target within the area, a short distance from the given edge.
 */
private class Inside extends Position {
	private var margin:Float;
	private var direction:Direction;
	
	public function new(margin:Float, direction:Direction) {
		super(direction.isHorizontal());
		this.margin = margin;
		this.direction = direction;
	}
	
	private override function getCoordinate(areaMin:Float, areaSize:Float, targetSize:Float, scale:Float):Float {
		if(direction.isTopLeft()) {
			return areaMin + margin * scale;
		} else {
			return areaMin + areaSize - margin * scale - targetSize;
		}
	}
}

/**
 * Places the target within the area, a short distance from the given edge.
 * This distance is NOT multiplied by the current scale.
 */
private class InsideExact extends Position {
	private var margin:Float;
	private var direction:Direction;
	
	public function new(margin:Float, direction:Direction) {
		super(direction.isHorizontal());
		this.margin = margin;
		this.direction = direction;
	}
	
	private override function getCoordinate(areaMin:Float, areaSize:Float, targetSize:Float, scale:Float):Float {
		if(direction.isTopLeft()) {
			return areaMin + margin;
		} else {
			return areaMin + areaSize - margin - targetSize;
		}
	}
}

/**
 * Places the target next to the area, a short distance from the given edge.
 */
private class Outside extends Position {
	private var margin:Float;
	private var direction:Direction;
	
	public function new(margin:Float, direction:Direction) {
		super(direction.isHorizontal());
		this.margin = margin;
		this.direction = direction;
	}
	
	private override function getCoordinate(areaMin:Float, areaSize:Float, targetSize:Float, scale:Float):Float {
		if(direction.isTopLeft()) {
			return areaMin - margin * scale - targetSize;
		} else {
			return areaMin + areaSize + margin * scale;
		}
	}
}

/**
 * Places the target next to the area, a short distance from the given edge.
 * This distance is NOT multiplied by the current scale.
 */
private class OutsideExact extends Position {
	private var margin:Float;
	private var direction:Direction;
	
	public function new(margin:Float, direction:Direction) {
		super(direction.isHorizontal());
		this.margin = margin;
		this.direction = direction;
	}
	
	private override function getCoordinate(areaMin:Float, areaSize:Float, targetSize:Float, scale:Float):Float {
		if(direction.isTopLeft()) {
			return areaMin - margin - targetSize;
		} else {
			return areaMin + areaSize + margin;
		}
	}
}
