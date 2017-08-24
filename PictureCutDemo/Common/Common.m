//
//  Common.m
//  horse
//
//  Created by 442 on 17/5/31.
//  Copyright © 2017年 442. All rights reserved.
//

#import "Common.h"
#import "AppDelegate.h"
@implementation Common

+(UIViewController *)currentViewController {
    
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
            
        }else{
            break;
        }
    }
    return vc;
}

@end
