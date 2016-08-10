//
//  BookViewController.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/18.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "BookViewController.h"

@interface BookViewController ()<UIAlertViewDelegate>{
    NSInteger currentBookMonth;
    BOOL isChecked;
    NSDictionary *dicUserInfo;
    NSDictionary *dicMoney;
    BOOL isBooked;
    double ntotalMoney;
    NSInteger diffDate;
}
@property (weak, nonatomic) IBOutlet UILabel *bookIntroduce;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *bookTime;
@property (weak, nonatomic) IBOutlet UILabel *chargeLevel;
@property (weak, nonatomic) IBOutlet UILabel *duedate;
@property (weak, nonatomic) IBOutlet UILabel *bookMonth;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UILabel *accountMoney;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;

@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentBookMonth = 1;
    isChecked = NO;
    
//    "USER_NAME" = hxcjfxs008;
//    avatar = "http://121.43.232.204:8098/upload/default_head.png";
//    balance = "1237209.30";
//    calcdate = "2016/5/26 6:00:02";
//    id = 1419;
//    maxretracement = "0.73";
//    muid = 916;
//    myrowid = "";
//    networth = "1.23721";
//    "nick_name" = huxiao;
//    plevel = 1;
//    "pt_name" = "\U9ec4\U91d1";
//    "row_count" = 58;
//    "row_id" = 10;
//    speciality = 2;
//    subMoney = "0.0000";
//    "sub_be_count" = 0;
//    "sub_fee_id" = 1888;
//    sumnum = 522;
//    sumprofit = "338372.09";
//    "user_type" = 2;
//    winrate = "88.51";
//USER_NAME:用户名 id:用户ID avatar:用户图像地址 speciality:擅长方向ID plevel 星级 sumprofit：收益 winrate：胜率 净值：networth sub_be_count：被订阅次数 submoney:订阅费用 rowid:排名
    
    [self.view setBackgroundColor:[UIColor YColorBackGroudGray]];
    [self.btnOK setBackgroundColor:[UIColor YColorGray]];
    
    self.bookTime.text = [NSString stringWithFormat:@"%ld", (long)currentBookMonth*30];
}

-(void)configureWithData:(id)data{
    dicUserInfo = data[@"data"];
    dicMoney = data[@"money"];
    isBooked = [data[@"isBooked"] boolValue];
    self.accountMoney.text = [NSString stringWithFormat:@"%.2f呼啸币",[dicMoney[@"UseCaijingNum"] doubleValue]];
    self.name.text = dicUserInfo[@"nick_name"];
    diffDate = [data[@"diffDate"] integerValue];
    if (isBooked && diffDate > 0) {
        self.bookTime.text = [NSString stringWithFormat:@"%ld", (long)diffDate];
        NSDate *newDate = [ToolCore addSomeDayFromDate:diffDate+30 beginTime:[ToolCore strFromTimeStr3:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"]];
        
        self.duedate.text = [ToolCore strFromTimeStr3:newDate format:@"yyyy-MM-dd HH:mm:ss"];
    }else{
        self.bookTime.text = @"30天";
        NSDate *newDate = [ToolCore addSomeDayFromDate:30 beginTime:[ToolCore strFromTimeStr3:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"]];
        
        self.duedate.text = [ToolCore strFromTimeStr3:newDate format:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    self.chargeLevel.text = [NSString stringWithFormat:@"%.2f", [dicUserInfo[@"submoney"] doubleValue]];
    ntotalMoney = [dicUserInfo[@"submoney"] doubleValue] * currentBookMonth;
    self.totalMoney.text = [NSString stringWithFormat:@"合计: %.2f币", ntotalMoney];

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
- (IBAction)subAction:(id)sender {
    if (currentBookMonth <= 1) {
        currentBookMonth = 1;
    }else{
        currentBookMonth--;
    }
    self.bookMonth.text = [NSString stringWithFormat:@"%ld", (long)currentBookMonth];
    self.bookTime.text = [NSString stringWithFormat:@"%ld", (long)currentBookMonth*30];
    
    NSDate *newDate = [ToolCore addSomeDayFromDate:-30 beginTime:self.duedate.text];
    ntotalMoney = [dicUserInfo[@"submoney"] doubleValue] * currentBookMonth;
    self.totalMoney.text = [NSString stringWithFormat:@"合计: %.2f币", ntotalMoney];
    self.duedate.text = [ToolCore strFromTimeStr3:newDate format:@"yyyy-MM-dd HH:mm:ss"];
}
- (IBAction)addAction:(id)sender {
    if (currentBookMonth >= 99) {
        currentBookMonth = 99;
    }else{
        currentBookMonth++;
    }
    self.bookMonth.text = [NSString stringWithFormat:@"%ld", (long)currentBookMonth];
    self.bookTime.text = [NSString stringWithFormat:@"%ld", (long)currentBookMonth*30];
    
    NSDate *newDate = [ToolCore addSomeDayFromDate:30 beginTime:self.duedate.text];
    ntotalMoney = [dicUserInfo[@"submoney"] doubleValue] * currentBookMonth;
    self.totalMoney.text = [NSString stringWithFormat:@"合计: %.2f币", ntotalMoney];
    self.duedate.text = [ToolCore strFromTimeStr3:newDate format:@"yyyy-MM-dd HH:mm:ss"];
    
}
- (IBAction)checkAction:(id)sender {
    isChecked = !isChecked;
    if (isChecked) {
        [self.btnCheck setImage:[UIImage imageNamed:@"checkOn"] forState:UIControlStateNormal];
        [self.btnOK setBackgroundColor:[UIColor YColorGreen]];
    }else{
        [self.btnCheck setImage:[UIImage imageNamed:@"checkOff"] forState:UIControlStateNormal];
        [self.btnOK setBackgroundColor:[UIColor YColorGray]];
    }
}
- (IBAction)gotoUsageAction:(id)sender {
    [self performSegueWithIdentifier:@"BookAgreementViewController" sender:nil];
}

- (IBAction)bookAction:(id)sender {
    if (!isChecked) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请勾选订阅协议" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    NSString *strTips = @"";
    if (isBooked) {
        strTips = @"您确定要续约该用户吗?";
    }else{
        strTips = @"您确定要订阅该用户吗?";
    }
    if (ntotalMoney > [dicMoney[@"UseCaijingNum"] doubleValue]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"余额不足，请及时充值" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:strTips delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 0;
    [alertView show];
    
}


#pragma mark - delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1 && alertView.tag == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if (buttonIndex == 1 && alertView.tag == 0) {
        //    订阅	http://121.43.232.204:8097/ajax/DataHandler.ashx?action=subscrib	POST	account（账号）
        //    pwd（密码）	MD5后
        //    paytype	支付类型 1为余额 :0为呼啸币（默认）
        //    paytouserid	被订阅人的用户ID
        //    subtouserid	被订阅人的市场子ID
        //    period	订阅的月数
        //    scribletype	订阅的类型 1. 直接订阅 2. 续订（过期） 3. 续费（未过期）4.退订（只需要传参account,pwd,subtouserid,muid）
        //    muid	被订阅人的市场子账户的muid
        //    money	订阅费用单价（如果为0则是免费订阅，不会产生流水）
        //
        
        NSInteger type = 1;
        if (isBooked){
            if (diffDate > 0) {
                type = 3;
            }else{
                type = 2;
            }
        }
        
        NSDictionary *dicBook = @{@"account":[GlobalValue sharedInstance].uname,
                                  @"pwd": [Request getMD5:[GlobalValue sharedInstance].pwd],
                                  @"paytype":@0,
                                  @"paytouserid":dicUserInfo[@"id"],
                                  @"subtouserid":dicUserInfo[@"sub_fee_id"],
                                  @"period":[NSNumber numberWithInteger:[self.bookMonth.text integerValue]],
                                  @"scribletype":[NSNumber numberWithInteger:type],
                                  @"muid":dicUserInfo[@"muid"],
                                  @"money":[NSNumber numberWithDouble:ntotalMoney]
                                  };
        [NetWork postDataWithServer:@"http://121.43.232.204:8097/ajax/DataHandler.ashx?action=subscrib" sendDic:dicBook kind:HttpRequstSubmit tips:@"正在提交订阅信息..." target:self userInfo:nil callback:^(NSDictionary *resultDic) {
            NSLog(@"resultdic=%@", resultDic);
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"订阅成功" message:@"首页中的\"我的订阅\"查看更多设置" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"我的订阅", nil];
            alertView.tag = 1;
            [alertView show];
        }errorCallback:nil];

    }
}

@end
