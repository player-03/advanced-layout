package com.player03.layout;

import com.player03.layout.area.Area;
import com.player03.layout.area.StageArea;
import com.player03.layout.Direction;
import flash.events.Event;
import flash.Lib;

#if openfl
import openfl.system.Capabilities;
import lime.system.Display;
#end

/**
 * When you set a "simple" size for an object (as opposed to a relative
 * size), that value will be multiplied by either Scale.x or Scale.y. For
 * instance, setting simpleWidth(128) when Scale.x is 2 will result in a
 * width of 256. All margins are also scaled by these values.
 * 
 * Each Layout can have its own Scale, but by default a Scale is shared
 * between nested layouts.
 * 
 * For instance, you might want an object to be 100x100 pixels on an
 * 800x600 stage. But on a 5120x2880 stage, that wouldn't be enough, so
 * this class will tell you how much to scale it up.
 * 
 * One possibility is to scale the width and height independently:
 * multiply width by 6.4, and multiply height by 4.8. However, this will
 * cause images to be distorted, which often won't look good. Call
 * Scale.stretch() if you want to enable this.
 * 
 * This class offers options to preserve the aspect ratio, but none of
 * them are perfect. A 5120x2880 stage is proportionately wider than the
 * 800x600 "base" stage, so there's no way to get an exact fit while
 * keeping the aspect ratio.
 * 
 * Choosing a scale of 4.8 would make the height fit exactly
 * (600 * 4.8 == 2880), but the width would fall short: 800 * 4.8 is only
 * 3840. You'd end up with blank space horizontally. This is done by
 * default.
 * 
 * If you went with a scale of 6.4, the width would now match, but the
 * converted height would be more than the stage height, and some objects
 * might get cut off. Call Scale.aspectRatioWithCropping() to enable this.
 * @author Joseph Cloutier
 */
@:allow(com.player03.layout.ScaleBehavior)
@:allow(com.player03.layout.Layout)
class Scale {
	public static var stageScale(get, never):Scale;
	private static inline function get_stageScale():Scale {
		return Layout.stageLayout.scale;
	}
	
	public var x(default, null):Float = 1;
	public var y(default, null):Float = 1;
	
	/**
	 * The average of x and y.
	 */
	public var average(get, never):Float;
	
	public var baseWidth:Int;
	public var baseHeight:Int;
	
	/**
	 * @param	baseWidth The initial width of the layout. Scaling will be
	 * determined by dividing the current width by baseWidth.
	 * @param	baseHeight The initial height of the layout. Scaling will
	 * be determined by dividing the current height by baseHeight.
	 * @param	area If you want to use something besides the stage
	 * boundaries to calculate scale, specify it here. In most cases this
	 * won't be necessary.
	 */
	public function new(?baseWidth:Int = 800, ?baseHeight:Int = 600,
						?area:Area) {
		this.baseWidth = baseWidth;
		this.baseHeight = baseHeight;
		this.area = area != null ? area : StageArea.instance;
		
		aspectRatio();
	}
	
	/**
	 * The behavior updates Scale.x and Scale.y whenever the stage size
	 * changes.
	 */
	private var behavior(null, set):ScaleBehavior;
	private function set_behavior(value:ScaleBehavior):ScaleBehavior {
		if(behavior == null && value != null) {
			area.addEventListener(Event.CHANGE, onResize, false, 1);
		} else if(behavior != null && value == null) {
			area.removeEventListener(Event.CHANGE, onResize);
			
			x = 1;
			y = 1;
		}
		
		behavior = value;
		
		area.dispatchEvent(new Event(Event.CHANGE));
		
		return behavior;
	}
	private function onResize(?e:Event):Void {
		if(behavior != null) {
			behavior.onResize(Std.int(area.width), Std.int(area.height), this);
		}
	}
	
	private inline function get_average():Float {
		return (x + y) / 2;
	}
	
	/**
	 * Do not scale anything.
	 */
	public inline function noScale():Void {
		behavior = null;
	}
	/**
	 * Fills the stage. Does not maintain aspect ratio. This is the
	 * default behavior.
	 */
	public inline function stretch():Void {
		behavior = new ExactFitScale();
	}
	/**
	 * Makes everything as large as possible while maintaining aspect
	 * ratio and fitting onstage. Some space may be left empty.
	 */
	public inline function aspectRatio():Void {
		behavior = new ShowAllScale();
	}
	/**
	 * Maintains aspect ratio and fills the stage. Some items may extend
	 * offscreen, and there is additional danger of overlap.
	 */
	public inline function aspectRatioWithCropping():Void {
		behavior = new NoBorderScale();
	}
	
	#if (openfl && !flash && !html5)
		/**
		 * Scale based on the screen's DPI. This requires OpenFL and
		 * doesn't work in Flash or HTML5. Use something else in that
		 * case.
		 * @param	baseDPI The pixels per inch of the device you're
		 * testing on. The default is 160 because that's what Android
		 * considers to be "medium" density.
		 * @param	smart Whether to adjust the scale based on how
		 * large users may expect things to appear onscreen. For
		 * instance, desktop users with higher resolution screens may
		 * expect things to look smaller. Defaults to true.
		 */
		public function screenDPI(?baseDPI:Int = 160, ?smart:Bool = true):Void {
			behavior = new DPIScale(baseDPI, smart);
			area.dispatchEvent(new Event(Event.CHANGE));
		}
	#end
	
	private var area(default, set):Area;
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

private class ScaleBehavior {
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
private class WidthScale extends ScaleBehavior {
	public function new() {
		super();
	}
	
	public override function onResize(stageWidth:Int, stageHeight:Int, scale:Scale):Void {
		scale.x = stageWidth / scale.baseWidth;
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
		scale.x = stageHeight / scale.baseHeight;
		scale.y = scale.x;
	}
}

//The following are all named after Flash's StageScaleMode constants.
class ExactFitScale extends ScaleBehavior {
	public function new() {
		super();
	}
	
	public override function onResize(stageWidth:Int, stageHeight:Int, scale:Scale):Void {
		scale.x = stageWidth / scale.baseWidth;
		scale.y = stageHeight / scale.baseHeight;
	}
}

class ShowAllScale extends ScaleBehavior {
	public function new() {
		super();
	}
	
	public override function onResize(stageWidth:Int, stageHeight:Int, scale:Scale):Void {
		scale.x = Math.min(stageWidth / scale.baseWidth,
							stageHeight / scale.baseHeight);
		scale.y = scale.x;
	}
}

class NoBorderScale extends ScaleBehavior {
	public function new() {
		super();
	}
	
	public override function onResize(stageWidth:Int, stageHeight:Int, scale:Scale):Void {
		scale.x = Math.max(stageWidth / scale.baseWidth,
							stageHeight / scale.baseHeight);
		scale.y = scale.x;
	}
}

#if (openfl && !flash)
class DPIScale extends ScaleBehavior {
	private var baseDPI:Float;
	private var smart:Bool;
	
	public function new(baseDPI:Float, smart:Bool) {
		super();
		
		this.baseDPI = baseDPI;
		this.smart = smart;
	}
	
	public override function onResize(stageWidth:Int, stageHeight:Int, scale:Scale):Void {
		scale.x = (smart ? Capabilities.screenDPI : Display.dpi) / baseDPI;
		scale.y = scale.x;
	}
}
#end
