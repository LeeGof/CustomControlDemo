/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： DBHelper.h
 * 内容摘要： 数据库操作类，用于新建数据库、数据库表，增、删、改、查数据表
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年8月26日
 * 说   明： 
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import <UIKit/UIKit.h>

@class FMDatabase;
@class FMResultSet;
@interface DBHelper : NSObject
{
    FMDatabase      *_db;  // 数据库操作对象
}

- (FMResultSet *)executeQuery:(NSString *)strSql;  // 查询
- (BOOL)executeUpdate:(NSString *)strSql;  // 增、删、改
- (NSString *)stringForQuery:(NSString *)strSql;  // 常用于返回sql执行查询后，返回的记录数

@end
