//
//  UseCarTypeCell.m
//  passenger
//
//  Created by 杨星星 on 2017/12/18.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "UseCarTypeCell.h"

@interface UseCarTypeCell() {
    UILabel *_titleLabel,*_descpritLabel;
    UIView *_backView;
    
    UIImageView *_selectedImageView;
}

@end

@implementation UseCarTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, SCREENW - 20, 100)];
    backView.backgroundColor = textWhiteColor;
    _backView = backView;
    [self.contentView addSubview:backView];
    [backView setLayerShadow:textGrayColorPass offset:CGSizeMake(0, 0.4) radius:0.5];
    
    _titleLabel = [MyTools createLabelWithFrame:CGRectMake(10, 10, backView.width - 20, 20) text:nil textColor:textBlackColorPass font:17];
    [backView addSubview:_titleLabel];
    
    _descpritLabel = [MyTools createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame) + 10, backView.width - 10 - 35, 20) text:nil textColor:textLightGrayColorPass font:13];
    _descpritLabel.numberOfLines = 0;
    _descpritLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [backView addSubview:_descpritLabel];
    
    _descpritLabel.textAlignment = _titleLabel.textAlignment = NSTextAlignmentLeft;
    
    _selectedImageView = [MyTools createImageViewWithFrame:CGRectMake(backView.width - 10 - 12, 0, 12, 12) imageName:@"select_icon_popupwindow"];
    [backView addSubview:_selectedImageView];
}

- (void)setModel:(UseCarTypeModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    _descpritLabel.text = model.detail;
    _descpritLabel.height = model.height;
    _selectedImageView.hidden = YES;
    if (model.selected) {
        _selectedImageView.hidden = NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _selectedImageView.centerY = self.height/2;
    _backView.height = _model.height + 50;
}

@end
