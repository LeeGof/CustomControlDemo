/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： TelephoneNumberFunction.m
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
#import "TelephoneNumberFunction.h"

@implementation TelephoneNumberFunction
@synthesize phoneNumber;

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
    
    }
    
    return self;
}

//--------------------------------------------------
//函数作用：打电话发信息调用此方法
//参   数：传入电话号码
//备   注：
//--------------------------------------------------
-(void)showIn:(UIViewController*)theController
{
    if(phoneNumber != nil && ![phoneNumber isEqual:@""])
    {
        UIActionSheet *actsheet = [[UIActionSheet alloc]initWithTitle:@"请选择" 
                                              delegate:self 
                                     cancelButtonTitle:@"取消" 
                                destructiveButtonTitle:nil 
                                     otherButtonTitles:@"打电话",@"发信息",nil];
        [actsheet showInView:theController.view];
        [actsheet release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil   message:@"请先填入电话号码!" delegate: self  cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        [alert release];   
    }
}

/***
 过滤掉电话中的非法字符，返回字符长度为0的不是电话号码
 **/
-(NSMutableString *)filteNumber:(NSString *) number
{
    
    NSMutableString *strippedString = [NSMutableString 
                                       stringWithCapacity:number.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:number];
    NSCharacterSet *numbers = [NSCharacterSet 
                               characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) 
    {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) 
        {
            [strippedString appendString:buffer];
        }
        else 
        {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        } 
    }
    
    return strippedString;
}


//--------------------------------------------------
//函数描述：相应UIActiongSheet，选择是打电话、发信息
//备   注：
//--------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{  //选择是打电话还是发信息
    if(buttonIndex == 0)
    {
        
        [self callTheNumber:phoneNumber];   //得到号码 打电话
		
    }
    else if (buttonIndex == 1) 
    {
        [self smsToTheNumber:phoneNumber];   //得到号码 发信息
    }
	
}

//--------------------------------------------------
//函数描述：打电话调用
//备   注：
//--------------------------------------------------
-(void)callTheNumber:(NSString *)number 
{
    NSString *num = [self filteNumber:number];
    if(num.length <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"电话号码错误" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",number]]];
    }
}

-(void)smsToTheNumber:(NSString *)number
{
    NSString *num = [self filteNumber:number];
    if(num.length <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"电话号码错误" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",number]]];  
    }
    
}

-(void)dealloc
{
    [super dealloc];
}


@end
