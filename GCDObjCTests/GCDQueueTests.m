//
//  GCDObjCTests.m
//  GCDObjCTests
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "GCDObjC.h"

@interface GCDQueueTests : SenTestCase
@end

@implementation GCDQueueTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testDispatchBlock {
  GCDQueue *queue = [[GCDQueue alloc] initSerial];
  __block int val = 0;
  
  [queue dispatchBlock:^{
    ++val; 
  }];
  
  sleep(1);
  STAssertEquals(val, 1, @"testDispatchBlock");
}

- (void)testDispatchBlockAfterSeconds {
  GCDQueue *queue = [[GCDQueue alloc] initSerial];
  __block int val = 0;
  
  [queue dispatchBlock:^{
    ++val; 
  } afterSeconds:0.5];
  
  STAssertEquals(val, 0, @"testDispatchBlock");
  sleep(1);
  STAssertEquals(val, 1, @"testDispatchBlock");
}

- (void)testDispatchSyncBlock {
  GCDQueue *queue = [[GCDQueue alloc] initSerial];
  __block int val = 0;
  
  [queue dispatchSyncBlock:^{
    ++val; 
  }];
    
  STAssertEquals(val, 1, @"testDispatchSync");
}

void dispatchFunction(void *context) {
  ++(*(int *)context);
}

- (void)testDispatchSyncFunction {
  GCDQueue *queue = [[GCDQueue alloc] initSerial];
  __block int val = 0;
  
  [queue dispatchSyncFunction:dispatchFunction withContext:&val];
  
  STAssertEquals(val, 1, @"testDispatchFunction");
}

@end
