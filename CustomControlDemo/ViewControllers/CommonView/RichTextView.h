/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： RichTextView.h
 * 内容摘要： 本功能类为富文本框效果
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年9月5日
 * 说   明： 本类非本人原创，由Francesco Freezone <cescofry@gmail.com>提供，本人整理而成
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import <UIKit/UIKit.h>
#import "RichTextStyle.h"

@protocol RichTextViewDelegate;
@interface RichTextView : UIView
{
	
	NSMutableDictionary *_styles;
	NSMutableDictionary *_defaultsTags;
	struct 
    {
        unsigned int textChangesMade:1;
        unsigned int updatedAttrString:1;
        unsigned int updatedFramesetter:1;
	} _coreTextViewFlags;
}

@property (nonatomic, retain) NSString				*text;
@property (nonatomic, retain) NSString				*processedString;
@property (nonatomic, readonly) NSAttributedString	*attributedString;
@property (nonatomic, assign) CGPathRef				path;
@property (nonatomic, retain) NSMutableDictionary	*URLs;
@property (nonatomic, retain) NSMutableArray		*images;
@property (nonatomic, assign) id <RichTextViewDelegate> delegate;
@property (nonatomic, retain) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;

/* Using this method, you then have to set the -text property to get any result */
- (id)initWithFrame:(CGRect)frame;

- (id)initWithFrame:(CGRect)frame andAttributedString:(NSAttributedString *)attributedString;

/* Using one of the FTCoreTextTag constants defined you can change a default tag to a new one.
 * Example: you can call [coretTextView changeDefaultTag:FTCoreTextTagBullet toTag:@"li"] to
 * make the view regonize <li>...</li> tags as bullet points */
- (void)changeDefaultTag:(NSString *)coreTextTag toTag:(NSString *)newDefaultTag;

- (void)setStyles:(NSDictionary *)styles __deprecated;

- (void)addStyle:(RichTextStyle *)style;
- (void)addStyles:(NSArray *)styles;

- (void)removeAllStyles;

- (NSArray *)stylesArray __deprecated;
- (NSArray *)styles;

+ (NSString *)stripTagsForString:(NSString *)string;
+ (NSArray *)pagesFromText:(NSString *)string;

- (CGSize)suggestedSizeConstrainedToSize:(CGSize)size;
- (void)fitToSuggestedHeight;

@end

@protocol RichTextViewDelegate <NSObject>
@optional
- (void)touchedData:(NSDictionary *)data inCoreTextView:(RichTextView *)textView __deprecated;
- (void)coreTextView:(RichTextView *)coreTextView receivedTouchOnData:(NSDictionary *)data;
@end

@interface NSString (FTCoreText)
//for a given 'string' and 'tag' return '<tag>string</tag>'
- (NSString *)stringByAppendingTagName:(NSString *)tagName;
@end
