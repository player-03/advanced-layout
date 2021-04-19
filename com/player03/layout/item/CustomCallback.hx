package com.player03.layout.item;

import com.player03.layout.item.LayoutItem.LayoutMask;

class CustomCallback implements LayoutItem {
	public var callback:Void -> Void;
	public var mask:LayoutMask = 0;
	
	public function new(callback:Void -> Void) {
		this.callback = callback;
	}
	
	public function apply(target:Resizable, area:Resizable, scale:Scale):Void {
		callback();
	}
}
