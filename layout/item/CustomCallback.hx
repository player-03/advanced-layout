package layout.item;

class CustomCallback implements LayoutItem {
	public var callback:Void -> Void;
	public var mask:Int = 0;
	
	public function new(callback:Void -> Void) {
		this.callback = callback;
	}
	
	public function apply(target:Resizable, area:Resizable, scale:Scale):Void {
		callback();
	}
}
