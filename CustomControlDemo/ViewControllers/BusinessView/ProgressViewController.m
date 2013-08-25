//
//  ProgressViewController.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-23.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "ProgressViewController.h"
#import "ProgressView.h"
#import "Loading.h"

@interface ProgressViewController ()
- (void)btnClicked:(id)sender;
@end

@implementation ProgressViewController
@synthesize progressView = _progressView;

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
    
    UIButton *btnType1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnType1 setFrame:CGRectMake(10, 10, 300, 30)];
    btnType1.tag = 1000;
    [btnType1 setTitle:NSLocalizedString(@"type1", nil) forState:UIControlStateNormal];
    [btnType1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnType1];

    UIButton *btnType2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnType2 setFrame:CGRectMake(10, 50, 300, 30)];
    btnType2.tag = 1001;
    [btnType2 setTitle:NSLocalizedString(@"type2", nil) forState:UIControlStateNormal];
    [btnType2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnType2];
}

- (void)viewDidUnload
{
    self.progressView = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    if (_progressView) {
        [_progressView release];
    }
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)btnClicked:(id)sender
{
    UIButton *btnSender = (UIButton *)sender;
    switch (btnSender.tag) {
        case 1000:
        {
            [self startProgress];
            [self performSelector:@selector(endProgress) withObject:nil afterDelay:1.0f];
            break;
        }
        case 1001:
        {
            [self startLoading];
            [self performSelector:@selector(endLoading) withObject:nil afterDelay:1.0f];
            break;
        }
        default:
            break;
    }
}

- (void)startProgress
{
    _progressView = [[ProgressView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    [_progressView.activeView startAnimating];
    
    [self.view addSubview:_progressView];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate distantPast]];
}

- (void)endProgress
{
    [_progressView.activeView stopAnimating];
    [_progressView removeFromSuperview];
}

- (void)startLoading
{
    //初始化进度条效果
    Loading *loading=[[Loading alloc] init];
    [loading startLoading:self.view title:NSLocalizedString(@"loading", @"")];
    [loading release];
}

- (void)endLoading
{
    //停止进度条效果
    Loading *loading=[[Loading alloc] init];
    [loading stopLoading:self.view];
    [loading release];
}

@end
