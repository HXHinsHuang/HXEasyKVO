//
//  HXEasyKVOTests.m
//  HXEasyKVOTests
//
//  Created by haoxian on 2018/8/12.
//  Copyright © 2018年 haoxian. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Observer.h"
#import "RemovedObserver.h"
#import "NSObject+HXEasyKVO.h"

@interface HXEasyKVOTests : XCTestCase
{
    dispatch_queue_t _queue;
}
@property (nonatomic) UILabel *label;
@property (nonatomic) UILabel *label2;
@property (nonatomic) Observer *o1;
@property (nonatomic) Observer *o2;
@property (nonatomic) Observer *o3;
@property (nonatomic) Observer *o4;
@property (nonatomic) Observer *o5;
@property (nonatomic) Observer *o6;
@property (nonatomic) Observer *o7;
@property (nonatomic) Observer *o8;
@property (nonatomic) Observer *o9;
@property (nonatomic) Observer *o10;
@property (nonatomic) RemovedObserver *ro1;
@property (nonatomic) RemovedObserver *ro2;
@property (nonatomic) RemovedObserver *ro3;
@property (nonatomic) RemovedObserver *ro4;
@property (nonatomic) RemovedObserver *ro5;
@property (nonatomic) RemovedObserver *ro6;
@property (nonatomic) RemovedObserver *ro7;
@property (nonatomic) RemovedObserver *ro8;
@property (nonatomic) RemovedObserver *ro9;
@property (nonatomic) RemovedObserver *ro10;
@end

@implementation HXEasyKVOTests

- (void)setUp {
    [super setUp];
    _queue = dispatch_queue_create("test", NULL);
    _label = [UILabel new];
    _label.text = @"old";
    _label2 = [UILabel new];
    _label2.text = @"old";
    _o1 = [Observer new];
    _o2 = [Observer new];
    _o3 = [Observer new];
    _o4 = [Observer new];
    _o5 = [Observer new];
    _o6 = [Observer new];
    _o7 = [Observer new];
    _o8 = [Observer new];
    _o9 = [Observer new];
    _o10 = [Observer new];
    _ro1 = [RemovedObserver new];
    _ro2 = [RemovedObserver new];
    _ro3 = [RemovedObserver new];
    _ro4 = [RemovedObserver new];
    _ro5 = [RemovedObserver new];
    _ro6 = [RemovedObserver new];
    _ro7 = [RemovedObserver new];
    _ro8 = [RemovedObserver new];
    _ro9 = [RemovedObserver new];
    _ro10 = [RemovedObserver new];
}

- (void)tearDown {
    _label = nil;
    _o1 = nil;
    _o2 = nil;
    _o3 = nil;
    _o4 = nil;
    _o5 = nil;
    _o6 = nil;
    _o7 = nil;
    _o8 = nil;
    _o9 = nil;
    _ro1 = nil;
    _ro2 = nil;
    _ro3 = nil;
    _ro4 = nil;
    _ro5 = nil;
    _ro6 = nil;
    _ro7 = nil;
    _ro8 = nil;
    _ro9 = nil;
    _ro10 = nil;
    [super tearDown];
}

- (void)testInvoke {
    
    [_o1 hx_observe:_label forKeyPath:@"text" newValueChangeBlock:^(id  _Nullable observer, id  _Nonnull object, id newValue) {
        NSAssert([NSThread.currentThread isMainThread], nil);
        NSAssert([newValue isEqualToString:@"new"], nil);
    }];
    
    [_o2 hx_observe:_label forKeyPath:@"text" queue:_queue newValueChangeBlock:^(id  _Nullable observer, id  _Nonnull object, id newValue) {
        NSAssert(![NSThread.currentThread isMainThread], nil);
        NSAssert([newValue isEqualToString:@"new"], nil);
    }];
    
    [_o3 hx_observe:_label forKeyPath:@"text" oldAndNewValueChangeBlock:^(id  _Nullable observer, id  _Nonnull object, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSAssert([NSThread.currentThread isMainThread], nil);
        NSAssert([oldValue isEqualToString:@"old"] && [newValue isEqualToString:@"new"], nil);
    }];
    
    [_o4 hx_observe:_label forKeyPath:@"text" queue:_queue oldAndNewValueChangeBlock:^(id  _Nullable observer, id  _Nonnull object, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSAssert(![NSThread.currentThread isMainThread], nil);
        NSAssert([oldValue isEqualToString:@"old"] && [newValue isEqualToString:@"new"], nil);
    }];
    
    [_o5 hx_observe:_label forKeyPath:@"text" options:(NSKeyValueObservingOptionNew) context:nil block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSAssert([NSThread.currentThread isMainThread], nil);
        id newValue = change[NSKeyValueChangeNewKey];
        NSAssert([newValue isEqualToString:@"new"], nil);
    }];
    
    [_o6 hx_observe:_label forKeyPath:@"text" queue:_queue options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSAssert(![NSThread.currentThread isMainThread], nil);
        id oldValue = change[NSKeyValueChangeOldKey];
        id newValue = change[NSKeyValueChangeNewKey];
        NSAssert([oldValue isEqualToString:@"old"] && [newValue isEqualToString:@"new"], nil);
    }];
    
    [_o7 hx_observe:_label forKeyPath:@"text" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil selector:@selector(KVOInvokeOnMainThreadWithObject:change:)];
    
    [_o8 hx_observe:_label forKeyPath:@"text" queue:_queue options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil selector:@selector(KVOInvokeOnConcurrentThreadWithObject:change:)];
    
    [_o9 hx_observe:_label forKeyPath:@"text" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil block:nil];
    
    [_o10 hx_observe:_label forKeyPath:@"text" queue:_queue options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil  block:nil];
    
    
    
    [_o1 hx_observe:_label2 forKeyPath:@"text" newValueChangeBlock:^(id  _Nullable observer, id  _Nonnull object, id newValue) {
        NSAssert([NSThread.currentThread isMainThread], nil);
        NSAssert([newValue isEqualToString:@"new"], nil);
    }];
    
    [_o2 hx_observe:_label2 forKeyPath:@"text" queue:_queue newValueChangeBlock:^(id  _Nullable observer, id  _Nonnull object, id newValue) {
        NSAssert(![NSThread.currentThread isMainThread], nil);
        NSAssert([newValue isEqualToString:@"new"], nil);
    }];
    
    [_o3 hx_observe:_label2 forKeyPath:@"text" oldAndNewValueChangeBlock:^(id  _Nullable observer, id  _Nonnull object, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSAssert([NSThread.currentThread isMainThread], nil);
        NSAssert([oldValue isEqualToString:@"old"] && [newValue isEqualToString:@"new"], nil);
    }];
    
    [_o4 hx_observe:_label2 forKeyPath:@"text" queue:_queue oldAndNewValueChangeBlock:^(id  _Nullable observer, id  _Nonnull object, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSAssert(![NSThread.currentThread isMainThread], nil);
        NSAssert([oldValue isEqualToString:@"old"] && [newValue isEqualToString:@"new"], nil);
    }];
    
    [_o5 hx_observe:_label2 forKeyPath:@"text" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSAssert([NSThread.currentThread isMainThread], nil);
        id oldValue = change[NSKeyValueChangeOldKey];
        id newValue = change[NSKeyValueChangeNewKey];
        NSAssert([oldValue isEqualToString:@"old"] && [newValue isEqualToString:@"new"], nil);
    }];
    
    [_o6 hx_observe:_label2 forKeyPath:@"text" queue:_queue options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSAssert(![NSThread.currentThread isMainThread], nil);
        id oldValue = change[NSKeyValueChangeOldKey];
        id newValue = change[NSKeyValueChangeNewKey];
        NSAssert([oldValue isEqualToString:@"old"] && [newValue isEqualToString:@"new"], nil);
    }];
    
    [_o7 hx_observe:_label2 forKeyPath:@"text" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil selector:@selector(KVOInvokeOnMainThreadWithObject:change:)];
    
    [_o8 hx_observe:_label2 forKeyPath:@"text" queue:_queue options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil selector:@selector(KVOInvokeOnConcurrentThreadWithObject:change:)];
    
    [_o9 hx_observe:_label2 forKeyPath:@"text" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil block:nil];
    
    [_o10 hx_observe:_label2 forKeyPath:@"text" queue:_queue options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil  block:nil];
    
    _label.text = @"new";
    _label2.text = @"new";
}

- (void)configRemove {
    [_ro1 hx_observe:_label forKeyPath:@"text" newValueChangeBlock:^(id  _Nullable observer, id  _Nonnull object, id newValue) {
        XCTFail();
    }];
    
    [_ro2 hx_observe:_label forKeyPath:@"text" queue:_queue newValueChangeBlock:^(id  _Nullable observer, id  _Nonnull object, id newValue) {
        XCTFail();
    }];
    
    [_ro3 hx_observe:_label forKeyPath:@"text" oldAndNewValueChangeBlock:^(id  _Nullable observer, id  _Nonnull object, id  _Nonnull oldValue, id  _Nonnull newValue) {
        XCTFail();
    }];
    
    [_ro4 hx_observe:_label forKeyPath:@"text" queue:_queue oldAndNewValueChangeBlock:^(id  _Nullable observer, id  _Nonnull object, id  _Nonnull oldValue, id  _Nonnull newValue) {
        XCTFail();
    }];
    
    [_ro5 hx_observe:_label forKeyPath:@"text" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        XCTFail();
    }];
    
    [_ro6 hx_observe:_label forKeyPath:@"text" queue:_queue options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        XCTFail();
    }];
    
    [_ro7 hx_observe:_label forKeyPath:@"text" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil selector:@selector(KVORemoveOnMainWithObject:change:)];
    
    [_ro8 hx_observe:_label forKeyPath:@"text" queue:_queue options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil selector:@selector(KVORemoveOnConcurrentWithObject:change:)];
    
    [_ro9 hx_observe:_label forKeyPath:@"text" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil block:nil];
    
    [_o10 hx_observe:_label forKeyPath:@"text" queue:_queue options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil  block:nil];
    
    
    [_ro1 hx_observe:_label2 forKeyPath:@"text" newValueChangeBlock:^(id  _Nullable observer, id  _Nonnull object, id newValue) {
        XCTFail();
    }];
    
    [_ro2 hx_observe:_label2 forKeyPath:@"text" queue:_queue newValueChangeBlock:^(id  _Nullable observer, id  _Nonnull object, id newValue) {
        XCTFail();
    }];
    
    [_ro3 hx_observe:_label2 forKeyPath:@"text" oldAndNewValueChangeBlock:^(id  _Nullable observer, id  _Nonnull object, id  _Nonnull oldValue, id  _Nonnull newValue) {
        XCTFail();
    }];
    
    [_ro4 hx_observe:_label2 forKeyPath:@"text" queue:_queue oldAndNewValueChangeBlock:^(id  _Nullable observer, id  _Nonnull object, id  _Nonnull oldValue, id  _Nonnull newValue) {
        XCTFail();
    }];
    
    [_ro5 hx_observe:_label2 forKeyPath:@"text" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        XCTFail();
    }];
    
    [_ro6 hx_observe:_label2 forKeyPath:@"text" queue:_queue options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        XCTFail();
    }];
    
    [_ro7 hx_observe:_label2 forKeyPath:@"text" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil selector:@selector(KVORemoveOnMainWithObject:change:)];
    
    [_ro8 hx_observe:_label2 forKeyPath:@"text" queue:_queue options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil selector:@selector(KVORemoveOnConcurrentWithObject:change:)];
    
    [_ro9 hx_observe:_label2 forKeyPath:@"text" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil block:nil];
    
    [_o10 hx_observe:_label2 forKeyPath:@"text" queue:_queue options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil  block:nil];
}

- (void)testRemoveAllObserver {
    
    [self configRemove];
    [_ro1 hx_removeAllObserved];
    [_ro2 hx_removeAllObserved];
    [_ro3 hx_removeAllObserved];
    [_ro4 hx_removeAllObserved];
    [_ro5 hx_removeAllObserved];
    [_ro6 hx_removeAllObserved];
    [_ro7 hx_removeAllObserved];
    [_ro8 hx_removeAllObserved];
    [_ro9 hx_removeAllObserved];
    [_ro10 hx_removeAllObserved];
    
    _label.text = @"new";
}

- (void)testRemoveObserver {
    
    [self configRemove];
    [_ro1 hx_removeObserved:_label];
    [_ro2 hx_removeObserved:_label];
    [_ro3 hx_removeObserved:_label];
    [_ro4 hx_removeObserved:_label];
    [_ro5 hx_removeObserved:_label];
    [_ro6 hx_removeObserved:_label];
    [_ro7 hx_removeObserved:_label];
    [_ro8 hx_removeObserved:_label];
    [_ro9 hx_removeObserved:_label];
    [_ro10 hx_removeObserved:_label];
    
    [_ro1 hx_removeObserved:_label2];
    [_ro2 hx_removeObserved:_label2];
    [_ro3 hx_removeObserved:_label2];
    [_ro4 hx_removeObserved:_label2];
    [_ro5 hx_removeObserved:_label2];
    [_ro6 hx_removeObserved:_label2];
    [_ro7 hx_removeObserved:_label2];
    [_ro8 hx_removeObserved:_label2];
    [_ro9 hx_removeObserved:_label2];
    [_ro10 hx_removeObserved:_label2];
    
    _label.text = @"new";
}

- (void)testRemoveObserverKeyPath {
    
    [self configRemove];
    [_ro1 hx_removeObserved:_label forKeyPath:@"text"];
    [_ro2 hx_removeObserved:_label forKeyPath:@"text"];
    [_ro3 hx_removeObserved:_label forKeyPath:@"text"];
    [_ro4 hx_removeObserved:_label forKeyPath:@"text"];
    [_ro5 hx_removeObserved:_label forKeyPath:@"text"];
    [_ro6 hx_removeObserved:_label forKeyPath:@"text"];
    [_ro7 hx_removeObserved:_label forKeyPath:@"text"];
    [_ro8 hx_removeObserved:_label forKeyPath:@"text"];
    [_ro9 hx_removeObserved:_label forKeyPath:@"text"];
    [_ro10 hx_removeObserved:_label forKeyPath:@"text"];
    
    [_ro1 hx_removeObserved:_label2 forKeyPath:@"text"];
    [_ro2 hx_removeObserved:_label2 forKeyPath:@"text"];
    [_ro3 hx_removeObserved:_label2 forKeyPath:@"text"];
    [_ro4 hx_removeObserved:_label2 forKeyPath:@"text"];
    [_ro5 hx_removeObserved:_label2 forKeyPath:@"text"];
    [_ro6 hx_removeObserved:_label2 forKeyPath:@"text"];
    [_ro7 hx_removeObserved:_label2 forKeyPath:@"text"];
    [_ro8 hx_removeObserved:_label2 forKeyPath:@"text"];
    [_ro9 hx_removeObserved:_label2 forKeyPath:@"text"];
    [_ro10 hx_removeObserved:_label2 forKeyPath:@"text"];
    
    _label.text = @"new";
}

- (void)testRemoveObserverNil {
    
    [self configRemove];
    _ro1 = nil;
    _ro2 = nil;
    _ro3 = nil;
    _ro4 = nil;
    _ro5 = nil;
    _ro6 = nil;
    _ro7 = nil;
    _ro8 = nil;
    _ro9 = nil;
    _ro10 = nil;
    
    _label.text = @"new";
}

- (void)testNilObserved {
    
    [self configRemove];
    _label = nil;
    _label2 = nil;
    XCTAssertNil(_label);
    XCTAssertNil(_label2);
}


@end
