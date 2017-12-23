//
//  NSArray+YXXArray.m
//  防止数组越界
//
//  Created by 杨星星 on 2017/3/15.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "NSArray+YXXArray.h"
#import <objc/message.h>

@implementation NSArray (YXXArray)

+ (void)load {
    [super load];
    
    //  替换不可变数组中的方法
    Method oldMethod1 = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
    Method oldMethod2 = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(yxxObjectAtIndex:));
    method_exchangeImplementations(oldMethod1, oldMethod2);
    
    //  替换可变数组中的方法
    Method oldMutableObjectAtIndex = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:));
    Method newMutableObjectAtIndex =  class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(yxxMutableObjectAtIndex:));
    method_exchangeImplementations(oldMutableObjectAtIndex, newMutableObjectAtIndex);
}

- (id)yxxObjectAtIndex:(NSInteger)index {
#if !DEBUG
    if (!self.count || self.count-1<index) {
        @try {
            [self yxxObjectAtIndex:index]; // 调用原来的objectAtIndex方法
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            
            NSLog(@"ERROR:%@",[exception callStackSymbols]);
        }
        @finally {}
        return nil;
    }
#endif
    return [self yxxObjectAtIndex:index];
}

- (id)yxxMutableObjectAtIndex:(NSInteger)index {
#if !DEBUG
    if (!self.count || self.count-1<index) {
        @try {
            [self yxxMutableObjectAtIndex:index]; // 调用原来的objectAtIndex方法
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            
            NSLog(@"ERROR:%@",[exception callStackSymbols]);
        }
        @finally {}
        return nil;
    }
#endif
    return [self yxxMutableObjectAtIndex:index];
}

@end
