//
//  NSString+Helper.m
//  TubeMogul
//
//  Created by Xiaodiao.Deng on 15/12/17.
//  Copyright © 2015年 Satinno. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

+ (NSString*)saveFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
    
    BOOL isDirectory = YES;
    
    NSString *saveFilePath = [documentsDirectory stringByAppendingPathComponent:@"saveFile"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:saveFilePath isDirectory:&isDirectory]) {
        if (!isDirectory) {
            if (![[NSFileManager defaultManager] createDirectoryAtPath:saveFilePath
                                           withIntermediateDirectories:YES
                                                            attributes:nil
                                                                 error:nil])
            {
                // Handle the error.
            }
        }
    }
    else{
        if (![[NSFileManager defaultManager] createDirectoryAtPath:saveFilePath
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:nil])
        {
            // Handle the error.
        }
    }
    
    return saveFilePath;
}

-(BOOL)isValidEmail
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end
