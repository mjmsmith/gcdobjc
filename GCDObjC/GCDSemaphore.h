//
//  GCDSemaphore.h
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

@interface GCDSemaphore : NSObject

@property (unsafe_unretained, nonatomic, readonly) dispatch_semaphore_t dispatchSemaphore;

- initWithValue:(long)value;

- (long)signal;
- (long)wait:(dispatch_time_t)timeout;

@end