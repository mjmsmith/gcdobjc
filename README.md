# GCDObjC

GCDObjC is an Objective-C wrapper for the most commonly used features of Grand Central Dispatch.  It has four main aims:

* Organize the flat C API into appropriate classes.
* Use more natural arguments, such as time intervals rather than absolute times.
* Split single functions into multiple intent-revealing methods. 
* Add convenience methods.

In all classes, the associated __dispatch_object_t__ object is created in the init method and released in the dealloc method.

### GCDQueue

Most of the functionality is implemented in the __GCDQueue__ class.

* convenience accessors for the global queues and current queue

```
+ (GCDQueue *)mainQueue;
+ (GCDQueue *)globalQueue;
+ (GCDQueue *)highPriorityGlobalQueue;
+ (GCDQueue *)lowPriorityGlobalQueue;
+ (GCDQueue *)backgroundPriorityGlobalQueue;
+ (GCDQueue *)currentQueue;
- (BOOL)isCurrentQueue;
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

### GCDSemaphore

Semaphores are supported through the __GCDSemaphore__ class.

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

### GCDGroup

Groups are supported through the __GCDGroup__ class.

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

### Macros

Two macros are provided for wrapping __dispatch_once()__ calls.

* __GCDExecOnce()__: executing a block once

```
GCDExecOnce(^{ NSLog(@"This will only be logged once."); });
```

* __GCDSharedInstance()__: creating a singleton instance of a class

```
+ (instancetype)sharedInstance {
  GCDSharedInstance(^{ return [[self class] new]; });
}
```
