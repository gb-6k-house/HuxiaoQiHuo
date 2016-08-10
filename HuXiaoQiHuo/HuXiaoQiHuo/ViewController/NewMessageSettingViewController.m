//
//  NewMessageSettingViewController.m
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/16.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "NewMessageSettingViewController.h"

@interface NewMessageSettingViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *messageOpenSwith;
@property (weak, nonatomic) IBOutlet UISwitch *soundTipsSwith;
@property (weak, nonatomic) IBOutlet UISwitch *nightModeSwitch;

@end

@implementation NewMessageSettingViewController

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

@end
