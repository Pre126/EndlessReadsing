//
//  HomeTableViewCell.m
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 15/12/28.
//  Copyright © 2015年 Satinno. All rights reserved.
//

#import "HomeTableViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation HomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupHomeTableViewCell:(NSDictionary*)dict HaveUpdate:(BOOL)haveUpdate{
    _dotImageView.hidden = !haveUpdate;
    
    NSString *imagePath = [dict objectForKey:@"book_img"];
    [_imageView setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil];
    
    _titleLabel.text = [dict objectForKey:@"book_name"];
    _desLabel.text = [dict objectForKey:@"description"];
}

@end
