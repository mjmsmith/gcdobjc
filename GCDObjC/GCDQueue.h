//
//  GCDQueue.h
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import "GCDObject.h"

@class GCDGroup;

@interface GCDQueue : GCDObject

@property (assign, readonly, nonatomic) dispatch_queue_t dispatchQueue;

+ (GCDQueue *)mainQueue;
+ (GCDQueue *)globalQueue;
+ (GCDQueue *)highPriorityGlobalQueue;
+ (GCDQueue *)lowPriorityGlobalQueue;
+ (GCDQueue *)backgroundPriorityGlobalQueue;
+ (GCDQueue *)currentQueue;

- (instancetype)initSerial;
- (instancetype)initConcurrent;

- (void)asyncBlock:(dispatch_block_t)block;
- (void)asyncBlock:(dispatch_block_t)block inGroup:(GCDGroup *)group;
- (void)asyncBlock:(dispatch_block_t)block afterDelay:(double)seconds;

- (void)asyncBarrierBlock:(dispatch_block_t)block;
- (void)asyncNotifyBlock:(dispatch_block_t)block inGroup:(GCDGroup *)group;

- (void)syncBlock:(dispatch_block_t)block;
- (void)syncBlock:(void (^)(size_t))block count:(size_t)count;

- (void)syncBarrierBlock:(dispatch_block_t)block;

- (BOOL)isCurrentQueue;

- (void)suspend;
- (void)resume;

@end
