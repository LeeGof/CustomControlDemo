/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： POAPinyin.h
 * 内容摘要： 本功能类主要为获取汉字的全拼
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年8月23日
 * 说   明： 该类为第三方提供，不是本人原创
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import <Foundation/Foundation.h>


@interface POAPinyin : NSObject {
    
}

+ (NSString *) convert:(NSString *) hzString;//输入中文，返回拼音。
+ (NSString *)quickConvert:(NSString *)hzString;
+ (void)clearCache;
+(NSString*) stringConvert:(NSString*)hzString;
@end
