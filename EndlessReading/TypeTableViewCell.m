//
//  TypeTableViewCell.m
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 16/1/25.
//  Copyright © 2016年 Satinno. All rights reserved.
//

#import "TypeTableViewCell.h"

@implementation TypeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupTypeTableViewCell:(NSDictionary *)dict{
    if ([dict objectForKey:@"catalog_name"]) {
        _titleLabel.text = [dict objectForKey:@"catalog_name"];
    }
    else{
        _titleLabel.text = [dict objectForKey:@"chart_name"];
    }
}

@end
