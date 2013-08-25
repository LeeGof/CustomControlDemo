//
//  DropDownListViewController.h
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-21.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownList.h"
#import "DDLTableAlert.h"

@interface DropDownListViewController : UIViewController<DDLTableAlertDelegate,DDLTableAlertDataSource>
{
    DropDownList        *_ddlType;  // 下拉列表框
    NSArray             *_arrDdlData;  // 下拉框数据
    UIButton            *_btnDdlAlert;  // 
}

@end
