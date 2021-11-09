package layout;

/**
 * To use this as a static extension, you need to specify what you're using it for:
 * 
 * using layout.LayoutCreator.ForOpenFL; //compatible with DisplayObjects, but not Rectangles
 * using layout.LayoutCreator.ForRectangles; //compatible with OpenFL's Rectangles
 * using layout.LayoutCreator.ForFlixel; //compatible with FlxSprites
 * using layout.LayoutCreator.ForHaxePunk; //compatible with HaxePunk's entities
 * 
 * Once you've picked one or more of the above, without any further setup, you can
 * call layout functions as if they were instance methods:
 * 
 * object0.simpleWidth(30);
 * object0.simpleHeight(40);
 * object0.alignBottomRight();
 * 
 * object1.simpleScale();
 * object1.center();
 * 
 * object2.fillWidth();
 * object2.simpleHeight();
 * object2.below(object1);
 * 
 * Remember: set width and height before setting an object's position. Your
 * instructions will be run in order, and position often depends on dimensions.
 * 
 * @author Joseph Cloutier
 */
typedef LayoutCreator = com.player03.layout.LayoutCreator;

typedef ForAreas = com.player03.layout.LayoutCreator.ForAreas;
typedef ForRectangles = com.player03.layout.LayoutCreator.ForRectangles;
typedef ForOpenFL = com.player03.layout.LayoutCreator.ForOpenFL;

#if haxeui
typedef ForHaxeUI = com.player03.layout.LayoutCreator.ForHaxeUI;
#end
#if flixel
typedef ForFlixel = com.player03.layout.LayoutCreator.ForFlixel;
#end
#if haxepunk
typedef ForHaxePunk = com.player03.layout.LayoutCreator.ForHaxePunk;
#end
