iOS-CAAnimation-group-demo
==========================

This is a demo project that illustrates various animation techniques

It shows 3 different kinds of animations:

* A simple UIView animation that animates an image in a straight line while increasing the scale of the image and rotating it around it's axis
* A "clock wipe" animation that gradually reveals an image in a circular arc like a radar display, then hides it again
* A complex sequence of animations that are managed using a CAAnimationGroup.


## UIVIew animation (View Animation button)

The UIView animation is performed by the method `-doViewAnimation: (id) sender` in viewController.m. It uses the method `animateWithDuration:delay:options:animations:completion:` to do it's job. UIView animations modify animatable properties of one or more views. It is possible to animate mutliple animatable properties of multiple view objects with a single UIView animation call. the doViewAnimation method animates the view's center, scale, and rotation all at the same time. 

## Clock Wipe animation (Mask Animation button)

The clock wipe animation is performed in the method `- (IBAction)doMaskAnimation:(id)sender;`. It works by creating a shape layer (`CAShapeLayer`) and setting it as the mask for an image view's layer. We set the shape layer to contain a an arc that describes a full circle, where the radius of the arc is 1/2 of the center-to-corner distance of the view. The line width of the arc is set to the arc radius, so the arc actually fills the entire image bounds rectangle. 

`CAShapeLayer`s have a properties **strokeStart** and **strokeEnd**. Both values range from 0.0 to 1.0. Normally strokeStart = 0 and strokeEnd = 1.0. If you set strokeEnd to a value less than 1, only a portion of the shape layer's path is drawn.

The `doMaskAnimation` method sets `strokeEnd = 0` to start, which means the path is empty, and the entire image view is hidden (masked.) It then creates a CABasicAnimatimation that animates the strokeEnd property from 0.0 to 1.0. That causes the layer's path to animate an ever-increasing arc. Since the line thickness for hte shape layer is very thick, the arc fills the entire bounds of the image view, revealing an ever-increasing portion of the image view.

The animation looks like this:

![clock wipe](Clock wipe.gif)


## CAAnimationGroup animation. (CAAnimation button)

The "CAAnimation" button invokes the method `- (IBAction)doAnimation:(id)sender `. It performs a whole sequence of animations. It does this buy creating a CAAnimationGroup, and then creating a sequence of individual CAAnimation objects of different flavors. It sets the beginTime property of each animation so that each animation step in the animation group begins when the next animation finishes. 




## What you will learn:
This project demonstrates a wide variety of animation techniques

  * Using CABasicAnimation to animate a property and move images around on the screen.
  * Using different animation timing functions like kCAMediaTimingFunctionLinear, kCAMediaTimingFunctionEaseIn, and  kCAMediaTimingFunctionEaseInEaseOut to get different effects
  * Using CAKeyframeAnimation and a CGPath to animate a layer along a curved path (a figure 8).
  * Creating a custom subclass of UIView that has a CAShapeLayer as it's backing layer so you can draw shapes in a view "for free."
  * Adding a CGPath to a shape layer to draw shapes on the screen.
  * Using CAAnimationGroup to create a linked series of animations that run in sequence
  * Creating a very clean "per animation" completion block scheme using the fact that CAAnimation objects support the setValue:forKey: method. I add a code block to an animation object and set up the animation delegate's animationDidStop:finished method to check for a special key/value pair with the key kAnimationCompletionBlock.
  * Using the cumulative property on animations to create a single repeating animation that continuously rotates a layer by any desired amount.
  * Using a CATapGestureRecognizer to detect taps on a view.
  * Detecting taps on a view while it animates "live" by using the hitTest method of the view's presentation layer
  * Pausing and resuming animation on a layer.



