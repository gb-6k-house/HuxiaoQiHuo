//
//  RegisterViewController.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/12.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "RegisterViewController.h"
#import "GetCodeTool.h"
#import "CRegisterClientSocket.h"
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgInput;
@property (weak, nonatomic) IBOutlet UITextField *telNoInput;
@property (weak, nonatomic) IBOutlet UITextField *emailInput;
@property (weak, nonatomic) IBOutlet UITextField *inviteCodeInput;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeInput;
@property (weak, nonatomic) IBOutlet UIButton *btnGetVerifyCode;
@property NSString* checkSum;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.checkSum = @"";
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

#pragma mark - delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - action
- (IBAction)getVerifyCodeAction:(id)sender {
    if (self.telNoInput.text == nil){
        [TToast  showToast:@"请输入才正确的手机号" afterDelay:1.5];
        return;
    }
    GetCodeTool * getCodeTool = [[GetCodeTool alloc] init];
    getCodeTool.view = self.view;
    getCodeTool.btn = (UIButton*)sender;
    getCodeTool.strPhone = _telNoInput.text;
    getCodeTool.strClientType = @"user";
    [getCodeTool check];
}

- (IBAction)registAction:(id)sender {
    if ([self checkInputCorrect] != nil) {
        
        return;
    }
    [[CRegisterClientSocket sharedInstance] sendRegisterInfo:self.userNameInput.text Password:self.passwordInput.text PhoneNumber:self.telNoInput.text EMail:self.emailInput.text Captcha:self.verifyCodeInput.text Checksum:self.checkSum AndAgentID:self.inviteCodeInput.text];
    
}

#pragma mark - method
- (NSString*)checkInputCorrect{
    //用户名
    NSString * msg = nil;
    if (0 == [self.userNameInput.text length])
    {
        msg = @"用户名不能为空";
    }
    else if ([self.userNameInput.text length]>25)
    {
        msg = @"用户名过长";
    }

    //用户密码
    if(0 == [self.passwordInput.text length])
    {
        msg = @"密码不能为空";
    }
    
    if(0 == [self.passwordAgInput.text length])
    {
        msg = @"确认密码不能为空";
        
    }
    else if (![self.passwordInput.text isEqualToString:self.passwordAgInput.text])
    {
        msg = @"密码不一致";
        
    }
    
    //电话号
    if (0 == [self.telNoInput.text length]){
        msg = @"电话号码不能为空";
    }
    else if (![ToolCore validPhone:self.telNoInput.text]){
        msg = @"电话号码格式不对";
        
    }
    //邮箱
    if (0 == [self.emailInput.text length])
    {
        msg = @"邮箱不能为空";
    }
    else if (![ToolCore validateEmail:self.emailInput.text])
    {
        msg = @"邮箱格式错误";
    }
    
    if (!self.inviteCodeInput.text.length) {
        msg = @"请输入推荐码";
    }
    
    if (!self.verifyCodeInput.text.length) {
        msg = @"请输入验证码";
    }
    if (([[self.verifyCodeInput.text stringByAppendingString:self.checkSum] intValue] % 97) != 1) {
        msg = @"验证码错误";
    }
    if (msg) {
        [TToast showToast:msg afterDelay:2.0f];
    }
    return msg;
}

-(BOOL)checkVerifyCode{
    
    return NO;
}

SOCKET_PROTOCOL(RegisterCode){
    NSLog(@"验证码返回");
    TraderResponse *rs = response;
    if (rs.rst == 0) {
        self.checkSum = [rs.para objectForKey:@"checksum"];
    }else{
        [TToast  showToast:rs.reason afterDelay:1.5];

    }
    
}

SOCKET_PROTOCOL(Register){
    NSLog(@"注册返回");
    TraderResponse *rs = response;
    NSString * msg = rs.reason;

    if (msg != nil){
        [ToolCore showAlertViewWithTitle:nil message:msg];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
}

@end
