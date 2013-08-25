/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： DropDownList.m
 * 内容摘要： 本功能类主要下拉列表框效果
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年8月21日
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import "DropDownList.h"
#import <QuartzCore/CALayer.h>

@implementation DropDownList
@synthesize txtSelect = _txtSelect;
@synthesize iSelectSerial = _iSelectSerial;
@synthesize arrListData = _arrListData;

#pragma mark - 对象初始化

/*******************************************************************************
 * 方法名称：初始化
 * 功能描述：初始化DropDownList对象
 * 输入参数：
    frame：DropDownList的frame
 * 输出参数：DropDownList对象
 ******************************************************************************/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isShowList = NO;
        _upFrame = frame;
        _downFrame = CGRectMake(_upFrame.origin.x, _upFrame.origin.y, _upFrame.size.width, _upFrame.size.height * 5);
        
        _borderWidth = 1;
        
        self.backgroundColor = [UIColor clearColor];
        [self drawView];
    }
    return self;
}

/*******************************************************************************
 * 方法名称：资源释放
 * 功能描述：资源释放
 * 输入参数：
 * 输出参数：
 ******************************************************************************/
- (void)dealloc
{
    if (_arrListData) {
        [_arrListData release];
    }
    
    [super dealloc];
}

#pragma mark - 自定义方法

/*******************************************************************************
 * 方法名称：绘制页面
 * 功能描述：绘制dropdownlist控件的内容
 * 输入参数：
 * 输出参数：
 ******************************************************************************/
- (void)drawView
{
    //文本框
    _txtSelect = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, _upFrame.size.width, _upFrame.size.height)];
    _txtSelect.borderStyle = UITextBorderStyleBezel;
    _txtSelect.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _txtSelect.enabled = NO;
    [self addSubview:_txtSelect];
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _upFrame.size.width, _upFrame.size.height)];
    [btnBack addTarget:self action:@selector(viewClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnBack];
    [btnBack release];
    
    _btnDownOrUp = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnDownOrUp setImage:[UIImage imageNamed:NSLocalizedString(@"ddldown", nil)] forState:UIControlStateNormal];
    [_btnDownOrUp setFrame:CGRectMake(_upFrame.size.width - 26, 0, 24, 24)];
    [_btnDownOrUp addTarget:self action:@selector(viewClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnDownOrUp];
    
    //下拉列表
    _tblListView = [[UITableView alloc]initWithFrame: CGRectMake(_borderWidth, _upFrame.size.height + _borderWidth, _upFrame.size.width - _borderWidth * 2, _upFrame.size.height * 4 - _borderWidth * 2)];
    _tblListView.dataSource = self;
    _tblListView.delegate = self;
    _tblListView.layer.borderWidth = 1;
    _tblListView.layer.borderColor = [[UIColor grayColor] CGColor];
    _tblListView.backgroundColor = [UIColor whiteColor];
    _tblListView.separatorColor = [UIColor grayColor];
    _tblListView.hidden = !_isShowList;//一开始listView是隐藏的，此后根据showList的值显示或隐藏
    
    [self addSubview:_tblListView]; 
    [_tblListView release];
}

/*******************************************************************************
 * 方法名称：下拉单击事件
 * 功能描述：响应dropdownlist控件的单击事件
 * 输入参数：
 * 输出参数：
 ******************************************************************************/
- (void)viewClicked
{
    [_txtSelect resignFirstResponder];
    if(_isShowList) //如果下拉框已显示，什么都不做
    {
        [_btnDownOrUp setImage:[UIImage imageNamed:NSLocalizedString(@"ddldown", nil)] forState:UIControlStateNormal];
        [self setShowList:NO];
    }
    else
    {
        [_btnDownOrUp setImage:[UIImage imageNamed:NSLocalizedString(@"ddlup", nil)] forState:UIControlStateNormal];
        [self.superview bringSubviewToFront:self];
        [self setShowList:YES];//显示下拉框
    }
}

/*******************************************************************************
 * 方法名称：下拉单击事件
 * 功能描述：响应dropdownlist控件的单击事件
 * 输入参数：
    isShow：设置是否显示下拉框，取值为YES或NO
 * 输出参数：
 ******************************************************************************/
- (void) setShowList:(BOOL)isShow
{
    _isShowList = isShow;
    if(_isShowList)
    {
        self.frame = _downFrame;
    }
    else 
    {
        self.frame = _upFrame;
    }
    _tblListView.hidden = !isShow;
}

#pragma mark - TableView dataSource

/*******************************************************************************
 * 方法名称：TableView dataSource
 * 功能描述：返回当前tableview共有几节
 * 输入参数：
 * 输出参数：
 ******************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/*******************************************************************************
 * 方法名称：TableView dataSource
 * 功能描述：返回tableview每节里面的行数
 * 输入参数：
 * 输出参数：
 ******************************************************************************/
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return _arrListData.count;
}

/*******************************************************************************
 * 方法名称：TableView dataSource
 * 功能描述：返回tableview每行的内容
 * 输入参数：
 * 输出参数：
 ******************************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid =@"DropDownList";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid]autorelease];
    }
    //文本标签
    cell.textLabel.text = (NSString*)[_arrListData objectAtIndex:indexPath.row];
    cell.textLabel.font = _txtSelect.font;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

/*******************************************************************************
 * 方法名称：TableView dataSource
 * 功能描述：返回tableview每行的高度
 * 输入参数：
 * 输出参数：
 ******************************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _upFrame.size.height;
}

#pragma mark - TableView delegate

/*******************************************************************************
 * 方法名称：TableView delegate
 * 功能描述：响应tableview的行单击事件
 * 输入参数：
 * 输出参数：
 ******************************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _txtSelect.text = (NSString*)[_arrListData objectAtIndex:indexPath.row];
    _iSelectSerial = indexPath.row;
    [_btnDownOrUp setImage:[UIImage imageNamed:NSLocalizedString(@"ddldown", nil)] forState:UIControlStateNormal];
    [self setShowList:NO];
}



@end
