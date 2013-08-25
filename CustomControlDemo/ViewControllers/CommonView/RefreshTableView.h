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

#import <UIKit/UIKit.h>

/*******************************************************************************
 * RefreshState状态说明：
 * RefreshStateNormal：正常状态，这个状态下，看不到下拉或上拉的那个view
 * RefreshStatePulling：下拉或上拉动作时的状态
 * RefreshStateLoading：下拉或上拉动作释放时的状态
 * RefreshStateHitTheEnd：上拉专用，该状态表明已经没有更多历史数据了
 ******************************************************************************/
typedef enum {
    RefreshStateNormal = 0,
    RefreshStatePulling = 1,
    RefreshStateLoading = 2,
    RefreshStateHitTheEnd = 3
} RefreshState;

//==============================================================================
// 刷新效果的view
@interface LoadingView : UIView {
    UILabel                     *_stateLabel;  // 状态描述的文本框
    UILabel                     *_dateLabel;   // 更新日起的文本框
    UIImageView                 *_arrowView;   // 初始化时的箭头
    UIActivityIndicatorView     *_activityView;  // 正在加载效果的指示标
    CALayer                     *_arrow;  // 刷新一次之后显示的箭头
    BOOL                        _loading;  // 是否正在加载
}
@property (nonatomic,getter = isLoading) BOOL loading;    
@property (nonatomic,getter = isAtTop) BOOL atTop;  // 是否是下拉刷新
@property (nonatomic) RefreshState state;  // 刷新的状态

- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top;  // 初始化该view

- (void)updateRefreshDate:(NSDate *)date;  // 更新刷新时间

@end

//==============================================================================
// RefreshTableView
@protocol RefreshTableViewDelegate;
@interface RefreshTableView : UITableView<UIScrollViewDelegate>{
    LoadingView             *_headerView;  // 下拉刷新的view
    LoadingView             *_footerView;  // 上拉加载更多的view
    UILabel                 *_msgLabel;  // 刷新操作完成之后，用于提示用户的label
    BOOL                    _isFooterInAction;  // 标识是否上拉动作
}
@property (assign,nonatomic) id <RefreshTableViewDelegate> refreshDelegate;
@property (nonatomic) BOOL reachedTheEnd;  // 是否没有更多纪录
@property (nonatomic,getter = isHeaderOnly) BOOL headerOnly;  // 是否只显示下拉刷新

- (id)initWithFrame:(CGRect)frame pullingDelegate:(id<RefreshTableViewDelegate>)aPullingDelegate;

- (void)tableViewDidScroll:(UIScrollView *)scrollView;  

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView;

- (void)tableViewDidFinishedLoading;

- (void)tableViewDidFinishedLoadingWithMessage:(NSString *)msg;

@end

//==============================================================================
// RefreshTableViewDelegate
@protocol RefreshTableViewDelegate <NSObject>

@required
- (void)tableViewDidStartRefreshing:(RefreshTableView *)tableView;  // 刷新的时候使用

@optional
- (void)tableViewDidStartLoading:(RefreshTableView *)tableView;  // 加载更多的时候使用
- (NSDate *)tableViewRefreshingFinishedDate;  // 更新上次刷新或加载更多的时间

@end

//==============================================================================



