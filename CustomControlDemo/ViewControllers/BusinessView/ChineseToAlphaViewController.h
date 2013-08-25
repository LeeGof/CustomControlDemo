//
//  ChineseToAlphaViewController.h
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-22.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChineseToAlphaViewController : UIViewController
{
    UITextField    *_txtField;  // 待转换内容
    UIButton       *_btnConvert;  // 转换按钮
    UITextView     *_tvResult;  //转换结果
}

@end
