//
//  GCDSingleton.h
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

@interface GCDSingleton : NSObject

- (void)dispatchBlock:(dispatch_block_t)block;
- (void)dispatchFunction:(dispatch_function_t)function withContext:(void *)context;

@end
