/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： GifView.h
 * 内容摘要： 本功能类负责显示gif图片
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年9月23日
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import "GifView.h"
#import <QuartzCore/QuartzCore.h>

@implementation GifView

- (id)initWithFrame:(CGRect)frame filePath:(NSString *)strFilePath
{
    self = [super initWithFrame:frame];
    if (self) 
    {
		gifProperties = [[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount]
													 forKey:(NSString *)kCGImagePropertyGIFDictionary] retain];
		gif = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:strFilePath], (CFDictionaryRef)gifProperties);
		count =CGImageSourceGetCount(gif);
		timer = [NSTimer scheduledTimerWithTimeInterval:0.12 target:self selector:@selector(play) userInfo:nil repeats:YES];
		[timer fire];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame data:(NSData *)strData
{
    self = [super initWithFrame:frame];
    if (self) 
    {
		gifProperties = [[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount]
													 forKey:(NSString *)kCGImagePropertyGIFDictionary] retain];
        gif = CGImageSourceCreateWithData((CFDataRef)strData, (CFDictionaryRef)gifProperties);
		count =CGImageSourceGetCount(gif);
		timer = [NSTimer scheduledTimerWithTimeInterval:0.12 target:self selector:@selector(play) userInfo:nil repeats:YES];
		[timer fire];
    }
    return self;
}

- (void)play
{
	index ++;
	index = index%count;
	CGImageRef ref = CGImageSourceCreateImageAtIndex(gif, index, (CFDictionaryRef)gifProperties);
	self.layer.contents = (id)ref;
    CFRelease(ref);
}

- (void)removeFromSuperview
{
	[timer invalidate];
	timer = nil;
	[super removeFromSuperview];
}

- (void)dealloc 
{
	CFRelease(gif);
	[gifProperties release];
    [super dealloc];
}

@end
