//
//  CycleImageCell.m
//  iPolice
//
//  Created by 杨阳 on 15/9/5.
//  Copyright (c) 2015年 yangyang. All rights reserved.
//

#import "CycleImageCell.h"
//#import "UIImageView+WebCache.h"


#define CycleImageCellIdentifier @"CycleImageCell"

@interface CycleImageCell()
@end

@implementation CycleImageCell
-(id)initWithFrame:(CGRect)frame
{
    if ( self == [super initWithFrame:frame])
    {
        [self makeUI];
    }
    return self;
}

-(void)makeUI
{
    self.backgroundColor = [UIColor clearColor];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.imageView];
    
    self.title = [UILabel new];
    self.title.frame = CGRectMake(10, self.frame.size.height - 50, self.frame.size.width - 50, 20);
    self.title.textColor = [UIColor whiteColor];
    self.title.font = [UIFont systemFontOfSize:15];
    self.title.textAlignment = NSTextAlignmentLeft;
    //设置文字折行方式
    self.title.lineBreakMode = NSLineBreakByWordWrapping;
    self.title.numberOfLines = 2;
    [self.imageView addSubview:self.title];
}

- (void)setPlaceHolderImageName:(NSString *)placeHolderImageName
{
    _placeHolderImageName = placeHolderImageName;
}

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    //一句话, 自动实现了异步下载. 图片本地缓存. 网络下载. 自动设置占位符.
    [self.imageView setImageWithURL:self.imageURL placeholder:[UIImage imageNamed:_placeHolderImageName]];
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    [self.imageView setImage:[UIImage imageNamed:imageName]];
}

- (void)setTitleName:(NSString *)titleName {
    _titleName = titleName;
    self.title.text = titleName;
}

//+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
//{
//    [collectionView registerClass:[CycleImageCell class] forCellWithReuseIdentifier:CycleImageCellIdentifier];
//    CycleImageCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CycleImageCellIdentifier forIndexPath:indexPath];
//    
//    return cell;
//}

@end
