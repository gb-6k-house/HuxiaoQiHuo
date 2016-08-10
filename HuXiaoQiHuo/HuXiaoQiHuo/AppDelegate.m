//
//  AppDelegate.m
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/12.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "AppDelegate.h"
#import "TTKeyBoardManager.h"
#import "MTA.h"
#import "TalkingData/TalkingData.h"
#import "CGT6ClientSocket.h"
#define TALKINGDATA_KEY @"2D92964220CA0966630FE7B56A74B0D1"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height//获取屏幕高度，兼容性测试
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width//获取屏幕宽度，兼容性测试

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [MTA startWithAppkey:@"IAR343LIVY3W"];
    //捕获异常
    [TalkingData setExceptionReportEnabled:YES];
    [TalkingData setSignalReportEnabled:YES];
    [TalkingData sessionStarted:TALKINGDATA_KEY withChannelId:@"appStore"];
    // Override point for customization after application launch.
    if(ScreenHeight > 480){
        self.autoSizeScaleX = ScreenWidth/320;
        self.autoSizeScaleY = ScreenHeight/568;
    }else{
        self.autoSizeScaleX = 1.0;
        self.autoSizeScaleY = 1.0;
    }
    
    //定制tab item的样式
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor YColorBlue], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor YColorBlack], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBar appearance] setTintColor:[UIColor YColorGreen]];
    //处理输入键盘的事件，有输入界面无需关注界面遮挡和键盘隐藏问题
    [[TTKeyBoardManager sharedInstance] setEnable:YES];
    
    //建立网络连接
//    [[CTradeClientSocket sharedInstance]connectToHost:@"121.40.94.122" onPort:9401];

    [[CRegisterClientSocket sharedInstance]connectToHost:@"121.40.94.122" onPort:9402];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
