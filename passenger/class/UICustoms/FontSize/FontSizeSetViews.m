//
//  FontSizeSetViews.m
//  
//
//  Created by 邱家楗 on 16/3/30.
//  Copyright © 2016年 tigo soft. All rights reserved.
//

#import "FontSizeSetViews.h"

#define BottomViewHeight 90.0

@interface FontSizeSetViews()
<FXMarkSliderDelegate>

@end

@implementation FontSizeSetViews

- (instancetype)initWithSuper:(UIView*)superView
{
    self = [super init];
    if (self)
    {
        [self initViews:superView];
    }
    return self;
}

- (void)initViews:(UIView*)superView
{
    if (_textFont)
        return;
    
    _fontLevel = [WBJUIFont fontLevel];
    
    _textFont   = [[WBJUIFont tableViewFont] copy];
    _detailFont = [[WBJUIFont tableViewDetailFont] copy];
    _timeFont   = [[WBJUIFont tableViewTimeFont] copy];
    
    CGRect r = superView.bounds;
    r.size.height -= BottomViewHeight;
    _tableView = [[UITableViewCustom alloc] initWithFrame:r
                                                    style:UITableViewStylePlain];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO; // 不允许选中
    self.tableView.autoresizingMask = UIAutoSizeMaskAll;
    
    [superView addSubview:_tableView];
    
    CGRect rect = superView.frame;
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height - BottomViewHeight, rect.size.width, BottomViewHeight)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _bottomView.autoresizingMask = UIAutoSizeMaskBottom;
    [superView addSubview:_bottomView];
    
    _textSmall = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 20, 30)];
    _textSmall.text            = @"A";
    _textSmall.backgroundColor = [UIColor clearColor];
    _textSmall.autoresizingMask = UIAutoSizeMaskTop;
    [_bottomView addSubview:_textSmall];
    
    _textStandard = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 20, 30)];
    _textStandard.backgroundColor = [UIColor clearColor];
    _textStandard.textColor       = [UIColor lightGrayColor];
    _textStandard.text            = LocalizedString(@"Standard");
    _textStandard.autoresizingMask = UIAutoSizeMaskTop;
    [_bottomView addSubview:_textStandard];
    
    
    _textMax = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 20, 30)];
    _textMax.text            = @"A";
    _textMax.backgroundColor = [UIColor clearColor];
    _textMax.autoresizingMask = UIAutoSizeMaskRight;
    [_bottomView addSubview:_textMax];
    
    _slider = [[FXMarkSlider alloc] initWithFrame:CGRectMake(0, 200, rect.size.width, 50)];
    [_bottomView addSubview:_slider];
    
    self.slider.markPositions = @[@1,@2,@3,@4,@5];
    self.slider.minimumValue  = 0;
    self.slider.maximumValue  = 5;
    self.slider.delegate = self;
    self.slider.autoresizingMask = UIAutoSizeMaskTop;
    self.slider.currentValue  = _fontLevel;
    
    float fontSize;
    float detailFontSize;
    float timeFontSize;
    UIFont *font = [WBJUIFont tableViewFont];
    
    [WBJUIFont calcFontSizeWithFontLevel:0 TextFontSize:&fontSize
                          DetailFontSize:&detailFontSize
                            TimeFontSize:&timeFontSize];
    _textSmall.font    = [font fontWithSize: fontSize];
    
    [WBJUIFont calcFontSizeWithFontLevel:1 TextFontSize:&fontSize
                          DetailFontSize:&detailFontSize
                            TimeFontSize:&timeFontSize];
    _textStandard.font = [font fontWithSize:fontSize];
    
    [WBJUIFont calcFontSizeWithFontLevel:self.slider.maximumValue
                            TextFontSize:&fontSize
                          DetailFontSize:&detailFontSize
                            TimeFontSize:&timeFontSize];
    _textMax.font      = [font fontWithSize:fontSize];
}

- (void)viewUnLoad
{
    _tableView  = nil;
    _bottomView = nil;
    _textSmall  = nil;
    _textStandard = nil;
    _textMax = nil;
    _slider  = nil;
    
    _textFont   = nil;
    _detailFont = nil;
    _timeFont   = nil;
}

- (void)dealloc
{
#if ! __has_feature(objc_arc)
    [_tableView release];
    [_bottomView release];
    [_textSmall release];
    [_textStandard release];
    [_textMax release];
    [_slider release];
    
    if (_textFont)
        [_textFont release];
    if (_detailFont)
        [_detailFont release];
    if (_timeFont)
        [_timeFont release];
    [self viewUnLoad];
    [super dealloc];
#else
    [self viewUnLoad];
#endif
}

- (void)layoutSliderSubviews
{
    if (!_tableView || !_tableView.superview)
        return;
    
    CGRect rect =  _tableView.superview.frame;
    //    if (self.params.sysVer < 7.0)
    //        rect.size.height -= [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    
    //    CGFloat bottomHeight = BottomViewHeight;
    //    _tableView.frame  = CGRectMake(0, 0, rect.size.width, rect.size.height - bottomHeight - rect.origin.y);
    //    _bottomView.frame = CGRectMake(0, rect.size.height - bottomHeight - rect.origin.y,
    //                                   rect.size.width, bottomHeight);
    
    CGFloat w = rect.size.width - 40.0;
    _slider.frame = CGRectMake(20.0, 55, w, 20);
    
    rect = _slider.frame;
    CGFloat y = rect.origin.y;
    
    [_textSmall sizeToFit];
    CGRect r = _textSmall.frame;
    r.origin.x = rect.origin.x + r.size.width;
    r.origin.y = y - 10 - r.size.height;
    _textSmall.frame = r;
    
    [_textStandard sizeToFit];
    r = _textStandard.frame;
    r.origin.x = rect.origin.x + (rect.size.width / 6.0);  //r.size.width * 0.5
    r.origin.y = y - 10 - r.size.height;
    _textStandard.frame = r;
    
    [_textMax sizeToFit];
    r = _textMax.frame;
    r.origin.x = rect.origin.x - r.size.width + rect.size.width;
    r.origin.y = y - 10 - r.size.height;
    _textMax.frame = r;
}

- (void)FXSliderTapGestureValue:(CGFloat)selectValue
{
#if ! __has_feature(objc_arc)
    if (_textFont)
        [_textFont release];
    if (_detailFont)
        [_detailFont release];
    if (_timeFont)
        [_timeFont release];
#endif
    
    float fontSize;
    float detailFontSize;
    float timeFontSize;
    _fontLevel = selectValue;
    [WBJUIFont calcFontSizeWithFontLevel:_fontLevel TextFontSize:&fontSize
                          DetailFontSize:&detailFontSize
                            TimeFontSize:&timeFontSize];
    UIFont *font = [WBJUIFont tableViewFont];
    
    _textFont   = [font fontWithSize:fontSize];
    _detailFont = [font fontWithSize:detailFontSize];
    _timeFont   = [WBJUIFont lightFontWithSize:timeFontSize];
    
#if ! __has_feature(objc_arc)
    [_textFont retain];
    [_detailFont retain];
    [_timeFont retain];
#endif
    
    [_tableView reloadData];
}


@end

