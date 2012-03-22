//
//  TestView.h
//  CA Test iOS new
//
//  Created by Duncan Champney on 3/21/12.
//  Copyright (c) 2012 WareTo. All rights reserved.
//

//This is a custom subclass of UIView. 
//The only thing it does that's different is to implement the class method +layerClass
//Implementing that method lets you make a view's layer use a different type of CALayer.
//In our case, we make the view's layer a CAShapeLayer so we can install a path into the layer.

#import <UIKit/UIKit.h>

@interface TestView : UIView

@end
