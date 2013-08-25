//
//  DownloadAndUnzipViewController.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-9-13.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "DownloadAndUnzipViewController.h"
//#import "ASIHTTPRequest.h"
#import "ProgressView.h"
#import "Constants.h"

@interface NationObj : NSObject
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *fileType;
@property(nonatomic, copy)NSString *url;
@end

@implementation NationObj
@synthesize name, fileType, url;
-(id)init{
    if (self = [super init]) {        
        self.name = @"7za920";
        self.fileType = @"zip";
        self.url = @"http://downloads.sourceforge.net/sevenzip/7za920.zip";
        
        //        self.name = @"44610";
        //        self.fileType = @"mp3";
        //        self.url = @"http://www.plcsky.com:888/yl/ylsx/ljsy/images/2008/12/23/44610.mp3";
    }
    return self;
}
@end

@interface DownloadAndUnzipViewController ()
{
    NationObj       *_obj;
    DownloadHandler *_downloadHanlder;
    UIButton        *_btnDownload;
}

@end

@implementation DownloadAndUnzipViewController
@synthesize progressView = _progressView;

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
    
    _obj = [[NationObj alloc] init];
	_btnDownload = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnDownload.frame = CGRectMake(0, 0, 100, 50);
    _btnDownload.center = CGPointMake(160, 240);
    [_btnDownload setTitle:@"下载" forState:UIControlStateNormal];
    [_btnDownload addTarget:self action:@selector(downloadContent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnDownload];
}

- (void)viewDidUnload
{
    self.progressView = nil;
    
    [super viewDidUnload];
}

- (void)dealloc
{
    if (_progressView) 
    {
        [_progressView release];
    }
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)downloadContent
{
    _downloadHanlder = [DownloadHandler sharedInstance];
    _downloadHanlder.strUrl = @"http://downloads.sourceforge.net/sevenzip/7za920.zip";
    _downloadHanlder.strFileType = @"zip";
    _downloadHanlder.strFilename = @"aa";
    _downloadHanlder.strSavePath = DOCUMENTS_FOLDER;
    _downloadHanlder.delegate = self;
    [self startProgress];
    [_downloadHanlder startDownload];
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

#pragma mark -
#pragma mark DownloadHandlerDelegate
-(void)requestSucceed:(id)data 
{
    [self performSelector:@selector(endProgress) withObject:nil afterDelay:1.0f];
}

//出现错误时调用
-(void)requestError:(NSError *)error
{
    [self performSelector:@selector(endProgress) withObject:nil afterDelay:1.0f];
}

@end
