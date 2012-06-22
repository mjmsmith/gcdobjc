//
//  GCDQueue.m
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import "GCDGroup.h"
#import "GCDQueue.h"

@interface GCDQueue ()
- (id)initWithDispatchQueue:(dispatch_queue_t)dispatchQueue;
@end

@implementation GCDQueue

static GCDQueue *mainQueue;
static GCDQueue *globalQueue;
static GCDQueue *highPriorityGlobalQueue;
static GCDQueue *lowPriorityGlobalQueue;
static GCDQueue *backgroundPriorityGlobalQueue;

#pragma mark Static methods.

+ (void)initialize {
  if ([self class] == [GCDQueue class]) {
    mainQueue = [[GCDQueue alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    globalQueue = [[GCDQueue alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    highPriorityGlobalQueue = [[GCDQueue alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];
    lowPriorityGlobalQueue = [[GCDQueue alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)];
    backgroundPriorityGlobalQueue = [[GCDQueue alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
  }
}  

+ (GCDQueue *)mainQueue {
  return mainQueue;
}

+ (GCDQueue *)globalQueue {
  return globalQueue;
}

+ (GCDQueue *)highPriorityGlobalQueue {
  return highPriorityGlobalQueue;
}

+ (GCDQueue *)lowPriorityGlobalQueue {
  return lowPriorityGlobalQueue;
}

+ (GCDQueue *)backgroundPriorityGlobalQueue {
  return backgroundPriorityGlobalQueue;
}

+ (GCDQueue *)currentQueue {
  return [[GCDQueue alloc] initWithDispatchQueue:dispatch_get_current_queue()];
}

#pragma mark Construction.

- (id)init {
  return [self initWithLabel:nil attr:DISPATCH_QUEUE_SERIAL];
}

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

#pragma mark Public block methods.

- (void)asyncBlock:(dispatch_block_t)block {
  dispatch_async(self.dispatchQueue, block);
}

- (void)asyncBlock:(dispatch_block_t)block inGroup:(GCDGroup *)group {
  dispatch_group_async(group.dispatchGroup, self.dispatchQueue, block);
}

- (void)asyncBlock:(dispatch_block_t)block afterDelay:(double)seconds {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (seconds * NSEC_PER_SEC)), self.dispatchQueue, block);
}

- (void)asyncBarrierBlock:(dispatch_block_t)block {
  dispatch_barrier_async(self.dispatchQueue, block);
}

- (void)asyncNotifyBlock:(dispatch_block_t)block inGroup:(GCDGroup *)group {
  dispatch_group_notify(group.dispatchGroup, self.dispatchQueue, block);
}

- (void)syncBlock:(dispatch_block_t)block {
  if ([self isCurrentQueue]) {
    block();
  }
  else {
    dispatch_sync(self.dispatchQueue, block);
  }
}

- (void)syncBlock:(void (^)(size_t))block count:(size_t)count {
  if ([self isCurrentQueue]) {
    for (int i = 0; i < count; ++i) {
      block(i);
    }
  }
  else {
    dispatch_apply(count, self.dispatchQueue, block);
  }
}

- (void)syncBarrierBlock:(dispatch_block_t)block {
  // TODO How to deal with attempted dispatch on the current queue?
  dispatch_barrier_sync(self.dispatchQueue, block);
}

#pragma mark Public function methods.

- (void)asyncFunction:(dispatch_function_t)function withContext:(void *)context {
  dispatch_async_f(self.dispatchQueue, context, function);
}

- (void)asyncFunction:(dispatch_function_t)function withContext:(void *)context inGroup:(GCDGroup *)group {
  dispatch_group_async_f(group.dispatchGroup, self.dispatchQueue, context, function);
}

- (void)asyncFunction:(dispatch_function_t)function withContext:(void *)context afterDelay:(double)seconds {
  dispatch_after_f(dispatch_time(DISPATCH_TIME_NOW, (seconds * NSEC_PER_SEC)), self.dispatchQueue, context, function);
}

- (void)asyncBarrierFunction:(dispatch_function_t)function withContext:(void *)context {
  dispatch_barrier_async_f(self.dispatchQueue, context, function);
}

- (void)asyncNotifyFunction:(dispatch_function_t)function withContext:(void *)context inGroup:(GCDGroup *)group {
  dispatch_group_notify_f(group.dispatchGroup, self.dispatchQueue, context, function);
}

- (void)syncFunction:(dispatch_function_t)function withContext:(void *)context {
  if ([self isCurrentQueue]) {
    function(context);
  }
  else {
    dispatch_sync_f(self.dispatchQueue, context, function);
  }
}

- (void)syncFunction:(void (*)(void *, size_t))function withContext:(void *)context count:(size_t)count {
  if ([self isCurrentQueue]) {
    for (int i = 0; i < count; ++i) {
      function(context, i);
    }
  }
  else {
    dispatch_apply_f(count, self.dispatchQueue, context, function);
  }
}

- (void)syncBarrierFunction:(dispatch_function_t)function withContext:(void *)context {
  // TODO How to deal with attempted dispatch on the current queue?
  dispatch_barrier_sync_f(self.dispatchQueue, context, function);
}

#pragma mark Misc public methods.

- (BOOL)isCurrentQueue {
  return self.dispatchQueue == dispatch_get_current_queue();
}

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
