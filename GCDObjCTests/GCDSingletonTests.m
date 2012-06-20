//
//  GCDSingletonTests.m
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <dispatch/dispatch.h>

#import "GCDObjC.h"

@interface GCDSingletonTests : SenTestCase
@end

@implementation GCDSingletonTests

- (void)testSyncBlock {
  GCDSingleton *singleton = [[GCDSingleton alloc] init];
  
  __block int val = 0;
  
  for (int i = 0; i < 10; ++i) {
    [singleton syncBlock:^{ ++val; }];
  }
  
  STAssertEquals(val, 1, nil);
}

static void syncFunction(void *context) {
  ++(*(int *)context);
}

- (void)testSyncFunction {
  GCDSingleton *singleton = [[GCDSingleton alloc] init];
  
  __block int val = 0;
  
  for (int i = 0; i < 10; ++i) {
    [singleton syncFunction:syncFunction withContext:&val];
  }
  
  STAssertEquals(val, 1, nil);
}

@end
