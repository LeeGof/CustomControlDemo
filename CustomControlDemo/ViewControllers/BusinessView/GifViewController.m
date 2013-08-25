//
//  GifViewController.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-9-23.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "GifViewController.h"
#import "GifView.h"

@interface GifViewController ()

@end

@implementation GifViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 本地图片 
    NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"run" ofType:@"gif"]]; 
    
    GifView *dataView = [[GifView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) data:localData];  
    [self.view addSubview:dataView];
    [dataView release];
    
    // 或者
    GifView *pathView =[[GifView alloc] initWithFrame:CGRectMake(100, 0, 100, 100) filePath:[[NSBundle mainBundle] pathForResource:@"run" ofType:@"gif"]];
    [self.view addSubview:pathView];
    [pathView release];
    
    //2. webView   
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"run" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 120, 100, 100)];
    webView.backgroundColor = [UIColor redColor];
    webView.scalesPageToFit = YES;
    [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    [self.view addSubview:webView];
    [webView release];
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

@end
