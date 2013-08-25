/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： CheckButton.h
 * 内容摘要： 本功能类主要提供单选框和复选框效果
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年8月19日
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    CheckButtonStyleDefault = 0,
    CheckButtonStyleBox = 1,
    CheckButtonStyleRadio = 2
}CheckButtonStyle;

@interface CheckButton : UIControl 
{
    BOOL                    _isChecked;  // 是否选中
    BOOL                    _isEnable;  // 是否可用
    NSString                *_strChkName;  // 选中时的图片名称
    NSString                *_strUnChkName;  // 未选中时的图片名称
    CGRect                  _frame;  // 本view的frame
    int                     _iGap;  // 选择框图标和文本之间的空隙
}
@property (assign, nonatomic) id delegate;  
@property (assign, nonatomic) int iValue;  
@property (retain, nonatomic) UILabel *lblTitle;
@property (retain, nonatomic) UIImageView* imgIcon;
@property (assign, nonatomic, getter = checked, setter = setChecked:) BOOL isChecked;
@property (assign, nonatomic, getter = enable, setter = setEnable:) BOOL isEnable;
@property (assign, nonatomic) CheckButtonStyle style;

-(void)resizeFrameToRect:(CGRect)rect;

@end
