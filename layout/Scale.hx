package layout;

import layout.area.Area;
import layout.area.StageArea;
import layout.Direction;
import flash.events.Event;
import flash.Lib;

/**
 * In the absence of other scale instructions, objects onscreen will be
 * scaled by these values. That is, scaleX will be multiplied by
 * Scale.x, and scaleY will be multiplied by Scale.y. Each Layout can
 * have its own Scale, but by Scale is shared between nested layouts.
 * 
 * For instance, you might want an object to be 100x100 pixels on an
 * 800x600 stage, but on a 5120x2880 stage, that wouldn't be enough, so
 * this class will tell you how much to scale it up.
 * 
 * One possibility is to scale the width and height independently:
 * multiply width by (5120/800), and multiply height by (2880/600).
 * However, this will cause images to be distorted, which often won't
 * look good. Call GlobalScale.stretch() to enable this.
 * 
 * This class offers options to preserve the aspect ratio, but none of
 * them are perfect. A 5120x2880 stage is proportionately wider than the
 * 800x600 "base" stage, so there's no way to get an exact fit while
 * keeping the aspect ratio.
 * 
 * Choosing a scale of 4.8 would make the height fit exactly
 * (600 * 4.8 == 2880), but the width would fall short: 800 * 4.8 is only
 * 3840. You'd end up with blank space horizontally. Call
 * GlobalScale.aspectRatio() to enable this (recommended).
 * 
 * If you went with a scale of 6.4, the width would now match, but the
 * converted height would be more than the stage height, and some objects
 * might get cut off. Call GlobalScale.aspectRatioWithCropping() to
 * enable this.
 * @author Joseph Cloutier
 */
@:allow(layout.ScaleBehavior)
class Scale {
	public var x(default, null):Float = 1;
	public var y(default, null):Float = 1;
	
	public var baseStageWidth:Int;
	public var baseStageHeight:Int;
	
	/**
	 * @param	baseStageWidth The stage width you're using for testing.
	 * @param	baseStageHeight The stage height you're using for testing.
	 * @param	area If you want to use something besides the stage
	 * boundaries to calculate scale, specify it here. In most cases this
	 * won't be necessary.
	 */
	public function new(baseStageWidth:Int = 800, baseStageHeight:Int = 600,
						?area:Area) {
		this.baseStageWidth = baseStageWidth;
		this.baseStageHeight = baseStageHeight;
		this.area = area != null ? area : StageArea.instance;
		
		aspectRatio();
	}
	
	/**
	 * The behavior updates Scale.x and Scale.y whenever the stage size
	 * changes.
	 */
	public var behavior(null, set):ScaleBehavior;
	private function set_behavior(value:ScaleBehavior):ScaleBehavior {
		if(behavior == null && value != null) {
			area.addEventListener(Event.CHANGE, onResize);
		} else if(behavior != null && value == null) {
			area.removeEventListener(Event.CHANGE, onResize);
		}
		
		behavior = value;
		
		onResize(null);
		
		return behavior;
	}
	public function onResize(?e:Event):Void {
		behavior.onResize(Std.int(area.width), Std.int(area.height), this);
	}
	
	//Convenience functions for some of the the available behaviors.
	public inline function disable():Void {
		behavior = null;
		x = 1;
		y = 1;
	}
	public inline function stretch():Void {
		behavior = new ExactFitScale();
	}
	public inline function aspectRatio():Void {
		behavior = new ShowAllScale();
	}
	public inline function aspectRatioWithCropping():Void {
		behavior = new NoBorderScale();
	}
	
	/**
	 * Most users can safely ignore this.
	 */
	public var area(default, set):Area;
	private function set_area(value:Area):Area {
		if(value == null) {
			area = StageArea.instance;
		} else {
			area = value;
		}
		
		if(behavior != null) {
			onResize(null);
		}
		
		return area;
	}
}

class ScaleBehavior {
	public function new() {
	}
	
	public function onResize(stageWidth:Int, stageHeight:Int, scale:Scale):Void {
		scale.x = 1;
		scale.y = 1;
	}
}

/**
 * Scale based only on the stage width, maintaining aspect ratio.
 */
class WidthScale extends ScaleBehavior {
	public function new() {
		super();
	}
	
	public override function onResize(stageWidth:Int, stageHeight:Int, scale:Scale):Void {
		scale.x = stageWidth / scale.baseStageWidth;
		scale.y = scale.x;
	}
}

/**
 * Scale based only on the stage height, maintaining aspect ratio.
 */
class HeightScale extends ScaleBehavior {
	public function new() {
		super();
	}
	
	public override function onResize(stageWidth:Int, stageHeight:Int, scale:Scale):Void {
		scale.x = stageHeight / scale.baseStageHeight;
		scale.y = scale.x;
	}
}

//The following are all named after Flash's StageScaleMode constants.
class ExactFitScale extends ScaleBehavior {
	public function new() {
		super();
	}
	
	public override function onResize(stageWidth:Int, stageHeight:Int, scale:Scale):Void {
		scale.x = stageWidth / scale.baseStageWidth;
		scale.y = stageHeight / scale.baseStageHeight;
	}
}

class ShowAllScale extends ScaleBehavior {
	public function new() {
		super();
	}
	
	public override function onResize(stageWidth:Int, stageHeight:Int, scale:Scale):Void {
		scale.x = Math.min(stageWidth / scale.baseStageWidth,
							stageHeight / scale.baseStageHeight);
		scale.y = scale.x;
	}
}

class NoBorderScale extends ScaleBehavior {
	public function new() {
		super();
	}
	
	public override function onResize(stageWidth:Int, stageHeight:Int, scale:Scale):Void {
		scale.x = Math.max(stageWidth / scale.baseStageWidth,
							stageHeight / scale.baseStageHeight);
		scale.y = scale.x;
	}
}
