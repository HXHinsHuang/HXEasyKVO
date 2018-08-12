//
//  NSObject+HXEasyKVO.h
//  HXEasyKVO
//
//  Created by haoxian on 2018/8/12.
//  Copyright © 2018年 haoxian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^KVONewValueChangeBlock)(id _Nullable observer, id object, id newValue);
typedef void (^KVOOldAndNewValueChangeBlock)(id _Nullable observer, id object, id oldValue, id newValue);
typedef void (^KVOBlock)(id _Nullable observer, id object, NSDictionary<NSKeyValueChangeKey,id> *change);

@interface NSObject (HXEasyKVO)

-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath newValueChangeBlock:(KVONewValueChangeBlock _Nullable)block;
-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath queue:(dispatch_queue_t _Nullable)queue newValueChangeBlock:(KVONewValueChangeBlock _Nullable)block;
-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath oldAndNewValueChangeBlock:(KVOOldAndNewValueChangeBlock _Nullable)block;
-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath queue:(dispatch_queue_t _Nullable)queue oldAndNewValueChangeBlock:(KVOOldAndNewValueChangeBlock _Nullable)block;
-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void * _Nullable)context block:(KVOBlock _Nullable)block;
-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath queue:(dispatch_queue_t _Nullable)queue options:(NSKeyValueObservingOptions)options context:(void * _Nullable)context block:(KVOBlock _Nullable)block;
-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void * _Nullable)context selector:(SEL _Nullable)selector;
-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath queue:(dispatch_queue_t _Nullable)queue options:(NSKeyValueObservingOptions)options context:(void * _Nullable)context selector:(SEL _Nullable)selector;

-(void)hx_removeAllObserved;
-(void)hx_removeObserved:(NSObject *)observed;
-(void)hx_removeObserved:(NSObject *)observed forKeyPath:(NSString *)keyPath;

@end


NS_ASSUME_NONNULL_END
