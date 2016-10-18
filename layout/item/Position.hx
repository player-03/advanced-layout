package layout.item;

import layout.Direction;
import layout.item.LayoutItem.LayoutMask;
import layout.Resizable;
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
			case TOP:
				return new Position(false);
			case BOTTOM:
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
	 * @param	offset In unscaled pixels.
	 */
	public static inline function offsetFromCenterX(offset:Float):Position {
		return new PercentWithOffset(true, 0.5, offset);
	}
	/**
	 * @param	offset In unscaled pixels.
	 */
	public static inline function offsetFromCenterY(offset:Float):Position {
		return new PercentWithOffset(false, 0.5, offset);
	}
	
	/**
	 * Places the target next to the area, in the given direction.
	 * Affects only one axis.
	 */
	public static inline function adjacent(margin:Float, direction:Direction):Position {
		return new Outside(margin, direction);
	}
	
	/**
	 * Places the target inside the area, next to the given edge.
	 */
	public static inline function inside(margin:Float, direction:Direction):Position {
		return new Inside(margin, direction);
	}
	
	/**
	 * Places the target inside the area, next to the given edge.
	 * The margin won't go below its initial value.
	 */
	public static inline function rigidInside(margin:Float, direction:Direction):Position {
		return new RigidInside(margin, direction);
	}
	
	private var horizontal:Bool;
	public var mask:Int;
	
	public function new(horizontal:Bool) {
		this.horizontal = horizontal;
		mask = horizontal ? LayoutMask.AFFECTS_X : LayoutMask.AFFECTS_Y;
	}
	
	public function apply(target:Resizable, area:Resizable, scale:Scale):Void {
		if(horizontal) {
			var x:Float = getCoordinate(area.x, area.width, target.width, scale.x);
			if(x != target.x) {
				target.x = x;
			}
		} else {
			var y:Float = getCoordinate(area.y, area.height, target.height, scale.y);
			if(y != target.y) {
				target.y = y;
			}
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
 * multiplied by the current scale.
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
		return percent * (areaSize - targetSize) + offset * scale + areaMin;
	}
}

/**
 * Places the target within the area, a short distance from the given
 * edge. The distance is multiplied by the current scale.
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
 * Places the target next to the area, a short distance from the given
 * edge. The distance is multiplied by the current scale.
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
 * Places the target within the area, a short distance from the given
 * edge. The distance is multiplied by the current scale, unless the
 * scale is less than 1, in which case it will be treated as 1.
 */
private class RigidInside extends Inside {
	public function new(margin:Float, direction:Direction) {
		super(margin, direction);
	}
	
	private override function getCoordinate(areaMin:Float, areaSize:Float, targetSize:Float, scale:Float):Float {
		return super.getCoordinate(areaMin, areaSize, targetSize, scale >= 1 ? scale : 1);
	}
}
