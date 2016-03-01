//
//  SearchTableViewCell.h
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 15/12/29.
//  Copyright © 2015年 Satinno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell
{
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_authorLabel;
    __weak IBOutlet UILabel *_readNumberLabel;
    __weak IBOutlet UILabel *_desLabel;
}

- (void)setupSearchTableViewCell:(NSDictionary*)dict;

@end
