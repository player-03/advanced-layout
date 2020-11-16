package com.player03.layout;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
#else
import flash.text.TextField;
import flash.display.DisplayObjectContainer;
import com.player03.layout.item.Edge;
import com.player03.layout.item.LayoutItem.LayoutMask;
import com.player03.layout.item.Position;
import com.player03.layout.item.Size;
import com.player03.layout.item.TextSize;
import com.player03.layout.Resizable;

/**
 * To use this as a static extension, you need to specify what you're using it for:
 * 
 * using layout.LayoutCreator.ForOpenFL; //compatible with DisplayObjects, but not Rectangles
 * using layout.LayoutCreator.ForRectangles; //compatible with OpenFL's Rectangles
 * using layout.LayoutCreator.ForHaxeUI; //compatible with HaxeUI's IDisplayObjects
 * using layout.LayoutCreator.ForFlixel; //compatible with FlxSprites
 * using layout.LayoutCreator.ForHaxePunk; //compatible with HaxePunk's entities
 * 
 * Once you've picked one or more of the above, without any further setup, you can
 * call layout functions as if they were instance methods:
 * 
 * object0.simpleWidth(30);
 * object0.simpleHeight(40);
 * object0.alignBottomRight();
 * 
 * object1.simpleScale();
 * object1.center();
 * 
 * object2.fillWidth();
 * object2.simpleHeight();
 * object2.below(object1);
 * 
 * Remember: set width and height before setting an object's position. Your
 * instructions will be run in order, and position often depends on dimensions.
 * 
 * If you've already positioned your objects, try using the stickTo() functions
 * to make them stay there and scale appropriately. Alternatively, try using
 * preserve() if you want the class to guess which edge(s) each object should
 * stick to.
 * 
 * @author Joseph Cloutier
 */
@:build(com.player03.layout.LayoutCreator.LayoutCreatorBuilder.build())
class LayoutCreator {
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
		check(layout).add(objectToPlace, Position.adjacent(margin, TOP), target);
	}
	/**
	 * Places the object below the target, separated by the given margin.
	 */
	public static inline function below(objectToPlace:Resizable, target:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.adjacent(margin, BOTTOM), target);
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
		layout.add(objectToPlace, Position.adjacent(margin, TOP), target);
		layout.add(objectToPlace, Position.centerX(), target);
	}
	/**
	 * Places the object below the target, centered horizontally, and
	 * separated by the given margin.
	 */
	public static inline function belowCenter(objectToPlace:Resizable, target:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(objectToPlace, Position.adjacent(margin, BOTTOM), target);
		layout.add(objectToPlace, Position.centerX(), target);
	}
	
	/**
	 * Aligns the object with the target along the given edge. For
	 * instance, if you specify BOTTOM, the object's bottom edge will be
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
	 * margin. Compatible with fillAreaRightOf().
	 */
	public static function fillAreaLeftOf(objectToPlace:Resizable, target:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(objectToPlace, Edge.matchOppositeEdges(RIGHT, margin), target);
		
		var fill:Edge = Edge.matchSameEdges(LEFT, margin);
		if(!layout.conflictExists(objectToPlace, fill)) {
			layout.add(objectToPlace, fill);
		}
	}
	
	/**
	 * Places the object right of the target, separated by the given
	 * margin. Compatible with fillAreaLeftOf().
	 */
	public static function fillAreaRightOf(objectToPlace:Resizable, target:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		layout = check(layout);
		var fill:Edge = Edge.matchSameEdges(RIGHT, margin);
		if(!layout.conflictExists(objectToPlace, fill)) {
			layout.add(objectToPlace, fill);
		}
		
		layout.add(objectToPlace, Edge.matchOppositeEdges(LEFT, margin), target);
	}
	
	/**
	 * Places the object above the target, separated by the given margin.
	 * Compatible with fillAreaBelow().
	 */
	public static function fillAreaAbove(objectToPlace:Resizable, target:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(objectToPlace, Edge.matchOppositeEdges(BOTTOM, margin), target);
		
		var fill:Edge = Edge.matchSameEdges(TOP, margin);
		if(!layout.conflictExists(objectToPlace, fill)) {
			layout.add(objectToPlace, fill);
		}
	}
	
	/**
	 * Places the object below the target, separated by the given margin.
	 * Compatible with fillAreaAbove().
	 */
	public static function fillAreaBelow(objectToPlace:Resizable, target:Resizable, ?margin:Float = 0, ?layout:Layout):Void {
		layout = check(layout);
		var fill:Edge = Edge.matchSameEdges(BOTTOM, margin);
		if(!layout.conflictExists(objectToPlace, fill)) {
			layout.add(objectToPlace, fill);
		}
		
		layout.add(objectToPlace, Edge.matchOppositeEdges(TOP, margin), target);
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
		check(layout).add(objectToPlace, Position.inside(y, TOP));
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
	 * Centers the object onscreen.
	 */
	public static inline function center(objectToPlace:Resizable, ?layout:Layout):Void {
		centerX(objectToPlace, layout);
		centerY(objectToPlace, layout);
	}
	
	/**
	 * Aligns the object to the left edge of the screen.
	 */
	public static inline function alignLeft(objectToPlace:Resizable, ?margin:Float, ?layout:Layout):Void {
		check(layout).add(objectToPlace, margin == null ? Position.edge(LEFT) : Position.inside(margin, LEFT));
	}
	/**
	 * Aligns the object to the right edge of the screen.
	 */
	public static inline function alignRight(objectToPlace:Resizable, ?margin:Float, ?layout:Layout):Void {
		check(layout).add(objectToPlace, margin == null ? Position.edge(RIGHT) : Position.inside(margin, RIGHT));
	}
	/**
	 * Aligns the object to the top edge of the screen.
	 */
	public static inline function alignTop(objectToPlace:Resizable, ?margin:Float, ?layout:Layout):Void {
		check(layout).add(objectToPlace, margin == null ? Position.edge(TOP) : Position.inside(margin, TOP));
	}
	/**
	 * Aligns the object to the bottom edge of the screen.
	 */
	public static inline function alignBottom(objectToPlace:Resizable, ?margin:Float, ?layout:Layout):Void {
		check(layout).add(objectToPlace, margin == null ? Position.edge(BOTTOM) : Position.inside(margin, BOTTOM));
	}
	
	/**
	 * Aligns the object to the top-left corner of the screen.
	 */
	public static inline function alignTopLeft(objectToPlace:Resizable, ?margin:Float, ?layout:Layout):Void {
		alignLeft(objectToPlace, margin, layout);
		alignTop(objectToPlace, margin, layout);
	}
	/**
	 * Aligns the object to the top-right corner of the screen.
	 */
	public static inline function alignTopRight(objectToPlace:Resizable, ?margin:Float, ?layout:Layout):Void {
		alignRight(objectToPlace, margin, layout);
		alignTop(objectToPlace, margin, layout);
	}
	/**
	 * Aligns the object to the bottom-left corner of the screen.
	 */
	public static inline function alignBottomLeft(objectToPlace:Resizable, ?margin:Float, ?layout:Layout):Void {
		alignLeft(objectToPlace, margin, layout);
		alignBottom(objectToPlace, margin, layout);
	}
	/**
	 * Aligns the object to the bottom-right corner of the screen.
	 */
	public static inline function alignBottomRight(objectToPlace:Resizable, ?margin:Float, ?layout:Layout):Void {
		alignRight(objectToPlace, margin, layout);
		alignBottom(objectToPlace, margin, layout);
	}
	
	/**
	 * Centers the object along the left edge of the screen.
	 */
	public static inline function alignLeftCenter(objectToPlace:Resizable, ?margin:Float, ?layout:Layout):Void {
		alignLeft(objectToPlace, margin, layout);
		centerY(objectToPlace, layout);
	}
	/**
	 * Centers the object along the right edge of the screen.
	 */
	public static inline function alignRightCenter(objectToPlace:Resizable, ?margin:Float, ?layout:Layout):Void {
		alignRight(objectToPlace, margin, layout);
		centerY(objectToPlace, layout);
	}
	/**
	 * Centers the object along the top of the screen.
	 */
	public static inline function alignTopCenter(objectToPlace:Resizable, ?margin:Float, ?layout:Layout):Void {
		centerX(objectToPlace, layout);
		alignTop(objectToPlace, margin, layout);
	}
	/**
	 * Centers the object along the bottom of the screen.
	 */
	public static inline function alignBottomCenter(objectToPlace:Resizable, ?margin:Float, ?layout:Layout):Void {
		centerX(objectToPlace, layout);
		alignBottom(objectToPlace, margin, layout);
	}
	
	
	/**
	 * Sets the object's x coordinate so that it's the given percent of
	 * the way across the stage. 0 is equivalent to alignLeft(), 0.5 is
	 * equivalent to centerX(), and 1 is equivalent to alignRight().
	 * Values below 0 or above 1 may produce unintuitive results.
	 */
	public static inline function horizontalPercent(objectToPlace:Resizable, percent:Float, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.horizontalPercent(percent));
	}
	/**
	 * Sets the object's y coordinate so that it's the given percent of
	 * the way down the stage. 0 is equivalent to alignTop(), 0.5 is
	 * equivalent to centerY(), and 1 is equivalent to alignBottom().
	 * Values below 0 or above 1 may produce unintuitive results.
	 */
	public static inline function verticalPercent(objectToPlace:Resizable, percent:Float, ?layout:Layout):Void {
		check(layout).add(objectToPlace, Position.verticalPercent(percent));
	}
	
	//Simple scaling options
	//======================
	
	/**
	 * The object will be scaled based on the current scale values. This
	 * uses the object's initial dimensions, not the object's dimensions at the
	 * time of calling.
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
		check(layout).add(objectToScale, Size.simpleWidth(width));
	}
	/**
	 * Sets the object's height to this value times Scale.scaleY. If the
	 * height isn't specified, the object's initial height will be used.
	 */
	public static inline function simpleHeight(objectToScale:Resizable, ?height:Float, ?layout:Layout):Void {
		check(layout).add(objectToScale, Size.simpleHeight(height));
	}
	
	/**
	 * Like simpleScale(), but the object won't go below its initial
	 * width and height.
	 */
	public static inline function rigidSimpleScale(objectToScale:Resizable, ?layout:Layout):Void {
		rigidSimpleWidth(objectToScale, layout);
		rigidSimpleHeight(objectToScale, layout);
	}
	/**
	 * Like simpleWidth(), but the object won't go below its initial
	 * width.
	 */
	public static inline function rigidSimpleWidth(objectToScale:Resizable, ?width:Float, ?layout:Layout):Void {
		if(width == null) {
			width = objectToScale.baseWidth;
		}
		check(layout).add(objectToScale, Size.clampedSimpleWidth(width, width));
	}
	/**
	 * Like simpleHeight(), but the object won't go below its initial
	 * height.
	 */
	public static inline function rigidSimpleHeight(objectToScale:Resizable, ?height:Float, ?layout:Layout):Void {
		if(height == null) {
			height = objectToScale.baseHeight;
		}
		check(layout).add(objectToScale, Size.clampedSimpleHeight(height, height));
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
	 * Sets the object's width to fill the stage horizontally, minus the
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
	 * Scales the object to take up this much of the stage horizontally.
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
	
	/**
	 * Like fillPercentWidth(), but the object won't go below its
	 * initial height.
	 */
	public static inline function rigidFillPercentWidth(objectToScale:Resizable, percent:Float, ?layout:Layout):Void {
		check(layout).add(objectToScale, Size.clampedRelativeWidth(percent, objectToScale.baseWidth));
	}
	/**
	 * Like fillPercentHeight(), but the object won't go below its
	 * initial height.
	 */
	public static inline function rigidFillPercentHeight(objectToScale:Resizable, percent:Float, ?layout:Layout):Void {
		check(layout).add(objectToScale, Size.clampedRelativeHeight(percent, objectToScale.baseHeight));
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
	
	//Position objects near an edge, and scale them normally
	//======================================================
	
	public static inline function stickToLeft(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		layout = check(layout);
		if(rigid) {
			layout.add(object, Size.rigidSimpleWidth(object.baseWidth));
			layout.add(object, Position.rigidInside(object.x / layout.scale.x, LEFT));
		} else {
			layout.add(object, Size.simpleWidth());
			layout.add(object, Position.inside(object.x / layout.scale.x, LEFT));
		}
	}
	public static inline function stickToRight(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		layout = check(layout);
		if(rigid) {
			layout.add(object, Size.rigidSimpleWidth(object.baseWidth));
			layout.add(object, Position.rigidInside((layout.bounds.height - object.right) / layout.scale.x, RIGHT));
		} else {
			layout.add(object, Size.simpleWidth());
			layout.add(object, Position.inside((layout.bounds.width - object.right) / layout.scale.x, RIGHT));
		}
	}
	public static inline function stickToTop(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		layout = check(layout);
		if(rigid) {
			layout.add(object, Size.rigidSimpleHeight(object.baseHeight));
			layout.add(object, Position.rigidInside(object.y / layout.scale.y, TOP));
		} else {
			layout.add(object, Size.simpleHeight());
			layout.add(object, Position.inside(object.y / layout.scale.y, TOP));
		}
	}
	public static inline function stickToBottom(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		layout = check(layout);
		if(rigid) {
			layout.add(object, Size.rigidSimpleHeight(object.baseHeight));
			layout.add(object, Position.rigidInside((layout.bounds.height - object.bottom) / layout.scale.y, BOTTOM));
		} else {
			layout.add(object, Size.simpleHeight());
			layout.add(object, Position.inside((layout.bounds.height - object.bottom) / layout.scale.y, BOTTOM));
		}
	}
	public static inline function stickToCenterX(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		layout = check(layout);
		if(rigid) {
			layout.add(object, Size.rigidSimpleWidth(object.baseWidth));
		} else {
			layout.add(object, Size.simpleWidth());
		}
		layout.add(object, Position.offsetFromCenterX((object.x + object.width / 2 - layout.bounds.width / 2) / layout.scale.x));
	}
	public static inline function stickToCenterY(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		layout = check(layout);
		if(rigid) {
			layout.add(object, Size.rigidSimpleHeight(object.baseHeight));
		} else {
			layout.add(object, Size.simpleHeight());
		}
		layout.add(object, Position.offsetFromCenterY((object.y + object.height / 2 - layout.bounds.height / 2) / layout.scale.y));
	}
	
	public static inline function stickToTopLeft(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		stickToLeft(object, rigid, layout);
		stickToTop(object, rigid, layout);
	}
	public static inline function stickToTopRight(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		stickToRight(object, rigid, layout);
		stickToTop(object, rigid, layout);
	}
	public static inline function stickToBottomLeft(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		stickToLeft(object, rigid, layout);
		stickToBottom(object, rigid, layout);
	}
	public static inline function stickToBottomRight(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		stickToRight(object, rigid, layout);
		stickToBottom(object, rigid, layout);
	}
	public static inline function stickToLeftCenter(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		stickToLeft(object, rigid, layout);
		stickToCenterY(object, rigid, layout);
	}
	public static inline function stickToRightCenter(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		stickToRight(object, rigid, layout);
		stickToCenterY(object, rigid, layout);
	}
	public static inline function stickToTopCenter(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		stickToCenterX(object, rigid, layout);
		stickToTop(object, rigid, layout);
	}
	public static inline function stickToBottomCenter(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		stickToCenterX(object, rigid, layout);
		stickToBottom(object, rigid, layout);
	}
	public static inline function stickToCenter(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		stickToCenterX(object, rigid, layout);
		stickToCenterY(object, rigid, layout);
	}
	
	//Stretch objects to fill the stage (minus any margins)
	//=====================================================
	
	public static function stickToLeftAndRight(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		layout = check(layout);
		if(rigid) {
			layout.add(object, Size.clampedWidthMinus(layout.scale.baseWidth - object.width, object.baseWidth));
			layout.add(object, Position.rigidInside(object.x, LEFT));
		} else {
			layout.add(object, Size.widthMinus(layout.scale.baseWidth - object.width));
			layout.add(object, Position.inside(object.x, LEFT));
		}
	}
	public static inline function stickToTopAndBottom(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		layout = check(layout);
		if(rigid) {
			layout.add(object, Size.clampedHeightMinus(layout.scale.baseHeight - object.height, object.baseHeight));
			layout.add(object, Position.rigidInside(object.y, TOP));
		} else {
			layout.add(object, Size.heightMinus(layout.scale.baseHeight - object.height));
			layout.add(object, Position.inside(object.y, TOP));
		}
	}
	public static inline function stickToAllSides(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		stickToLeftAndRight(object, rigid, layout);
		stickToTopAndBottom(object, rigid, layout);
	}
	
	//Intelligent (?) positioning
	//===========================
	
	/**
	 * Guess which edges the object should stick to, or if it should stick to
	 * the center, or if it should stretch to fill the stage.
	 */
	public static function preserve(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		layout = check(layout);
		
		if(object.baseWidth > layout.scale.baseWidth / 2) {
			stickToLeftAndRight(object, rigid, layout);
		} else {
			var leftMargin:Float = object.left;
			var rightMargin:Float = layout.scale.baseWidth - object.right;
			var centerDifferenceX:Float = Math.abs(object.centerX - layout.scale.baseWidth / 2);
			
			if(centerDifferenceX < leftMargin && centerDifferenceX < rightMargin) {
				stickToCenterX(object, rigid, layout);
			} else if(leftMargin < rightMargin) {
				stickToLeft(object, rigid, layout);
			} else {
				stickToRight(object, rigid, layout);
			}
		}
		
		if(object.baseHeight > layout.scale.baseHeight / 2) {
			stickToTopAndBottom(object, rigid, layout);
		} else {
			var topMargin:Float = object.top;
			var bottomMargin:Float = layout.scale.baseHeight - object.bottom;
			var centerDifferenceY:Float = Math.abs(object.centerY - layout.scale.baseHeight / 2);
			
			if(centerDifferenceY < topMargin && centerDifferenceY < bottomMargin) {
				stickToCenterY(object, rigid, layout);
			} else if(topMargin < bottomMargin) {
				stickToTop(object, rigid, layout);
			} else {
				stickToBottom(object, rigid, layout);
			}
		}
	}
}

@:autoBuild(com.player03.layout.LayoutCreator.LayoutCreatorBuilder.build())
@:noCompletion class TypedLayoutCreator<T> extends LayoutCreator {
}

class ForAreas extends TypedLayoutCreator<com.player03.layout.area.Area> {
}

class ForRectangles extends TypedLayoutCreator<flash.geom.Rectangle> {
}

class ForOpenFL extends TypedLayoutCreator<flash.display.DisplayObject> {
	/**
	 * Scales the text in the given text field. If no base size is
	 * specified, the default text size will be used. If a minimum text
	 * size is specified, the given value will be used.
	 */
	public static inline function simpleTextSize(textField:TextField, ?baseTextSize:Int, ?minimumTextSize:Int, ?layout:Layout):Void {
		if(baseTextSize == null) {
			baseTextSize = Std.int(textField.defaultTextFormat.size);
		}
		if(minimumTextSize == null) {
			LayoutCreator.check(layout).add(textField, TextSize.simpleTextSize(baseTextSize));
		} else {
			LayoutCreator.check(layout).add(textField, TextSize.textSizeWithMinimum(baseTextSize, minimumTextSize));
		}
	}
	
	/**
	 * Guess how to scale all children of the given object.
	 */
	public static inline function preserveChildren(parent:DisplayObjectContainer, ?rigid:Bool = false, ?layout:Layout):Void {
		for(i in 0...parent.numChildren) {
			LayoutCreator.preserve(parent.getChildAt(i), rigid, layout);
		}
	}
}

#if haxeui
class ForHaxeUI extends TypedLayoutCreator<haxe.ui.toolkit.core.interfaces.IDisplayObject> {
}
#end
#if flixel
class ForFlixel extends TypedLayoutCreator<flixel.FlxSprite> {
}
#end
#if haxepunk
class ForHaxePunk extends TypedLayoutCreator<haxepunk.Entity> {
}
#end
#end

@:noCompletion class LayoutCreatorBuilder {
	#if macro
	private static var layoutCreatorFields:Array<Field>;
	#end
	
	public static macro function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		
		var typeParam:ComplexType;
		switch(Context.getLocalType()) {
			case TInst(t, _):
				if(t.get().name == "LayoutCreator") {
					layoutCreatorFields = fields;
					return fields;
				}
				
				var params:Array<Type> = t.get().superClass.params;
				if(params.length != 1) {
					throw "Subclasses of TypedLayoutCreator must specify one type parameter.";
				}
				
				typeParam = Context.toComplexType(Context.follow(params[0]));
			default:
				throw "LayoutCreatorBuilder called on something other than a subclass of TypedLayoutCreator.";
		}
		
		//Hopefully the superclass will always be processed first, but if not, it's best not to
		//throw an error. That way, the other macros can finish and the next attempt will work.
		if(layoutCreatorFields == null) {
			trace("Macros got executed in the wrong order. Please try again without restarting the language server.");
			return fields;
		}
		
		for(field in layoutCreatorFields) {
			if(field.access.indexOf(APublic) < 0 || field.access.indexOf(AStatic) < 0) {
				continue;
			}
			
			switch(field.kind) {
				case FFun(f):
					if(f.args.length < 2) {
						continue;
					}
					
					var args:Array<FunctionArg> = f.args.copy();
					args[0] = {
						name: args[0].name,
						type: typeParam
					};
					
					var callName:String = field.name;
					var callArgs:Array<Expr> = [for(arg in args) @:pos(field.pos) macro $i{arg.name}];
					
					for(arg in callArgs) {
						arg.pos = field.pos;
					}
					
					var fun:Function = {
						args: args,
						expr: macro com.player03.layout.LayoutCreator.$callName($a{callArgs}),
						ret: f.ret
					};
					fun.expr.pos = field.pos;
					
					fields.push({
						name: field.name,
						kind: FFun(fun),
						access: [APublic, AStatic, AInline],
						
						//Deliberately including references to both field.pos and
						//Context.currentPos() to make it more likely that both are
						//displayed to the user.
						pos: Context.currentPos()
					});
				default:
			}
		}
		
		return fields;
	}
}
