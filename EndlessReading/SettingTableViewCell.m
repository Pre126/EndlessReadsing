//
//  SettingTableViewCell.m
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 15/12/28.
//  Copyright © 2015年 Satinno. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupSettingTableViewCell:(NSDictionary*)dict{
    _imageView.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
    _titleLabel.text = [dict objectForKey:@"title"];
}

@end
