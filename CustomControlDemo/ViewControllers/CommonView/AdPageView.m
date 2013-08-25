/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： AdPageView.m
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

#import "AdPageView.h"
#import "PageControl.h"

//==============================================================================
#pragma mark - AdPageView 私有函数

@interface AdPageView()
{
    UIScrollView    *_scrollView;
    PageControl     *_pageControl;
    
    BOOL            _pageUsed;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) PageControl *pageControl;

- (void)addSubViews:(CGRect)frame;
- (void)loadScrollViewWithPage:(int)page;

@end

//==============================================================================
#pragma mark - AdPageView类实现

@implementation AdPageView
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;

@synthesize pageViewHeight = _pageViewHeight;
@synthesize imageSpace = _imageSpace;
@synthesize imageBgk = _imageBgk;
@synthesize pageBgk = _pageBgk;

@synthesize imageArray = _imageArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubViews:frame];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self addSubViews:self.frame];
    }
    return self;
}

- (void)dealloc
{
	[_scrollView release];
	[_pageControl release];
    
    [_imageBgk release];
    [_pageBgk release];
    [_imageArray release];
    
    [super dealloc];
}

//==============================================================================
#pragma mark - 属性

- (void)setImageSpace:(CGFloat)imageSpace
{
    _imageSpace = imageSpace;
}

- (void)setImageBgk:(UIColor *)imageBgk
{
    [_imageBgk release];
    _imageBgk = [imageBgk retain];
    
    _scrollView.backgroundColor = _imageBgk;
}

- (void)setPageBgk:(UIColor *)pageBgk
{
    [_pageBgk release];
    _pageBgk = [pageBgk retain];
    
    _pageControl.backgroundColor = _pageBgk;
}

- (void)setImageArray:(NSArray *)imageArray
{
    if (imageArray == nil)
    {
        return;
    }
    
    [_imageArray release];
    _imageArray = nil;
    
    _imageArray = [imageArray retain];
    
    if (_imageArray)
    {
        int num = [_imageArray count];
        
        // 设置位置
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*num, _scrollView.frame.size.height);
        _pageControl.numOfPages = num;
        
        // 加载页码数据
        [self loadScrollViewWithPage:0];
        [self loadScrollViewWithPage:1];
    }
}

//==============================================================================
#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_pageUsed)
    {
        return;
    }
	
    CGFloat pageWidth = scrollView.frame.size.width - 30;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.curPage = page;
	
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _pageUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageUsed = NO;
}

//==============================================================================
#pragma mark - 属性

- (void)setPageViewHeight:(CGFloat)pageViewHeight
{
    _pageViewHeight = pageViewHeight;
    //_pageControl.frame = CGRectMake(0, self.frame.size.height - _pageViewHeight, self.frame.size.width, _pageViewHeight);
    //_scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - _pageViewHeight);
    _pageControl.frame = CGRectMake(0, self.frame.size.height - _pageViewHeight, self.frame.size.width, _pageViewHeight);
    _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

//==============================================================================
#pragma mark - 私有函数

- (void)addSubViews:(CGRect)frame
{
    _scrollView = [[UIScrollView alloc]
                   initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _pageControl = [[PageControl alloc]
                    initWithFrame:CGRectMake(0, frame.size.height - 10, frame.size.width, 10)];
    _pageControl.userInteractionEnabled = NO;
    
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    
    _pageControl.curPage = 0;
    _pageControl.backgroundColor = [UIColor blackColor];
    
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0 || page >= [_imageArray count])
    {
        return;
    }
    
    UIImageView *iv = [_imageArray objectAtIndex:page];
    
    if (iv.superview == nil)
    {
        CGRect frame = _scrollView.frame;
        
        // 图片宽度
        int width = frame.size.width - 2*_imageSpace;
        frame.origin.x = page * width + (2*page + 1)*_imageSpace;
        frame.origin.y = 0;
        frame.size.width = width;
        iv.frame = frame;
        [_scrollView addSubview:iv];
    }
}

@end

//==============================================================================

