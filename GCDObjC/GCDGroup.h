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

@property (unsafe_unretained, readonly, nonatomic) dispatch_group_t dispatchGroup;

- (void)enter;
- (void)leave;
- (long)wait:(dispatch_time_t)timeout;

@end
