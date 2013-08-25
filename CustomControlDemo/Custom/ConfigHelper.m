/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： ConfigHelper.m
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

#import "ConfigHelper.h"
#import "Constants.h"

@implementation ConfigHelper

/*******************************************************************************
 * 方法名称：createConfig
 * 功能描述：创建配置文件
 * 输入参数：
 * 输出参数：
 ******************************************************************************/

+ (void)createConfig:(NSString *)strFileName
{
    // 创建时间戳配置文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:GETFILEFULLPATH(strFileName)]) 
    {
        NSString *defaultStorePath=[[NSBundle mainBundle] pathForResource:CONFIG_FILE_NAME ofType:@"plist"];
        
        if (defaultStorePath) 
        {
            [fileManager copyItemAtPath:defaultStorePath toPath:GETFILEFULLPATH(strFileName) error:NULL];
        }
    }
}

/*******************************************************************************
 * 方法名称：getValueForKey:
 * 功能描述：根据配置文件的键值获取value值
 * 输入参数：
    strKey：配置文件的键值
 * 输出参数：配置文件的value值
 ******************************************************************************/
+ (NSString *)getValueForKey:(NSString *)strKey fileName:(NSString *)strFileName
{
    return [[NSMutableDictionary dictionaryWithContentsOfFile:GETFILEFULLPATH(strFileName)] objectForKey:strKey];
}

/*******************************************************************************
 * 方法名称：setValue:forKey
 * 功能描述：设置配置文件的键值对
 * 输入参数：
    strValue：配置文件的value值
    strKey  ：配置文件的键值
 * 输出参数：
 ******************************************************************************/
+ (void)setValue:(NSString *)strValue forKey:(NSString *)strKey fileName:(NSString *)strFileName
{
    NSMutableDictionary *config = [NSMutableDictionary dictionaryWithContentsOfFile:GETFILEFULLPATH(strFileName)];
    [config setObject:strValue forKey:strKey];
    [config writeToFile:GETFILEFULLPATH(strFileName) atomically:YES];
}

/*******************************************************************************
 * 方法名称：removeAllKeyFromConfig
 * 功能描述：清空配置文件
 * 输入参数：
 * 输出参数：
 ******************************************************************************/
+ (void)removeAllKeyFromConfig:(NSString *)strFileName
{
    NSMutableDictionary *config = [NSMutableDictionary dictionaryWithContentsOfFile:GETFILEFULLPATH(strFileName)];
    [config removeAllObjects];
    [config writeToFile:GETFILEFULLPATH(strFileName) atomically:YES];
}

/*******************************************************************************
 * 方法名称：removeKey:
 * 功能描述：删除指定的键值对
 * 输入参数：
    strKey：指定的键名称
 * 输出参数：
 ******************************************************************************/
+ (void)removeKey:(NSString *)strKey fileName:(NSString *)strFileName
{
    NSMutableDictionary *config = [NSMutableDictionary dictionaryWithContentsOfFile:GETFILEFULLPATH(strFileName)];
    [config removeObjectForKey:strKey];
    [config writeToFile:GETFILEFULLPATH(strFileName) atomically:YES];
}

@end
