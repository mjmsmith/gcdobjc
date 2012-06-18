//
//  GCDQueue.h
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

#import "GCDObject.h"

@class GCDGroup;

@interface GCDQueue : GCDObject

@property (unsafe_unretained, readonly, nonatomic) dispatch_queue_t dispatchQueue;

+ (GCDQueue *)mainQueue;
+ (GCDQueue *)globalQueueWithPriority:(long)priority flags:(unsigned long)flags;
+ (GCDQueue *)currentQueue;

- (id)initSerial;
- (id)initSerialWithLabel:(NSString *)label;
- (id)initConcurrent;
- (id)initConcurrentWithLabel:(NSString *)label;
- (id)initWithLabel:(NSString *)label attr:(dispatch_queue_attr_t)attr;

- (void)dispatchBlock:(dispatch_block_t)block;
- (void)dispatchBlock:(dispatch_block_t)block inGroup:(GCDGroup *)group;
- (void)dispatchBlock:(dispatch_block_t)block afterSeconds:(double)seconds;

- (void)dispatchBarrierBlock:(dispatch_block_t)block;
- (void)dispatchNotifyBlock:(dispatch_block_t)block inGroup:(GCDGroup *)group;

- (void)dispatchSyncBlock:(dispatch_block_t)block;
- (void)dispatchSyncBlock:(void (^)(size_t))block forIterations:(size_t)iterations;

- (void)dispatchSyncBarrierBlock:(dispatch_block_t)block;

- (void)dispatchFunction:(dispatch_function_t)function withContext:(void *)context;
- (void)dispatchFunction:(dispatch_function_t)function withContext:(void *)context inGroup:(GCDGroup *)group;
- (void)dispatchFunction:(dispatch_function_t)function withContext:(void *)context afterSeconds:(double)seconds;

- (void)dispatchBarrierFunction:(dispatch_function_t)function withContext:(void *)context;
- (void)dispatchNotifyFunction:(dispatch_function_t)function withContext:(void *)context inGroup:(GCDGroup *)group;

- (void)dispatchSyncFunction:(dispatch_function_t)function withContext:(void *)context;
- (void)dispatchSyncFunction:(void (*)(void *, size_t))function withContext:(void *)context forIterations:(size_t)iterations;

- (void)dispatchSyncBarrierFunction:(dispatch_function_t)function withContext:(void *)context;

- (void)suspend;
- (void)resume;

- (NSString *)label;

- (void)setContext:(void *)context forKey:(const void *)key destructor:(dispatch_function_t)destructor;
- (void *)contextForKey:(const void *)key;

@end
