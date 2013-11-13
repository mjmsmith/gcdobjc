//
//  GCDGroup.m
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import "GCDGroup.h"

@interface GCDGroup ()
@end

@implementation GCDGroup

#pragma mark Lifecycle.

- (instancetype)init {
  return [self initWithDispatchGroup:dispatch_group_create()];
}

- (instancetype)initWithDispatchGroup:(dispatch_group_t)dispatchGroup {
  return [super initWithDispatchObject:dispatchGroup];
}

#pragma mark Public methods.

- (void)enter {
  dispatch_group_enter(self.dispatchGroup);
}

- (void)leave {
  dispatch_group_leave(self.dispatchGroup);
}

- (void)wait {
  dispatch_group_wait(self.dispatchGroup, DISPATCH_TIME_FOREVER);
}

- (BOOL)wait:(double)seconds {
  return dispatch_group_wait(self.dispatchGroup, dispatch_time(DISPATCH_TIME_NOW, (seconds * NSEC_PER_SEC))) == 0;
}

- (dispatch_group_t)dispatchGroup {
  return self.dispatchObject._dg;
}

@end
