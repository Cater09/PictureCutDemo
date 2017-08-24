//
//  ClipperView.h
//  nvbs
//
//  Created by Cater on 17/2/9.
//  Copyright © 2017年 HeNanRunShengXXJS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, ClipperType) {
    ClipperTypeImgMove,
    ClipperTypeImgStay
};

@interface ClipperView : UIView

@property (nonatomic, strong) UIImage *baseImg;
@property (nonatomic, assign) CGSize resultImgSize;
@property (nonatomic, assign) ClipperType type;

- (UIImage *)clipImg;

@end
