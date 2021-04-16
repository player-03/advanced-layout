package com.player03.layout.item;

import com.player03.layout.Direction;
import com.player03.layout.item.LayoutItem.LayoutMask;
import com.player03.layout.Resizable;
import com.player03.layout.Scale;
import flash.display.DisplayObject;

/**
 * The Edge class moves one of an object's edges at a time. This causes
 * it to modify an object's position AND size.
 */
class Edge implements LayoutItem {
	/**
	 * Makes the given edge of the target match the opposite edge of the
	 * area. For instance, if you pass LEFT, then the left edge of the
	 * target will match the right edge of the area.
	 */
	public static function matchOppositeEdges(edge:Direction, ?margin:Float = 0):Edge {
		//The class names have to be the opposite of the edge parameter,
		//because the parameter refers to the target, and the class names
		//refer to the area.
		if(edge.isTopLeft()) {
			return new OutsideRightOrBottom(edge.isHorizontal(), margin);
		} else {
			return new OutsideLeftOrTop(edge.isHorizontal(), margin);
		}
	}
	
	/**
	 * Makes the given edge of the target match the same edge of the area.
	 * For instance, if you pass LEFT, then the left edge of the target
	 * will match the left edge of the area.
	 * 
	 * Calling this for all four directions would make the target exactly
	 * match the area. (Of course, there are more efficient ways to do
	 * that...)
	 */
	public static function matchSameEdges(edge:Direction, ?margin:Float):Edge {
		if(edge.isTopLeft()) {
			return new InsideLeftOrTop(edge.isHorizontal(), margin);
		} else {
			return new InsideRightOrBottom(edge.isHorizontal(), margin);
		}
	}
	
	private var direction:Direction;
	private var horizontal:Bool;
	public var mask:Int;
	
	public function new(direction:Direction) {
		this.direction = direction;
		horizontal = direction.isHorizontal();
		switch(direction) {
			case LEFT:
				mask = LayoutMask.SETS_LEFT_EDGE;
			case RIGHT:
				mask = LayoutMask.SETS_RIGHT_EDGE;
			case TOP:
				mask = LayoutMask.SETS_TOP_EDGE;
			case BOTTOM:
				mask = LayoutMask.SETS_BOTTOM_EDGE;
		}
	}
	
	public function apply(target:Resizable, area:Resizable, scale:Scale):Void {
		var targetEdge:Float = switch(direction) {
				case LEFT:
					target.left;
				case RIGHT:
					target.right;
				case TOP:
					target.top;
				case BOTTOM:
					target.bottom;
			};
		var adjustment:Float = getEdge(
				horizontal ? area.x : area.y,
				horizontal ? area.width : area.height,
				targetEdge,
				horizontal ? scale.x : scale.y)
			- targetEdge;
		
		if(adjustment != 0) {
			switch(direction) {
				case LEFT:
					target.left += adjustment;
				case RIGHT:
					target.right += adjustment;
				case TOP:
					target.top += adjustment;
				case BOTTOM:
					target.bottom += adjustment;
			}
		}
	}
	
	/**
	 * @return The new value for targetEdge.
	 */
	private function getEdge(areaMin:Float, areaSize:Float, targetEdge:Float, scale:Float):Float {
		return targetEdge;
	}
}

/**
 * Sets the right or bottom edge of the target based on the left or top
 * edge of the area.
 */
private class OutsideLeftOrTop extends Edge {
	private var margin:Float;
	
	public function new(horizontal:Bool, ?margin:Float = 0) {
		super(horizontal ? RIGHT : BOTTOM);
		
		this.margin = margin;
	}
	
	private override function getEdge(areaMin:Float, areaSize:Float, targetEdge:Float, scale:Float):Float {
		return areaMin - margin * scale;
	}
}
/**
 * Sets the left or top edge of the target based on the right or bottom
 * edge of the area.
 */
private class OutsideRightOrBottom extends Edge {
	private var margin:Float;
	
	public function new(horizontal:Bool, ?margin:Float = 0) {
		super(horizontal ? LEFT : TOP);
		
		this.margin = margin;
	}
	
	private override function getEdge(areaMin:Float, areaSize:Float, targetEdge:Float, scale:Float):Float {
		return areaMin + areaSize + margin * scale;
	}
}

/**
 * Sets the left or top edge of the target based on the same edge of the
 * area.
 */
private class InsideLeftOrTop extends Edge {
	private var margin:Float;
	
	public function new(horizontal:Bool, ?margin:Float = 0) {
		super(horizontal ? LEFT : TOP);
		
		this.margin = margin;
	}
	
	private override function getEdge(areaMin:Float, areaSize:Float, targetEdge:Float, scale:Float):Float {
		return areaMin + margin * scale;
	}
}
/**
 * Sets the right or bottom edge of the target based on the same edge of
 * the area.
 */
private class InsideRightOrBottom extends Edge {
	private var margin:Float;
	
	public function new(horizontal:Bool, ?margin:Float = 0) {
		super(horizontal ? RIGHT : BOTTOM);
		
		this.margin = margin;
	}
	
	private override function getEdge(areaMin:Float, areaSize:Float, targetEdge:Float, scale:Float):Float {
		return areaMin + areaSize - margin * scale;
	}
}
