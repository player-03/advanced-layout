package layout.area;

import flash.events.Event;
import flash.events.EventDispatcher;

/**
 * A rectangular region, to place objects within. Note: area boundaries
 * will not always be strictly enforced.
 * 
 * When the area changes for any reason, it will dispatch a CHANGE event.
 * @author Joseph Cloutier
 */
@:allow(layout.Scale)
class Area extends EventDispatcher {
	public var x(default, set):Float;
	public var y(default, set):Float;
	public var width(default, set):Float;
	public var height(default, set):Float;
	
	public var centerX(get, never):Float;
	public var centerY(get, never):Float;
	public var left(get, set):Float;
	public var right(get, set):Float;
	public var top(get, set):Float;
	public var bottom(get, set):Float;
	
	public function new(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0) {
		super();
		
		setTo(x, y, width, height);
	}
	
	/**
	 * Sets this rectangle to the given values, only dispatching a single
	 * CHANGE event in the process.
	 */
	public function setTo(x:Float, y:Float, width:Float, height:Float):Void {
		Reflect.setField(this, "x", x);
		Reflect.setField(this, "y", y);
		Reflect.setField(this, "width", width);
		Reflect.setField(this, "height", height);
		
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	private function set_x(value:Float):Float {
		x = value;
		dispatchEvent(new Event(Event.CHANGE));
		return x;
	}
	private function set_y(value:Float):Float {
		y = value;
		dispatchEvent(new Event(Event.CHANGE));
		return y;
	}
	private function set_width(value:Float):Float {
		width = value;
		dispatchEvent(new Event(Event.CHANGE));
		return width;
	}
	private function set_height(value:Float):Float {
		height = value;
		dispatchEvent(new Event(Event.CHANGE));
		return height;
	}
	
	private inline function get_left():Float {
		return x;
	}
	private inline function set_left(value:Float):Float {
		setTo(value, y, width - (value - x), height);
		return value;
	}
	private inline function get_right():Float {
		return x + width;
	}
	private inline function set_right(value:Float):Float {
		width = value - x;
		return value;
	}
	private inline function get_top():Float {
		return y;
	}
	private inline function set_top(value:Float):Float {
		setTo(x, value, width, height - (value - y));
		return value;
	}
	private inline function get_bottom():Float {
		return y + height;
	}
	private inline function set_bottom(value:Float):Float {
		height = value - y;
		return value;
	}
	
	private inline function get_centerX():Float {
		return x + width / 2;
	}
	private inline function get_centerY():Float {
		return y + height / 2;
	}
	
	public inline function clone():Area {
		return new Area(x, y, width, height);
	}
}
