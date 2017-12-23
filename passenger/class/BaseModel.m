//
//  BaseModel.m
//  114SD
//
//  Created by 杨星星 on 2017/3/23.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "BaseModel.h"
#import <objc/message.h>

@implementation BaseModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"Id"];
    } else if ([key isEqualToString:@"description"]) {
        [self setValue:value forKey:@"descript"];
    }
}

//归档
//- (void)encodeWithCoder:(NSCoder *)coder
//{
//    unsigned int count = 0;
//    // C语言里面，如果传基本数据类型的指针!那么一般都是需要在函数内部改变他的值！
//    Ivar * ivars = class_copyIvarList([BaseModel class], &count); // .m内属性照样能拿到
//    for (int i = 0; i < count; i++) {
//        Ivar ivar = ivars[i];
//        const char * name = ivar_getName(ivar);
//        NSString * key = [NSString stringWithUTF8String:name];
//        //归档
//        [coder encodeObject:[self valueForKey:key] forKey:key];
//    }
//    
//    // 在C语言里面，但凡看到NEW,Create,Copy函数需要释放！
//    free(ivars);
//}
//
//
////解档
//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    if (self = [super init]) {
//        unsigned int count = 0;
//        Ivar * ivars = class_copyIvarList([BaseModel class], &count);
//        for (int i = 0; i < count; i++) {
//            Ivar ivar = ivars[i];
//            const char * name = ivar_getName(ivar);
//            NSString * key = [NSString stringWithUTF8String:name];
//            //解档
//            id value = [coder decodeObjectForKey:key];
//            //设置到成员变量身上
//            [self setValue:value forKey:key];
//        }
//        
//        free(ivars);
//    }
//    return self;
//}

//- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues {
//    [super setValuesForKeysWithDictionary:keyedValues];
//    for (id key in keyedValues) {
//        id value = keyedValues[key];
//        if([value isKindOfClass:[NSString class]]) {
//            NSString *str = (NSString *)value;
//            if (str) {
//                [self setValue:value forKey:key];
//            }
//            
//        } else if([value isKindOfClass:[NSNull class]]) {
//            [self setValue:nil forKey:key];
//            continue;
//        } else {
//            if (value && value > 0) {
//                [self setValue:value forKey:key];
//            }
//        }
//    }
//}

+ (NSArray *)jsonToModelWithArray:(NSArray *)recordlist {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dict in recordlist) {
        BaseModel *model = [self new];
        [model setValuesForKeysWithDictionary:dict];
        [tempArray addObject:model];
    }
    return tempArray;
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(setValue:forKey:) with:@selector(setCustomValue:forKey:)];
    });
}


- (void)setCustomValue:(id)value forKey:(NSString *)key {
    if (value) {
        [self setCustomValue:value forKey:key];
    } else {
        NSLog(@"---------- %s Crash Because Method %s  ---------- key=%@\n", class_getName(self.class), __func__,key);
    }
}

@end
