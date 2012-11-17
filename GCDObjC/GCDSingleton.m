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

- (void)syncBlock:(dispatch_block_t)block {
  dispatch_once(&_once, block);
}

- (void)syncFunction:(dispatch_function_t)function withContext:(void *)context {
  dispatch_once_f(&_once, context, function);
}

@end
