//
//  NSDictionary+Custom.m
//  114SD
//
//  Created by 杨星星 on 2017/3/30.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "NSDictionary+Custom.h"

@implementation NSDictionary (Custom)

//+ (void)load {
//    [super load];
//
//    //  替换不可变数组中的方法
//    Method oldMethod1 = class_getInstanceMethod(objc_getClass("__NSDictionaryI"), @selector(setValue:forKey:));
//    Method oldMethod2 = class_getInstanceMethod(objc_getClass("__NSDictionaryI"), @selector(setCustomValue:forKey:));
//    method_exchangeImplementations(oldMethod1, oldMethod2);
//    
//    //  替换可变数组中的方法
//    Method oldMutableObjectAtIndex = class_getInstanceMethod(objc_getClass("__NSDictionaryM"), @selector(setValue:forKey:));
//    Method newMutableObjectAtIndex =  class_getInstanceMethod(objc_getClass("__NSDictionaryM"), @selector(setMutableCustomValue:forKey:));
//    method_exchangeImplementations(oldMutableObjectAtIndex, newMutableObjectAtIndex);
//}
//
//- (void)setCustomValue:(id)value forKey:(NSString *)key {
//#if !DEBUG
//    if (value || value.length > 0) {
//        @try {
//            [self setCustomValue:value forKey:key]; // 调用原来的objectAtIndex方法
//        }
//        @catch (NSException *exception) {
//            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
//            
//            NSLog(@"ERROR:%@",[exception callStackSymbols]);
//        }
//        @finally {}
//        return nil;
//    }
//#endif
//    return [self setCustomValue:value forKey:key];
//}
//
//- (void)setMutableCustomValue:(id)value forKey:(NSString *)key {
//#if !DEBUG
//    if (value || value.length > 0) {
//        @try {
//            [self setMutableCustomValue:value forKey:key]; // 调用原来的objectAtIndex方法
//        }
//        @catch (NSException *exception) {
//            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
//            
//            NSLog(@"ERROR:%@",[exception callStackSymbols]);
//        }
//        @finally {}
//        return nil;
//    }
//#endif
//    return [self setMutableCustomValue:value forKey:key];
//}

//- (void)setValue:(id)value forKey:(NSString *)key {
//    if ([value isKindOfClass:[NSString class]]) {
//        if (value) {
//            [self setValue:value forKey:key];
//        }
//    }
//}

-(NSString*)valueForKeyCustom:(NSString *)key{
    NSString * value = [self valueForKey:key];
    if (value && [value isKindOfClass:[NSString class]] && value.length > 0) {
        return value;
    }else if (value && [value isKindOfClass:[NSNumber class]]){
        return value.description;
    }else{
        return SStringEmpty;
    }
}

-(void)setString:(NSString *)value forKey:(NSString *)key{
    if (value && value.length > 0) {
        [self setValue:value forKey:key];
    } else{
        [self setValue:SStringEmpty forKey:key];
    }
}

@end
