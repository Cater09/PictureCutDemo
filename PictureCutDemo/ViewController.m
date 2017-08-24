//
//  ViewController.m
//  PictureCutDemo
//
//  Created by Ethan on 2017/8/24.
//  Copyright © 2017年 Ethan. All rights reserved.
//

#import "ViewController.h"
#import "PictureSelector.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (nonatomic, strong) PictureSelector *picture;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ImageEditNone:(UIButton *)sender {
    [self selectImage:ImageEditTypeNone];
}


- (IBAction)ImageEditSystem:(id)sender {
    [self selectImage:ImageEditTypeSystem];
}


- (IBAction)ImageEditImgMove:(id)sender {
    [self selectImage:ImageEditTypeImgMove];
}


- (IBAction)ImageEditImgStay:(id)sender {
    [self selectImage:ImageEditTypeImgStay];
}

-(void)selectImage:(ImageEditType)type {
    
    _picture = [[PictureSelector alloc] initWithResultImageSize:self.imageV.frame.size imageEditType:type];
    __weak typeof(self) weakSelf = self;
    _picture.selectedPicture = ^(UIImage *image) {
        weakSelf.imageV.image = image;
    };
}




@end
