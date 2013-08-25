/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： WebServicesHelper.m
 * 内容摘要： 通过ASIHTTPRequest实现的Web Services。
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年8月31日
 * 说   明： 
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import "WebServicesHelper.h"
#import "Constants.h"
#import "JSON.h"
#import "CheckNetwork.h"
#import "ConfigHelper.h"

@implementation WebServicesHelper

@synthesize delegate = _delegate;
@synthesize strServiceURL = _strServiceURL;

//==============================================================================
#pragma mark - 初始化和资源释放

/*******************************************************************************
 * 方法名称：init
 * 功能描述：对象初始化
 * 输入参数：
 * 输出参数：
 ******************************************************************************/
- (id)init
{
    if (self = [super init]) 
    {
        [ConfigHelper createConfig:CONFIG_FILE_NAME];
        self.strServiceURL = [ConfigHelper getValueForKey:@"WeatherServerUrl" fileName:CONFIG_FILE_NAME];
    }
    
    return self;
}

/*******************************************************************************
 * 方法名称：dealloc
 * 功能描述：对象释放
 * 输入参数：
 * 输出参数：
 ******************************************************************************/
- (void)dealloc
{
//    if (_strServiceURL) 
//    {
//        [_strServiceURL release];
//        self.strServiceURL = nil;
//    }
    
    [super dealloc];
}

//==============================================================================
#pragma mark - 业务相关函数

/*******************************************************************************
 * 方法名称：getWeatherBySync:
 * 功能描述：同步方式获取天气数据
 * 输入参数：
    strCityCode：城市编号
 * 输出参数：天气参数
 ******************************************************************************/
- (NSString *)getWeatherBySync:(NSString *)strCityCode
{
    NSString *strResult = [self doWebService:@"" postURL:[NSString stringWithFormat:@"%@/%@.html", _strServiceURL, strCityCode] getMode:@"GET"];

    return strResult;
}

/*******************************************************************************
 * 方法名称：getWeatherByAsync:
 * 功能描述：异步方式获取天气数据
 * 输入参数：
    strCityCode：城市编号
 * 输出参数：
 ******************************************************************************/
- (void)getWeatherByAsync:(NSString *)strCityCode
{
    
    [self doWebServiceAsyn:@"" postURL:[NSString stringWithFormat:@"%@/%@.html", _strServiceURL, strCityCode] getMode:@"GET"];
}

//==============================================================================
#pragma mark - WebServices调用

/*******************************************************************************
 * 方法名称：doWebService:postURL:getMode
 * 功能描述：同步方式调用WebServices
 * 输入参数：
    strBody：请求发送的数据
    strUrl：请求的地址
    strMode：请求的方式，分为GET和POST两种方式
 * 输出参数：根据请求信息返回的数据
 ******************************************************************************/
- (NSString *)doWebService:(NSString *)strBody postURL:(NSString *)strUrl getMode:(NSString *)strMode
{
	if (![CheckNetwork isExistenceNetwork]) 
    {
		return @"";
	}
	
	//显示网络活动指示器
	UIApplication *app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = !app.networkActivityIndicatorVisible;
	
	//post数据
	NSString *postMsg = [NSString stringWithFormat:@"%@",strBody];
	
	//封装post请求
	NSURL *url = [NSURL URLWithString:strUrl];	
	ASIHTTPRequest *theRequest = [ASIHTTPRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d",[postMsg length]];
	
	//设置请求头信息
//	[theRequest addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=UTF-8"];
    [theRequest addRequestHeader:@"Content-Type" value:@"application/json"];  //返回为json数据
	[theRequest addRequestHeader:@"Content-Length" value:msgLength];
	[theRequest setRequestMethod:strMode];
	[theRequest setPostBody:[NSMutableData dataWithData:[postMsg dataUsingEncoding:NSUTF8StringEncoding]]];
	
	//超时
	[theRequest setTimeOutSeconds:NETWORK_TIMEOUT];
	
	//隐藏网络活动指示器
	app.networkActivityIndicatorVisible = !app.networkActivityIndicatorVisible;
	
	//同步数据返回
	[theRequest startSynchronous];
	NSError *error = [theRequest error];
	if (!error) 
    {
		return [theRequest responseString];
	}
    else 
    {
		return @"";
	}
}

/*******************************************************************************
 * 方法名称：doWebServiceAsyn:postURL:getMode
 * 功能描述：异步方式调用WebServices
 * 输入参数：
    strBody：请求发送的数据
    strUrl：请求的地址
    strMode：请求的方式，分为GET和POST两种方式
 * 输出参数：
 ******************************************************************************/
- (void)doWebServiceAsyn:(NSString *)strBody postURL:(NSString *)strUrl getMode:(NSString *)strMode
{
	
	if (![CheckNetwork isExistenceNetwork]) 
    {
		[_delegate requestError:nil];
		return;
	}
	
	//显示网络活动指示器
	UIApplication *app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = !app.networkActivityIndicatorVisible;
	
	//post数据
	NSString *postMsg = [NSString stringWithFormat:@"%@",strBody];
	//封装post请求
	NSURL *url = [NSURL URLWithString:strUrl];	
	ASIHTTPRequest *theRequest = [ASIHTTPRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d",[postMsg length]];
	
	//设置请求头信息
    //	[theRequest addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];  //返回为xml数据
    [theRequest addRequestHeader:@"Content-Type" value:@"application/json"];  //返回为json数据
	[theRequest addRequestHeader:@"Content-Length" value:msgLength];
	[theRequest setRequestMethod:strMode];
	[theRequest setPostBody:[NSMutableData dataWithData:[postMsg dataUsingEncoding:NSUTF8StringEncoding]]];
    
	//超时
	[theRequest setTimeOutSeconds:NETWORK_TIMEOUT];
	
	//设置回调方法
	theRequest.delegate = self;
	[theRequest startAsynchronous];
}

/*******************************************************************************
 * 方法名称：dataAnalysis:
 * 功能描述：异步回调数据处理
 * 输入参数：
    strBackData：异步调用后服务器的返回数据
 * 输出参数：
 ******************************************************************************/
-(void) dataAnalysis:(NSString *)strBackData{
    NSMutableDictionary *data =[strBackData JSONValue];
    [_delegate requestSucceed:data];
    return;
}

//==============================================================================
#pragma mark - ASIHTTPRequestDelegate
/*******************************************************************************
 * 方法名称：requestFinished:
 * 功能描述：异步调用后，服务器返回成功的处理函数
 * 输入参数：
    request：ASIHTTPRequest对象
 * 输出参数：
 ******************************************************************************/
- (void)requestFinished:(ASIHTTPRequest *)request
{
	//显示网络活动指示器
	UIApplication *app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = !app.networkActivityIndicatorVisible;
	
	NSString *responseString = [request responseString];
	[self dataAnalysis:responseString];
}

/*******************************************************************************
 * 方法名称：requestFailed:
 * 功能描述：异步调用后，服务器返回失败的处理函数
 * 输入参数：
    request：ASIHTTPRequest对象
 * 输出参数：
 ******************************************************************************/
- (void)requestFailed:(ASIHTTPRequest *)request
{
	//显示网络活动指示器
	UIApplication *app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = !app.networkActivityIndicatorVisible;
	
	[_delegate requestError:nil];
}

@end
