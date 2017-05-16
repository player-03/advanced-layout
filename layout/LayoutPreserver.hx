package layout;

/**
 * Use this class if you positioned your objects beforehand, and all you need is
 * to make everything scale. If you still need to position your objects,
 * consider using LayoutCreator to save a step.
 * 
 * Use this class as a static extension.
 * 
 * Example: consider an object that you've placed at the bottom of the stage.
 * When the stage scales, you want to update the object's y coordinate so that
 * it stays at the bottom. To do this, call stickToBottom().
 * 
 * All "stickTo" functions remember how far the object was from the edge (or
 * center). So if the sample object starts five pixels above the bottom, it will
 * remain about five pixels above the bottom as the stage scales. This
 * five-pixel margin will increase as the stage gets bigger, and it will
 * decrease as the stage gets smaller.
 * 
 * If you want this class to guess how an object should scale, use the
 * preserve() function.
 * 
 * @author Joseph Cloutier
 */
typedef LayoutPreserver = com.player03.layout.LayoutPreserver;