//
//  GCDGroup.h
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

#import "GCDObject.h"

@interface GCDGroup : GCDObject

@property (assign, readonly, nonatomic) dispatch_group_t dispatchGroup;

+ (GCDGroup *)group;

- (void)enter;
- (void)leave;
- (long)wait;
- (long)wait:(double)seconds;

@end
