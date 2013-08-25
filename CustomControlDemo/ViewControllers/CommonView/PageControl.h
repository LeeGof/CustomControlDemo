/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： PageControl.h
 * 内容摘要： 分页效果类。
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

@interface PageControl : UIPageControl 
{
    NSInteger _curPage;
    NSInteger _numOfPages;
    
    UIColor *_dotColorCurrentPage;
    UIColor *_dotColorOtherPage;
}

@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger numOfPages;
@property (nonatomic, retain) UIColor *dotColorCurrentPage;
@property (nonatomic, retain) UIColor *dotColorOtherPage;

@end