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
  GCDSemaphore *semaphore = [[GCDSemaphore alloc] initWithValue:0];
  
  STAssertEquals(semaphore.context, NULL, nil);
  semaphore.context = &semaphore;
  STAssertEquals(semaphore.context, (void *)&semaphore, nil);
}

void finalizerFunction(void *context) {
  [(__bridge GCDSemaphore *)context signal];
}

- (void)testSetFinalizerFunction {
  GCDSemaphore *semaphore = [[GCDSemaphore alloc] initWithValue:0];
  GCDQueue *queue = [[GCDQueue alloc] init];
  __block int val = 0;
  
  [queue asyncBlock:^{
    GCDSemaphore *blockSemaphore = [[GCDSemaphore alloc] initWithValue:0];
    
    blockSemaphore.context = (__bridge void *)semaphore;
    [blockSemaphore setFinalizerFunction:finalizerFunction];
    
    ++val;
  }];
  
  [semaphore wait];
  
  STAssertEquals(val, 1, nil);
}

- (void)testLogDebugMessage {
  GCDQueue *queue = [[GCDQueue alloc] init];

  STAssertNoThrow([queue logDebugWithMessage:@"testLogDebugMessage"], nil);
}

@end
