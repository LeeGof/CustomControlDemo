//
//  VoiceViewController.h
//  CustomControlDemo
//
//  Created by ligf on 12-12-19.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iFlyMSC/IFlyRecognizeControl.h"
#import "iFlyMSC/IFlySynthesizerControl.h"

@interface VoiceViewController : UIViewController<IFlyRecognizeControlDelegate,IFlySynthesizerControlDelegate>
{
    IFlyRecognizeControl		*_iFlyRecognizeControl;  // 识别控件
    IFlySynthesizerControl		*_iFlySynthesizerControl;  // 合成控件
}

@end
