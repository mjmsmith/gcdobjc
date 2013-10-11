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

- (void)testAsyncBlock {
  GCDSemaphore *semaphore = [GCDSemaphore new];
  GCDQueue *queue = [GCDQueue new];
  __block int val = 0;
  
  [queue asyncBlock:^{
    ++val;
    [semaphore signal];
  }];
  
  [semaphore wait];

  XCTAssertEqual(val, 1);
}

- (void)testAsyncBlockAfterDelay {
  GCDSemaphore *semaphore = [GCDSemaphore new];
  GCDQueue *queue = [GCDQueue new];
  __block int val = 0;
  
  [queue asyncBlock:^{
    ++val; 
    [semaphore signal];
  } afterDelay:0.5];
  
  XCTAssertEqual(val, 0);
  [semaphore wait];
  XCTAssertEqual(val, 1);
}

- (void)testAsyncBlockInGroup {
  GCDQueue *queue = [GCDQueue new];
  GCDGroup *group = [GCDGroup new];
  __block int val = 0;
  
  [queue asyncBlock:^{ ++val; } inGroup:group];
  [queue asyncBlock:^{ ++val; } inGroup:group];
  
  [group wait];
  XCTAssertEqual(val, 2);
}

- (void)testSyncBlock {
  GCDQueue *queue = [GCDQueue new];
  __block int val = 0;
  
  [queue syncBlock:^{ ++val; }];
    
  XCTAssertEqual(val, 1);
}

- (void)testSyncBlockOnCurrentQueue {
  GCDQueue *queue = [GCDQueue mainQueue];
  __block int val = 0;
  
  [queue syncBlock:^{ ++val; }];
  
  XCTAssertTrue([queue isCurrentQueue]);
  XCTAssertEqual(val, 1);
}

@end
