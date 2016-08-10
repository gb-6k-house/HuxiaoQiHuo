//
//  ForgetPasswordViewController.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/12.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "GetCodeTool.h"

@interface ForgetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgInput;
@property (weak, nonatomic) IBOutlet UITextField *telNoInput;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeInput;
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;

@property NSString* checkSum;
@end

@implementation ForgetPasswordViewController

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
- (IBAction)commitAction:(id)sender {
    if (![self checkInputCorrect]) {
        return;
    }
    
    [[CRegisterClientSocket sharedInstance] modifyUser:self.userNameInput.text newPassword:self.passwordInput.text PhoneNumber:self.telNoInput.text  Captcha:self.verifyCodeInput.text Checksum:self.checkSum];
    
}

SOCKET_PROTOCOL(ModifyPassword){
    TraderResponse *rs = response;
    NSString * msg = rs.reason;
    
    if (msg != nil){
        [ToolCore showAlertViewWithTitle:nil message:msg];
    }else{
        [ToolCore showAlertViewWithTitle:nil message:@"密码修改成功！"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)getCodeAction:(id)sender {
    if (0 == [self.userNameInput.text length])
    {
        [TToast showToast: @"用户名不能为空" afterDelay:2.0f];
        return;
    }
    GetCodeTool * getCodeTool = [[GetCodeTool alloc] init];
    getCodeTool.view = self.view;
    getCodeTool.btn = (UIButton*)sender;
    getCodeTool.strPhone = _telNoInput.text;
    getCodeTool.strUserName = self.userNameInput.text;
    getCodeTool.strClientType = @"modifyPassword";
    [getCodeTool check];

}

#pragma mark - delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - method
- (BOOL)checkInputCorrect{
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
    
    if (([[self.verifyCodeInput.text stringByAppendingString:self.checkSum] intValue] % 97) != 1) {
        msg = @"验证码错误";
    }
    
    //电话号
    if (0 == [self.telNoInput.text length]){
        msg = @"电话号码不能为空";
    }
    else if (![ToolCore validPhone:self.telNoInput.text]){
        msg = @"电话号码格式不对";
        
    }
    if (msg) {
        [TToast showToast:msg afterDelay:2.0f];
        return NO;
    }
    return YES;

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


@end
