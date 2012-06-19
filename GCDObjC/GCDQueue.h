//
//  GCDQueue.h
//  GCDObjC
//
//  Copyright (c) 2012 Mark Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

#import "GCDObject.h"

@class GCDGroup;

@interface GCDQueue : GCDObject

@property (unsafe_unretained, readonly, nonatomic) dispatch_queue_t dispatchQueue;

+ (GCDQueue *)mainQueue;
+ (GCDQueue *)globalQueue;
+ (GCDQueue *)highPriorityGlobalQueue;
+ (GCDQueue *)lowPriorityGlobalQueue;
+ (GCDQueue *)backgroundPriorityGlobalQueue;
+ (GCDQueue *)currentQueue;

- (id)initSerial;
- (id)initSerialWithLabel:(NSString *)label;
- (id)initConcurrent;
- (id)initConcurrentWithLabel:(NSString *)label;
- (id)initWithLabel:(NSString *)label attr:(dispatch_queue_attr_t)attr;

- (void)asyncBlock:(dispatch_block_t)block;
- (void)asyncBlock:(dispatch_block_t)block inGroup:(GCDGroup *)group;
- (void)asyncBlock:(dispatch_block_t)block afterSeconds:(double)seconds;

- (void)asyncBarrierBlock:(dispatch_block_t)block;
- (void)asyncNotifyBlock:(dispatch_block_t)block inGroup:(GCDGroup *)group;

- (void)syncBlock:(dispatch_block_t)block;
- (void)syncBlock:(void (^)(size_t))block count:(size_t)count;

- (void)syncBarrierBlock:(dispatch_block_t)block;

- (void)asyncFunction:(dispatch_function_t)function withContext:(void *)context;
- (void)asyncFunction:(dispatch_function_t)function withContext:(void *)context inGroup:(GCDGroup *)group;
- (void)asyncFunction:(dispatch_function_t)function withContext:(void *)context afterSeconds:(double)seconds;

- (void)asyncBarrierFunction:(dispatch_function_t)function withContext:(void *)context;
- (void)asyncNotifyFunction:(dispatch_function_t)function withContext:(void *)context inGroup:(GCDGroup *)group;

- (void)syncFunction:(dispatch_function_t)function withContext:(void *)context;
- (void)syncFunction:(void (*)(void *, size_t))function withContext:(void *)context count:(size_t)count;

- (void)syncBarrierFunction:(dispatch_function_t)function withContext:(void *)context;

- (BOOL)isCurrentQueue;

- (void)suspend;
- (void)resume;

- (NSString *)label;

- (void)setContext:(void *)context forKey:(const void *)key destructor:(dispatch_function_t)destructor;
- (void *)contextForKey:(const void *)key;

@end
