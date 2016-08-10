//
//  MyPopBox.h
//  Bussiness
//
//  Created by liukai on 14-8-14.
//  Copyright (c) 2014年 yhc. All rights reserved.
//

#import <UIKit/UIKit.h>

//类型
typedef NS_OPTIONS(NSInteger, MyPopBoxStyle){
    MyPopBoxStyleNormal = 1<<0, //普通类型，居中显示界面，点击界面自动消失 ，也是缺省类型
    MyPopBoxStyleNonAutoDisplay = 1<<1, //界面不自动消失，需要主动调用消失界面方法
    MyPopBoxStyleExternalCoordinate = 1<<2 //外部坐标，以subView的坐标值显示subView，否则居中显示

};
@protocol MyPopBoxDelegate <NSObject>

@optional
-(void)dismissPopView;

@end
//模态弹出框
@interface MyPopBox : UIView<UIGestureRecognizerDelegate>
//在superview上显示窗口
@property(nonatomic, assign) MyPopBoxStyle style;
@property(nonatomic, assign)id<MyPopBoxDelegate>delegate;
-(void)showView:(UIView*)view inSuperView:(UIView*)superView;
//windows上显示
-(void)showView:(UIView *)view;
-(void)hide;
+(MyPopBox*)defualPopBox;
@end
