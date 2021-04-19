package com.player03.layout.item;

import com.player03.layout.item.LayoutItem.LayoutMask;
import com.player03.layout.Resizable;
import flash.text.TextField;
import flash.text.TextFormat;

/**
 * Sets the text size of a text field based on the current scale. To
 * resize the text field based on the text size, use TextField.autoSize.
 * 
 * If you pass anything except a TextField object, an error will be thrown.
 */
class TextSize implements LayoutItem {
	public static inline function simpleTextSize(baseSize:Int):TextSize {
		return new TextSize(baseSize);
	}
	
	public static inline function textSizeWithMinimum(baseSize:Int, minimum:Int):TextSize {
		return new TextSizeWithMinimum(baseSize, minimum);
	}
	
	/**
	 * In most cases this won't matter much, but if you want to use
	 * Scale.x rather than Scale.y, set this to true.
	 */
	public var horizontal:Bool = false;
	public var mask:LayoutMask = LayoutMask.AFFECTS_TEXT_SIZE;
	private var baseSize:Int;
	
	private function new(baseSize:Int) {
		this.baseSize = baseSize;
	}
	
	public function apply(target:Resizable, area:Resizable, scale:Scale):Void {
		var textField:TextField = target.castDisplayObject(TextField);
		
		var format:TextFormat = textField.defaultTextFormat;
		format.size = getTextSize(scale);
		
		textField.defaultTextFormat = format;
		
		//When calling setTextFormat(), don't change anything except the size.
		textField.setTextFormat(new TextFormat(null, format.size));
	}
	
	private function getTextSize(scale:Scale):Int {
		return Math.round(baseSize * (horizontal ? scale.x : scale.y));
	}
}

private class TextSizeWithMinimum extends TextSize {
	private var minimum:Int;
	
	public function new(baseSize:Int, minimum:Int) {
		super(baseSize);
		
		this.minimum = minimum;
	}
	
	private override function getTextSize(scale:Scale):Int {
		var result:Int = super.getTextSize(scale);
		if(result < minimum) {
			return minimum;
		} else {
			return result;
		}
	}
}
