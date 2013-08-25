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

#import "PageControl.h"

#define kDotDiameter 6.0
#define kDotSpacer 10.0

@implementation PageControl
@synthesize curPage = _curPage;
@synthesize numOfPages = _numOfPages;
@synthesize dotColorCurrentPage = _dotColorCurrentPage;
@synthesize dotColorOtherPage = _dotColorOtherPage;

- (NSInteger)curPage
{
    return _curPage;
}

- (void)setCurPage:(NSInteger)page
{
    _curPage = MIN(MAX(0, page), _numOfPages - 1);
    [self setNeedsDisplay];
}

- (NSInteger)numOfPages
{
    return _numOfPages;
}

- (void)setNumOfPages:(NSInteger)pages
{
    _numOfPages = MAX(0, pages);
    _curPage = MIN(MAX(0, _curPage), _numOfPages - 1);
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
    {
        self.backgroundColor = [UIColor clearColor];
        self.dotColorCurrentPage = [UIColor redColor];
        self.dotColorOtherPage = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect 
{
    CGContextRef context = UIGraphicsGetCurrentContext();   
    CGContextSetAllowsAntialiasing(context, true);
    
    CGRect currentBounds = self.bounds;
    CGFloat dotsWidth = self.numOfPages * kDotDiameter + MAX(0, self.numOfPages - 1) * kDotSpacer;
    CGFloat x = CGRectGetMidX(currentBounds) - dotsWidth / 2;
    CGFloat y = CGRectGetMidY(currentBounds) - kDotDiameter / 2;
    
    for (int i = 0; i < self.numOfPages; i++)
    {
        CGRect circleRect = CGRectMake(x, y, kDotDiameter, kDotDiameter);
        if (i == self.curPage)
        {
            CGContextSetFillColorWithColor(context, self.dotColorCurrentPage.CGColor);
        }
        else
        {
            CGContextSetFillColorWithColor(context, self.dotColorOtherPage.CGColor);
        }
        CGContextFillEllipseInRect(context, circleRect);
        x += kDotDiameter + kDotSpacer;
    }
}

- (void)dealloc 
{
    [_dotColorCurrentPage release];
    [_dotColorOtherPage release];
    
    [super dealloc];
}

@end
