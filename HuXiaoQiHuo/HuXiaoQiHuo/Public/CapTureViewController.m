
//
//  RootViewController.m
//  NewProject
//
//  Created by 学鸿 张 on 13-11-29.
//  Copyright (c) 2013年 Steven. All rights reserved.
//

#import "CapTureViewController.h"
#import "ToolCore.h"

@interface CapTureViewController ()

@end

@implementation CapTureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)backAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupCamera];
}

- (void)setupCamera {
    CGSize s = [ToolCore sizeForCurrentScreen];
    CGFloat c = [ToolCore ratioForScreen];
    // Device
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // Output
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [output setRectOfInterest: CGRectMake (0.25 , 0.2 , 220.0 / s.height , 220.0 / s.width )];
    // Session
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    if (output.availableMetadataObjectTypes.count > 0) {
        [output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil]];
        // Preview
        AVCaptureVideoPreviewLayer * preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
        preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        preview.frame = [UIScreen mainScreen].bounds;
        [self.view.layer insertSublayer:preview atIndex:1];
        
        CALayer *shadowLayer = [CALayer layer];
        shadowLayer.frame = [UIScreen mainScreen].bounds;
        [shadowLayer setContents:(id)[UIImage imageNamed:@"bkgScanShadow"].CGImage];
        [self.view.layer insertSublayer:shadowLayer above:preview];
        
        
        CGFloat lStart = 160.0;
        CGFloat lEnd = 360.0;
        if (s.height < 500) {
            lStart = 130.0;
            lEnd = 300.0;
        }
        CGPoint startPoint = CGPointMake((s.width *.5), lStart * c);
        CGPoint endPoint = CGPointMake((s.width *.5), lEnd * c);
        
        CALayer * lineLayer = [CALayer layer];
        lineLayer.bounds = CGRectMake(0, 0, 220, 2);
        [lineLayer setContents:(id)[UIImage imageNamed:@"line"].CGImage];
        
        CABasicAnimation *animation =
        [CABasicAnimation animationWithKeyPath:@"position"];
        animation.fromValue = [NSValue valueWithCGPoint:startPoint];
        animation.toValue = [NSValue valueWithCGPoint:endPoint];
        animation.duration = 2.0;
        animation.repeatCount = HUGE_VALF;
        animation.autoreverses = YES;
        [lineLayer setPosition:endPoint];
        [lineLayer addAnimation:animation forKey:@"position"];
        [self.view.layer addSublayer:lineLayer];
        
        UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [scanButton setTitle:@"取消" forState:UIControlStateNormal];
        scanButton.frame = CGRectMake((s.width - 220 )*0.5, (s.height - 148), 220, 44);
        scanButton.backgroundColor = self.colorForCancel;
        scanButton.layer.cornerRadius = 5;
        scanButton.layer.masksToBounds = YES;
        
        [scanButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:scanButton];
        
        [self.session startRunning];
    }else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的相机功能无法使用，请您前往系统设置修改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString * stringValue = @"";
    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    [self.session stopRunning];
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.fatherCtl respondsToSelector:@selector(flashTwoCode:)]) {
            [self.fatherCtl performSelector:@selector(flashTwoCode:) withObject:stringValue];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:NO completion:nil];
} 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
