//
//  ShakeViewController.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-24.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "ShakeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TimeHelper.h"

@interface ShakeViewController ()

@end

@implementation ShakeViewController

#pragma mark - 生命周期方法

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
	UILabel *lblShake = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 40)];
    lblShake.text = NSLocalizedString(@"shake", nil);
    [lblShake setFont:[UIFont boldSystemFontOfSize:28]];
    [self.view addSubview:lblShake];
    [lblShake release];
    
    _ivShake = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedString(@"shakeimage", nil)]];
    [_ivShake setFrame:CGRectMake(50, 60, 270, 270)];
    [self.view addSubview:_ivShake];
    [_ivShake release];
    
    UILabel *lblInterval = [[UILabel alloc] initWithFrame:CGRectMake(10, 340, 150, 30)];
    lblInterval.text = [TimeHelper intervalSinceNow:@"2013-06-12 18:00:00"];
    [self.view addSubview:lblInterval];
    [lblInterval release];
    
    UIButton *btnShake = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnShake setFrame:CGRectMake(160, 340, 160, 30)];
    [btnShake setTitle:NSLocalizedString(@"shake", nil) forState:UIControlStateNormal];
    btnShake.tag = 1000;
    [btnShake addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnShake];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:NSLocalizedString(@"shakeaudio", nil) ofType:@"wav"];
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &_soundID);
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
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

#pragma mark - 自定义方法

-(void)addAnimations
{
    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"transform"];
    translation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translation.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI_4, 0, 0, 100)];
    
    translation.duration = 0.2;
    translation.repeatCount = 2;
    translation.autoreverses = YES;
    
    [_ivShake.layer addAnimation:translation forKey:@"translation"];
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    
    if(motion==UIEventSubtypeMotionShake)
    {
        [self addAnimations];
        AudioServicesPlaySystemSound (_soundID);	
        
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"李高峰!" message:@"您得到一条数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    [alert release];
    
}

- (void)btnClicked:(id)sender
{
    UIButton *btnSender = (UIButton *)sender;
    switch (btnSender.tag)
    {
        case 1000:
        {
            [self addAnimations];
            AudioServicesPlaySystemSound (_soundID);
        }
            break;
            
        default:
            break;
    }
}

@end
