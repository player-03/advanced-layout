# Advanced Layout

An easy way to create fluid layouts in Flash and OpenFL. There are two main ways to use it:

1. [Define your layout using convenience functions](#creating-layouts).
2. [Take a pre-built layout, and make it scale](#preserving-layouts).

For a slower introduction to this library and the philosophy behind it, check out [my blog post](https://player03.com/2017/05/16/advanced-layout/).

Installation
============

```text
haxelib install advanced-layout
```

Setup
-----

When enabling layouts for your project, you need to specify what type of objects you're working with. Add one or more of these lines after your import statements:

```haxe
using layout.LayoutCreator.ForOpenFL; //compatible with DisplayObjects
using layout.LayoutCreator.ForRectangles; //compatible with OpenFL's Rectangles
using layout.LayoutCreator.ForHaxeUI; //compatible with HaxeUI's IDisplayObjects
using layout.LayoutCreator.ForFlixel; //compatible with FlxSprites
using layout.LayoutCreator.ForHaxePunk; //compatible with HaxePunk's entities
```

Creating layouts
================

These functions will move your objects into place and keep them there. If you've already arranged everything, consider using the [alternate paradigm](#preserving-layouts).

Scaling
-------

```haxe
//Sample objects.
var mySprite:Sprite = new Sprite();
mySprite.graphics.beginFill(0x000000);
mySprite.graphics.drawCircle(40, 40, 40);
addChild(mySprite);
var myBitmap:Bitmap = new Bitmap(Assets.getBitmapData("MyBitmap.png"));
addChild(myBitmap);

//The easiest way to handle scale. The sprite will now scale with
//the stage.
mySprite.simpleScale();

//Make the sprite fill half the stage. Caution: this only changes
//the size; it won't center it.
mySprite.fillPercentWidth(0.5);
mySprite.fillPercentHeight(0.5);

//Make the bitmap match the width of the sprite, meaning it will
//fill half the stage horizontally. The bitmap's height won't
//scale at all... yet.
myBitmap.matchWidth(sprite);

//Scale the bitmap's height so that it isn't distorted.
myBitmap.maintainAspectRatio();
```

Positioning
-----------

Always set the position after setting the scale. Most of these functions take the object's current width and height into account, so you want to make sure those values are up to date.

```haxe
//Place the bitmap on the right edge of the stage.
myBitmap.alignRight();

//Place the sprite in the top-left corner, leaving a small margin.
mySprite.alignTopLeft(5);

//Place the bitmap 75% of the way down the stage.
myBitmap.verticalPercent(0.75);

//Place the bitmap a medium distance from the left.
myBitmap.alignLeft(50);
```

Sometimes the best way to create a layout is to specify that one object should be above, below, left of, or right of another object.

```haxe
//Place the bitmap below the sprite. (Warning: this only affects the
//y coordinate; the x coordinate will be unchanged.)
myBitmap.below(mySprite);

//Place the bitmap to the right of the sprite. (This only affects the
//x coordinate, so now it'll be diagonally below.)
myBitmap.rightOf(mySprite);

//Center the bitmap directly below the sprite. (This affects both the
//x and y coordinates.)
myBitmap.belowCenter(mySprite);

//Place the bitmap directly right of the sprite, a long distance away.
myBitmap.rightOfCenter(mySprite, 300);

//Place the sprite in the center of the stage. Warning: now the
//instructions are out of order. The bitmap will be placed to the
//right of wherever the sprite was last time.
mySprite.center();

//Correct the ordering.
myBitmap.rightOfCenter(mySprite, 300);
```

Conflict resolution
-------------------

Advanced Layout uses an intelligent system to determine whether a given instruction conflicts with a previous one. When a conflict occurs, the old instruction will be removed from the list.

```haxe
//The first instruction never conflicts with anything.
myBitmap.simpleWidth();

//This does not conflict with simpleWidth(), so both will be used.
myBitmap.fillHeight();

//This conflicts with fillHeight(), so fillHeight() will be replaced.
myBitmap.simpleHeight();

//This does not conflict with either size command; all three will be used.
myBitmap.alignLeft();

//This does not conflict with alignLeft() or the size commands, so
//all of them will be used.
myBitmap.alignBottom();

//This conflicts with both alignBottom() and alignLeft(), so both
//will be replaced.
myBitmap.alignTopCenter();

//This conflicts with only the "top" part of alignTopCenter(), so
//only that part will be replaced.
myBitmap.above(mySprite);
```

It's obviously more efficient not to call extra functions in the first place, but if for some reason you have to, it won't cause a memory leak.

Preserving layouts
==================

These functions assume that you've already arranged your layout. They take objects' positions into account and attempt to keep everything in place.

Guessing
--------

As of release 0.6.0, `LayoutPreserver` can guess how an object should scale. To guess an individual object, use this:

```haxe
myObject.preserve();
```

If you have a number of objects to scale, but they all have the same parent, you can call `preserveChildren()` to handle them all at once. Here is how you'd convert the code in OpenFL's SimpleSWFLayout example:

```haxe
var clip:MovieClip = Assets.getMovieClip("layout:Layout");
addChild(clip);

clip.preserveChildren();
```

`LayoutPreserver` manual usage
----------------------------

If guessing isn't good enough, you can specify how an object should act:

```haxe
//Make the object follow the right edge.
myObject.stickToRight();

//Make the object follow the left edge. If it's on the right, this
//may push it offscreen, or pull it towards the center. (Not pretty!)
myObject.stickToLeft();

//Tug of war! The object stretches horizontally so that its left edge
//follows the screen's left, and its right edge follows the screen's right.
myObject.stickToLeftAndRight();
```

These `stickTo()` functions always preserve whatever margin currently exists. If an object is five pixels from the right, and you call `stickToRight()`, the object will keep a five-pixel margin (except that the margin will scale slightly as the stage gets wider and narrower).

This is how objects get pushed offscreen. If you call `stickToLeft()` for an object that's on the right, the margin will be enormous (most of the width of the stage). Then when the stage gets narrower, the margin will only get a little narrower, and the object will end up past the right edge.

Cleaning up
===========

If you use the same UI for the entire lifespan of your app, you don't have to worry about cleaning anything up. However, if you want an object to be garbage collected, you'll need to remove Advanced Layout's references to it.

You can remove objects one at a time, if you like:

```haxe
Layout.currentLayout.remove(myObject);
```

This may get tedious if you're trying to dispose of a large number at once. In that case, you'll want to plan ahead. When you first set up these objects, make sure to add them to their own `Layout` object:

```haxe
myLayout = new Layout();
Layout.currentLayout = myLayout;

//Now when you lay out your objects, they'll be associated with myLayout.

//...

//Once you're done laying out objects, you'll want to un-set currentLayout.
//Otherwise, a different class may add items to this class's layout.
Layout.currentLayout = null;
```

Now you have a set of objects all associated with `myLayout`. Once you're done with them, simply call `myLayout.dispose()` to clean up Advanced Layout's references.
