package layout;

import flash.display.DisplayObject;
import flash.geom.Rectangle;
import layout.area.Area;

#if haxeui
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
#end

/**
 * Represents an object with position, width, and height. The following
 * are supported, and will be converted automatically:
	 * Area (from this library)
	 * DisplayObject (Flash/OpenFL)
	 * Rectangle (Flash/OpenFL)
	 * DisplayObject (HaxeUI)
	 * Custom classes that extend ResizableImpl
 */
@:forward(x, y, width, height, baseWidth, baseHeight, left, right, top, bottom)
abstract Resizable(ResizableImpl) from ResizableImpl {
	public var scaleX(get, set):Float;
	public var scaleY(get, set):Float;
	
	public var centerX(get, never):Float;
	public var centerY(get, never):Float;
	
	/**
	 * Useful for when you need something invisible to mark a position.
	 */
	public function new() {
		return cast new RectangleResizable(new Rectangle(0, 0, 1, 1));
	}
	
	@:from private static inline function fromDisplayObject(displayObject:DisplayObject):Resizable {
		return cast new DisplayObjectResizable(displayObject);
	}
	#if haxeui
	@:from private static inline function fromHaxeUIObject(haxeUIObject:IDisplayObject):Resizable {
		return cast new HaxeUIObjectResizable(haxeUIObject);
	}
	#end
	@:from private static inline function fromArea(area:Area):Resizable {
		return cast new AreaResizable(area);
	}
	@:from private static inline function fromRectangle(rectangle:Rectangle):Resizable {
		return cast new RectangleResizable(rectangle);
	}
	
	private inline function get_scaleX():Float {
		return this.width / this.baseWidth;
	}
	private inline function set_scaleX(value:Float):Float {
		this.width = value * this.baseWidth;
		return value;
	}
	private inline function get_scaleY():Float {
		return this.width / this.baseWidth;
	}
	private inline function set_scaleY(value:Float):Float {
		this.width = value * this.baseWidth;
		return value;
	}
	
	private inline function get_centerX():Float {
		return this.x + this.width / 2;
	}
	private inline function get_centerY():Float {
		return this.y + this.height / 2;
	}
	
	public inline function castDisplayObject<T:DisplayObject>(type:Class<T>):T {
		if(Std.is(this, DisplayObjectResizable)) {
			var displayResizable:DisplayObjectResizable = cast this;
			if(Std.is(displayResizable.displayObject, type)) {
				return cast displayResizable.displayObject;
			} else {
				throw type + " required!";
			}
		} else {
			throw type + " required!";
		}
	}
}

class ResizableImpl {
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var width(get, set):Float;
	public var height(get, set):Float;
	public var baseWidth:Float;
	public var baseHeight:Float;
	
	/**
	 * The setter adjusts the x coordinate and width so that the left
	 * edge moves and the right edge stays the same.
	 */
	public var left(get, set):Float;
	/**
	 * The setter adjusts the width so that the right edge moves and the
	 * left edge stays the same.
	 */
	public var right(get, set):Float;
	/**
	 * The setter adjusts the y coordinate and height so that the top
	 * moves and the bottom stays the same.
	 */
	public var top(get, set):Float;
	/**
	 * The setter adjusts the height so that the bottom moves and the top
	 * stays the same.
	 */
	public var bottom(get, set):Float;
	
	private function new() {
		baseWidth = width;
		baseHeight = height;
	}
	
	private function get_x():Float { return 0; }
	private function set_x(value:Float):Float { return 0; }
	private function get_y():Float { return 0; }
	private function set_y(value:Float):Float { return 0; }
	private function get_width():Float { return 0; }
	private function set_width(value:Float):Float { return 0; }
	private function get_height():Float { return 0; }
	private function set_height(value:Float):Float { return 0; }
	
	private inline function get_left():Float {
		return x;
	}
	private function set_left(value:Float):Float {
		width -= value - x;
		return x = value;
	}
	private inline function get_right():Float {
		return x + width;
	}
	private function set_right(value:Float):Float {
		width = value - x;
		return value;
	}
	private inline function get_top():Float {
		return y;
	}
	private function set_top(value:Float):Float {
		height -= value - y;
		return y = value;
	}
	private inline function get_bottom():Float { return y + height; }
	private function set_bottom(value:Float):Float {
		height = value - y;
		return value;
	}
}

private class DisplayObjectResizable extends ResizableImpl {
	public var displayObject:DisplayObject;
	
	public function new(displayObject:DisplayObject) {
		this.displayObject = displayObject;
		super();
		
		baseWidth = displayObject.width / displayObject.scaleX;
		baseHeight = displayObject.height / displayObject.scaleY;
	}
	
	private override function get_x():Float {
		return displayObject.x;
	}
	private override function set_x(value:Float):Float {
		return displayObject.x = value;
	}
	
	private override function get_y():Float {
		return displayObject.y;
	}
	private override function set_y(value:Float):Float {
		return displayObject.y = value;
	}
	
	private override function get_width():Float {
		#if html5
			return displayObject.scaleX * baseWidth;
		#else
			return displayObject.width;
		#end
	}
	private override function set_width(value:Float):Float {
		#if html5
			displayObject.scaleX = value / baseWidth;
			return value;
		#else
			return displayObject.width = value;
		#end
	}
	
	private override function get_height():Float {
		#if html5
			return displayObject.scaleY * baseHeight;
		#else
			return displayObject.height;
		#end
	}
	private override function set_height(value:Float):Float {
		#if html5
			displayObject.scaleY = value / baseHeight;
			return value;
		#else
			return displayObject.height = value;
		#end
	}
}

#if haxeui
private class HaxeUIObjectResizable extends ResizableImpl {
	public var displayObject:IDisplayObject;
	
	public function new(displayObject:IDisplayObject) {
		this.displayObject = displayObject;
		super();
	}
	
	private override function get_x():Float {
		return displayObject.x;
	}
	private override function set_x(value:Float):Float {
		return displayObject.x = value;
	}
	
	private override function get_y():Float {
		return displayObject.y;
	}
	private override function set_y(value:Float):Float {
		return displayObject.y = value;
	}
	
	private override function get_width():Float {
		return displayObject.width;
	}
	private override function set_width(value:Float):Float {
		return displayObject.width = value;
	}
	
	private override function get_height():Float {
		return displayObject.height;
	}
	private override function set_height(value:Float):Float {
		return displayObject.height = value;
	}
}
#end

private class AreaResizable extends ResizableImpl {
	private var area:Area;
	
	public function new(area:Area) {
		this.area = area;
		super();
	}
	
	private override function get_x():Float {
		return area.x;
	}
	private override function set_x(value:Float):Float {
		return area.x = value;
	}
	
	private override function get_y():Float {
		return area.y;
	}
	private override function set_y(value:Float):Float {
		return area.y = value;
	}
	
	private override function get_width():Float {
		return area.width;
	}
	private override function set_width(value:Float):Float {
		return area.width = value;
	}
	
	private override function get_height():Float {
		return area.height;
	}
	private override function set_height(value:Float):Float {
		return area.height = value;
	}
	
	private override function set_left(value:Float):Float {
		return area.left = value;
	}
	private override function set_right(value:Float):Float {
		return area.right = value;
	}
	private override function set_top(value:Float):Float {
		return area.top = value;
	}
	private override function set_bottom(value:Float):Float {
		return area.bottom = value;
	}
}

private class RectangleResizable extends ResizableImpl {
	private var rectangle:Rectangle;
	
	public function new(rectangle:Rectangle) {
		this.rectangle = rectangle;
		super();
	}
	
	private override function get_x():Float {
		return rectangle.x;
	}
	private override function set_x(value:Float):Float {
		return rectangle.x = value;
	}
	
	private override function get_y():Float {
		return rectangle.y;
	}
	private override function set_y(value:Float):Float {
		return rectangle.y = value;
	}
	
	private override function get_width():Float {
		return rectangle.width;
	}
	private override function set_width(value:Float):Float {
		return rectangle.width = value;
	}
	
	private override function get_height():Float {
		return rectangle.height;
	}
	private override function set_height(value:Float):Float {
		return rectangle.height = value;
	}
}
