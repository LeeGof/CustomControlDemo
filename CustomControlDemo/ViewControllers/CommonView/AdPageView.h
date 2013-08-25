/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： AdPageView.h
 * 内容摘要： 广告预览类，用于实现广告的预览效果。
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年8月24日
 * 说   明： 本类为直接从用友应用中心中提取过来，没有进行修改，感谢原创马增盛
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import <UIKit/UIKit.h>

@interface AdPageView : UIView<UIScrollViewDelegate>
{
    CGFloat _pageViewHeight;    // 页码视图高度
    CGFloat _imageSpace;        // 图片间距, 如果不需要间距设置为0, 注意，要先于imageArray之前设置
    
    UIColor *_imageBgk;         // 图片视图背景色
    UIColor *_pageBgk;          // 页码视图背景色
    
    NSArray *_imageArray;       // 广告图片数据，装载数据为UIImageView
}

@property (nonatomic, assign) CGFloat pageViewHeight;
@property (nonatomic, assign) CGFloat imageSpace;
@property (nonatomic, retain) UIColor *imageBgk;
@property (nonatomic, retain) UIColor *pageBgk;

@property (nonatomic, retain) NSArray *imageArray;

@end

//==============================================================================