package com.player03.layout;

import flash.display.DisplayObject;
import flash.geom.Rectangle;
import com.player03.layout.area.Area;

#if haxeui
import haxe.ui.toolkit.core.interfaces.IDisplayObject;
#end
#if flixel
import flixel.FlxSprite;
#end
#if haxepunk
import haxepunk.Entity;
#end

/**
 * Represents an object with position, width, and height. The following
 * are supported, and will be converted automatically:
	 * Area (from this library)
	 * DisplayObject (Flash/OpenFL)
	 * Rectangle (Flash/OpenFL)
	 * DisplayObject (HaxeUI)
	 * FlxSprite (Flixel)
	 * Entity (HaxePunk)
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
		this = cast new RectangleResizable(new Rectangle(0, 0, 1, 1));
	}
	
	@:from private static inline function fromDisplayObject(displayObject:DisplayObject):Resizable {
		return cast new DisplayObjectResizable(displayObject);
	}
	#if haxeui
	@:from private static inline function fromHaxeUIObject(haxeUIObject:IDisplayObject):Resizable {
		return cast new HaxeUIObjectResizable(haxeUIObject);
	}
	#end
	#if flixel
	@:from private static inline function fromFlxSprite(flxSprite:FlxSprite):Resizable {
		return cast new FlxSpriteResizable(flxSprite);
	}
	#end
	#if haxepunk
	@:from private static inline function fromHaxePunkEntity(entity:Entity):Resizable {
		return cast new HaxePunkEntityResizable(entity);
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
		return this.height / this.baseHeight;
	}
	private inline function set_scaleY(value:Float):Float {
		this.height = value * this.baseHeight;
		return value;
	}
	
	private inline function get_centerX():Float {
		return this.x + this.width / 2;
	}
	private inline function get_centerY():Float {
		return this.y + this.height / 2;
	}
	
	public inline function castDisplayObject<T:DisplayObject>(type:Class<T>):T {
		if(Std.isOfType(this, DisplayObjectResizable)) {
			var displayResizable:DisplayObjectResizable = cast this;
			if(Std.isOfType(displayResizable.displayObject, type)) {
				return cast displayResizable.displayObject;
			} else {
				throw type + " required!";
			}
		} else {
			throw type + " required!";
		}
	}
	
	public inline function equals(other:Resizable):Bool {
		return this.sourceObject == other.asImpl().sourceObject;
	}
	
	private inline function asImpl():ResizableImpl {
		return this;
	}
}

class ResizableImpl {
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var width(get, set):Float;
	public var height(get, set):Float;
	public var baseWidth:Float;
	public var baseHeight:Float;
	
	public var sourceObject(get, never):Dynamic;
	
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
	
	private function get_sourceObject():Dynamic {
		throw "get_sourceObject() must be overridden!";
		return null;
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
	
	private override function get_sourceObject():Dynamic {
		return displayObject;
	}
}

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
	
	private override function get_sourceObject():Dynamic {
		return area;
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
	
	private override function get_sourceObject():Dynamic {
		return rectangle;
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
	
	private override function get_sourceObject():Dynamic {
		return displayObject;
	}
}
#end

#if flixel
private class FlxSpriteResizable extends ResizableImpl {
	public var flxSprite:FlxSprite;
	
	public function new(flxSprite:FlxSprite) {
		this.flxSprite = flxSprite;
		super();
	}
	
	private override function get_x():Float {
		return flxSprite.x;
	}
	private override function set_x(value:Float):Float {
		return flxSprite.x = value;
	}
	
	private override function get_y():Float {
		return flxSprite.y;
	}
	private override function set_y(value:Float):Float {
		return flxSprite.y = value;
	}
	
	private override function get_width():Float {
		return flxSprite.width;
	}
	private override function set_width(value:Float):Float {
		//setGraphicSize()
		flxSprite.scale.x = value / flxSprite.frameWidth;
		
		//updateHitbox()
		flxSprite.width = value;
		flxSprite.offset.x = (value - flxSprite.frameWidth) * -0.5;
		flxSprite.origin.x = flxSprite.frameWidth * 0.5;
		
		return value;
	}
	
	private override function get_height():Float {
		return flxSprite.height;
	}
	private override function set_height(value:Float):Float {
		//setGraphicSize()
		flxSprite.scale.y = value / flxSprite.frameHeight;
		
		//updateHitbox()
		flxSprite.height = value;
		flxSprite.offset.y = (value - flxSprite.frameHeight) * -0.5;
		flxSprite.origin.y = flxSprite.frameHeight * 0.5;
		
		return value;
	}
	
	private override function get_sourceObject():Dynamic {
		return flxSprite;
	}
}
#end

#if haxepunk
private class HaxePunkEntityResizable extends ResizableImpl {
	public var entity:Entity;
	
	public function new(entity:Entity) {
		this.entity = entity;
		super();
	}
	
	private override function get_x():Float {
		return entity.localX;
	}
	private override function set_x(value:Float):Float {
		return entity.localX = value;
	}
	
	private override function get_y():Float {
		return entity.localY;
	}
	private override function set_y(value:Float):Float {
		return entity.localY = value;
	}
	
	private override function get_width():Float {
		return entity.width;
	}
	private override function set_width(value:Float):Float {
		return entity.width = Math.round(value);
	}
	
	private override function get_height():Float {
		return entity.height;
	}
	private override function set_height(value:Float):Float {
		return entity.height = Math.round(value);
	}
	
	private override function get_sourceObject():Dynamic {
		return entity;
	}
}
#end
