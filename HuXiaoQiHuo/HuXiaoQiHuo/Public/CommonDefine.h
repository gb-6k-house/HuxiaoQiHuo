//
//  CommonDefine.h
//  YouChi
//
//  Created by niupark on 16/1/14.
//  Copyright © 2016年 FKLK. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#define USER_Default [NSUserDefaults standardUserDefaults]
#define IOS_Version ([[[UIDevice currentDevice] systemVersion] floatValue])

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)      //屏幕宽度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)    //屏幕高度

#define kPickerAnimationDelay .5

#define SCREEN_4S (SCREEN_HEIGHT<=480? YES :NO)//是否4s屏幕高度

//判断iphone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iphone6+
#define iPhone6Plus (IOS_8?([UIScreen mainScreen].nativeScale>2.60 ? YES : NO):NO)


/**
 *  DLog
 */
#ifdef DEBUG
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#   define ELog(err) {if(err) DLog(@"%@", err)}
#else
#   define DLog(...)
#   define ELog(err)
#endif
#endif /* CommonDefine_h */
