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
  
  //outlets
  __weak IBOutlet UIView *myContainerView;
  __weak IBOutlet UIImageView *imageOne;
  __weak IBOutlet UIButton *animateButton;
  __weak IBOutlet UILabel *animationStepLabel;
  __weak IBOutlet UIButton *stopAnimationButton;
  __weak IBOutlet UILabel *tapInstructionsLabel;
  __weak IBOutlet UIView *animationStepView;
}

@property (nonatomic, weak) IBOutlet UIView *myContainerView;
@property (nonatomic) BOOL animationInFlight;

- (IBAction)doAnimation:(id)sender;
- (IBAction)testViewTapped:(id)sender;
- (IBAction)stopAnimation:(id)sender;

@end
