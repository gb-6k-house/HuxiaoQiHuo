//
//  RssMessageViewController.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/12.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "RssMessageViewController.h"
#import "RssTableViewCell.h"

@interface RssMessageViewController (){
    BOOL bManage;
}
@property (weak, nonatomic) IBOutlet UITableView *rssTableView;

@property (strong, nonatomic) NSArray *arrayRssMessage;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *btnAllRead;

@end

@implementation RssMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    bManage = YES;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self  action:@selector(manageTouched:)];
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor], nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, nil]] forState:UIControlStateNormal];
    
    self.cancelButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self  action:@selector(cancelTouched:)];
    [self.cancelButton setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor], nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, nil]] forState:UIControlStateNormal];

    
    [self.navigationItem setRightBarButtonItem:rightButton];

    [self initData];
    
}

-(void)initData{
    NSDictionary *dicSampleData = @{@"rssTime": @"2016-4-25 11:37:25",
                                    @"userName": @"超极天下无敌",
                                    @"userLevel": @"程序化",
                                    @"accountMoney": @"12345678.677",
                                    @"todayMoney": @"+12333.22",
                                    @"winRate": @"77.1%",
                                    @"type": @"建仓",
                                    @"typeName": @"布伦特原油",
                                    @"typeDate": @"2016-05",
                                    @"dealPrice": @"1234.5",
                                    @"dealNumber": @"1234",
                                    @"dealMoney": @"1234.56",
                                    @"messageState": @0};
    
    NSDictionary *dicSampleData2 = @{@"rssTime": @"2016-4-25 11:37:25",
                                    @"userName": @"超极天下",
                                    @"userLevel": @"分析师",
                                    @"accountMoney": @"1234323278.677",
                                    @"todayMoney": @"+333333.22",
                                    @"winRate": @"74.1%",
                                    @"type": @"建仓",
                                    @"typeName": @"布伦特原油",
                                    @"typeDate": @"2016-05",
                                    @"dealPrice": @"1234.5",
                                    @"dealNumber": @"1234",
                                    @"dealMoney": @"1234.56",
                                    @"messageState": @0};
    
    NSMutableDictionary *dicMutMessage1 = [[NSMutableDictionary alloc]initWithDictionary:dicSampleData];
    NSMutableDictionary *dicMutMessage2 = [[NSMutableDictionary alloc]initWithDictionary:dicSampleData2];
    
    self.arrayRssMessage = @[dicMutMessage1, dicMutMessage2];
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

-(void)manageTouched:(id)sender{
    UIBarItem *item = (UIBarItem *)sender;
    
    bManage = !bManage;
    if (bManage) {
        item.title = @"管理";
        self.btnAllRead.hidden = YES;
        [self.navigationItem setLeftBarButtonItem:nil];
        [self.navigationItem setLeftBarButtonItem:super.back];
    }else{
        item.title = @"完成";
        self.btnAllRead.hidden = NO;
        [self.navigationItem setLeftBarButtonItem:self.cancelButton];
    }
    
}

-(void)cancelTouched:(id)sender{
    bManage = NO;
    [self manageTouched:self.navigationItem.rightBarButtonItem];
}

-(void)followAction:(UIButton*)sender{
    NSInteger btnTag = sender.tag;
    //TODO: 暂时不知道操作和跳转
}

- (IBAction)allReadAction:(id)sender {
    for (NSInteger i = 0; i < self.arrayRssMessage.count; i++) {
        self.arrayRssMessage[i][@"messageState"] = @YES;
    }
    
    [self.rssTableView reloadData];
}

#pragma mark - delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayRssMessage.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RssTableViewCell *cell = nil;
    NSDictionary *dicData = self.arrayRssMessage[indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:@"RssTableViewCell"];
    if (cell == nil) {
        cell = [[RssTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RssTableViewCell"];
    }
    
    [cell refreshUI:dicData];
    cell.btnFollow.tag = indexPath.row;
    [cell.btnFollow addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

@end
