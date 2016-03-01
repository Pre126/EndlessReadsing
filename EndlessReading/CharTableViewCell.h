//
//  CharTableViewCell.h
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 16/1/26.
//  Copyright © 2016年 Satinno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharTableViewCell : UITableViewCell
{
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *_titleLabel;
}

- (void)setupCharTableViewCell:(NSDictionary*)dict isCurrent:(BOOL)current;

@end
