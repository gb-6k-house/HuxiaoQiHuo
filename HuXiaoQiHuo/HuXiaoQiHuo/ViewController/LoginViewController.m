//
//  LoginViewController.m
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/12.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameInput;
@property (weak, nonatomic) IBOutlet UITextField *pwdInput;
@property (nonatomic, strong) MBProgressHUD *progressView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[CTradeClientSocket sharedInstance]connectToHost:@"121.40.94.122" onPort:9401];

}

-(void)viewWillAppear:(BOOL)animated{
    [super setShowBackButton:NO];
    [super viewWillAppear:animated];
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
- (IBAction)loginAction:(UIButton *)sender {
    if ([self checkInputCorrect] != nil) {
        return;
    }
    
    self.progressView = [TToast showProcess:@"正在加载数据" inView:self.view];

    [[CTradeClientSocket sharedInstance]loginWithUsername:self.userNameInput.text AndPassword:self.pwdInput.text];
}


SOCKET_PROTOCOL(Login){
    NSLog(@"登录接口返回");
    TraderResponse *rs = response;
    NSString * msg = rs.reason;
    switch (rs.rst) {
        case 0:
            //加入蒙版，开始download login.json数据
            [[CTradeClientSocket sharedInstance] getLoginJsonFileForce:NO];
            break;
        default:
            break;
    }
    if (msg != nil){
        [ToolCore showAlertViewWithTitle:nil message:msg];
        [self.progressView hide:YES];

    }else{
        [GlobalValue sharedInstance].isLogin = YES;
        [GlobalValue sharedInstance].uname = self.userNameInput.text;
        [GlobalValue sharedInstance].pwd = self.pwdInput.text;
        [GlobalValue sharedInstance].sid = rs.SID;
        [GlobalValue sharedInstance].uid = rs.UID;
        LoginParaObj *para = rs.para;
        
        [GlobalValue sharedInstance].tradeAccount = para.muserInfo[@"account"];
        [GlobalValue sharedInstance].tradePwd = para.muserInfo[@"pwd"];

    }
}
SOCKET_PROTOCOL(LoginJson){
    //去掉蒙版，开始download login.json数据
    [self.progressView hide:YES];

    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loginOK" object:nil];
    }];
    NSLog(@"LoginJson 数据获取成功");
}
- (IBAction)registAction:(id)sender {
    [self performSegueWithIdentifier:@"RegisterViewController" sender:nil];
}

- (IBAction)forgetpwdAction:(id)sender {
    [self performSegueWithIdentifier:@"ForgetPasswordViewController" sender:nil];
}


#pragma mark - method
- (NSString*)checkInputCorrect{
    NSString * msg = nil;
    if (0 == [self.userNameInput.text length])
    {
        msg = @"用户名不能为空";
    }
    else if ([self.userNameInput.text length]>25)
    {
        msg = @"用户名过长";
    }
    
    if (msg) {
        [TToast showToast:msg afterDelay:2.0f];
    }
    return msg;
}

#pragma mark -delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    return YES;
}

@end
