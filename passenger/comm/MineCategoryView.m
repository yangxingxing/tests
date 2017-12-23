//
//  MineCategoryView.m
//  114SD
//
//  Created by 杨星星 on 2017/3/27.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "MineCategoryView.h"

@interface MineCategoryView () {
    float _lineWidth;
    UIColor *_backColor;
    UIColor *_selectedBackColor;
}

@property (nonatomic,assign) NSInteger selectedTag;

@end

@implementation MineCategoryView

- (instancetype)initWithFrame:(CGRect)frame withItems:(NSArray *)items showSeparatedLine:(BOOL)showSeparated textColor:(UIColor *)color btnClcik:(BtnClickBlock)btnClcik imageLocation:(ImageLocation)location btnHeight:(CGFloat)btnHeight fontSize:(UIFont *)fontSize lineColor:(UIColor *)lineColor btnSpace:(CGFloat)btnSpace selectedTextColor:(UIColor *)selectedTextColor {
    if (self = [super initWithFrame:frame]) {
        [self initViews:items showSeparatedLine:showSeparated textColor:color selectedTextColor:selectedTextColor imageLocation:location btnHeight:btnHeight fontSize:fontSize lineColor:(UIColor *)lineColor btnSpace:btnSpace selectedTag:0];
        if (color != textWhiteColor) {
            self.backgroundColor = textWhiteColor;
        }
        _btnClcik = btnClcik;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withItems:(NSArray *)items showSeparatedLine:(BOOL)showSeparated textColor:(UIColor *)color btnClcik:(BtnClickBlock)btnClcik imageLocation:(ImageLocation)location btnHeight:(CGFloat)btnHeight fontSize:(UIFont *)fontSize lineColor:(UIColor *)lineColor btnSpace:(CGFloat)btnSpace selectedTextColor:(UIColor *)selectedTextColor backColor:(UIColor *)backColor selectedBackColor:(UIColor *)selectedBackColor lineWidth:(float)lineWid  selectedTag:(NSInteger)tag {
    self = [super initWithFrame:frame];
    _lineWidth = lineWid;
    _backColor = backColor;
    _selectedBackColor = selectedBackColor;
    _selectedTag = tag;
    return [self initWithFrame:frame withItems:items showSeparatedLine:showSeparated textColor:color btnClcik:btnClcik imageLocation:location btnHeight:btnHeight fontSize:fontSize lineColor:lineColor btnSpace:btnSpace selectedTextColor:selectedTextColor];
    
}


// 创建按钮
- (void)initViews:(NSArray *)items showSeparatedLine:(BOOL)showSeparated textColor:(UIColor *)color selectedTextColor:(UIColor *)selectedTextColor imageLocation:(ImageLocation)location btnHeight:(CGFloat)btnHeight fontSize:(UIFont *)fontSize  lineColor:(UIColor *)lineColor btnSpace:(CGFloat)btnSpace selectedTag:(int)tag {
    CGFloat height = self.height;
    CGFloat width = SCREENW / items.count;
    for (NSInteger i = 0; i<items.count; i++) {
        NSDictionary *dic = items[i];
        UIButtonCustom *btn = [UIButtonCustom buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * width, 0, width, height);
        btn.tag = i;
        NSString *imageStr = dic[@"image"];
        NSString *selectedImage = dic[@"selectedImage"];
        [btn setImage:ImageNamed(imageStr) forState:UIControlStateNormal];
        if (selectedImage && selectedImage.length > 0) {
            [btn setImage:ImageNamed(selectedImage) forState:UIControlStateSelected];
        }
        if (selectedTextColor) {
            [btn setTitleColor:selectedTextColor forState:UIControlStateSelected];
        }
        if (i == _selectedTag) { // 第一个选中
            btn.selected = YES;
            _selectedBtn = btn;
        }
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btn.titleLabel.font = fontSize;
        [btn setTitle:dic[@"title"] forState:UIControlStateNormal];
        btnSpace = btnSpace > 0 ? btnSpace : 4;
        switch (location) {
            case ImageLocationTop:
                btn.imageViewFrame = CGRectMake(btn.width/2-btnHeight/2, (height - btnHeight - 20 - btnSpace)/2, btnHeight, btnHeight);
                btn.titleLabelFrame = CGRectMake(0, CGRectGetMaxY(btn.imageViewFrame) + btnSpace, width, 20);
                break;
            case ImageLocationLeft:
                [btn.titleLabel sizeToFit];
                btn.imageViewFrame = CGRectMake((width - btn.titleLabel.width - btnHeight - btnSpace)/2, (height - btnHeight)/2, btnHeight, btnHeight);
                btn.titleLabelFrame = CGRectMake(CGRectGetMaxX(btn.imageViewFrame) + btnSpace, (height - 20)/2, btn.titleLabel.width, 20);
                break;
            case ImageLocationBottom:
                
                break;
            case ImageLocationRight:
                
                break;
            case ImageLocationNone:
                
                break;
                
            default:
                break;
        }
        
        
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:color forState:UIControlStateNormal];
        if (_selectedBackColor && i == _selectedTag) {
            btn.backgroundColor = _selectedBackColor;
        }
        

        if (showSeparated && i < items.count-1) { // 画中间线
            float lineWidth = _lineWidth ? _lineWidth : UILineBorderWidth;
            if (lineWidth) {
                [btn lineVerticalWithPoint:CGPointMake(width - lineWidth, 0) toPoint:CGPointMake(width - lineWidth, height) andColor:lineColor ? lineColor : textLightGrayColor lineWidth:lineWidth];
            } else {
                [btn lineVerticalWithPoint:CGPointMake(width - lineWidth, height/4) toPoint:CGPointMake(width - lineWidth, height/4*3) andColor:lineColor ? lineColor : textLightGrayColor lineWidth:lineWidth];
            }
        }
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

//- (UILabelCustom *)levelLabel {
//    if (!_levelLabel) {
//        _levelLabel = [[UILabelCustom alloc] init];
//        _levelLabel.textColor = textWhiteColor;
//        _levelLabel.text = @"0";
//        _levelLabel.font = FontSize(17);
//        _levelLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _levelLabel;
//}

- (void)btnClick:(UIButtonCustom *)btn {
    _selectedBtn.selected = NO;
    if (_selectedBackColor) {
        _selectedBtn.backgroundColor = self.backgroundColor;
        btn.backgroundColor = _selectedBackColor;
    }
    btn.selected = YES;
    _selectedBtn = btn;
    if (_btnClcik) {
        _btnClcik(btn.tag);
    }
}

- (void)btnClickWithTag:(NSInteger)tag {
    UIButtonCustom *btn = (UIButtonCustom *)[self subviews][tag];
    
    [self btnClick:btn];
}

@end
