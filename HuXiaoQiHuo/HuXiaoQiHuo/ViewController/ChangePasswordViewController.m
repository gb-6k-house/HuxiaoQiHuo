//
//  ChangePasswordViewController.m
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/16.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *currentPwd;
@property (weak, nonatomic) IBOutlet UITextField *changePwdInput;
@property (weak, nonatomic) IBOutlet UITextField *agNewPwd;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (IBAction)changeAction:(id)sender {
    if (![self.agNewPwd.text isEqualToString:self.changePwdInput.text]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请确定两次输入密码一致？" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    //修改密码	http://121.43.232.204:8097/ajax/DataHandler.ashx?action=changepwd	POST	uname（账号）
//    pwd（密码）
//    newpwd（新密码）
//
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定要修改密码吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];

    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSDictionary *dicInfo = @{@"uname":[GlobalValue sharedInstance].uname,
                                  @"pwd": [Request getMD5:[GlobalValue sharedInstance].pwd],
                                  @"newpwd":self.agNewPwd.text
                                  };
        [NetWork postDataWithServer:@"http://121.43.232.204:8097/ajax/DataHandler.ashx?action=changepwd" sendDic:dicInfo kind:HttpRequstSubmit tips:@"正在提交信息" target:self userInfo:nil callback:^(NSDictionary *dic) {
            [GlobalValue sharedInstance].pwd = self.changePwdInput.text;
            
            [self.navigationController popViewControllerAnimated:YES];
        }errorCallback:^(NSDictionary *resultDic) {
            
        }];
    }
}

@end
