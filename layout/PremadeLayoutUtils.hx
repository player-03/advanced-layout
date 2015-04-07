package layout;

import layout.item.LayoutItem;
import layout.item.Position;
import layout.item.Size;
import flash.display.DisplayObject;

/**
 * Functions for converting a premade layout into a scaling layout. This
 * class is designed to be used as a static extension.
 * 
 * The functions in this class are similar to the equivalent functions
 * in LayoutUtils, except these functions look at the object's current
 * position and size to determine how the object should scale.
 * @author Joseph Cloutier
 */
class PremadeLayoutUtils {
	private static inline function check(layout:Layout):Layout {
		if(layout == null) {
			return Layout.currentLayout;
		} else {
			return layout;
		}
	}
	
	/**
	 * When the stage scales, the object will "stick" to the left edge.
	 * If it was 30 pixels from the left edge, it will end up 30 pixels
	 * from the new left edge, times Scale.x.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function alignLeft(object:DisplayObject, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.simpleWidth(object.width));
		layout.add(object, Position.inside(object.x - layout.bounds.x, LEFT));
	}
	/**
	 * When the stage scales, the object will "stick" to the horizontal
	 * center. If it was 30 pixels left of the center, it will end up
	 * 30 pixels left of the new center, times Scale.x.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function centerX(object:DisplayObject, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.simpleWidth(object.width));
		layout.add(object, Position.offsetFromCenterX(object.x - layout.scale.baseStageWidth / 2));
	}
	/**
	 * When the stage scales, the object will "stick" to the right edge.
	 * For instance, if it was 30 pixels from the right edge, it will end
	 * up 30 pixels from the new right edge, times Scale.x.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function alignRight(object:DisplayObject, ?layout:Layout):Void {
		layout = check(layout);
		var width:Float = object.width;
		layout.add(object, Size.simpleWidth(width));
		layout.add(object, Position.inside(layout.scale.baseStageWidth - (object.x + width), RIGHT));
	}
	
	/**
	 * When the stage scales, the object will "stick" to the top. If it
	 * was 30 pixels from the top, it will end up 30 pixels from the new
	 * top, times Scale.y.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function alignTop(object:DisplayObject, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.simpleHeight(object.height));
		layout.add(object, Position.inside(object.y - layout.bounds.y, UP));
	}
	/**
	 * When the stage scales, the object will "stick" to the vertical
	 * center. If it was 30 pixels below the center, it will end up
	 * 30 pixels below the new center, times Scale.y.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function centerY(object:DisplayObject, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.simpleHeight(object.height));
		layout.add(object, Position.offsetFromCenterY(object.y - layout.scale.baseStageHeight / 2));
	}
	/**
	 * When the stage scales, the object will "stick" to the bottom.
	 * For instance, if it was 30 pixels from the bottom, it will end
	 * up 30 pixels from the new bottom, times Scale.y.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function alignBottom(object:DisplayObject, ?layout:Layout):Void {
		layout = check(layout);
		var height:Float = object.height;
		layout.add(object, Size.simpleHeight(height));
		layout.add(object, Position.inside(layout.scale.baseStageHeight - (object.y + height), DOWN));
	}
	
	/**
	 * When the stage scales, the object will stretch to fill the
	 * horizontal space, minus whatever margins it currently has.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function fillWidth(object:DisplayObject, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.widthMinus(layout.scale.baseStageWidth - object.width));
		layout.add(object, Position.inside(object.x - layout.bounds.x, LEFT));
	}
	/**
	 * When the stage scales, the object will stretch to fill the vertical
	 * space, minus whatever margins it currently has.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function fillHeight(object:DisplayObject, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.heightMinus(layout.scale.baseStageHeight - object.height));
		layout.add(object, Position.inside(object.y - layout.bounds.y, UP));
	}
}
