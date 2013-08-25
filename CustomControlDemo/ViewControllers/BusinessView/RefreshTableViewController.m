//
//  RefreshTableViewController.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-9-7.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "RefreshTableViewController.h"
#import "RefreshTableView.h"

@interface RefreshTableViewController ()<RefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray              *_arrList;
}

@property (nonatomic, retain) RefreshTableView *tableView;
@property (nonatomic, retain) NSMutableArray *arrList;
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, assign) NSInteger page;

@end

@implementation RefreshTableViewController
@synthesize tableView = _tableView;
@synthesize arrList = _arrList;
@synthesize refreshing = _refreshing;
@synthesize page = _page;

#pragma mark - 生命周期函数

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    _arrList = [[NSMutableArray alloc] init];
    
    CGRect bounds = self.view.bounds;
    bounds.size.height -= 44.f;
    _tableView = [[RefreshTableView alloc] initWithFrame:bounds pullingDelegate:self];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.headerOnly = YES;
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if (self.page == 0) 
    {
        [self loadData];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [_tableView release];
    
    [super dealloc];
}

#pragma mark - 自定义函数

- (void)loadData
{
    self.page++;
    if (self.refreshing) 
    {
        self.page = 1;
        self.refreshing = NO;
        [self.arrList removeAllObjects];
    }
    for (int i = 0; i < 10; i++) 
    {
        [self.arrList addObject:@"ROW"];
    }
    if (self.page >= 3) 
    {
        [self.tableView tableViewDidFinishedLoadingWithMessage:@"All loaded!"];
        self.tableView.reachedTheEnd  = YES;
    } 
    else 
    {        
//        [self.tableView tableViewDidFinishedLoading];
        [self.tableView tableViewDidFinishedLoadingWithMessage:@"加载了10条数据"];
        self.tableView.reachedTheEnd  = NO;
        [self.tableView reloadData];
    }
}

#pragma mark - TableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"I'm cell %d",indexPath.row];
    return cell;
}

#pragma mark TableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"=========");
}

#pragma mark - PullingRefreshTableViewDelegate

- (void)tableViewDidStartRefreshing:(RefreshTableView *)tableView
{
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

- (NSDate *)tableViewRefreshingFinishedDate
{
    return [NSDate date];
}

- (void)tableViewDidStartLoading:(RefreshTableView *)tableView
{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];    
}

#pragma mark - Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tableView tableViewDidEndDragging:scrollView];
}

@end
