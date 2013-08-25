//
//  SqliteViewController.h
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-30.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class UserEntity;
@interface SqliteViewController : UITableViewController
{
    UITableView         *_tblData;
    NSMutableArray      *_arrListData;
//    UserEntity          *_userEntity;
}

@property (nonatomic, retain) UITableView *tblData;
@property (nonatomic, retain) NSMutableArray *arrListData;
//@property (nonatomic, retain) UserEntity *userEntity;

@end
