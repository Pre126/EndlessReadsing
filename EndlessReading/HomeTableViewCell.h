//
//  HomeTableViewCell.h
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 15/12/28.
//  Copyright © 2015年 Satinno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
{
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_desLabel;
    __weak IBOutlet UIImageView *_dotImageView;
    
}
- (void)setupHomeTableViewCell:(NSDictionary*)dict HaveUpdate:(BOOL)haveUpdate;

@end
