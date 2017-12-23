//
//  wProgressView.m
//
//
//  Created by 邱家楗 on 14-7-23.
//  Copyright (c) 2014年 tigo soft. All rights reserved.
//

#import "wProgressView.h"
#import "UIConsts.h"
#import "WBJUIFont.h"
#import "UIView+Category.h"

#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

static NSMapTable *kProgressViews = nil;


@interface wProgressView()
{
    UIActivityIndicatorView *_progress;
    
    UILabel *_info;
    UIView  *_backView;
    
    #if ! __has_feature(objc_arc)
    __unsafe_unretained UIViewController *_saveVc;
#else
    __weak UIViewController *_saveVc;
#endif
}


@end

@implementation wProgressView


+ (void)showInfo:(NSString *)info inViewWindow:(UIView *)view
{
    wProgressView *progressView = [[wProgressView alloc] initWithFrame:CGRectZero];
    [progressView show:info InView:view FullView:YES inWindow:YES];
#if ! __has_feature(objc_arc)
    [progressView release];
#endif
}

+ (void)showInfo:(NSString *)info InView:(UIView *)inView
{
    [wProgressView showInfo:info InView:inView FullView:YES];
}

//非模态显示, 需要自已移除显示
+ (void)showInfo:(NSString *)info InView:(UIView *)inView FullView:(BOOL)fullView
{
    dispatch_main_sync_safe(^{
       
        wProgressView *progressView = [[wProgressView alloc] initWithFrame:CGRectZero];
        [progressView show:info InView:inView FullView:fullView inWindow:NO];
#if ! __has_feature(objc_arc)
        [progressView release];
#endif
        
    });
}

+ (void)closeInView:(UIView *)inView
{
    if (!inView || !kProgressViews || kProgressViews.count == 0)
    {
        return;
    }
    
    dispatch_main_async( ^{
        UIView *view = [kProgressViews objectForKey:inView];
        if (view)
        {
            [view removeFromSuperview];
            [kProgressViews removeObjectForKey:inView];
        }
    });
}

//关闭所有显示ProgressView
+ (void)closeAllViews
{
    if (!kProgressViews || kProgressViews.count == 0)
    {
        return;
    }
    
    dispatch_main_async( ^{
        for (UIView *inView in kProgressViews) {
            UIView *view = [kProgressViews objectForKey:inView];
            if (view)
            {
                [view removeFromSuperview];
            }
        }
        [kProgressViews removeAllObjects];
    });
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         _progress = nil;
        _info = nil;
        _backView = nil;
    }
    return self;
}

- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event
{
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event;   // default returns YES if point is in bounds
{
    return NO;
}

- (void)show:(NSString *)sInfo InView:(UIView *)inView FullView:(BOOL)fullView inWindow:(BOOL)inWindow
{
    if (!kProgressViews)
    {
        kProgressViews = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory
                                                   valueOptions:NSPointerFunctionsWeakMemory
                                                       capacity:0];
//        [kProgressViews retain];
    }
    
    if (!inView)
    {
        return;
    }
    
    BOOL upDown = sInfo && sInfo.length > 0;   //上下显示，NO左右显示
    
    self.backgroundColor = [UIColor clearColor];
    if (!_backView)
    {
        _backView = [[UIView alloc] initWithFrame:CGRectZero];
        //_backView.userInteractionEnabled = YES;   //不处理touch事件
        [self addSubview:_backView];
        
        UIColor *backgroundColor      = [UIColor blackColor];  //[UIColor grayColor]
        _backView.backgroundColor     = [backgroundColor colorWithAlphaComponent:0.6];
        //显示圆角
        _backView.layer.cornerRadius  = upDown ? RadiusBig : RadiusIcon;
        _backView.layer.masksToBounds = TRUE;
        
        //显示边框
        _backView.layer.borderWidth   = UIButtonBorderWidth;
        _backView.layer.borderColor   = [backgroundColor CGColor];
        
        _backView.autoresizingMask    = UIAutoSizeMaskFixs;
    }
    
    if (!_progress)
    {
        _progress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                                            upDown ? UIActivityIndicatorViewStyleWhiteLarge : UIActivityIndicatorViewStyleWhite];
        [_backView addSubview:_progress];
        _progress.backgroundColor = [UIColor clearColor];
    }
    
    if (!_info)
    {
        _info = [[UILabel alloc] initWithFrame:CGRectZero];
        [_backView addSubview:_info];
        _info.font            = [WBJUIFont tableViewDetailFont];
        _info.backgroundColor = [UIColor clearColor];
        _info.textColor       = [UIColor whiteColor];
    }
    [_progress startAnimating];
    _info.text          = sInfo;
    _info.lineBreakMode = NSLineBreakByWordWrapping;
    _info.numberOfLines = 2;
    
    UIView *progressView = [kProgressViews objectForKey:inView];
    if (progressView && progressView != self)
    {
        [progressView removeFromSuperview];
        [[self class] closeInView:inView];
    }
    
    [kProgressViews setObject:self forKey:inView];
    UIView *saveInView = inView;
    
    if (inWindow && ![inView isKindOfClass:[UIWindow class]])
    {
//        inView = [UIApplication sharedApplication].keyWindow;
        //lastObject 键盘打开时，不会显示
//        inView = [[UIApplication sharedApplication].windows lastObject];
        inView = inView.window;
        self.frame = inView.frame;
    }
  
    
    CGRect r = inView.frame;
    
    CGSize size = [_info sizeThatFits:CGSizeMake(SCREENW - 40, SCREENH)];
    if (size.width > r.size.width)
    {
        CGFloat tw = r.size.width - 10-20-10-10;
        int line = ceilf(size.width / tw);
        _info.numberOfLines = line;
        size.width = tw;
        
        //没有文字时，最小高
        if (!upDown && size.height < 40)
            size.height = 40;
//        if (line > 2)
//            size.height = size.height + ((line - 2) * 20);
    }

    CGFloat w = 10 + 10 + size.width;
    CGFloat h = size.height <= 0 ? 40 : size.height + 20;

    
    if (sInfo && sInfo.length > 0)
        w += 8;
    
    if (upDown)
    {
        CGRect r1 = _progress.frame;
        CGFloat y = 35;
        if (sInfo && sInfo.length > 0)
        {
            h += y + r1.size.width + 20;
            
            //希望字符少时，是显示正方形
            CGFloat bw = y + r1.size.width + 40 + _info.font.lineHeight * 3;
            if (w < bw)
                w = bw;
        }
        
        r1.origin       = CGPointMake((w - r1.size.width) / 2.0, y);
        _progress.frame = r1;
        _info.frame     = CGRectMake((w - size.width) * 0.5, y + r1.size.height + 20, size.width, size.height);
    }
    else
    {
        w += 20;
        _progress.frame = CGRectMake(10, (h - 20.0)/2.0, 20.0, 20.0);
        _info.frame     = CGRectMake(38, (h - (h-20))/2.0, size.width + 1.0, h - 20.0);
    }

    self.autoresizingMask = UIAutoSizeMaskAll;
    [inView addSubview:self];
    
    CGRect backRect = CGRectMake((r.size.width - w)/2.0, (r.size.height - h) / 2.0, w, h);
    if (!fullView)
    {
        self.frame = backRect;
        backRect.origin = CGPointMake(0, 0);
    }
    else
    {
        CGRect r = inView.bounds;
        r.origin = CGPointMake(0, r.origin.y * 0.5);
        self.frame = r;
    }
    _saveVc = nil;
    if (fullView && [inView isKindOfClass:[UIWindow class]])
    {
        UIViewController *vc = [saveInView viewController];
        if (vc && vc.navigationController && vc.navigationController.interactivePopGestureRecognizer.enabled)
        {
                #if ! __has_feature(objc_arc)
            objc_storeWeak(&_saveVc, vc);
#else
            _saveVc = vc;
#endif
            _saveVc.navigationController.interactivePopGestureRecognizer.enabled = NO;  //禁止划屏
        }
    }
    _backView.frame  = backRect;
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    
    if (_saveVc)
    {
        _saveVc.navigationController.interactivePopGestureRecognizer.enabled = YES;   //恢复划屏
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.userInteractionEnabled = NO;
    if (self.superview && _backView)
        _backView.center = _backView.superview.center;
}

- (void)dealloc
{
    #if ! __has_feature(objc_arc)
    [_progress release];
    [_info release];
    [_backView release];
    
    #endif
    _progress = nil;
    _info     = nil;
    _backView = nil;
    
    #if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

@interface wShowInfoView()
{
    long _backTick;
    BOOL _showed;
}
@end

@implementation wShowInfoView

+ (void)showInfo:(NSString*)sInfo
{
    if (!sInfo || sInfo.length == 0)
    {
        return;
    }
    dispatch_main_sync_safe(^{
        
        wShowInfoView *infoView = [[wShowInfoView alloc] initWithFrame:CGRectZero];
        [infoView showInfo:sInfo font:nil];
#if ! __has_feature(objc_arc)
        [infoView release];
#endif
        
    });
}

+ (void)showInfoGray:(NSString*)info
{
    dispatch_main_sync_safe(^{
        
        wShowInfoView *infoView = [[wShowInfoView alloc] initWithFrame:CGRectZero];
        [infoView showInfo:info font:nil];
        infoView.backgroundColor   = [[UIColor blackColor] colorWithAlphaComponent:0.7];//[UIColor darkGrayColor];
        infoView.layer.borderColor = [[[UIColor blackColor] colorWithAlphaComponent:0.8] CGColor];
        infoView.textColor         = [UIColor whiteColor];
        
        
#if ! __has_feature(objc_arc)
        [infoView release];
#endif
        
    });

}

- (void)removeFromSuperview{
    [super removeFromSuperview];
    if (_showed)
    {
        UIApplication *app = [UIApplication sharedApplication];
        UIView *win = [app.windows lastObject];
        [win addSubview:self];
    }
        
}

- (void)closeView
{
    [super removeFromSuperview];
}

- (void)showInfo:(NSString *)sInfo font:(UIFont *)font
{
    if (!_showInfoTime) {
        _showInfoTime = 1.0;
    }
    UIApplication *app = [UIApplication sharedApplication];
    if (app.applicationState != UIApplicationStateActive)
        return;
    self.backgroundColor = [UIColor whiteColor];
    self.alpha  = 0.88f;

    if (!font)
        font = [WBJUIFont lightFontWithSize:[WBJUIFont tableViewDetailFontSize]  - 1];
    self.text = sInfo;
    self.font = font;
    self.textAlignment = NSTextAlignmentCenter;
    //显示圆角
    self.layer.cornerRadius = RadiusIcon;
    self.layer.masksToBounds = TRUE;
    //显示边框
    self.layer.borderWidth = UIButtonBorderWidth;
    self.layer.borderColor = [[UIColor grayColor] CGColor];
    //显示阴影
    //self.layer.shadowColor = [[UIColor blackColor] CGColor];
    //self.layer.shadowOffset = CGSizeMake(1.0, 2.0);
    //self.layer.shadowOpacity = YES;

    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.numberOfLines = 4;
    self.userInteractionEnabled = NO;
    
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    CGRect r = window.frame;

    CGSize size = [self sizeThatFits:CGSizeMake(r.size.width - 40, r.size.height / 2.0)];
    
    CGFloat w = size.width + 10;
    CGFloat h = size.height + 10;
    
    [window addSubview:self];
    _showed = YES;
        
    self.alpha = 1;

    r = CGRectMake(r.origin.x + (r.size.width - w) / 2.0, r.size.height -100, w, h);
    self.frame = r;
    
#if ! __has_feature(objc_arc)
    wShowInfoView *wself = self;
#else
    __weak wShowInfoView *wself = self;
#endif
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_showInfoTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [UIView animateWithDuration:1.0f
                         animations:^{
                             wself.alpha = 0.2;
                         }
                         completion:^(BOOL finished) {
                             if (finished && self && self.superview && _backTick == 0)
                             {
                                 _showed = NO;
                                 [wself removeFromSuperview];
                             }
                         }];
        
    });
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _backTick = 0;
        _showed = NO;
        NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
        
        [noti addObserver:self
                 selector:@selector(appDidEnterBackground)
                     name:UIApplicationDidEnterBackgroundNotification
                   object:nil];
        
        [noti addObserver:self
                 selector:@selector(appDidBecomeActive)
                     name:UIApplicationDidBecomeActiveNotification
                   object:nil];
    }
    return self;
}

- (void)appDidEnterBackground
{
    //提示 信息, 同时把APP 进入休眠, 不会移除, 所以在此强制移除
    _backTick = [[NSDate date] timeIntervalSince1970]; //[Comm tickCount];
    _showed = NO;
    [self removeFromSuperview];
}

- (void)appDidBecomeActive
{
    if (_backTick > 0)
        _backTick = 0;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    #if ! __has_feature(objc_arc)
    [super dealloc];
    #endif
}


@end
