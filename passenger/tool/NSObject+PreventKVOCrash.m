//
//  NSObject+PreventKVOCrash.m
//  防止数组越界
//
//  Created by 杨星星 on 2017/3/17.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "NSObject+PreventKVOCrash.h"
#import <objc/runtime.h>

@implementation NSObject (PreventKVOCrash)

+ (void)load
{
    
}

- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues {
    for (id key in keyedValues) {
        id value = keyedValues[key];
        if([value isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)value;
            if (str) {
                [self setValue:value forKey:key];
            }
            
        } else if([value isKindOfClass:[NSNull class]]) {
            [self setValue:SStringEmpty forKey:key];
            continue;
        } else {
            if (value && value > 0) {
                [self setValue:value forKey:key];
            }
        }
    }
}

//+ (void)switchMethod
//{
//    SEL removeSel = @selector(removeObserver:forKeyPath:);
//    SEL myRemoveSel = @selector(removeDasen:forKeyPath:);
//    SEL addSel = @selector(addObserver:forKeyPath:options:context:);
//    SEL myaddSel = @selector(addDasen:forKeyPath:options:context:);
//    
//    Method systemRemoveMethod = class_getClassMethod([self class],removeSel);
//    Method DasenRemoveMethod = class_getClassMethod([self class], myRemoveSel);
//    Method systemAddMethod = class_getClassMethod([self class],addSel);
//    Method DasenAddMethod = class_getClassMethod([self class], myaddSel);
//    
//    method_exchangeImplementations(systemRemoveMethod, DasenRemoveMethod);
//    method_exchangeImplementations(systemAddMethod, DasenAddMethod);
//}
//
//
//#pragma mark -
//// 交换后的方法
//- (void)removeDasen:(NSObject *)observer forKeyPath:(NSString *)keyPath
//{
//    if ([self observerKeyPath:keyPath]) {
//        [self removeDasen:observer forKeyPath:keyPath];
//    }
//}
//
//// 交换后的方法
//- (void)addDasen:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
//{
//    if (![self observerKeyPath:keyPath]) {
//        [self addDasen:observer forKeyPath:keyPath options:options context:context];
//    }
//}
//
//// 进行检索获取Key
//- (BOOL)observerKeyPath:(NSString *)key
//{
//    id info = self.observationInfo;
//    NSArray *array = [info valueForKey:@"_observances"];
//    for (id objc in array) {
//        id Properties = [objc valueForKeyPath:@"_property"];
//        NSString *keyPath = [Properties valueForKeyPath:@"_keyPath"];
//        if ([key isEqualToString:keyPath]) {
//            return YES;
//        }
//    }
//    return NO;
//}


@end
