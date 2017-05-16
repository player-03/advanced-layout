package com.player03.layout.area;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.display.Stage;
import flash.Lib;

#if flixel
import flixel.FlxG;
import flixel.system.scaleModes.StageSizeScaleMode;
#end

/**
 * The full area of the stage. Use StageArea.instance rather than
 * instantiating it yourself.
 * @author Joseph Cloutier
 */
@:allow(com.player03.layout.Layout)
class StageArea extends Area {
	public static var instance(get, null):StageArea;
	private static function get_instance():StageArea {
		if(instance == null) {
			instance = new StageArea();
		}
		return instance;
	}
	
	private function new() {
		super();
		
		#if flixel
			FlxG.signals.gameResized.add(setStageDimensions);
			FlxG.scaleMode = new StageSizeScaleMode();
		#else
			Lib.current.stage.addEventListener(Event.RESIZE, onStageResize, false, 1);
			onStageResize(null);
		#end
	}
	
	#if flixel
		private function setStageDimensions(width:Int, height:Int):Void {
			super.setTo(0, 0, width, height);
		}
	#end
	
	private function onStageResize(?e:Event):Void {
		var stage:Stage = Lib.current.stage;
		
		if(stage.stageWidth != width || stage.stageHeight != height) {
			super.setTo(0, 0, stage.stageWidth, stage.stageHeight);
		}
	}
	
	//The boundaries are set automatically and can't otherwise be modified.
	public override function setTo(x:Float, y:Float, width:Float, height:Float, ?suppressEvent:Bool = false):Void {
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
