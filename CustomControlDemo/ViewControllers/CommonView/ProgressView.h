/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： ProgressView.h
 * 内容摘要： 本功能类实现正在加载效果
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年8月24日
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import <UIKit/UIKit.h>

@interface ProgressView : UIView
{
    UIActivityIndicatorView         *_activeView;  // 加载的图标
}

@property (nonatomic, retain) UIActivityIndicatorView *activeView;

@end
