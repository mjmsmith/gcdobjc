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

@end
