//
//  UserDao.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-30.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "UserDao.h"
#import "UserEntity.h"
#import "FMResultSet.h"
#import "DBHelper.h"
#import "Constants.h"

@implementation UserDao

- (id)init
{
	if(self = [super init])
	{
		_dbHelper = [[DBHelper alloc] init];
	}
	
	return self;
}

- (NSMutableArray *)getUserList
{
    NSMutableArray *arrResult = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    FMResultSet *resultSet = [_dbHelper executeQuery:[NSString stringWithFormat:@"select * from %@",TABLE_USER]];
    
    while ([resultSet next]) 
    {
        UserEntity *userEntity = [[UserEntity alloc] initPortalWithIndex:[resultSet intForColumn:@"ID"] userName:[resultSet stringForColumn:@"Name"] phone:[resultSet stringForColumn:@"Phone"]];
        [arrResult addObject:userEntity];
        [userEntity release];
    }
    
    [resultSet close];
    
    return arrResult;
}

@end
