/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： ConfigHelper.h
 * 内容摘要： 用于操作配置文件
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

@interface ConfigHelper : NSObject

+ (void)createConfig:(NSString *)strFileName;

+ (NSString *)getValueForKey:(NSString *)strKey fileName:(NSString *)strFileName;

+ (void)setValue:(NSString *)strValue forKey:(NSString *)strKey fileName:(NSString *)strFileName;

+ (void)removeAllKeyFromConfig:(NSString *)strFileName;

+ (void)removeKey:(NSString *)strKey fileName:(NSString *)strFileName;

@end
