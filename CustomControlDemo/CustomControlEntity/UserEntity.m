//
//  UserEntity.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-30.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "UserEntity.h"

@implementation UserEntity
@synthesize userName = _userName;
@synthesize phone = _phone;

- (id)initPortalWithIndex:(int) newIndex userName:(NSString *)newUserName phone:(NSString *)newPhone
{
    if(self = [self init])
    {
        _iIndex = newIndex;
        self.userName = newUserName;
        self.phone = newPhone;
    }
    return self;
}

- (void)dealloc
{
    [_userName release];
    [_phone release];
    
    [super dealloc];
}

@end
