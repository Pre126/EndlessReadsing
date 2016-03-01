//
//  TableviewSectionHeaderView.m
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 16/1/25.
//  Copyright © 2016年 Satinno. All rights reserved.
//

#import "TableviewSectionHeaderView.h"

@implementation TableviewSectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupTableviewSectionHeaderView:(NSDictionary *)dict{
    _headerImageView.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
    _titleLabel.text = [dict objectForKey:@"title"];
    
    if ([[dict objectForKey:@"export"] boolValue]) {
        _expoleImageView.image = [UIImage imageNamed:@"icon_up.png"];
    }
    else{
        _expoleImageView.image = [UIImage imageNamed:@"icon_down.png"];
    }
}

- (IBAction)buttonClicked:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(tableviewSectionHeaderViewClicked:)]) {
        [_delegate tableviewSectionHeaderViewClicked:self.tag];
    }
}

@end
