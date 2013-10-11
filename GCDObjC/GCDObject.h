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

+ (void)syncBlock:(dispatch_block_t)block once:(dispatch_once_t *)once;

- (instancetype)initWithDispatchObject:(dispatch_object_t)dispatchObject;

- (void)logDebugWithMessage:(NSString *)message;

@end
