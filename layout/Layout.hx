package layout;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.Vector;
import layout.area.Area;
import layout.area.BoundedArea;
import layout.area.IRectangle;
import layout.area.StageArea;
import layout.item.LayoutItem;

/**
 * @author Joseph Cloutier
 */
class Layout {
	public static var stageLayout(get, null):Layout;
	private static function get_stageLayout():Layout {
		if(stageLayout == null) {
			stageLayout = new Layout(stageScale);
		}
		return stageLayout;
	}
	
	private static var stageScale:Scale = new Scale();
	public static function setStageBaseDimensions(width:Int, height:Int):Void {
		stageScale.baseStageWidth = width;
		stageScale.baseStageHeight = height;
		stageScale.onResize();
		StageArea.instance.onStageResize();
	}
	
	/**
	 * The Layout object that will be used (by DynamicLayout and StaticLayout)
	 * if you don't specify one. You may update this at any time. Setting
	 * this to null will make it default to stageLayout.
	 */
	@:isVar public static var defaultLayout(get, set):Layout;
	private static function get_defaultLayout():Layout {
		if(defaultLayout == null) {
			defaultLayout = Layout.stageLayout;
		}
		return defaultLayout;
	}
	private static inline function set_defaultLayout(value:Layout):Layout {
		return defaultLayout = value;
	}
	
	public var scale(default, null):Scale;
	public var bounds(default, null):Area;
	
	private var items:Vector<BoundItem>;
	
	public function new(?scale:Scale, ?bounds:Area) {
		if(bounds == null) {
			this.bounds = StageArea.instance;
		} else {
			this.bounds = bounds;
		}
		
		if(scale == null) {
			this.scale = new Scale(Std.int(this.bounds.width), Std.int(this.bounds.height));
		} else {
			this.scale = scale;
		}
		
		this.bounds.addEventListener(Event.CHANGE, onBoundsChanged);
		
		items = new Vector<BoundItem>();
	}
	
	private function onBoundsChanged(e:Event):Void {
		apply();
	}
	
	/**
	 * Applies this layout, updating the position, size, etc. of each
	 * tracked object. Updates are done in the order they were added, so
	 * be sure to set size before setting position.
	 */
	public function apply():Void {
		for(instruction in items) {
			instruction.item.apply(instruction.target, instruction.area, scale);
		}
	}
	
	public function dispose():Void {
		bounds.removeEventListener(Event.CHANGE, onBoundsChanged);
		items = null;
	}
	
	/**
	 * Creates a new layout object within this one that's bounded in the
	 * given directions by the given objects.
	 */
	public function partition(?leftEdge:DisplayObject, ?rightEdge:DisplayObject,
					?topEdge:DisplayObject, ?bottomEdge:DisplayObject):Layout {
		var subArea:BoundedArea = new BoundedArea(bounds,
							leftEdge, rightEdge, topEdge, bottomEdge);
		//A BoundedArea serves as its own LayoutInstruction.
		add(null, subArea);
		
		return new Layout(scale, subArea);
	}
	
	/**
	 * Adds a layout item, to be applied when the stage is resized and
	 * when apply() is called. If no "base" object is specified, the
	 * entire layout area will be used as the base.
	 * 
	 * This clears any conflicting items.
	 */
	public function add(target:DisplayObject,
						item:LayoutItem,
						?base:DisplayObject):Void {
		var i:Int = items.length - 1;
		while(i >= 0) {
			if(items[i].target == target
					&& LayoutMask.hasConflict(
						items[i].item.mask,
						item.mask)) {
				items.splice(i, 1);
			}
			i--;
		}
		
		var boundItem:BoundItem =
			new BoundItem(target,
						base != null ? base : bounds,
						item);
		items.push(boundItem);
		boundItem.item.apply(boundItem.target, boundItem.area, scale);
	}
	
	public inline function addMultiple(target:DisplayObject,
						items:Array<LayoutItem>,
						?base:DisplayObject) {
		for(item in items) {
			add(target, item, base);
		}
	}
	
	/**
	 * Finds the InstructionMask values currently associated with the
	 * given object.
	 */
	public function getMask(target:DisplayObject):Int {
		var mask:Int = 0;
		for(item in items) {
			if(item.target == target) {
				mask |= item.item.mask;
			}
		}
		return mask;
	}
}

/**
 * It's like bind(), except for a class.
 */
private class BoundItem {
	public var target:DisplayObject;
	public var area:IRectangle;
	public var item:LayoutItem;
	
	public function new(target:DisplayObject, area:IRectangle, item:LayoutItem) {
		this.target = target;
		this.area = area;
		this.item = item;
	}
	
	public static function sortOrder(a:BoundItem, b:BoundItem):Int {
		//Conveniently, the mask bits are already in order. (Hopefully
		//they'll stay that way...)
		return a.item.mask - b.item.mask;
	}
}
