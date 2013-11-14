# GCDObjC

GCDObjC is an Objective-C wrapper for the most commonly used features of Grand Central Dispatch.  It has four main aims:

* Organize the flat C API into appropriate classes.
* Use more convenient arguments, such as NSTimeIntervals.
* Split single functions into multiple intent-revealing methods.
* Add convenience methods.

## Usage

__GCDObjC__ requires ARC and iOS 6.0.  (Prior to 6.0, dispatch objects were not considered Objective-C objects, and therefore required manual memory management.)

__GCDObjC.h__ is the only header file that needs to be imported.

For usage examples, see [GCDObjCTests.m](https://github.com/mjmsmith/gcdobjc/blob/master/GCDObjCTests/GCDQueueTests.m).

## GCDQueue

Most of the functionality is implemented in the __GCDQueue__ class.

* convenience accessors for the global queues and current queue

```
+ (GCDQueue *)mainQueue;
+ (GCDQueue *)globalQueue;
+ (GCDQueue *)highPriorityGlobalQueue;
+ (GCDQueue *)lowPriorityGlobalQueue;
+ (GCDQueue *)backgroundPriorityGlobalQueue;
```

* creating serial and concurrent queues

```
- (instancetype)initSerial;
- (instancetype)initConcurrent;
```

* queueing blocks for asynchronous execution

```
- (void)queueBlock:(dispatch_block_t)block;
- (void)queueBlock:(dispatch_block_t)block afterDelay:(double)seconds;
- (void)queueBlock:(dispatch_block_t)block inGroup:(GCDGroup *)group;
```

* queueing blocks for synchronous execution

```
- (void)queueAndAwaitBlock:(dispatch_block_t)block;
- (void)queueAndAwaitBlock:(void (^)(size_t))block iterationCount:(size_t)count;
```

* queueing notify blocks on groups

```
- (void)queueNotifyBlock:(dispatch_block_t)block forGroup:(GCDGroup *)group;
```

* queueing barrier blocks for synchronous or asynchronous execution

```
- (void)queueBarrierBlock:(dispatch_block_t)block;
- (void)queueAndAwaitBarrierBlock:(dispatch_block_t)block;
```

* suspending and resuming a queue

```
- (void)suspend;
- (void)resume;
```

## GCDSemaphore

Semaphores are implemented in the __GCDSemaphore__ class.

* creating semaphores

```
- (instancetype)init;
- (instancetype)initWithValue:(long)value;
```

* signaling and waiting on a semaphore

```
- (BOOL)signal;
- (void)wait;
- (BOOL)wait:(double)seconds;
```

## GCDGroup

Groups are implemented in the __GCDGroup__ class.

* creating groups

```
- (instancetype)init;
```

* entering and leaving a group

```
- (void)enter;
- (void)leave;
```

* waiting on completion of a group

```
- (void)wait;
- (BOOL)wait:(double)seconds;
```

## Macros

Two macros are provided for wrapping __dispatch_once()__ calls.

* executing a block only once: __GCDExecOnce(block)__

```
GCDExecOnce(^{ NSLog(@"This will only be logged once."); });
```

* creating a singleton instance of a class: __GCDSharedInstance(block)__

```
+ (instancetype)sharedInstance {
  GCDSharedInstance(^{ return [[self class] new]; });
}
```

The block supplied to __GCDSharedInstance()__ must return an instance of the desired class.
