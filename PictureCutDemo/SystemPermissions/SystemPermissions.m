//
//  SystemPermissions.m
//  horse
//
//  Created by 442 on 17/5/31.
//  Copyright © 2017年 442. All rights reserved.
//

#import "SystemPermissions.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>

@interface SystemPermissions ()<CLLocationManagerDelegate>

@property (nonatomic, copy) void(^locationReply)(BOOL);

@end


@implementation SystemPermissions

+(NSString *)disPlayName {

    static NSString *displayName;
    
    if (displayName.length == 0) {

        NSDictionary *dictionary = [[NSBundle mainBundle] infoDictionary];
        
        displayName = [dictionary objectForKey:@"CFBundleDisplayName"];
    
    }
    return displayName;
}


#pragma mark - 相册
+ (void)requestAccessForPhoto:(void(^)())reply {
    
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    
    switch (photoAuthorStatus) {
            
        case PHAuthorizationStatusNotDetermined:{
            
            // 许可对话没有出现，发起授权许可
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                if (status == PHAuthorizationStatusAuthorized) {
                
                    if (reply) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            reply();
                        });
                    }
                }
            }];
            
            break;
        }
            
            
        case PHAuthorizationStatusAuthorized: {
            
            // 已经开启授权，可继续
            
            if (reply) {
                reply();
            }
            
            break;
        }
            
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted: {
            // 用户明确地拒绝授权，或者相机设备无法访问
            
            [self alertView:@"相册被禁止访问" message:[NSString stringWithFormat:@"请在iphone的“设置-隐私-相册”中允许%@访问你的相册",[self disPlayName]]];
            
            break;
        }
        
        default:
            
            break;
    }
}



#pragma mark -- 相机

+ (void)requestAccessForVideo:(void(^)())reply{
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    
                    if (reply) {
                    
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            reply();
                        });
                    }
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            if (reply) {
                reply();
            }
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:  {
            // 用户明确地拒绝授权，或者相机设备无法访问
            [self alertView:@"相机被禁用" message:[NSString stringWithFormat:@"请在iphone的\"设置-隐私-相机\"中允许%@访问你的相机",[self disPlayName]]];
        }
            break;
        default:
            break;
    }
}

+ (void)requestAccessForAudio:(void(^)())reply{
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
            // 许可对话没有出现，发起授权许可
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (granted) {
                    
                    if (reply) {
                        reply();
                    }
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            if (reply) {
                reply();
            }
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted: {
            // 用户明确地拒绝授权，或者麦克风设备无法访问
            [self alertView:@"麦克风被禁用" message:[NSString stringWithFormat:@"请在iphone的\"设置-隐私-麦克风\"中允许%@访问你的麦克风",[self disPlayName]]];
        }
            break;
        default:
            break;
    }
}


#pragma mark - 定位

static CLLocationManager *locationManager = nil;
+(void)requestAccessForLocation:(void (^)(BOOL))reply {
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            //未确定
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = [self examplesWithRepley:reply];
            [locationManager requestAlwaysAuthorization];
        }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            //允许
            if (reply) {
                reply(true);
            }
        }
            break;
            
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied: {
            
            [self alertView:@"定位服务被禁用" message:[NSString stringWithFormat:@"请在iphone的\"设置-隐私-定位服务\"中允许%@访问你的定位服务",[self disPlayName]]];
            
            if (reply) {
                reply(false);
            }
//            if ([CLLocationManager locationServicesEnabled]) {
//                NSLog(@"定位服务开启，被拒绝");
//            } else {
//                NSLog(@"定位服务关闭，不可用");
//            }
        }
            break;            
        default:
            break;
    }
}

static SystemPermissions *permission = nil;
+(instancetype)examplesWithRepley:(void(^)(BOOL))reply {

    if (!permission) {
        permission = [[SystemPermissions alloc] initWithReply:reply];
    }
    return permission;
}
-(instancetype)initWithReply:(void(^)(BOOL))reply {
    self = [super init];
    if (self) {
        _locationReply = reply;
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {

    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            if (_locationReply) {
                _locationReply(true);
            }
        }
            break;
        default: {
            if (_locationReply) {
                _locationReply(false);
            }
        }
            break;
    }
    if (status != kCLAuthorizationStatusNotDetermined) {
        _locationReply = nil;
        permission = nil;
        locationManager = nil;
    }
}




#pragma mark - alert

+ (void)alertView:(NSString *)title message:(NSString *)message {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
    [alertView show];
}


+(void)alertView:(UIAlertView *)titleAlert clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            
            NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            [[UIApplication sharedApplication] openURL:url];
    
        }
    }
}

@end
