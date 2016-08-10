//
//  YCTabBarViewController.m
//  YouChi
//
//  Created by niupark on 16/1/15.
//  Copyright © 2016年 FKLK. All rights reserved.
//

#import "YCTabBarViewController.h"

@interface YCTabBarViewController ()

@end

@implementation YCTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViewController];
    
    [self chooseItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  Tabbar加载ViewController
 */
-(void)initViewController{
    //初始化Storyboard
    UIStoryboard *mySB =[UIStoryboard storyboardWithName:@"My" bundle:nil];
    UIStoryboard *messageSB =[UIStoryboard storyboardWithName:@"Message" bundle:nil];
    UIStoryboard *tradeSB =[UIStoryboard storyboardWithName:@"Trade" bundle:nil];
    UIStoryboard *marketSB =[UIStoryboard storyboardWithName:@"Market" bundle:nil];
    UIStoryboard *homeSB =[UIStoryboard storyboardWithName:@"Home" bundle:nil];
    
    //设置ViewController
    UINavigationController *homeNav = [homeSB instantiateInitialViewController];
    UIViewController *homeVC = homeNav.topViewController;
    homeVC.title = @"首页";
    homeVC.tabBarItem.image = [UIImage imageNamed:@"homeIcon"];
    homeVC.tabBarItem.selectedImage = [UIImage imageNamed:@"homeIconPress"];
    
    UINavigationController *marketNav = [marketSB instantiateInitialViewController];
    UIViewController *marketVC = marketNav.topViewController;
    marketVC.title = @"行情";
    marketVC.tabBarItem.image = [UIImage imageNamed:@"marketIcon"];
    marketVC.tabBarItem.selectedImage = [UIImage imageNamed:@"marketIconPress"];
    
    UINavigationController *tradeNav = [tradeSB instantiateInitialViewController];
    UIViewController *tradeVC = tradeNav.topViewController;
    tradeVC.title = @"交易";
    tradeVC.tabBarItem.image = [UIImage imageNamed:@"tradeIcon"];
    tradeVC.tabBarItem.selectedImage = [UIImage imageNamed:@"marketIconPress"];
    
    UINavigationController *messageNav = [messageSB instantiateInitialViewController];
    UIViewController *messageVC = messageNav.topViewController;
    messageVC.title = @"消息中心";
    messageVC.tabBarItem.image = [UIImage imageNamed:@"messageIcon"];
    messageVC.tabBarItem.selectedImage = [UIImage imageNamed:@"messageIconPress"];
    
    UINavigationController *myNav = [mySB instantiateInitialViewController];
    UIViewController *myVC = myNav.topViewController;
    myVC.title = @"用户";
    myVC.tabBarItem.image = [UIImage imageNamed:@"myIcon"];
    myVC.tabBarItem.selectedImage = [UIImage imageNamed:@"myIconPress"];
    
    
    // 4.创建并将4个Storyboard添加到TabBarCongtroller中
    self.viewControllers = @[homeNav,
                             marketNav,
                             tradeNav,
                             messageNav,
                             myNav
                           ];
    [self setSelectedIndex:0];
    
}

-(void)chooseItem{
    
}
//横屏控制
- (BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}
//支持的横屏方向
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}
    //初始屏幕方向
-(UIInterfaceOrientation)apreferredInterfaceOrientationForPresentation{

    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
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
