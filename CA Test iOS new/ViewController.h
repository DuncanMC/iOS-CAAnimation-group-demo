//
//  ViewController.h
//  CA Test iOS
//
//  Created by Duncan Champney on 3/21/12.
//  Copyright (c) 2012 WareTo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^animationCompletionBlock)(void);
#define kAnimationCompletionBlock @"animationCompletionBlock"

@interface ViewController : UIViewController
{
  BOOL animationInFlight;
  BOOL doingMaskAnimation;
//  NSMutableArray *messagesArray;
  
  //outlets
  __weak IBOutlet UIView *myContainerView;
  __weak IBOutlet UIImageView *imageOne;
  __weak IBOutlet UIButton *animateButton;
  __weak IBOutlet UIButton *viewAnimationButton;
  __weak IBOutlet UIButton *maskAnimationButton;

  __weak IBOutlet UILabel *animationStepLabel;
  __weak IBOutlet UIButton *stopAnimationButton;
  __weak IBOutlet UILabel *tapInstructionsLabel;
  __weak IBOutlet UIView *animationStepView;
  __weak IBOutlet UIImageView *waretoLogoLarge;
  CFTimeInterval animationStartTime;
  BOOL doingViewAnimation;
}

@property (nonatomic, weak) IBOutlet UIView *myContainerView;
@property (nonatomic) BOOL animationInFlight;
@property (nonatomic, strong) NSMutableArray *messagesArray;

- (IBAction)doAnimation:(id)sender;
- (IBAction)doViewAnimation:(id)sender;
- (IBAction)doMaskAnimation:(id)sender;

- (IBAction)testViewTapped:(id)sender;
- (IBAction)stopAnimation:(id)sender;

@end
