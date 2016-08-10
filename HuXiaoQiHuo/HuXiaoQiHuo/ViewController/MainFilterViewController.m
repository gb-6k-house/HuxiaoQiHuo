//
//  MainFilterViewController.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/16.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "MainFilterViewController.h"

@interface MainFilterViewController (){
    NSInteger level;
    NSInteger filterId;
}
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *starLevel;

@property (strong, nonatomic) NSArray *arrData;
@end

@implementation MainFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"重置" style:UIBarButtonItemStylePlain target:self  action:@selector(resetTouched:)];
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor], nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, nil]] forState:UIControlStateNormal];
    
    [self.navigationItem setRightBarButtonItem:rightButton];
    
//    获取产品种类	http://121.43.232.204:8097/ajax/DataHandler.ashx?action=getproductlist	GET	name(产品名，模糊查询)
    NSDictionary *dicSend = @{@"name":@""};
    [NetWork postDataWithServer:@"http://121.43.232.204:8097/ajax/DataHandler.ashx?action=getproductlist" sendDic:dicSend kind:HttpRequstLoadingNone tips:@"" target:self userInfo:nil callback:^(NSDictionary *dic){
        self.arrData = dic[@"data"];
    }errorCallback:^(NSDictionary *resultDic) {
        
    }];
    
    filterId = -1;
    
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
- (IBAction)chooseTypeAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //{"code":0,"msg":6,"data":[{"id":"1","name":"白银","sequence":"0"},{"id":"2","name":"黄金","sequence":"0"},{"id":"3","name":"a50","sequence":"0"},{"id":"4","name":"恒指","sequence":"0"},{"id":"5","name":"原油","sequence":"0"},{"id":"6","name":"外汇","sequence":"0"}]}
    
    for (NSInteger i = 0; i < self.arrData.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:self.arrData[i][@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.type.text = self.arrData[i][@"name"];
            filterId = [self.arrData[i][@"id"] integerValue];
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];

}

- (IBAction)chooseStarAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"不限" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.starLevel.text = @"不限";
        level = 0;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"1星" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        self.starLevel.text = @"1星";
        level = 1;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"2星" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        self.starLevel.text = @"2星";
        level = 2;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"3星" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        self.starLevel.text = @"3星";
        level = 3;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"4星" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        self.starLevel.text = @"4星";
        level = 4;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"5星" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        self.starLevel.text = @"5星";
        level = 5;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];

}
- (IBAction)chooseAction:(id)sender {
    NSDictionary *dicSend = @{@"type":[NSNumber numberWithInteger:filterId],
                              @"level":[NSNumber numberWithInteger:level],
                              @"isBack": @YES};
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"backViewController" object:dicSend];
    [self performSegueWithIdentifier:@"backViewController" sender:dicSend];
}

-(void)resetTouched:(id)sender{
    self.type.text = @"原油";
    filterId = -1;
    self.starLevel.text = @"不限";
    level = 0;
}

@end
