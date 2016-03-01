//
//  CharTableViewCell.m
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 16/1/26.
//  Copyright © 2016年 Satinno. All rights reserved.
//

#import "CharTableViewCell.h"

@implementation CharTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCharTableViewCell:(NSDictionary*)dict isCurrent:(BOOL)current{
    _titleLabel.text = [NSString stringWithFormat:@"%@ %@", [[dict objectForKey:@"order_id"] description], [dict objectForKey:@"chapter_title"]];
    if (current) {
        _imageView.image = [UIImage imageNamed:@"read_chart_current.png"];
    }
    else{
        _imageView.image = [UIImage imageNamed:@"read_chart.png"];
    }
}

@end
