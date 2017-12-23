//
//  HttpApi.h
//  114SD
//
//  Created by 杨星星 on 2017/3/24.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#ifndef HttpApi_h
#define HttpApi_h

// 七牛信息
#define QiniuInfoApi @"index/qiniu"

// 七牛token
#define QntokenApi @"index/qntoken"

// 获取所有地址的接口
#define IndexArea @"index/area"

// 收货地址管理接口
#define AddressApi @"user/address"

#pragma mark - 公共模块
// 主页
#define HomeIndex @"index/index"

// 获取公司分类
#define GetCompanyCategoryApi @"index/getCompanyCategory"

// 石材种类、商家、买卖推荐（用于石材百科页面）
#define GetRecommondApi @"index/getRecommond"

// 获取分类的列表（action参数）
#define GetCategoryListApi @"index/getCategoryList"

#pragma mark - 我的
// 2、发送验证码 (sms/send)
#define GetUserSmsApi @"sms/send"

// 3、登陆 (/user/login)
#define UserLoginApi @"login/dologin"

// 6、获取用户信息 (user/userinfo)
#define GetUserApi @"user/userinfo"

// 修改用户信息
#define UsereditApi @"user/useredit"


#pragma mark - 公司
// 石材公司信息 http://woody0518.tunnel.qydev.com/api/brand/info
#define BrandInfoApi @"brand/info"

/// 石材图片（轮播用）
#define BrandImagelistApi @"brand/imagelist"

// 获取公司名下的石材
#define BrandGoodlistApi @"brand/goodlist"

// 修改石材公司信息
#define BrandCompanyeditApi @"brand/companyedit"

// 获取公司列表
#define  BrandIndexApi @"brand/index"

// 成为石材企业的提交接口
#define BrandRegisterApi @"brand/register"

// 添加企业场景
#define BrandAddscenceApi @"brand/addscence"

#pragma mark - 搜索
// 搜索接口（全局搜索）
#define IndexSearchApi @"index/search"
// 搜索
#define SearchIndexApi @"search/index"


#endif /* HttpApi_h */



