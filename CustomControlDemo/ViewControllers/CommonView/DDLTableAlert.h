/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： DDLTableAlert.h
 * 内容摘要： 本功能类主要提供alert方式的选择框效果
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年8月23日
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import <Foundation/Foundation.h>
#define kTableCornerRadius 5.

//==============================================================================

/*******************************************************************************
 * 内容摘要：选择框的选择方式，有单选和多选两种
 ******************************************************************************/
typedef enum
{
    DDLTableAlertTypeSingleSelect,  //单选
    DDLTableAlertTypeMultipleSelect,  //多选
}DDLTableAlertType;

//==============================================================================

/*******************************************************************************
 * 内容摘要：选择框的delegate
 ******************************************************************************/
@class DDLTableAlert;
@protocol DDLTableAlertDelegate <NSObject>
@optional
- (CGFloat)tableAlert:(DDLTableAlert *)tableAlert heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableAlert:(DDLTableAlert *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableAlertCancel:(DDLTableAlert *)tableAlert;

- (void)tableAlert:(DDLTableAlert *)tableAlert clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)willPresentTableAlert:(DDLTableAlert *)tableAlert;
- (void)didPresentTableAlert:(DDLTableAlert *)tableAlert;

- (void)tableAlert:(DDLTableAlert *)tableAlert willDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)tableAlert:(DDLTableAlert *)tableAlert didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end

@protocol DDLTableAlertDataSource <NSObject>
@required

- (UITableViewCell *)tableAlert:(DDLTableAlert *)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableAlert:(DDLTableAlert *)tableAlert numberOfRowsInSection:(NSInteger)section;

@optional

- (NSInteger)numberOfSectionsInTableAlert:(DDLTableAlert *)tableAlert; // default 1
- (NSString *)tableAlert:(DDLTableAlert *)tableAlert titleForHeaderInSection:(NSInteger)section;

@end

//==============================================================================

/*******************************************************************************
 * 内容摘要：DDLTableAlert的定义
 ******************************************************************************/
@interface DDLTableAlert : NSObject <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {}

@property (nonatomic, retain) UIAlertView *alertView;  //弹出框
@property (nonatomic, retain) UITableView *tableView;  //弹出框里的tableview
@property (nonatomic) DDLTableAlertType type;  //下拉框类型 
@property (nonatomic) NSInteger maximumVisibleRows; // 可显示的行数量，默认为4
@property (nonatomic) CGFloat rowHeight; // 行高，默认为40

@property (nonatomic, assign) id <DDLTableAlertDelegate> delegate; 
@property (nonatomic, assign) id <DDLTableAlertDataSource> dataSource;

@property (nonatomic, assign) id <UITableViewDelegate> tableViewDelegate; // tableview的委托
@property (nonatomic, assign) id <UITableViewDataSource> tableViewDataSource; // tableview的数据源
@property (nonatomic, assign) id <UIAlertViewDelegate> alertViewDelegate; // 弹出框委托

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle messageFormat:(NSString *)message, ...;
+ (id)alertWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle messageFormat:(NSString *)message, ...;

- (void)show;

@end
