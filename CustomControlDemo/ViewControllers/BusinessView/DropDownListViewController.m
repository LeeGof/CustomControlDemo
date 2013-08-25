//
//  DropDownListViewController.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-21.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "DropDownListViewController.h"

@interface DropDownListViewController ()

@end

@implementation DropDownListViewController

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
    UILabel *lblType = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
    lblType.text = NSLocalizedString(@"whichcourse", nil);
    [self.view addSubview:lblType];
    [lblType release];
    
    _arrDdlData = [NSArray arrayWithObjects:NSLocalizedString(@"chinese", nil),NSLocalizedString(@"math", nil),NSLocalizedString(@"english", nil),NSLocalizedString(@"physics", nil),NSLocalizedString(@"chemistry", nil),NSLocalizedString(@"history", nil), nil];
    
    _ddlType = [[DropDownList alloc] initWithFrame:CGRectMake(10, 46, 200, 30)];
    _ddlType.arrListData = _arrDdlData;
    _ddlType.txtSelect.text = NSLocalizedString(@"chinese", nil);
    _ddlType.iSelectSerial = 0;
    [self.view addSubview:_ddlType];
    [_ddlType release];
    
    _btnDdlAlert = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnDdlAlert.frame = CGRectMake(10, 100, 300, 30);
    _btnDdlAlert.tag = 1000;
    [_btnDdlAlert setTitle:NSLocalizedString(@"ddltype", nil) forState:UIControlStateNormal];
    [_btnDdlAlert addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnDdlAlert];
    
    UIButton *btnClick = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnClick.frame = CGRectMake(10, 240, 300, 30);
    btnClick.tag = 1001;
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
    UIButton *btnSender = (UIButton *)sender;
    switch (btnSender.tag) {
        case 1000:
        {
            DDLTableAlert *alert = [[DDLTableAlert alloc] initWithTitle:NSLocalizedString(@"whichcourse", nil) cancelButtonTitle:NSLocalizedString(@"cancel", nil) messageFormat:nil];
            [alert setType:DDLTableAlertTypeSingleSelect];
//            [alert.alertView addButtonWithTitle:NSLocalizedString(@"sure", nil)];
            [alert.alertView setTag:0];
            
            [alert setDelegate:self];
            [alert setDataSource:self];
            
            [alert show];
            break;
        }
        case 1001:
        {
            NSString *strMsg = [NSString stringWithFormat:@"%d",_ddlType.iSelectSerial];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:strMsg delegate:nil cancelButtonTitle:NSLocalizedString(@"sure", nil) otherButtonTitles: nil];
            [alert show];
            [alert release];
            
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - SBTableAlertDataSource

- (UITableViewCell *)tableAlert:(DDLTableAlert *)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	
	[cell.textLabel setText:[NSString stringWithFormat:@"%@",[_arrDdlData objectAtIndex:indexPath.row]]];
	
	return cell;
}

- (NSInteger)tableAlert:(DDLTableAlert *)tableAlert numberOfRowsInSection:(NSInteger)section {
	return [_arrDdlData count];
}

- (NSInteger)numberOfSectionsInTableAlert:(DDLTableAlert *)tableAlert {
    return 1;
}

- (NSString *)tableAlert:(DDLTableAlert *)tableAlert titleForHeaderInSection:(NSInteger)section {
    return nil;
}

#pragma mark - SBTableAlertDelegate

- (void)tableAlert:(DDLTableAlert *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableAlert.type == DDLTableAlertTypeMultipleSelect) {
		UITableViewCell *cell = [tableAlert.tableView cellForRowAtIndexPath:indexPath];
		if (cell.accessoryType == UITableViewCellAccessoryNone)
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
		else
			[cell setAccessoryType:UITableViewCellAccessoryNone];
		
		[tableAlert.tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
    else if(tableAlert.type == DDLTableAlertTypeSingleSelect)
    {
        [_btnDdlAlert setTitle:[_arrDdlData objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    }
}

- (void)tableAlert:(DDLTableAlert *)tableAlert didDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	[tableAlert release];
}

@end
