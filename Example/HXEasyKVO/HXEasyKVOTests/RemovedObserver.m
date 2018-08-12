//
//  RemovedObserver.m
//  KVOBlockTests
//
//  Created by hinshuang(黄浩贤) on 2018/8/12.
//  Copyright © 2018 hinshuang. All rights reserved.
//

#import "RemovedObserver.h"

@implementation RemovedObserver

-(void)KVORemoveOnMainWithObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    NSAssert(YES, nil);
}

-(void)KVORemoveOnConcurrentWithObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    NSAssert(YES, nil);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSAssert(YES, nil);
}

@end
