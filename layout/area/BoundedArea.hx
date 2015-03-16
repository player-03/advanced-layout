package layout.area;

import layout.item.LayoutItem;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.display.DisplayObject;

/**
 * An area whose boundaries are defined by already-placed objects.
 * @author Joseph Cloutier
 */
class BoundedArea extends Area implements LayoutItem {
	/**
	 * The object on this area's left.
	 */
	public var leftEdge:DisplayObject;
	/**
	 * The object on this area's right.
	 */
	public var rightEdge:DisplayObject;
	/**
	 * The object above this area.
	 */
	public var topEdge:DisplayObject;
	/**
	 * The object below this area.
	 */
	public var bottomEdge:DisplayObject;
	
	public var mask:Int;
	
	/**
	 * @param	parentArea The boundaries to use by default if an object
	 * is not specified for that side. The bounded area will not extend
	 * beyond its parent.
	 */
	public function new(parentArea:Area,
					?leftEdge:DisplayObject, ?rightEdge:DisplayObject,
					?topEdge:DisplayObject, ?bottomEdge:DisplayObject) {
		super(parentArea.x, parentArea.y, parentArea.width, parentArea.height);
		
		this.leftEdge = leftEdge;
		this.rightEdge = rightEdge;
		this.topEdge = topEdge;
		this.bottomEdge = bottomEdge;
		
		mask = LayoutMask.AFFECTS_X | LayoutMask.AFFECTS_Y
			| LayoutMask.AFFECTS_WIDTH | LayoutMask.AFFECTS_HEIGHT;
		
		refresh(parentArea);
	}
	
	//This isn't elegant code, but at least it works.
	public function apply(target:DisplayObject, area:IRectangle, scale:Scale):Void {
		refresh(area);
	}
	
	public function refresh(parentArea:IRectangle):Void {
		var x:Float = parentArea.x;
		if(leftEdge != null) {
			x = Math.max(x, leftEdge.x + leftEdge.width);
		}
		
		var y:Float = parentArea.y;
		if(topEdge != null) {
			y = Math.max(y, topEdge.y + topEdge.height);
		}
		
		var width:Float = parentArea.x + parentArea.width - x;
		if(rightEdge != null) {
			width = Math.min(width, rightEdge.x - x);
		}
		
		var height:Float = parentArea.y + parentArea.height - y;
		if(bottomEdge != null) {
			height = Math.min(height, bottomEdge.y - y);
		}
		
		if(x != this.x || y != this.y || width != this.width || height != this.height) {
			super.setTo(x, y, width, height);
		}
	}
	
	//The boundaries are set automatically and can't otherwise be modified.
	public override function setTo(x:Float, y:Float, width:Float, height:Float):Void {
	}
	private override function set_x(value:Float):Float {
		return x;
	}
	private override function set_y(value:Float):Float {
		return y;
	}
	private override function set_width(value:Float):Float {
		return width;
	}
	private override function set_height(value:Float):Float {
		return height;
	}
}
