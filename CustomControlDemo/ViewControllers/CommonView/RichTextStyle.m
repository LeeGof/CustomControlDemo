/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： RichTextStyle.m
 * 内容摘要： 本功能类为富文本框的样式设置
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年9月5日
 * 说   明： 本类非本人原创，由Francesco Freezone <cescofry@gmail.com>提供，本人整理而成
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import "RichTextStyle.h"

@implementation RichTextStyle
@synthesize strStyleName = _strStyleName;
@synthesize strAddString = _strAddString;
@synthesize font = _font;
@synthesize color = _color;
@synthesize isUnderlined = _isUnderlined;
@synthesize textAlignment = _textAlignment;
@synthesize paragraphInset = _paragraphInset;
@synthesize isApplyParagraphStyling = _isApplyParagraphStyling;
@synthesize iPreSpace = _iPreSpace;
@synthesize iMaxLineHeight = _iMaxLineHeight;
@synthesize iMinLineHeight = _iMinLineHeight;

@synthesize bulletCharacter = _bulletCharacter;
@synthesize bulletFont = _bulletFont;
@synthesize bulletColor = _bulletColor;

- (id)init
{
    self = [super init];
	if (self) 
    {
        self.strStyleName = @"_default";
		self.bulletCharacter = @"•";
		self.strAddString = @"";
		self.font = [UIFont systemFontOfSize:12];
		self.color = [UIColor blackColor];
		self.isUnderlined = NO;
		self.textAlignment = RichTextAlignementLeft;
		self.iMaxLineHeight = 0;
		self.iMinLineHeight = 0;
		self.paragraphInset = UIEdgeInsetsZero;
		self.isApplyParagraphStyling = YES;
		self.iPreSpace = 0;
	}
	return self;
}

+ (id)styleWithName:(NSString *)name 
{
    RichTextStyle *style = [[RichTextStyle alloc] init];
    [style setStrStyleName:name];
    return [style autorelease];
}

- (UIFont *)bulletFont
{
	if (_bulletFont == nil) 
    {
		return _font;
	}
	return _bulletFont;
}

- (UIColor *)bulletColor
{
	if (_bulletColor == nil) 
    {
		return _color;
	}
	return _bulletColor;
}

- (id)copyWithZone:(NSZone *)zone
{
	RichTextStyle *style = [[RichTextStyle alloc] init];
	style.strStyleName = [[self.strStyleName copy] autorelease];
	style.bulletCharacter = self.bulletCharacter;
	style.strAddString = [[self.strAddString copy] autorelease];
	style.font = [UIFont fontWithName:self.font.fontName size:self.font.pointSize];
	style.color = self.color;
	style.isUnderlined = self.isUnderlined;
    style.textAlignment = self.textAlignment;
	style.iMaxLineHeight = self.iMaxLineHeight;
	style.iMinLineHeight = self.iMinLineHeight;
	style.iPreSpace = self.iPreSpace;
	style.isApplyParagraphStyling = self.isApplyParagraphStyling;
	style.paragraphInset = self.paragraphInset;
	return style;
}

- (void)setParagraphInset:(UIEdgeInsets)paragraphInset
{
	_paragraphInset = paragraphInset;
}

- (void)dealloc
{    
    [_strStyleName release];
	[_bulletCharacter release];
    [_strAddString release];
    [_font release];
    [_color release];
	[_bulletColor release];
	[_bulletFont release];
    [super dealloc];
}

@end
