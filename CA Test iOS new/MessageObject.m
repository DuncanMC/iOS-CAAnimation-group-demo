//
//  MessageObject.m
//  CA Test iOS new
//
//  Created by Duncan Champney on 3/24/12.
//  Copyright (c) 2012 WareTo. All rights reserved.
//

#import "MessageObject.h"


@implementation MessageObject

@synthesize startTime;
@synthesize message;


+ (MessageObject *) message: (NSString *) message 
                  startTime: (CFTimeInterval) time;
{
  MessageObject *result = [[MessageObject alloc] init] ;
  result.startTime = time;
  result.message = message;
  return result;
}

- (NSString *) description;
{
  return [NSString stringWithFormat:@"Message string = \"%@\", time = %.3f", message, startTime];
}

@end
