/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： DownloadHandler.h
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

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@protocol DownloadHandlerDelegate;
@interface DownloadHandler : NSObject<ASIHTTPRequestDelegate, ASIProgressDelegate>
{
    id<DownloadHandlerDelegate>         _delegate;
}

@property(nonatomic, copy) NSString *strUrl;  // 下载资源的路径
@property(nonatomic, copy) NSString *strFilename;  // 下载资源的名称
@property(nonatomic, copy) NSString *strFileType;  // 下载资源的类型，即后缀
@property(nonatomic, copy) NSString *strSavePath;  // 下载保存路径
@property (nonatomic,assign) id<DownloadHandlerDelegate> delegate;

+ (DownloadHandler *)sharedInstance;
- (void)startDownload;

@end

//==============================================================================
// DownloadHandler的回传委托
@protocol DownloadHandlerDelegate
@optional
- (void)requestSucceed:(id)data;
- (void)requestError:(NSError *)error;
@end
