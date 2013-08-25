//
//  RichTextViewController.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-9-6.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "RichTextViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

@interface RichTextViewController ()

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) RichTextView *richTextView;

@end

@implementation RichTextViewController
@synthesize scrollView;
@synthesize richTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //add coretextview
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    richTextView = [[RichTextView alloc] initWithFrame:CGRectMake(20, 20, 280, 0)];
	richTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // set text
    [richTextView setText:[self textForTextView:@"胡锦涛"]];
    // set styles
    [richTextView addStyles:[self richTextStyle]];
    // set delegate
    [richTextView setDelegate:self];
	
	[richTextView fitToSuggestedHeight];
    
    [scrollView addSubview:richTextView];
    [scrollView setContentSize:CGSizeMake(CGRectGetWidth(scrollView.bounds), CGRectGetHeight(richTextView.frame) + 40)];
    
    [self.view addSubview:scrollView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [scrollView setContentSize:CGSizeMake(CGRectGetWidth(scrollView.bounds), CGRectGetHeight(richTextView.frame) + 40)];
}

- (void)dealloc
{
	[richTextView release];
	[scrollView release];
	[super dealloc];
}

#pragma mark - 自定义方法

- (NSArray *)richTextStyle
{
    NSMutableArray *result = [NSMutableArray array];
    
	RichTextStyle *defaultStyle = [RichTextStyle new];
	defaultStyle.strStyleName = RICHTEXTVIEW_TAG_DEFAULT;	
	defaultStyle.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:18.f];
	defaultStyle.textAlignment = RichTextAlignementJustified;
	[result addObject:defaultStyle];
    
    RichTextStyle *coloredStyle = [defaultStyle copy];
    [coloredStyle setStrStyleName:RICHTEXTVIEW_TAG_COLOR];
    [coloredStyle setColor:[UIColor redColor]];
	[result addObject:coloredStyle];
    [defaultStyle release];
    [coloredStyle release];
    
    return  result;
}

- (NSString *)textForTextView:(NSString *)strColor
{
    NSString *strContent = [NSString stringWithFormat:@"%@",@"　　原标题：胡锦涛今起出席亚太经合组织(APEC)第20次领导人非正式会议  \r\n    人民网北京9月6日电(苏楠) 应俄罗斯总统普京邀请，国家主席胡锦涛将于9月6日至9日出席在俄罗斯符拉迪沃斯托克举行的亚太经合组织第二十次领导人非正式会议。会议期间，中国国家主席胡锦涛、俄罗斯总统普京等21个经济体领导人将就促进亚太地区的发展与繁荣问题进行深入探讨。此外，中俄元首还将举行双边会见，就两国全面战略协作伙伴关系发展和共同关心的国际与地区问题深入交换意见。 \r\n    胡锦涛将出席多场会议 阐述对推动世界和亚太经济发展的看法主张 \r\n    外交部8月30日举行中外媒体吹风会，外交部部长助理马朝旭、商务部部长助理俞建华介绍了胡锦涛主席出席会议的重要意义、背景情况和主要活动。 \r\n    胡锦涛主席将在领导人非正式会议上，阐述中方对推动世界和亚太地区经济发展的看法主张，以及关于今年亚太经合组织重点议题的观点立场，回顾20年来亚太经合组织发展历程，展望亚太经合组织发展未来。"];
    return [strContent stringByReplacingOccurrencesOfString:strColor withString:[NSString stringWithFormat:@"<%@>%@</%@>",RICHTEXTVIEW_TAG_COLOR,strColor,RICHTEXTVIEW_TAG_COLOR]];
}

#pragma mark - RichTextViewDelegate

- (void)coreTextView:(RichTextView *)coreTextView receivedTouchOnData:(NSDictionary *)data
{
    CGRect frame = CGRectFromString([data objectForKey:RICHTEXTVIEW_TAG_DATAFRAME]);
    
    if (CGRectEqualToRect(CGRectZero, frame)) return;
    
    frame.origin.x -= 3;
    frame.origin.y -= 1;
    frame.size.width += 6;
    frame.size.height += 6;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view.layer setCornerRadius:3];
    [view setBackgroundColor:[UIColor orangeColor]];
    [view setAlpha:0];
    [richTextView.superview addSubview:view];
    [UIView animateWithDuration:0.2 animations:^{
        [view setAlpha:0.4];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            [view setAlpha:0];
        }];
    }];
    
    NSURL *url = [data objectForKey:RICHTEXTVIEW_TAG_DATAURL];
    if (!url) return;
    [[UIApplication sharedApplication] openURL:url];
    
    return;
}

@end
