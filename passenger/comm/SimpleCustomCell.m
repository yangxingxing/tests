//
//  SimpleCustomCell.m
//  114SD
//
//  Created by 杨星星 on 2017/4/7.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "SimpleCustomCell.h"

@interface SimpleCustomCell ()



@end

@implementation SimpleCustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_iconImageView];
    
    _customImageView = [UIImageView new];
    _customImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_customImageView];
    
    _customTextLabel = [UILabel new];
    [self.contentView addSubview:_customTextLabel];
    
    _customDetailTextLabel = [UILabel new];
    _customDetailTextLabel.textAlignment = NSTextAlignmentRight;
    _customDetailTextLabel.font = FontSize(15);
    [self.contentView addSubview:_customDetailTextLabel];
    
    _simpleBtn = [UIButtonCustom buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_simpleBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = _iconImageView.frame;
    if (_iconImageView.x < 10) {
        rect.origin.x = UITableViewCellCustomLeftX;
    }
    
    _iconImageView.frame = rect;
    
    rect = _customTextLabel.frame;
    rect.origin.x = rect.origin.x > 0 ? rect.origin.x : (_iconImageView.image && _iconImageView.x < SCREENW/2) ? CGRectGetMaxX(_iconImageView.frame) + UITableViewCellCustomLeftX : UITableViewCellCustomLeftX;
    rect.size.height = self.height;
    rect.size.width = self.width - (_iconImageView.x < SCREENW/2 ? CGRectGetMaxX(_iconImageView.frame) : 0) - 2 * UITableViewCellCustomLeftX;
    _customTextLabel.frame = rect;
    _simpleBtn.centerY = _customDetailTextLabel.centerY = _customTextLabel.centerY = _iconImageView.centerY = self.height/2;
}

@end
