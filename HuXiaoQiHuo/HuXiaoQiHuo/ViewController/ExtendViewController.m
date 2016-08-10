//
//  ExtendViewController.m
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/15.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "ExtendViewController.h"

@interface ExtendViewController ()
@property (weak, nonatomic) IBOutlet UILabel *commisionPercent;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *myCommisionID;

@end

@implementation ExtendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    用户推广	http://121.43.232.204:8097/ajax/DataHandler.ashx?action=userpromotion&account=Ranfy&pwd=e10adc3949ba59abbe56e057f20f883e	POST	uname（账号）
//    pwd（密码）
    NSDictionary *dicInfo = @{@"account":[GlobalValue sharedInstance].uname,
                              @"pwd": [Request getMD5:[GlobalValue sharedInstance].pwd]
                              };
    [NetWork postDataWithServer:@"http://121.43.232.204:8097/ajax/DataHandler.ashx?action=userpromotion" sendDic:dicInfo kind:HttpRequstLoading tips:@"" target:self userInfo:nil callback:^(NSDictionary *dic) {
        self.money.text = [NSString stringWithFormat:@"%ld", (long)[dic[@"data"][0][@"Reward"] integerValue]];
        self.number.text = [NSString stringWithFormat:@"%ld", (long)[dic[@"data"][0][@"Referral"] integerValue]];
        self.myCommisionID.text = dic[@"data"][0][@"ReferralCode"];
    }errorCallback:^(NSDictionary *resultDic) {
        
    }];
    
    [self.view setBackgroundColor:[UIColor YColorBackGroudGray]];
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
#pragma mark - action
- (IBAction)howtoAction:(id)sender {
    //TODO: 不知道去哪里
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"此功能正在开发中..敬请期待!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}
- (IBAction)copyAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.myCommisionID.text;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"已经成功复制到剪切板" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
