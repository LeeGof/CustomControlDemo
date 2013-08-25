/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： EncryptDecryptHelper.h
 * 内容摘要： 本类主要提供加解密方法的封装。
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年9月3日
 * 说   明： 
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import <Foundation/Foundation.h>

@interface EncryptDecryptHelper : NSObject

+ (NSString *)aesEncrypt:(NSString *)strSource forKey:(NSString *)strKey;
+ (NSString *)aesDecrypt:(NSString *)strSource forKey:(NSString *)strKey;
+ (NSString *) md5:(NSString *)strSource;
+ (NSString*) sha1:(NSString*)strSource;

@end
