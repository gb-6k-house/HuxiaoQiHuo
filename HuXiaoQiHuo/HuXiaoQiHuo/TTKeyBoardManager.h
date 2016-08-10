//
//  TTKeyBoardManager.h
//  WashCarMechanic
//
//  Created by liukai on 16/5/5.
//  Copyright © 2016年 niupark. All rights reserved.
//
/**
 *  @author LiuK, 16-05-05 11:05:43
 *
 *  主要处理UITextField,UITextView的键盘相关问题
 *  1、如果键盘遮挡TextField时，将改变viewcontroller view的frame，保证TextField不被遮挡
 *  2、当点击界面空白处时，自动隐藏键盘。如果要使用该功能，自己的viewcontroller最好不要添加UITapGestureRecognizer手势，防止覆盖TTKeyBoardManager内部的手势处理
 *  3、暂未添加对UITextView的支持。。。。
 *  @param instancetype
 *
 *  @return 
 */
#import <Foundation/Foundation.h>
@interface TTKeyBoardManager : NSObject
+ (instancetype)sharedInstance;
//是否开启功能
@property(nonatomic, assign)BOOL enable;
@end
