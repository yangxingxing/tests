//
//  WBJUIActionSheet.m
//  
//
//  Created by 邱家楗 on 16/5/18.
//  Copyright © 2016年 邱家楗. All rights reserved.
//

#import "WBJUIActionSheet.h"
#import "UIView+MaskWithPath.h"
#import "UITableViewCustom.h"

#define SplitRowHeight 8

@interface WBJUIActionSheetItem: NSObject

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   UIColor  *textColor;
@property (nonatomic, copy)   WBJUIActionSheetBlock block;

@end

@implementation WBJUIActionSheetItem

- (void)dealloc
{
    self.title     = nil;
    self.block     = nil;
    self.textColor = nil;
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

@end

@interface UITableViewCellActionSheet : UITableViewCell


@end


@implementation UITableViewCellActionSheet

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect r = self.textLabel.frame;
    r.origin.x = 0;
    r.size.width = self.frame.size.width;
    self.textLabel.frame = r;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsMake(0, -50, 0, -50)];
            self.preservesSuperviewLayoutMargins = NO;
        }
        
        if ([self respondsToSelector:@selector(separatorInset)])
        {
            UIEdgeInsets separatorInset = self.separatorInset;
            separatorInset.left  = -50;
            separatorInset.right = -50;
            self.separatorInset = separatorInset;
        }
    }
    return self;
}

@end


@interface WBJUIActionSheet ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain)   NSMutableArray *buttons;
@property (nonatomic, readonly) UITableViewCustom  *tableView;
@property (nonatomic, readonly) UIView         *backView;
@property (nonatomic, readonly) UIView         *topBackView;

@property (nonatomic, copy)     NSString       *title;
@property (nonatomic, copy)     NSString       *cancelButtonTitle;

@end

@implementation WBJUIActionSheet

- (instancetype)init
{
    return [self initWithTitle:nil cancelButtonTitle:LocalizedString(@"Cancel")];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithTitle:nil cancelButtonTitle:LocalizedString(@"Cancel")];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithTitle:nil cancelButtonTitle:LocalizedString(@"Cancel")];
}

- (instancetype) initWithTitle:(NSString *)title
             cancelButtonTitle:(NSString *)cancelButtonTitle
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {
        self.title = title;
        self.cancelButtonTitle = cancelButtonTitle;
        self.autoresizingMask  = UIAutoSizeMaskAll;

        _buttons = [[NSMutableArray alloc] init];
        
        _topBackView = [[UIView alloc] init];
        _topBackView.autoresizingMask = UIAutoSizeMaskAll;
        [self addSubview:_topBackView];
        
        UITapGestureRecognizer *tapPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
        [_topBackView addGestureRecognizer:tapPress];
        
#if ! __has_feature(objc_arc)
        [_topBackView release];
        [tapPress release];
#endif
    }
    return self;
}

- (void)dealloc
{
    self.buttons = nil;
    self.title   = nil;
    self.cancelButtonTitle = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)addItemWithTitle:(NSString *)title block:(WBJUIActionSheetBlock)block tag:(NSInteger)tag
{
    [self addItemWithTitle:title block:block tag: tag titleColor:nil];
}

- (void)addItemWithTitle:(NSString *)title block:(WBJUIActionSheetBlock)block tag:(NSInteger)tag titleColor:(UIColor *)titleColor
{
    if (!_buttons)
    {
        _buttons = [[NSMutableArray alloc] initWithCapacity:2];
    }
    
    WBJUIActionSheetItem *item = [[WBJUIActionSheetItem alloc] init];
    item.tag    = tag;
    item.title  = title;
    item.block  = block;
    item.textColor = titleColor;
    
    [_buttons addObject:item];
}

- (void)showInView:(UIView *)inView
{
    if (!inView)
        return;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeView)
                                                 name:@"mctShutdown"
                                               object:nil];
    
    self.frame = inView.window.bounds;
    
    CGFloat rowHeight = 50 * [WBJUIFont screenRate];
    CGFloat h = rowHeight * (self.buttons.count + 1) + SplitRowHeight;
    if (self.title && self.title.length > 0)
        h += rowHeight;

    UIColor *backColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    CGRect  r = CGRectMake(0, self.frame.size.height, self.frame.size.width, h);
    _topBackView.frame = self.frame;
    _topBackView.backgroundColor = [UIColor clearColor];
    self.backgroundColor         = backColor;
    
    if (!_backView)
    {
        CGFloat sysVer = [[[UIDevice currentDevice] systemVersion] doubleValue];
        
        if (sysVer < 7.0)
        {
            _backView = [[UIScrollView alloc] initWithFrame:r];
            _backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.98];
        }
        else
        if (sysVer < 8.0) //IOS 7
        {
            UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:r];
            toolBar.barTintColor = nil;
            toolBar.translucent  = YES;
            _backView = toolBar;
        }
        else
        {
            UIBlurEffect *beffect    = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            _backView = [[UIVisualEffectView alloc]initWithEffect:beffect];
            _backView.frame = r;
        }
        [self addSubview:_backView];
        _backView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
#if ! __has_feature(objc_arc)
        [_backView release];
#endif
    }
    _backView.frame = r;
    
    if (!_tableView)
    {
        _tableView = [[UITableViewCustom alloc] initWithFrame: r
                                                        style: UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        _tableView.rowHeight  = rowHeight;
        _tableView.autoresizingMask = _backView.autoresizingMask;
        _tableView.backgroundColor  = [UIColor clearColor];
        _tableView.separatorColor   = [UIColor lightGrayColor];
        _tableView.autoresizingMask = UIAutoSizeMaskBottom;
        [self addSubview:_tableView];
#if ! __has_feature(objc_arc)
        [_tableView release];
#endif
    }
    _tableView.scrollEnabled = NO;
    _tableView.frame = r;
    
    [_tableView reloadData];
    
    [inView.window addSubview:self];
    
    self.alpha = 0.1;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha  = 1.0;
        CGRect r1   = r;
        r1.origin.y = self.frame.size.height - h;
        _backView.frame  = r1;
        _tableView.frame = r1;
        
        _topBackView.frame = CGRectMake(0, 0, r.size.width, self.frame.size.height - h);
    } completion:^(BOOL finished) {
        
        _topBackView.backgroundColor = backColor;
        self.backgroundColor         = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];

    }];
}

- (BOOL)hasTitle
{
    return self.title && self.title.length > 0;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return section == 0 ? self.buttons.count + ([self hasTitle] ? 1 : 0) : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCellActionSheet *cell = [UITableViewCellActionSheet cellWithTableView:tableView
                                                                           CellStyle:UITableViewCellStyleDefault cellIdent:@"cell"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.textLabel.font      = [WBJUIFont tableViewFont];
    cell.textLabel.textColor = [UIColor blackColor];
    if (indexPath.section == 0)
    {
        if ([self hasTitle] && indexPath.row == 0)
        {
            cell.selectionStyle      = UITableViewCellSelectionStyleNone;
            cell.textLabel.font      = [WBJUIFont tableViewTimeFont];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.text      = self.title;
        }
        else
        {
            cell.selectionStyle      = UITableViewCellSelectionStyleGray;
            WBJUIActionSheetItem *item = self.buttons[indexPath.row - ([self hasTitle] ? 1 : 0)];
            if (item.textColor)
                cell.textLabel.textColor = item.textColor;
            cell.textLabel.text      = item.title;
        }
    }
    else
    {
        cell.selectionStyle      = UITableViewCellSelectionStyleGray;
        cell.textLabel.text      = self.cancelButtonTitle;
    }
    cell.backgroundColor             = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor   = [UIColor clearColor];

    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 0 : SplitRowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat h = [self tableView:tableView heightForHeaderInSection:section];
    CGRect r = CGRectMake(0, 0, SCREENW, h);
    UIView *header = [[UIView alloc] initWithFrame:r];
    header.backgroundColor = [_tableView.separatorColor colorWithAlphaComponent:0.90];

#if ! __has_feature(objc_arc)
    [header autorelease];
#endif
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if ([self hasTitle] && indexPath.row == 0)
            return;
        NSInteger row = indexPath.row - ([self hasTitle] ? 1 : 0);
        WBJUIActionSheetItem *item = self.buttons[row];
        if (item.block)
        {
            item.block(item.tag);
            [self closeView];
        }
    }
    else
    if (indexPath.section == 1)
    {
        [self closeView];
    }
}

- (void)closeView
{
    if (!self.buttons)
    {
        return;
    }
    self.buttons = nil;
    self.title   = nil;
    self.cancelButtonTitle = nil;
    
    if (_closeViewBlock)
    {
        _closeViewBlock();
        self.closeViewBlock = nil;
    }
    CGRect r   = _backView.frame;
    r.origin.y = self.frame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        _topBackView.alpha  = 0;

        _backView.frame  = r;
        _tableView.frame = r;
        
        _topBackView.frame = self.frame;
        
    }completion:^(BOOL finished) {
        if (finished)
        {
            [self.backView removeFromSuperview];
            [self.topBackView removeFromSuperview];
            [self.buttons removeAllObjects];
            [self removeFromSuperview];
        }
    }];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    if (touch.view == self)
    {
        [self closeView];
    }
}


@end
