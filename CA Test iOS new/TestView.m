//
//  TestView.m
//  CA Test iOS new
//
//  Created by Duncan Champney on 3/21/12.
//  Copyright (c) 2012 WareTo. All rights reserved.
//

#import "TestView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TestView


//Tell the system that we want our baking layer to be a CAShapeLayer.
+ (Class)layerClass
{
  return [CAShapeLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


@end
