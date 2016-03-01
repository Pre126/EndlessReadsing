
//
//  ReadHeaderView.m
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 16/1/6.
//  Copyright © 2016年 Satinno. All rights reserved.
//

#import "ReadHeaderView.h"

@implementation ReadHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setTitle:(NSString *)title{
    _titleLabel.text = title;
}

- (IBAction)backButtonClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(backButtonClicked)]) {
        [_delegate backButtonClicked];
    }
}

@end
