/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： RefreshTableView.h
 * 内容摘要： 本功能类为带刷新(可下拉刷新、上拉加载更多)的TableView
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年9月7日
 * 说   明： 本类非本人原创，由danal Luo提供，本人整理而成
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import "RefreshTableView.h"
#import <QuartzCore/QuartzCore.h>

#define kPROffsetY 60.f
#define kPRMargin 5.f
#define kPRLabelHeight 20.f
#define kPRLabelWidth 100.f
#define kPRArrowWidth 20.f  
#define kPRArrowHeight 40.f

#define kTextColor [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define kPRBGColor [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0]
#define kPRAnimationDuration .18f

//==============================================================================
@interface LoadingView () 
- (void)updateRefreshDate :(NSDate *)date;
- (void)layouts;
@end

@implementation LoadingView
@synthesize atTop = _atTop;
@synthesize state = _state;
@synthesize loading = _loading;

- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top 
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.atTop = top;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = kPRBGColor;
        UIFont *ft = [UIFont systemFontOfSize:12.f];
        _stateLabel = [[UILabel alloc] init ];
        _stateLabel.font = ft;
        _stateLabel.textColor = kTextColor;
        _stateLabel.textAlignment = UITextAlignmentCenter;
        _stateLabel.backgroundColor = kPRBGColor;
        _stateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _stateLabel.text = NSLocalizedString(@"downrefresh", @"");
        [self addSubview:_stateLabel];
        
        _dateLabel = [[UILabel alloc] init ];
        _dateLabel.font = ft;
        _dateLabel.textColor = kTextColor;
        _dateLabel.textAlignment = UITextAlignmentCenter;
        _dateLabel.backgroundColor = kPRBGColor;
        _dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_dateLabel];
        
        _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20) ];
        
        _arrow = [CALayer layer];
        _arrow.frame = CGRectMake(0, 0, 20, 20);
        _arrow.contentsGravity = kCAGravityResizeAspect;
        
        _arrow.contents = (id)[UIImage imageWithCGImage:[UIImage imageNamed:@"blueArrow.png"].CGImage scale:1 orientation:UIImageOrientationDown].CGImage;
        
        [self.layer addSublayer:_arrow];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activityView];
        
        [self layouts];
        
    }
    return self;
}

- (void)layouts 
{
    CGSize size = self.frame.size;
    CGRect stateFrame,dateFrame,arrowFrame;
    
    float x = 0,y,margin;
    margin = (kPROffsetY - 2*kPRLabelHeight)/2;
    if (self.isAtTop) 
    {
        y = size.height - margin - kPRLabelHeight;
        dateFrame = CGRectMake(0,y,size.width,kPRLabelHeight);
        
        y = y - kPRLabelHeight;
        stateFrame = CGRectMake(0, y, size.width, kPRLabelHeight);
        
        
        x = kPRMargin;
        y = size.height - margin - kPRArrowHeight;
        arrowFrame = CGRectMake(4*x, y, kPRArrowWidth, kPRArrowHeight);
        
        UIImage *arrow = [UIImage imageNamed:@"blueArrow"];
        _arrow.contents = (id)arrow.CGImage;
        
    } 
    else 
    {    
        y = margin;
        stateFrame = CGRectMake(0, y, size.width, kPRLabelHeight );
        
        y = y + kPRLabelHeight;
        dateFrame = CGRectMake(0, y, size.width, kPRLabelHeight);
        
        x = kPRMargin;
        y = margin;
        arrowFrame = CGRectMake(4*x, y, kPRArrowWidth, kPRArrowHeight);
        
        UIImage *arrow = [UIImage imageNamed:@"blueArrowDown"];        
        _arrow.contents = (id)arrow.CGImage;
        _stateLabel.text = NSLocalizedString(@"topload", @"");
    }
    
    _stateLabel.frame = stateFrame;
    _dateLabel.frame = dateFrame;
    _arrowView.frame = arrowFrame;
    _activityView.center = _arrowView.center;
    _arrow.frame = arrowFrame;
    _arrow.transform = CATransform3DIdentity;
}

- (void)setState:(RefreshState)state 
{
    [self setState:state animated:YES];
}

- (void)setState:(RefreshState)state animated:(BOOL)animated
{
    float duration = animated ? kPRAnimationDuration : 0.f;
    if (_state != state) 
    {
        _state = state;
        if (_state == RefreshStateLoading)   //Loading
        {
            _arrow.hidden = YES;
            _activityView.hidden = NO;
            [_activityView startAnimating];
            
            _loading = YES;
            if (self.isAtTop) 
            {
                _stateLabel.text = NSLocalizedString(@"refresh", @"");
            } 
            else 
            {
                _stateLabel.text = NSLocalizedString(@"loading", @"");
            }
            
        } 
        else if (_state == RefreshStatePulling && !_loading)  
        {    //Scrolling
            _arrow.hidden = NO;
            _activityView.hidden = YES;
            [_activityView stopAnimating];
            
            [CATransaction begin];
            [CATransaction setAnimationDuration:duration];
            _arrow.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            [CATransaction commit];
            
            if (self.isAtTop) 
            {
                _stateLabel.text = NSLocalizedString(@"releaserefresh", @"");
            } 
            else 
            {
                _stateLabel.text = NSLocalizedString(@"releaseloadmore", @"");
            }
            
        } 
        else if (_state == RefreshStateNormal && !_loading)
        {    //Reset
            _arrow.hidden = NO;
            _activityView.hidden = YES;
            [_activityView stopAnimating];
            
            [CATransaction begin];
            [CATransaction setAnimationDuration:duration];
            _arrow.transform = CATransform3DIdentity;
            [CATransaction commit];
            
            if (self.isAtTop) 
            {
                _stateLabel.text = NSLocalizedString(@"downrefresh", @"");
            } 
            else 
            {
                _stateLabel.text = NSLocalizedString(@"toploadmore", @"");
            }
        } 
        else if (_state == RefreshStateHitTheEnd)
        {
            if (!self.isAtTop) 
            {    //footer
                _arrow.hidden = YES;
                _stateLabel.text = NSLocalizedString(@"nothavemore", @"");
            }
        }
    }
}

- (void)setLoading:(BOOL)loading 
{
    _loading = loading;
}

- (void)updateRefreshDate :(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateString = [df stringFromDate:date];
    
    _dateLabel.text = [NSString stringWithFormat:@"%@: %@",
                       NSLocalizedString(@"lastupdate", @""),
                       dateString];
    [df release];
}

@end

//==============================================================================

@implementation RefreshTableView
@synthesize refreshDelegate = _refreshDelegate;
@synthesize reachedTheEnd = _reachedTheEnd;
@synthesize headerOnly = _headerOnly;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) 
    {
        CGRect rect = CGRectMake(0, 0 - frame.size.height, frame.size.width, frame.size.height);
        _headerView = [[LoadingView alloc] initWithFrame:rect atTop:YES];
        _headerView.atTop = YES;
        [self addSubview:_headerView];
        
        rect = CGRectMake(0, frame.size.height, frame.size.width, frame.size.height);
        _footerView = [[LoadingView alloc] initWithFrame:rect atTop:NO];
        _footerView.atTop = NO;
        [self addSubview:_footerView];
        
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame pullingDelegate:(id<RefreshTableViewDelegate>)aRefreshDelegate 
{
    self = [self initWithFrame:frame style:UITableViewStylePlain];
    if (self)
    {
        self.refreshDelegate = aRefreshDelegate;
    }
    return self;
}

- (void)dealloc 
{
    [self removeObserver:self forKeyPath:@"contentSize"];
    [_headerView release];
    [_footerView release];
    [super dealloc];
}

#pragma mark - attributes

- (void)setReachedTheEnd:(BOOL)reachedTheEnd
{
    _reachedTheEnd = reachedTheEnd;
    if (_reachedTheEnd)
    {
        _footerView.state = RefreshStateHitTheEnd;
    } 
    else 
    {
        _footerView.state = RefreshStateNormal;
    }
}

- (void)setHeaderOnly:(BOOL)headerOnly
{
    _headerOnly = headerOnly;
    _footerView.hidden = _headerOnly;
}

#pragma mark - Scroll methods

- (void)tableViewDidScroll:(UIScrollView *)scrollView 
{
    if (_headerView.state == RefreshStateLoading || _footerView.state == RefreshStateLoading) 
    {
        return;
    }
    
    CGPoint offset = scrollView.contentOffset;
    CGSize size = scrollView.frame.size;
    CGSize contentSize = scrollView.contentSize;
    
    float yMargin = offset.y + size.height - contentSize.height;
    if (offset.y < -kPROffsetY) 
    {   //header totally appeard
        _headerView.state = RefreshStatePulling;
    } 
    else if (offset.y > -kPROffsetY && offset.y < 0)
    { //header part appeared
        _headerView.state = RefreshStateNormal;
        
    } 
    else if ( yMargin > kPROffsetY)
    {  //footer totally appeared
        if (_footerView.state != RefreshStateHitTheEnd) 
        {
            _footerView.state = RefreshStatePulling;
        }
    } 
    else if ( yMargin < kPROffsetY && yMargin > 0) 
    {//footer part appeared
        if (_footerView.state != RefreshStateHitTheEnd)
        {
            _footerView.state = RefreshStateNormal;
        }
    }
}

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView 
{
    
    if (_headerView.state == RefreshStateLoading || _footerView.state == RefreshStateLoading) 
    {
        return;
    }
    if (_headerView.state == RefreshStatePulling) 
    {
        _isFooterInAction = NO;
        _headerView.state = RefreshStateLoading;
        
        [UIView animateWithDuration:kPRAnimationDuration animations:^{
            self.contentInset = UIEdgeInsetsMake(kPROffsetY, 0, 0, 0);
        }];
        if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(tableViewDidStartRefreshing:)]) 
        {
            [_refreshDelegate tableViewDidStartRefreshing:self];
        }
    } 
    else if (_footerView.state == RefreshStatePulling) 
    {
        if (self.reachedTheEnd || self.headerOnly) 
        {
            return;
        }
        _isFooterInAction = YES;
        _footerView.state = RefreshStateLoading;
        [UIView animateWithDuration:kPRAnimationDuration animations:^{
            self.contentInset = UIEdgeInsetsMake(0, 0, kPROffsetY, 0);
        }];
        if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(tableViewDidStartLoading:)]) 
        {
            [_refreshDelegate tableViewDidStartLoading:self];
        }
    }
}

- (void)tableViewDidFinishedLoading 
{
    [self tableViewDidFinishedLoadingWithMessage:nil];  
}

- (void)tableViewDidFinishedLoadingWithMessage:(NSString *)msg
{
    if (_headerView.loading) 
    {
        _headerView.loading = NO;
        [_headerView setState:RefreshStateNormal animated:NO];
        NSDate *date = [NSDate date];
        if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(tableViewRefreshingFinishedDate)]) 
        {
            date = [_refreshDelegate tableViewRefreshingFinishedDate];
        }
        [_headerView updateRefreshDate:date];
        [UIView animateWithDuration:kPRAnimationDuration*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } completion:^(BOOL bl){
            if (msg != nil && ![msg isEqualToString:@""]) 
            {
                [self flashMessage:msg];
            }
        }];
    }
    else if (_footerView.loading) 
    {
        _footerView.loading = NO;
        [_footerView setState:RefreshStateNormal animated:NO];
        NSDate *date = [NSDate date];
        if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(tableViewRefreshingFinishedDate)]) 
        {
            date = [_refreshDelegate tableViewRefreshingFinishedDate];
        }
        [_footerView updateRefreshDate:date];
        
        [UIView animateWithDuration:kPRAnimationDuration animations:^{
            self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } completion:^(BOOL bl){
            if (msg != nil && ![msg isEqualToString:@""]) 
            {
                [self flashMessage:msg];
            }
        }];
    }
}

- (void)flashMessage:(NSString *)msg
{
    if (_isFooterInAction) 
    {
        __block CGRect rect = CGRectMake(0, self.contentOffset.y + self.bounds.size.height, self.bounds.size.width, 20);
        if (_msgLabel == nil) 
        {
            _msgLabel = [[UILabel alloc] init];
            _msgLabel.frame = rect;
            _msgLabel.font = [UIFont systemFontOfSize:14.f];
            _msgLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            _msgLabel.backgroundColor = [UIColor orangeColor];
            _msgLabel.textAlignment = UITextAlignmentCenter;
            [self addSubview:_msgLabel];    
        }
        _msgLabel.text = msg;
        
        rect.origin.y -= 20;
        [UIView animateWithDuration:.4f animations:^{
            _msgLabel.frame = rect;
        } completion:^(BOOL finished){
            rect.origin.y += 20;
            [UIView animateWithDuration:.4f delay:0.8f options:UIViewAnimationOptionCurveLinear animations:^{
                _msgLabel.frame = rect;
            } completion:^(BOOL finished)
             {
                 [_msgLabel removeFromSuperview];
                 _msgLabel = nil;            
             }];
        }];
    }
    else 
    {
        __block CGRect rect = CGRectMake(0, self.contentOffset.y - 20, self.bounds.size.width, 20);
        if (_msgLabel == nil) 
        {
            _msgLabel = [[UILabel alloc] init];
            _msgLabel.frame = rect;
            _msgLabel.font = [UIFont systemFontOfSize:14.f];
            _msgLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            _msgLabel.backgroundColor = [UIColor orangeColor];
            _msgLabel.textAlignment = UITextAlignmentCenter;
            [self addSubview:_msgLabel];    
        }
        _msgLabel.text = msg;
        
        rect.origin.y += 20;
        [UIView animateWithDuration:.4f animations:^{
            _msgLabel.frame = rect;
        } completion:^(BOOL finished){
            rect.origin.y -= 20;
            [UIView animateWithDuration:.4f delay:0.8f options:UIViewAnimationOptionCurveLinear animations:^{
                _msgLabel.frame = rect;
            } completion:^(BOOL finished){
                [_msgLabel removeFromSuperview];
                _msgLabel = nil;            
            }];
        }];
    }
}

#pragma mark - 

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context 
{
    CGRect frame = _footerView.frame;
    CGSize contentSize = self.contentSize;
    frame.origin.y = contentSize.height < self.frame.size.height ? self.frame.size.height : contentSize.height;
    _footerView.frame = frame;
    if (_isFooterInAction) 
    {
        CGPoint offset = self.contentOffset;
        offset.y += 44.f;
        self.contentOffset = offset;
    }
}

@end
