//
//  NickNameViewController.m
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/15.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "NickNameViewController.h"

@interface NickNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nickName;

@property (strong, nonatomic) NSDictionary *dicUserInfo;
@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self  action:@selector(saveTouched:)];
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor], nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, nil]] forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    [self.view setBackgroundColor:[UIColor YColorBackGroudGray]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureWithData:(id)data{
    self.dicUserInfo = data;
    NSString *strNickName = self.dicUserInfo[@"NickName"];
    self.nickName.text = strNickName;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)saveTouched:(id)sender{
    if ([_nickName.text isEqualToString:@""]) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入昵称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if (_nickName.text.length > 10) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入10个字符以内的昵称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    NSDictionary *dicInfo = @{@"uname":[GlobalValue sharedInstance].uname,
                              @"pwd": [Request getMD5:[GlobalValue sharedInstance].pwd],
                              @"nickname":_nickName.text,
                              @"sex":self.dicUserInfo[@"Sex"]};
    [NetWork postDataWithServer:@"http://121.43.232.204:8097/ajax/DataHandler.ashx?action=modify" sendDic:dicInfo kind:HttpRequstSubmit tips:@"正在提交信息" target:self userInfo:nil callback:^(NSDictionary *dic) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userNameUpdate" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }errorCallback:^(NSDictionary *resultDic) {
        
    }];
    
}


@end
