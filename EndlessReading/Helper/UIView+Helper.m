//
//  UIView+Helper.m
//  TubeMogul
//
//  Created by Xiaodiao.Deng on 15/12/15.
//  Copyright © 2015年 Satinno. All rights reserved.
//

#import "UIView+Helper.h"

@implementation UIView (Helper)

- (void)cornerRadius:(CGFloat)radius{
    self.clipsToBounds = YES;
    
    self.layer.cornerRadius = radius;
}

- (void)cornerRadius:(CGFloat)radius BorderWidth:(CGFloat)borderWidth BorderColor:(UIColor*)borderColor{
    self.clipsToBounds = YES;
    
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.cornerRadius = radius;
}

@end
