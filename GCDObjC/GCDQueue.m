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
@property (unsafe_unretained, nonatomic) dispatch_queue_t dispatchQueue;
@end

@implementation GCDQueue

@synthesize dispatchQueue = _dispatchQueue;

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

- (id)initSerialWithLabel:(NSString *)label {
  if ((self = [super init]) != nil) {
    _dispatchQueue = dispatch_queue_create([label cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_SERIAL);
  }
  
  return self;
}

- (id)initConcurrentWithLabel:(NSString *)label {
  if ((self = [super init]) != nil) {
    _dispatchQueue = dispatch_queue_create([label cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_CONCURRENT);
  }
  
  return self;
}

- (id)initWithDispatchQueue:(dispatch_queue_t)dispatchQueue {
  if ((self = [super init]) != nil) {
    _dispatchQueue = dispatchQueue;
  }
  
  return self;
}

- (void)dealloc {
  if (_dispatchQueue != mainDispatchQueue) {
    dispatch_release(_dispatchQueue);
  }
  
  _dispatchQueue = NULL;
}

#pragma mark Public methods.

- (NSString *)label {
  const char *value = dispatch_queue_get_label(self.dispatchQueue);
  
  if (value == NULL) {
    return nil;
  }

  return [NSString stringWithCString:value encoding:NSASCIIStringEncoding];
}

- (void)dispatchAsyncBlock:(dispatch_block_t)block {
  dispatch_async(self.dispatchQueue, block);
}

- (void)dispatchAsyncBlock:(dispatch_block_t)block inGroup:(GCDGroup *)group {
  dispatch_group_async(group.dispatchGroup, self.dispatchQueue, block);
}

- (void)dispatchNotifyBlock:(dispatch_block_t)block forGroup:(GCDGroup *)group {
  dispatch_group_notify(group.dispatchGroup, self.dispatchQueue, block);
}

- (void)dispatchBarrierAsyncBlock:(dispatch_block_t)block {
  dispatch_barrier_async(self.dispatchQueue, block);
}

- (void)dispatchAsyncFunction:(dispatch_function_t)function withContext:(void *)context {
  dispatch_async_f(self.dispatchQueue, context, function);
}

- (void)dispatchAsyncFunction:(dispatch_function_t)function withContext:(void *)context inGroup:(GCDGroup *)group {
  dispatch_group_async_f(group.dispatchGroup, self.dispatchQueue, context, function);
}

- (void)dispatchNotifyFunction:(dispatch_function_t)function withContext:(void *)context forGroup:(GCDGroup *)group {
  dispatch_group_notify_f(group.dispatchGroup, self.dispatchQueue, context, function);
}

- (void)dispatchBarrierAsyncFunction:(dispatch_function_t)function withContext:(void *)context {
  dispatch_barrier_async_f(self.dispatchQueue, context, function);
}

- (void)dispatchSyncBlock:(dispatch_block_t)block {
  dispatch_sync(self.dispatchQueue, block);
}

- (void)dispatchBarrierSyncBlock:(dispatch_block_t)block {
  dispatch_barrier_sync(self.dispatchQueue, block);
}

- (void)dispatchSyncFunction:(dispatch_function_t)function withContext:(void *)context {
  dispatch_sync_f(self.dispatchQueue, context, function);
}

- (void)dispatchBarrierSyncFunction:(dispatch_function_t)function withContext:(void *)context {
  dispatch_barrier_sync_f(self.dispatchQueue, context, function);
}

@end
