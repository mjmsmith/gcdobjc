//
//  GCDQueueTests.m
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <dispatch/dispatch.h>

#import "GCDObjC.h"

@interface GCDQueueTests : SenTestCase
@end

@implementation GCDQueueTests

- (void)testMainQueue {
  STAssertEquals([GCDQueue mainQueue].dispatchQueue, dispatch_get_main_queue(), nil);
}

- (void)testGlobalQueues {
  STAssertEquals([GCDQueue globalQueue].dispatchQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), nil);
  STAssertEquals([GCDQueue highPriorityGlobalQueue].dispatchQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), nil);
  STAssertEquals([GCDQueue lowPriorityGlobalQueue].dispatchQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), nil);
  STAssertEquals([GCDQueue backgroundPriorityGlobalQueue].dispatchQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), nil);
}

- (void)testCurrentQueue {
  STAssertEquals([GCDQueue currentQueue].dispatchQueue, dispatch_get_current_queue(), nil);
}

- (void)testAsyncBlock {
  GCDSemaphore *semaphore = [[GCDSemaphore alloc] init];
  GCDQueue *queue = [[GCDQueue alloc] init];
  __block int val = 0;
  
  [queue asyncBlock:^{
    ++val;
    [semaphore signal];
  }];
  
  [semaphore wait];

  STAssertEquals(val, 1, nil);
}

- (void)testAsyncBlockAfterDelay {
  GCDSemaphore *semaphore = [[GCDSemaphore alloc] init];
  GCDQueue *queue = [[GCDQueue alloc] init];
  __block int val = 0;
  
  [queue asyncBlock:^{
    ++val; 
    [semaphore signal];
  } afterDelay:0.5];
  
  STAssertEquals(val, 0, nil);
  [semaphore wait];
  STAssertEquals(val, 1, nil);
}

- (void)testAsyncBlockInGroup {
  GCDQueue *queue = [[GCDQueue alloc] init];
  GCDGroup *group = [[GCDGroup alloc] init];
  __block int val = 0;
  
  [queue asyncBlock:^{ ++val; } inGroup:group];
  [queue asyncBlock:^{ ++val; } inGroup:group];
  
  [group wait];
  STAssertEquals(val, 2, nil);
}

- (void)testSyncBlock {
  GCDQueue *queue = [[GCDQueue alloc] init];
  __block int val = 0;
  
  [queue syncBlock:^{ ++val; }];
    
  STAssertEquals(val, 1, nil);
}

- (void)testSyncBlockOnCurrentQueue {
  GCDQueue *queue = [GCDQueue mainQueue];
  __block int val = 0;
  
  [queue syncBlock:^{ ++val; }];
  
  STAssertTrue([queue isCurrentQueue], nil);
  STAssertEquals(val, 1, nil);
}

static void syncFunction(void *context) {
  ++(*(int *)context);
}

- (void)testSyncFunction {
  GCDQueue *queue = [[GCDQueue alloc] init];
  __block int val = 0;
  
  [queue syncFunction:syncFunction withContext:&val];
  
  STAssertEquals(val, 1, nil);
}

- (void)testSyncFunctionOnCurrentQueue {
  GCDQueue *queue = [GCDQueue mainQueue];
  __block int val = 0;
  
  [queue syncFunction:syncFunction withContext:&val];
  
  STAssertTrue([queue isCurrentQueue], nil);
  STAssertEquals(val, 1, nil);
}

- (void)testLabel {
  GCDQueue *queue = [[GCDQueue alloc] initSerialWithLabel:@"testLabel"];
  
  STAssertEqualObjects(queue.label, @"testLabel", nil);
}

@end
