//
//  GCDSemaphore.h
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

#import "GCDObject.h"

@interface GCDSemaphore : GCDObject

@property (assign, readonly, nonatomic) dispatch_semaphore_t dispatchSemaphore;

- initWithValue:(long)value;

- (long)signal;
- (long)wait;
- (long)wait:(double)seconds;

@end