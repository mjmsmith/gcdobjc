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

#pragma mark Construction.

- (id)initWithValue:(long)value {
  return [super initWithDispatchObject:dispatch_semaphore_create(value)];
}

- (void)dealloc {
  dispatch_release(self.dispatchSemaphore);
}

#pragma mark Public methods.

- (long)signal {
  return dispatch_semaphore_signal([self dispatchSemaphore]);
}

- (long)wait:(dispatch_time_t)timeout {
  return dispatch_semaphore_wait([self dispatchSemaphore], timeout);
}

- (dispatch_semaphore_t)dispatchSemaphore {
  return self.dispatchObject._dsema;
}


@end
