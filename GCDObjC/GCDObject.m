//
//  GCDObject.m
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import "GCDObject.h"

@implementation GCDObject

@synthesize dispatchObject = _dispatchObject;

#pragma mark Construction.

- (id)initWithDispatchObject:(dispatch_object_t)dispatchObject {
  if ((self = [super init]) != nil) {
    _dispatchObject = dispatchObject;
  }
  
  return self;
}

- (void)dealloc {
  dispatch_release(self.dispatchObject);
}

#pragma mark Public methods.

- (void *)context {
  return dispatch_get_context(self.dispatchObject);
}

- (void)setContext:(void *)context {
  return dispatch_set_context(self.dispatchObject, context);
}

- (void)setFinalizerFunction:(dispatch_function_t)function {
  dispatch_set_finalizer_f(self.dispatchObject, function);
}

- (void)logDebugWithMessage:(NSString *)message {
  dispatch_debug(self.dispatchObject, "%s", [message cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
