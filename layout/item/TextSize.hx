package layout.item;

import layout.item.LayoutItem.LayoutMask;
import layout.Resizable;
import flash.text.TextField;
import flash.text.TextFormat;

/**
 * Sets the text size of a text field based on the current scale. To
 * resize the text field based on the text size, use TextField.autoSize.
 * 
 * If you pass anything except a TextField object, an error will be thrown.
 */
class TextSize implements LayoutItem {
	public static inline function simpleTextSize(baseSize:Float):TextSize {
		return new TextSize(baseSize);
	}
	
	public static inline function textSizeWithMinimum(baseSize:Float, minimum:Float):TextSize {
		return new TextSizeWithMinimum(baseSize, minimum);
	}
	
	private static var tempFormat:TextFormat;
	
	/**
	 * In most cases this won't matter much, but if you want to use
	 * Scale.x rather than Scale.y, set this to true.
	 */
	public var horizontal:Bool = false;
	public var mask:Int = LayoutMask.AFFECTS_TEXT_SIZE;
	private var baseSize:Float;
	
	private function new(baseSize:Float) {
		this.baseSize = baseSize;
		
		if(tempFormat == null) {
			tempFormat = new TextFormat();
		}
	}
	
	public function apply(target:Resizable, area:Resizable, scale:Scale):Void {
		tempFormat.size = getTextSize(scale);
		
		target.castDisplayObject(TextField).setTextFormat(tempFormat);
	}
	
	private function getTextSize(scale:Scale):Float {
		return baseSize * (horizontal ? scale.x : scale.y);
	}
}

private class TextSizeWithMinimum extends TextSize {
	private var minimum:Float;
	
	private function new(baseSize:Float, minimum:Float) {
		super(baseSize);
		
		this.minimum = minimum;
	}
	
	private override function getTextSize(scale:Scale):Float {
		return Math.max(minimum, super.getTextSize(scale));
	}
}
