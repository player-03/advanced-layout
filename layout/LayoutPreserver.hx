package layout;

import layout.item.Position;
import layout.item.Size;

/**
 * Use this class if you positioned your objects beforehand, and all you need is
 * to make everything scale. If you still need to position your objects, use
 * LayoutCreator to save a step.
 * 
 * Use this class as a static extension.
 * 
 * Sample usage: consider an object that you've placed at the bottom of the
 * stage. When the stage scales, you want to update the object's y coordinate
 * so that it's at the new bottom. To do this, call stickToBottom().
 * 
 * All "stickTo" functions remember how far the object was from the edge (or
 * center). So if the sample object starts five pixels above the bottom, it will
 * remain about five pixels above the bottom as the stage scales. This
 * five-pixel margin will increase as the stage gets bigger, and it will
 * decrease as the stage gets smaller.
 * 
 * @author Joseph Cloutier
 */
class LayoutPreserver {
	private static inline function check(layout:Layout):Layout {
		if(layout == null) {
			return Layout.currentLayout;
		} else {
			return layout;
		}
	}
	
	public static inline function stickToLeft(object:Resizable, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.simpleWidth());
		layout.add(object, Position.inside(object.x - layout.bounds.x, LEFT));
	}
	public static inline function stickToRight(object:Resizable, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.simpleWidth());
		layout.add(object, Position.inside(layout.scale.baseStageWidth - object.right, RIGHT));
	}
	public static inline function stickToTop(object:Resizable, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.simpleHeight());
		layout.add(object, Position.inside(object.y - layout.bounds.y, TOP));
	}
	public static inline function stickToBottom(object:Resizable, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.simpleHeight());
		layout.add(object, Position.inside(layout.scale.baseStageHeight - object.bottom, BOTTOM));
	}
	public static inline function stickToCenterX(object:Resizable, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.simpleWidth());
		layout.add(object, Position.offsetFromCenterX(object.x - layout.scale.baseStageWidth / 2));
	}
	public static inline function stickToCenterY(object:Resizable, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.simpleHeight());
		layout.add(object, Position.offsetFromCenterY(object.y - layout.scale.baseStageHeight / 2));
	}
	
	public static inline function stickToTopLeft(object:Resizable, ?layout:Layout):Void {
		stickToLeft(object, layout);
		stickToTop(object, layout);
	}
	public static inline function stickToTopRight(object:Resizable, ?layout:Layout):Void {
		stickToRight(object, layout);
		stickToTop(object, layout);
	}
	public static inline function stickToBottomLeft(object:Resizable, ?layout:Layout):Void {
		stickToLeft(object, layout);
		stickToBottom(object, layout);
	}
	public static inline function stickToBottomRight(object:Resizable, ?layout:Layout):Void {
		stickToRight(object, layout);
		stickToBottom(object, layout);
	}
	public static inline function stickToLeftCenter(object:Resizable, ?layout:Layout):Void {
		stickToLeft(object, layout);
		stickToCenterY(object, layout);
	}
	public static inline function stickToRightCenter(object:Resizable, ?layout:Layout):Void {
		stickToRight(object, layout);
		stickToCenterY(object, layout);
	}
	public static inline function stickToTopCenter(object:Resizable, ?layout:Layout):Void {
		stickToCenterX(object, layout);
		stickToTop(object, layout);
	}
	public static inline function stickToBottomCenter(object:Resizable, ?layout:Layout):Void {
		stickToCenterX(object, layout);
		stickToBottom(object, layout);
	}
	public static inline function stickToCenter(object:Resizable, ?layout:Layout):Void {
		stickToCenterX(object, layout);
		stickToCenterY(object, layout);
	}
	
	/**
	 * When the stage scales, the object will stretch to fill the horizontal
	 * space, minus whatever margins it currently has.
	 */
	public static inline function stickToLeftAndRight(object:Resizable, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.widthMinus(layout.scale.baseStageWidth - object.width));
		layout.add(object, Position.inside(object.x - layout.bounds.x, LEFT));
	}
	/**
	 * When the stage scales, the object will stretch to fill the vertical
	 * space, minus whatever margins it currently has.
	 */
	public static inline function stickToTopAndBottom(object:Resizable, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.heightMinus(layout.scale.baseStageHeight - object.height));
		layout.add(object, Position.inside(object.y - layout.bounds.y, TOP));
	}
	/**
	 * When the stage scales, the object will stretch to fill the whole thing,
	 * minus whatever margins it currently has.
	 */
	public static inline function stickToAllSides(object:Resizable, ?layout:Layout):Void {
		stickToLeftAndRight(object, layout);
		stickToTopAndBottom(object, layout);
	}
}
