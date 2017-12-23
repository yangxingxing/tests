//
//  WBJDropDownMenu.m
//  
//
//  Created by 邱家楗 on 16/12/1.
//  Copyright © 2016年 邱家楗. All rights reserved.
//

#import "WBJDropDownMenu.h"


#define MenuFooterHeight 0.0
#define TableViewAddHeight 8.0

static WBJDropDownMenu *lastDropDownMenu = nil;

@interface WBJDropDownMenuItem: NSObject

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, strong) UIImage  *image;
@property (nonatomic, copy)   WBJDropDownMenuBlock block;

@end

@implementation WBJDropDownMenuItem

- (void)dealloc
{
    self.title     = nil;
    self.block     = nil;
    self.image     = nil;
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

@end

@interface WBJDropDownMenuCell : UITableViewCellCustom;

@end

@implementation WBJDropDownMenuCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect r = self.textLabel.frame;
    r.origin.y   = 0.0;
    r.size.width = self.frame.size.width - r.origin.x - 8;
    self.textLabel.frame = r;
}

@end



@interface WBJDropDownMenu ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, readonly) UIView *backView;

@end

@implementation WBJDropDownMenu

-(id)init
{
    self = [super init];
    if (self)
        [self initSelf];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self initSelf];
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
        [self initSelf];
    return self;
}

-(void)initSelf
{
    if (_tableView)
        return;
    
    if (lastDropDownMenu)
        [lastDropDownMenu closeWithAnimation:NO];
    lastDropDownMenu = self;
    
    _buttons = [[NSMutableArray alloc] init];
    _shapesBeaker = sbTop;
    self.titleColor = [UIColor whiteColor];
    
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    
    UIImage *image = [UIImage imageNamed:@"skin_header_bar_bg"];

    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor colorWithPatternImage:image];
    _backView.userInteractionEnabled = YES;
    
    [self addSubview:_backView];
    
    _tableView = [[UITableViewCustom alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    [_backView addSubview:_tableView];
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.cornerRadius = 6;
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.backgroundColor = _backView.backgroundColor;
    _tableView.alpha           = 0.95;
    _tableView.tableHeaderView = nil;     //去除顶部的线
    _tableView.tableFooterView = nil;
    _tableView.rowHeight       = 40;
    _tableView.separatorColor  = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.scrollEnabled = NO;
    
    self.imageWidthDec = _tableView.rowHeight - 20;
    
    //    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    //    [self addGestureRecognizer:tap];
#if ! __has_feature(objc_arc)
    [_backView release];
    [_tableView release];
    //    [tap release];
#endif
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeSelfView)
                                                 name:@"mctShutdown" object:nil];
}

- (void)dealloc
{
    lastDropDownMenu = nil;
    
    self.buttons    = nil;
    self.titleColor = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)addItemWithTitle:(NSString *)title block:(WBJDropDownMenuBlock)block tag:(NSInteger)tag
{
    [self addItemWithTitle:title block:block tag: tag image:nil];
}

- (void)addItemWithTitle:(NSString *)title block:(WBJDropDownMenuBlock)block tag:(NSInteger)tag image:(UIImage *)image
{
    WBJDropDownMenuItem *item = [[WBJDropDownMenuItem alloc] init];
    item.tag    = tag;
    item.title  = title;
    item.block  = block;
    item.image  = image;
    
    [_buttons addObject:item];
}

-(CGFloat)beakerOffset
{
    return _beakerOffset == 0 ? _backView.frame.size.width - 28 : _beakerOffset;
}

//需要 子类设置 cell图片，title
-(void)setItem:(UITableViewCellCustom*)cell IndexPath:(NSIndexPath*)indexPath
{
    
}

#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _buttons.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"menuCell";
    
    WBJDropDownMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[WBJDropDownMenuCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellName];
#if ! __has_feature(objc_arc)
        [cell autorelease];
#endif
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //UIImage *image = [UIImage imageNamed:@"skin_header_bar_bg"];
        cell.backgroundColor             = textGrayColorPass; //[UIColor colorWithPatternImage:image];
        cell.contentView.backgroundColor = cell.backgroundColor; //IOS6 必须设置
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font            = [WBJUIFont tableViewFont];
        cell.textLabel.textColor       = self.titleColor ? : [UIColor whiteColor];
        
        cell.imageWidthDec             = self.imageWidthDec;
        
    }
    [cell setSelected:FALSE];
    WBJDropDownMenuItem *item = self.buttons[indexPath.row];
    cell.textLabel.text   = item.title;
    cell.imageView.image  = item.image;
    
    [self setItem:cell IndexPath:indexPath];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    WBJDropDownMenuItem *item = self.buttons[indexPath.row];
    if (item.block)
    {
        item.block(item.tag);
    }
    [self closeWithAnimation: NO];
}

- (void)showInView:(UIView *)view beakerView:(UIView *)beakerView width:(CGFloat)width
{
    if (!view)
    {
        return;
    }
    
    CGRect wr = view.window.frame;
    CGRect r = [beakerView convertRect:beakerView.bounds toView:view.window];
//    UIView *supView = beakerView.superview;
//    while (supView) {
//        if ([beakerView.superview isKindOfClass:[UINavigationBar class]])
//        {
//            r.origin.x = beakerView.frame.origin.x; //convertRect x 不对
//            r.origin.y = beakerView.superview.frame.origin.y;
//            r.size.height = beakerView.superview.frame.size.height;
//            break;
//        }
//        supView = supView.superview;
//    }

    CGFloat x, y, o;
    CGFloat h = [self calcBackViewHeight];
    CGFloat dec = 10;
    switch (self.shapesBeaker) {
        case sbLeft:    //左
        {
            x = CGRectGetMaxX(r) + 1.5;
            y = r.origin.y;
            if (y + h > wr.size.height - dec)
            {
                y = wr.size.height - h - dec;
            }
            o = r.origin.y - y + r.size.height * 0.5;
        }
            break;
        case sbRight:   //右
        {
            x = r.origin.x - width - 1.5;
            y = r.origin.y;
            if (y + h > wr.size.height - dec)
            {
                y = wr.size.height - h - dec;
            }
            o = r.origin.y - y + r.size.height * 0.5;
        }
            break;
        case sbTop:     //上
        {
            y = CGRectGetMaxY(r) + 1.5;
            x = r.origin.x;
            if (x + width > wr.size.width - dec)
            {
                x = wr.size.width - width - dec;
            }
            o = r.origin.x - x + r.size.width * 0.5;
        }
            break;
        case sbBottom:   //下
        {
            y = CGRectGetMaxY(r) - h + dec;
            x = r.origin.x;
            if (x + width > wr.size.width - dec)
            {
                x = wr.size.width - width - dec;
            }
            o = r.origin.x - x + r.size.width * 0.5;
        }
            break;
        default:
        {
            x = r.origin.x;
            y = r.origin.y;
            o = -9999;
        }
            break;
    }
    if (o != 9999)
    {
        _beakerOffset = o;
    }
    [self showInView:view origin:CGPointMake(x, y) width:width];
}

- (CGFloat)calcBackViewHeight
{
    return self.buttons.count * _tableView.rowHeight + MenuFooterHeight + TableViewAddHeight;
}

- (void)showInView:(UIView *)view origin:(CGPoint)origin width:(CGFloat)width
{
    if (!view)
    {
        return;
    }
    _tableView.autoresizingMask = UIAutoSizeMaskAll;
    
    
    CGFloat addHeight = TableViewAddHeight;
    CGFloat height    = [self calcBackViewHeight];
    CGRect  rectDest  = CGRectMake(origin.x, origin.y, width, height);
    
    //calcAnimationOrigin 有用到 _backView.frame.size.width
    [self setTableViewFrame:rectDest addHeight:addHeight];
    
    self.backView.layer.anchorPoint = CGPointMake(0.9, 0);
    self.backView.layer.position    = [self calcAnimationOrigin:origin];
    self.backView.transform         = CGAffineTransformMakeScale(0.01, 0.01);

    self.backView.alpha             = 0.2;
    self.tableView.alpha            = 0.2;

    _showAnimateing = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.alpha    = 1;
        self.backView.alpha     = 1;
        self.backView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.backView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            _showAnimateing = NO;
        }];
    }];
    
    self.frame = view.window.frame;
    [view.window addSubview:self];
    
    [_tableView reloadData];
}

- (CGPoint)calcAnimationOrigin:(CGPoint)origin
{
    switch (self.shapesBeaker) {
        case sbLeft:    //左
        case sbRight:   //右
        {
            origin.y += self.beakerOffset;  //rect.size.height +
        }
            break;
        case sbTop:     //上
        case sbBottom:   //下
        {
             origin.x += self.beakerOffset; //rect.size.width +
        }
            break;
        default:
            break;
    }
    return origin;
}

- (void)setTableViewFrame:(CGRect)r addHeight:(CGFloat) addHeight
{
    _backView.frame = r;
    
    UIBezierPath *bezierPath = [UIBezierPath beakerShape: r
                                            ShapesBeaker: self.shapesBeaker
                                                  Offset: self.beakerOffset
                                             BorderWidth: 0];
    [_backView setMaskWithPath:bezierPath
               withBorderColor:textGrayColorPass
                   borderWidth:10];
    
    r.origin = CGPointMake(1, addHeight);
    r.size.height -= addHeight;
    _tableView.frame = r;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *hitView = [super hitTest:point withEvent:event];
//    return hitView == self ? nil : hitView;
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
//    UITouch *touch = [touches anyObject];
//    CGPoint p = [touch locationInView:self];
//    if (CGRectContainsPoint(_backView.frame, p))
//        return;
//    [self closeView];
    UITouch *touch = [touches anyObject];
    if (touch.view == self)
    {
        if (!_showAnimateing)
        {
            [self closeView];
        }
    }
}

- (void)closeSelfView
{
    [self closeWithAnimation:NO];
}

- (void)closeView
{
    [self closeWithAnimation: YES];
}

//关闭
- (void)closeWithAnimation:(BOOL)animation
{
    lastDropDownMenu = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (animation)
    {
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.backView.alpha  = 0.2;
                             self.tableView.alpha = 0.2;
                             self.backView.transform = CGAffineTransformMakeScale(0.01, 0.01);
                             
                         } completion:^(BOOL finished) {
                             self.backView.alpha = 0.0;
                             if (finished)
                             {
                                 [self removeFromSuperview];
                             }
                         }];
    }
    else
    {
        [self removeFromSuperview];
    }
}


@end
