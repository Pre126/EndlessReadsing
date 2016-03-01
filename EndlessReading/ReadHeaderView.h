//
//  ReadHeaderView.h
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 16/1/6.
//  Copyright © 2016年 Satinno. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReadHeaderViewDelegate <NSObject>

- (void)backButtonClicked;

@end

@interface ReadHeaderView : UIView
{
    __weak IBOutlet UILabel *_titleLabel;
}

@property (nonatomic, weak)id<ReadHeaderViewDelegate> delegate;


- (void)setTitle:(NSString *)title;

- (IBAction)backButtonClicked:(id)sender;

@end
