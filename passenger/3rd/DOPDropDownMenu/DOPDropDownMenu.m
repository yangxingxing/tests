//
//  DOPDropDownMenu.m
//  DOPDropDownMenuDemo
//
//  Created by weizhou on 9/26/14.
//  Modify by tanyang on 20/3/15.
//  Copyright (c) 2014 fengweizhou. All rights reserved.
//

#import "DOPDropDownMenu.h"
#import "UIImageCategory.h"
#import "UISubTitleCell.h"
@implementation DOPIndexPath
- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row {
    self = [super init];
    if (self) {
        _column = column;
        _row = row;
        _item = -1;
    }
    return self;
}

- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row tem:(NSInteger)item {
    self = [self initWithColumn:column row:row];
    if (self) {
        _item = item;
    }
    return self;
}

+ (instancetype)indexPathWithCol:(NSInteger)col row:(NSInteger)row {
    DOPIndexPath *indexPath = [[self alloc] initWithColumn:col row:row];
    return indexPath;
}

+ (instancetype)indexPathWithCol:(NSInteger)col row:(NSInteger)row item:(NSInteger)item
{
    return [[self alloc]initWithColumn:col row:row tem:item];
}

@end

@implementation DOPBackgroundCellView

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画一条底部线
    
    CGContextSetRGBStrokeColor(context, 219.0/255, 224.0/255, 228.0/255, 1);//线条颜色
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, rect.size.width,0);
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width,rect.size.height);
    CGContextStrokePath(context);
}

@end

#pragma mark - menu implementation

@interface DOPDropDownMenu (){
    struct {
        unsigned int numberOfRowsInColumn :1;
        unsigned int numberOfItemsInRow :1;
        unsigned int titleForRowAtIndexPath :1;
        unsigned int titleForItemsInRowAtIndexPath :1;
        unsigned int imageNameForRowAtIndexPath :1;
        unsigned int imageSelectedNameForRowAtIndexPath :1;
        unsigned int imageNameForItemsInRowAtIndexPath :1;
        unsigned int detailTextForRowAtIndexPath: 1;
        unsigned int detailTextForItemsInRowAtIndexPath: 1;
        
    }_dataSourceFlags;
    BOOL isFirstTwo;
    UIView *_customView;
}

@property (nonatomic, assign) NSInteger currentSelectedMenudIndex;  // 当前选中列

@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) NSInteger numOfMenu;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, strong) UIView *backGroundView;

//@property (nonatomic, strong) UIImageView *buttomImageView; // 底部imageView
@property (nonatomic, weak) UIView *bottomShadow;

//data source
@property (nonatomic, copy) NSArray *array;
//layers array
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *indicators;
@property (nonatomic, copy) NSArray *bgLayers;

@end

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define kTableViewCellHeight 43
#define kTableViewHeight 300
#define kButtomImageViewHeight 21
#define kTextSpace 20
#define kTextColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]
#define kDetailTextColor [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1]
#define kSeparatorColor [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1]
#define kCellBgColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]
#define kTextSelectColor [UIColor colorWithRed:246/255.0 green:79/255.0 blue:0/255.0 alpha:1]

@implementation DOPDropDownMenu {
    CGFloat _tableViewHeight;
}

#pragma mark - getter
- (UIColor *)indicatorColor {
    if (!_indicatorColor) {
        _indicatorColor = [UIColor blackColor];
    }
    return _indicatorColor;
}

- (UIColor *)textColor {
    if (!_textColor) {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}

- (UIColor *)separatorColor {
    if (!_separatorColor) {
        _separatorColor = [UIColor blackColor];
    }
    return _separatorColor;
}

- (NSString *)titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    return [self.dataSource menu:self titleForRowAtIndexPath:indexPath];
}

- (void)reloadData
{
    [self animateBackGroundView:_backGroundView show:NO complete:^{
        [self animateTableView:nil show:NO complete:^{
            _show = NO;
            id VC = self.dataSource;
            self.dataSource = nil;
            self.dataSource = VC;
        }];
    }];
    
}

- (void)selectDefalutIndexPath
{
    [self selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:0]];
}

- (void)selectIndexPath:(DOPIndexPath *)indexPath triggerDelegate:(BOOL)trigger {
    if (!_dataSource || !_delegate
        || ![_delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
        return;
    }
    
    if ([_dataSource numberOfColumnsInMenu:self] <= indexPath.column || [_dataSource menu:self numberOfRowsInColumn:indexPath.column] <= indexPath.row) {
        return;
    }
    NSInteger j=indexPath.column;
    if (isFirstTwo) {
        j +=1;
    }
    CATextLayer *title = (CATextLayer *)_titles[j];
    
    if (indexPath.item < 0 ) {
        if (!_isClickHaveItemValid && [_dataSource menu:self numberOfItemsInRow:indexPath.row column:indexPath.column] > 0){
            title.string = [_dataSource menu:self titleForMenuClickAtIndexPath:[DOPIndexPath indexPathWithCol:indexPath.column row:self.isRemainMenuTitle ? 0 : indexPath.row item:0]];
            if (trigger) {
                [_delegate menu:self didSelectRowAtIndexPath:[DOPIndexPath indexPathWithCol:indexPath.column row:indexPath.row item:0]];
            }
        }else {
            title.string = [_dataSource menu:self titleForMenuClickAtIndexPath:
                            [DOPIndexPath indexPathWithCol:indexPath.column row:self.isRemainMenuTitle ? 0 : indexPath.row]];
            if (trigger) {
                [_delegate menu:self didSelectRowAtIndexPath:indexPath];
            }
        }
        if (_currentSelectRowArray.count > indexPath.column) {
            _currentSelectRowArray[indexPath.column] = @(indexPath.row);
        }
        CGSize size = [self calculateTitleSizeWithString:title.string];
        CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - kTextSpace) ? size.width : self.frame.size.width / _numOfMenu - kTextSpace;
        title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    }else if ([_dataSource menu:self numberOfItemsInRow:indexPath.row column:indexPath.column] > indexPath.column) {
        if (![_dataSource menu:self itemsExistAtColumn:indexPath.column]) {
            title.string = [_dataSource menu:self titleForMenuClickAtIndexPath:indexPath];
            if (trigger) {
                [_delegate menu:self didSelectRowAtIndexPath:indexPath];
            }
            if (_currentSelectRowArray.count > indexPath.column) {
                _currentSelectRowArray[indexPath.column] = @(indexPath.row);
            }
            CGSize size = [self calculateTitleSizeWithString:title.string];
            CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - kTextSpace) ? size.width : self.frame.size.width / _numOfMenu - kTextSpace;
            title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
        }

    }else{
        //可能有问题 出现问题要注意这
        if (trigger) {
            [_delegate menu:self didSelectRowAtIndexPath:indexPath];
        }
        if (_currentSelectRowArray.count > indexPath.column) {
            _currentSelectRowArray[indexPath.column] = @(indexPath.row);
        }
    }
}

- (void)selectIndexPath:(DOPIndexPath *)indexPath {
    [self selectIndexPath:indexPath triggerDelegate:YES];
}

#pragma mark - setter
- (void)setDataSource:(id<DOPDropDownMenuDataSource>)dataSource {
    if (_dataSource == dataSource) {
        return;
    }
    _dataSource = dataSource;
    
    //configure view
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInMenu:)]) {
        _numOfMenu = [_dataSource numberOfColumnsInMenu:self];
    } else {
        _numOfMenu = 1;
    }

    _selectedIndexPathAry = [NSMutableArray arrayWithCapacity:_numOfMenu];
    for (NSInteger index = 0; index < _numOfMenu; index++) {
        DOPIndexPath *indexpath = [DOPIndexPath indexPathWithCol:index row:0 item:0];
        [_selectedIndexPathAry addObject:indexpath];
    }
    
    _currentSelectRowArray = [NSMutableArray arrayWithCapacity:_numOfMenu];
    
    for (NSInteger index = 0; index < _numOfMenu; ++index) {
        [_currentSelectRowArray addObject:@(0)];
    }
    
    _dataSourceFlags.numberOfRowsInColumn = [_dataSource respondsToSelector:@selector(menu:numberOfRowsInColumn:)];
    _dataSourceFlags.numberOfItemsInRow = [_dataSource respondsToSelector:@selector(menu:numberOfItemsInRow:column:)];
    _dataSourceFlags.titleForRowAtIndexPath = [_dataSource respondsToSelector:@selector(menu:titleForRowAtIndexPath:)];
    _dataSourceFlags.titleForItemsInRowAtIndexPath = [_dataSource respondsToSelector:@selector(menu:titleForItemsInRowAtIndexPath:)];
    _dataSourceFlags.imageNameForRowAtIndexPath = [_dataSource respondsToSelector:@selector(menu:imageNameForRowAtIndexPath:)];
    _dataSourceFlags.imageSelectedNameForRowAtIndexPath = [_dataSource respondsToSelector:@selector(menu:imageSelectedNameForRowAtIndexPath:)];
    _dataSourceFlags.imageNameForItemsInRowAtIndexPath = [_dataSource respondsToSelector:@selector(menu:imageNameForItemsInRowAtIndexPath:)];
    _dataSourceFlags.detailTextForRowAtIndexPath = [_dataSource respondsToSelector:@selector(menu:detailTextForRowAtIndexPath:)];
    _dataSourceFlags.detailTextForItemsInRowAtIndexPath = [_dataSource respondsToSelector:@selector(menu:detailTextForItemsInRowAtIndexPath:)];
    
    _bottomShadow.hidden = NO;
    CGFloat textLayerInterval = self.frame.size.width / ( _numOfMenu * 2);
    CGFloat separatorLineInterval = self.frame.size.width / _numOfMenu;
    CGFloat bgLayerInterval = self.frame.size.width / _numOfMenu;
    
    NSMutableArray *tempTitles = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempIndicators = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempBgLayers = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    
    for (int i = 0; i < _numOfMenu; i++) {
        //bgLayer
        CGPoint bgLayerPosition = CGPointMake((i+0.5)*bgLayerInterval, self.frame.size.height/2);
        CALayer *bgLayer = [self createBgLayerWithColor:[UIColor whiteColor] andPosition:bgLayerPosition];
        [self.layer addSublayer:bgLayer];
        [tempBgLayers addObject:bgLayer];
        //title
        CGPoint titlePosition = CGPointMake( (i * 2 + 1) * textLayerInterval - 5 , self.frame.size.height / 2);
        
        NSString *titleString;
        if (!self.isClickHaveItemValid && _dataSourceFlags.numberOfItemsInRow && [_dataSource menu:self numberOfItemsInRow:0 column:i]>0) {
            titleString = [_dataSource menu:self titleForItemsInRowAtIndexPath:[DOPIndexPath indexPathWithCol:i row:0 item:0]];
        }else {
            titleString =[_dataSource menu:self titleForMenuClickAtIndexPath:[DOPIndexPath indexPathWithCol:i row:0]];
        }
//        NSArray *ary = [titleString componentsSeparatedByString:@"\n"];
//        if (ary.count == 2) {
////            isFirstTwo = YES;
//            CATextLayer *title1 = [self createTextLayerWithNSString:ary[0] withColor:self.textColor andPosition:CGPointMake(titlePosition.x, self.frame.size.height / 4+5)];
//            [self.layer addSublayer:title1];
//            [tempTitles addObject:title1];
//            CATextLayer *title2= [self createTextLayerWithNSString:ary[1] withColor:self.textColor andPosition:CGPointMake(titlePosition.x, self.frame.size.height / 4*3)];
//            [self.layer addSublayer:title2];
//            [tempTitles addObject:title2];
//            //indicator
//            CAShapeLayer *indicator = [self createIndicatorWithColor:self.indicatorColor andPosition:CGPointMake(title1.bounds.size.width/2+titlePosition.x+5, self.frame.size.height / 2)];
//            [self.layer addSublayer:indicator];
//            [tempIndicators addObject:indicator];
//        }else{
            CATextLayer *title = [self createTextLayerWithNSString:titleString withColor:self.textColor andPosition:titlePosition];
            [self.layer addSublayer:title];
            [tempTitles addObject:title];
            //indicator
            CAShapeLayer *indicator = [self createIndicatorWithColor:self.indicatorColor andPosition:CGPointMake(title.bounds.size.width/2+titlePosition.x+5, self.frame.size.height / 2)];
            
            [self.layer addSublayer:indicator];
            SLog(@"titlePosition = %@,title.bounds = %@,indicator.position = %@,indicator.bounds = %@",NSStringFromCGPoint(titlePosition),NSStringFromCGRect(title.bounds),NSStringFromCGPoint(indicator.position),NSStringFromCGRect(indicator.bounds));
            [tempIndicators addObject:indicator];
//        }
//        //indicator
//        CAShapeLayer *indicator = [self createIndicatorWithColor:self.indicatorColor andPosition:CGPointMake((i + 1)*separatorLineInterval - 10, self.frame.size.height / 2)];
//        [self.layer addSublayer:indicator];
//        [tempIndicators addObject:indicator];
        
        //separator
        if (i != _numOfMenu - 1) {
            CGPoint separatorPosition = CGPointMake(ceilf((i + 1) * separatorLineInterval-1), self.frame.size.height / 2);
            CAShapeLayer *separator = [self createSeparatorLineWithColor:BusinessCellSeparatorLineColor andPosition:separatorPosition];
            [self.layer addSublayer:separator];
        }
        
        
    }
    _titles = [tempTitles copy];
    _indicators = [tempIndicators copy];
    _bgLayers = [tempBgLayers copy];
}

#pragma mark - init method
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, height)];
    if (self) {
        _origin = origin;
        _currentSelectedMenudIndex = -1;
        _show = NO;
        _fontSize = 14;
        _cellStyle = UITableViewCellStyleDefault;
        _separatorColor = BusinessCellSeparatorLineColor;
        _textColor = [UIColor blackColor];
        _textSelectedColor = textOrangeColor;
        _detailTextFont = [UIFont systemFontOfSize:11];
        _detailTextColor = kDetailTextColor;
        _indicatorColor = kTextColor;
        _tableViewHeight = SCREENH - 64 - 150;
        _isClickHaveItemValid = YES;
        

        //lefttableView init
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 0) style:UITableViewStylePlain];
        _leftTableView.rowHeight = kTableViewCellHeight;
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        [_leftTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _leftTableView.backgroundColor = kCellBgColor;

//        if ([_leftTableView respondsToSelector:@selector(separatorInset)]) {
//            _leftTableView.separatorInset = UIEdgeInsetsZero;
//        }
        _leftTableView.tableFooterView = [[UIView alloc]init];
        
        //righttableView init
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 0) style:UITableViewStylePlain];
        _rightTableView.rowHeight = kTableViewCellHeight;
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
//        _rightTableView.backgroundColor = kCellBgColor;
        [_rightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

//        _rightTableView.separatorColor = kSeparatorColor;
//        if ([_rightTableView respondsToSelector:@selector(separatorInset)]) {
//            _rightTableView.separatorInset = UIEdgeInsetsZero;
//
//        }
        _rightTableView.tableFooterView = [[UIView alloc]init];
        
//        _buttomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, kButtomImageViewHeight)];
//        _buttomImageView.image = [UIImage imageNamed:@"icon_chose_bottom"];
        
        //self tapped
        self.backgroundColor = [UIColor whiteColor];
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped:)];
        [self addGestureRecognizer:tapGesture];
        
        //background init and tapped
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, screenSize.height)];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [_backGroundView addGestureRecognizer:gesture];
        
        //add bottom shadow
        UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, screenSize.width, 0.5)];
        bottomShadow.backgroundColor = BusinessCellSeparatorLineColor;
        bottomShadow.hidden = YES;
        [self addSubview:bottomShadow];
        _bottomShadow = bottomShadow;
    }
    return self;
}

#pragma mark - init support
- (CALayer *)createBgLayerWithColor:(UIColor *)color andPosition:(CGPoint)position {
    CALayer *layer = [CALayer layer];
    
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, self.frame.size.width/self.numOfMenu, self.frame.size.height-1);
    layer.backgroundColor = color.CGColor;
    
    return layer;
}

- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
//    CAShapeLayer *layer = [CAShapeLayer new];
    
//    UIBezierPath *path = [UIBezierPath new];
//    [path moveToPoint:CGPointMake(0, 0)];
//    [path addLineToPoint:CGPointMake(4, 5)];
//    [path addLineToPoint:CGPointMake(8, 0)];
//    [path closePath];
    
//    layer.path = path.CGPath;
//    layer.lineWidth = 0.8;
//    layer.fillColor = color.CGColor;
    CGMutablePathRef linePath = CGPathCreateMutable();
    CAShapeLayer * lineShape = [CAShapeLayer layer];
    lineShape.lineWidth = UIButtonBorderWidth+0.1;
    lineShape.lineCap = kCALineCapRound;
    lineShape.strokeColor = [color CGColor];
    CGPathMoveToPoint(linePath, NULL, 0, 0);
    CGPathAddLineToPoint(linePath, NULL, 5, 5);
//    CGPathAddLineToPoint(linePath, NULL, 8, 0);
    CGPathMoveToPoint(linePath, NULL, 5, 5);
    CGPathAddLineToPoint(linePath, NULL, 10, 0);
    lineShape.path = linePath;
    CGPathRelease(linePath);
//    [self.layer addSublayer:lineShape];
    CGPathRef bound = CGPathCreateCopyByStrokingPath(lineShape.path, nil, lineShape.lineWidth, kCGLineCapButt, kCGLineJoinMiter, lineShape.miterLimit);
    lineShape.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    lineShape.position = point;
    
    return lineShape;
}

- (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, self.height)];
    
    layer.path = path.CGPath;
    layer.lineWidth = UIButtonBorderWidth+0.1;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = point;
    return layer;
}

- (CATextLayer *)createTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point {
    
    CGSize size = [self calculateTitleSizeWithString:string];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - kTextSpace) ? size.width : self.frame.size.width / _numOfMenu - kTextSpace;
    layer.wrapped = _isDateSelect;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    UIFont *font = [WBJUIFont lightFontWithSize:_fontSize];
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    layer.font = fontRef;
    layer.fontSize = _fontSize;

    layer.alignmentMode = kCAAlignmentCenter;
    layer.truncationMode = kCATruncationEnd;
    layer.foregroundColor = color.CGColor;
    
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    layer.position = point;
    
    CGFontRelease(fontRef);
    
    return layer;
}

- (CGSize)calculateTitleSizeWithString:(NSString *)string
{
    //CGFloat fontSize = 14.0;
//    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:_fontSize]};
    CGSize size = [string calcSizeWithFont:[WBJUIFont lightFontWithSize:_fontSize] constrainedToSize:CGSizeMake(280, 0)];
//    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return CGSizeMake(ceilf(size.width)+2, size.height);
}

#pragma mark - gesture handle
- (void)menuTapped:(UITapGestureRecognizer *)paramSender {
    if (_dataSource == nil) {
        return;
    }
    CGPoint touchPoint = [paramSender locationInView:self];
    //calculate index
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / _numOfMenu);
    BOOL shouldDrown = YES;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(menu:willDorpDownMenuAtIndex:success:)]) {
        shouldDrown = [self.dataSource menu:self willDorpDownMenuAtIndex:tapIndex success:^{
//            if (_show) {
////                [_leftTableView reloadData];
//                [self animateTableView:_leftTableView show:YES complete:^{
//                    
//                }];
//            }else
                [self clickIndexAction:tapIndex];
        }];
    }
    if (shouldDrown) {
        [self clickIndexAction:tapIndex];
    }

}
-(void)clickIndexAction:(NSInteger)tapIndex{
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:didSelectedMenuButtonAtIndex:)]) {
        BOOL shouldTap = [self.delegate menu:self didSelectedMenuButtonAtIndex:tapIndex];
        if (!shouldTap) {
            return;
        }
    }
    for (int i = 0; i < _numOfMenu; i++) {
        if (i != tapIndex) {
            [self animateIndicator:_indicators[i] Forward:NO complete:^{
                int j=i;
                if (isFirstTwo) {
                    j +=1;
                }
                [self animateTitle:_titles[j] show:NO complete:^{
                    
                }];
            }];
        }
    }
    
    if (tapIndex == _currentSelectedMenudIndex && _show) {
        NSInteger j=_currentSelectedMenudIndex;
        if (isFirstTwo) {
            j +=1;
        }
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_leftTableView title:_titles[j] forward:NO complecte:^{
            _currentSelectedMenudIndex = tapIndex;
            _show = NO;
        }];
    } else {
        _currentSelectedMenudIndex = tapIndex;
        if (_show) {
            [_leftTableView setContentOffset:CGPointZero];
            [_rightTableView setContentOffset:CGPointZero];
        }


        [_leftTableView reloadData];
        if (_dataSource && _dataSourceFlags.numberOfItemsInRow) {
            [_rightTableView reloadData];
        }
        NSInteger j=tapIndex;
        if (isFirstTwo) {
            j +=1;
        }
        [self animateIdicator:_indicators[tapIndex] background:_backGroundView tableView:_leftTableView title:_titles[j] forward:YES complecte:^{
            _show = YES;
        }];
    }
}
- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender
{
//    NSInteger j=_currentSelectedMenudIndex;
//    if (isFirstTwo) {
//        j +=1;
//    }
//    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_leftTableView title:_titles[j] forward:NO complecte:^{
//        _show = NO;
//    }];
    [self closeView];
}
- (void)closeView{
    if (_currentSelectedMenudIndex<0) {
        return;
    }
    NSInteger j=_currentSelectedMenudIndex;
    if (isFirstTwo) {
        j +=1;
    }
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_leftTableView title:_titles[j] forward:NO complecte:^{
        _show = NO;
    }];
}
#pragma mark - animation method
- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)())complete {
    if (_currentSelectedMenudIndex >= 0) {
        CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
        CAShapeLayer *indi = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
        indi.position = CGPointMake(title.bounds.size.width/2+title.position.x+5, self.frame.size.height / 2);
    }
  
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim forKey:anim.keyPath];
        [indicator setValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    [CATransaction commit];
    
    if (forward) {
        // 展开
        indicator.strokeColor = _textSelectedColor.CGColor;
    } else {
        // 收缩
        indicator.strokeColor = _textColor.CGColor;
    }
    
    complete();
}

- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete {
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}

- (void)animateTableView:(UITableView *)tableView show:(BOOL)show complete:(void(^)())complete {
    
    BOOL haveItems = NO;
    
    if (_dataSource) {
//        NSInteger num = [_leftTableView numberOfRowsInSection:0];
        
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(menu:itemsExistAtColumn:)]) {
            haveItems = [self.dataSource menu:self itemsExistAtColumn:_currentSelectedMenudIndex];
        }
    }
    BOOL isCustom = NO;
    UIView *temView = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(menu:viewForDropDownMenuAtIndex:)]) {
         temView = [self.dataSource menu:self viewForDropDownMenuAtIndex:_currentSelectedMenudIndex];
    }
    if (temView) {
        isCustom = YES;
    }
    if (show) {
        if (isCustom) {
            if (_customView && _customView.superview) {
//                [_customView removeFromSuperview];
                _customView.hidden = NO;
                _customView.alpha = 1;
                _customView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);

            }else{
                _customView = temView;
//                [self.superview addSubview:_customView];
//                [self.superview bringSubviewToFront:self];
            }
            [self.superview addSubview:_customView];
            [self.superview bringSubviewToFront:self];
            
            if (_customView) {
                _customView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
                CGFloat h = [self.dataSource menu:self heightForDropDownMenuAtIndex:_currentSelectedMenudIndex];
                CGFloat tableViewHeight = h > _tableViewHeight+1 ? _tableViewHeight:h;
  
                if (_leftTableView) {
                    [_leftTableView removeFromSuperview];
                }
                if (_rightTableView) {
                    [_rightTableView removeFromSuperview];
                }
                //            _buttomImageView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, kButtomImageViewHeight);
                //            [self.superview addSubview:_buttomImageView];
                [UIView animateWithDuration:0.2 animations:^{
                    _customView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, tableViewHeight);
                    //                    _buttomImageView.frame = CGRectMake(self.origin.x, CGRectGetMaxY(_customView.frame)-2, self.frame.size.width, kButtomImageViewHeight);
                    
                }];
            }
        }
        else{
            if (haveItems) {
                _leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 0);
                _rightTableView.frame = CGRectMake(self.origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 0);
                [self.superview addSubview:_leftTableView];
                [self.superview addSubview:_rightTableView];
//                NSInteger currentSelectedMenudRow = [_currentSelectRowArray[_currentSelectedMenudIndex] integerValue];
//                if (indexPath.row == currentSelectedMenudRow){

//                }
            } else {
                _leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
                _rightTableView.frame = CGRectMake(self.origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 0);
                [self.superview addSubview:_leftTableView];
                
            }
//            _buttomImageView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, kButtomImageViewHeight);
//            [self.superview addSubview:_buttomImageView];
            
            NSInteger num = [self tableView:_leftTableView numberOfRowsInSection:0];
            CGFloat tableViewHeight = num * kTableViewCellHeight > _tableViewHeight+1 ? _tableViewHeight:num*kTableViewCellHeight+1;
            
            [UIView animateWithDuration:0.2 animations:^{
                if (haveItems) {
                    _leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, tableViewHeight);
                    
                    _rightTableView.frame = CGRectMake(self.origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, tableViewHeight);
                } else {
                    _leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, tableViewHeight);
                }
                if (_customView) {
                    _customView.alpha = 0;
                }
//                            _buttomImageView.frame = CGRectMake(self.origin.x, CGRectGetMaxY(_leftTableView.frame)-2, self.frame.size.width, kButtomImageViewHeight);
            } completion:^(BOOL finished) {
                [_leftTableView reloadData];
                [_rightTableView reloadData];
//                if (haveItems) {
//                    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_firstSelectedRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//                    [_rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_secondSelectedRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//                }else{
//                    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_firstSelectedRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//                    
//                }
            }];
        }

    } else {
        [UIView animateWithDuration:0.2 animations:^{
            if(_customView && isCustom){
//                _customView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
                _customView.alpha = 0;
            }else{
                if (haveItems) {
                    _leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 0);
                    
                    _rightTableView.frame = CGRectMake(self.origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 0);
                } else {
                    _leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
                }
            }
//            _buttomImageView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
        } completion:^(BOOL finished) {
            if(_customView && _customView.superview){
                _customView.hidden = YES;
            }
            if (_rightTableView.superview) {
                [_rightTableView removeFromSuperview];
            }
            [_leftTableView removeFromSuperview];
//            [_buttomImageView removeFromSuperview];
        }];
    }
    if (complete) {
        complete();
    }
}

- (void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(void(^)())complete {
    CGSize size = [self calculateTitleSizeWithString:title.string];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - kTextSpace) ? size.width : self.frame.size.width / _numOfMenu - kTextSpace;
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    if (!show) {
        title.foregroundColor = _textColor.CGColor;
    } else {
        title.foregroundColor = _textSelectedColor.CGColor;
    }
    complete();
}

- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background tableView:(UITableView *)tableView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)())complete{
    [self animateTitle:title show:forward complete:^{
        [self animateIndicator:indicator Forward:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateTableView:tableView show:forward complete:^{
                }];
            }];
        }];
    }];
    
    complete();
}

#pragma mark - table datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSAssert(_dataSource != nil, @"menu's dataSource shouldn't be nil");
    if (_leftTableView == tableView) {
        if (_dataSourceFlags.numberOfRowsInColumn) {
            return [_dataSource menu:self
                numberOfRowsInColumn:_currentSelectedMenudIndex];
        } else {
            //NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
            return 0;
        }
    } else {
        if (_dataSourceFlags.numberOfItemsInRow) {
            NSInteger currentSelectedMenudRow = [_currentSelectRowArray[_currentSelectedMenudIndex] integerValue];
            return [_dataSource menu:self
                  numberOfItemsInRow:currentSelectedMenudRow column:_currentSelectedMenudIndex];
        } else {
            //NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = SStringEmpty;
    if (tableView == _leftTableView) {
        _cellStyle = UITableViewCellStyleValue1;
        identifier = @"DropDownMenuCell1";
    }else{
        _cellStyle = UITableViewCellStyleValue2;
        identifier = @"DropDownMenuCell2";
    }
    
    UISubTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UISubTitleCell alloc] initWithStyle:_cellStyle reuseIdentifier:identifier];
        //cell.separatorInset = UIEdgeInsetsZero;
        UIView *bg = [[UIView alloc]init];
        bg.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = bg;
        cell.textLabel.highlightedTextColor = _textSelectedColor;
        cell.textLabel.textColor = _textColor;
        cell.textLabel.font = [WBJUIFont lightFontWithSize:_fontSize];
        if (_dataSourceFlags.detailTextForRowAtIndexPath || _dataSourceFlags.detailTextForItemsInRowAtIndexPath) {
            cell.detailTextLabel.textColor = _detailTextColor;
            cell.detailTextLabel.font = _detailTextFont;
        }
        cell.imageWidthDec = kTableViewCellHeight - cell.textLabel.font.lineHeight;//图标高度20
//        cell.imageView.image = [[UIImage imageNamed:@"orange_cellSelected"] transformWidth:15 Height:10 Scale:1];

    }
    //NSAssert(_dataSource != nil, @"menu's datasource shouldn't be nil");
    if (tableView == _leftTableView) {
        cell.backgroundColor = kCellBgColor;
        DOPIndexPath *path = _selectedIndexPathAry[_currentSelectedMenudIndex];
        if (indexPath.row == path.row) {
            cell.textLabel.textColor = _textSelectedColor;
            cell.backgroundColor = [UIColor whiteColor];
        }else
            cell.textLabel.textColor = _textColor;

        if (_dataSourceFlags.titleForRowAtIndexPath) {
            cell.textLabel.text = [_dataSource menu:self titleForRowAtIndexPath:[DOPIndexPath indexPathWithCol:_currentSelectedMenudIndex row:indexPath.row]];
            if (indexPath.row == path.row) {
                if (_dataSourceFlags.imageSelectedNameForRowAtIndexPath) {
                    NSString *imageName = [_dataSource menu:self imageSelectedNameForRowAtIndexPath:[DOPIndexPath indexPathWithCol:_currentSelectedMenudIndex row:indexPath.row]];
                    if (imageName && imageName.length > 0) {
//                        [cell.imageView setImageWithOssKey:imageName placeholderImage:[UIImage imageNamed:@"friendscircle_default"]];
                        cell.imageView.image = [UIImage imageNamed:imageName];
//                        cell.imageView.frame = CGRectMake(10, 10, 20, 10);
//                        [cell.imageView setImageviewTheImageWithUrl:imageName defaultImage:BusinessDefaultImage];
                    }else {
                        cell.imageView.image = nil;
                    }
                    
                }else {
                    cell.imageView.image = nil;
                }
            }else{
                if (_dataSourceFlags.imageNameForRowAtIndexPath) {
                    NSString *imageName = [_dataSource menu:self imageNameForRowAtIndexPath:[DOPIndexPath indexPathWithCol:_currentSelectedMenudIndex row:indexPath.row]];
                    if (imageName && imageName.length > 0) {
//                        [cell.imageView setImageWithOssKey:imageName placeholderImage:[UIImage imageNamed:@"friendscircle_default"]];
//                        cell.imageView.image = [UIImage imageNamed:@"friendscircle_default"];
//                        [cell.imageView setImageviewTheImageWithUrl:imageName defaultImage:BusinessDefaultImage];

                    }else {
                        cell.imageView.image = nil;
                    }
                    
                }else {
                    cell.imageView.image = nil;
                }
                
            }
            
            if (_dataSourceFlags.detailTextForRowAtIndexPath) {
                NSString *detailText = [_dataSource menu:self detailTextForRowAtIndexPath:[DOPIndexPath indexPathWithCol:_currentSelectedMenudIndex row:indexPath.row]];
                cell.detailTextLabel.text = detailText;
            }else {
                cell.detailTextLabel.text = nil;
            }
            
        } else {
            //NSAssert(0 == 1, @"dataSource method needs to be implemented");
        }
        
        
        
//        if (_dataSourceFlags.numberOfItemsInRow && [_dataSource menu:self numberOfItemsInRow:indexPath.row column:_currentSelectedMenudIndex]> 0){
//            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_chose_arrow_nor"] highlightedImage:[UIImage imageNamed:@"icon_chose_arrow_sel"]];
//        } else {
//            cell.accessoryView = nil;
//        }
        
        
    } else {
        DOPIndexPath *path = _selectedIndexPathAry[_currentSelectedMenudIndex];

        if(path.item == indexPath.row){
//            cell.imageView.image = [[UIImage imageNamed:@"orange_cellSelected"] transformWidth:15 Height:10 Scale:1];
            cell.textLabel.textColor =  _textSelectedColor;
        }else{
            cell.imageView.image = nil;
            cell.textLabel.textColor =  _textColor;

        }
        if (_dataSourceFlags.titleForItemsInRowAtIndexPath) {
            NSInteger currentSelectedMenudRow = [_currentSelectRowArray[_currentSelectedMenudIndex] integerValue];
            cell.textLabel.text = [_dataSource menu:self titleForItemsInRowAtIndexPath:[DOPIndexPath indexPathWithCol:_currentSelectedMenudIndex row:currentSelectedMenudRow item:indexPath.row]];
            
            if (_dataSourceFlags.imageNameForItemsInRowAtIndexPath) {
                NSString *imageName = [_dataSource menu:self imageNameForItemsInRowAtIndexPath:[DOPIndexPath indexPathWithCol:_currentSelectedMenudIndex row:currentSelectedMenudRow item:indexPath.row]];
                
                if (imageName && imageName.length > 0) {
                    cell.imageView.image = [UIImage imageWithResNamed:imageName];
                }else {
                    cell.imageView.image = nil;
                }
            }else {
                cell.imageView.image = nil;
            }
            
            if (_dataSourceFlags.detailTextForItemsInRowAtIndexPath) {
                NSString *detailText = [_dataSource menu:self detailTextForItemsInRowAtIndexPath:[DOPIndexPath indexPathWithCol:_currentSelectedMenudIndex row:currentSelectedMenudRow item:indexPath.row]];
                cell.detailTextLabel.text = detailText;
            }else {
                cell.detailTextLabel.text = nil;
            }
            
        } else {
            //NSAssert(0 == 1, @"dataSource method needs to be implemented");
        }
//        NSInteger j=_currentSelectedMenudIndex;
//        if (isFirstTwo) {
//            j +=1;
//        }
//        if ([cell.textLabel.text isEqualToString:[(CATextLayer *)[_titles objectAtIndex:j] string]]) {
//            NSInteger currentSelectedMenudRow = [_currentSelectRowArray[_currentSelectedMenudIndex] integerValue];
//            [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentSelectedMenudRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//            [_rightTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryView = nil;
//        cell.imageView.size = CGSizeMake(13, 9);
    }
    
    return cell;
}

#pragma mark - tableview delegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [_delegate respondsToSelector:@selector(menu:willSelectRowAtIndexPath:)]) {
        return [self.delegate menu:self willSelectRowAtIndexPath:[DOPIndexPath indexPathWithCol:_currentSelectedMenudIndex row:indexPath.row]];
    } else {
        //TODO: delegate is nil
        return indexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (_leftTableView == tableView) {
        DOPIndexPath *path = _selectedIndexPathAry[_currentSelectedMenudIndex];
        NSInteger selectedRow = path.row;
        if(selectedRow == indexPath.row){
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            DOPIndexPath *path = _selectedIndexPathAry[_currentSelectedMenudIndex];
            NSInteger selectedRow = path.row;
            path.row = indexPath.row;
            path.item = 0;

            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedRow inSection:0],[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }

        BOOL haveItem = [self confiMenuWithSelectRow:indexPath.row];
        BOOL isClickHaveItemValid = self.isClickHaveItemValid ? YES : haveItem;
        
        if (isClickHaveItemValid && _delegate && [_delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
            [self.delegate menu:self didSelectRowAtIndexPath:[DOPIndexPath indexPathWithCol:_currentSelectedMenudIndex row:indexPath.row]];
        } else {
            //TODO: delegate is nil
        }
    } else {
        DOPIndexPath *path = _selectedIndexPathAry[_currentSelectedMenudIndex];
        NSInteger selectedRow = path.item;
        path.item = indexPath.row;
        if(path.item == indexPath.row){
//            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_secondSelectedRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }else{
             path.item = indexPath.row;
             [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedRow inSection:0],[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        [self confiMenuWithSelectItem:indexPath.item];
        if (self.delegate && [_delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
            NSInteger currentSelectedMenudRow = [_currentSelectRowArray[_currentSelectedMenudIndex] integerValue];
            [self.delegate menu:self didSelectRowAtIndexPath:[DOPIndexPath indexPathWithCol:_currentSelectedMenudIndex row:currentSelectedMenudRow item:indexPath.row]];
        } else {
            //TODO: delegate is nil
            
        }
    }
}

- (BOOL )confiMenuWithSelectRow:(NSInteger)row {
    
    _currentSelectRowArray[_currentSelectedMenudIndex] = @(row);
    
    NSInteger j=_currentSelectedMenudIndex;
    if (isFirstTwo) {
        j +=1;
    }
    CATextLayer *title = (CATextLayer *)_titles[j];
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(menu:itemsExistAtColumn:row:)] && [self.dataSource menu:self itemsExistAtColumn:_currentSelectedMenudIndex row:row]) {
        
        // 有双列表 有item数据
        if (self.isClickHaveItemValid) {
//            title.string = [_dataSource menu:self titleForMenuClickAtIndexPath:[DOPIndexPath indexPathWithCol:_currentSelectedMenudIndex row:row]];
//            [self animateTitle:title show:YES complete:^{
//                ((CAShapeLayer *)_indicators[_currentSelectedMenudIndex]).position = CGPointMake(title.bounds.size.width/2+title.position.x+5, self.frame.size.height / 2);
                [_rightTableView reloadData];
//            }];
        } else {
            [_rightTableView reloadData];
        }
        return NO;
        
    } else {
        
        title.string = [_dataSource menu:self titleForMenuClickAtIndexPath:
                        [DOPIndexPath indexPathWithCol:_currentSelectedMenudIndex row:self.isRemainMenuTitle ? 0 : row]];
        
        NSInteger j=_currentSelectedMenudIndex;
        if (isFirstTwo) {
            j +=1;
        }
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_leftTableView title:_titles[j] forward:NO complecte:^{
            _show = NO;
        }];
        return YES;
    }
}
- (void)confiMenuWithSelectItem:(NSInteger)item {
    NSInteger j=_currentSelectedMenudIndex;
    if (isFirstTwo) {
        j +=1;
    }
    CATextLayer *title = (CATextLayer *)_titles[j];
    NSInteger currentSelectedMenudRow = [_currentSelectRowArray[_currentSelectedMenudIndex] integerValue];
    title.string = [_dataSource menu:self titleForMenuClickAtIndexPath:[DOPIndexPath indexPathWithCol:_currentSelectedMenudIndex row:currentSelectedMenudRow item:item]];
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_leftTableView title:_titles[j] forward:NO complecte:^{
//        ((CAShapeLayer *)_indicators[_currentSelectedMenudIndex]).position = CGPointMake(title.bounds.size.width/2+title.position.x+5, self.frame.size.height / 2);
        _show = NO;
    }];
    
}

- (void)setMenuTitle:(NSString *)title colum:(int)colum show:(BOOL)show{
    if (_titles.count > colum) {
        CATextLayer *tLayer = _titles[colum];
        tLayer.string = title;
        [self animateTitle:tLayer show:show complete:^{
            CATextLayer *title = (CATextLayer *)_titles[colum];
            CAShapeLayer *indi = (CAShapeLayer *)_indicators[colum];
            indi.position = CGPointMake(title.bounds.size.width/2+title.position.x+5, self.frame.size.height / 2);
        }];
    }
}
@end

