//
//  ImageClipController.h
//  nvbs
//
//  Created by Cater on 17/2/9.
//  Copyright © 2017年 HeNanRunShengXXJS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClipperView.h"

@interface ImageClipController : UIViewController

- (instancetype)initWithBaseImg:(UIImage *)baseImg
                  resultImgSize:(CGSize)resultImgSize
                    clipperType:(ClipperType)type
                     sourceType:(UIImagePickerControllerSourceType)sourceType;


@property (nonatomic, copy) void(^successClippedHandler)(UIImage *clippedImage);

@property (nonatomic, copy) NSString *type;

@end
