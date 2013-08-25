//
//  PictureViewController.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-9-17.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "PictureViewController.h"

@interface PictureViewController ()

@end

@implementation PictureViewController

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
    
    _myGetPictureFuntion = [[PictureFunction alloc] init];
    _myGetPictureFuntion.delegate = self;
    
    [_myGetPictureFuntion takeAPhotoAtCurrentView:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    if(_myGetPictureFuntion)
    {
        _myGetPictureFuntion.delegate = nil;
        [_myGetPictureFuntion release];
    }
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark GetPictureFuntion delegate

-(void)selectedPicture:(UIImage *)image
{
    UIImageView *ivSel = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    [ivSel setImage:image];
    [self.view addSubview:ivSel];
    [ivSel release];
}

@end
