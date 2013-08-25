/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： RichTextStyle.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*******************************************************************************
 * 功能描述：本常量用于定义文本的对齐方式
 * 0：左对齐；
 * 1：右对齐；
 * 2：居中对齐；
 * 3：规范的对齐方式，一个段落的最后一行是自然对齐的；
 * 4：自然的对齐方式
 ******************************************************************************/
typedef enum
{
	RichTextAlignementLeft = 0,
	RichTextAlignementRight = 1,
	RichTextAlignementCenter = 2,
	RichTextAlignementJustified = 3,
	RichTextAlignementNatural = 4
}RichTextAlignement;

@interface RichTextStyle : NSObject<NSCopying>

/*******************************************************************************
 * 属性统一说明：
 * strStyleName：样式名称，标识某个文本属于那种类型，例如<title>ligf</title>，title是标识
 * strAddString：给某个样式的文本后面附加指定的文本；
 * font：该样式下文本的字体；
 * color：该样式下文本的颜色；
 * isUnderlined：该样式下文本是否添加下划线；
 * textAlignment：该样式下文本的对齐方式；
 * paragraphInset：该样式下文本与周围文本的间距；
 * isApplyParagraphStyling：与上一个参数联合使用，默认为YES，如果为NO，则上一个参数设置无效
 * iPreSpace：与上一行的间距；
 * iMaxLineHeight：最大行高；
 * iMinLineHeight：最小行高；
 
 // 下述三个仅用于项目符号的方式
 * bulletCharacter：项目符号的字符；
 * bulletFont：该风格下的字体；
 * bulletColor：该风格下的颜色；
 ******************************************************************************/
@property (nonatomic, retain) NSString                  *strStyleName;
@property (nonatomic, retain) NSString                  *strAddString;
@property (nonatomic, retain) UIFont                    *font;
@property (nonatomic, retain) UIColor                   *color;
@property (nonatomic, assign, getter=isUnderLined) BOOL isUnderlined;
@property (nonatomic, assign) RichTextAlignement        textAlignment;
@property (nonatomic, assign) UIEdgeInsets              paragraphInset;
@property (nonatomic, assign) BOOL                      isApplyParagraphStyling;
@property (nonatomic, assign) CGFloat                   iPreSpace;
@property (nonatomic, assign) CGFloat                   iMaxLineHeight;
@property (nonatomic, assign) CGFloat                   iMinLineHeight;

@property (nonatomic, retain) NSString                  *bulletCharacter;
@property (nonatomic, retain) UIFont                    *bulletFont;
@property (nonatomic, retain) UIColor                   *bulletColor;

+ (id)styleWithName:(NSString *)strStyleName;

@end
