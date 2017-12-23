//
//  UITableViewCellCustomDrow.m
//  wBaiJu
//
//  Created by Apple on 14-12-22.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "UITableViewCellCustom.h"
#import "UIView+MaskWithPath.h"
#import "UITableViewCustom.h"


static UIView  *kTableViewCellSelectedBackView = nil;
static UIImage *kTableViewCellAccessoryDisclosureIndicatorImage = nil;

@implementation UITableViewCell(UITableViewCellCategory)


- (void)setAccessoryView
{
    self.accessoryType     = UITableViewCellAccessoryDisclosureIndicator;
    
    UIImage *imgAccessory  = [UIImage imageNamed:@"CellAccessoryDetailImage"];
    UIImageView *accessory = nil;
    
    if ([self.accessoryView isKindOfClass:[UIImageView class]])
    {
        accessory = (UIImageView*)self.accessoryView;
        accessory.image = imgAccessory;
    }
    else
    {
        accessory = [[UIImageView alloc] initWithImage:imgAccessory];
        self.accessoryView = accessory;
#if ! __has_feature(objc_arc)
        [accessory release];
#endif
    }
    //更改
    //    accessory.frame = CGRectMake(0, 0, 28, 28);
    accessory.frame = CGRectMake(0, 0, 8, 15);
    accessory.backgroundColor = [UIColor clearColor];
    accessory.hidden = NO;
}

//设置Cell默认选中UIView
+ (void)setTableViewCellSelectedBackView:(UIView *)selectedBackView
{
    if (kTableViewCellSelectedBackView)
    {
#if ! __has_feature(objc_arc)
        [kTableViewCellSelectedBackView release];
#endif

    }
    kTableViewCellSelectedBackView = selectedBackView;
    
#if ! __has_feature(objc_arc)
    [kTableViewCellSelectedBackView retain];
#endif

}

+ (void)setTableViewCellAccessoryDisclosureIndicatorImage:(UIImage *)image
{
    if (kTableViewCellAccessoryDisclosureIndicatorImage)
    {
#if ! __has_feature(objc_arc)
        [kTableViewCellAccessoryDisclosureIndicatorImage release];
#endif
        
    }
    kTableViewCellAccessoryDisclosureIndicatorImage = image;
    
#if ! __has_feature(objc_arc)
    [kTableViewCellAccessoryDisclosureIndicatorImage retain];
#endif
}

//返回Cell默认返回UIView   default  nil
+ (UIView *)tableViewCellSelectedBackView
{
    return kTableViewCellSelectedBackView;
}

@end

@implementation UITableViewCell (UITableView)

+ (instancetype)cellWithTableView:(UITableView *)tableView CellStyle:(UITableViewCellStyle)cellStyle
{
    //这用类名做ident，是为了避免同个TableView中，忘记区分ident
    NSString *cellIdent = NSStringFromClass([self class]);
    return [self cellWithTableView:tableView CellStyle:cellStyle cellIdent:cellIdent];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView CellStyle:(UITableViewCellStyle)cellStyle
                        cellIdent:(NSString *)cellIdent;
{
    UITableViewCellCustom *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if (!cell)
    {
        cell = [[self alloc] initWithStyle:cellStyle reuseIdentifier:cellIdent];
#if ! __has_feature(objc_arc)
        [cell autorelease];
#endif
    }
    return cell;
}

- (UITableView*)tableView
{
    UIView *superView = self.superview;
    while (superView) {
        if ([superView isKindOfClass:[UITableView class]])
        {
            break;
        }
        superView = superView.superview;
    }
    if (!superView)
        return nil;
    
    UITableView *tableView = (UITableView*)superView;
    return tableView;
}

@end

@interface UITableViewCellCustom()

@property (nonatomic) BOOL isSplitRow;

@property (nonatomic, retain) NSHashTable *unChangeBackgroundColorViews;

@end

@implementation UITableViewCellCustom


- (void)setUnChangeBackgroundColorWithViewOnHighlighted:(UIView *)view
{
    if (!_unChangeBackgroundColorViews)
    {
        self.unChangeBackgroundColorViews = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
    }
    [self.unChangeBackgroundColorViews addObject:view];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;
{
    NSMapTable *saveColors = nil;
    if (highlighted && _unChangeBackgroundColorViews)
    {
        saveColors = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory
                                           valueOptions:NSPointerFunctionsStrongMemory];
        for (UIView *view in _unChangeBackgroundColorViews) {
            dispatch_main_async(^{
                [saveColors setObject:view.backgroundColor forKey:view];
            });
        }
    }
    [super setHighlighted:highlighted animated:animated];
    
    if (saveColors && _unChangeBackgroundColorViews)
    {
        for (UIView *view in _unChangeBackgroundColorViews) {
            view.backgroundColor = [saveColors objectForKey: view];
        }
        [saveColors removeAllObjects];
    }
}

//分隔行 赋值
- (void)setIsSplitRow:(BOOL)value
{
    //if (_isSplitRow == value)
    //    return;
    _isSplitRow = value;
    
    if (value)
    {
        //_drawTopLine     = NO;
        //_drawBottomLine  = NO;
        
        self.accessoryType   = UITableViewCellAccessoryNone;
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        self.imageView.image      = nil;
        self.textLabel.text       = @"";
        self.detailTextLabel.text = @"";
        self.backgroundColor      = UITableViewBackgroundColor;
        
        if (self.accessoryView)
            self.accessoryView.hidden = YES;
    }
    else
    {
        self.selectionStyle         = UITableViewCellSelectionStyleGray;
        self.backgroundColor        = UITableViewCellBackgroundColor;
        
        self.selectedBackgroundView = kTableViewCellSelectedBackView;
    }
}

- (void)layoutSubviews
{
    CGFloat cellLeftX = UITableViewCellCustomLeftX;

    [super layoutSubviews];
    
    
    CGFloat dec = _imageWidthDec + [WBJUIFont fontLevel];
    
    CGFloat h = ceilf(self.frame.size.height - dec);
    CGFloat x = ceilf(cellLeftX + self.indentationLevel * self.indentationWidth);

    CGFloat separatorX = _isSplitRow || self.separatorAlign == SeparatorAlignLeft ? 0.0 : x;
    
    if (!_isSplitRow && self.imageView.image)
    {
        if (self.separatorAlign == SeparatorAlignImageView)
            separatorX = x;
        
        self.imageView.frame = CGRectMake(x, dec / 2.0, h, h);
        x += h + cellLeftX; //UITableViewCellCustomLeftX;
    }
    
    CGRect r = self.textLabel.frame;
    r.origin.x = x;
    if (self.separatorAlign == SeparatorAlignTextLabel)
        separatorX = x;
    else
    if (self.separatorAlign == SeparatorAlignNone)
        separatorX = self.frame.size.width * 2.0;
    
    self.textLabel.frame = r;
    
    CGFloat y = CGRectGetMaxY(r) + 2;
    r = self.detailTextLabel.frame;
    r.origin.x = x;
    if (r.origin.y < y)
        r.origin.y = y;
    self.detailTextLabel.frame = r;
    
    //用户自定义 accessoryView
    UIView *accessoryView = self.accessoryView;
    if (!accessoryView && self.accessoryType != UITableViewCellAccessoryNone)
    {
        //系统accessoryView
        accessoryView = [self valueForKey:@"_accessoryView"];
//        accessoryView.hidden = self.accessoryType == UITableViewCellAccessoryNone;
    }
    
    if (accessoryView)
    {
        if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator && kTableViewCellAccessoryDisclosureIndicatorImage && [accessoryView isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton *)accessoryView;
            [button setBackgroundImage:kTableViewCellAccessoryDisclosureIndicatorImage forState:UIControlStateNormal];
        }
        
        UITableView *tableView = [self tableView];
        CGFloat offsetRight = 0;
        //如果使用系统的 索引区
        if (tableView && tableView.dataSource &&  ([tableView.dataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)] || [tableView.dataSource respondsToSelector:@selector(sectionIndexTitlesForABELTableView:)]))
        {
            offsetRight = 10;
        }
        
        CGRect ar = accessoryView.frame;
        ar.origin.x = self.frame.size.width - ar.size.width - cellLeftX - offsetRight;
        accessoryView.frame = ar;
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        if (!UIEdgeInsetsEqualToEdgeInsets(self.layoutMargins, UIEdgeInsetsZero))
            [self setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if (self.separatorAlign != SeparatorAlignCustom && [self respondsToSelector:@selector(separatorInset)]) {
        
        UIEdgeInsets inset = UIEdgeInsetsZero;
        inset.left = separatorX;
        inset.top  = 0.2;
        if (!UIEdgeInsetsEqualToEdgeInsets(self.separatorInset, inset))
        {
            self.separatorInset = inset;
        }
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textLabel.font  = [WBJUIFont tableViewFont];
        self.exclusiveTouch  = YES;
        self.backgroundColor = UITableViewCellBackgroundColor;
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        self.detailTextLabel.font            = [WBJUIFont tableViewDetailFont];
        self.detailTextLabel.textColor       = [UIColor grayColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor     = [UIColor clearColor];

        _imageWidthDec           = 14;
        _autoCancelSelected      = YES;
        //self.opaque = NO;
        //self.clearsContextBeforeDrawing = YES;
        
        self.selectedBackgroundView = kTableViewCellSelectedBackView;
        
        self.imageView.layer.cornerRadius = RadiusIcon;
        self.imageView.clipsToBounds      = YES;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    //如果选中
    if (selected && _autoCancelSelected)
        [self setSelected:NO animated:true];
}

- (void)dealloc
{
    //取消 下载图片
    if (self.imageView && [self.imageView respondsToSelector:@selector(cancelCurrentFileDownload)])
        [self.imageView performSelector:@selector(cancelCurrentFileDownload)];
    self.unChangeBackgroundColorViews = nil;
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif

}

@end

@interface UISectionHeaderView()

@end


@implementation UISectionHeaderView

+ (UISectionHeaderView *)headerWithHeight:(CGFloat)height
{
    UISectionHeaderView *header = [[self alloc] initWithWidth:SCREENW Height:height];
#if ! __has_feature(objc_arc)
    [header autorelease];
#endif
    return header;
}

+ (UISectionHeaderView *)standardHeader
{
    return [self headerWithHeight: [self standardHeaderHeight]];
}

//timeFont lineHeight + 8
+ (CGFloat)standardHeaderHeight
{
    return ceilf([WBJUIFont tableViewDetailFont].lineHeight + 8.0);
}

- (instancetype)initWithWidth:(CGFloat)width Height:(CGFloat)height
{
    return [self initWithFrame:CGRectMake(0, 0, width, height)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = UITableViewBackgroundColor;
        self.textEdgeInsets  = UIEdgeInsetsMake(0, UITableViewCellCustomLeftX, 0, UITableViewCellCustomLeftX);
        self.textColor       = [UIColor grayColor];
        self.font            = [WBJUIFont tableViewDetailFont];
        _keepMoveSection     = NSUIntegerMax;
    }
    return self;
}

- (UITableView *)superTableView
{
    UIView *superView = self.superview;
    while (superView) {
        if ([superView isKindOfClass:[UITableView class]])
        {
            break;
        }
        superView = superView.superview;
    }
    if (!superView)
        return nil;
    
    UITableView *tableView = (UITableView*)superView;
    return tableView;
}

- (void)setFrame:(CGRect)frame{
    
    if (_keepMoveSection != NSUIntegerMax)
    {
        UITableView *tv = [self superTableView];
        if (tv && tv.dataSource && [tv.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)] && _keepMoveSection < [tv.dataSource numberOfSectionsInTableView:tv])
        {
            CGRect sectionRect = [tv rectForSection:self.keepMoveSection];
            frame.origin.y = _sectionViewType == UISectionViewTypeFooter ? CGRectGetMaxY(sectionRect) - frame.size.height : CGRectGetMinY(sectionRect);
        }
    }
    [super setFrame:frame];
}

@end
