//
//  Observer.h
//  KVOBlockTests
//
//  Created by hinshuang(黄浩贤) on 2018/8/12.
//  Copyright © 2018 hinshuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Observer : NSObject


-(void)KVOInvokeOnMainThreadWithObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change;
-(void)KVOInvokeOnConcurrentThreadWithObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change;


@end
