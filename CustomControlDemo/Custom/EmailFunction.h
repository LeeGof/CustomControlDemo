/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： EmailFunction.h
 * 内容摘要： 邮件功能类
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

@interface EmailFunction : NSObject <UIActionSheetDelegate>
{
    NSString *eMail;   // 获取邮箱地址
}

@property(nonatomic, retain) NSString *eMail;

//需要发送电子邮件时调用
//-(void)getEmailAddress:(NSString *)address showIn:(UIViewController *)theController;
//确定发送时调用
-(void)sendEmailToAddress:(NSString *)address;

@end
