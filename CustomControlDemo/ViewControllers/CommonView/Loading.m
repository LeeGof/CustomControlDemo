/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： Loading.m
 * 内容摘要： 本功能类实现正在加载效果
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年8月24日
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import "Loading.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+ModalAnimation.h"

@implementation Loading

#pragma mark - 自定义方法

/*******************************************************************************
 * 方法名称：显示loading
 * 功能描述：外部调用方法，用于显示loading
 * 输入参数：
    theView：在哪个view上显示，一般取值为self.view
    title：显示的提示信息文字
 * 输出参数：
 ******************************************************************************/
-(void) startLoading:(UIView *)theView title:(NSString *)title
{
	UIView *view = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
	//蒙版
	UIView *mask = [[UIView alloc] initWithFrame:view.frame];
	mask.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.0];
	mask.tag = LOADING_MASK_VIEWTAG;
	mask.userInteractionEnabled = YES;
	
	//灰色底层
	UIView *maskgray = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 70)];
	maskgray.tag = LOADING_MASK_GRAYVIEWTAG;
	maskgray.alpha = 0.0;
	maskgray.center = CGPointMake(mask.frame.size.width/2, mask.frame.size.height/2);
	maskgray.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8];
	CALayer *layer = [maskgray layer];
	[layer setCornerRadius:6.0f];
	[mask addSubview:maskgray];
	[maskgray release];
    
	//计算Loading图标和文字的大小和位置
    UIFont *font = [UIFont boldSystemFontOfSize:18.0];
	CGSize size = [title sizeWithFont:font];
	CGRect iconRect = CGRectMake((view.frame.size.width - size.width - 20)/2, (view.frame.size.height - 20)/2 + 2, 14, 14);
	CGRect titleRect = CGRectMake((view.frame.size.width - size.width - 20)/2 + 25, (view.frame.size.height - 20)/2 + 2, size.width, 14);
	
	//loading图标
	UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	aiv.frame = iconRect;
	[aiv startAnimating];
	[mask addSubview:aiv];
	[aiv release];
	
	//title
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	label.text = title;
	label.textColor =[UIColor whiteColor]; 
	label.frame = titleRect;
	label.backgroundColor = [UIColor clearColor];
	label.font = font;
	[mask addSubview:label];
	[label release];
	
	[view addSubview:mask];
	[mask release];
	
	//动画
	CGAffineTransform currentTransform = maskgray.transform;
	CGAffineTransform scallTransform = CGAffineTransformScale(currentTransform, 2.0f, 2.0f);
	[maskgray setTransform:scallTransform];
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.2];	
	[maskgray setTransform:currentTransform];
	maskgray.alpha = 1.0f;
	[UIView commitModalAnimations];
}

/*******************************************************************************
 * 方法名称：隐藏loading
 * 功能描述：外部调用方法，用于隐藏loading
 * 输入参数：
    theView：从哪个view上隐藏，一般取值为self.view
 * 输出参数：
 ******************************************************************************/
-(void) stopLoading:(UIView *)theView
{
	UIView *view = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
	UIView *vi = [view viewWithTag:LOADING_MASK_VIEWTAG];
	UIView *maskgray = [vi viewWithTag:LOADING_MASK_GRAYVIEWTAG];
    
	CGAffineTransform currentTransform = maskgray.transform;
	CGAffineTransform scallTransform = CGAffineTransformScale(currentTransform, 0.8f, 0.8f);
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.1];	
	[maskgray setTransform:scallTransform];
	[UIView commitModalAnimations];
	
	scallTransform = CGAffineTransformScale(currentTransform, 2.0, 2.0);
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.2];	
	[maskgray setTransform:scallTransform];
	maskgray.alpha = 0.0;
	[UIView commitModalAnimations];
    
	[vi removeFromSuperview];
}

@end
