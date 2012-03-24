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
//  NSMutableArray *messagesArray;
  
  //outlets
  __weak IBOutlet UIView *myContainerView;
  __weak IBOutlet UIImageView *imageOne;
  __weak IBOutlet UIButton *animateButton;
  __weak IBOutlet UILabel *animationStepLabel;
  __weak IBOutlet UIButton *stopAnimationButton;
  __weak IBOutlet UILabel *tapInstructionsLabel;
  __weak IBOutlet UIView *animationStepView;
  CFTimeInterval animationStartTime;
}

@property (nonatomic, weak) IBOutlet UIView *myContainerView;
@property (nonatomic) BOOL animationInFlight;
@property (nonatomic) NSMutableArray *messagesArray;

- (IBAction)doAnimation:(id)sender;
- (IBAction)testViewTapped:(id)sender;
- (IBAction)stopAnimation:(id)sender;

@end
