//
//  Metadata.h
//  digester解析xml数据
//
//  Created by 高峰 李 on 12-8-26.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Metadata : NSObject
{
    NSString            *_title;
    NSString            *_language;
    NSString            *_creator;
    NSString            *_publisher;
}
@property(copy, nonatomic) NSString *title;
@property(copy, nonatomic) NSString *language;
@property(copy, nonatomic) NSString *creator;
@property(copy, nonatomic) NSString *publisher;

@end
