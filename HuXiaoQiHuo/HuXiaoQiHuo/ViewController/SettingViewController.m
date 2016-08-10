//
//  SettingViewController.m
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/15.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "SettingViewController.h"
#import "CGT6ClientSocket.h"
@interface SettingViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cacheSize;
@property (weak, nonatomic) IBOutlet UILabel *version;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.version.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [self.view setBackgroundColor:[UIColor YColorBackGroudGray]];
    self.cacheSize.text = @"0K";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)gotoChangePassword:(id)sender {
    [self performSegueWithIdentifier:@"ChangePasswordViewController" sender:nil];
}
- (IBAction)gotoMessageSetting:(id)sender {
    [self performSegueWithIdentifier:@"NewMessageSettingViewController" sender:nil];
}
- (IBAction)exitLogin:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定要退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

#pragma mark - delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[CGT6ClientSocket sharedInstance] disconnect];
        [[CTradeClientSocket sharedInstance] logout];
        [self.tabBarController setSelectedIndex:0];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"relogin" object:nil];
    }
}

@end
