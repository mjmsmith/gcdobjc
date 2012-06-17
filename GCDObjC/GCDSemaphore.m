//
//  GCDSemaphore.m
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import "GCDSemaphore.h"

@interface GCDSemaphore ()
@property (unsafe_unretained, nonatomic, readwrite) dispatch_semaphore_t dispatchSemaphore;
@end

@implementation GCDSemaphore

@synthesize dispatchSemaphore = _dispatchSemaphore;

#pragma mark Construction.

- (id)initWithValue:(long)value {
  if ((self = [super init]) != nil) {
    _dispatchSemaphore = dispatch_semaphore_create(value);
  }
  
  return self;
}

- (void)dealloc {
  dispatch_release(_dispatchSemaphore);
  _dispatchSemaphore = NULL;
}

#pragma mark Public methods.

- (long)signal {
  return dispatch_semaphore_signal([self dispatchSemaphore]);
}

- (long)wait:(dispatch_time_t)timeout {
  return dispatch_semaphore_wait([self dispatchSemaphore], timeout);
}

@end
