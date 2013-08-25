//
//  CheckBoxViewController.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-20.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "CheckBoxViewController.h"
#import "CheckButton.h"

@interface CheckBoxViewController ()

@end

@implementation CheckBoxViewController
@synthesize checkGroupView = _checkGroupView;

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
    lblTitle.text = NSLocalizedString(@"whichfood", nil);
    [self.view addSubview:lblTitle];
    [lblTitle release];
    
    _checkGroupView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 320, 270)];
    
    CheckButton *chkFood = [[CheckButton alloc] initWithFrame:CGRectMake(20, 0, 260, 32)];
    chkFood.lblTitle.text = NSLocalizedString(@"fish", nil);
    chkFood.iValue = 1;
    chkFood.style = CheckButtonStyleDefault;
    [_checkGroupView addSubview:chkFood];
    [chkFood release];
    
    chkFood = [[CheckButton alloc] initWithFrame:CGRectMake(20, 40, 260, 32)];
    chkFood.lblTitle.text = NSLocalizedString(@"meat", nil) ;
    chkFood.iValue = 2;
    chkFood.style = CheckButtonStyleDefault ;
    [_checkGroupView addSubview:chkFood];
    [chkFood release]; 
    
    [self.view addSubview:_checkGroupView];
    
    UIButton *btnClick = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnClick.frame = CGRectMake(10, 370, 300, 30);
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
    NSMutableString *strMsg = [[NSMutableString alloc] initWithCapacity:20];
    
    NSArray *arrSubViews = [_checkGroupView subviews];
    if (arrSubViews && [arrSubViews count] > 0) {
        for (int i = 0; i < [arrSubViews count]; i++) {
            CheckButton *chk = (CheckButton *)[arrSubViews objectAtIndex:i];
            if (chk.isChecked) {
                [strMsg appendFormat:@"%@  ",chk.lblTitle.text];
            }
        }
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:strMsg delegate:nil cancelButtonTitle:NSLocalizedString(@"sure", nil) otherButtonTitles: nil];
    [alert show];
    [alert release];
    [strMsg release];
}

@end
