//
//  VoiceViewController.m
//  CustomControlDemo
//
//  Created by ligf on 12-12-19.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "VoiceViewController.h"
#import "Constants.h"

@interface VoiceViewController ()
{
    UITextView      *tvContent;
}

@end

@implementation VoiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    tvContent = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, 300, 100)];
    [tvContent setText:@"迅飞语音"];
    [self.view addSubview:tvContent];
    [tvContent release];
    
    UIButton *btnVoiceRecognize = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnVoiceRecognize setFrame:CGRectMake(10, 160, 145, 50)];
    [btnVoiceRecognize setTitle:NSLocalizedString(@"voicerecognize",nil) forState:UIControlStateNormal];
    btnVoiceRecognize.tag = 1000;
    [btnVoiceRecognize addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnVoiceRecognize];
    
    UIButton *btnVoiceCompound = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnVoiceCompound setTitle:NSLocalizedString(@"voicecompound", nil) forState:UIControlStateNormal];
    [btnVoiceCompound setFrame:CGRectMake(165, 160, 145, 50)];
    btnVoiceCompound.tag = 1001;
    [btnVoiceCompound addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnVoiceCompound];
    
    NSString *initParam = [[NSString alloc] initWithFormat:
						   @"server_url=%@,appid=%@",ENGINE_URL,APPID];
    
    // 初始化语音识别控件
	_iFlyRecognizeControl = [[IFlyRecognizeControl alloc] initWithOrigin:CGPointMake(20, 70) initParam:initParam];
    [self.view addSubview:_iFlyRecognizeControl];
    // 设置语音识别控件的参数,具体参数可参看开发文档
	[_iFlyRecognizeControl setEngine:@"sms" engineParam:nil grammarID:nil];
	[_iFlyRecognizeControl setSampleRate:16000];
	_iFlyRecognizeControl.delegate = self;
    
    // 初始化语音合成控件
	_iFlySynthesizerControl = [[IFlySynthesizerControl alloc] initWithOrigin:CGPointMake(20, 70) initParam:initParam];
    // 配置语音合成控件，比如采样率，委托对象，发音人等等。
	_iFlySynthesizerControl.delegate = self;
	[self.view addSubview:_iFlySynthesizerControl];
    [_iFlySynthesizerControl setShowUI: YES];
    
    [initParam release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnClicked:(id)sender
{
    UIButton *btnSender = (UIButton *)sender;
    
    switch (btnSender.tag)
    {
        case 1000:
        {
            if([_iFlyRecognizeControl start])
            {
                // 开始语音识别时的一些页面设置
            }
            break;
        }
        case 1001:
        {
            [_iFlySynthesizerControl setText:tvContent.text params:nil];
            
            // 调用start方法，开始合成
            if([_iFlySynthesizerControl start])
            {
                // 开始语音合成时的一些页面设置
            }
            else
            {
                NSLog(@"start errror");
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - IFlyRecognizeControlDelegate
//  识别结束回调函数，当整个会话过程结束时候会调用这个函数
- (void)onRecognizeEnd:(IFlyRecognizeControl *)iFlyRecognizeControl theError:(SpeechError) error
{
	NSLog(@"getUpflow:%d,getDownflow:%d",[iFlyRecognizeControl getUpflow],[iFlyRecognizeControl getDownflow]);
	
}

//  recognition result callback
//  识别结果回调函数
- (void)onResult:(IFlyRecognizeControl *)iFlyRecognizeControl theResult:(NSArray *)resultArray
{
	[self onRecognizeResult:resultArray];
}

- (void)onRecognizeResult:(NSArray *)array
{
    //  execute the onUpdateTextView function in main thread
    //  在主线程中执行onUpdateTextView方法
	[self performSelectorOnMainThread:@selector(onUpdateTextView:) withObject:
	 [[array objectAtIndex:0] objectForKey:@"NAME"] waitUntilDone:YES];
}

//  设置textview中的文字，既返回的识别结果
- (void)onUpdateTextView:(NSString *)sentence
{
	NSString *str = [[NSString alloc] initWithFormat:@"%@%@", tvContent.text, sentence];
	tvContent.text = str;
	NSLog(@"str");
}

#pragma mark - IFlySynthesizerControlDelegate
//  合成回调函数，当你执行了cancel函数，整个会话结束时，会调用这个函数
- (void)onSynthesizerEnd:(IFlySynthesizerControl *)iFlySynthesizerControl theError:(SpeechError) error
{
    // 获取上传流量和下载流量
	NSLog(@"upFlow:%d,downFlow:%d",[iFlySynthesizerControl getUpflow],[iFlySynthesizerControl getDownflow]);
}

// get the player buffer progress
// 获取播放器缓冲进度
- (void)onSynthesizerBufferProgress:(float)bufferProgress
{
    NSLog(@"the playing buffer :%f",bufferProgress);
}

// get the player progress
// 获取播放器的播放进度
- (void)onSynthesizerPlayProgress:(float)playProgress
{
    NSLog(@"the playing progress :%f",playProgress);
}

@end
