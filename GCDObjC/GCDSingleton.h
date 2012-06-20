//
//  GCDSingleton.h
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

@interface GCDSingleton : NSObject

@property (assign, readwrite, nonatomic) dispatch_once_t once;

- (void)syncBlock:(dispatch_block_t)block;
- (void)syncFunction:(dispatch_function_t)function withContext:(void *)context;

@end
