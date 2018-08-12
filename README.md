# HXEasyKVO
Easy to use KVO in Obj-C by Block or SEL.

## Installation
HXEasyKVO is available through CocoaPods. To install it, simply add the following line to your Podfile:

``` 
pod 'HXEasyKVO'
```

## Example:
#### import the header file

``` OBJC
#import "ViewController.h"
#import "NSObject+HXEasyKVO.h"

@interface ViewController ()
{
    dispatch_queue_t _queue;
}
@property (nonatomic) UILabel *label;
@property (nonatomic) NSObject *o1;
@property (nonatomic) NSObject *o2;
@property (nonatomic) NSObject *o3;
@property (nonatomic) NSObject *o4;
@property (nonatomic) NSObject *o5;
@property (nonatomic) NSObject *o6;
@property (nonatomic) NSObject *o7;
@property (nonatomic) NSObject *o8;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _queue = dispatch_queue_create("test", NULL);
    _label = [UILabel new];
    _label.text = @"old";
    
    _o1 = [NSObject new];
    _o2 = [NSObject new];
    _o3 = [NSObject new];
    _o4 = [NSObject new];
    _o5 = [NSObject new];
    _o6 = [NSObject new];
    _o7 = [NSObject new];
    _o8 = [NSObject new];
    
    [_o1 hx_observe:_label forKeyPath:@"text" newValueChangeBlock:^(id  _Nullable observer, id  _Nonnull object, id newValue) {
        NSAssert([NSThread.currentThread isMainThread], nil);
        NSLog(@"-1- thread - %@, newValue - %@", NSThread.currentThread, newValue);
    }];
    
    [_o2 hx_observe:_label forKeyPath:@"text" queue:_queue newValueChangeBlock:^(id  _Nullable observer, id  _Nonnull object, id newValue) {
        NSAssert(![NSThread.currentThread isMainThread], nil);
        NSAssert([newValue isEqualToString:@"new"], nil);
        NSLog(@"-2- thread - %@, newValue - %@", NSThread.currentThread, newValue);
    }];
    
    [_o3 hx_observe:_label forKeyPath:@"text" oldAndNewValueChangeBlock:^(id  _Nullable observer, id  _Nonnull object, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSAssert([NSThread.currentThread isMainThread], nil);
        NSLog(@"-3- oldValue - %@, newValue - %@", oldValue, newValue);
    }];
    
    [_o4 hx_observe:_label forKeyPath:@"text" queue:_queue oldAndNewValueChangeBlock:^(id  _Nullable observer, id  _Nonnull object, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSAssert(![NSThread.currentThread isMainThread], nil);
        NSLog(@"-4- thread - %@, oldValue - %@, newValue - %@", NSThread.currentThread, oldValue, newValue);
    }];
    
    [_o5 hx_observe:_label forKeyPath:@"text" options:(NSKeyValueObservingOptionNew) context:nil block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSAssert([NSThread.currentThread isMainThread], nil);
        id newValue = change[NSKeyValueChangeNewKey];
        NSLog(@"-5- thread - %@, newValue - %@", NSThread.currentThread, newValue);
    }];
    
    [_o6 hx_observe:_label forKeyPath:@"text" queue:_queue options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSAssert(![NSThread.currentThread isMainThread], nil);
        id oldValue = change[NSKeyValueChangeOldKey];
        id newValue = change[NSKeyValueChangeNewKey];
        NSLog(@"-6- thread - %@, oldValue - %@, newValue - %@", NSThread.currentThread, oldValue, newValue);
    }];
    
    [_o7 hx_observe:_label forKeyPath:@"text" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil selector:@selector(KVOInvokeOnMainThreadWithObject:change:)];
    
    [_o8 hx_observe:_label forKeyPath:@"text" queue:_queue options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil selector:@selector(KVOInvokeOnConcurrentThreadWithObject:change:)];
    
    // invoke observeValueForKeyPath:ofObject:change:context:
    [self hx_observe:_label forKeyPath:@"text" queue:_queue options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil  block:nil];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _label.text = @"new";
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSAssert([keyPath isEqualToString:@"text"], nil);
    id oldValue = change[NSKeyValueChangeOldKey];
    id newValue = change[NSKeyValueChangeNewKey];
    NSLog(@"-9- thread - %@, oldValue - %@, newValue - %@", NSThread.currentThread, oldValue, newValue);
}


@end

@implementation NSObject (Test)

-(void)KVOInvokeOnMainThreadWithObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    NSAssert([NSThread.currentThread isMainThread], nil);
    id oldValue = change[NSKeyValueChangeOldKey];
    id newValue = change[NSKeyValueChangeNewKey];
    NSLog(@"-7- thread - %@, oldValue - %@, newValue - %@", NSThread.currentThread, oldValue, newValue);
}

-(void)KVOInvokeOnConcurrentThreadWithObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    NSAssert(![NSThread.currentThread isMainThread], nil);
    id oldValue = change[NSKeyValueChangeOldKey];
    id newValue = change[NSKeyValueChangeNewKey];
    NSLog(@"-8- thread - %@, oldValue - %@, newValue - %@", NSThread.currentThread, oldValue, newValue);
}

@end
```

## Author
hins Huang, 505608099@qq.com

## License
HXEasyKVO is available under the MIT license. See the LICENSE file for more info.



