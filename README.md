# Advanced Layout

An easy way to create fluid layouts. There are two main ways to use it:
    1. Define your layout using convenience functions. (See [LayoutUtils](#using-layoututils).)
    2. Take a pre-built layout, and make it scale. (See [PremadeLayoutUtils](#using-premadelayoututils).)

Note that the library does nothing except move and resize objects. All examples shown will assume you've already created a Sprite named `mySprite` and a Bitmap named `myBitmap`, and that you've added both to the stage.

Using LayoutUtils
=================

To get started, add this after your imports:

    using layout.LayoutUtils;

LayoutUtils is a [static extension](http://haxe.org/manual/lf-static-extension.html), so this will enable you to call all of its functions more easily.

Scaling
-------

    //The easiest way to handle scale. The bitmap will now scale with
    //the stage.
    myBitmap.simpleScale();
    
    //Make the sprite fill half the stage. (Warning: this only changes
    //the size; it won't center it.)
    mySprite.fillPercentWidth(0.5);
    mySprite.fillPercentHeight(0.5);
    
    //Make the bitmap match the width of the sprite, thereby filling
    //half the stage (horizontally). The bitmap's height will scale
    //as before, causing the bitmap to get distorted.
    myBitmap.matchWidth(sprite);

Positioning
-----------

Always set position after setting scale. The new width and height will be required to place the object correctly.

    //Place the bitmap on the right edge of the stage.
    myBitmap.alignRight();
    
    //Place the sprite in the top-left corner, leaving a small margin.
    mySprite.alignTopLeft(5);
    
    //Place the bitmap 75% of the way down the stage.
    myBitmap.verticalPercent(0.75);
    
    //Place the bitmap a medium distance from the left.
    myBitmap.alignLeft(50);

Sometimes the best way to create a layout is to specify that one object should be above, below, left of, or right of another object.

    //Place the bitmap below the sprite. (Warning: this only affects the
    //y coordinate; the x coordinate will be unchanged.)
    myBitmap.below(mySprite);
    
    //Place the bitmap to the right of the sprite. (This only affects the
    //x coordinate, so now it'll be diagonally below.)
    myBitmap.rightOf(mySprite);
    
    //Place the bitmap directly below the sprite.
    myBitmap.belowCenter(mySprite);
    
    //Place the bitmap directly right of the sprite, a long distance away.
    myBitmap.rightOfCenter(mySprite, 300);
    
    //Place the sprite in the center of the stage. (Warning: now the
    //instructions are out of order.)
    mySprite.center();
    
    //Correct the ordering.
    myBitmap.rightOfCenter(mySprite, 300);
    
    //Align the bitmap to the sprite's bottom edge, rather than centering
    //it on the sprite.
    myBitmap.alignWith(mySprite, BOTTOM);

Remember, when one object is being placed relative to a second object, place the latter object first.

Conflict resolution
-------------------

Advanced Layout uses an intelligent system to determine whether a given instruction conflicts with a previous command. When a conflict occurs, the old instruction will be removed from the list.

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

It's obviously more efficient not to call all these extra functions if they're just going to be replaced, but if you have to change one regularly, it won't cause a memory leak.
