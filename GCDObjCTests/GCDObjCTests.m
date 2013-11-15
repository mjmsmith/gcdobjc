//
//  GCDQueueTests.m
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <dispatch/dispatch.h>
#import <libkern/OSAtomic.h>

#import "GCDObjC.h"

@interface GCDObjCTests : XCTestCase
@end

@implementation GCDObjCTests

- (void)testMainQueue {
  XCTAssertEqual([GCDQueue mainQueue].dispatchQueue, dispatch_get_main_queue());
}

- (void)testGlobalQueues {
  XCTAssertEqual([GCDQueue globalQueue].dispatchQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
  XCTAssertEqual([GCDQueue highPriorityGlobalQueue].dispatchQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
  XCTAssertEqual([GCDQueue lowPriorityGlobalQueue].dispatchQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));
  XCTAssertEqual([GCDQueue backgroundPriorityGlobalQueue].dispatchQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0));
}

- (void)testQueueBlock {
  GCDSemaphore *semaphore = [GCDSemaphore new];
  GCDQueue *queue = [GCDQueue new];
  __block int32_t val = 0;
  
  [queue queueBlock:^{
    OSAtomicIncrement32(&val);
    [semaphore signal];
  }];
  
  [semaphore wait];
  XCTAssertEqual(val, 1);
}

- (void)testQueueBlockAfterDelay {
  GCDSemaphore *semaphore = [GCDSemaphore new];
  GCDQueue *queue = [GCDQueue new];
  NSDate *then = [NSDate new];
  __block int32_t val = 0;
  
  [queue queueBlock:^{
    OSAtomicIncrement32(&val);
    [semaphore signal];
  } afterDelay:0.5];
  
  XCTAssertEqual(val, 0);
  [semaphore wait];
  XCTAssertEqual(val, 1);

  NSDate *now = [NSDate new];
  XCTAssertTrue([now timeIntervalSinceDate:then] > 0.4);
  XCTAssertTrue([now timeIntervalSinceDate:then] < 0.6);
}

- (void)testQueueAndAwaitBlock {
  GCDQueue *queue = [GCDQueue new];
  __block int32_t val = 0;
  
  [queue queueAndAwaitBlock:^{ OSAtomicIncrement32(&val); }];
  
  XCTAssertEqual(val, 1);
}

- (void)testQueueAndAwaitBlockIterationCount {
  GCDQueue *queue = [[GCDQueue alloc] initConcurrent];
  __block int32_t val = 0;
  
  [queue queueAndAwaitBlock:^(size_t i){ OSAtomicIncrement32(&val); } iterationCount:100];
  
  XCTAssertEqual(val, 100);
}

- (void)testQueueBlockInGroup {
  GCDQueue *queue = [[GCDQueue alloc] initConcurrent];
  GCDGroup *group = [GCDGroup new];
  __block int32_t val = 0;
  
  for (int i = 0; i < 100; ++i) {
    [queue queueBlock:^{ OSAtomicIncrement32(&val); } inGroup:group];
  }
  
  [group wait];
  XCTAssertEqual(val, 100);
}

- (void)testQueueNotifyBlockForGroup {
  GCDQueue *queue = [[GCDQueue alloc] initConcurrent];
  GCDSemaphore *semaphore = [GCDSemaphore new];
  GCDGroup *group = [GCDGroup new];
  __block int32_t val = 0;
  __block int32_t notifyVal = 0;
  
  for (int i = 0; i < 100; ++i) {
    [queue queueBlock:^{ OSAtomicIncrement32(&val); } inGroup:group];
  }
  [queue queueNotifyBlock:^{ notifyVal = val; [semaphore signal]; } inGroup:group];

  [semaphore wait];
  XCTAssertEqual(notifyVal, 100);
}

- (void)testQueueBarrierBlock {
  GCDQueue *queue = [[GCDQueue alloc] initConcurrent];
  GCDSemaphore *semaphore = [GCDSemaphore new];
  __block int32_t val = 0;
  __block int32_t barrierVal = 0;

  for (int i = 0; i < 100; ++i) {
    [queue queueBlock:^{ OSAtomicIncrement32(&val); }];
  }
  [queue queueBarrierBlock:^{ barrierVal = val; [semaphore signal]; }];
  for (int i = 0; i < 100; ++i) {
    [queue queueBlock:^{ OSAtomicIncrement32(&val); }];
  }

  [semaphore wait];
  XCTAssertEqual(barrierVal, 100);
}

- (void)testQueueAndAwaitBarrierBlock {
  GCDQueue *queue = [[GCDQueue alloc] initConcurrent];
  __block int32_t val = 0;
  
  for (int i = 0; i < 100; ++i) {
    [queue queueBlock:^{ OSAtomicIncrement32(&val); }];
  }
  [queue queueAndAwaitBarrierBlock:^{}];
  XCTAssertEqual(val, 100);
}

static int onceVal;

- (void)onceBlock {
  GCDExecOnce(^{ ++onceVal; });
}

- (void)testExecOnce {
  onceVal = 0;
  for (int i = 0; i < 100; ++i) {
    [self onceBlock];
  }
  
  XCTAssertEqual(onceVal, 1);
}

+ (instancetype)theTestInstance {
  GCDSharedInstance(^{ return [[self class] new]; });
}

- (void)testSharedInstance {
  XCTAssertTrue([[GCDObjCTests theTestInstance] class] == [self class]);
  XCTAssertEqual([GCDObjCTests theTestInstance], [GCDObjCTests theTestInstance]);
}

@end
