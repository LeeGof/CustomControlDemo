//
//  Metadata.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-26.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "Metadata.h"

@implementation Metadata
@synthesize title = _title;
@synthesize language = _language;
@synthesize creator = _creator;
@synthesize publisher = _publisher;

- (void)dealloc
{
    [_title release];;
    [_language release];
    [_creator release];;
    [_publisher release];
    [super dealloc];    
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"metadata - title:%@, language:%@, creator:%@, publisher:%@, ", 
            _title, _language, _creator, _publisher];
}

@end
