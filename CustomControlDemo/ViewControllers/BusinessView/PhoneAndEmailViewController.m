//
//  PhoneAndEmailViewController.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-29.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "PhoneAndEmailViewController.h"
#import "TelephoneNumberFunction.h"
#import "EmailFunction.h"

@interface PhoneAndEmailViewController ()
{
    UILabel     *_lblPhone;
    UILabel     *_lblEmail;
    
    UIButton    *_btnEmail;
    UIButton    *_btnPhone;
}

@property (nonatomic, retain) UILabel *lblPhone;
@property (nonatomic, retain) UILabel *lblEmail;
@property (nonatomic, retain) UIButton *btnEmail;
@property (nonatomic, retain) UIButton *btnPhone;

@end

@implementation PhoneAndEmailViewController

@synthesize lblEmail = _lblEmail;
@synthesize lblPhone = _lblPhone;
@synthesize btnEmail = _btnEmail;
@synthesize btnPhone = _btnPhone;

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
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
    self.lblEmail = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)] autorelease];
    _lblEmail.text = NSLocalizedString(@"email", nil);
    _lblEmail.textAlignment = UITextAlignmentRight;
    _lblEmail.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_lblEmail];
    
    self.btnEmail = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnEmail setFrame:CGRectMake(115, 10, 200, 30)];
    [_btnEmail setTitle:@"ligfc@ufida.com" forState:UIControlStateNormal];
    _btnEmail.titleLabel.textColor = [UIColor colorWithRed:0.19608 green:0.30980 blue:0.52157 alpha:1.0];
    _btnEmail.titleLabel.textAlignment = UITextAlignmentLeft;
    _btnEmail.tag = 1000;
    [_btnEmail addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnEmail];
    
    self.lblPhone = [[[UILabel alloc] initWithFrame:CGRectMake(10, 50, 100, 30)] autorelease];
    _lblPhone.text = NSLocalizedString(@"phone", nil);
    _lblPhone.textAlignment = UITextAlignmentRight;
    _lblPhone.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_lblPhone];
    
    self.btnPhone = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnPhone setFrame:CGRectMake(115, 50, 200, 30)];
    [_btnPhone setTitle:@"18701697873" forState:UIControlStateNormal];
    _btnPhone.titleLabel.textAlignment = UITextAlignmentLeft;
    _btnPhone.titleLabel.textColor = [UIColor colorWithRed:0.19608 green:0.30980 blue:0.52157 alpha:1.0];
    _btnPhone.tag = 1001;
    [_btnPhone addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnPhone];
}

- (void)viewDidUnload
{
    self.lblEmail = nil;
    self.lblPhone = nil;
    self.btnEmail = nil;
    self.btnPhone = nil;
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [_lblEmail release];
    [_lblPhone release];
    [_btnEmail release];
    [_btnPhone release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
     
- (void)btnClicked:(id)sender
{
    UIButton *btnSender = (UIButton *)sender;
    
    switch (btnSender.tag) {
        case 1000:
        {
            EmailFunction *email=[[EmailFunction alloc] init];
            NSString *emailStr = [[NSString alloc ] initWithFormat:@"%@",_btnEmail.titleLabel.text];
            [email sendEmailToAddress:emailStr];
            [emailStr release];
            [email release];
            break;
        }  
        case 1001:
        {
            // 判断phone设备
            NSString* deviceType = [UIDevice currentDevice].model;
            if ([deviceType isEqualToString:@"iPhone"])
            {
                // TODO:调用打电话接口
                TelephoneNumberFunction *telephone = [[TelephoneNumberFunction alloc] init];
                NSString *telStr = [[NSString alloc ] initWithFormat:@"%@",_btnPhone.titleLabel.text];
                
                [telephone callTheNumber:telStr];
                [telStr release];
                [telephone release];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"nophoneinfo", nil) delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            
            break;
        }
        default:
            break;
    }
}

@end
