//
//  GCDQueue.h
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

@class GCDGroup;

@interface GCDQueue : NSObject

+ (GCDQueue *)mainQueue;
+ (GCDQueue *)globalQueueWithPriority:(long)priority flags:(unsigned long)flags;
+ (GCDQueue *)currentQueue;

- (id)initSerialWithLabel:(NSString *)label;
- (id)initConcurrentWithLabel:(NSString *)label;
- (id)initWithDispatchQueue:(dispatch_queue_t)dispatchQueue;

- (NSString *)label;

- (void)dispatchAsyncBlock:(dispatch_block_t)block;
- (void)dispatchAsyncBlock:(dispatch_block_t)block inGroup:(GCDGroup *)group;
- (void)dispatchNotifyBlock:(dispatch_block_t)block forGroup:(GCDGroup *)group;
- (void)dispatchBarrierAsyncBlock:(dispatch_block_t)block;

- (void)dispatchAsyncFunction:(dispatch_function_t)function withContext:(void *)context;
- (void)dispatchAsyncFunction:(dispatch_function_t)function withContext:(void *)context inGroup:(GCDGroup *)group;
- (void)dispatchNotifyFunction:(dispatch_function_t)function withContext:(void *)context forGroup:(GCDGroup *)group;
- (void)dispatchBarrierAsyncFunction:(dispatch_function_t)function withContext:(void *)context;

- (void)dispatchSyncBlock:(dispatch_block_t)block;
- (void)dispatchBarrierSyncBlock:(dispatch_block_t)block;

- (void)dispatchSyncFunction:(dispatch_function_t)function withContext:(void *)context;
- (void)dispatchBarrierSyncFunction:(dispatch_function_t)function withContext:(void *)context;

@end
