//
//  GCDObjectTests.m
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <dispatch/dispatch.h>

#import "GCDObjC.h"

@interface GCDObjectTests : SenTestCase
@end

@implementation GCDObjectTests

- (void)testContext {
  GCDSemaphore *semaphore = [GCDSemaphore semaphore];
  
  STAssertEquals(semaphore.context, NULL, nil);
  semaphore.context = &semaphore;
  STAssertEquals(semaphore.context, (void *)&semaphore, nil);
}

void finalizerFunction(void *context) {
  [(__bridge GCDSemaphore *)context signal];
}

- (void)testSetFinalizerFunction {
  GCDSemaphore *semaphore = [GCDSemaphore semaphore];
  GCDQueue *queue = [GCDQueue queue];
  __block int val = 0;
  
  [queue asyncBlock:^{
    GCDSemaphore *blockSemaphore = [GCDSemaphore semaphore];
    
    blockSemaphore.context = (__bridge void *)semaphore;
    [blockSemaphore setFinalizerFunction:finalizerFunction];
    
    ++val;
  }];
  
  [semaphore wait];
  
  STAssertEquals(val, 1, nil);
}

- (void)testLogDebugMessage {
  GCDQueue *queue = [GCDQueue queue];

  STAssertNoThrow([queue logDebugWithMessage:@"testLogDebugMessage"], nil);
}

- (void)testOnceBlock {
  static dispatch_once_t once = 0;
  __block int val = 0;
  
  for (int i = 0; i < 10; ++i) {
    [GCDObject syncBlock:^{ ++val; } once:&once];
  }
  
  STAssertEquals(val, 1, nil);
}

static void function(void *context) {
  ++(*(int *)context);
}

- (void)testOnceFunction {
  static dispatch_once_t once = 0;
  __block int val = 0;
  
  for (int i = 0; i < 10; ++i) {
    [GCDObject syncFunction:function withContext:&val once:&once];
  }
  
  STAssertEquals(val, 1, nil);
}

@end
