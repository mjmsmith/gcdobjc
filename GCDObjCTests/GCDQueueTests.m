//
//  GCDQueueTests.m
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <dispatch/dispatch.h>

#import "GCDObjC.h"

@interface GCDQueueTests : XCTestCase
@end

@implementation GCDQueueTests

- (void)testMainQueue {
  XCTAssertEqual([GCDQueue mainQueue].dispatchQueue, dispatch_get_main_queue());
}

- (void)testGlobalQueues {
  XCTAssertEqual([GCDQueue globalQueue].dispatchQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
  XCTAssertEqual([GCDQueue highPriorityGlobalQueue].dispatchQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
  XCTAssertEqual([GCDQueue lowPriorityGlobalQueue].dispatchQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));
  XCTAssertEqual([GCDQueue backgroundPriorityGlobalQueue].dispatchQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0));
}

- (void)testCurrentQueue {
  XCTAssertEqual([GCDQueue currentQueue].dispatchQueue, dispatch_get_current_queue());
}

- (void)testQueueBlock {
  GCDSemaphore *semaphore = [GCDSemaphore new];
  GCDQueue *queue = [GCDQueue new];
  __block int val = 0;
  
  [queue queueBlock:^{
    ++val;
    [semaphore signal];
  }];
  
  [semaphore wait];
  XCTAssertEqual(val, 1);
}

- (void)testQueueBlockAfterDelay {
  GCDSemaphore *semaphore = [GCDSemaphore new];
  GCDQueue *queue = [GCDQueue new];
  NSDate *then = [NSDate new];
  __block int val = 0;
  
  [queue queueBlock:^{
    ++val; 
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
  __block int val = 0;
  
  [queue queueAndAwaitBlock:^{ ++val; }];
  
  XCTAssertEqual(val, 1);
}

- (void)testQueueAndAwaitBlockIterationCount {
  GCDQueue *queue = [GCDQueue new];
  __block int val = 0;
  
  [queue queueAndAwaitBlock:^(size_t i){ ++val; } iterationCount:10];
  
  XCTAssertEqual(val, 10);
}

- (void)testQueueBlockInGroup {
  GCDQueue *queue = [GCDQueue new];
  GCDGroup *group = [GCDGroup new];
  __block int val = 0;
  
  [queue queueBlock:^{ ++val; } inGroup:group];
  [queue queueBlock:^{ ++val; } inGroup:group];
  
  XCTAssertEqual(val, 0);
  [group wait];
  XCTAssertEqual(val, 2);
}

- (void)testQueueNotifyBlockForGroup {
  GCDQueue *queue = [GCDQueue new];
  GCDGroup *group = [GCDGroup new];
  GCDSemaphore *semaphore = [GCDSemaphore new];
  __block int val = 0;
  
  [queue queueBlock:^{ val += 1; } inGroup:group];
  [queue queueBlock:^{ val += 2; } inGroup:group];
  [queue queueNotifyBlock:^{ [semaphore signal]; } forGroup:group];
  
  [semaphore wait];
  XCTAssertEqual(val, 3);
}

- (void)testQueueBarrierBlock {
  GCDQueue *queue = [GCDQueue new];
  __block int val = 0;
  __block int barrierVal = 0;

  for (int i = 0; i < 10; ++i) {
    [queue queueBlock:^{ ++val; }];
  }
  [queue queueBarrierBlock:^{ barrierVal = val; }];
  for (int i = 0; i < 10; ++i) {
    [queue queueBlock:^{ ++val; }];
  }

  [queue queueAndAwaitBlock:^{}];
  XCTAssertEqual(barrierVal, 10);
  XCTAssertEqual(val, 20);
}

- (void)testQueueAndAwaitBarrierBlock {
  GCDQueue *queue = [GCDQueue new];
  __block int val = 0;
  
  for (int i = 0; i < 10; ++i) {
    [queue queueBlock:^{ ++val; }];
  }
  [queue queueAndAwaitBarrierBlock:^{}];
  XCTAssertEqual(val, 10);
}

static int onceVal;
- (void)onceBlock {
  GCDExecOnce(^{ ++onceVal; });
}
- (void)testExecOnce {
  onceVal = 0;
  for (int i = 0; i < 10; ++i) {
    [self onceBlock];
  }
  
  XCTAssertEqual(onceVal, 1);
}

+ (instancetype)theTestInstance {
  GCDSharedInstance(^{ return [[self class] new]; });
}
- (void)testSharedInstance {
  XCTAssertTrue([[GCDQueueTests theTestInstance] class] == [self class]);
  XCTAssertEqual([GCDQueueTests theTestInstance], [GCDQueueTests theTestInstance]);
}

@end
