//
//  QRCodeViewController.h
//  二维码
//
//  Created by ligf on 13-6-17.
//  Copyright (c) 2013年 用友软件股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface QRCodeViewController : UIViewController<ZBarReaderDelegate,UIAlertViewDelegate>

@end
