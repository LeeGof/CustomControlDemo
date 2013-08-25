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

#import "DBHelper.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseAdditions.h"
#import "Constants.h"

@implementation DBHelper

- (id)init
{
	if(self = [super init])
	{
		[self initDatabase];
	}
	
	return self;
}

/*******************************************************************************
 * 方法名称：initDatabase
 * 功能描述：打开数据库
 * 输入参数：
 * 输出参数：成功(返回YES);失败(返回NO)
 ******************************************************************************/
- (BOOL)initDatabase
{
    BOOL success = YES;  // 打开数据库是否成功
    NSString *wirtableDBPath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:DB_NAME];

    _db = [FMDatabase databaseWithPath:wirtableDBPath];    //创建或打开数据库实例db 
    if([_db open])
    {
        [_db setShouldCacheStatements:YES];
        
        [self initTable];
    }
    else
    {
        success=NO;
    }
    
    return success;
}

/*******************************************************************************
 * 方法名称：initTable
 * 功能描述：初始化数据库表
 * 输入参数：
 * 输出参数：
 ******************************************************************************/
- (void)initTable
{
    // 用户表
    if (![_db tableExists:TABLE_USER]) 
    {
        [_db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE %@(ID Integer PRIMARY KEY autoincrement,Name varchar(40),Phone varchar(40))",TABLE_USER]]; 
        
        [_db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@(Name,Phone) VALUES('李高峰','13800138000')", TABLE_USER]];
        [_db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@(Name,Phone) VALUES('张三','13800138000')", TABLE_USER]];
        [_db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@(Name,Phone) VALUES('李四','13800138000')", TABLE_USER]];
    }
}

/*******************************************************************************
 * 方法名称：executeQuery:
 * 功能描述：查询表纪录
 * 输入参数：
    strSql：查询语句，例如:select * from user;
 * 输出参数：返回结果集
 ******************************************************************************/
- (FMResultSet *)executeQuery:(NSString *)strSql
{
    return [_db executeQuery:strSql];
}

/*******************************************************************************
 * 方法名称：executeUpdate:
 * 功能描述：对表进行增、删、改操作
 * 输入参数：
    strSql：操作语句，例如:delete from user;
 * 输出参数：成功(返回YES);失败(返回NO)
 ******************************************************************************/
- (BOOL)executeUpdate:(NSString *)strSql
{
    BOOL isSuccess = YES;
    [_db executeUpdate:strSql];
    
    if ([_db hadError]) 
    {
		NSLog(@"Err %d: %@", [_db lastErrorCode], [_db lastErrorMessage]);
		isSuccess = NO;
	}
	return isSuccess;
}

/*******************************************************************************
 * 方法名称：stringForQuery:
 * 功能描述：查询表纪录，常用于返回表纪录数量(可用于判断纪录是否存在于表中)
 * 输入参数：
    strSql：操作语句，例如:delete from user;
 * 输出参数：以字符串的方式返回查询结果
 ******************************************************************************/
- (NSString *)stringForQuery:(NSString *)strSql
{
    return [_db stringForQuery:strSql];
}

-(void)dealloc
{
    [_db close];
    [_db release];
    [super dealloc];
}

@end
