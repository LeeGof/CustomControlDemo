/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： TimeHelper.h
 * 内容摘要： 时间操作类。
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年8月26日
 * 说   明： 
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import <Foundation/Foundation.h>

@interface TimeHelper : NSObject

+ (NSDate *)getNowDate;  // 获取当前时间
+ (NSDate *)dateFromString:(NSString *)dateString;  // 字符串转成日期类型
+ (NSString *)stringFromDate:(NSDate *)date;  // 日期类型转成字符串
+ (NSString *)intervalSinceNow: (NSString *) theDate;  // 指定时间和当前时间的间隔

@end
