package layout;

import layout.item.LayoutItem.LayoutMask;
import layout.item.Position;
import layout.item.Size;
import flash.display.DisplayObject;

/**
 * Functions for creating a layout from scratch. If you've already
 * arranged everything onscreen and want to keep them in place as the
 * stage is resized, see StaticLayout instead.
 * @author Joseph Cloutier
 */
class DynamicLayout {
	private static inline function check(layout:Layout):Layout {
		if(layout == null) {
			return Layout.defaultLayout;
		} else {
			return layout;
		}
	}
	
	//Place objects relative to one another
	//=====================================
	
	/**
	 * Places the object left of the target, separated by the given margin.
	*/
	public static inline function leftOf(objectToPlace:DisplayObject, target:DisplayObject, ?margin:Float = 0, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.adjacent(margin, LEFT), target);
	}
	/**
	 * Places the object right of the target, separated by the given margin.
	 */
	public static inline function rightOf(objectToPlace:DisplayObject, target:DisplayObject, ?margin:Float = 0, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.adjacent(margin, RIGHT), target);
	}
	/**
	 * Places the object above the target, separated by the given margin.
	 */
	public static inline function above(objectToPlace:DisplayObject, target:DisplayObject, ?margin:Float = 0, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.adjacent(margin, UP), target);
	}
	/**
	 * Places the object below the target, separated by the given margin.
	 */
	public static inline function below(objectToPlace:DisplayObject, target:DisplayObject, ?margin:Float = 0, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.adjacent(margin, DOWN), target);
	}
	
	/**
	 * Places the object left of the target, centered vertically, and
	 * separated by the given margin.
	 */
	public static inline function leftOfCenter(objectToPlace:DisplayObject, target:DisplayObject, ?margin:Float = 0, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(objectToPlace, Position.adjacent(margin, LEFT), target);
		layout.add(objectToPlace, Position.centerY(), target);
	}
	/**
	 * Places the object right of the target, centered vertically, and
	 * separated by the given margin.
	 */
	public static inline function rightOfCenter(objectToPlace:DisplayObject, target:DisplayObject, ?margin:Float = 0, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(objectToPlace, Position.adjacent(margin, RIGHT), target);
		layout.add(objectToPlace, Position.centerY(), target);
	}
	/**
	 * Places the object above the target, centered horizontally, and
	 * separated by the given margin.
	 */
	public static inline function aboveCenter(objectToPlace:DisplayObject, target:DisplayObject, ?margin:Float = 0, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(objectToPlace, Position.adjacent(margin, UP), target);
		layout.add(objectToPlace, Position.centerX(), target);
	}
	/**
	 * Places the object below the target, centered horizontally, and
	 * separated by the given margin.
	 */
	public static inline function belowCenter(objectToPlace:DisplayObject, target:DisplayObject, ?margin:Float = 0, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(objectToPlace, Position.adjacent(margin, DOWN), target);
		layout.add(objectToPlace, Position.centerX(), target);
	}
	
	/**
	 * Aligns the object with the target along the given edge. For
	 * instance, if you specify DOWN, the object's bottom edge will be
	 * aligned with the target's bottom edge.
	 */
	public static inline function alignWith(objectToPlace:DisplayObject, target:DisplayObject, direction:Direction, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.edge(direction), target);
	}
	/**
	 * Centers the object horizontally on the target.
	 */
	public static inline function centerXOn(objectToPlace:DisplayObject, target:DisplayObject, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.centerX(), target);
	}
	/**
	 * Centers the object vertically on the target.
	 */
	public static inline function centerYOn(objectToPlace:DisplayObject, target:DisplayObject, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.centerY(), target);
	}
	
	//Place objects onstage
	//=====================
	
	/**
	 * Sets the object's x coordinate to this value times Scale.scaleX.
	 */
	public static inline function setX(objectToPlace:DisplayObject, x:Float, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.inside(x, LEFT));
	}
	/**
	 * Sets the object's y coordinate to this value times Scale.scaleY.
	 */
	public static inline function setY(objectToPlace:DisplayObject, y:Float, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.inside(y, UP));
	}
	
	/**
	 * Centers the object horizontally onscreen.
	 */
	public static inline function centerX(objectToPlace:DisplayObject, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.centerX());
	}
	/**
	 * Centers the object vertically onscreen.
	 */
	public static inline function centerY(objectToPlace:DisplayObject, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.centerY());
	}
	
	/**
	 * Aligns the object to the left edge of the screen.
	 */
	public static inline function alignLeft(objectToPlace:DisplayObject, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.edge(LEFT));
	}
	/**
	 * Aligns the object to the right edge of the screen.
	 */
	public static inline function alignRight(objectToPlace:DisplayObject, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.edge(RIGHT));
	}
	/**
	 * Aligns the object to the top edge of the screen.
	 */
	public static inline function alignTop(objectToPlace:DisplayObject, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.edge(UP));
	}
	/**
	 * Aligns the object to the bottom edge of the screen.
	 */
	public static inline function alignBottom(objectToPlace:DisplayObject, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.edge(DOWN));
	}
	
	//Scale objects relative to one another
	//=====================================
	
	/**
	 * Sets the object's width to match the target's width, minus the
	 * given margin times two. Call centerXOn() after this to ensure that
	 * the same margin appears on both sides of the object.
	 */
	public static inline function matchWidth(objectToScale:DisplayObject, target:DisplayObject, ?margin:Float = 0, ?layout:Layout):Void {
		check(layout).add(objectToScale, Size.widthMinus(margin * 2), target);
	}
	/**
	 * Sets the object's height to match the target's height, minus the
	 * given margin times two. Call centerYOn() after this to ensure that
	 * the same margin appears both above and below the object.
	 */
	public static inline function matchHeight(objectToScale:DisplayObject, target:DisplayObject, ?margin:Float = 0, ?layout:Layout):Void {
		check(layout).add(objectToScale, Size.heightMinus(margin * 2), target);
	}
	
	//Scale objects relative to the stage
	//===================================
	
	/**
	 * Sets the object's width to this value times Scale.scaleX.
	 */
	public static inline function setWidth(objectToScale:DisplayObject, width:Float, ?layout:Layout):Void {
		check(layout).add(objectToScale, Size.simpleWidth(width));
	}
	/**
	 * Sets the object's height to this value times Scale.scaleY.
	 */
	public static inline function setHeight(objectToScale:DisplayObject, height:Float, ?layout:Layout):Void {
		check(layout).add(objectToScale, Size.simpleHeight(height));
	}
	
	/**
	 * Sets the object's width to fill the stage horizintally, minus the
	 * given margin times two. Call centerX() after this to ensure that
	 * the same margin appears on both sides of the object.
	 */
	public static inline function fillWidth(objectToScale:DisplayObject, ?margin:Float = 0, ?layout:Layout):Void {
		check(layout).add(objectToScale, Size.widthMinus(margin * 2));
	}
	/**
	 * Sets the object's height to fill the stage vertically, minus the
	 * given margin times two. Call centerY() after this to ensure that
	 * the same margin appears both above and below the object.
	 */
	public static inline function fillHeight(objectToScale:DisplayObject, ?margin:Float = 0, ?layout:Layout):Void {
		check(layout).add(objectToScale, Size.heightMinus(margin * 2));
	}
	
	/**
	 * Scales the object to take up this much of the stage horizintally.
	 * Caution: despite the name, "percent" should be a value between 0
	 * and 1.
	 */
	public static inline function fillPercentWidth(objectToScale:DisplayObject, percent:Float, ?layout:Layout):Void {
		check(layout).add(objectToScale, Size.relativeWidth(percent));
	}
	/**
	 * Scales the object to take up this much of the stage vertically.
	 * Caution: despite the name, "percent" should be a value between 0
	 * and 1.
	 */
	public static inline function fillPercentHeight(objectToScale:DisplayObject, percent:Float, ?layout:Layout):Void {
		check(layout).add(objectToScale, Size.relativeHeight(percent));
	}
	
	//Miscellaneous
	//=============
	
	/**
	 * If one dimension is being scaled and the other isn't, this will
	 * scale the other one to maintain the aspect ratio. If both
	 * dimensions are already defined, this function will do nothing.
	 * 
	 * If neither are defined, this will add an item for both, and you
	 * can replace one of the items later.
	 */
	public static function maintainAspectRatio(objectToScale:DisplayObject, ?layout:Layout):Void {
		layout = check(layout);
		
		var mask:Int = layout.getMask(objectToScale);
		var width:Bool = (mask & LayoutMask.AFFECTS_WIDTH) != 0;
		var height:Bool = (mask & LayoutMask.AFFECTS_HEIGHT) != 0;
		
		if(!width) {
			layout.add(objectToScale, Size.maintainAspectRatio(true));
		}
		if(!height) {
			layout.add(objectToScale, Size.maintainAspectRatio(false));
		}
	}
}
