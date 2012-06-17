//
//  GCDGroup.h
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

@interface GCDGroup : NSObject

@property (unsafe_unretained, nonatomic, readonly) dispatch_group_t dispatchGroup;

- (id)init;

- (void)enter;
- (void)leave;
- (long)wait:(dispatch_time_t)timeout;

@end
