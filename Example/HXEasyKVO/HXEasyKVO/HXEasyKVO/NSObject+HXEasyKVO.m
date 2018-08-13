//
//  NSObject+HXEasyKVO.m
//  HXEasyKVO
//
//  Created by haoxian on 2018/8/12.
//  Copyright © 2018年 haoxian. All rights reserved.
//

#import "NSObject+HXEasyKVO.h"
#import <objc/message.h>
#import <pthread.h>

typedef enum {
    HXKeyValueObservingTypeNew,
    HXKeyValueObservingTypeOldNew,
    HXKeyValueObservingTypeAll,
    HXKeyValueObservingTypeSEL,
} HXKeyValueObservingType;

#pragma mark - HXKVOInfo

@interface HXKVOInfo: NSObject
{
@public
    NSString * _Nonnull _keyPath;
    NSKeyValueObservingOptions _options;
    void * _Nullable _context;
    HXKeyValueObservingType _type;
    dispatch_queue_t _Nullable _queue;
    SEL _Nullable _selector;
    HXKVONewValueChangeBlock _Nullable _newBlock;
    HXKVOOldAndNewValueChangeBlock _Nullable _oldNewBlock;
    HXKVOBlock _Nullable _allBlock;
}
@end

@implementation HXKVOInfo

-(instancetype)initWithKeyPath:(NSString * _Nullable)keyPath
                       options:(NSKeyValueObservingOptions)options
                       context:(void * _Nullable)context
                       KVOType:(HXKeyValueObservingType)type
                         queue:(dispatch_queue_t _Nullable)queue
                      selector:(SEL _Nullable)selector
                      newBlock:(HXKVONewValueChangeBlock _Nullable)newBlock
                   oldNewBlock:(HXKVOOldAndNewValueChangeBlock _Nullable)oldNewBlock
                      allBlock:(HXKVOBlock _Nullable)allBlock {
    if (self = [super init]) {
        _keyPath = keyPath;
        _options = options;
        _context = context;
        _type = type;
        _queue = queue;
        _newBlock = newBlock;
        _oldNewBlock = oldNewBlock;
        _allBlock = allBlock;
        _selector = selector;
    }
    return self;
}

@end

#pragma mark - HXKVOHandler

@interface HXKVOHandler : NSObject
{
    __weak id _caller;
    NSMapTable<NSObject *, NSMutableDictionary<NSString *, HXKVOInfo *> *> * _observedInfosMap;
    pthread_rwlock_t _lock;
}
@end


@implementation HXKVOHandler

+(instancetype)handlerWithCaller:(id)caller {
    return [[self alloc] initHandlerWithCaller:caller];
}

-(instancetype)initHandlerWithCaller:(id)caller {
    if (self = [super init]) {
        _caller = caller;
        _observedInfosMap = [NSMapTable mapTableWithKeyOptions:(NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality)
                                                  valueOptions:(NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPointerPersonality)];
        pthread_rwlock_init(&_lock, NULL);
    }
    return self;
}

-(void)observerWithObserved:(nonnull NSObject *)observed andInfo:(HXKVOInfo *)info {
    pthread_rwlock_wrlock(&_lock);
    NSMutableDictionary<NSString *, HXKVOInfo *> *dict = [_observedInfosMap objectForKey:observed];
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    if ([dict objectForKey:info->_keyPath]) {
        [observed removeObserver:self forKeyPath:info->_keyPath];
    }
    [dict setObject:info forKey:info->_keyPath];
    [_observedInfosMap setObject:dict forKey:observed];
    [observed addObserver:self forKeyPath:info->_keyPath options:info->_options context:info->_context];
    pthread_rwlock_unlock(&_lock);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    pthread_rwlock_rdlock(&_lock);
    NSMutableDictionary<NSString *, HXKVOInfo *> *dict = [_observedInfosMap objectForKey:object];
    NSCParameterAssert(dict);
    HXKVOInfo *info = dict[keyPath];
    NSCParameterAssert(info);
    NSCParameterAssert(info->_queue);
    id copy = [change copy]; // 系统bug？old value会在指派线程时设置为nil，这里copy保存一下
    dispatch_async(info->_queue, ^{
        [self invokeWithInfo:info object:object change:copy context:context];
    });
    pthread_rwlock_unlock(&_lock);
}

-(void)invokeWithInfo:(HXKVOInfo *)info object:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    switch (info->_type) {
        case HXKeyValueObservingTypeNew:
            if (info->_newBlock) {
                id newValue = change[NSKeyValueChangeNewKey];
                info->_newBlock(self, object, newValue);
                return;
            }
            break;
        case HXKeyValueObservingTypeOldNew:
            if (info->_oldNewBlock) {
                id oldValue = change[NSKeyValueChangeOldKey];
                id newValue = change[NSKeyValueChangeNewKey];
                info->_oldNewBlock(self, object, oldValue, newValue);
                return;
            }
            break;
        case HXKeyValueObservingTypeAll:
            if (info->_allBlock) {
                info->_allBlock(self, object, change);
                return;
            }
            break;
        case HXKeyValueObservingTypeSEL:
            if (_caller && info->_selector && [_caller respondsToSelector:info->_selector]) {
                // https://www.jianshu.com/p/cbe9f21cee81
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [_caller performSelector:info->_selector withObject:object withObject:change];
#pragma clang diagnostic pop
                return;
            }
            break;
    }
    dispatch_async(info->_queue, ^{
        [self->_caller observeValueForKeyPath:info->_keyPath ofObject:object change:change context:context];
    });
}

-(void)removeAllObserverd {
    [self removeObserved:nil];
}

-(void)removeObserved:(NSObject *)observed {
    [self removeObserved:observed keyPath:nil];
}

-(void)removeObserved:(NSObject *)observed keyPath:(NSString *)keyPath {
    pthread_rwlock_wrlock(&_lock);
    if (_observedInfosMap.count == 0) { return; }
    if (observed) {
        NSMutableDictionary<NSString *, HXKVOInfo *> *dict = [_observedInfosMap objectForKey:observed];
        if (dict) {
            if (keyPath) {
                if ([dict objectForKey:keyPath]) {
                    [dict removeObjectForKey:keyPath];
                    [observed removeObserver:self forKeyPath:keyPath];
                }
            } else {
                for (NSString *key in [dict keyEnumerator]) {
                    [observed removeObserver:self forKeyPath:key];
                }
                [dict removeAllObjects];
                [_observedInfosMap removeObjectForKey:observed];
            }
        }
    } else {
        for (NSObject *mapKey in [_observedInfosMap keyEnumerator]) {
            NSMutableDictionary<NSString *, HXKVOInfo *> *dict = [_observedInfosMap objectForKey:mapKey];
            for (NSString *key in [dict keyEnumerator]) {
                [mapKey removeObserver:self forKeyPath:key];
            }
            [dict removeAllObjects];
        }
        [_observedInfosMap removeAllObjects];
    }
    pthread_rwlock_unlock(&_lock);
}



- (void)dealloc
{
    [self removeAllObserverd];
    pthread_rwlock_destroy(&_lock);
}

@end


#pragma mark - NSObject+HXEasyKVO

@implementation NSObject (HXEasyKVO)

static char kKVOHandlerKey;

-(void)setKVOHandler:(HXKVOHandler *)hander {
    objc_setAssociatedObject(self, &kKVOHandlerKey, hander, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(HXKVOHandler *)KVOHandler {
    HXKVOHandler *handler = objc_getAssociatedObject(self, &kKVOHandlerKey);
    if (!handler) {
        handler = [HXKVOHandler handlerWithCaller:self];
        [self setKVOHandler:handler];
    }
    return handler;
}

-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath newValueChangeBlock:(HXKVONewValueChangeBlock _Nullable)block {
    [self hx_observe:observed forKeyPath:keyPath queue:dispatch_get_main_queue() newValueChangeBlock:block];
}

-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath queue:(dispatch_queue_t)queue newValueChangeBlock:(HXKVONewValueChangeBlock _Nullable)block {
    HXKVOInfo *info = [[HXKVOInfo alloc] initWithKeyPath:keyPath options:(NSKeyValueObservingOptionNew) context:nil KVOType:(HXKeyValueObservingTypeNew) queue:queue selector:nil newBlock:block oldNewBlock:nil allBlock:nil];
    [self.KVOHandler observerWithObserved:observed andInfo:info];
}

-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath oldAndNewValueChangeBlock:(HXKVOOldAndNewValueChangeBlock)block {
    [self hx_observe:observed forKeyPath:keyPath queue:dispatch_get_main_queue() oldAndNewValueChangeBlock:block];
}

-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath queue:(dispatch_queue_t)queue oldAndNewValueChangeBlock:(HXKVOOldAndNewValueChangeBlock _Nullable)block {
    HXKVOInfo *info = [[HXKVOInfo alloc] initWithKeyPath:keyPath options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil KVOType:(HXKeyValueObservingTypeOldNew) queue:queue selector:nil newBlock:nil oldNewBlock:block allBlock:nil];
    [self.KVOHandler observerWithObserved:observed andInfo:info];
}

-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context block:(HXKVOBlock _Nullable)block {
    [self hx_observe:observed forKeyPath:keyPath queue:dispatch_get_main_queue() options:options context:context block:block];
}

-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath queue:(dispatch_queue_t)queue options:(NSKeyValueObservingOptions)options context:(void *)context block:(HXKVOBlock _Nullable)block {
    HXKVOInfo *info = [[HXKVOInfo alloc] initWithKeyPath:keyPath options:options context:nil KVOType:(HXKeyValueObservingTypeAll) queue:queue selector:nil newBlock:nil oldNewBlock:nil allBlock:block];
    [self.KVOHandler observerWithObserved:observed andInfo:info];
}

-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context selector:(SEL _Nullable)selector {
    [self hx_observe:observed forKeyPath:keyPath queue:dispatch_get_main_queue() options:options context:context selector:selector];
}

-(void)hx_observe:(NSObject *)observed forKeyPath:(NSString *)keyPath queue:(dispatch_queue_t)queue options:(NSKeyValueObservingOptions)options context:(void *)context selector:(SEL _Nullable)selector {
    HXKVOInfo *info = [[HXKVOInfo alloc] initWithKeyPath:keyPath options:options context:nil KVOType:(HXKeyValueObservingTypeSEL) queue:queue selector:selector newBlock:nil oldNewBlock:nil allBlock:nil];
    [self.KVOHandler observerWithObserved:observed andInfo:info];
}



-(void)hx_removeAllObserved {
    [self.KVOHandler removeAllObserverd];
}

-(void)hx_removeObserved:(NSObject *)observed {
    if (!observed) { return; }
    [self.KVOHandler removeObserved:observed];
}

-(void)hx_removeObserved:(NSObject *)observed forKeyPath:(NSString *)keyPath {
    if (!observed) { return; }
    [self.KVOHandler removeObserved:observed keyPath:keyPath];
}

@end

