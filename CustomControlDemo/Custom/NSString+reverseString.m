//
//  NSString+reverseString.m
//  ShareDemo
//
//  Created by ligf on 13-2-28.
//  Copyright (c) 2013年 ligf. All rights reserved.
//

#import "NSString+reverseString.h"

@implementation NSString (reverseString)

- (NSString *)reverseString
{
    NSInteger len = [self length];
    
    NSMutableString *retString = [NSMutableString stringWithCapacity:len];
    
    while (len > 0)
    {
        unichar c = [self characterAtIndex:--len];
        [retString appendFormat:@"%C",c];
    }
    
    return retString;
}

@end
