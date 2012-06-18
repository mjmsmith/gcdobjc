//
//  GCDSingleton.m
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import "GCDSingleton.h"

@interface GCDSingleton ()
@property (assign, readwrite, nonatomic) dispatch_once_t once;
@end

@implementation GCDSingleton

@synthesize once = _once;

- (void)dispatchBlock:(dispatch_block_t)block {
  dispatch_once(&_once, block);
}

- (void)dispatchFunction:(dispatch_function_t)function withContext:(void *)context {
  dispatch_once_f(&_once, function, context);
}

@end
