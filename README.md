# Advanced Layout

An easy way to create fluid layouts in OpenFL. There are two main ways to use it:

1. [Define your layout using convenience functions](#creating-layouts).
2. [Take a pre-built layout, and make it scale](#preserving-layouts).

For a slower introduction to this library and the philosophy behind it, check out [my blog post](https://player03.com/openfl/advanced-layout/).

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

Another approach is to arrange everything by hand inside a pre-defined "stage", and use that as a template. (Adobe Animate provides - or provided? - a WYSIWYG editor for this.) Advanced Layout has a few ways to take your pre-arranged layout and make it scale smoothly.

Guessing
--------

The `preserve()` function will look at an object's size and position, and guess how it should scale.

If you have a lot of objects and are using OpenFL, `preserveChildren()` will recursively call `preserve()` on each one. This allows you to dramatically simplify OpenFL's "SimpleSWFLayout" sample project:

```haxe
var clip:MovieClip = Assets.getMovieClip("layout:Layout");
addChild(clip);

clip.preserveChildren();
```

Not guessing
------------

If guessing isn't reliable enough, you can choose how to preserve an object's location:

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

This is how objects get pushed offscreen. If you call `stickToLeft()` for an object that's on the right, the margin will be enormous (say, 600 pixels on an 800 pixel stage). If the stage gets narrower, the margin will stay at ~600, which could at that point be more than the entire width.

You usually want to stick an object to the side it's closest to (which `preserve()` is good at), but there are exceptions.

- If the object is part of a group, it's usually more important to stick it to the same place as the rest of the group. If you call the same `stickTo()` function for the whole group, all the pieces will move as if they're a single unit. `preserve()` is terrible at catching this.
- If the object takes up most of the screen, you may want to stretch it to fill, or you might just want to center it. Depends on the type of object, and which ends up looking better. `preserve()` will err on the side of "stretch it."

Some guessing
-------------

A middle road is also possible. You can use `preserve()` to make some quick guesses, then override what it gets wrong. For example:

```haxe
//Assume we have a `ui` object with a pre-defined layout.

//Start by taking guesses as to how this layout should
//scale, even though some guesses will be wrong.
ui.preserveChildren();

//Fortunately, the guesses are wrong in the same way
//every time. Here are the mistakes:

//The popup window gets stretched horizontally, when
//it should be centered. The vertical axis is fine.
ui.popupWindow.stickToCenterX();

//The popup window's x button sticks to the top right
//corner of the stage instead of the popup window.
ui.xButton.stickToCenter();
```

Supporting other libraries
==========================
Even though it focuses on the OpenFL ecosystem, Advanced Layout's code is library-agnostic. It's possible to add support for any 2D display library, as long as that library lets you get and set `x`, `y`, `width`, and `height`. (Or the equivalents thereof.)

To add support for a new library, you need:

1. To be able to implicitly cast that library's objects to [`Resizable`](https://github.com/player-03/advanced-layout/blob/master/com/player03/layout/Resizable.hx#L29).
   - This requires making a subclass of [`ResizableImpl`](https://github.com/player-03/advanced-layout/blob/master/com/player03/layout/Resizable.hx#L112).
2. A subclass of `LayoutCreator`.

There are a few ways to accomplish step 1, each with pros and cons. For this example, assume you're trying to add support for a type called `Sprite2D`.

- If you were the one who created `Sprite2D`, you could extend `ResizableImpl` directly. This is kind of restrictive, though.
- The easiest option is to modify [Resizable.hx](https://github.com/player-03/advanced-layout/blob/master/com/player03/layout/Resizable.hx) directly, adding a `fromSprite2D()` function similar to the existing `from` functions. But this will be undone when Advanced Layout gets updated. (Unless you submit a pull request!)
- If `Sprite2D` is an abstract, you can add an implicit cast to `Resizable`, but that'll be undone when you update the other library.
- The most realistic option is to make an abstract wrapping `Sprite2D`, which forwards all fields and implicitly casts to `Resizable`. For best results, write your code to refer exclusively to this abstract, not `Sprite2D`. It may not be convenient, but it'll work.

Step 2 is simpler: create a subclass of `TypedLayoutCreator`.

```haxe
import com.player03.layout.LayoutCreator;

class Sprite2DLayoutCreator extends TypedLayoutCreator<AbstractSprite2D> {
}
```

You don't need to write any functions in this class; a macro will handle that. Just type `using package.Sprite2DLayoutCreator` and start laying out your `AbstractSprite2D`s.

The reason you have to declare all variables as `AbstractSprite2D` instead of just `Sprite2D` is, the `using` directive only works on an exact type match. So you can only write `sprite.alignRight(20)` if `sprite` matches the type parameter you wrote when extending `TypedLayoutCreator`. (And that type parameter must convert directly to `Resizable`. Haxe can't handle `Sprite2D` -> `AbstractSprite2D` -> `Resizable`; that's one step too many.)

If you want to act on a `Sprite2D` value, you either need to cast it to `AbstractSprite2D` or skip the `using` directive and type out `Sprite2DLayoutCreator.alignRight(sprite, 20)`.

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
