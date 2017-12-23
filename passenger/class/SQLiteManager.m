//
//  SQLiteManager.m
//  114SD
//
//  Created by 杨星星 on 2017/4/10.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "SQLiteManager.h"
//#import "FMDatabase.h"
//
//@interface SQLiteManager ()
//
//// 数据库对象
//@property (nonatomic, strong) FMDatabase * dataBase;

//@end

@implementation SQLiteManager

/*
 *  创建数据库
 */
//- (void)craetDateBaseWithUserId:(NSString *)UserId {
//    // 获取数据库存储的路径
//    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory  , NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",UserId]];
//    
//    // 1. 实例化数据库, 需要传入数据库保存的路径
//    // 如果说这个路径下面没有文件，就去创建一个数据库文件
//    // 如果说这个路径下面有一个数据库文件，那么就去读取这个数据库
//    self.dataBase = [[FMDatabase alloc] initWithPath:path];
//    NSLog(@"%@",path);
//    // 2. 数据库分为打开和关闭的状态，只有在打开状态下，才能给访问数据库里面的内容，对数据库进行任何的操作。
//    // 打开数据库，如果能正常打开，就表示数据库加载成功，否则失败
//    if ([self.dataBase open]) {
//        SLog(@"数据库打开成功");
//    } else {
//        SLog(@"数据库打开失败");
//    }
//    
//}
//
///**
// *  创建表
// */
//- (void)createTableWithSQL:(NSString *)sql {
//    // 从建表开始，所有的数据库操作都需要用SQL语句来实现
//    // SQL语句不区分大小写
//    // 键 key
//    // 主键 一张表里面，主键不能重复
//    // 一张表里面可以没有主键，最多只有一个主键
//    // 在创建表的时候，键没有顺序的意义
//    // create table if not exists 可以认为是一个固定格式
////    NSString * sql = @"create table if not exists QFUser(name varchar(32),age integer, id integer primary key)";
//    
//    // 执行建表语句
//    if ([self.dataBase executeUpdate:sql]) {
//        SLog(@"建表成功");
//    }
//}

@end
