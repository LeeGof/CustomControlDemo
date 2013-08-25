//
//  UserDao.h
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-30.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserEntity;
@class DBHelper;
@interface UserDao : NSObject
{
    DBHelper    *_dbHelper;
}

- (NSMutableArray *)getUserList;  // 获取用户列表
//- (BOOL)deleteUser;  // 删除用户
//- (BOOL)addUser:(UserEntity *)userEntity;  // 添加用户
//- (BOOL)updateUser:(UserEntity *)userEntity;  // 更新用户
//- (BOOL)userIsExist:(NSString *)userName;  // 判断用户是否存在

@end
