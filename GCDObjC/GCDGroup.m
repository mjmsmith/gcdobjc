//
//  GCDGroup.m
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import "GCDGroup.h"

@implementation GCDGroup

@synthesize dispatchGroup = _dispatchGroup;

#pragma mark Construction.

- (id)init {
  if ((self = [super init]) != nil) {
    _dispatchGroup = dispatch_group_create();
  }
  
  return self;
}

- (void)dealloc {
  dispatch_release(_dispatchGroup);
  _dispatchGroup = NULL;
}

#pragma mark Public methods.

- (void)enter {
  dispatch_group_enter(self.dispatchGroup);
}

- (void)leave {
  dispatch_group_leave(self.dispatchGroup);
}

- (long)wait:(dispatch_time_t)timeout {
  return dispatch_group_wait(self.dispatchGroup, timeout);
}

@end
