//
//  GCDObject.h
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

@interface GCDObject : NSObject

@property (assign, readonly, nonatomic) dispatch_object_t dispatchObject;
@property (assign, readwrite, nonatomic) void *context;

- (id)initWithDispatchObject:(dispatch_object_t)dispatchObject;

@end
