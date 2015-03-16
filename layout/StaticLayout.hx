package layout;

import layout.item.LayoutItem;
import layout.item.Position;
import layout.item.Size;
import flash.display.DisplayObject;

/**
 * Functions for controlling how an existing layout will scale. If you
 * haven't already arranged your display objects onscreen, or if you want
 * more intelligent behavior, see DynamicLayout.
 * @author Joseph Cloutier
 */
class StaticLayout {
	private static inline function check(layout:Layout):Layout {
		if(layout == null) {
			return Layout.defaultLayout;
		} else {
			return layout;
		}
	}
	
	/**
	 * When the stage scales, the object will "stick" to the left edge.
	 * In other words, its x coordinate will not change (relative to the
	 * layout bounds, at least).
	 */
	public static inline function stickToLeft(object:DisplayObject, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Position.offsetFromEdge(LEFT, (object.x - layout.bounds.x) / object.width));
	}
	/**
	 * When the stage scales, the object will "stick" to the horizontal
	 * center. If it was 30 pixels left of the center, it will end up
	 * 30 pixels left of the new center.
	 */
	public static inline function stickToCenterX(object:DisplayObject, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Position.offsetFromCenterX((object.x - layout.bounds.centerX) / object.width));
	}
	/**
	 * When the stage scales, the object will "stick" to the right edge.
	 * For instance, if it was 30 pixels from the right edge, it will end
	 * up 30 pixels from the new right edge.
	 */
	public static inline function stickToRight(object:DisplayObject, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Position.offsetFromEdge(RIGHT, (layout.bounds.right - (object.x + object.width)) / object.width));
	}
	
	/**
	 * When the stage scales, the object will "stick" to the top. In
	 * other words, its y coordinate will not change (relative to the
	 * layout bounds, at least).
	 */
	public static inline function stickToTop(object:DisplayObject, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Position.offsetFromEdge(UP, (object.y - layout.bounds.y) / object.height));
	}
	/**
	 * When the stage scales, the object will "stick" to the vertical
	 * center. If it was 30 pixels below the center, it will end up
	 * 30 pixels below the new center.
	 */
	public static inline function stickToCenterY(object:DisplayObject, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Position.offsetFromCenterY((object.y - layout.bounds.centerY) / object.height));
	}
	/**
	 * When the stage scales, the object will "stick" to the bottom.
	 * For instance, if it was 30 pixels from the bottom, it will end
	 * up 30 pixels from the new bottom.
	 */
	public static inline function stickToBottom(object:DisplayObject, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Position.offsetFromEdge(DOWN, (layout.bounds.bottom - (object.y + object.height)) / object.height));
	}
	
	/**
	 * When the stage scales, the object will stretch to fill the
	 * horizontal space. The original margins will be maintained, however.
	 */
	public static inline function stretchX(object:DisplayObject, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.widthMinusExact(layout.bounds.width - object.width));
		layout.add(object, Position.insideExact(object.x - layout.bounds.x, LEFT));
	}
	/**
	 * When the stage scales, the object will stretch to fill the vertical
	 * space. The original margins will be maintained, however.
	 */
	public static inline function stretchY(object:DisplayObject, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.heightMinusExact(layout.bounds.height - object.height));
		layout.add(object, Position.insideExact(object.y - layout.bounds.y, UP));
	}
}
