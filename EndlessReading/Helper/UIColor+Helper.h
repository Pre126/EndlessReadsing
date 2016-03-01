//
//  UIColor+Helper.h
//  TubeMogul
//
//  Created by Xiaodiao.Deng on 15/12/15.
//  Copyright © 2015年 Satinno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Helper)

+ (UIColor *) colorWithHexString: (NSString *) hexString;

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;

@end
