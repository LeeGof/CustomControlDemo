/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： ProgressView.m
 * 内容摘要： 本功能类实现正在加载效果
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年8月24日
 
 * 修改日期： 2012年8月28日
 * 版 本 号： v1.0
 * 修 改 人： 李高峰
 * 修改内容： 去掉提示文字的背景色
 ******************************************************************************/

#import "ProgressView.h"

@implementation ProgressView
@synthesize activeView = _activeView;

#pragma mark - 对象初始化

/*******************************************************************************
 * 方法名称：初始化
 * 功能描述：初始化DropDownList对象
 * 输入参数：
    frame：ProgressView的frame
 * 输出参数：ProgressView对象
 ******************************************************************************/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) 
        {
            _activeView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
            [_activeView setFrame:CGRectMake(142, 153, 37, 37)];
            
            if ([_activeView respondsToSelector:@selector(setColor:)]) 
            {
                _activeView.color = [UIColor colorWithRed:0.2784 green:0.4863 blue:0.8353 alpha:1.0];
            }
        }
        else 
        {
            _activeView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
            [_activeView setFrame:CGRectMake(142, 153, 37, 37)];
        }
        
        [self addSubview:_activeView];
        
        
        UILabel *lblLoad = [[UILabel alloc] initWithFrame:CGRectMake(87, 193, 147, 37)];
        lblLoad.textAlignment = UITextAlignmentCenter;
        [lblLoad setText:NSLocalizedString(@"loading", nil)];
        lblLoad.backgroundColor = [UIColor clearColor];
        [lblLoad setFont:[UIFont boldSystemFontOfSize:26.0]];
        lblLoad.textColor = [UIColor colorWithRed:0.2784 green:0.4863 blue:0.8353 alpha:1.0];
        [self addSubview:lblLoad];
        [lblLoad release];
    }
    return self;
}

@end
