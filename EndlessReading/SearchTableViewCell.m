//
//  SearchTableViewCell.m
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 15/12/29.
//  Copyright © 2015年 Satinno. All rights reserved.
//

#import "SearchTableViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation SearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupSearchTableViewCell:(NSDictionary*)dict{
    NSString *imagePath = [dict objectForKey:@"book_img"];
    [_imageView setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil];
    
    _nameLabel.text = [dict objectForKey:@"book_name"];
    _authorLabel.text = [NSString stringWithFormat:@"%@ | %@", [dict objectForKey:@"zuozhe"], [dict objectForKey:@"catalog_name"]];
    _readNumberLabel.text = [NSString stringWithFormat:@"%@人在读", [dict objectForKey:@"bookclick"]];
    _desLabel.text = [dict objectForKey:@"description"];
}

@end
