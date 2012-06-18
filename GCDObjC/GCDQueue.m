//
//  GCDQueue.m
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import "GCDGroup.h"
#import "GCDQueue.h"

static dispatch_queue_t mainDispatchQueue;

@interface GCDQueue ()
- (id)initWithDispatchQueue:(dispatch_queue_t)dispatchQueue;
@end

@implementation GCDQueue

#pragma mark Static methods.

+ (void)initialize {
  if ([self class] == [GCDQueue class]) {
    mainDispatchQueue = dispatch_get_main_queue();
  }
}  

+ (GCDQueue *)mainQueue {
  return [[GCDQueue alloc] initWithDispatchQueue:mainDispatchQueue];
}

+ (GCDQueue *)globalQueueWithPriority:(long)priority flags:(unsigned long)flags {
  return [[GCDQueue alloc] initWithDispatchQueue:dispatch_get_global_queue(priority, flags)];
}

+ (GCDQueue *)currentQueue {
  return [[GCDQueue alloc] initWithDispatchQueue:dispatch_get_current_queue()];
}

#pragma mark Construction.

- (id)initSerial {
  return [self initWithLabel:nil attr:DISPATCH_QUEUE_SERIAL];
}

- (id)initSerialWithLabel:(NSString *)label {
  return [self initWithLabel:label attr:DISPATCH_QUEUE_SERIAL];
}

- (id)initConcurrent {
  return [self initWithLabel:nil attr:DISPATCH_QUEUE_CONCURRENT];
}

- (id)initConcurrentWithLabel:(NSString *)label {
  return [self initWithLabel:label attr:DISPATCH_QUEUE_CONCURRENT];
}

- (id)initWithLabel:(NSString *)label attr:(dispatch_queue_attr_t)attr {
  return [super initWithDispatchObject:dispatch_queue_create([label cStringUsingEncoding:NSASCIIStringEncoding], attr)];
}

- (id)initWithDispatchQueue:(dispatch_queue_t)dispatchQueue {
  return [super initWithDispatchObject:dispatchQueue];
}

- (void)dealloc {
  if (self.dispatchQueue != mainDispatchQueue) {
    dispatch_release(self.dispatchQueue);
  }
}

#pragma mark Public block methods.

- (void)dispatchBlock:(dispatch_block_t)block {
  dispatch_async(self.dispatchQueue, block);
}

- (void)dispatchBlock:(dispatch_block_t)block inGroup:(GCDGroup *)group {
  dispatch_group_async(group.dispatchGroup, self.dispatchQueue, block);
}

- (void)dispatchBlock:(dispatch_block_t)block afterSeconds:(double)seconds {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (seconds * NSEC_PER_SEC)), self.dispatchQueue, block);
}

- (void)dispatchBarrierBlock:(dispatch_block_t)block {
  dispatch_barrier_async(self.dispatchQueue, block);
}

- (void)dispatchNotifyBlock:(dispatch_block_t)block inGroup:(GCDGroup *)group {
  dispatch_group_notify(group.dispatchGroup, self.dispatchQueue, block);
}

- (void)dispatchSyncBlock:(dispatch_block_t)block {
  dispatch_sync(self.dispatchQueue, block);
}

- (void)dispatchSyncBlock:(void (^)(size_t))block forIterations:(size_t)iterations {
  dispatch_apply(iterations, self.dispatchQueue, block);
}

- (void)dispatchSyncBarrierBlock:(dispatch_block_t)block {
  dispatch_barrier_sync(self.dispatchQueue, block);
}

#pragma mark Public function methods.

- (void)dispatchFunction:(dispatch_function_t)function withContext:(void *)context {
  dispatch_async_f(self.dispatchQueue, context, function);
}

- (void)dispatchFunction:(dispatch_function_t)function withContext:(void *)context inGroup:(GCDGroup *)group {
  dispatch_group_async_f(group.dispatchGroup, self.dispatchQueue, context, function);
}

- (void)dispatchFunction:(dispatch_function_t)function withContext:(void *)context afterSeconds:(double)seconds {
  dispatch_after_f(dispatch_time(DISPATCH_TIME_NOW, (seconds * NSEC_PER_SEC)), self.dispatchQueue, context, function);
}

- (void)dispatchBarrierFunction:(dispatch_function_t)function withContext:(void *)context {
  dispatch_barrier_async_f(self.dispatchQueue, context, function);
}

- (void)dispatchNotifyFunction:(dispatch_function_t)function withContext:(void *)context inGroup:(GCDGroup *)group {
  dispatch_group_notify_f(group.dispatchGroup, self.dispatchQueue, context, function);
}

- (void)dispatchSyncFunction:(dispatch_function_t)function withContext:(void *)context {
  dispatch_sync_f(self.dispatchQueue, context, function);
}

- (void)dispatchSyncFunction:(void (*)(void *, size_t))function withContext:(void *)context forIterations:(size_t)iterations {
  dispatch_apply_f(iterations, self.dispatchQueue, context, function);
}

- (void)dispatchSyncBarrierFunction:(dispatch_function_t)function withContext:(void *)context {
  dispatch_barrier_sync_f(self.dispatchQueue, context, function);
}

#pragma mark Misc public methods.

- (void)suspend {
  dispatch_suspend(self.dispatchQueue);
}

- (void)resume {
  dispatch_resume(self.dispatchQueue);
}

- (NSString *)label {
  const char *value = dispatch_queue_get_label(self.dispatchQueue);
  
  if (value == NULL) {
    return nil;
  }
  
  return [NSString stringWithCString:value encoding:NSASCIIStringEncoding];
}

- (void)setContext:(void *)context forKey:(const void *)key destructor:(dispatch_function_t)destructor {
  dispatch_queue_set_specific(self.dispatchQueue, key, context, destructor);
}

- (void *)contextForKey:(const void *)key {
  return dispatch_queue_get_specific(self.dispatchQueue, key);
}

- (dispatch_queue_t)dispatchQueue {
  return self.dispatchObject._dq;
}

@end
