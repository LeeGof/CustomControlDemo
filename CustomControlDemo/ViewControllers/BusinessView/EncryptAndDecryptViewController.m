//
//  EncryptAndDecryptViewController.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-9-3.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "EncryptAndDecryptViewController.h"
#import "EncryptDecryptHelper.h"

@interface EncryptAndDecryptViewController ()
{
    UITextField         *_txtSource; 
    UITextField         *_txtMd5;
    UITextField         *_txtSha1;
    UITextField         *_txtAesEncrypt;
    UITextField         *_txtAesDecrypt;
}

@end

@implementation EncryptAndDecryptViewController

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
    UILabel *lblSource = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 90, 30)];
    lblSource.textAlignment = UITextAlignmentRight;
    lblSource.text = NSLocalizedString(@"source", nil);
    [self.view addSubview:lblSource];
    [lblSource release];
    _txtSource = [[UITextField alloc] initWithFrame:CGRectMake(105, 90, 205, 30)];
    _txtSource.textAlignment = UITextAlignmentLeft;
    [_txtSource setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:_txtSource];
    [_txtSource release];
    
    UILabel *lblAesEncrypt = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, 90, 30)];
    lblAesEncrypt.textAlignment = UITextAlignmentRight;
    lblAesEncrypt.text = NSLocalizedString(@"aesencrypt", nil);
    [self.view addSubview:lblAesEncrypt];
    [lblAesEncrypt release];
    _txtAesEncrypt = [[UITextField alloc] initWithFrame:CGRectMake(105, 130, 205, 30)];
    _txtAesEncrypt.textAlignment = UITextAlignmentLeft;
    _txtAesEncrypt.enabled = NO;
    [_txtAesEncrypt setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:_txtAesEncrypt];
    [_txtAesEncrypt release];
    
    UILabel *lblSha1Encrypt = [[UILabel alloc] initWithFrame:CGRectMake(10, 170, 90, 30)];
    lblSha1Encrypt.textAlignment = UITextAlignmentRight;
    lblSha1Encrypt.text = NSLocalizedString(@"sha1", nil);
    [self.view addSubview:lblSha1Encrypt];
    [lblSha1Encrypt release];
    _txtSha1 = [[UITextField alloc] initWithFrame:CGRectMake(105, 170, 205, 30)];
    _txtSha1.textAlignment = UITextAlignmentLeft;
    _txtSha1.enabled = NO;
    [_txtSha1 setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:_txtSha1];
    [_txtSha1 release];
    
    UILabel *lblMd5Encrypt = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, 90, 30)];
    lblMd5Encrypt.textAlignment = UITextAlignmentRight;
    lblMd5Encrypt.text = NSLocalizedString(@"md5", nil);
    [self.view addSubview:lblMd5Encrypt];
    [lblMd5Encrypt release];
    _txtMd5 = [[UITextField alloc] initWithFrame:CGRectMake(105, 210, 205, 30)];
    _txtMd5.textAlignment = UITextAlignmentLeft;
    _txtMd5.enabled = NO;
    [_txtMd5 setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:_txtMd5];
    [_txtMd5 release];
    
    UILabel *lblAesDecrypt = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 90, 30)];
    lblAesDecrypt.textAlignment = UITextAlignmentRight;
    lblAesDecrypt.text = NSLocalizedString(@"aesdecrypt", nil);
    [self.view addSubview:lblAesDecrypt];
    [lblAesDecrypt release];
    _txtAesDecrypt = [[UITextField alloc] initWithFrame:CGRectMake(105, 250, 205, 30)];
    _txtAesDecrypt.textAlignment = UITextAlignmentLeft;
    _txtAesDecrypt.enabled = NO;
    [_txtAesDecrypt setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:_txtAesDecrypt];
    [_txtAesDecrypt release];
    
    UIButton *btnEncrypt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnEncrypt setFrame:CGRectMake(10, 10, 300, 30)];
    [btnEncrypt setTitle:NSLocalizedString(@"encrypt", nil) forState:UIControlStateNormal];
    btnEncrypt.tag = 1000;
    [btnEncrypt addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnEncrypt];
    
    UIButton *btnDecrypt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnDecrypt setFrame:CGRectMake(10, 50, 300, 30)];
    [btnDecrypt setTitle:NSLocalizedString(@"decrypt", nil) forState:UIControlStateNormal];
    btnDecrypt.tag = 1001;
    [btnDecrypt addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDecrypt];
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
    UIButton *btnSender = (UIButton *)sender;
    [_txtSource resignFirstResponder];
    switch (btnSender.tag) 
    {
        case 1000:
        {
            if ([_txtSource text] && [[_txtSource text] length] > 0) 
            {
                _txtAesEncrypt.text = [EncryptDecryptHelper aesEncrypt:_txtSource.text forKey:@"1"];
                _txtMd5.text = [EncryptDecryptHelper md5:_txtSource.text];
                _txtSha1.text = [EncryptDecryptHelper sha1:_txtSource.text];
            }
            break;
        }
        case 1001:
        {
            if ([_txtAesEncrypt text] && [[_txtAesEncrypt text] length] > 0) 
            {
                _txtAesDecrypt.text = [EncryptDecryptHelper aesDecrypt:_txtAesEncrypt.text forKey:@"1"];
            }
            break;
        }
        default:
            break;
    }
}

@end
