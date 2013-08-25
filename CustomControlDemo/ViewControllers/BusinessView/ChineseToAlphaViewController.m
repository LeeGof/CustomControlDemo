//
//  ChineseToAlphaViewController.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-22.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "ChineseToAlphaViewController.h"
#import "PYMethod.h"
#import "pinyin.h"
#import "POAPinyin.h"

@interface ChineseToAlphaViewController ()
- (void)btnClick:(id)sender;
@end

@implementation ChineseToAlphaViewController

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
    self.view.backgroundColor = [UIColor grayColor];
    _txtField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 210, 30)];
    _txtField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_txtField];
    [_txtField release];
    
	_btnConvert = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btnConvert setFrame:CGRectMake(225, 10, 85, 30)];
    [_btnConvert setTitle:NSLocalizedString(@"convert", nil) forState:UIControlStateNormal];
    [_btnConvert addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnConvert];
//    [_btnConvert release];
    
    _tvResult = [[UITextView alloc] initWithFrame:CGRectMake(10, 45, 300, 360)];
    [_tvResult setEditable:NO];
    
    [self.view addSubview:_tvResult];
    [_tvResult release];
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

- (void)btnClick:(id)sender
{
    [_txtField resignFirstResponder];
    if ([_txtField.text length] > 0)
    {
        NSMutableString *strResult = [[NSMutableString alloc] initWithCapacity:1000];
        
        clock_t begin = clock();
        NSMutableString* string = [NSMutableString stringWithString:@""];
        
        [string appendFormat:@"获取首字母：%@",[self getFirstLetter:_txtField.text]];
        
        for (int i = 0; i < [_txtField.text length]; i++)
        {
            [string appendFormat:@"%c",pinyinFirstLetter([_txtField.text characterAtIndex:i])];
        }
        [strResult appendFormat:@"pinyinFirstLetter %@:%@",NSLocalizedString(@"result", nil),string];
        clock_t end = clock();
        [strResult appendFormat:@"\n\n"];
        [strResult appendFormat:@"pinyinFirstLetter %@:%f s",NSLocalizedString(@"time", nil),(end - begin)/(float)CLOCKS_PER_SEC];
        [strResult appendFormat:@"\n\n"];
        
        // symbol
        begin = clock();
        [strResult appendFormat:@"PYMethod getPinYin %@:%@",NSLocalizedString(@"result", nil),[PYMethod getPinYin:_txtField.text]];
        end = clock();
        [strResult appendFormat:@"\n\n"];
        [strResult appendFormat:@"PYMethod getPinYin %@:%f s",NSLocalizedString(@"time",nil),(end - begin)/(float)CLOCKS_PER_SEC];
        [strResult appendFormat:@"\n\n"];   
        
        // oapinyin
        begin = clock();
        [strResult appendFormat:@"POAPinyin quickConvert %@:%@",NSLocalizedString(@"result", nil),[POAPinyin quickConvert:_txtField.text]];
        end = clock();
        [strResult appendFormat:@"\n\n"];
        [strResult appendFormat:@"POAPinyin quickConvert %@:%f s",NSLocalizedString(@"time",nil),(end - begin)/(float)CLOCKS_PER_SEC];
        [strResult appendFormat:@"\n\n"];   
        
        begin = clock();
        [strResult appendFormat:@"POAPinyin convert %@:%@",NSLocalizedString(@"result", nil),[POAPinyin convert:_txtField.text]];
        end = clock();
        [strResult appendFormat:@"\n\n"];
        [strResult appendFormat:@"POAPinyin convert %@:%f s",NSLocalizedString(@"time",nil),(end - begin)/(float)CLOCKS_PER_SEC];
        [strResult appendFormat:@"\n\n"];  
        
        begin = clock();
        [strResult appendFormat:@"POAPinyin stringConvert %@:%@",NSLocalizedString(@"result", nil),[POAPinyin stringConvert:_txtField.text]];
        end = clock();
        [strResult appendFormat:@"\n\n"];
        [strResult appendFormat:@"POAPinyin stringConvert %@:%f s",NSLocalizedString(@"time",nil),(end - begin)/(float)CLOCKS_PER_SEC];
        [strResult appendFormat:@"\n\n"]; 
        
        _tvResult.text = strResult;
        [strResult release];
    }
}

//获取名称的首字母
- (NSString *)getFirstLetter:(NSString *)strName
{
    
    NSString *strRet;
    NSString *strChina = strName;//汉字拼音转换
    NSMutableArray *arrLetter = [[NSMutableArray alloc] init];//存储拼音字母
    for(int i = 0;i < [strChina length];i++)
    {
        NSString *str = [NSString stringWithFormat:@"%c",pinyinFirstLetter([strChina characterAtIndex:i])];
        [arrLetter addObject:str];
    }
    
    NSString *strCode = [NSString stringWithFormat:@"%@",[arrLetter objectAtIndex:0]];
    
    if (strCode == nil || strCode.length == 0)
    {
        strRet = @"";
    }
    else if([strCode isEqualToString:@"#"])
    {
        strCode = nil;
        strCode = [NSString stringWithFormat:@"%c",[strName characterAtIndex:0]];
        strRet = [NSString stringWithFormat:@"%@",[self getNameFirst:strCode]];
        
    }
    else
    {
        strRet = [NSString stringWithFormat:@"%@",[self getNameFirst:strCode]];
    }
    return strRet;
}

- (NSString *)getNameFirst:(NSString *)strCode
{
    NSString *strRet;
    if (strCode == nil || strCode.length == 0)
    {
        strRet = @"";
    }
    else
    {
        if ([strCode isEqualToString:@"a"] || [strCode isEqualToString:@"A"])
        {
            strRet = @"A";
        }
        else if ([strCode isEqualToString:@"b"] || [strCode isEqualToString:@"B"])
        {
            strRet = @"B";
        }
        else if ([strCode isEqualToString:@"c"] || [strCode isEqualToString:@"C"])
        {
            strRet  =  @"C";
        }
        else if ([strCode isEqualToString:@"d"] || [strCode isEqualToString:@"D"])
        {
            strRet = @"D";
        }
        else if ([strCode isEqualToString:@"e"] || [strCode isEqualToString:@"E"])
        {
            strRet = @"E";
        }
        else if ([strCode isEqualToString:@"f"] || [strCode isEqualToString:@"F"])
        {
            strRet = @"F";
        }
        else if ([strCode isEqualToString:@"g"] || [strCode isEqualToString:@"G"])
        {
            strRet = @"G";
        }
        else if ([strCode isEqualToString:@"h"] || [strCode isEqualToString:@"H"])
        {
            strRet = @"H";
        }
        else if ([strCode isEqualToString:@"i"] || [strCode isEqualToString:@"I"])
        {
            strRet = @"I";
        }
        else if ([strCode isEqualToString:@"j"] || [strCode isEqualToString:@"J"])
        {
            strRet = @"J";
        }
        else if ([strCode isEqualToString:@"k"] || [strCode isEqualToString:@"K"])
        {
            strRet = @"K";
        }
        else if ([strCode isEqualToString:@"l"] || [strCode isEqualToString:@"L"])
        {
            strRet = @"L";
        }
        else if ([strCode isEqualToString:@"m"] || [strCode isEqualToString:@"M"])
        {
            strRet = @"M";
        }
        else if ([strCode isEqualToString:@"n"] || [strCode isEqualToString:@"N"])
        {
            strRet = @"N";
        }
        else if ([strCode isEqualToString:@"o"] || [strCode isEqualToString:@"O"])
        {
            strRet = @"O";
        }
        else if ([strCode isEqualToString:@"p"] || [strCode isEqualToString:@"P"])
        {
            strRet = @"P";
        }
        else if ([strCode isEqualToString:@"q"] || [strCode isEqualToString:@"Q"])
        {
            strRet = @"Q";
        }
        else if ([strCode isEqualToString:@"r"] || [strCode isEqualToString:@"R"])
        {
            strRet = @"R";
        }
        else if ([strCode isEqualToString:@"s"] || [strCode isEqualToString:@"S"])
        {
            strRet = @"S";
        }
        else if ([strCode isEqualToString:@"t"] || [strCode isEqualToString:@"T"])
        {
            strRet = @"T";
        }
        else if ([strCode isEqualToString:@"u"] || [strCode isEqualToString:@"U"])
        {
            strRet = @"U";
        }
        else if ([strCode isEqualToString:@"v"] || [strCode isEqualToString:@"V"])
        {
            strRet = @"V";
        }
        else if ([strCode isEqualToString:@"w"] || [strCode isEqualToString:@"W"])
        {
            strRet = @"W";
        }
        else if ([strCode isEqualToString:@"x"] || [strCode isEqualToString:@"X"])
        {
            strRet = @"X";
        }
        else if ([strCode isEqualToString:@"y"] || [strCode isEqualToString:@"Y"])
        {
            strRet = @"Y";
        }
        else if ([strCode isEqualToString:@"z"] || [strCode isEqualToString:@"Z"])
        {
            strRet = @"Z";
        }
        else if ([strCode isEqualToString:@"#"])
        {
            strRet = @"##";
        }
        else
        {
            strRet = @"##";
        }
    }
    return strRet;
}

@end
