//
//  QRCodeViewController.m
//  CustomControlDemo
//
//  Created by ligf on 13-6-17.
//  Copyright (c) 2013年 用友软件股份有限公司. All rights reserved.
//

#import "QRCodeViewController.h"

@interface QRCodeViewController ()
{
    UILabel             *_lblInfo;
    UIImageView         *_imageQRCode;
}

@property (nonatomic, retain) UILabel *lblInfo;
@property (nonatomic, retain) UIImageView *imageQRCode;

@end

@implementation QRCodeViewController
@synthesize lblInfo = _lblInfo;
@synthesize imageQRCode = _imageQRCode;

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
	
    self.imageQRCode = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 280, 280)];
    _imageQRCode.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_imageQRCode];
    [_imageQRCode release];
    
    UIButton *btnSure = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnSure setTitle:NSLocalizedString(@"sure", nil) forState:UIControlStateNormal];
    [btnSure setFrame:CGRectMake(20, 355, 280, 37)];
    [btnSure addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSure];
    
    self.lblInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, 405, 280, 45)];
    [self.view addSubview:_lblInfo];
    [_lblInfo release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    self.lblInfo = nil;
    self.imageQRCode = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [_lblInfo release];
    [_imageQRCode release];
    [super dealloc];
}

/*
 扫描二维码：
 导入ZBarSDK文件夹和libzbar.a文件并引入如下框架
 AVFoundation.framework
 CoreMedia.framework
 CoreVideo.framework
 QuartzCore.framework
 libiconv.dylib
 引入头文件#import “ZBarSDK.h” 即可使用
 当找到条形码时，会执行代理方法
 
 - (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
 
 最后读取并显示了条形码的图片和内容。
 */
- (void)btnClicked:(id)sender
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentViewController:reader animated:YES completion:nil];
    [reader release];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    _imageQRCode.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    [reader dismissViewControllerAnimated:YES completion:nil];
    
    // 判断是否包含 头'http:'
    NSString *regexHttp = @"http+:[^\\s]*";
    NSPredicate *predicateHttp = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexHttp];
    
    // 判断是否包含 头'www.'
    NSString *regexWWW = @"www+.[^\\s]*";;
    NSPredicate *predicateWWW = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexWWW];
    
    _lblInfo.text = symbol.data ;
    
    if ([predicateHttp evaluateWithObject:_lblInfo.text] ||[predicateWWW evaluateWithObject:_lblInfo.text])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"是否打开链接"
                                                        message:_lblInfo.text
                                                       delegate:nil
                                              cancelButtonTitle:@"否"
                                              otherButtonTitles:@"是", nil];
        alert.delegate = self;
        [alert show];
        [alert release];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            
            break;
        case 1:
        {
            NSURL *url;
            // 判断是否包含 头'www.'
            NSString *regexWWW = @"www+.[^\\s]*";;
            NSPredicate *predicateWWW = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexWWW];
            
            if ([predicateWWW evaluateWithObject:_lblInfo.text])
            {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",_lblInfo.text]];
            }
            else
            {
                url = [NSURL URLWithString:_lblInfo.text];
            }
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
        default:
            break;
    }
}

@end
