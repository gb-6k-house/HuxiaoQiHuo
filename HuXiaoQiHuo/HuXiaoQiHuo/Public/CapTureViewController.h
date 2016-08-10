//
//  RootViewController.h
//  NewProject
//
//  Created by 学鸿 张 on 13-11-29.
//  Copyright (c) 2013年 Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol FlashTwoCode
- (void)flashTwoCode:(NSString *)str;
@end
@interface CapTureViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (assign)UIViewController * fatherCtl;
@property (strong,nonatomic)UIColor * colorForCancel;
@property (strong,nonatomic)AVCaptureSession * session;

@end
