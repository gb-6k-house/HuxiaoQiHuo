//
//  MyViewController.m
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/12.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "MyViewController.h"

#define GOTO_USERINFO 0
#define GOTO_TRADE 1
#define GOTO_MYMONEY 2
#define GOTO_EXTEND 3
#define GOTO_SETTING 4


@interface MyViewController (){
    NSDictionary *dicMoney;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (weak, nonatomic) IBOutlet UIView *vlevel;
@property (weak, nonatomic) IBOutlet UILabel *tradeMoney;
@property (weak, nonatomic) IBOutlet UILabel *myMoney;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super setShowBackButton:NO];
    [self getUserInfo:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserInfo:) name:@"userNameUpdate" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserInfo:) name:@"updateAVator" object:nil];
    
    [self.view setBackgroundColor:[UIColor YColorBackGroudGray]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //    获取用户钱包（余额和财经币）	http://121.43.232.204:8097/ajax/DataHandler.ashx?action=getwallet	POST	uname（账号）
    //    pwd（密码）
    NSDictionary *dicInfo = @{@"account":[GlobalValue sharedInstance].uname,
                              @"pwd": [Request getMD5:[GlobalValue sharedInstance].pwd]
                              };
    [NetWork postDataWithServer:@"http://121.43.232.204:8097/ajax/DataHandler.ashx?action=getwallet" sendDic:dicInfo kind:HttpRequstLoading tips:@"" target:self userInfo:nil callback:^(NSDictionary *dic) {
        NSLog(@"getwallet=%@", dic);
        dicMoney = dic[@"data"][0];
        //    UserName:用户名 UseMoney：资金余额 UseCaijingNum：呼啸币
        self.myMoney.text = [NSString stringWithFormat:@"%.2f", [dicMoney[@"UseCaijingNum"] doubleValue]];
        self.tradeMoney.hidden = YES;
    }errorCallback:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUserInfo:(NSNotification *) notification{
    NSDictionary *dicInfo = @{@"uname":[GlobalValue sharedInstance].uname};
    [NetWork postDataWithServer:@"http://121.43.232.204:8097/ajax/DataHandler.ashx?action=account" sendDic:dicInfo kind:HttpRequstLoading tips:@"" target:self userInfo:nil callback:^(NSDictionary *dic) {
        [self.imgHeader sd_setImageWithURL:dic[@"Data"][@"Avatar"] placeholderImage:[UIImage imageNamed:@"userName"]options:SDWebImageRefreshCached];
        self.userName.text = dic[@"Data"][@"NickName"];
        self.accountName.text = [GlobalValue sharedInstance].uname;
        //{"Code":0,"Msg":"success","Data":{"Avatar":"","NickName":"iOS测试","Level":"1"}}
    }errorCallback:^(NSDictionary *resultDic) {
        
    }];
}

#pragma mark - action
- (IBAction)btnActions:(UIButton *)sender {
    switch (sender.tag) {
        case GOTO_USERINFO:
            [self performSegueWithIdentifier:@"MyInfoViewController" sender:nil];
            break;
        case GOTO_TRADE:
            [self.tabBarController setSelectedIndex:2];
            break;
        case GOTO_MYMONEY:
            [self performSegueWithIdentifier:@"MyMoneyViewController" sender:dicMoney];
            break;
        case GOTO_EXTEND:
            [self performSegueWithIdentifier:@"ExtendViewController" sender:nil];
            break;
        case GOTO_SETTING:
            [self performSegueWithIdentifier:@"SettingViewController" sender:nil];
            break;
            
        default:
            break;
    }
}

@end
