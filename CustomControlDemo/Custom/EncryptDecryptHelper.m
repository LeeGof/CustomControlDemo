/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： EncryptDecryptHelper.m
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

#import "EncryptDecryptHelper.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "NSData+CommonCrypto.h"

@implementation EncryptDecryptHelper

//==============================================================================
#pragma mark - AES加密和解密

/*******************************************************************************
 * 方法名称：aesEncrypt:forKey:
 * 功能描述：AES加密
 * 输入参数：
    strSource：待加密的字符串
    strKey：加密所使用的key，可以理解为一个密钥，等会解密的时候也需要提供该密钥
 * 输出参数：加密后的字符串
 ******************************************************************************/
+ (NSString *)aesEncrypt:(NSString *)strSource forKey:(NSString *)strKey
{
    NSData *encryptedData = [[strSource dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptedDataUsingKey:[[strKey dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
    NSString *base64EncodedString = [NSString base64StringFromData:encryptedData length:[encryptedData length]];
    return base64EncodedString;
}

/*******************************************************************************
 * 方法名称：aesDecrypt:forKey:
 * 功能描述：AES解密
 * 输入参数：
    strSource：待解密的字符串
    strKey：必须和加密时使用strKey相同
 * 输出参数：解密后的字符串
 ******************************************************************************/
+ (NSString *)aesDecrypt:(NSString *)strSource forKey:(NSString *)strKey 
{
    NSData *encryptedData = [NSData base64DataFromString:strSource];
    NSData *decryptedData = [encryptedData decryptedAES256DataUsingKey:[[strKey dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
    
    return [[[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding] autorelease];
}

//==============================================================================
#pragma mark - MD5加密

/*******************************************************************************
 * 方法名称：md5:
 * 功能描述：MD5加密
 * 输入参数：
    strSource：待加密的字符串
 * 输出参数：加密后的字符串
 ******************************************************************************/
+ (NSString *) md5:(NSString *)strSource
{
    const char *cStr = [strSource UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//==============================================================================
#pragma mark - SHA1加密

/*******************************************************************************
 * 方法名称：sha1:
 * 功能描述：SHA1加密
 * 输入参数：
    strSource：待加密的字符串
 * 输出参数：加密后的字符串
 ******************************************************************************/
+ (NSString*) sha1:(NSString*)strSource
{
    const char *cstr = [strSource cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:strSource.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return [output uppercaseString];
}

//==============================================================================

@end
