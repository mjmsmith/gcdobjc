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

- (id)init {
  return [self initWithValue:0];
}

- (id)initWithValue:(long)value {
  return [super initWithDispatchObject:dispatch_semaphore_create(value)];
}

- (void)dealloc {
  dispatch_release(self.dispatchSemaphore);
}

#pragma mark Public methods.

- (long)signal {
  return dispatch_semaphore_signal(self.dispatchSemaphore);
}

- (long)wait {
  return dispatch_semaphore_wait(self.dispatchSemaphore, DISPATCH_TIME_FOREVER);
}

- (long)wait:(double)seconds {
  return dispatch_semaphore_wait(self.dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, (seconds * NSEC_PER_SEC)));
}

- (dispatch_semaphore_t)dispatchSemaphore {
  return self.dispatchObject._dsema;
}


@end
