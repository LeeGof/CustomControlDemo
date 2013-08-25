/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： WebServicesHelper.h
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

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@protocol WebServicesDelegate;
@interface WebServicesHelper : NSObject<ASIHTTPRequestDelegate>
{
    NSString                        *_strServiceURL;
    id<WebServicesDelegate>         _delegate;
}

@property (nonatomic,assign) id<WebServicesDelegate> delegate;
@property (nonatomic,retain) NSString *strServiceURL;

//==============================================================================
//业务相关函数
- (NSString *)getWeatherBySync:(NSString *)strCityCode;  // 同步方式获取天气数据
- (void)getWeatherByAsync:(NSString *)strCityCode;   // 异步方式获取天气数据

//==============================================================================
// WebService相关调用
- (NSString *)doWebService:(NSString *)strBody postURL:(NSString *)strUrl getMode:(NSString *)strMode; // 同步调用
- (void)doWebServiceAsyn:(NSString *)strBody postURL:(NSString *)strUrl getMode:(NSString *)strMode;  // 异步调用
- (void) dataAnalysis:(NSString *)strBackData;  // 异步调用后的数据解析

@end

//==============================================================================
// WebService的回传委托
@protocol WebServicesDelegate
@optional
- (void)requestSucceed:(id)data;
- (void)requestError:(NSError *)error;
@end
