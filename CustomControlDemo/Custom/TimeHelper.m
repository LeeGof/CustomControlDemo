/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： TimeHelper.m
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

#import "TimeHelper.h"

@implementation TimeHelper

/*******************************************************************************
 * 方法名称：getNowDate
 * 功能描述：获取当前时间
 * 输入参数：
 * 输出参数：返回当前时间
 ******************************************************************************/
+ (NSDate *) getNowDate
{
	NSTimeZone *zone = [NSTimeZone defaultTimeZone];//获得当前应用程序的默认时区
	NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];//以秒为单位返回当前应用程序与世界标准时间的时差
	NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:interval];
	return nowDate;
}

/*******************************************************************************
 * 方法名称：stringFromDate
 * 功能描述：字符串转成日期类型
 * 输入参数：
    date：NSDate格式的时间
 * 输出参数：返回NSString格式的时间
 ******************************************************************************/
+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDate=[dateFormatter stringFromDate:date];
    [dateFormatter release];
    
    return destDate;
    
}

/*******************************************************************************
 * 方法名称：dateFromString
 * 功能描述：字符串转成日期类型
 * 输入参数：
    dateString：字符串格式的时间
 * 输出参数：返回NSDate格式的时间
 ******************************************************************************/
+ (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate=[dateFormatter dateFromString:dateString];
    [dateFormatter release];
    return destDate;
}

/*******************************************************************************
 * 方法名称：intervalSinceNow
 * 功能描述：指定时间和当前时间的间隔
 * 输入参数：
    theDate：字符串格式的时间
 * 输出参数：返回指定时间和当前时间的间隔
 ******************************************************************************/
+ (NSString *)intervalSinceNow: (NSString *) theDate 
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
        
    }
    [date release];
    return timeString;
}

@end
