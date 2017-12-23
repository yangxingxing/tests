//
//  HKLPickerView.m
//  safeepay-ios-new
//
//  Created by san_xu on 2016/11/28.
//  Copyright © 2016年 com.app.huakala. All rights reserved.
//

#import "HKLPickerView.h"
/** 屏幕宽度*/
#define HKL_ScreenHeight  [UIScreen mainScreen].bounds.size.height
/** 屏幕高度*/
#define HKL_ScreenWidth  [UIScreen mainScreen].bounds.size.width

@interface HKLPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak,nonatomic)UIView * bottomContainerView;
@property (weak,nonatomic)UIPickerView * pickerView;
@end

@implementation HKLPickerView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //默认的属性设置
        //动画时间
        self.animationTime = 0.5;
        //背景透明度
        self.BackgroundAlpha = 0.0;
        //背景颜色
        self.backgroundViewColor = [UIColor blackColor];
        //按钮宽和高
        self.buttonWidth = 50;
        self.buttonHeight = 40;
        //pickView默认背景颜色
        self.pickerViewBackgroundColor = textLightGrayColor;
        self.screenHeightPercent = 0.5;
        
        //设置self属性
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, HKL_ScreenWidth, HKL_ScreenHeight);
//        UIWindow * displayWindow = [[UIApplication sharedApplication].windows lastObject];
//        [displayWindow addSubview:self];
        
        //添加子控件->半透明的背景按钮
        UIButton * translucentBackgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        translucentBackgroundBtn.alpha = self.BackgroundAlpha;
        translucentBackgroundBtn.backgroundColor = [UIColor clearColor];
        [translucentBackgroundBtn addTarget:self action:@selector(translucentBackgroundBtn) forControlEvents:UIControlEventTouchDown];
        translucentBackgroundBtn.frame = CGRectMake(0, 0, HKL_ScreenWidth, HKL_ScreenHeight);
        [self addSubview:translucentBackgroundBtn];
        
        //添加子控件->底部弹出的容器视图
        UIView * bottomContainerView = [[UIView alloc]init];
        self.bottomContainerView = bottomContainerView;
        bottomContainerView.backgroundColor = [UIColor whiteColor];
        [bottomContainerView addTopLineWithBorderColor:textLightGrayColor borderWidth:UILineBorderWidth];
        bottomContainerView.frame = CGRectMake(0, HKL_ScreenHeight, HKL_ScreenWidth, 280);
        [self bottomContainerViewAddSubviews:bottomContainerView];
        [self addSubview:bottomContainerView];
        
        self.hidden = YES;
    }
    return self;
}
#pragma mark - 私有方法
//容器视图添加子控件
- (void)bottomContainerViewAddSubviews:(UIView *)superView {
    //取消按钮
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(0, 0, self.buttonWidth, self.buttonHeight);
    [superView addSubview:cancelBtn];
    //中间标签
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"";
    titleLabel.width = 100;
    titleLabel.y = 0;
    titleLabel.height = cancelBtn.height;
    titleLabel.x = HKL_ScreenWidth * 0.5 - titleLabel.width * 0.5;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [superView addSubview:titleLabel];
    //确定按钮
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    sureBtn.frame = CGRectMake(HKL_ScreenWidth - self.buttonWidth, 0, self.buttonWidth, self.buttonHeight);
    [superView addSubview:sureBtn];
    
    //pickerView
    UIPickerView * pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.buttonHeight, HKL_ScreenWidth, superView.height - sureBtn.height)];
    self.pickerView = pickerView;
    pickerView.backgroundColor = self.pickerViewBackgroundColor;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [superView addSubview:pickerView];
}

#pragma mark - 数据源赋值
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.pickerView reloadAllComponents];
//    [self.pickerView selectRow:5 inComponent:0 animated:YES];
}

#pragma mark - 按钮点击响应方法
//半透明的背景按钮点击响应方法
- (void)translucentBackgroundBtn {
    [self hideCoverView];
}
//取消按钮
- (void)cancelBtnClick {
    [self hideCoverView];
}
//确定按钮
- (void)confirmBtnClick {
    [self hideCoverView];
    if (self.confirmBtnClickBlock) {
        NSMutableArray * tempArr = [NSMutableArray array];
        for (int i = 0; i < self.dataSource.count; ++i) {
            NSInteger index = [self.pickerView selectedRowInComponent:i];
            [tempArr addObject:self.dataSource[i][index]];
        }
        self.confirmBtnClickBlock(tempArr.copy);
    }
}

#pragma mark - 开始和结束
//API
//开始
- (void)showCoverView {
    self.hidden = NO;
    [UIView animateWithDuration:self.animationTime animations:^{
        self.bottomContainerView.y = HKL_ScreenHeight-280;
    } completion:^(BOOL finished) {
    }];
}
//结束
- (void)hideCoverView {
    [UIView animateWithDuration:self.animationTime animations:^{
        self.bottomContainerView.y = HKL_ScreenHeight;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.bottomContainerView = nil;
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.dataSource.count;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    for (int i = 0; i < self.dataSource.count; ++i) {
        if (i == component) {
            NSArray * tempArr = self.dataSource[i];
            return tempArr.count;
        }
    }
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    for (int i = 0; i < self.dataSource.count; ++i) {
        if (i == component) {
            return self.dataSource[i][row];
        }
    }
    return nil;
}

- (void)dealloc {
    SLog(@"HKLPickerView dealloc");
}
@end
