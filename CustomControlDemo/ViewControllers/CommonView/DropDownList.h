/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： DropDownList.h
 * 内容摘要： 本功能类主要下拉列表框效果
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年8月21日
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import <UIKit/UIKit.h>

@interface DropDownList : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UITextField         *_txtSelect;  // 文本框
    UITableView         *_tblListView;  // 下拉数据的表格
    UIButton            *_btnDownOrUp;  // 标识下拉的图标
    
    UIColor             *_borderColor;  // 下拉表格的边框颜色
    UIColor             *_backColor;  // 下拉表格的背景颜色
    CGFloat             _borderWidth;  // 下拉表格的边框粗细
    CGRect              _upFrame;  // 没有下拉时本view的frame
    CGRect              _downFrame;  // 下拉时本view的frame
    UITextBorderStyle   _borderStyle;  // 文本框的样式
    
    int                 _iSelectSerial;  // 当前选中下拉框的序号,从0开始计数
    NSArray             *_arrListData;  // 下拉列表框数据
    BOOL                _isShowList;  // 下拉列表框是否显示
}

@property (nonatomic, retain) UITextField *txtSelect;

@property (nonatomic, assign) int iSelectSerial;
@property (nonatomic, retain) NSArray *arrListData;

- (void) setShowList:(BOOL)isShow;

@end
