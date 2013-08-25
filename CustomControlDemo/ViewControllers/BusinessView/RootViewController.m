//
//  RootViewController.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-20.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "RootViewController.h"
#import "RadioViewController.h"
#import "CheckBoxViewController.h"
#import "DropDownListViewController.h"
#import "ChineseToAlphaViewController.h"
#import "ProgressViewController.h"
#import "AdvertisementViewController.h"
#import "ShakeViewController.h"
#import "GetPositionViewController.h"
#import "XMLDigesterViewController.h"
#import "PhoneAndEmailViewController.h"
#import "SqliteViewController.h"
#import "ConfigViewController.h"
#import "EncryptAndDecryptViewController.h"
#import "AsiHttpRequestViewController.h"
#import "RichTextViewController.h"
#import "RefreshTableViewController.h"
#import "DownloadAndUnzipViewController.h"
#import "PictureViewController.h"
#import "GifViewController.h"
#import "QRCodeViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController
@synthesize arrTableData = _arrTableData;
@synthesize tblControl = _tblControl;

#pragma mark - 生命周期

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
    
    self.title = NSLocalizedString(@"roottitle", nil);
    
	// Do any additional setup after loading the view.
    self.arrTableData = [NSArray arrayWithObjects:NSLocalizedString(@"radiobutton", nil),NSLocalizedString(@"checkbutton", nil),NSLocalizedString(@"dropdownlist", nil), NSLocalizedString(@"chinesetoalpha", nil), NSLocalizedString(@"loading", nil), NSLocalizedString(@"advertisement", nil), NSLocalizedString(@"shake", nil), NSLocalizedString(@"currposition", nil), NSLocalizedString(@"xmldigester", nil), NSLocalizedString(@"phoneandemail", nil), NSLocalizedString(@"sqlite", nil), NSLocalizedString(@"configfile", nil), NSLocalizedString(@"encryptdecrypt", nil), NSLocalizedString(@"asihttprequest", nil), NSLocalizedString(@"richtextview", nil), NSLocalizedString(@"tablerefresh", nil), NSLocalizedString(@"downandupzip", nil), NSLocalizedString(@"selectpic", nil), NSLocalizedString(@"displaygif", nil), NSLocalizedString(@"qrcode", nil), nil];
    
    _tblControl = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    _tblControl.delegate = self;
    _tblControl.dataSource = self;
    [self.view addSubview:_tblControl];
    [_tblControl release];
}

- (void)viewDidUnload
{
    self.arrTableData = nil;
    self.tblControl = nil;
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [_arrTableData release];
    [_tblControl release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Tableview DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arrTableData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [_tblControl dequeueReusableCellWithIdentifier:@"BaseCell"];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BaseCell"] autorelease];
    }
    cell.textLabel.text = [_arrTableData objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Tableview Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = NSLocalizedString(@"cancel", nil);
    self.navigationItem.backBarButtonItem=barButtonItem;
    [barButtonItem release];
    
    //进入详情页面
    switch (indexPath.row)
    {
        case 0:
        {
            RadioViewController *radioViewController = [[[RadioViewController alloc] init] autorelease];
            [self.navigationController pushViewController:radioViewController animated:YES];
        
            break;
        }
        case 1:
        {
            CheckBoxViewController *checkBoxViewController = [[[CheckBoxViewController alloc] init] autorelease];
            [self.navigationController pushViewController:checkBoxViewController animated:YES];
        
            break;
        }
        case 2:
        {
            DropDownListViewController *dropDownListViewController = [[[DropDownListViewController alloc] init] autorelease];
            [self.navigationController pushViewController:dropDownListViewController animated:YES];
            
            break;
        }
        case 3:
        {
            ChineseToAlphaViewController *chineseToAlphaViewController = [[[ChineseToAlphaViewController alloc] init] autorelease];
            [self.navigationController pushViewController:chineseToAlphaViewController animated:YES];
            
            break;
        }
        case 4:
        {
            ProgressViewController *progressViewController = [[[ProgressViewController alloc] init] autorelease];
            [self.navigationController pushViewController:progressViewController animated:YES];
            
            break;
        }
        case 5:
        {
            AdvertisementViewController *advertisementViewController = [[[AdvertisementViewController alloc] init] autorelease];
            [self.navigationController pushViewController:advertisementViewController animated:YES];
            break;
        }
        case 6:
        {
            ShakeViewController *shakeViewController = [[[ShakeViewController alloc] init] autorelease];
            [self.navigationController pushViewController:shakeViewController animated:YES];
            break;
        }
        case 7:
        {
            GetPositionViewController *getPositionViewController = [[[GetPositionViewController alloc] init] autorelease];
            [self.navigationController pushViewController:getPositionViewController animated:YES];
            break;
        }
        case 8:
        {
            XMLDigesterViewController *xmlDigesterViewController = [[[XMLDigesterViewController alloc] init] autorelease];
            [self.navigationController pushViewController:xmlDigesterViewController animated:YES];
            break;
        }
        case 9:
        {
            PhoneAndEmailViewController *phoneAndEmailViewController = [[[PhoneAndEmailViewController alloc] init] autorelease];
            [self.navigationController pushViewController:phoneAndEmailViewController animated:YES];
            break;
        }
        case 10:
        {
            SqliteViewController *sqliteViewController = [[[SqliteViewController alloc] init] autorelease];
            [self.navigationController pushViewController:sqliteViewController animated:YES];
            break;
        }
        case 11:
        {
            ConfigViewController *configViewController = [[[ConfigViewController alloc] init] autorelease];
            [self.navigationController pushViewController:configViewController animated:YES];
            break;
        }
        case 12:
        {
            EncryptAndDecryptViewController *encryptAndDecryptViewController = [[[EncryptAndDecryptViewController alloc] init] autorelease];
            [self.navigationController pushViewController:encryptAndDecryptViewController animated:YES];
            break;
        }
        case 13:
        {
            AsiHttpRequestViewController *asiHttpRequestViewController = [[[AsiHttpRequestViewController alloc] init] autorelease];
            [self.navigationController pushViewController:asiHttpRequestViewController animated:YES];
            break;
        }
        case 14:
        {
            RichTextViewController *richTextViewController = [[[RichTextViewController alloc] init] autorelease];
            [self.navigationController pushViewController:richTextViewController animated:YES];
            break;
        }
        case 15:
        {
            RefreshTableViewController *refreshTableViewController = [[[RefreshTableViewController alloc] init] autorelease];
            [self.navigationController pushViewController:refreshTableViewController animated:YES];
            break;
        }
        case 16:
        {
            DownloadAndUnzipViewController *downloadAndUnzipViewController = [[[DownloadAndUnzipViewController alloc] init] autorelease];
            [self.navigationController pushViewController:downloadAndUnzipViewController animated:YES];
            break;
        }
        case 17:
        {
            PictureViewController *pictureViewController = [[[PictureViewController alloc] init] autorelease];
            [self.navigationController pushViewController:pictureViewController animated:YES];
            break;
        }
        case 18:
        {
            GifViewController *gifViewController = [[[GifViewController alloc] init] autorelease];
            [self.navigationController pushViewController:gifViewController animated:YES];
            break;
        }
        case 19:
        {
            QRCodeViewController *qRCodeViewController = [[[QRCodeViewController alloc] init] autorelease];
            [self.navigationController pushViewController:qRCodeViewController animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
