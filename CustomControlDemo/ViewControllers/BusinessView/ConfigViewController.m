//
//  ConfigViewController.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-31.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "ConfigViewController.h"
#import "ConfigHelper.h"
#import "DeviceInfoHelper.h"
#import "Constants.h"

@interface ConfigViewController ()
{
    UITextField     *_txtName;
    UIButton        *_btnRead;
    UIButton        *_btnWrite;
}

@end

@implementation ConfigViewController

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
    
    [ConfigHelper createConfig:CONFIG_FILE_NAME];
	
    _txtName = [[UITextField alloc] init];
    [_txtName setFrame:CGRectMake(10, 10, 300, 30)];
    [_txtName setBorderStyle:UITextBorderStyleRoundedRect]; 
    _txtName.text = [DeviceInfoHelper getMacAddress];
    [self.view addSubview:_txtName];
    [_txtName release];
    
    _btnRead = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btnRead setFrame:CGRectMake(10, 50, 300, 30)];
    [_btnRead setTitle:NSLocalizedString(@"read", nil) forState:UIControlStateNormal];
    [_btnRead addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnRead.tag = 1000;
    [self.view addSubview:_btnRead];
    
    _btnWrite = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btnWrite setFrame:CGRectMake(10, 90, 300, 30)];
    [_btnWrite setTitle:NSLocalizedString(@"write", nil) forState:UIControlStateNormal];
    [_btnWrite addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnWrite.tag = 1001;
    [self.view addSubview:_btnWrite];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
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
            _txtName.text = [ConfigHelper getValueForKey:@"name" fileName:CONFIG_FILE_NAME];
            break;
        }
        case 1001:
        {
            if (_txtName.text) 
            {
                [ConfigHelper setValue:_txtName.text forKey:@"name" fileName:CONFIG_FILE_NAME];
            }
            
            break;
        }
        default:
            break;
    }
}

@end
