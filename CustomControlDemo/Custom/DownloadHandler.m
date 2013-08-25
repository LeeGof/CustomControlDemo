/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： DownloadHandler.m
 * 内容摘要： 下载管理类。
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年9月13日
 * 说   明： 
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import "DownloadHandler.h"
#import "ZipArchive.h"

static DownloadHandler *sharedDownloadhandler = nil;

@implementation DownloadHandler
{
    ASIHTTPRequest      *_request;
    ASINetworkQueue     *_queue;
    NSString            *_pathOfTmp;
    UILabel             *_label;
    unsigned long long  _dataSize;
}

@synthesize strUrl = _strUrl;
@synthesize strFilename = _strFilename;
@synthesize strFileType = _strFileType;
@synthesize strSavePath = _strSavePath;
@synthesize delegate = _delegate;

/*******************************************************************************
 * 方法名称：sharedInstance
 * 功能描述：获取DownloadHandler实例
 * 输入参数：
 * 输出参数：返回DownloadHandler实例
 ******************************************************************************/
+ (DownloadHandler *)sharedInstance
{
    if (!sharedDownloadhandler) 
    {
        sharedDownloadhandler = [[DownloadHandler alloc] init];
    }
    return sharedDownloadhandler;
}

/*******************************************************************************
 * 方法名称：init
 * 功能描述：初始化
 * 输入参数：
 * 输出参数：返回DownloadHandler实例
 ******************************************************************************/
- (id)init
{
    if (self = [super init]) 
    {
        if (!_queue) 
        {
            _queue = [[ASINetworkQueue alloc] init];
            _queue.showAccurateProgress = YES;
            _queue.shouldCancelAllRequestsOnFailure = NO;
            [_queue go];
        }
    }
    return self;
}

#pragma mark - 自定义方法

- (void)startDownload
{
    for (ASIHTTPRequest *r in [_queue operations]) 
    {
        NSString *fileName = [r.userInfo objectForKey:@"Name"];
        if ([fileName isEqualToString:_strFilename]) 
        {
            return;  //队列中已存在特定request时，退出
        }
    }
    
    NSURL *url = [NSURL URLWithString:_strUrl];
    _request = [ASIHTTPRequest requestWithURL:url];
    _request.delegate = self;
    _request.temporaryFileDownloadPath = [self cachesPath];
    _request.downloadDestinationPath = [self actualSavePath];
    _request.allowResumeForFileDownloads = YES;
    _request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:_strFilename, @"Name", nil];
    [_queue addOperation:_request];
}

- (NSString *)actualSavePath
{
    return [_strSavePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", _strFilename, _strFileType]];
}

- (NSString *)cachesPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", _strFilename, _strFileType]];
    return path;
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
//    NSLog(@"total size: %lld", request.contentLength);
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if ([_strFileType isEqualToString:@"zip"]) 
    {
        [self unzipFile];
    }
    [_delegate requestSucceed:nil];
    [self removeRequestFromQueue];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
    [_delegate requestError:nil];
    [self removeRequestFromQueue];
}

- (void)removeRequestFromQueue
{
    for (ASIHTTPRequest *r in [_queue operations]) 
    {
        NSString *fileName = [r.userInfo objectForKey:@"Name"];
        if ([fileName isEqualToString:_strFilename]) 
        {
            [r clearDelegatesAndCancel];
        }
    }
}

- (void)unzipFile
{
    NSString *unzipPath = [_strSavePath stringByAppendingPathComponent:_strFilename];
    ZipArchive *unzip = [[ZipArchive alloc] init];
    if ([unzip UnzipOpenFile:[self actualSavePath]]) 
    {
        BOOL result = [unzip UnzipFileTo:unzipPath overWrite:YES];
        if (result) 
        {
            NSLog(@"unzip successfully");
        }
        [unzip UnzipCloseFile];
    }
    [unzip release];
    unzip = nil;
}

- (void)dealloc
{
    [_queue release];
    _queue = nil;
    [_label release];
    _label = nil;
    
    [super dealloc];
}

@end
