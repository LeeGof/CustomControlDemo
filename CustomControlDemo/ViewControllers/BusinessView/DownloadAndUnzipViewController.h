//
//  DownloadAndUnzipViewController.h
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-9-13.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadHandler.h"

@class ProgressView;
@interface DownloadAndUnzipViewController : UIViewController<DownloadHandlerDelegate>
{
    ProgressView                *_progressView;
}

@property (nonatomic, retain) ProgressView *progressView;

@end
