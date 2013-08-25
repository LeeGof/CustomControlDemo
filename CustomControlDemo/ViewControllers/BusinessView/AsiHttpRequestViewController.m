//
//  AsiHttpRequestViewController.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-9-5.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "AsiHttpRequestViewController.h"

@interface AsiHttpRequestViewController ()
{
    UITextView      *_tvResult;
}
@end

@implementation AsiHttpRequestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //异步请求
    UIButton *btnAsync = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnAsync setFrame:CGRectMake(10, 20, 300, 30)];
    [btnAsync setTitle:NSLocalizedString(@"asynchronous", nil) forState:UIControlStateNormal];
    btnAsync.tag = 1000;
    [btnAsync addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnAsync];
    
    //同步请求
    UIButton *btnSync = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnSync setFrame:CGRectMake(10, 60, 300, 30)];
    [btnSync setTitle:NSLocalizedString(@"synchronous", nil) forState:UIControlStateNormal];
    btnSync.tag = 1001;
    [btnSync addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSync];
    
    _tvResult = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, 300, 340)];
    _tvResult.editable = NO;
    [self.view addSubview:_tvResult];
    [_tvResult release];
    
    webServicesHelper = [[WebServicesHelper alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    if (webServicesHelper) 
    {
        [webServicesHelper release];
        webServicesHelper = nil;
    }
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - btnClick
- (void)btnClick:(id)sender
{
    UIButton *btnSel = (UIButton *)sender;
    switch (btnSel.tag) 
    {
        case 1000:  //异步请求
        {
            webServicesHelper.delegate = self;
            [webServicesHelper getWeatherByAsync:@"101010100"];
            
            break;
        }
        case 1001:  //同步请求
        {
            _tvResult.text = [NSString stringWithFormat:@"%@",[webServicesHelper getWeatherBySync:@"101010100"]];
            
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark WebServicesDelegate
-(void)requestSucceed:(id)data 
{
    //    [webServicesHelper release];
    //在此处进行数据处理......
    NSMutableDictionary *dicResult = (NSMutableDictionary *)data;
    
    _tvResult.text = [NSString stringWithFormat:@"%@",dicResult];
}

//出现错误时调用
-(void)requestError:(NSError *)error
{
    //    [webServicesHelper release];
}

@end
