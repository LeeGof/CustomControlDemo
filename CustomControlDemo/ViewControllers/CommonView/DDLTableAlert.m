/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： DDLTableAlert.m
 * 内容摘要： 本功能类主要提供alert方式的选择框效果
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年8月23日
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import "DDLTableAlert.h"
#import <QuartzCore/QuartzCore.h>

@interface DDLTableAlert ()
@property (nonatomic, assign) BOOL isPresented;  //是否已经显示

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle messageFormat:(NSString *)format args:(va_list)args;
- (void)increaseHeightBy:(CGFloat)delta;
- (void)layout;

@end

@implementation DDLTableAlert

@synthesize alertView = _alertView;
@synthesize tableView = _tableView;
@synthesize type = _type;
@synthesize maximumVisibleRows = _maximumVisibleRows;
@synthesize rowHeight = _rowHeight;

@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

@dynamic tableViewDelegate;
@dynamic tableViewDataSource;
@dynamic alertViewDelegate;

@synthesize isPresented = _isPresented;

#pragma mark - 对象初始化

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle messageFormat:(NSString *)format args:(va_list)args {
	if ((self = [super init])) {
		NSString *message = format ? [[[NSString alloc] initWithFormat:format arguments:args] autorelease] : nil;
		
		_alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil];
		
		_maximumVisibleRows = 4;
		_rowHeight = 40.;
        
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
		
		[_tableView setDelegate:self];
		[_tableView setDataSource:self];
		[_tableView setBackgroundColor:[UIColor whiteColor]];
		[_tableView setRowHeight:_rowHeight];
		[_tableView setSeparatorColor:[UIColor lightGrayColor]];
		[_tableView.layer setCornerRadius:kTableCornerRadius];
		
		[_alertView addSubview:_tableView];
		
		[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidChangeStatusBarOrientationNotification object:nil queue:nil usingBlock:^(NSNotification *n) {
			dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), ^{[self layout];});
		}];
	}
	
	return self;
}

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle messageFormat:(NSString *)message, ... {
	va_list list;
	va_start(list, message);
	self = [self initWithTitle:title cancelButtonTitle:cancelTitle messageFormat:message args:list];
	va_end(list);
	return self;
}

+ (id)alertWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle messageFormat:(NSString *)message, ... {
	return [[[DDLTableAlert alloc] initWithTitle:title cancelButtonTitle:cancelTitle messageFormat:message] autorelease];
}

- (void)dealloc {
	[self setTableView:nil];
	[self setAlertView:nil];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super dealloc];
}

#pragma mark - 公共方法

- (void)show {
	[_tableView reloadData];
	[_alertView show];
}

#pragma mark - 属性

- (id<UITableViewDelegate>)tableViewDelegate {
	return _tableView.delegate;
}

- (void)setTableViewDelegate:(id<UITableViewDelegate>)tableViewDelegate {
	[_tableView setDelegate:tableViewDelegate];
}

- (id<UITableViewDataSource>)tableViewDataSource {
	return _tableView.dataSource;
}

- (void)setTableViewDataSource:(id<UITableViewDataSource>)tableViewDataSource {
	[_tableView setDataSource:tableViewDataSource];
}

- (id<UIAlertViewDelegate>)alertViewDelegate {
	return _alertView.delegate;
}

- (void)setAlertViewDelegate:(id<UIAlertViewDelegate>)alertViewDelegate {
	[_alertView setDelegate:alertViewDelegate];
}


#pragma mark - 私有方法

- (void)increaseHeightBy:(CGFloat)delta {
	CGPoint c = _alertView.center;
	CGRect r = _alertView.frame;
	r.size.height += delta;
	_alertView.frame = r;
	_alertView.center = c;
	_alertView.frame = CGRectIntegral(_alertView.frame);
	
	for(UIView *subview in [_alertView subviews]) {
		if([subview isKindOfClass:[UIControl class]]) {
			CGRect frame = subview.frame;
			frame.origin.y += delta;
			subview.frame = frame;
		}
	}
}

- (void)layout {
	CGFloat height = 0.;
	NSInteger rows = 0;
	for (NSInteger section = 0; section < [_tableView numberOfSections]; section++) {
		for (NSInteger row = 0; row < [_tableView numberOfRowsInSection:section]; row++) {
			height += [_tableView.delegate tableView:_tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
			rows ++;
		}
	}
	
    CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGFloat avgRowHeight = height / rows;
	CGFloat resultHeigh;
	
    if(height > screenRect.size.height) {
        if(UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
            resultHeigh = screenRect.size.height - _alertView.frame.size.height - 65.;
        else
            resultHeigh = screenRect.size.width - _alertView.frame.size.height - 65.;
    }
	else if (_maximumVisibleRows == -1 || rows <= _maximumVisibleRows)
		resultHeigh = _tableView.contentSize.height;
	else
		resultHeigh = (avgRowHeight * _maximumVisibleRows);
	
	[self increaseHeightBy:resultHeigh];
	
	
	[_tableView setFrame:CGRectMake(12,
                                    _alertView.frame.size.height - resultHeigh - 65,
                                    _alertView.frame.size.width - 24,
                                    resultHeigh)];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(tableAlert:heightForRowAtIndexPath:)])
        return [_delegate tableAlert:self heightForRowAtIndexPath:indexPath];
    
    return _rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (_type == DDLTableAlertTypeSingleSelect)
		[_alertView dismissWithClickedButtonIndex:-1 animated:YES];
	
	if ([_delegate respondsToSelector:@selector(tableAlert:didSelectRowAtIndexPath:)])
		[_delegate tableAlert:self didSelectRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	return [_dataSource tableAlert:self	cellForRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_dataSource tableAlert:self numberOfRowsInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([_dataSource respondsToSelector:@selector(numberOfSectionsInTableAlert:)])
		return [_dataSource numberOfSectionsInTableAlert:self];
    
	return 1;
}

#pragma mark - UIAlertViewDelegate

- (void)alertViewCancel:(UIAlertView *)alertView {
	if ([_delegate respondsToSelector:@selector(tableAlertCancel:)])
		[_delegate tableAlertCancel:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([_delegate respondsToSelector:@selector(tableAlert:clickedButtonAtIndex:)])
		[_delegate tableAlert:self clickedButtonAtIndex:buttonIndex];
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
	if (!_isPresented)
		[self layout];
	_isPresented = YES;
	if ([_delegate respondsToSelector:@selector(willPresentTableAlert:)])
		[_delegate willPresentTableAlert:self];
}
- (void)didPresentAlertView:(UIAlertView *)alertView {
	if ([_delegate respondsToSelector:@selector(didPresentTableAlert:)])
		[_delegate didPresentTableAlert:self];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	if ([_delegate respondsToSelector:@selector(tableAlert:willDismissWithButtonIndex:)])
		[_delegate tableAlert:self willDismissWithButtonIndex:buttonIndex];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	_isPresented = NO;
	if ([_delegate respondsToSelector:@selector(tableAlert:didDismissWithButtonIndex:)])
		[_delegate tableAlert:self didDismissWithButtonIndex:buttonIndex];
}

@end
