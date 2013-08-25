//
//  UIImage+iPhone5.m
//  CustomControlDemo
//
//  Created by ligf on 13-3-4.
//  Copyright (c) 2013年 用友软件股份有限公司. All rights reserved.
//

#import "UIImage+iPhone5.h"

@implementation UIImage (iPhone5)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

+ (UIImage *)imageNamedWithiPhone5:(NSString *)name imageTyped:(NSString *)type
{
    NSString *imgName = nil;
    if ([type length]==0)
    {
        type = @"png";
    }
    else
    {
        type = type;
    }
    if (iPhone5)
    {
        imgName = [NSString stringWithFormat:@"%@-ip5",name];
    }
    else
    {
        imgName = name;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:type];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    return image;
}

@end
