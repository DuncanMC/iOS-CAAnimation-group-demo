//
//  ViewController.m
//  CA Test iOS
//
//  Created by Duncan Champney on 3/21/12.
//  Copyright (c) 2012 WareTo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "MessageObject.h"


@interface ViewController ()

- (void) resumeLayer: (CALayer *) theLayer;


@end

@implementation ViewController


@synthesize animationInFlight;
@synthesize myContainerView;
@synthesize messagesArray;

//-----------------------------------------------------------------------------------------------------------
#pragma mark - view lifecycle methods
//-----------------------------------------------------------------------------------------------------------


- (void)viewDidLoad
{
  self.messagesArray = [NSMutableArray arrayWithCapacity: 10];
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


//We only support portrait and portrait upside down orientations
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
  return UIInterfaceOrientationIsPortrait(interfaceOrientation);
//	return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

//-----------------------------------------------------------------------------------------------------------

- (void)viewDidUnload
{
  self.messagesArray = nil;
  imageOne = nil;
  //containerView = nil;
  animateButton = nil;
  viewAnimationButton = nil;

  animationStepLabel = nil;
  stopAnimationButton = nil;
  tapInstructionsLabel = nil;
  animationStepView = nil;
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}



//-----------------------------------------------------------------------------------------------------------
#pragma mark - instance methods
//-----------------------------------------------------------------------------------------------------------

/*
 This method sets up delayed calls to setText to display the animation steps at the appropriate times.
 The method is also used if we resume the animation after pausing it, so we need an offset 
 into the total animation time. Offset 0 is the beginning of the whole animation sequence.
 */

- (void) queueMessagesAtTime: (CFTimeInterval) time;
{
  MessageObject *message = nil;
  
  for (message in messagesArray)
  {
    if (message.startTime >= time)
    {
      [animationStepLabel performSelector: @selector(setText:) withObject: message.message afterDelay: message.startTime - time];
    }
  }
}

//-----------------------------------------------------------------------------------------------------------

//This method shows how to use a CAAnimationGroup to create a whole series of linked animations that
//run one right after the other. The secret is to set a duration for the entire group, and use the beginTime
//property in each animation step to make it start at the desired time within the group animation.

- (IBAction)doAnimation:(id)sender 
{
  [messagesArray removeAllObjects];
  CGFloat animationSpeed = .25;  //run the animation at 1/4 speed so you can see it and tap on the image
  animationStepView.hidden = FALSE;
  tapInstructionsLabel.hidden = FALSE;
  stopAnimationButton.enabled = TRUE;
  
  animationCompletionBlock theBlock;
  
  self.animationInFlight = TRUE;
  animateButton.enabled = FALSE;
  viewAnimationButton.enabled = FALSE;


  CGPoint oldOrigin;
  CGFloat duration = 0.4;
  CGFloat totalDuration = 0.0;
  CGFloat pause = .05;
  CGFloat start = 0;
  
  //-----------------------------------------------------------------------
  //Create an opacity animation to show the image view
  //-----------------------------------------------------------------------
  [messagesArray addObject: [MessageObject message: @"Show" startTime: start/animationSpeed]];
  CABasicAnimation* show =  [CABasicAnimation animationWithKeyPath: @"opacity"];
  show.removedOnCompletion = FALSE;
  show.fillMode = kCAFillModeForwards;
  show.duration = duration;
  show.beginTime = start;
  start = start + duration + pause;
  show.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
  [show setToValue: [NSNumber numberWithFloat: 1.0]];
  
  //-----------------------------------------------------------------------
  //Create a move animation to move the image view to a different spot
  //-----------------------------------------------------------------------
  [messagesArray addObject: [MessageObject message: @"Move" startTime: start/animationSpeed]];


  oldOrigin = imageOne.layer.position;
  CGPoint newOrigin = CGPointMake(oldOrigin.x + 330, oldOrigin.y - 100);
  CABasicAnimation* move =  [CABasicAnimation animationWithKeyPath: @"position"];
  move.removedOnCompletion = FALSE;
  move.fillMode = kCAFillModeForwards;
  move.duration = duration;
  move.beginTime = start;
  
  start = start + duration;
  move.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
  [move setToValue: [NSValue valueWithCGPoint: newOrigin]];
  
  
  //-----------------------------------------------------------------------
  //Create a figure 8 animation (Using CAKeyframeAnimation)
  //-----------------------------------------------------------------------
  [messagesArray addObject: [MessageObject message: @"Figure 8" startTime: start/animationSpeed]];

  CAKeyframeAnimation* figure8 = nil;
  figure8=  [CAKeyframeAnimation animationWithKeyPath: @"position"];
  figure8.removedOnCompletion = FALSE;
  figure8.fillMode = kCAFillModeForwards;
  figure8.duration = 2;
  figure8.beginTime = start;
  figure8.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

  
  //Create a CGPath to hold the figure 8
  CGMutablePathRef figure8Path;
  figure8Path = CGPathCreateMutable();
  CGFloat left, right, middleX, bottom, top, middleY;
  CGFloat boxHalfWidth = 175;
  
  //Calculate the points use to create the figure 8 path.
  middleX = newOrigin.x;
  left = middleX - boxHalfWidth;
  right = middleX + boxHalfWidth;
  
  bottom = newOrigin.y;
  middleY = bottom - boxHalfWidth * 2;
  top = middleY - boxHalfWidth * 2;
  
  
  CGPathMoveToPoint(figure8Path, NULL, middleX, bottom);
  
  //Make the first S of the figure 8
  CGPathAddCurveToPoint(figure8Path, NULL, right, bottom, right, middleY, middleX, middleY);
  CGPathAddCurveToPoint(figure8Path, NULL, left, middleY, left, top, middleX, top);
  
  //Loop down in a reverse S for the second half of a figure 8
  CGPathAddCurveToPoint(figure8Path, NULL, right, top, right, middleY, middleX, middleY);
  CGPathAddCurveToPoint(figure8Path, NULL, left, middleY, left, bottom, middleX, bottom);

  //Make the figure 8 do 2 full cycles.
  figure8.repeatCount = 2;
  
  
  start = start + figure8.duration * figure8.repeatCount + pause;
  figure8.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
  
  //install the path in the CAKeyframeAnimation
  [figure8 setPath: figure8Path];
  
  
  //Also install the path into our view's layer so you can see the figure 8 shape.
  //The shape layer is set up as a CAShapeLayer
  CAShapeLayer *shapeLayer = (CAShapeLayer *)[myContainerView layer];
  shapeLayer.path = figure8Path;
  shapeLayer.lineWidth = 1.0;
  shapeLayer.strokeColor = [[UIColor grayColor] CGColor];
  shapeLayer.fillColor = [[UIColor clearColor] CGColor];
  shapeLayer.lineDashPattern = [NSArray arrayWithObjects: 
                                [NSNumber numberWithInt: 5], 
                                [NSNumber numberWithInt: 9], 
                                nil];
  
  //Release our figure 8 path now that we are done with it.
  CFRelease(figure8Path);
  
  
  //-----------------------------------------------------------------------
  //Create a rotation animation.
  //This shows how to use a repeating animation of less than 180 degrees, set to "cumulative", 
  //to do full circle rotations.
  //-----------------------------------------------------------------------
  [messagesArray addObject: [MessageObject message: @"Rotate" startTime: start/animationSpeed]];

  CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
  rotate.removedOnCompletion = FALSE;
  rotate.fillMode = kCAFillModeForwards;
  
  //Do a series of 5 quarter turns for a total of a 1.25 turns
  //(2PI is a full turn, so pi/2 is a quarter turn)
  [rotate setToValue: [NSNumber numberWithFloat: -M_PI / 2]];
  rotate.repeatCount = 11;

  rotate.duration = duration/2;
  rotate.beginTime = start;
  rotate.cumulative = TRUE;
  rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

  
  start = start + rotate.duration * rotate.repeatCount + pause;
  
  //-----------------------------------------------------------------------
  //Create an animation to move the image back down to it's starting y position.
  //-----------------------------------------------------------------------
  [messagesArray addObject: [MessageObject message: @"Move Down" startTime: start/animationSpeed]];
  newOrigin = CGPointMake(newOrigin.x, newOrigin.y + 100);
  CABasicAnimation* moveDown =  [CABasicAnimation animationWithKeyPath: @"position"];
  moveDown.removedOnCompletion = FALSE;
  moveDown.fillMode = kCAFillModeForwards;
  moveDown.duration = duration;
  moveDown.beginTime = start;
  moveDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
  [moveDown setToValue: [NSValue valueWithCGPoint: newOrigin]];
  
  start = start + duration + pause;
  
  //-----------------------------------------------------------------------
  //Create an animation to rotate the image back to 0 degrees.
  //-----------------------------------------------------------------------
  [messagesArray addObject: [MessageObject message: @"Rotate Back" startTime: start/animationSpeed]];

  CABasicAnimation* rotateBack =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
  rotateBack.removedOnCompletion = FALSE;
  rotateBack.fillMode = kCAFillModeForwards;
  rotateBack.duration = duration;
  rotateBack.beginTime = start;
  start = start + duration + pause;
  rotateBack.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  [rotateBack setToValue: [NSNumber numberWithFloat: 0.0]];
  
  //-----------------------------------------------------------------------
  //Create an animation to hide the image.
  //-----------------------------------------------------------------------
  start +=.2;
  [messagesArray addObject: [MessageObject message: @"Hide" startTime: start/animationSpeed]];

  CABasicAnimation* hide =  [CABasicAnimation animationWithKeyPath: @"opacity"];
  hide.removedOnCompletion = FALSE;
  hide.fillMode = kCAFillModeForwards;
  hide.duration = duration;
  hide.beginTime = start;
  totalDuration = start + duration + pause;
  hide.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  [hide setToValue: [NSNumber numberWithFloat: 0.0]];
  
  
  //-----------------------------------------------------------------------
  //Create a group animation that will hold all the steps in our total animation.
  //-----------------------------------------------------------------------
  CAAnimationGroup* group = [CAAnimationGroup animation];
  [group setDuration: totalDuration];
  group.removedOnCompletion = FALSE;
  group.fillMode = kCAFillModeForwards;
  [group setAnimations: [NSArray arrayWithObjects: show, move, figure8, rotate, moveDown, rotateBack, hide, nil]];
  group.speed = animationSpeed;//play the animation slowly
  
  //Set up a block of code that gets executed when the group animation completes.
  theBlock = ^void(void)
  {    
    stopAnimationButton.enabled = FALSE;
    
    [imageOne.layer removeAllAnimations];
    self.animationInFlight = FALSE;
    animateButton.enabled = TRUE;
    viewAnimationButton.enabled = TRUE;

    shapeLayer.path = nil;
    animationStepView.hidden = TRUE;
    tapInstructionsLabel.hidden = TRUE;
    //If the animation was paused, cancel the pause so it runs correctly next time.
    if (myContainerView.layer.speed == 0)
      [self removePauseForLayer: myContainerView.layer];
  };
  
  /*
   Install the completion block in the animation using the key kAnimationCompletionBlock
   The completion block will be run by in the group animation's animationDidStop:finished delegate method.
   This approach doesn't work for animations that are part of a group, unfortunately, since an animation's
   delegate methods don't get called when the animation is part of an animation group
   */
  
  [group setValue: theBlock forKey: kAnimationCompletionBlock];
  
  //Make this view controller the group animation's delegate so we get an animationDidStop:finished call 
  //When the animation is finished.
  group.delegate = self;
  
  
  //Install the animation group into the image view's layer.
  [imageOne.layer addAnimation: group forKey:  nil];
  animationStartTime = [myContainerView.layer convertTime: CACurrentMediaTime() fromLayer: nil];
  
  //Queue messages for each animation step, starting at the beginning of the animation.
  [self queueMessagesAtTime: 0];
}

//-----------------------------------------------------------------------------------------------------------
/*
 This method shows how to use UIView animation blocks, and use the same tap view gesture recognizer 
 to freeze all animations on the parent layer
 */

- (IBAction)doViewAnimation:(id)sender;
{
  
  stopAnimationButton.enabled = TRUE; //Enable the stop button
  
  //Disable the 2 animation buttons while the animation is running.
  animateButton.enabled = FALSE;
  viewAnimationButton.enabled = FALSE;
  
  //Set a flag so we know that we're doing a view-based animation instead of the animation group animation
  doingViewAnimation = TRUE;
  
  //Save the center point of the image view so we can restore it in the completion block.
  CGPoint imageOneCenter = imageOne.center;
  
  
  NSLog(@"In %s", __PRETTY_FUNCTION__);
  self.animationInFlight = TRUE;
  [UIView animateWithDuration: 3.0
                        delay: 0.0 
                      options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
   
                   animations: ^{
                     
                     //Animate moving the image view diagonally across the screen.
                     imageOne.center = CGPointMake(668, 100);
                     
                     //Make it grow by 50% as it moves
                     CATransform3D layerTransform = CATransform3DMakeScale(1.5, 1.5, 1.0);
                     
                     //Also make it rotate 180 degrees. Note that you can't roate more than 180
                     //degrees this way, because the system can't tell the difference between a 
                     //clockwize 270 degree rotation and a counterclockwize 90 degree rotation.
                     //The layer-based animation in the "doAnimation" shows how to rotate more than
                     //180 degrees by using a repeating animation of less than 180 degrees.
                     layerTransform = CATransform3DRotate(layerTransform, M_PI, 0, 0, 1);
                     
                     imageOne.layer.transform = layerTransform;
                   } 
   
                   completion: ^(BOOL finished) {
                     NSLog(@"Animation completed");
                     animateButton.enabled = TRUE;
                     viewAnimationButton.enabled = TRUE;
                     imageOne.center = imageOneCenter;
                     imageOne.layer.transform = CATransform3DIdentity;
                     stopAnimationButton.enabled = FALSE;
                     if (myContainerView.layer.speed == 0)
                       [self removePauseForLayer: myContainerView.layer];
                     doingViewAnimation = FALSE;
                   }
   ];
}

//-----------------------------------------------------------------------------------------------------------

- (void) pauseLayer: (CALayer *) theLayer
{
  CFTimeInterval mediaTime = CACurrentMediaTime();
  CFTimeInterval pausedTime = [theLayer convertTime: mediaTime fromLayer: nil];
  theLayer.speed = 0.0;
  theLayer.timeOffset = pausedTime;
}

//-----------------------------------------------------------------------------------------------------------

- (void) removePauseForLayer: (CALayer *) theLayer;
{
  theLayer.speed = 1.0;
  theLayer.timeOffset = 0.0;
  theLayer.beginTime = 0.0;
}

//-----------------------------------------------------------------------------------------------------------

- (void) resumeLayer: (CALayer *) theLayer;
{
  CFTimeInterval pausedTime = [theLayer timeOffset];
  [self removePauseForLayer: theLayer];
  CFTimeInterval mediaTime = CACurrentMediaTime();
  CFTimeInterval timeSincePause = [theLayer convertTime: mediaTime fromLayer: nil] - pausedTime;
  theLayer.beginTime = timeSincePause;
  if (!doingViewAnimation)
  {
  [self queueMessagesAtTime: mediaTime - animationStartTime - timeSincePause];
  animationStepView.hidden = FALSE;
  }
}

//-----------------------------------------------------------------------------------------------------------

/*
 This method gets called from a tap gesture recognizer installed on the view myContainerView.
 We get the coordinates of the tap from the gesture recognizer and use it to hit-test 
 myContainerView.layer.presentationLayer to see if the user tapped on the moving image view's 
 (presentation) layer. The presentation layer's properties are updated as the animation runs, so hit-testing
 the presentation layer lets you do tap and/or collision tests on the "in flight" animation.
 */

- (IBAction)testViewTapped:(id)sender 
{
  CALayer *tappedLayer;
  id layerDelegate;
  UITapGestureRecognizer *theTapper = (UITapGestureRecognizer *)sender;
  CGPoint touchPoint = [theTapper locationInView: myContainerView];
  if (animationInFlight)
  {
    tappedLayer = [myContainerView.layer.presentationLayer hitTest: touchPoint];
    layerDelegate = [tappedLayer delegate];
    
    if (layerDelegate == imageOne)
    {
      if (myContainerView.layer.speed == 0)
        [self resumeLayer: myContainerView.layer];
      else
      {
        [self pauseLayer: myContainerView.layer];
                
        //Also kill all the pending label changes that we set up using performSelector:withObject:afterDelay
        [NSObject cancelPreviousPerformRequestsWithTarget: animationStepLabel];
      }
    }
  }
}

//-----------------------------------------------------------------------------------------------------------

- (IBAction)stopAnimation:(id)sender 
{
  [imageOne.layer removeAllAnimations];
  //Also kill all the pending label changes that we set up using performSelector:withObject:afterDelay
  [NSObject cancelPreviousPerformRequestsWithTarget: animationStepLabel];

}

//-----------------------------------------------------------------------------------------------------------
#pragma mark - CAAnimation delegate methods
//-----------------------------------------------------------------------------------------------------------
/*
 This method looks for a value added to the animation that just completed 
 with the key kAnimationCompletionBlock.
 If it exists, it assumes it is a code block of type animationCompletionBlock, and executes the code block.
 This allows you to add a custom block of completion code to any animation or animation group, rather than
 Having a big complicated switch statement in your animationDidStop:finished: method with global animation
 Completion code.
 (Note that the system won't call the animationDidStop:finished method for individual animations in an
 Animation group - it will only call the completion method for the entire group. Thus, if you want to run
 code after part of an animation group completes, you have to set up a manual timer.
*/

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
  animationCompletionBlock theBlock = [theAnimation valueForKey: kAnimationCompletionBlock];
  if (theBlock)
    theBlock();
}

//-----------------------------------------------------------------------------------------------------------

@end
