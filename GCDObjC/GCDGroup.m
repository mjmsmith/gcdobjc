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

- (long)wait {
  return dispatch_group_wait(self.dispatchGroup, DISPATCH_TIME_FOREVER);
}

- (long)wait:(double)seconds {
  return dispatch_group_wait(self.dispatchGroup, dispatch_time(DISPATCH_TIME_NOW, (seconds * NSEC_PER_SEC)));
}

- (dispatch_group_t)dispatchGroup {
  return self.dispatchObject._dg;
}



@end
