//
//  UISubTitleCell.m
//  wBaiJu
//
//  Created by Mac on 16/5/16.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "UISubTitleCell.h"

@implementation UISubTitleCell
{
    UITableViewCellStyle _style;
    UITableViewCellMyStyle _myStyle;
    float _leftWidth;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _style = style;
        self.separatorAlign = SeparatorAlignLeft;
    }
    return self;
}
-(instancetype)initWithMyStyle:(UITableViewCellMyStyle)style reuseIdentifier:(NSString *)reuseIdentifier leftWidth:(float)leftWidth{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        _myStyle = style;
        self.separatorAlign = SeparatorAlignLeft;
        self.detailTextLabel.textColor = self.textLabel.textColor;
        _leftWidth = leftWidth;
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (_myStyle == UITableViewCellMyStyle1) {
        self.textLabel.width = _leftWidth;
        self.detailTextLabel.x = CGRectGetMaxX(self.textLabel.frame);
        self.detailTextLabel.width = self.width - self.detailTextLabel.x - UITableViewCellCustomLeftX;
        self.detailTextLabel.font = self.textLabel.font;
        self.detailTextLabel.centerY = self.textLabel.centerY;
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    }else if (_style == UITableViewCellStyleValue1) {//detailLab水平紧挨textLab
        [self.detailTextLabel sizeToFit];
        self.detailTextLabel.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame), self.textLabel.frame.origin.y+self.textLabel.frame.size.height/2-self.detailTextLabel.frame.size.height/2, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
    }else if (_style == UITableViewCellStyleValue2){//detailLab靠右
        [self.detailTextLabel sizeToFit];
        [self.textLabel sizeToFit];
        self.textLabel.frame = CGRectMake(self.textLabel.x, self.frame.size.height/2-self.textLabel.frame.size.height/2, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
        self.detailTextLabel.frame = CGRectMake(self.frame.size.width-self.detailTextLabel.frame.size.width-UITableViewCellCustomLeftX - 20, self.textLabel.frame.origin.y+self.textLabel.frame.size.height/2-self.detailTextLabel.frame.size.height/2, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
    }
}

@end
