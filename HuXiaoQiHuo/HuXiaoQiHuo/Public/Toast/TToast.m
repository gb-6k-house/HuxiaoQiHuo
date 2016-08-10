//
//  TToast.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/12.
//  Copyright © 2016年 LiuK. All rights reserved.
//

#import "TToast.h"
#import "MBProgressHUD.h"
@implementation TToast
//delay单位是秒
+(void)showToast:(NSString*)toast afterDelay:(NSTimeInterval)delay{
    [self showToast:toast afterDelay:delay completion:nil];

}
+(void)showToast:(NSString*)toast afterDelay:(NSTimeInterval)delay completion: (void (^)())completion{
    [self showToast:toast labelFont:nil afterDelay:delay completion:completion];


}
+(void)showToast:(NSString*)toast labelFont:(UIFont *)font afterDelay:(NSTimeInterval)delay{
    [self showToast:toast labelFont:font afterDelay:delay completion:nil];
}

+(void)showToast:(NSString*)toast labelFont:(UIFont *)font  afterDelay:(NSTimeInterval)delay completion: (void (^)())completion{
    //    if (nil == _toastView) {
   MBProgressHUD * _toastView = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    if (font) {
        _toastView.labelFont = font;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:_toastView];
    _toastView.mode = MBProgressHUDModeCustomView;
    _toastView.dimBackground = NO;
    _toastView.labelText = toast;
    [_toastView showAnimated:YES whileExecutingBlock:^{
        sleep(delay);
    }completionBlock:^{
        [_toastView removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}
+(MBProgressHUD*)showProcess:(NSString*)toast inView:(UIView*)inView{
    MBProgressHUD * _toastView = [[MBProgressHUD alloc] initWithView:inView];
//    if (font) {
//        _toastView.labelFont = font;
//    }
    [inView addSubview:_toastView];
    _toastView.mode = MBProgressHUDModeIndeterminate;
    _toastView.dimBackground = NO;
    _toastView.labelText = toast;
    [_toastView show:YES];
    return _toastView;
}

@end
