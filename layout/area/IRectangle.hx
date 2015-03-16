package layout.area;

/**
 * A typedef that matches either a DisplayObject or an Area.
 */
typedef IRectangle = {
	#if flash
		var x(default, null):Float;
		var y(default, null):Float;
		var width(default, null):Float;
		var height(default, null):Float;
	#else
		var x(get, null):Float;
		var y(get, null):Float;
		var width(get, null):Float;
		var height(get, null):Float;
	#end
}
