package layout;

import layout.item.LayoutItem;
import layout.item.Position;
import layout.item.Size;
import flash.text.TextField;
import layout.item.TextSize;

/**
 * Functions for converting a premade layout into a scaling layout. This
 * class is designed to be used as a static extension.
 * 
 * The functions in this class are similar to the equivalent functions
 * in LayoutUtils, except these functions look at the object's current
 * position and size to determine how the object should move/scale.
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
	public static inline function alignLeft(object:Resizable, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.simpleWidth());
		layout.add(object, Position.inside(object.x - layout.bounds.x, LEFT));
	}
	/**
	 * When the stage scales, the object will "stick" to the horizontal
	 * center. If it was 30 pixels left of the center, it will end up
	 * 30 pixels left of the new center, times Scale.x.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function centerX(object:Resizable, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.simpleWidth());
		layout.add(object, Position.offsetFromCenterX(object.x - layout.scale.baseStageWidth / 2));
	}
	/**
	 * When the stage scales, the object will "stick" to the right edge.
	 * For instance, if it was 30 pixels from the right edge, it will end
	 * up 30 pixels from the new right edge, times Scale.x.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function alignRight(object:Resizable, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.simpleWidth());
		layout.add(object, Position.inside(layout.scale.baseStageWidth - object.right, RIGHT));
	}
	
	/**
	 * When the stage scales, the object will "stick" to the top. If it
	 * was 30 pixels from the top, it will end up 30 pixels from the new
	 * top, times Scale.y.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function alignTop(object:Resizable, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.simpleHeight());
		layout.add(object, Position.inside(object.y - layout.bounds.y, TOP));
	}
	/**
	 * When the stage scales, the object will "stick" to the vertical
	 * center. If it was 30 pixels below the center, it will end up
	 * 30 pixels below the new center, times Scale.y.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function centerY(object:Resizable, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.simpleHeight());
		layout.add(object, Position.offsetFromCenterY(object.y - layout.scale.baseStageHeight / 2));
	}
	/**
	 * When the stage scales, the object will "stick" to the bottom.
	 * For instance, if it was 30 pixels from the bottom, it will end
	 * up 30 pixels from the new bottom, times Scale.y.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function alignBottom(object:Resizable, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.simpleHeight());
		layout.add(object, Position.inside(layout.scale.baseStageHeight - object.bottom, BOTTOM));
	}
	
	/**
	 * When the stage scales, the object will "stick" to the top left.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function alignTopLeft(object:Resizable, ?layout:Layout):Void {
		alignLeft(object, layout);
		alignTop(object, layout);
	}
	/**
	 * When the stage scales, the object will "stick" to the top right.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function alignTopRight(object:Resizable, ?layout:Layout):Void {
		alignRight(object, layout);
		alignTop(object, layout);
	}
	/**
	 * When the stage scales, the object will "stick" to the bottom left.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function alignBottomLeft(object:Resizable, ?layout:Layout):Void {
		alignLeft(object, layout);
		alignBottom(object, layout);
	}
	/**
	 * When the stage scales, the object will "stick" to the bottom right.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function alignBottomRight(object:Resizable, ?layout:Layout):Void {
		alignRight(object, layout);
		alignBottom(object, layout);
	}
	/**
	 * When the stage scales, the object will "stick" to the center of
	 * the left edge.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function alignLeftCenter(object:Resizable, ?layout:Layout):Void {
		alignLeft(object, layout);
		centerY(object, layout);
	}
	/**
	 * When the stage scales, the object will "stick" to the center of
	 * the right edge.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function alignRightCenter(object:Resizable, ?layout:Layout):Void {
		alignRight(object, layout);
		centerY(object, layout);
	}
	/**
	 * When the stage scales, the object will "stick" to the center of
	 * the top edge.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function alignTopCenter(object:Resizable, ?layout:Layout):Void {
		centerX(object, layout);
		alignTop(object, layout);
	}
	/**
	 * When the stage scales, the object will "stick" to the center of
	 * the bottom edge.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function alignBottomCenter(object:Resizable, ?layout:Layout):Void {
		centerX(object, layout);
		alignBottom(object, layout);
	}
	
	
	/**
	 * When the stage scales, the object will stretch to fill the
	 * horizontal space, minus whatever margins it currently has.
	 * 
	 * Requires the object to have been positioned beforehand.
	 */
	public static inline function fillWidth(object:Resizable, ?layout:Layout):Void {
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
	public static inline function fillHeight(object:Resizable, ?layout:Layout):Void {
		layout = check(layout);
		layout.add(object, Size.heightMinus(layout.scale.baseStageHeight - object.height));
		layout.add(object, Position.inside(object.y - layout.bounds.y, TOP));
	}
	
	/**
	 * When the stage scales, the text will scale proportionately. If a
	 * minimum is specified, the text size will not go below that value.
	 * 
	 * Uses textField.defaultTextFormat.size as the base value.
	 */
	public static function simpleTextSize(textField:TextField, ?minimumTextSize:Int, ?layout:Layout):Void {
		if(minimumTextSize == null) {
			check(layout).add(textField, TextSize.simpleTextSize(getDefaultTextSize(textField)));
		} else {
			check(layout).add(textField, TextSize.textSizeWithMinimum(getDefaultTextSize(textField), minimumTextSize));
		}
	}
	
	private static inline function getDefaultTextSize(textField:TextField):Int {
		#if flash
			return Std.int(textField.defaultTextFormat.size);
		#else
			return textField.defaultTextFormat.size
		#end
	}
}
