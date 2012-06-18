//
//  GCDGroup.m
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import "GCDGroup.h"

@implementation GCDGroup

#pragma mark Construction.

- (id)init {
  return [super initWithDispatchObject:dispatch_group_create()];
}

- (void)dealloc {
  dispatch_release(self.dispatchGroup);
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

- (dispatch_group_t)dispatchGroup {
  return self.dispatchObject._dg;
}



@end
