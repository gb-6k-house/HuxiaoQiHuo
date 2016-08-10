//
//  MyMoneyViewController.m
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/15.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "MyMoneyViewController.h"
#import "MyMoneyTableViewCell.h"

@interface MyMoneyViewController ()<UITableViewDelegate, UITableViewDataSource>{
    UILabel *emptyLabel;
    NSDictionary *dicMoney;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *money;

@property (strong, nonatomic) NSMutableArray *arrayData;

@end

@implementation MyMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    emptyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, self.view.frame.size.height / 2, 100, 40)];
    emptyLabel.text = @"无数据";
    emptyLabel.font = [UIFont systemFontOfSize:15.0];
    emptyLabel.textColor = [UIColor YColorGray];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)initData{
//    呼啸币流水	http://121.43.232.204:8097/ajax/DataHandler.ashx?action=currency&account=Ranfy&pwd=e10adc3949ba59abbe56e057f20f883e	POST	uname（账号）
//    pwd（密码）
    NSDictionary *dicInfo = @{@"account":[GlobalValue sharedInstance].uname,
                              @"pwd": [Request getMD5:[GlobalValue sharedInstance].pwd]
                              };
    [NetWork postDataWithServer:@"http://121.43.232.204:8097/ajax/DataHandler.ashx?action=currency" sendDic:dicInfo kind:HttpRequstLoading tips:@"" target:self userInfo:nil callback:^(NSDictionary *dic) {
        NSLog(@"saveInformation=%@", dic);
        self.arrayData = dic[@"data"];
        //{"code":0,"msg":"success","data":[{"ID":"1108","SwiftNumber":"C20160505000001","UserID":"1168","UserName":"","UserType":"1","ToUserID":"4","ToUserName":"","ToUserType":"1","Status":"1","UseMoney":"-2.0000","ModifyTime":"2016/5/5 9:35:49","Note":"订阅用户","OperUserID":"1168","OperUserName":"","OpearType":"0","DetailLink":"www.baidu.com","TypeName":"支付"},
        self.arrayData = [self dataFilter:dic[@"data"]];
        
    }errorCallback:^(NSDictionary *resultDic) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureWithData:(id)data{
    dicMoney = data;
    self.money.text = [NSString stringWithFormat:@"%.2f呼啸币", [dicMoney[@"UseCaijingNum"] doubleValue]];
}

-(NSMutableArray *)dataFilter:(NSArray*)originalData{
    NSMutableArray *arrayFilte = [[NSMutableArray alloc]init];
    for (NSDictionary*dic in originalData) {
        //判断时间是否已经跟其他一样了
        if (arrayFilte.count == 0) {
            NSMutableArray *arrayMonth = [[NSMutableArray alloc]initWithObjects:dic, nil];
            NSDictionary *dicMonth = @{@"month":[self getMonth:dic[@"ModifyTime"]],
                                       @"data":arrayMonth};
            [arrayFilte addObject:dicMonth];
        } else {
            BOOL isSameMonth = NO;
            for (NSInteger index = 0; index < arrayFilte.count; ++index) {
                NSDictionary *dicInfo = arrayFilte[index];
                NSString *strMonthFormatter = [self getMonth:dic[@"ModifyTime"]];
                //相同的月，加入数组
                if ([dicInfo[@"month"] isEqualToString:strMonthFormatter]) {
                    NSMutableArray *arrayMonth = dicInfo[@"data"];
                    [arrayMonth addObject:dic];
                    isSameMonth = YES;
                    break;
                }
            }
            if (!isSameMonth) {
                //不同的月，新建一个key-value
                NSMutableArray *arrayMonth = [[NSMutableArray alloc]initWithObjects:dic, nil];
                NSDictionary *dicMonth = @{@"month":[self getMonth:dic[@"ModifyTime"]],
                                           @"data":arrayMonth};
                [arrayFilte addObject:dicMonth];
            }
        }
    }
    
    return arrayFilte;
}

-(NSString*)getMonth:(NSString*) strMonth{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy/MM/dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:strMonth];
    NSDateFormatter *dateFormatterChange = [[NSDateFormatter alloc] init];
    [dateFormatterChange setDateFormat:@"yyyy-MM"];
    
    NSString *month = [NSString stringWithFormat:@"%@", [dateFormatterChange stringFromDate:date]];
    
    return month;
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
- (IBAction)rechargeAction:(id)sender {
    //TODO: 不知道去哪里
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"此功能正在开发中..敬请期待!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}


#pragma mark - delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = self.arrayData[section];
    NSArray *array = [dic objectForKey:@"data"];
    return array.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.arrayData.count == 0) {
        [self.view addSubview:emptyLabel];
    }else{
        [emptyLabel removeFromSuperview];
    }
    return self.arrayData.count;
}

// 设置section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyMoneyTableViewCell *cell = nil;
    NSDictionary *dic = self.arrayData[indexPath.section];
    NSArray *array = [dic objectForKey:@"data"];
    NSDictionary *dicData = array[indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:@"MyMoneyTableViewCell"];
    if (cell == nil) {
        cell = [[MyMoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyMoneyTableViewCell"];
    }
    
    [cell refreshUI:dicData];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = nil;
    v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [v setBackgroundColor:[UIColor YColorBackGroudGray]];
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, self.view.frame.size.width, 30.0f)];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.text = self.arrayData[section][@"month"];
    [v addSubview:labelTitle];
    
    return v;
}


@end
