//
//  GCDObject.h
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

@interface GCDObject : NSObject

@property (assign, readonly, nonatomic) dispatch_object_t dispatchObject;
@property (assign, readwrite, nonatomic) void *context;

+ (void)syncBlock:(dispatch_block_t)block once:(dispatch_once_t *)once;
+ (void)syncFunction:(dispatch_function_t)function withContext:(void *)context once:(dispatch_once_t *)once;

- (id)initWithDispatchObject:(dispatch_object_t)dispatchObject;

- (void)setFinalizerFunction:(dispatch_function_t)function;
- (void)logDebugWithMessage:(NSString *)message;

@end
