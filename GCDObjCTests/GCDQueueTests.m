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
  
  XCTAssertEqual(val, 0);
  [semaphore wait];
  XCTAssertEqual(val, 1);
}

- (void)testQueueBlockAfterDelay {
  GCDSemaphore *semaphore = [GCDSemaphore new];
  GCDQueue *queue = [GCDQueue new];
  __block int val = 0;
  
  [queue queueBlock:^{
    ++val; 
    [semaphore signal];
  } afterDelay:0.5];
  
  XCTAssertEqual(val, 0);
  [semaphore wait];
  XCTAssertEqual(val, 1);
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

- (void)testQueueAndAwaitBlock {
  GCDQueue *queue = [GCDQueue new];
  __block int val = 0;
  
  [queue queueAndAwaitBlock:^{ ++val; }];
    
  XCTAssertEqual(val, 1);
}

@end
