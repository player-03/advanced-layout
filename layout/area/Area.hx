package layout.area;

import flash.events.Event;
import flash.events.EventDispatcher;

/**
 * A rectangular region, to place objects within. Note: area boundaries
 * will not always be strictly enforced.
 * 
 * After the area changes for any reason, it will dispatch a CHANGE event.
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
	
	public function new(?x:Float = 0, ?y:Float = 0, ?width:Float = 0, ?height:Float = 0) {
		super();
		
		setTo(x, y, width, height);
	}
	
	/**
	 * Sets this rectangle to the given values, only dispatching a single
	 * CHANGE event in the process.
	 */
	public function setTo(x:Float, y:Float, width:Float, height:Float, ?suppressEvent:Bool = false):Void {
		Reflect.setField(this, "x", x);
		Reflect.setField(this, "y", y);
		Reflect.setField(this, "width", width);
		Reflect.setField(this, "height", height);
		
		if(!suppressEvent) {
			queueChangeEvent();
		}
	}
	
	private function set_x(value:Float):Float {
		x = value;
		queueChangeEvent();
		return x;
	}
	private function set_y(value:Float):Float {
		y = value;
		queueChangeEvent();
		return y;
	}
	private function set_width(value:Float):Float {
		width = value;
		queueChangeEvent();
		return width;
	}
	private function set_height(value:Float):Float {
		height = value;
		queueChangeEvent();
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
	
	private static var currentArea:Area;
	private static var queue:Array<Area> = [];
	
	/**
	 * Dispatches a CHANGE event for this Area, but only after all ongoing
	 * CHANGE events are resolved.
	 */
	public function queueChangeEvent():Void {
		if(this == currentArea) {
			return;
		}
		
		//Queue this Area unless it's already queued.
		if(queue.indexOf(this) < 0) {
			queue.push(this);
		}
		
		//If the queue isn't currently being handled, dispatch events for each
		//Area in the queue.
		while(currentArea == null && queue.length > 0) {
			currentArea = queue[0];
			queue.splice(0, 1);
			
			//Dispatch the event. This may extend the queue.
			currentArea.dispatchEvent(new Event(Event.CHANGE));
			
			currentArea = null;
		}
	}
	
	public override function toString():String {
		return '(x=$x, y=$y, width=$width, height=$height)';
	}
}
