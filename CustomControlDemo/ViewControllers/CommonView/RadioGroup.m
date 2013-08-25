/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： RadioGroup.m
 * 内容摘要： 本功能类主要提供单选框组的实现和处理
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年8月20日
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import "RadioGroup.h"

@implementation RadioGroup
@synthesize strSelText = _strSelText;
@synthesize iValue = _iValue;
@synthesize arrRadioButton = _arrRadioButton;
@synthesize iSelectSerial = _iSelectSerial;

#pragma mark - 对象初始化

/*******************************************************************************
 * 方法名称：初始化
 * 功能描述：初始化RadioGroup对象
 * 输入参数：
 * 输出参数：RadioGroup对象
 ******************************************************************************/
- (id)init
{
	if (self=[super init])
    {
		_arrRadioButton = [[NSMutableArray alloc]init];
	}
	return self;
}

/*******************************************************************************
 * 方法名称：释放资源
 * 功能描述：释放资源
 * 输入参数：
 * 输出参数：
 ******************************************************************************/
-(void)dealloc{
    if (_strSelText) {
        [_strSelText release];
        self.strSelText = nil;
    }
	if (_arrRadioButton) {
        [_arrRadioButton release];
        self.arrRadioButton = nil;
    }
	
	[super dealloc];
}

#pragma mark - 自定义方法

/*******************************************************************************
 * 方法名称：添加控件
 * 功能描述：添加CheckButton到RadioGroup
 * 输入参数：
    newRadio：CheckButton对象
 * 输出参数：
 ******************************************************************************/
- (void)addRadio:(CheckButton *)newRadio
{
	newRadio.delegate=self;
	if (newRadio.checked) 
    {
		_strSelText = newRadio.lblTitle.text;
		_iValue = newRadio.iValue;
	}
	[_arrRadioButton addObject:newRadio];
}

/*******************************************************************************
 * 方法名称：单选控件的单击
 * 功能描述：响应单选控件的单击
 * 输入参数：
    sender：单击对象
 * 输出参数：
 ******************************************************************************/
- (void)radioButtonClicked:(id)sender
{
	CheckButton* currentCheckBtn=(CheckButton*)sender;
	if (NO == currentCheckBtn.checked) 
    {
		//实现单选
		for (int i = 0; i < _arrRadioButton.count; i++) 
        {
			CheckButton* checkBtn = (CheckButton *)[_arrRadioButton objectAtIndex:i];
			if (currentCheckBtn == checkBtn) 
            {
				_iSelectSerial = i;
				[checkBtn setChecked:YES];
				_strSelText = checkBtn.lblTitle.text;
				_iValue = checkBtn.iValue;
			}
            else 
            {
				[checkBtn setChecked:NO];
			}
		}
	}
}

@end
