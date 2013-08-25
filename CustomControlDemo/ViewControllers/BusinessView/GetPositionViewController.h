//
//  GetPositionViewController.h
//  CustomControlDemo
//
//  Created by 高峰 李 on 12-8-26.
//  Copyright (c) 2012年 用友软件股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface GetPositionViewController : UIViewController<CLLocationManagerDelegate,MKReverseGeocoderDelegate>
{
    UILabel                 *_lblLatitude;  // 纬度
    UILabel                 *_lblLongitude;  // 经度
    UILabel                 *_lblCurrentCity;  // 当前城市
    CLLocationManager       *_locationManager;  // 位置管理
}

@property (nonatomic, retain) CLLocationManager *locationManager;

@end
