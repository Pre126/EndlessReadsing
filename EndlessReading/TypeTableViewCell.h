//
//  TypeTableViewCell.h
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 16/1/25.
//  Copyright © 2016年 Satinno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeTableViewCell : UITableViewCell
{
    __weak IBOutlet UILabel *_titleLabel;
    
}

- (void)setupTypeTableViewCell:(NSDictionary *)dict;
@end
