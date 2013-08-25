//
//  RadioViewController.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-20.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "RadioViewController.h"

@interface RadioViewController ()
- (void)btnClicked:(id)sender;
@end

@implementation RadioViewController

#pragma mark - View lifecycle

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
	// Do any additional setup after loading the view.
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 260, 30)];
    lblTitle.text = NSLocalizedString(@"whichseason", nil);
    [self.view addSubview:lblTitle];
    [lblTitle release];
    
    // 单选按钮组
    _rgSeason = [[ RadioGroup alloc] init];
    
    // Spring
    CheckButton *cbSeason = [[CheckButton alloc] initWithFrame:CGRectMake (20, 60, 260, 32)];
    [_rgSeason addRadio:cbSeason];
    cbSeason.lblTitle.text = NSLocalizedString(@"spring", nil);
    cbSeason.iValue = 1;
    cbSeason.style = CheckButtonStyleRadio ;
    cbSeason.checked = YES;
    _rgSeason.iSelectSerial = 0;
    _rgSeason.strSelText = NSLocalizedString(@"spring", nil);
    
    [self.view addSubview:cbSeason];
    [cbSeason release]; 
    
    // Summer
    cbSeason = [[CheckButton alloc] initWithFrame:CGRectMake(20, 100, 260, 32)];
    [_rgSeason addRadio:cbSeason];
    cbSeason.lblTitle.text = NSLocalizedString(@"summer", nil);
    cbSeason.iValue = 2;
    cbSeason.style = CheckButtonStyleRadio;
    [self.view addSubview:cbSeason];
    [cbSeason release]; 
    
    // Autumn
    cbSeason = [[CheckButton alloc] initWithFrame:CGRectMake(20, 140, 260, 32)];
    [_rgSeason addRadio:cbSeason];
    cbSeason.lblTitle.text = NSLocalizedString(@"autumn", nil);
    cbSeason.iValue = 3;
    cbSeason.style = CheckButtonStyleRadio ;
    [self.view addSubview:cbSeason];
    [cbSeason release]; 
    
    // Winter
    cbSeason = [[CheckButton alloc] initWithFrame:CGRectMake(20, 180, 260, 32)];
    [_rgSeason addRadio:cbSeason];
    cbSeason.lblTitle.text = NSLocalizedString(@"winter", nil);
    cbSeason.iValue = 4;
    cbSeason.style = CheckButtonStyleRadio ;
    [self.view addSubview:cbSeason];
    [cbSeason release]; 
    
    UIButton *btnClick = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnClick.frame = CGRectMake(10, 240, 300, 30);
    [btnClick setTitle:NSLocalizedString(@"btnselect", nil) forState:UIControlStateNormal];
    [btnClick addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnClick];
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

- (void)btnClicked:(id)sender
{
//    NSString *strMsg = [NSString stringWithFormat:@"当前选中第%d项",_rgSeason.iSelectSerial];
    NSString *strMsg = [NSString stringWithFormat:@"%@",_rgSeason.strSelText];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:strMsg delegate:nil cancelButtonTitle:NSLocalizedString(@"sure", nil) otherButtonTitles: nil];
    [alert show];
    [alert release];
}

@end
