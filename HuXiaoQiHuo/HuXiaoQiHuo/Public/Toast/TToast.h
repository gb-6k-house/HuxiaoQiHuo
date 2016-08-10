//
//  TToast.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/12.
//  Copyright © 2016年 LiuK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface TToast : NSObject
//delay单位是秒
+(void)showToast:(NSString*)toast afterDelay:(NSTimeInterval)delay;
+(void)showToast:(NSString*)toast afterDelay:(NSTimeInterval)delay completion: (void (^)())completion;
+(void)showToast:(NSString*)toast labelFont:(UIFont *)font afterDelay:(NSTimeInterval)delay;
//网络加载
+(MBProgressHUD*)showProcess:(NSString*)toast inView:(UIView*)inView;

@end
