//
//  UserEntity.h
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-30.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserEntity : NSObject
{
    int                 _iIndex;
    NSString            *_userName;
    NSString            *_phone;
}

@property(copy, nonatomic) NSString *userName;
@property(copy, nonatomic) NSString *phone;

- (id)initPortalWithIndex:(int) newIndex userName:(NSString *)newUserName phone:(NSString *)newPhone;

@end
