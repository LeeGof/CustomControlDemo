//
//  ProgressViewController.h
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-23.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProgressView;
@interface ProgressViewController : UIViewController
{
    ProgressView                *_progressView;
}

@property (nonatomic, retain) ProgressView *progressView;

@end
