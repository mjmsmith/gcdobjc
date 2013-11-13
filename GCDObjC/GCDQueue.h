//
//  GCDQueue.h
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import "GCDObject.h"

@class GCDGroup;

@interface GCDQueue : GCDObject

/**
 *  Returns the underlying dispatch queue object.
 *  @return The dispatch queue object.
 */
@property (assign, readonly, nonatomic) dispatch_queue_t dispatchQueue;

/**
 *  Returns the serial dispatch queue associated with the application’s main thread.
 *
 *  @return The main queue. This queue is created automatically on behalf of the main thread before main is called.
 *  @see dispatch_get_main_queue()
 */
+ (GCDQueue *)mainQueue;

/**
 *  Returns the default priority global concurrent queue.
 *
 *  @return The queue.
 *  @see dispatch_get_global_queue()
 */
+ (GCDQueue *)globalQueue;

/**
 *  Returns the high priority global concurrent queue.
 *
 *  @return The queue.
 *  @see dispatch_get_global_queue()
 */
+ (GCDQueue *)highPriorityGlobalQueue;

/**
 *  Returns the low priority global concurrent queue.
 *
 *  @return The queue.
 *  @see dispatch_get_global_queue()
 */
+ (GCDQueue *)lowPriorityGlobalQueue;

/**
 *  Returns the background priority global concurrent queue.
 *
 *  @return The queue.
 *  @see dispatch_get_global_queue()
 */
+ (GCDQueue *)backgroundPriorityGlobalQueue;

/**
 *  Returns the queue on which the currently executing block is running.
 *
 *  @return The queue.
 *  @see dispatch_get_current_queue()
 */
+ (GCDQueue *)currentQueue;

/**
 *  Initializes a new serial queue.
 *
 *  @return The initialized serial queue instance.
 *  @see dispatch_queue_create()
 */
- (instancetype)init;

/**
 *  Initializes a new serial queue.
 *
 *  @return The initialized serial queue instance.
 *  @see dispatch_queue_create()
 */
- (instancetype)initSerial;

/**
 *  Initializes a new concurrent queue.
 *
 *  @return The initialized concurrent queue instance.
 *  @see dispatch_queue_create()
 */
- (instancetype)initConcurrent;

/**
 *  The GCDQueue designated initializer.
 *
 *  @param dispatchQueue A dispatch_queue_t object.
 *  @return The initialized instance. The GCDQueue object takes ownership of the underlying dispatch queue.
 */
- (instancetype)initWithDispatchQueue:(dispatch_queue_t)dispatchQueue;

/**
 *  Submits a block for asynchronous execution on the queue.
 *
 *  @param block The block to submit.
 *  @see dispatch_async()
 */
- (void)queueBlock:(dispatch_block_t)block;

/**
 *  Submits a block for asynchronous execution on the queue after a delay.
 *
 *  @param block The block to submit.
 *  @param afterDelay The delay in seconds.
 *  @see dispatch_after()
 */
- (void)queueBlock:(dispatch_block_t)block afterDelay:(double)seconds;

/**
 *  Submits a block for execution on the queue and waits until it completes.
 *
 *  @param block The block to submit.
 *  @see dispatch_sync()
 */
- (void)queueAndAwaitBlock:(dispatch_block_t)block;

/**
 *  Submits a block for execution on the queue multiple times and waits until all executions complete.
 *
 *  @param block The block to submit.
 *  @param iterationCount The number of times to execute the block.
 *  @see dispatch_apply()
 */
- (void)queueAndAwaitBlock:(void (^)(size_t))block iterationCount:(size_t)count;

/**
 *  Submits a block for asynchronous execution on the queue and associates it with the group.
 *
 *  @param block The block to submit.
 *  @param inGroup The group to associate the block with.
 *  @see dispatch_group_async()
 */
- (void)queueBlock:(dispatch_block_t)block inGroup:(GCDGroup *)group;

/**
 *  Schedules a block to be submitted to the queue when a group of previously submitted blocks have completed.
 *
 *  @param block The block to submit when the group completes.
 *  @param forGroup The group to observe.
 *  @see dispatch_group_notify()
 */
- (void)queueNotifyBlock:(dispatch_block_t)block forGroup:(GCDGroup *)group;

/**
 *  Submits a barrier block for asynchronous execution on the queue.
 *
 *  @param block The barrier block to submit.
 *  @see dispatch_barrier_async()
 */
- (void)queueBarrierBlock:(dispatch_block_t)block;

/**
 *  Submits a barrier block for execution on the queue and waits until it completes.
 *
 *  @param block The barrier block to submit.
 *  @see dispatch_barrier_sync()
 */
- (void)queueAndAwaitBarrierBlock:(dispatch_block_t)block;

/**
 *  Returns whether the queue is the current queue.
 *
 *  @return YES if it is the current queue, NO otherwise.
 *  @see dispatch_get_current_queue()
 */
- (BOOL)isCurrentQueue;

/**
 *  Suspends execution of blocks on the queue.
 *  @see dispatch_suspend()
 */
- (void)suspend;

/**
 *  Resumes execution of blocks on the queue.
 *  @see dispatch_resume()
 */
- (void)resume;

@end
