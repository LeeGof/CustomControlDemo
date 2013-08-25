/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： RichTextView.m
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
#import "RichTextView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "Constants.h"

#define SYSTEM_VERSION_LESS_THAN(v)			([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

typedef enum 
{
	RichTextTagTypeOpen,
	RichTextTagTypeClose,
	RichTextTagTypeSelfClose
}RichTextTagType;

@interface RichTextNode : NSObject

@property (nonatomic, assign) RichTextNode	*supernode;
@property (nonatomic, retain) NSArray			*subnodes;
@property (nonatomic, copy)	  RichTextStyle	*style;
@property (nonatomic, assign) NSRange			styleRange;
@property (nonatomic, assign) BOOL				isClosed;
@property (nonatomic, assign) NSInteger			startLocation;
@property (nonatomic, assign) BOOL				isLink;
@property (nonatomic, assign) BOOL				isImage;
@property (nonatomic, assign) BOOL				isBullet;
@property (nonatomic, retain) NSString			*imageName;

- (NSString *)descriptionOfTree;
- (NSString *)descriptionToRoot;
- (void)addSubnode:(RichTextNode *)node;
- (void)adjustStylesAndSubstylesRangesByRange:(NSRange)insertedRange;
- (void)insertSubnode:(RichTextNode *)subnode atIndex:(NSUInteger)index;
- (void)insertSubnode:(RichTextNode *)subnode beforeNode:(RichTextNode *)node;
- (RichTextNode *)previousNode;
- (RichTextNode *)nextNode;
- (NSUInteger)nodeIndex;
- (RichTextNode *)subnodeAtIndex:(NSUInteger)index;

@end

@implementation RichTextNode

@synthesize supernode = _supernode;
@synthesize subnodes = _subnodes;
@synthesize style = _style;
@synthesize styleRange = _styleRange;
@synthesize isClosed = _isClosed;
@synthesize isLink = _isLink;
@synthesize isImage = _isImage;
@synthesize startLocation = _startLocation;
@synthesize isBullet = _isBullet;
@synthesize imageName = _imageName;

- (NSArray *)subnodes
{
	if (_subnodes == nil) 
    {
		_subnodes = [NSMutableArray new];
	}
	return _subnodes;
}

- (void)addSubnode:(RichTextNode *)node
{
	[self insertSubnode:node atIndex:[_subnodes count]];
}

- (void)insertSubnode:(RichTextNode *)subnode atIndex:(NSUInteger)index
{
	subnode.supernode = self;
	
	NSMutableArray *subnodes = (NSMutableArray *)self.subnodes;
	if (index <= [_subnodes count]) 
    {
		[subnodes insertObject:subnode atIndex:index];
	}
	else 
    {
		[subnodes addObject:subnode];
	}
}

- (void)insertSubnode:(RichTextNode *)subnode beforeNode:(RichTextNode *)node
{
	NSInteger existingNodeIndex = [_subnodes indexOfObject:node];
	if (existingNodeIndex == NSNotFound) 
    {
		[self addSubnode:subnode];
	}
	else 
    {
		[self insertSubnode:subnode atIndex:existingNodeIndex];
	}
}

- (NSInteger)numberOfParents
{
	NSInteger returnedValue = 0;
	RichTextNode *node = self.supernode;
	while (node) 
    {
		returnedValue++;
		node = node.supernode;
	}
	return returnedValue;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@\t-\t%@ - \t%@", [super description], _style.strStyleName, NSStringFromRange(_styleRange)];
}

- (NSString *)descriptionToRoot
{
	NSMutableString *description = [NSMutableString stringWithString:@"\n\n"];
	
	RichTextNode *node = self;
	do 
    {
		[description insertString:[NSString stringWithFormat:@"%@",[self description]] atIndex:0];
		
		for (int i = 0; i < [self numberOfParents]; i++) 
        {
			[description insertString:@"\t" atIndex:0];
		}
		[description insertString:@"\n" atIndex:0];
		node = node.supernode;
		
	} while (node);
	
	return description;
}

- (NSString *)descriptionOfTree
{
	NSMutableString *description = [NSMutableString string];
	for (int i = 0; i < [self numberOfParents]; i++) 
    {
		[description insertString:@"\t" atIndex:0];
	}
	[description appendFormat:@"%@\n", [self description]];
	for (RichTextNode *node in _subnodes) 
    {
		[description appendString:[node descriptionOfTree]];
	}
	return description;
}

- (NSArray *)_allSubnodes
{
	NSMutableArray *subnodes = [[NSMutableArray new] autorelease];
	for (RichTextNode *node in _subnodes) 
    {
		[subnodes addObject:node];
		if (node.subnodes) [subnodes addObjectsFromArray:[node _allSubnodes]];
	}
	
	return subnodes;
}

//return an array of nodes starting with the current and recursively adding all its child nodes
- (NSArray *)allSubnodes
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	NSArray *allSubnodes = [[self _allSubnodes] copy];
	[pool release];
	NSMutableArray *returnedArray = [NSMutableArray arrayWithObject:self];
	[returnedArray addObjectsFromArray:allSubnodes];
	[allSubnodes release];
	return returnedArray;
}

- (void)adjustStylesAndSubstylesRangesByRange:(NSRange)insertedRange
{
	NSRange range = self.styleRange;
	if (range.length + range.location > insertedRange.location) 
    {
		range.location += insertedRange.length;
	}
	self.styleRange = range;
	
	for (RichTextNode *node in _subnodes) 
    {
		[node adjustStylesAndSubstylesRangesByRange:insertedRange];
	}
}

- (NSUInteger)nodeIndex
{
	return [_supernode.subnodes indexOfObject:self];
}

- (RichTextNode *)subnodeAtIndex:(NSUInteger)index
{
	if (index < [_subnodes count]) 
    {
		return [_subnodes objectAtIndex:index];
	}
	return nil;
}

- (RichTextNode *)previousNode
{
	NSUInteger index = [self nodeIndex];
	if (index != NSNotFound) 
    {
		return [_supernode subnodeAtIndex:index - 1];
	}
	return nil;
}

- (RichTextNode *)nextNode
{
	NSUInteger index = [self nodeIndex];
	if (index != NSNotFound) 
    {
		return [_supernode subnodeAtIndex:index + 1];
	}
	return nil;	
}

- (void)dealloc
{
	[_subnodes release];
	[_style release];
	[_imageName release];
	[super dealloc];
}

@end

@interface RichTextView ()

@property (nonatomic, assign) CTFramesetterRef framesetter;
@property (nonatomic, retain) RichTextNode *rootNode;

- (void)updateFramesetterIfNeeded;
- (void)processText;
CTFontRef CTFontCreateFromUIFont(UIFont *font);
- (BOOL)isSystemUnder3_2;
UITextAlignment UITextAlignmentFromCoreTextAlignment(RichTextAlignement alignment);
NSInteger rangeSort(NSString *range1, NSString *range2, void *context);
- (void)drawImages;
- (void)doInit;
- (void)didMakeChanges;
- (NSString *)defaultTagNameForKey:(NSString *)tagKey;
- (NSMutableArray *)divideTextInPages:(NSString *)string;

@end

@implementation RichTextView

@synthesize text = _text;
@synthesize processedString = _processedString;
@synthesize path = _path;
@synthesize URLs = _URLs;
@synthesize images = _images;
@synthesize delegate = _delegate;
@synthesize framesetter = _framesetter;
@synthesize rootNode = _rootNode;
@synthesize shadowColor = _shadowColor;
@synthesize shadowOffset = _shadowOffset;
@synthesize attributedString = _attributedString;

#pragma mark - Tools methods

NSInteger rangeSort(NSString *range1, NSString *range2, void *context)
{
    NSRange r1 = NSRangeFromString(range1);
	NSRange r2 = NSRangeFromString(range2);
	
    if (r1.location < r2.location)
    {
        return NSOrderedAscending;
    }
    else if (r1.location > r2.location)
    {
        return NSOrderedDescending;
    }
    else
    {
        return NSOrderedSame;
    }
}

CTFontRef CTFontCreateFromUIFont(UIFont *font)
{
    CTFontRef ctFont = CTFontCreateWithName((CFStringRef)font.fontName, 
                                            font.pointSize, 
                                            NULL);
    return ctFont;
}

UITextAlignment UITextAlignmentFromCoreTextAlignment(RichTextAlignement alignment)
{
	switch (alignment) 
    {
		case RichTextAlignementCenter:
        {
			return UITextAlignmentCenter;
			break;
        }
		case RichTextAlignementRight:
        {
			return UITextAlignmentRight;
			break;			
        }
		default:
        {
			return UITextAlignmentLeft;
			break;
        }
	}
}

- (BOOL)isSystemUnder3_2
{
    static BOOL checked = NO;
    static BOOL systemUnder3_2;
    if (!checked) 
    {
        checked = YES;
        systemUnder3_2 = SYSTEM_VERSION_LESS_THAN(@"3.2");
    }
	return systemUnder3_2;
}

#pragma mark - RichTextView business
#pragma mark -

- (void)changeDefaultTag:(NSString *)coreTextTag toTag:(NSString *)newDefaultTag
{
	if ([_defaultsTags objectForKey:coreTextTag] == nil) 
    {
		[NSException raise:NSInvalidArgumentException format:@"%@ is not a default tag of RichTextView. Use the constant RichTextTag constants.", coreTextTag];
	}
	else 
    {
		[_defaultsTags setObject:newDefaultTag forKey:coreTextTag];
	}
}

- (NSString *)defaultTagNameForKey:(NSString *)tagKey
{
	return [_defaultsTags objectForKey:tagKey];
}

- (void)didMakeChanges
{
	_coreTextViewFlags.updatedAttrString = NO;
	_coreTextViewFlags.updatedFramesetter = NO;
}

#pragma mark - UI related

- (NSDictionary *)dataForPoint:(CGPoint)point
{
	NSMutableDictionary *returnedDict = [NSMutableDictionary dictionary];
	
	CGMutablePathRef mainPath = CGPathCreateMutable();
    if (!_path) 
    {
        CGPathAddRect(mainPath, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));  
    }
    else 
    {
        CGPathAddPath(mainPath, NULL, _path);
    }
	
    CTFrameRef ctframe = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), mainPath, NULL);
    CGPathRelease(mainPath);
	
    NSArray *lines = (NSArray *)CTFrameGetLines(ctframe);
    NSInteger lineCount = [lines count];
    CGPoint origins[lineCount];
    
    if (lineCount != 0) 
    {
		CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), origins);
		
		for (int i = 0; i < lineCount; i++) 
        {
			CGPoint baselineOrigin = origins[i];
			//the view is inverted, the y origin of the baseline is upside down
			baselineOrigin.y = CGRectGetHeight(self.frame) - baselineOrigin.y;
			
			CTLineRef line = (CTLineRef)[lines objectAtIndex:i];
			CGFloat ascent, descent;
			CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
			
			CGRect lineFrame = CGRectMake(baselineOrigin.x, baselineOrigin.y - ascent, lineWidth, ascent + descent);
			
			if (CGRectContainsPoint(lineFrame, point)) 
            {
				//we look if the position of the touch is correct on the line
				CFIndex index = CTLineGetStringIndexForPosition(line, point);
                
				NSArray *urlsKeys = [_URLs allKeys];
				
				for (NSString *key in urlsKeys) 
                {
					NSRange range = NSRangeFromString(key);
					if (index >= range.location && index < range.location + range.length) 
                    {
						NSURL *url = [_URLs objectForKey:key];
						if (url) 
                        {
                            [returnedDict setObject:url forKey:RICHTEXTVIEW_TAG_DATAURL];
                        }
						break;
					}
				}
                
                //frame
                CFArrayRef runs = CTLineGetGlyphRuns(line);
                for(CFIndex j = 0; j < CFArrayGetCount(runs); j++) 
                {
                    CTRunRef run = CFArrayGetValueAtIndex(runs, j);
                    NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
                    
                    NSString *name = [attributes objectForKey:RICHTEXTVIEW_TAG_DATANAME];
                    if (![name isEqualToString:@"link"])
                    {
                       continue; 
                    }
                    
                    [returnedDict setObject:attributes forKey:RICHTEXTVIEW_TAG_DATAATTRIBUTES];
                    
                    CGRect runBounds;
                    runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
                    runBounds.size.height = ascent + descent;
                    
                    CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL); //9
                    runBounds.origin.x = baselineOrigin.x + self.frame.origin.x + xOffset + 0;
                    runBounds.origin.y = baselineOrigin.y + lineFrame.size.height - ascent; 
                    
                    [returnedDict setObject:NSStringFromCGRect(runBounds) forKey:RICHTEXTVIEW_TAG_DATAFRAME];
                }
            }
			if (returnedDict.count > 0) 
            {
                break;
            }
		}
	}
	
	CFRelease(ctframe);
	
	return returnedDict;
}


- (void)updateFramesetterIfNeeded
{
    if (!_coreTextViewFlags.updatedAttrString) 
    {
		if (_framesetter != NULL) 
        {
            CFRelease(_framesetter);
        }
		_framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
		_coreTextViewFlags.updatedAttrString = YES;
    }
}

/*!
 * @abstract get the supposed size of the drawn text
 *
 */

- (CGSize)suggestedSizeConstrainedToSize:(CGSize)size
{
	CGSize suggestedSize;
	if ([self isSystemUnder3_2]) {
		if (_processedString == nil) {
			[self processText];
		}
		RichTextStyle *style = [_styles objectForKey:[self defaultTagNameForKey:RICHTEXTVIEW_TAG_DEFAULT]];
		suggestedSize = [_processedString sizeWithFont:style.font constrainedToSize:CGSizeMake(self.bounds.size.width, MAXFLOAT)];
	}
	else 
    {
		[self updateFramesetterIfNeeded];
		if (_framesetter == NULL) 
        {
			return CGSizeZero;
		}
		suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(_framesetter, CFRangeMake(0, 0), NULL, size, NULL);
		suggestedSize = CGSizeMake(ceilf(suggestedSize.width), ceilf(suggestedSize.height));
	}
    return suggestedSize;
}

/*!
 * @abstract handy method to fit to the suggested height in one call
 *
 */

- (void)fitToSuggestedHeight
{
	CGSize suggestedSize = [self suggestedSizeConstrainedToSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT)];
	CGRect viewFrame = self.frame;
	viewFrame.size.height = suggestedSize.height;
	self.frame = viewFrame;
}

#pragma mark - Text processing

/*!
 * @abstract remove the tags from the text and create a tree representation of the text
 *
 */

- (void)processText
{    
    if (!_text || [_text length] == 0) return;
	
	[_URLs removeAllObjects];
    [_images removeAllObjects];
	
	RichTextNode *rootNode = [[RichTextNode new] autorelease];
	rootNode.style = [_styles objectForKey:[self defaultTagNameForKey:RICHTEXTVIEW_TAG_DEFAULT]];
	
	RichTextNode *currentSupernode = rootNode;
	
	NSMutableString *processedString = [NSMutableString stringWithString:_text];
	
	BOOL finished = NO;
	NSRange remainingRange = NSMakeRange(0, [processedString length]);
	
	NSString *regEx = @"<(/){0,1}.*?( /){0,1}>";	
	
	BOOL systemUnder3_2 = ([self isSystemUnder3_2]);
	
	NSArray *possibleTags = nil;
	if (systemUnder3_2) 
    {
		NSMutableArray *tagsNames = [NSMutableArray new];
		NSMutableArray *tags = [NSMutableArray new];
		for (RichTextStyle *style in _styles.allValues) 
        {
			[tagsNames addObject:style.strStyleName];
		}
		if (![tagsNames containsObject:RICHTEXTVIEW_TAG_BULLET]) 
        {
            [tagsNames addObject:RICHTEXTVIEW_TAG_BULLET];
        }
		if (![tagsNames containsObject:RICHTEXTVIEW_TAG_IMAGE]) 
        {
            [tagsNames addObject:RICHTEXTVIEW_TAG_IMAGE];
        }
		if (![tagsNames containsObject:RICHTEXTVIEW_TAG_PAGE]) 
        {
            [tagsNames addObject:RICHTEXTVIEW_TAG_PAGE];
        }
		
		for (NSString *tagName in tagsNames) 
        {
			[tags addObject:[NSString stringWithFormat:@"<%@>", tagName]];
			[tags addObject:[NSString stringWithFormat:@"</%@>", tagName]];
			[tags addObject:[NSString stringWithFormat:@"<%@ />", tagName]];
		}
		
		possibleTags = tags;
	}
	
	while (!finished) 
    {
		NSRange tagRange;
		if (systemUnder3_2) 
        {
			NSMutableArray *ranges = [NSMutableArray new];
			for (NSString *tag in possibleTags) 
            {
				NSRange tagRange = [processedString rangeOfString:tag options:0 range:remainingRange];
				if (tagRange.location != NSNotFound) 
                {
					[ranges addObject:NSStringFromRange(tagRange)];
				}
			}
			NSArray *sortedRanges = [ranges sortedArrayUsingFunction:rangeSort context:NULL];
			[ranges release];
			
			if (sortedRanges.count == 0) 
            {
				tagRange.location = NSNotFound;
			}
			else 
            {
				tagRange = NSRangeFromString([sortedRanges objectAtIndex:0]);
			}
		}
		else 
        {
			tagRange = [processedString rangeOfString:regEx options:NSRegularExpressionSearch range:remainingRange];
		}
		
		if (tagRange.location == NSNotFound) 
        {
			if (currentSupernode != rootNode && !currentSupernode.isClosed) 
            {
				NSLog(@"RichTextView :%@ - Couldn't parse text because tag '%@' at position %d is not closed - aborting rendering", self, currentSupernode.style.strStyleName, currentSupernode.startLocation);
				return;
			}
			finished = YES;
            continue;
		}
        
        NSString *fullTag = [processedString substringWithRange:tagRange];
        RichTextTagType tagType;
        
        if ([fullTag rangeOfString:@"</"].location == 0) 
        {
            tagType = RichTextTagTypeClose;
        }
        else if ([fullTag rangeOfString:@"/>"].location == NSNotFound && [fullTag rangeOfString:@" />"].location == NSNotFound) 
        {
            tagType = RichTextTagTypeOpen;
        }
        else 
        {
            tagType = RichTextTagTypeSelfClose;
        }
        
		NSArray *tagsComponents = [fullTag componentsSeparatedByString:@" "];
		NSString *tagName = (tagsComponents.count > 0) ? [tagsComponents objectAtIndex:0] : fullTag;
        tagName = [tagName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"< />"]];
		
        RichTextStyle *style = [_styles objectForKey:tagName];
        
        if (style == nil) 
        {
            style = [_styles objectForKey:[self defaultTagNameForKey:RICHTEXTVIEW_TAG_DEFAULT]];
        }
        
        switch (tagType) 
        {
            case RichTextTagTypeOpen:
            {
                if (currentSupernode.isLink || currentSupernode.isImage) 
                {
                    return;
                }
                
                RichTextNode *newNode = [RichTextNode new];
                newNode.style = style;
                newNode.startLocation = tagRange.location;
                
                if ([tagName isEqualToString:[self defaultTagNameForKey:RICHTEXTVIEW_TAG_LINK]]) 
                {
                    newNode.isLink = YES;
                }
                else if ([tagName isEqualToString:[self defaultTagNameForKey:RICHTEXTVIEW_TAG_BULLET]]) 
                {
                    newNode.isBullet = YES;
                    
                    NSString *appendedString = [NSString stringWithFormat:@"%@\t", newNode.style.bulletCharacter];
                    
                    [processedString insertString:appendedString atIndex:tagRange.location + tagRange.length];
                    
                    //bullet styling
                    RichTextStyle *bulletStyle = [RichTextStyle new];
                    bulletStyle.strStyleName = @"RichTextBulletStyle";
                    bulletStyle.font = newNode.style.bulletFont;
                    bulletStyle.color = newNode.style.bulletColor;
                    bulletStyle.isApplyParagraphStyling = NO;
                    bulletStyle.paragraphInset = UIEdgeInsetsMake(0, 0, 0, newNode.style.paragraphInset.left);
                    
                    RichTextNode *bulletNode = [RichTextNode new];
                    bulletNode.style = bulletStyle;
                    [bulletStyle release];
                    bulletNode.styleRange = NSMakeRange(tagRange.location, [appendedString length]);
                    
                    [newNode addSubnode:bulletNode];
                    [bulletNode release];
                }
                else if ([tagName isEqualToString:[self defaultTagNameForKey:RICHTEXTVIEW_TAG_IMAGE]]) 
                {
                    newNode.isImage = YES;
                }
                
                [processedString replaceCharactersInRange:tagRange withString:@""];
                
                [currentSupernode addSubnode:newNode];
                [newNode release];
                
                currentSupernode = newNode;
                
                remainingRange.location = tagRange.location;
                remainingRange.length = [processedString length] - tagRange.location;
            }
                break;
            case RichTextTagTypeClose:
            {
                if ((![currentSupernode.style.strStyleName isEqualToString:[self defaultTagNameForKey:RICHTEXTVIEW_TAG_DEFAULT]] && ![currentSupernode.style.strStyleName isEqualToString:tagName]) ) 
                {
                    return;
                }
                
                currentSupernode.isClosed = YES;
                
                if (currentSupernode.isLink) 
                {
                    NSRange elementContentRange = NSMakeRange(currentSupernode.startLocation, tagRange.location - currentSupernode.startLocation);
                    NSString *elementContent = [processedString substringWithRange:elementContentRange];
                    NSRange pipeRange = [elementContent rangeOfString:@"|"];
                    NSString *urlString = nil;
                    NSString *urlDescription = nil;
                    if (pipeRange.location != NSNotFound) 
                    {
                        urlString = [elementContent substringToIndex:pipeRange.location];
                        urlDescription = [elementContent substringFromIndex:pipeRange.location + 1];
                    }
                    
                    [processedString replaceCharactersInRange:NSMakeRange(elementContentRange.location, elementContentRange.length + tagRange.length) withString:urlDescription];
                    if (![urlString hasPrefix:@"http://"]) 
                    {
                        urlString = [NSString stringWithFormat:@"http://%@", urlString];
                    }
                    NSURL *url = [NSURL URLWithString:urlString];
                    NSRange urlDescriptionRange = NSMakeRange(elementContentRange.location, [urlDescription length]);
                    [_URLs setObject:url forKey:NSStringFromRange(urlDescriptionRange)];
                    
                    currentSupernode.styleRange = urlDescriptionRange;
                }
                else if (currentSupernode.isImage) 
                {
                    //replace active string with emptySpace
                    NSRange elementContentRange = NSMakeRange(currentSupernode.startLocation, tagRange.location - currentSupernode.startLocation);
                    NSString *elementContent = [processedString substringWithRange:elementContentRange];
                    
                    UIImage *img = [UIImage imageNamed:elementContent];
                    
                    if (img) 
                    {
                        NSString *lines = @"\n";
                        float leading = img.size.height;
                        currentSupernode.style.iPreSpace = leading;
                        
                        currentSupernode.imageName = elementContent;
                        [processedString replaceCharactersInRange:NSMakeRange(elementContentRange.location, elementContentRange.length + tagRange.length) withString:lines];
                        
                        [_images addObject:currentSupernode];
                        currentSupernode.styleRange = NSMakeRange(elementContentRange.location, [lines length]);
						
                    }
                    else {
//                        NSLog(@"FTCoreTextView :%@ - Couldn't find image '%@' in main bundle", self, elementContentRange);
                        [processedString replaceCharactersInRange:tagRange withString:@""];
                    }
                }
                else {
                    currentSupernode.styleRange = NSMakeRange(currentSupernode.startLocation, tagRange.location - currentSupernode.startLocation);
                    [processedString replaceCharactersInRange:tagRange withString:@""];
                }
                
                if ([currentSupernode.style.strAddString length] > 0) 
                {
                    [processedString insertString:currentSupernode.style.strAddString atIndex:currentSupernode.styleRange.location + currentSupernode.styleRange.length];
                    NSRange newStyleRange = currentSupernode.styleRange;
                    newStyleRange.length += [currentSupernode.style.strAddString length];
                    currentSupernode.styleRange = newStyleRange;							
                }
                
                if (style.paragraphInset.top > 0) 
                {
                    if (![style.strStyleName isEqualToString:[self defaultTagNameForKey:RICHTEXTVIEW_TAG_BULLET]] ||  [[currentSupernode previousNode].style.strStyleName isEqualToString:[self defaultTagNameForKey:RICHTEXTVIEW_TAG_BULLET]]) 
                    {
                        //fix: add a new line for each new line and set its height to 'top' value
                        [processedString insertString:@"\n" atIndex:currentSupernode.startLocation];
                        NSRange topSpacingStyleRange = NSMakeRange(currentSupernode.startLocation, [@"\n" length]);
                        RichTextStyle *topSpacingStyle = [[RichTextStyle alloc] init];
                        topSpacingStyle.strStyleName = [NSString stringWithFormat:@"_FTTopSpacingStyle_%@", currentSupernode.style.strStyleName];
                        topSpacingStyle.iMinLineHeight = currentSupernode.style.paragraphInset.top;
                        topSpacingStyle.iMaxLineHeight = currentSupernode.style.paragraphInset.top;
                        RichTextNode *topSpacingNode = [[RichTextNode alloc] init];
                        topSpacingNode.style = topSpacingStyle;
                        [topSpacingStyle release];
                        
                        topSpacingNode.styleRange = topSpacingStyleRange;
                        
                        [currentSupernode.supernode insertSubnode:topSpacingNode beforeNode:currentSupernode];
                        [topSpacingNode release];
                        
                        [currentSupernode adjustStylesAndSubstylesRangesByRange:topSpacingStyleRange];
                    }
                }
                
                remainingRange.location = currentSupernode.styleRange.location + currentSupernode.styleRange.length;
                remainingRange.length = [processedString length] - remainingRange.location;
                
                currentSupernode = currentSupernode.supernode;
            }
                break;
            case RichTextTagTypeSelfClose:
            {
                RichTextNode *newNode = [RichTextNode new];
                newNode.style = style;
                [processedString replaceCharactersInRange:tagRange withString:newNode.style.strAddString];
                newNode.styleRange = NSMakeRange(tagRange.location, [newNode.style.strAddString length]);
                [currentSupernode addSubnode:newNode];	
                [newNode release];
                
                remainingRange.location = tagRange.location;
                remainingRange.length = [processedString length] - tagRange.location;
            }
                break;
        }
	}	
	
	rootNode.styleRange = NSMakeRange(0, [processedString length]);
	
	self.rootNode = rootNode;	
	self.processedString = processedString;
}

/*!
 * @abstract Remove all the tags and return a clean text to be used
 *
 */

+ (NSString *)stripTagsForString:(NSString *)string
{
    RichTextView *instance = [[RichTextView alloc] initWithFrame:CGRectZero];
    [instance setText:string];
    [instance processText];
    NSString *result = [[instance.processedString copy] autorelease];
    [instance release];
    return result;
}

/*!
 * @abstract divide the text in different pages according to the tags <_page/> found
 *
 */

+ (NSArray *)pagesFromText:(NSString *)string
{
    RichTextView *instance = [[RichTextView alloc] initWithFrame:CGRectZero];
    NSArray *result = [instance divideTextInPages:string];
	[instance release];
    return (NSArray *)result;
}

/*!
 * @abstract divide the text in different pages according to the tags <_page/> found
 *
 */

- (NSMutableArray *)divideTextInPages:(NSString *)string
{
    NSMutableArray *result = [NSMutableArray array];
    int prevStart = 0;
    while (YES) 
    {
        NSRange rangeStart = [string rangeOfString:[NSString stringWithFormat:@"<%@/>", [self defaultTagNameForKey:RICHTEXTVIEW_TAG_PAGE]]];
		if (rangeStart.location == NSNotFound) 
        {
            rangeStart = [string rangeOfString:[NSString stringWithFormat:@"<%@ />", [self defaultTagNameForKey:RICHTEXTVIEW_TAG_PAGE]]];
        }
		
        if (rangeStart.location != NSNotFound) 
        {
            NSString *page = [string substringWithRange:NSMakeRange(prevStart, rangeStart.location)];
            [result addObject:page];
            string = [string stringByReplacingCharactersInRange:rangeStart withString:@""];
            prevStart = rangeStart.location;
        }
        else 
        {
            NSString *page = [string substringWithRange:NSMakeRange(prevStart, (string.length - prevStart))];
            [result addObject:page];
            break;
        }
    }
    return result;
}

#pragma mark Styling

- (void)addStyle:(RichTextStyle *)style
{
    [_styles setValue:style forKey:style.strStyleName];
	[self didMakeChanges];
    if ([self superview]) [self setNeedsDisplay];
}

- (void)addStyles:(NSArray *)styles
{
	for (RichTextStyle *style in styles) 
    {
		[_styles setValue:style forKey:style.strStyleName];
	}
	[self didMakeChanges];
    if ([self superview]) [self setNeedsDisplay];
}

- (void)removeAllStyles
{
	[_styles removeAllObjects];
	[self didMakeChanges];
    if ([self superview]) [self setNeedsDisplay];
}

- (void)applyStyle:(RichTextStyle *)style inRange:(NSRange)styleRange onString:(NSMutableAttributedString **)attributedString
{
    [*attributedString addAttribute:(id)RICHTEXTVIEW_TAG_DATANAME
							  value:(id)style.strStyleName
							  range:styleRange];
    
	[*attributedString addAttribute:(id)kCTForegroundColorAttributeName
							  value:(id)style.color.CGColor
							  range:styleRange];
	
	if (style.isUnderLined) {
		NSNumber *underline = [NSNumber numberWithInt:kCTUnderlineStyleSingle];
		[*attributedString addAttribute:(id)kCTUnderlineStyleAttributeName
								  value:(id)underline
								  range:styleRange];
	}	
	
	CTFontRef ctFont = CTFontCreateFromUIFont(style.font);
	
	[*attributedString addAttribute:(id)kCTFontAttributeName
							  value:(id)ctFont
							  range:styleRange];
	CFRelease(ctFont);
	
	CTTextAlignment alignment = style.textAlignment;
	CGFloat maxLineHeight = style.iMaxLineHeight;
	CGFloat minLineHeight = style.iMinLineHeight;
	CGFloat paragraphLeading = style.iPreSpace;
	
	CGFloat paragraphSpacingBefore = style.paragraphInset.top;
	CGFloat paragraphSpacingAfter = style.paragraphInset.bottom;
	CGFloat paragraphFirstLineHeadIntent = style.paragraphInset.left;
	CGFloat paragraphHeadIntent = style.paragraphInset.left;
	CGFloat paragraphTailIntent = style.paragraphInset.right;
	
	//if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
	paragraphSpacingBefore = 0;
	//}
	
	CFIndex numberOfSettings = 9;
	CGFloat tabSpacing = 28.f;
	
	BOOL applyParagraphStyling = style.isApplyParagraphStyling;
	
	if ([style.strStyleName isEqualToString:[self defaultTagNameForKey:RICHTEXTVIEW_TAG_BULLET]]) 
    {
		applyParagraphStyling = YES;
	}
	else if ([style.strStyleName isEqualToString:@"RichTextBulletStyle"]) 
    {
		applyParagraphStyling = YES;
		numberOfSettings++;
		tabSpacing = style.paragraphInset.right;
		paragraphSpacingBefore = 0;
		paragraphSpacingAfter = 0;
		paragraphFirstLineHeadIntent = 0;
		paragraphTailIntent = 0;
	}
	else if ([style.strStyleName hasPrefix:@"_FTTopSpacingStyle"]) 
    {
		[*attributedString removeAttribute:(id)kCTParagraphStyleAttributeName range:styleRange];
	}
	
	if (applyParagraphStyling) 
    {
		
		CTTextTabRef tabArray[] = { CTTextTabCreate(0, tabSpacing, NULL) };
		
		CFArrayRef tabStops = CFArrayCreate( kCFAllocatorDefault, (const void**) tabArray, 1, &kCFTypeArrayCallBacks );
		CFRelease(tabArray[0]);
		
		CTParagraphStyleSetting settings[] = 
        {
			{kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
			{kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maxLineHeight},
			{kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minLineHeight},
			{kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore},
			{kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacingAfter},
			{kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &paragraphFirstLineHeadIntent},
			{kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &paragraphHeadIntent},
			{kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), &paragraphTailIntent},
			{kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &paragraphLeading},
			{kCTParagraphStyleSpecifierTabStops, sizeof(CFArrayRef), &tabStops}//always at the end
		};
		
		CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, numberOfSettings);
		[*attributedString addAttribute:(id)kCTParagraphStyleAttributeName
								  value:(id)paragraphStyle 
								  range:styleRange];
		CFRelease(tabStops);
		CFRelease(paragraphStyle);
	}
}

#pragma mark - Object lifecycle

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andAttributedString:nil];
}

- (id)initWithFrame:(CGRect)frame andAttributedString:(NSAttributedString *)attributedString
{
	self = [super initWithFrame:frame];
	if (self) 
    {
		_attributedString = [attributedString retain];
		[self doInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) 
    {
        [self doInit];
    }
    return self;
}

- (void)doInit
{
	// Initialization code
	_framesetter = NULL;
	_styles = [[NSMutableDictionary alloc] init];
	_URLs = [[NSMutableDictionary alloc] init];
    _images = [[NSMutableArray alloc] init];
	self.opaque = NO;
	self.backgroundColor = [UIColor clearColor];
	self.contentMode = UIViewContentModeRedraw;
	[self setUserInteractionEnabled:YES];
	
	RichTextStyle *defaultStyle = [RichTextStyle styleWithName:RICHTEXTVIEW_TAG_DEFAULT];
	[self addStyle:defaultStyle];	
	
	RichTextStyle *linksStyle = [defaultStyle copy];
	linksStyle.color = [UIColor blueColor];
	linksStyle.strStyleName = RICHTEXTVIEW_TAG_LINK;
	[_styles setValue:linksStyle forKey:linksStyle.strStyleName];
	[linksStyle release];
	
	_defaultsTags = [[NSMutableDictionary dictionaryWithObjectsAndKeys:RICHTEXTVIEW_TAG_DEFAULT, RICHTEXTVIEW_TAG_DEFAULT,
					  RICHTEXTVIEW_TAG_LINK, RICHTEXTVIEW_TAG_LINK,
					  RICHTEXTVIEW_TAG_IMAGE, RICHTEXTVIEW_TAG_IMAGE,
					  RICHTEXTVIEW_TAG_PAGE, RICHTEXTVIEW_TAG_PAGE,
					  RICHTEXTVIEW_TAG_BULLET, RICHTEXTVIEW_TAG_BULLET,
					  nil] retain];
}

- (void)dealloc
{
	if (_framesetter) CFRelease(_framesetter);
	if (_path) CGPathRelease(_path);
	[_rootNode release];
    [_text release];
    [_styles release];
    [_processedString release];
    [_URLs release];
    [_images release];
	[_shadowColor release];
	[_attributedString release];
	[_defaultsTags release];
    [super dealloc];
}

#pragma mark - Custom Setters

- (void)setText:(NSString *)text
{
    [_text release];
    _text = [text retain];
	_coreTextViewFlags.textChangesMade = YES;
	[self didMakeChanges];
    if ([self superview]) [self setNeedsDisplay];
}

//only here to assure compatibility with previous versions
- (void)setStyles:(NSDictionary *)styles
{
	[_styles release];
    _styles = [styles mutableCopy];
	[self didMakeChanges];
    if ([self superview]) [self setNeedsDisplay];
}

- (void)setPath:(CGPathRef)path
{
    _path = CGPathRetain(path);
	[self didMakeChanges];
    if ([self superview]) [self setNeedsDisplay];
}

- (void)setShadowColor:(UIColor *)shadowColor
{
	[_shadowColor release];
	_shadowColor = [shadowColor retain];
	if ([self superview]) [self setNeedsDisplay];
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
	_shadowOffset = shadowOffset;
	if ([self superview]) [self setNeedsDisplay];
}

#pragma mark - Custom Getters

//only here to assure compatibility with previous versions
- (NSArray *)stylesArray
{
	return [self styles];
}

- (NSArray *)styles
{
	return [_styles allValues];
}

- (NSAttributedString *)attributedString
{
	if (!_coreTextViewFlags.updatedAttrString) 
    {
		_coreTextViewFlags.updatedAttrString = YES;
		
		if (_processedString == nil || _coreTextViewFlags.textChangesMade) 
        {
			_coreTextViewFlags.textChangesMade = NO;
			[self processText];
		}
		
		if (_processedString) 
        {
			
			NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_processedString];
			
			for (RichTextNode *node in [_rootNode allSubnodes]) 
            {
				[self applyStyle:node.style inRange:node.styleRange onString:&string];
			}
			
			[_attributedString release];
			_attributedString = string;
		}
	}
	return _attributedString;
}

#pragma mark - View lifecycle

/*!
 * @abstract draw the actual coretext on the context
 *
 */

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[self.backgroundColor setFill];
	CGContextFillRect(context, rect);
	
	if ([self isSystemUnder3_2]) 
    {
		
		if (_processedString == nil || _coreTextViewFlags.textChangesMade) 
        {
			_coreTextViewFlags.textChangesMade = NO;
			[self processText];
		}
		
		if (_shadowColor) 
        {
			CGContextSetShadowWithColor(context, _shadowOffset, 0.f, _shadowColor.CGColor);
		}
		
		RichTextStyle *defaultStyle = [_styles objectForKey:[self defaultTagNameForKey:RICHTEXTVIEW_TAG_DEFAULT]];
		[defaultStyle.color setFill];
		[_processedString drawInRect:rect
							withFont:defaultStyle.font
					   lineBreakMode:UILineBreakModeWordWrap
						   alignment:UITextAlignmentFromCoreTextAlignment(defaultStyle.textAlignment)];
	}
	else 
    {
		[self updateFramesetterIfNeeded];
		
		CGMutablePathRef mainPath = CGPathCreateMutable();
		
		if (!_path) 
        {
			CGPathAddRect(mainPath, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));  
		}
		else 
        {
			CGPathAddPath(mainPath, NULL, _path);
		}
		
		CTFrameRef drawFrame = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), mainPath, NULL);
		
		if (drawFrame == NULL) 
        {
			NSLog(@"FTCoreText unable to render: %@", self.processedString);
		}
		else 
        {
			//draw images
			if ([_images count] > 0) [self drawImages];
			
			if (_shadowColor) 
            {
				CGContextSetShadowWithColor(context, _shadowOffset, 0.f, _shadowColor.CGColor);
			}
			
			CGContextSetTextMatrix(context, CGAffineTransformIdentity);
			CGContextTranslateCTM(context, 0, self.bounds.size.height);
			CGContextScaleCTM(context, 1.0, -1.0);
			// draw text
			CTFrameDraw(drawFrame, context);
		}
		// cleanup
		if (drawFrame) CFRelease(drawFrame);
		CGPathRelease(mainPath);
	}
}

- (void)drawImages
{    
	CGMutablePathRef mainPath = CGPathCreateMutable();
    if (!_path) 
    {
        CGPathAddRect(mainPath, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));  
    }
    else 
    {
        CGPathAddPath(mainPath, NULL, _path);
    }
	
    CTFrameRef ctframe = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), mainPath, NULL);
    CGPathRelease(mainPath);
	
    NSArray *lines = (NSArray *)CTFrameGetLines(ctframe);
    NSInteger lineCount = [lines count];
    CGPoint origins[lineCount];
	
	CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), origins);
	
	RichTextNode *imageNode = [_images objectAtIndex:0];
	
	for (int i = 0; i < lineCount; i++) 
    {
		CGPoint baselineOrigin = origins[i];
		//the view is inverted, the y origin of the baseline is upside down
		baselineOrigin.y = CGRectGetHeight(self.frame) - baselineOrigin.y;
		
		CTLineRef line = (CTLineRef)[lines objectAtIndex:i];
		CFRange cfrange = CTLineGetStringRange(line);        
		
        if (cfrange.location > imageNode.styleRange.location) 
        {
			CGFloat ascent, descent;
			CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
			
			CGRect lineFrame = CGRectMake(baselineOrigin.x, baselineOrigin.y - ascent, lineWidth, ascent + descent);
			
			CTTextAlignment alignment = imageNode.style.textAlignment;
			
			UIImage *img = [UIImage imageNamed:imageNode.imageName];
			if (img) 
            {
				int x = 0;
				if (alignment == kCTRightTextAlignment) x = (self.frame.size.width - img.size.width);
				if (alignment == kCTCenterTextAlignment) x = ((self.frame.size.width - img.size.width) / 2);
				
				CGRect frame = CGRectMake(x, (lineFrame.origin.y - img.size.height), img.size.width, img.size.height);
                
                // adjusting frame
				
                UIEdgeInsets insets = imageNode.style.paragraphInset;
                if (alignment != kCTCenterTextAlignment) frame.origin.x = (alignment == kCTLeftTextAlignment)? insets.left : (self.frame.size.width - img.size.width - insets.right);
                frame.origin.y += insets.top;
                frame.size.width = ((insets.left + insets.right + img.size.width ) > self.frame.size.width)? self.frame.size.width : img.size.width;
                
				[img drawInRect:CGRectIntegral(frame)];
			}
			
			NSInteger imageNodeIndex = [_images indexOfObject:imageNode];
			if (imageNodeIndex < [_images count] - 1) 
            {
				imageNode = [_images objectAtIndex:imageNodeIndex + 1];
			}
			else 
            {
				break;
			}
		}
	}
	CFRelease(ctframe);
}

#pragma mark User Interaction

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	
	if (![self isSystemUnder3_2])
    {
		if (self.delegate && ([self.delegate respondsToSelector:@selector(touchedData:inCoreTextView:)] || [self.delegate respondsToSelector:@selector(coreTextView:receivedTouchOnData:)])) 
        {
			CGPoint point = [(UITouch *)[touches anyObject] locationInView:self];
			NSDictionary *data = [self dataForPoint:point];
			if (data) 
            {
				if ([self.delegate respondsToSelector:@selector(coreTextView:receivedTouchOnData:)]) 
                {
					[self.delegate coreTextView:self receivedTouchOnData:data];
				}
				else 
                {
					if ([self.delegate respondsToSelector:@selector(touchedData:inCoreTextView:)]) 
                    {
						[self.delegate touchedData:data inCoreTextView:self];
					}
				}
			}
		}
	}
}

@end

@implementation NSString (FTCoreText)
- (NSString *)stringByAppendingTagName:(NSString *)tagName
{
	return [NSString stringWithFormat:@"<%@>%@</%@>", tagName, self, tagName];
}
@end
