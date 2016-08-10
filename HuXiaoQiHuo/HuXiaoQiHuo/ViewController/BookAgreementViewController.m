//
//  BookAgreementViewController.m
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/18.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "BookAgreementViewController.h"

@interface BookAgreementViewController ()

@property (weak, nonatomic) IBOutlet UITextView *txtLabel;

@end

@implementation BookAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.txtLabel.font = [UIFont systemFontOfSize:15.0];
    // Do any additional setup after loading the view.
//    订阅服务协议文本	http://121.43.232.204:8097/ajax/DataHandler.ashx?action=servicetext	GET
    [NetWork postDataWithServer:@"http://121.43.232.204:8097/ajax/DataHandler.ashx?action=servicetext" sendDic:nil kind:HttpRequstLoading tips:@"正在取得信息..." target:self userInfo:nil callback:^(NSDictionary *dic){
        self.txtLabel.text = dic[@"data"][0][@"Content"];
    }errorCallback:nil];
    
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

@end
