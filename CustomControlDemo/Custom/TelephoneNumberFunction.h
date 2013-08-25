/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： TelephoneNumberFunction.h
 * 内容摘要： 电话功能类
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年8月29日
 * 说   明： 
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import <Foundation/Foundation.h>

@interface TelephoneNumberFunction : NSObject <UIActionSheetDelegate>
{
    NSString *phoneNumber;
}

@property (nonatomic, retain ) NSString *phoneNumber;

/***
 过滤掉电话中的非法字符，返回字符长度为0的不是电话号码
 **/
-(NSString *)filteNumber:(NSString *) number;

-(void)showIn:(UIViewController*)theController;

-(void)callTheNumber:(NSString *)number ;

-(void)smsToTheNumber:(NSString *)number;

@end
