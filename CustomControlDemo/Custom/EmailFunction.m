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

#import "EmailFunction.h"


@implementation EmailFunction
@synthesize eMail;

//--------------------------------------------------
//函数描述：需要发送邮件时调用
//参   数：邮箱地址  NSString类型
//备   注：
//--------------------------------------------------
-(void)showIn:(UIViewController *)theController{
    
 if(eMail != nil && ![eMail isEqual:@""]){
    UIActionSheet * actsheet = [[UIActionSheet alloc]initWithTitle:@"Please Select" 
                                                          delegate:self
                                                 cancelButtonTitle:@"取消" 
                                            destructiveButtonTitle:@"发送E-mail"  
                                                 otherButtonTitles:nil];
    [actsheet showInView:theController.view];
    [actsheet release];
 }
 else{
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil   message:@"请先填入email!" delegate: self  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
         [alert show];
         [alert release];
 }
    
	
}

//--------------------------------------------------
//函数描述：相应UIActiongSheet，选择发送电子邮件
//备   注：
//--------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{  
    if (buttonIndex == 1) 
	{
        [self sendEmailToAddress:eMail];
	}
	
}

//--------------------------------------------------
//函数描述：发送电子邮件时 调用
//备   注：
//--------------------------------------------------
-(void)sendEmailToAddress:(NSString *)address{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",address]]];    
}
-(void)dealloc
{
//    [self.eMail release];
    [super dealloc];
}
@end
