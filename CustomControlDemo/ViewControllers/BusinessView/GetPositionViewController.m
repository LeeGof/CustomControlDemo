//
//  GetPositionViewController.m
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-26.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import "GetPositionViewController.h"

@interface GetPositionViewController ()
- (void)startedReverseGeoderWithLatitude:(double)latitude longitude:(double)longitude;
@end

@implementation GetPositionViewController

@synthesize locationManager = _locationManager;

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
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    lblTitle.text = NSLocalizedString(@"latitude", nil);
    lblTitle.textAlignment = UITextAlignmentRight;
    [self.view addSubview:lblTitle];
    [lblTitle release];
    
    _lblLatitude = [[UILabel alloc] initWithFrame:CGRectMake(112, 10, 100, 30)];
    _lblLatitude.textAlignment = UITextAlignmentLeft;
    [self.view addSubview:_lblLatitude];
    [_lblLatitude release];
    
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 100, 30)];
    lblTitle.text = NSLocalizedString(@"longitude", nil);
    lblTitle.textAlignment = UITextAlignmentRight;
    [self.view addSubview:lblTitle];
    [lblTitle release];
    
    _lblLongitude = [[UILabel alloc] initWithFrame:CGRectMake(112, 50, 100, 30)];
    _lblLongitude.textAlignment = UITextAlignmentLeft;
    [self.view addSubview:_lblLongitude];
    [_lblLongitude release];
    
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 100, 30)];
    lblTitle.text = NSLocalizedString(@"city", nil);
    lblTitle.textAlignment = UITextAlignmentRight;
    [self.view addSubview:lblTitle];
    [lblTitle release];
    
    _lblCurrentCity = [[UILabel alloc] initWithFrame:CGRectMake(112, 90, 100, 30)];
    _lblCurrentCity.textAlignment = UITextAlignmentLeft;
    [self.view addSubview:_lblCurrentCity];
    [_lblCurrentCity release];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 1;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.locationManager = nil;
}

- (void)dealloc
{
    [_locationManager release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationDistance latitude = newLocation.coordinate.latitude;
    CLLocationDistance longitude = newLocation.coordinate.longitude;
    
    _lblLatitude.text = [NSString stringWithFormat:@"%f", latitude];
    _lblLongitude.text = [NSString stringWithFormat:@"%f", longitude];
    
    [self startedReverseGeoderWithLatitude: latitude longitude: longitude];
}

#pragma mark - MKReverseGeocoderDelegate 

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    /* placemark 属性说明
     @property (nonatomic, readonly) NSDictionary *addressDictionary; //地址字典
     @property (nonatomic, readonly) NSString *thoroughfare; //街道名——“同成街”
     @property (nonatomic, readonly) NSString *subThoroughfare; // 门牌号——“”
     @property (nonatomic, readonly) NSString *locality; //城市——“北京市”
     @property (nonatomic, readonly) NSString *subLocality; //区县——“昌平区”
     @property (nonatomic, readonly) NSString *administrativeArea; //身份——“北京市”
     @property (nonatomic, readonly) NSString *subAdministrativeArea; //没获取到，不知道是什么东东
     @property (nonatomic, readonly) NSString *postalCode; //邮政编码——不知道是什么原因，这里没获取到
     @property (nonatomic, readonly) NSString *country; //国家——“中国”
     @property (nonatomic, readonly) NSString *countryCode; //国家代码——“CN”
     */
    NSString *currCity = placemark.locality;
    if (currCity) 
    {
        _lblCurrentCity.text = currCity;
    }
}
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
}

#pragma mark - 自定义方法

- (void)startedReverseGeoderWithLatitude:(double)latitude longitude:(double)longitude
{
    CLLocationCoordinate2D coordinate2D;
    coordinate2D.longitude = longitude;
    coordinate2D.latitude = latitude;
    MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate2D];
    geoCoder.delegate = self;
    [geoCoder start];
}



@end
