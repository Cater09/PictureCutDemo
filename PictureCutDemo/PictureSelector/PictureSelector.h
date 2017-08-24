//
//  ChoosePicture.h
//  Tools
//
//  Created by Cater on 2017/3/14.
//  Copyright © 2017年 HeNanRunShengXXJS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ImageEditType) {

    ImageEditTypeNone     = 0,    //不编辑
    ImageEditTypeSystem   = 1,    //系统编辑
    ImageEditTypeImgMove  = 2,    //图片移动
    ImageEditTypeImgStay  = 3     //图片不动
};

@interface PictureSelector : NSObject

@property (nonatomic, copy) void(^selectedPicture)(UIImage *image);

-(instancetype)initWithResultImageSize:(CGSize)resultImageSize imageEditType:(ImageEditType)imageEditType;

@end
