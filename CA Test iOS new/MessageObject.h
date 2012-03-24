//
//  MessageObject.h
//  CA Test iOS new
//
//  Created by Duncan Champney on 3/24/12.
//  Copyright (c) 2012 WareTo. All rights reserved.
//

/*
 This is a simple data container object to hold the information needed to track messages that are displayed at each step in the animation process
 */

#import <Foundation/Foundation.h>

@interface MessageObject : NSObject
 {

 }
 
@property (nonatomic) CFTimeInterval startTime;
@property (nonatomic) NSString *message;


+ (MessageObject *) message: (NSString *) message 
                  startTime: (CFTimeInterval) time;

@end
