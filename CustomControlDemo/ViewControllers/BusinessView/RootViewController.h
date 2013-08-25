//
//  RootViewController.h
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-20.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView         *_tblControl;    //table控件
    NSArray             *_arrTableData;  // Table数据源
}

@property (nonatomic, retain) NSArray *arrTableData;
@property (nonatomic, retain) UITableView *tblControl;

@end
