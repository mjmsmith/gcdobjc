//
//  GCDSemaphore.m
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import "GCDSemaphore.h"

@interface GCDSemaphore ()
@end

@implementation GCDSemaphore

#pragma mark Lifecycle.

- (instancetype)init {
  return [self initWithValue:0];
}

- (instancetype)initWithValue:(long)value {
  return [self initWithDispatchSemaphore:dispatch_semaphore_create(value)];
}

- (instancetype)initWithDispatchSemaphore:(dispatch_semaphore_t)dispatchSemaphore {
  return [super initWithDispatchObject:dispatchSemaphore];
}

#pragma mark Public methods.

- (BOOL)signal {
  return dispatch_semaphore_signal(self.dispatchSemaphore) != 0;
}

- (void)wait {
  dispatch_semaphore_wait(self.dispatchSemaphore, DISPATCH_TIME_FOREVER);
}

- (BOOL)wait:(double)seconds {
  return dispatch_semaphore_wait(self.dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, (seconds * NSEC_PER_SEC))) == 0;
}

- (dispatch_semaphore_t)dispatchSemaphore {
  return self.dispatchObject._dsema;
}

@end
