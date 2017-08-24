//
//  SystemPermissions.h
//  horse
//
//  Created by 442 on 17/5/31.
//  Copyright © 2017年 442. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemPermissions : NSObject

//相册权限
+ (void)requestAccessForPhoto:(void(^)())reply;
//相机权限
+ (void)requestAccessForVideo:(void(^)())reply;
//麦克风权限
+ (void)requestAccessForAudio:(void(^)())reply;
//定位权限
+(void)requestAccessForLocation:(void(^)(BOOL isAccess))reply;

@end
