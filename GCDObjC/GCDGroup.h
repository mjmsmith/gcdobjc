//
//  GCDGroup.h
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import "GCDObject.h"

@interface GCDGroup : GCDObject

@property (assign, readonly, nonatomic) dispatch_group_t dispatchGroup;

- (instancetype)init;

- (void)enter;
- (void)leave;
- (long)wait;
- (long)wait:(double)seconds;

@end
