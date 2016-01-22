package layout;

import flash.events.Event;
import flash.Vector;
import layout.area.Area;
import layout.area.StageArea;
import layout.item.CustomCallback;
import layout.item.LayoutItem;
import layout.Resizable;

using layout.LayoutCreator;

/**
 * 
 * @author Joseph Cloutier
 */
class Layout {
	public static var stageLayout(get, null):Layout;
	private static function get_stageLayout():Layout {
		if(stageLayout == null) {
			stageLayout = new Layout(new Scale());
			stageScale = stageLayout.scale;
		}
		return stageLayout;
	}
	
	private static var stageScale:Scale;
	public static function setStageBaseDimensions(width:Int, height:Int):Void {
		if(stageScale == null) {
			get_stageLayout();
		}
		
		stageScale.baseStageWidth = width;
		stageScale.baseStageHeight = height;
		stageScale.onResize();
		StageArea.instance.onStageResize();
	}
	
	/**
	 * The Layout object that will be used (by LayoutCreator and LayoutPreserver)
	 * if you don't specify one. You may update this at any time. Setting
	 * this to null will make it default to stageLayout.
	 */
	@:isVar public static var currentLayout(get, set):Layout;
	private static function get_currentLayout():Layout {
		if(currentLayout == null) {
			currentLayout = Layout.stageLayout;
		}
		return currentLayout;
	}
	private static inline function set_currentLayout(value:Layout):Layout {
		//I'd prefer to use (get, default), but that's not allowed.
		return currentLayout = value;
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
			this.scale = new Scale(Std.int(this.bounds.width), Std.int(this.bounds.height), this.bounds);
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
	
	/**
	 * Applies this layout to the given item only.
	 */
	public function applyTo(target:Resizable):Void {
		for(instruction in items) {
			if(instruction.target != null && instruction.target.equals(target)) {
				instruction.item.apply(instruction.target, instruction.area, scale);
			}
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
	public function partition(?leftEdge:Resizable, ?rightEdge:Resizable,
					?topEdge:Resizable, ?bottomEdge:Resizable):Layout {
		var subArea:Area = bounds.clone();
		if(leftEdge != null) {
			subArea.rightOfWithResizing(leftEdge);
		}
		if(rightEdge != null) {
			subArea.leftOfWithResizing(rightEdge);
		}
		if(topEdge != null) {
			subArea.belowWithResizing(topEdge);
		}
		if(bottomEdge != null) {
			subArea.aboveWithResizing(bottomEdge);
		}
		
		return new Layout(
			new Scale(Math.round(subArea.width), Math.round(subArea.height), subArea),
			subArea);
	}
	
	/**
	 * Adds a layout item, to be applied when the stage is resized and
	 * when apply() is called. If no "base" object is specified, the
	 * entire layout area will be used as the base.
	 * 
	 * This clears any conflicting items.
	 */
	public function add(target:Resizable,
						item:LayoutItem,
						?base:Resizable):Void {
		//If the target was added before, use the original Resizable object.
		//(It would be more efficient not to create multiple Resizable objects
		//at all, but that isn't feasible.)
		var wasAddedBefore:Bool = false;
		for(item in items) {
			if(item.target != null && item.target.equals(target)) {
				target = item.target;
				wasAddedBefore = true;
				break;
			}
		}
		
		if(wasAddedBefore) {
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
		}
		
		var boundItem:BoundItem =
			new BoundItem(target,
						base != null ? base : bounds,
						item);
		items.push(boundItem);
		boundItem.item.apply(boundItem.target, boundItem.area, scale);
	}
	
	/**
	 * Adds a callback to be called at the current point in the layout process.
	 * If items have already been added using add(), those will be applied
	 * before calling the callback. If more items are added later, those will be
	 * applied afterwards.
	 */
	public inline function addCallback(callback:Void -> Void, callImmediately:Bool):Void {
		items.push(new BoundItem(null, null, new CustomCallback(callback)));
		
		if(callImmediately) {
			callback();
		}
	}
	
	public inline function addMultiple(target:Resizable,
						items:Array<LayoutItem>,
						?base:Resizable):Void {
		for(item in items) {
			add(target, item, base);
		}
	}
	
	/**
	 * Removes all references to the given object.
	 */
	public function remove(target:Resizable):Void {
		var i:Int = items.length - 1;
		while(i >= 0) {
			if(items[i].target == null) {
				//Skip callback items.
			} else if(items[i].target.equals(target) || items[i].area.equals(target)) {
				items.splice(i, 1);
			}
			
			i--;
		}
	}
	
	/**
	 * Removes the given callback function.
	 */
	public inline function removeCallback(callback:Void -> Void):Void {
		var i:Int = items.length - 1;
		while(i >= 0) {
			if(Std.is(items[i].item, CustomCallback) && cast(items[i].item, CustomCallback).callback == callback) {
				items.splice(i, 1);
			}
			
			i--;
		}
	}
	
	/**
	 * @return Whether this target/item pair would overwrite an existing pair.
	 */
	public function conflictExists(target:Resizable, item:LayoutItem):Bool {
		for(i in items) {
			if(i.target != null && i.target.equals(target)
				&& LayoutMask.hasConflict(
							i.item.mask,
							item.mask)) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Finds the InstructionMask values currently associated with the
	 * given object.
	 */
	public function getMask(target:Resizable):Int {
		var mask:Int = 0;
		for(item in items) {
			if(item.target != null && item.target.equals(target)) {
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
	public var target:Resizable;
	public var area:Resizable;
	public var item:LayoutItem;
	
	public function new(target:Resizable, area:Resizable, item:LayoutItem) {
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
