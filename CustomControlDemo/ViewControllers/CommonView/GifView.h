/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： GifView.h
 * 内容摘要： 本功能类负责显示gif图片
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年9月23日
 * 说   明： 需要引入ImageIO.framework、QuartzCore.framework框架
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

@interface GifView : UIView
{
	CGImageSourceRef            gif;
	NSDictionary                *gifProperties;
	size_t                      index;
	size_t                      count;
	NSTimer                     *timer;
}

- (id)initWithFrame:(CGRect)frame filePath:(NSString *)strFilePath;
- (id)initWithFrame:(CGRect)frame data:(NSData *)strData;

@end
