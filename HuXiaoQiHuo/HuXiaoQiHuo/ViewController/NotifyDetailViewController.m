//
//  NotifyDetailViewController.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/13.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "NotifyDetailViewController.h"

@interface NotifyDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation NotifyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSURL *url = [[NSURL alloc]initWithString:@"http://3g.sina.com.cn/"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
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
