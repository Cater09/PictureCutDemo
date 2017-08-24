//
//  ImageClipController.m
//  nvbs
//
//  Created by Cater on 17/2/9.
//  Copyright © 2017年 HeNanRunShengXXJS. All rights reserved.
//

#import "ImageClipController.h"

@interface ImageClipController ()

@property (nonatomic, strong) ClipperView *clipperView;

@property (nonatomic) UIImagePickerControllerSourceType sourceType;

@end

static CGFloat const footer_height = 64.f;
static CGFloat const bt_width = 60.f;
static CGFloat const bt_font = 17.f;

@implementation ImageClipController

-(instancetype)initWithBaseImg:(UIImage *)baseImg resultImgSize:(CGSize)resultImgSize clipperType:(ClipperType)type sourceType:(UIImagePickerControllerSourceType)sourceType {

    self = [super init];
    if (self) {
        
        self.sourceType = sourceType;
        
        _clipperView = [[ClipperView alloc]init];
        _clipperView.frame = [UIScreen mainScreen].bounds;
        _clipperView.resultImgSize = resultImgSize;
        //baseImg 的大小需依赖 resultImgSize 计算，所以 需在 resultImgSize 被赋值后才可赋值
        _clipperView.baseImg = baseImg;
        _clipperView.type = type;
        [self.view addSubview:_clipperView];
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - footer_height, self.view.frame.size.width, footer_height)];
        footerView.backgroundColor = [[UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.0] colorWithAlphaComponent:0.7f];
        [self.view addSubview:footerView];
        
        UIButton *cancel_bt = [self createBt:@"取消" frame:CGRectMake(0, 0, bt_width, footer_height)];
        cancel_bt.tag = 100;
        [footerView addSubview:cancel_bt];
        
        UIButton *select_bt = [self createBt:@"选取" frame:CGRectMake(self.view.frame.size.width - bt_width, 0, bt_width, footer_height)];
        select_bt.tag = 101;
        [footerView addSubview:select_bt];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(UIButton *)createBt:(NSString *)title frame:(CGRect)frame{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.titleLabel.font = [UIFont systemFontOfSize:bt_font];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)buttonClick:(UIButton *)button {
    
    if (button.tag == 100) {
        
        if (_sourceType == UIImagePickerControllerSourceTypeCamera) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else if (button.tag == 101) {
        if (_successClippedHandler) {
            _successClippedHandler([self.clipperView clipImg]);
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
