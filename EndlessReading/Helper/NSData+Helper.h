//
//  NSData+Helper.h
//  TubeMogul
//
//  Created by Xiaodiao.Deng on 15/12/15.
//  Copyright © 2015年 Satinno. All rights reserved.
//

@interface NSData (Helper)

+ (id)dataWithBase64EncodedString:(NSString *)string;     //  Padding '=' characters are optional. Whitespace is ignored.
- (NSString *)base64Encoding;

@end

