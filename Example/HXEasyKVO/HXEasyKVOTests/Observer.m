//
//  Observer.m
//  KVOBlockTests
//
//  Created by hinshuang(黄浩贤) on 2018/8/12.
//  Copyright © 2018 hinshuang. All rights reserved.
//

#import "Observer.h"

@implementation Observer

-(void)KVOInvokeOnMainThreadWithObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    NSAssert([NSThread.currentThread isMainThread], nil);
    id oldValue = change[NSKeyValueChangeOldKey];
    id newValue = change[NSKeyValueChangeNewKey];
    NSAssert([oldValue isEqualToString:@"old"] && [newValue isEqualToString:@"new"], nil);
}

-(void)KVOInvokeOnConcurrentThreadWithObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    NSAssert(![NSThread.currentThread isMainThread], nil);
    id oldValue = change[NSKeyValueChangeOldKey];
    id newValue = change[NSKeyValueChangeNewKey];
    NSAssert([oldValue isEqualToString:@"old"] && [newValue isEqualToString:@"new"], nil);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSAssert([keyPath isEqualToString:@"text"], nil);
    id oldValue = change[NSKeyValueChangeOldKey];
    id newValue = change[NSKeyValueChangeNewKey];
    NSAssert([oldValue isEqualToString:@"old"] && [newValue isEqualToString:@"new"], nil);
    
}

@end
