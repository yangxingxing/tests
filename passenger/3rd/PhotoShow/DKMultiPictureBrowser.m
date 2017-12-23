//
//  DKMultiPictureBrowser.m
//  DKMultiPictureBrowser
//
//  Created by 李大宽 on 2017/3/14.
//  Copyright © 2017年 李大宽. All rights reserved.
//

#import "DKMultiPictureBrowser.h"
#import "DKPictureCell.h"
//#import <ReactiveObjC.h>

@interface DKMultiPictureBrowser () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate> {
    UILabelCustom *_indexLab;
    BOOL _isLayout;
    SystemAuthority *_authoRity;
}

/** 源数组转接为字典 */
@property(nonatomic, strong) NSMutableDictionary *dictionary;

@property(nonatomic, strong) UICollectionView *collectionView;
/** 最终得到的数组 */
@property(nonatomic, strong) NSMutableArray *totalArr;

@end

@implementation DKMultiPictureBrowser

- (void)loadView {
    [super loadView];
    self.totalArr = [NSMutableArray array].mutableCopy;
    self.dictionary = [NSMutableDictionary dictionary].mutableCopy;
    // 数组中的数据转接到字典中
    int count = 0;
    for (id obj in self.pictureArray) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = obj;
            if ([(NSDictionary *)dic containsObjectForKey:@"img"]) {
                [self.dictionary setObject:UrlWithIconStr(dic[@"img"]) forKey:[NSString stringWithFormat:@"%d", count]];
            } else if ([(NSDictionary *)dic containsObjectForKey:@"image"]) {
                [self.dictionary setObject:UrlWithIconStr(dic[@"image"]) forKey:[NSString stringWithFormat:@"%d", count]];
            }
            
        } else if ([obj isKindOfClass:[NSString class]]) {
            NSString *url = obj;
            [self.dictionary setObject:UrlWithIconStr(url) forKey:[NSString stringWithFormat:@"%d", count]];
        }
        count++;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    if (self.pictureArray) {
        [self startDownloadPicWithArray:self.pictureArray];
    } else {
        self.totalArr = self.imageArray.mutableCopy;
    }
    
    // 点击退出
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    [self.collectionView addGestureRecognizer:tap];
    // 长按手势
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressAction:)];
    [self.collectionView addGestureRecognizer:longpress];
    
    _indexLab = [MyTools createLabelWithFrame:CGRectMake(0, SCREENH - 150, SCREENW, 40) text:@"0/0" textColor:textWhiteColor font:17.0];
    [self setIndexLabel:_selectedIndex];
    [self setStartLoction];
    [self.view addSubview:_indexLab];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActiveEnterForegroundChange) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)becomeActiveEnterForegroundChange {
    self.navigationController.navigationBar.alpha = 0;
    self.view.frame = CGRectMake(0, 0, SCREENW, SCREENH);
    //    self.collectionView.frame = CGRectMake(0, 0, SCREENW, SCREENH);
}

- (void)setIndexLabel:(NSInteger)index {
    _indexLab.text = [NSString stringWithFormat:@"%ld/%lu",(long)index+1,(unsigned long)_pictureArray.count > 0 ? _pictureArray.count : _imageArray.count];
    
}

- (void)setStartLoction {
    dispatch_main_async(^{
        self.collectionView.contentOffset = CGPointMake(_selectedIndex*SCREENW, 0);
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha = 0;
    
    
    //       self.collectionView.contentOffset = CGPointMake(_selectedIndex*SCREENW, 0);
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    if (!_isLayout) {
//        self.collectionView.contentOffset = CGPointMake(_selectedIndex*SCREENW, 0);
//    }
//    _isLayout = YES;
//}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)longpressAction:(UILongPressGestureRecognizer *)longpress {
    // 弹出保存图片的警告框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *saveBtn = [UIAlertAction actionWithTitle:@"保存到本地" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        _authoRity = [SystemAuthority new];
        if (![_authoRity PhotoLibraryAuthority]) return;
        // 获取图片
        NSInteger num = (NSInteger)(self.collectionView.contentOffset.x / self.view.bounds.size.width);
        UIImage *image = self.totalArr[num];
        //保存完后调用的方法
        SEL selector = @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:);
        //保存
        UIImageWriteToSavedPhotosAlbum(image, self, selector, NULL);
    }];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertController addAction:saveBtn];
    [alertController addAction:cancelBtn];
    [self presentViewController:alertController animated:YES completion:nil];
}

#warning 保存图片完成后, 在下面写成功或者失败的代码!!!!
//图片保存完后调用的方法
- (void) onCompleteCapture:(UIImage *)screenImage didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error){
        //保存失败
        [BusinessShowInfoView showInfo:@"保存失败"];
    }else {
        //保存成功
        [BusinessShowInfoView showInfo:@"保存成功"];
    }
}

#pragma mark- 图片下载
- (void)startDownloadPicWithArray:(NSArray *)array {
    // 源数组转接为字典类型
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary].mutableCopy;
    [self.dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [tempDic setObject:obj forKey:key];
            [weakSelf.dictionary removeObjectForKey:key];
        }
    }];
    // 开始加载数据
    __block NSInteger count = tempDic.count; // 计算进入网络请求的次数
    [tempDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1); // 创建信号
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // 信号等待
        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:obj] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_semaphore_signal(semaphore); // 信号 +1
            count--;
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    [tempDic setObject:image forKey:key];
                } else {
                    [tempDic setObject:DefalutImage forKey:key];
                }
                if (count == 0) {
                    // 所有图片下载完毕, 合并字典
                    [self.dictionary setDictionary:tempDic];
                    // 开始展示图片!
                    [self showPic];
                }
            } else {
                // 图片加载失败, 可以放一张默认图片上去
                [tempDic setObject:DefalutImage forKey:key];
                [self.dictionary setDictionary:tempDic];
                // 开始展示图片!
                [self showPic];
            }
        }] resume];
    }];
}

// 展示图片
- (void)showPic {
    // 数组排序
    NSArray *tempArr = [[self.dictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    for (NSString *str in tempArr) {
        [self.totalArr addObject:[self.dictionary objectForKey:str]];
    }
    // reloadData
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

#pragma mark- collectionView 代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.totalArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DKPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dkpiccell" forIndexPath:indexPath];
    [cell setPicWithImage:self.totalArr[indexPath.row]];
    return cell;
}

#pragma mark- 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 10, [UIScreen mainScreen].bounds.size.height);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[DKPictureCell class] forCellWithReuseIdentifier:@"dkpiccell"];
    }
    return _collectionView;
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    if (_isLayout) {
    //        NSInteger num = (NSInteger)(scrollView.contentOffset.x / SCREENW);
    //        if (num != _selectedIndex) {
    //            _selectedIndex = num;
    //            [self setIndexLabel:_selectedIndex];
    //        }
    //    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSInteger num = (NSInteger)(scrollView.contentOffset.x / SCREENW);
    if (num != _selectedIndex) {
        _selectedIndex = num;
        [self setIndexLabel:_selectedIndex];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSInteger num = (NSInteger)(scrollView.contentOffset.x / SCREENW);
    if (num != _selectedIndex) {
        _selectedIndex = num;
        [self setIndexLabel:_selectedIndex];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger num = (NSInteger)(scrollView.contentOffset.x / SCREENW);
    if (num != _selectedIndex) {
        _selectedIndex = num;
        [self setIndexLabel:_selectedIndex];
    }
}

@end
