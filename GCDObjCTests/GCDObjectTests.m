//
//  GCDObjectTests.m
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <dispatch/dispatch.h>

#import "GCDObjC.h"

@interface GCDObjectTests : XCTestCase
@end

@implementation GCDObjectTests

- (void)testLogDebugMessage {
  GCDQueue *queue = [GCDQueue new];

  XCTAssertNoThrow([queue logDebugWithMessage:@"testLogDebugMessage"]);
}

- (void)testOnceBlock {
  static dispatch_once_t once = 0;
  __block int val = 0;
  
  for (int i = 0; i < 10; ++i) {
    [GCDObject syncBlock:^{ ++val; } once:&once];
  }
  
  XCTAssertEqual(val, 1);
}

@end
