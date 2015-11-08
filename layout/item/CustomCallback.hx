package layout.item;

class CustomCallback implements LayoutItem {
	public var callback:Scale -> Void;
	public var mask:Int = 0;
	
	public function new(callback:Scale -> Void) {
		this.callback = callback;
	}
	
	public function apply(target:Resizable, area:Resizable, scale:Scale):Void {
		callback(scale);
	}
}
