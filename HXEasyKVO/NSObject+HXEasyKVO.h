//
//  NSObject+HXEasyKVO.h
//  HXEasyKVO
//
//  Created by haoxian on 2018/8/12.
//  Copyright © 2018年 haoxian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^HXKVONewValueChangeBlock)(id _Nullable observer, id object, id newValue);
typedef void (^HXKVOOldAndNewValueChangeBlock)(id _Nullable observer, id object, id oldValue, id newValue);
typedef void (^HXKVOBlock)(id _Nullable observer, id object, NSDictionary<NSKeyValueChangeKey,id> *change);

@interface NSObject (HXEasyKVO)

/*
 * NOTE: When the Block and the SEL are nil, or the SEL is not implement, that will call @selector(observeValueForKeyPath:ofObject:change:context:).
 */

-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath newValueChangeBlock:(HXKVONewValueChangeBlock _Nullable)block;
-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath queue:(dispatch_queue_t _Nullable)queue newValueChangeBlock:(HXKVONewValueChangeBlock _Nullable)block;
-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath oldAndNewValueChangeBlock:(HXKVOOldAndNewValueChangeBlock _Nullable)block;
-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath queue:(dispatch_queue_t _Nullable)queue oldAndNewValueChangeBlock:(HXKVOOldAndNewValueChangeBlock _Nullable)block;
-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void * _Nullable)context block:(HXKVOBlock _Nullable)block;
-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath queue:(dispatch_queue_t _Nullable)queue options:(NSKeyValueObservingOptions)options context:(void * _Nullable)context block:(HXKVOBlock _Nullable)block;
-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void * _Nullable)context selector:(SEL _Nullable)selector;
-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath queue:(dispatch_queue_t _Nullable)queue options:(NSKeyValueObservingOptions)options context:(void * _Nullable)context selector:(SEL _Nullable)selector;

-(void)hx_removeAllObserved;
-(void)hx_removeObserved:(NSObject *)observed;
-(void)hx_removeObserved:(NSObject *)observed forKeyPath:(NSString *)keyPath;

@end


NS_ASSUME_NONNULL_END
