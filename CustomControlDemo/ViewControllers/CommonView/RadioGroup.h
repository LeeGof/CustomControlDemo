/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： RadioGroup.h
 * 内容摘要： 本功能类主要提供单选框组的实现和处理
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年8月20日
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import <Foundation/Foundation.h>
#import "CheckButton.h"

@interface RadioGroup : NSObject 
{
    int                     _iSelectSerial;  // 当前选中单选框的序号,从0开始计数
    int                     _iValue;  // 当前选中单选框的value值
	NSString                *_strSelText;  // 当前选中单选框的文本框值
    NSMutableArray          *_arrRadioButton;  //存放单选框的数组
}

@property (nonatomic, assign) int iSelectSerial;
@property (nonatomic, readonly) int iValue;
@property (nonatomic, copy) NSString* strSelText;
@property (nonatomic, retain) NSMutableArray *arrRadioButton;

- (void)addRadio:(CheckButton *)newRadio;

@end
