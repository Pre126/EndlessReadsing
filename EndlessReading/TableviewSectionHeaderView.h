//
//  TableviewSectionHeaderView.h
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 16/1/25.
//  Copyright © 2016年 Satinno. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableviewSectionHeaderViewDelegate <NSObject>

- (void)tableviewSectionHeaderViewClicked:(NSInteger)index;

@end

@interface TableviewSectionHeaderView : UIView
{
    __weak IBOutlet UIImageView *_headerImageView;
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UIImageView *_expoleImageView;
}

@property (nonatomic, weak)id<TableviewSectionHeaderViewDelegate> delegate;

- (void)setupTableviewSectionHeaderView:(NSDictionary *)dict;

@end
