//
//  AdvertisementViewController.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-24.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "AdvertisementViewController.h"
#import "AdPageView.h"

@interface AdvertisementViewController ()

@end

@implementation AdvertisementViewController

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
    
    NSMutableArray *arrAdImage = [NSMutableArray array];
    UIImageView *ivAdImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedString(@"image1", nil)]];
    [arrAdImage addObject:ivAdImage];
    [ivAdImage release];
    
    ivAdImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedString(@"image2", nil)]];
    [arrAdImage addObject:ivAdImage];
    [ivAdImage release];
	
    AdPageView *adPageView = [[AdPageView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    adPageView.imageSpace = 2;
    adPageView.pageBgk = [UIColor clearColor];
    adPageView.imageArray = arrAdImage;
    [adPageView setNeedsDisplay];
    
    [self.view addSubview:adPageView];
    [adPageView release];
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

@end
