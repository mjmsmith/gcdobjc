//
//  GCDObject.m
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import "GCDObject.h"

@interface GCDObject ()
@property (assign, readwrite, nonatomic) dispatch_object_t dispatchObject;
@end

@implementation GCDObject

#pragma mark Static once methods.

+ (void)syncBlock:(dispatch_block_t)block once:(dispatch_once_t *)once {
  dispatch_once(once, block);
}

#pragma mark Lifecycle.

- (instancetype)initWithDispatchObject:(dispatch_object_t)dispatchObject {
  if ((self = [super init]) != nil) {
    self.dispatchObject = dispatchObject;
  }
  
  return self;
}

- (void)dealloc {
  dispatch_release(self.dispatchObject);
}

#pragma mark Public methods.

- (void)logDebugWithMessage:(NSString *)message {
  dispatch_debug(self.dispatchObject, "%s", [message cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
