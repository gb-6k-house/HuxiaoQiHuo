//
//  TTBaseViewController.h
//  YouChi
//
//  Created by niupark on 16/1/14.
//  Copyright © 2016年 FKLK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "AppDelegate.h"


@interface TTBaseViewController : UIViewController
@property(nonatomic,readonly)UIWindow *window;
@property(nonatomic, readonly)BOOL isApear; //是否显示

@property(strong, nonatomic)UIBarButtonItem *back;
/*支持右滑返回*/
-(void)rightSwipBackEnable:(BOOL)enable;
-(void)setShowBackButton:(BOOL)isShow;
-(float)getScareRatioX;
-(float)getScareRatioY;
/**
 *  @author LiuK, 15-09-15 14:09:18
 *
 *  子类实现该方法，进行控制器初始化。configureWithData:发生在上一个控制器进入当前控制器的时候。
 *
 *  @param data 上个控制器传递过来的数据 。 通过方法performSegueWithIdentifier:sender: 的sender参数传递。
 */
-(void)configureWithData:(id)data;
/**
 *  @author LiuK, 15-09-15 14:09:18
 *
 * 控制器跳转 和 completeWithData:配套使用。completion block，下个界面调用completeWithData:返回数据给当前界面时需要处理的事情。
 *
 *
 */
-(void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender completion:(void (^)(id data))completion;
/*
 *返回数据给上一个控制器
 */
-(void)completeWithData:(id)data;
-(void)configeRefreshTableView:(UITableView*)tableView headBlock:(MJRefreshComponentRefreshingBlock)headBlock footBlock:(MJRefreshComponentRefreshingBlock)footBlock;
-(void)showEmtiyFlageInView:(UIView*)view;
-(void)hidenEmtiyFlageInView:(UIView*)view;
@end
