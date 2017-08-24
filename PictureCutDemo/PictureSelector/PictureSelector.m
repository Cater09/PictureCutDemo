//
//  ChoosePicture.m
//  Tools
//
//  Created by Cater on 2017/3/14.
//  Copyright © 2017年 HeNanRunShengXXJS. All rights reserved.
//

#import "PictureSelector.h"
#import "Common.h"
//裁剪图片
#import "ImageClipController.h"
//获取系统权限
#import "SystemPermissions.h"

@interface PictureSelector () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign) CGSize resultImgSize;

@property (nonatomic, assign) ImageEditType imageEditType;

@end


@implementation PictureSelector


-(instancetype)initWithResultImageSize:(CGSize)resultImageSize imageEditType:(ImageEditType)imageEditType {
    
    self = [super init];
    if (self) {
        self.resultImgSize = resultImageSize;
        self.imageEditType = imageEditType;
        [self selectPhotoOrTakingPictures];
    }
    return self;
}




-(void)selectPhotoOrTakingPictures {
    
    UIViewController *vc = [Common currentViewController];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
#if !(TARGET_IPHONE_SIMULATOR)
    
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [SystemPermissions requestAccessForVideo:^{
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerController.delegate = self;
            if (_imageEditType == ImageEditTypeSystem) {
                pickerController.allowsEditing = YES;
            }
            [vc presentViewController:pickerController animated:YES completion:nil];
        }];
        
    }]];
    
#endif
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [SystemPermissions requestAccessForPhoto:^{
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerController.delegate = self;
            if (_imageEditType == ImageEditTypeSystem) {
                pickerController.allowsEditing = YES;
            }
            [vc presentViewController:pickerController animated:YES completion:nil];
            
        }];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [vc presentViewController:alert animated:YES completion:nil];
}


//MARK:获取图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [self turnImageWithInfo:info];
    
    if (_imageEditType == ImageEditTypeImgStay || _imageEditType == ImageEditTypeImgMove) {
        
        ClipperType clipperType;
        
        if (_imageEditType == ImageEditTypeImgMove) {
            clipperType = ClipperTypeImgMove;
        }else if (_imageEditType == ImageEditTypeImgStay){
            clipperType = ClipperTypeImgStay;
        }
        
        ImageClipController *clipperVC = [[ImageClipController alloc]initWithBaseImg:image
                                          
                                                                       resultImgSize:_resultImgSize
                                          
                                                                         clipperType:clipperType
                                          
                                                                          sourceType:picker.sourceType];
        
        __weak typeof(self)weakSelf = self;
        
        clipperVC.successClippedHandler = ^(UIImage *clippedImage){
            
            if (weakSelf.selectedPicture) {
                weakSelf.selectedPicture(clippedImage);
            }
            [picker dismissViewControllerAnimated:YES completion:nil];
        };
        [picker pushViewController:clipperVC animated:YES];

    }else {
        if (self.selectedPicture) {
            self.selectedPicture(image);
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


- (UIImage *)turnImageWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    //类型为 UIImagePickerControllerOriginalImage 时调整图片角度
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp) {
            // 原始图片可以根据照相时的角度来显示，但 UIImage无法判定，于是出现获取的图片会向左转90度的现象。
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    return image;
}




@end
