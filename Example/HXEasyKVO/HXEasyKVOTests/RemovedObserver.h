//
//  RemovedObserver.h
//  KVOBlockTests
//
//  Created by hinshuang(黄浩贤) on 2018/8/12.
//  Copyright © 2018 hinshuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemovedObserver : NSObject

-(void)KVORemoveOnMainWithObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change;
-(void)KVORemoveOnConcurrentWithObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change;

@end
