package layout;

import layout.item.Edge;
import layout.item.LayoutItem;
import layout.item.Position;
import layout.item.Size;
import layout.Resizable;

/**
 * Functions for setting up your layout. This class is designed to be
 * used as a static extension.
 * 
 * If you are familiar with the original Layout library, you may prefer
 * to use PremadeLayoutUtils.
 * @author Joseph Cloutier
 */
class LayoutUtils {
	private static inline function check(layout:Layout):Layout {
		if(layout == null) {
			return Layout.currentLayout;
		} else {
			return layout;
		}
	}
	
	//Place objects relative to one another
	//=====================================
	
	/**
	 * Places the object left of the target, separated by the given margin.
	*/
	public static inline function leftOf(objectToPlace:Resizable, target:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.adjacent(margin, LEFT), target);
	}
	/**
	 * Places the object right of the target, separated by the given margin.
	 */
	public static inline function rightOf(objectToPlace:Resizable, target:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.adjacent(margin, RIGHT), target);
	}
	/**
	 * Places the object above the target, separated by the given margin.
	 */
	public static inline function above(objectToPlace:Resizable, target:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.adjacent(margin, UP), target);
	}
	/**
	 * Places the object below the target, separated by the given margin.
	 */
	public static inline function below(objectToPlace:Resizable, target:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.adjacent(margin, DOWN), target);
	}
	
	/**
	 * Places the object left of the target, centered vertically, and
	 * separated by the given margin.
	 */
	public static inline function leftOfCenter(objectToPlace:Resizable, target:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(objectToPlace, Position.adjacent(margin, LEFT), target);
		layout.add(objectToPlace, Position.centerY(), target);
	}
	/**
	 * Places the object right of the target, centered vertically, and
	 * separated by the given margin.
	 */
	public static inline function rightOfCenter(objectToPlace:Resizable, target:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(objectToPlace, Position.adjacent(margin, RIGHT), target);
		layout.add(objectToPlace, Position.centerY(), target);
	}
	/**
	 * Places the object above the target, centered horizontally, and
	 * separated by the given margin.
	 */
	public static inline function aboveCenter(objectToPlace:Resizable, target:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(objectToPlace, Position.adjacent(margin, UP), target);
		layout.add(objectToPlace, Position.centerX(), target);
	}
	/**
	 * Places the object below the target, centered horizontally, and
	 * separated by the given margin.
	 */
	public static inline function belowCenter(objectToPlace:Resizable, target:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(objectToPlace, Position.adjacent(margin, DOWN), target);
		layout.add(objectToPlace, Position.centerX(), target);
	}
	
	/**
	 * Aligns the object with the target along the given edge. For
	 * instance, if you specify DOWN, the object's bottom edge will be
	 * aligned with the target's bottom edge.
	 */
	public static inline function alignWith(objectToPlace:Resizable, target:Resizable, direction:Direction, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.edge(direction), target);
	}
	/**
	 * Centers the object horizontally on the target.
	 */
	public static inline function centerXOn(objectToPlace:Resizable, target:Resizable, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.centerX(), target);
	}
	/**
	 * Centers the object vertically on the target.
	 */
	public static inline function centerYOn(objectToPlace:Resizable, target:Resizable, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.centerY(), target);
	}
	
	//Set objects' edges relative to other objects
	//============================================
	
	/**
	 * Places the object left of the target, separated by the given
	 * margin. Only the object's right edge will move; its left edge will
	 * stay the same.
	 */
	public static inline function leftOfWithResizing(objectToPlace:Resizable, target:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Edge.matchOppositeEdges(RIGHT, margin), target);
	}
	/**
	 * Places the object right of the target, separated by the given
	 * margin. Only the object's left edge will move; its right edge will
	 * stay the same.
	 */
	public static inline function rightOfWithResizing(objectToPlace:Resizable, target:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Edge.matchOppositeEdges(LEFT, margin), target);
	}
	/**
	 * Places the object above the target, separated by the given margin.
	 * Only the object's bottom edge will move; its top edge will stay
	 * the same.
	 */
	public static inline function aboveWithResizing(objectToPlace:Resizable, target:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Edge.matchOppositeEdges(DOWN, margin), target);
	}
	/**
	 * Places the object below the target, separated by the given margin.
	 * Only the object's top edge will move; its bottom edge will stay
	 * the same.
	 */
	public static inline function belowWithResizing(objectToPlace:Resizable, target:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Edge.matchOppositeEdges(UP, margin), target);
	}
	
	//Place objects onstage
	//=====================
	
	/**
	 * Sets the object's x coordinate to this value times Scale.scaleX.
	 */
	public static inline function simpleX(objectToPlace:Resizable, x:Float, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.inside(x, LEFT));
	}
	/**
	 * Sets the object's y coordinate to this value times Scale.scaleY.
	 */
	public static inline function simpleY(objectToPlace:Resizable, y:Float, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.inside(y, UP));
	}
	
	/**
	 * Centers the object horizontally onscreen.
	 */
	public static inline function centerX(objectToPlace:Resizable, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.centerX());
	}
	/**
	 * Centers the object vertically onscreen.
	 */
	public static inline function centerY(objectToPlace:Resizable, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.centerY());
	}
	
	/**
	 * Aligns the object to the left edge of the screen.
	 */
	public static inline function alignLeft(objectToPlace:Resizable, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.edge(LEFT));
	}
	/**
	 * Aligns the object to the right edge of the screen.
	 */
	public static inline function alignRight(objectToPlace:Resizable, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.edge(RIGHT));
	}
	/**
	 * Aligns the object to the top edge of the screen.
	 */
	public static inline function alignTop(objectToPlace:Resizable, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.edge(UP));
	}
	/**
	 * Aligns the object to the bottom edge of the screen.
	 */
	public static inline function alignBottom(objectToPlace:Resizable, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.edge(DOWN));
	}
	
	//Simple scaling options
	//======================
	
	/**
	 * The object will be scaled based on the current scale values. This
	 * assumes that the object is already at a reasonable default size.
	 */
	public static inline function simpleScale(objectToScale:Resizable, ?layout:Layout):Void {
		simpleWidth(objectToScale, layout);
		simpleHeight(objectToScale, layout);
	}
	/**
	 * Sets the object's width to this value times Scale.scaleX. If the
	 * width isn't specified, the object's initial width will be used.
	 */
	public static inline function simpleWidth(objectToScale:Resizable, ?width:Float, ?layout:Layout):Void {
		if(width != null) {
			objectToScale.baseWidth = width;
		}
		check(layout).add(objectToScale, Size.simpleWidth());
	}
	/**
	 * Sets the object's height to this value times Scale.scaleY. If the
	 * height isn't specified, the object's initial height will be used.
	 */
	public static inline function simpleHeight(objectToScale:Resizable, ?height:Float, ?layout:Layout):Void {
		if(height != null) {
			objectToScale.baseHeight = height;
		}
		check(layout).add(objectToScale, Size.simpleHeight());
	}
	
	//Scale objects relative to one another
	//=====================================
	
	/**
	 * Sets the object's width to match the target's width, minus the
	 * given margin times two. Call centerXOn() after this to ensure that
	 * the same margin appears on both sides of the object.
	 */
	public static inline function matchWidth(objectToScale:Resizable, target:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		check(layout).add(objectToScale, Size.widthMinus(margin * 2), target);
	}
	/**
	 * Sets the object's height to match the target's height, minus the
	 * given margin times two. Call centerYOn() after this to ensure that
	 * the same margin appears both above and below the object.
	 */
	public static inline function matchHeight(objectToScale:Resizable, target:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		check(layout).add(objectToScale, Size.heightMinus(margin * 2), target);
	}
	
	//Scale objects relative to the stage
	//===================================
	
	/**
	 * Sets the object's width to fill the stage horizintally, minus the
	 * given margin times two. Call centerX() after this to ensure that
	 * the same margin appears on both sides of the object.
	 */
	public static inline function fillWidth(objectToScale:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		check(layout).add(objectToScale, Size.widthMinus(margin * 2));
	}
	/**
	 * Sets the object's height to fill the stage vertically, minus the
	 * given margin times two. Call centerY() after this to ensure that
	 * the same margin appears both above and below the object.
	 */
	public static inline function fillHeight(objectToScale:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		check(layout).add(objectToScale, Size.heightMinus(margin * 2));
	}
	
	/**
	 * Scales the object to take up this much of the stage horizintally.
	 * Caution: despite the name, "percent" should be a value between 0
	 * and 1.
	 */
	public static inline function fillPercentWidth(objectToScale:Resizable, percent:Float, ?layout:Layout):Void {
		check(layout).add(objectToScale, Size.relativeWidth(percent));
	}
	/**
	 * Scales the object to take up this much of the stage vertically.
	 * Caution: despite the name, "percent" should be a value between 0
	 * and 1.
	 */
	public static inline function fillPercentHeight(objectToScale:Resizable, percent:Float, ?layout:Layout):Void {
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
	public static function maintainAspectRatio(objectToScale:Resizable, ?layout:Layout):Void {
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
