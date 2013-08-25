/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： CheckButton.m
 * 内容摘要： 本功能类主要提供单选框和复选框效果
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年8月19日
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import "CheckButton.h"

@implementation CheckButton
@synthesize lblTitle;
@synthesize imgIcon;
@synthesize iValue;
@synthesize delegate;
@synthesize style;

#pragma mark - 页面初始化

/*******************************************************************************
 * 方法名称：初始化View
 * 功能描述：根据frame初始化本view
 * 输入参数：
    newFrame：本view的frame
 * 输出参数：CheckButton对象
 ******************************************************************************/
- (id)initWithFrame:(CGRect)newFrame
{
	if (self=[super initWithFrame:newFrame]) 
    {
        _frame = newFrame; 
        _iGap = 8;
        [self setStyle:CheckButtonStyleDefault];//默认风格为方框（多选）样式

        // 添加选择框的图标
        imgIcon = [[UIImageView alloc]initWithFrame:
              CGRectMake(0, 0, _frame.size.height, _frame.size.height)];
        [self addSubview:imgIcon];
        
        //添加选择框的文本框
        lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(imgIcon.frame.size.width + _iGap, 0, 
                                      _frame.size.width - imgIcon.frame.size.width - _iGap,
                                     _frame.size.height)];
        lblTitle.backgroundColor=[UIColor clearColor];
        lblTitle.font=[UIFont systemFontOfSize:15];
        lblTitle.textColor=[UIColor blackColor];
        lblTitle.textAlignment = UITextAlignmentLeft;
        [self addSubview:lblTitle];
        
        [self addTarget:self action:@selector(viewClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _isEnable = YES;
        _isChecked = NO;
	}
	return self;
}

/*******************************************************************************
 * 方法名称：初始化子View
 * 功能描述：根据需要调整本view的文本框位置和大小，在初始化本view的时候调用
 * 输入参数：
 * 输出参数：
 ******************************************************************************/
- (void)layoutSubviews
{
    lblTitle.frame=CGRectMake(imgIcon.frame.size.width + _iGap, 0, 
                                  _frame.size.width - imgIcon.frame.size.width - _iGap,
                                                 _frame.size.height);
}

#pragma mark - 自定义方法

/*******************************************************************************
 * 方法名称：重新调整本view的位置和大小
 * 功能描述：外部调用方法，用于重新调整本view的位置和大小
 * 输入参数：
    rect：本view的frame
 * 输出参数：
 ******************************************************************************/
- (void)resizeFrameToRect:(CGRect)rect
{
	self.frame = rect;
	imgIcon.frame=CGRectMake(imgIcon.frame.origin.x, 
                             imgIcon.frame.origin.y, 
                             rect.size.height,
                             rect.size.height);
	lblTitle.frame=CGRectMake(lblTitle.frame.origin.x + _iGap, 
                              lblTitle.frame.origin.y,
                              rect.size.width-rect.size.height - _iGap,
                              rect.size.height);
}

/*******************************************************************************
 * 方法名称：本view单击时的响应事件
 * 功能描述：view单击时，会根据情况，设置参数值和view的显示
 * 输入参数：
    sender：本view
 * 输出参数：
 ******************************************************************************/
-(void)viewClicked:(id)sender
{
    if(_isEnable)
    {
        if (delegate != nil)  //如果使用了RadioGroup，需要实现特殊逻辑比如单选
        {
            SEL sel=NSSelectorFromString(@"radioButtonClicked:");
            if([delegate respondsToSelector:sel])
            {
                [delegate performSelector:sel withObject:sender]; 
            }  
        }
        else 
        {
            [self setChecked:!_isChecked];
        }
    }
}

#pragma mark - 属性

/*******************************************************************************
 * 方法名称：style属性的get方法
 * 功能描述：返回当前view的样式类别
 * 输入参数：
 * 输出参数：
    CheckButtonStyle：当前view的样式类别
 ******************************************************************************/
- (CheckButtonStyle)style
{
	return style;
}

/*******************************************************************************
 * 方法名称：style属性的set方法
 * 功能描述：设置当前view的样式类别
 * 输入参数：
    newStyle：当前view的样式类别
 * 输出参数：
 ******************************************************************************/
- (void)setStyle:(CheckButtonStyle)newStyle
{
	style = newStyle;
	switch (style) 
    {
		case CheckButtonStyleDefault:
			
		case CheckButtonStyleBox:
        {
			_strChkName = NSLocalizedString(@"checkselect", nil);
			_strUnChkName = NSLocalizedString(@"checknormal", nil);
			break;
        }
		case CheckButtonStyleRadio:
        {
			_strChkName = NSLocalizedString(@"radioselect", nil);
			_strUnChkName = NSLocalizedString(@"radionormal", nil);
			break;
        }
		default:
			break;
	}
	[self setChecked:_isChecked];
}

/*******************************************************************************
 * 方法名称：isEnable属性的get方法
 * 功能描述：返回当前view是否可用
 * 输入参数：
 * 输出参数：
    bool值：YES为可用；NO为不可用
 ******************************************************************************/
- (BOOL)enable
{
    return _isEnable;
}

/*******************************************************************************
 * 方法名称：isEnable属性的set方法
 * 功能描述：设置当前view是否可用
 * 输入参数：
    bool值：YES为可用；NO为不可用
 * 输出参数：
 ******************************************************************************/
- (void)setEnable:(BOOL)newEnable
{
    _isEnable = newEnable;
    if (!newEnable) 
    {
        [self setChecked:NO];
    }
}

/*******************************************************************************
 * 方法名称：isChecked属性的get方法
 * 功能描述：返回当前view是否选中
 * 输入参数：
 * 输出参数：
    bool值：YES为选中；NO为没选中
 ******************************************************************************/
-(BOOL)checked
{
	return _isChecked;
}

/*******************************************************************************
 * 方法名称：isChecked属性的set方法
 * 功能描述：设置当前view是否选中
 * 输入参数：
    bool值：YES为选中；NO为没选中
 * 输出参数：
 ******************************************************************************/
-(void)setChecked:(BOOL)newChecked
{
	if(_isEnable)  // 如果控件可用
    {
		_isChecked = newChecked;
		if (_isChecked) 
        {
			[imgIcon setImage:[UIImage imageNamed:_strChkName]];
		}
        else 
        {
			[imgIcon setImage:[UIImage imageNamed:_strUnChkName]];
		}
		
	}
    else
    {
        _isChecked=NO;
        [imgIcon setImage:[UIImage imageNamed:_strUnChkName]];
    }
}

@end
