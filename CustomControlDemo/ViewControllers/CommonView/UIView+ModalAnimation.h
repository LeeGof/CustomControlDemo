/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： UIView+ModalAnimation.h
 * 内容摘要： 本功能类是对uiview的扩展，实现模态动画效果。
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年8月24日
 * 说   明： 
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import <Foundation/Foundation.h>

@interface UIView (ModalAnimation) 
+(void) commitModalAnimations;

@end

@interface UIViewModalAnimationDelegate : NSObject
{
	CFRunLoopRef currentLoop;
}
-(id) initWithRunLoop:(CFRunLoopRef) cfRunLoopRef;
@end

