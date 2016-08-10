//
//  NotifyMessageViewController.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/12.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "NotifyMessageViewController.h"
#import "NotifyTableViewCell.h"

@interface NotifyMessageViewController (){
    BOOL bManage;
}

@property (weak, nonatomic) IBOutlet UITableView *notifyTableView;
@property (strong, nonatomic) NSArray *arrayData;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *btnAllRead;
@end

@implementation NotifyMessageViewController

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

#pragma mark - method
-(void)initData{
    
    NSDictionary *dicMessage1 = @{ @"actionInfo": @"平仓成功",
                                   @"content": @"我想用Teamviewer远端连入iMac, 可是萤幕关掉后，程式就没办法跑了，所以也没办法连，该如何解决呢?上网找了NoSleep装了也无效。",
                                   @"time": @"2016-05-25 17:12:11",
                                   @"messageState": @0
                                  };
    NSDictionary *dicMessage2 = @{ @"actionInfo": @"挂单已执行",
                                   @"content": @"我想用Teamviewer远端连入iMac, 可是萤幕关掉后，程式就没办法跑了，所以也没办法连，该如何解决呢?上网找了NoSleep装了也无效。",
                                   @"time": @"2016-05-25 17:12:11",
                                   @"messageState": @0
                                   };

    NSMutableDictionary *dicMutMessage1 = [[NSMutableDictionary alloc]initWithDictionary:dicMessage1];
    NSMutableDictionary *dicMutMessage2 = [[NSMutableDictionary alloc]initWithDictionary:dicMessage2];
    self.arrayData = @[dicMutMessage1, dicMutMessage2];

}

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

- (IBAction)allReadAction:(id)sender {
    for (NSInteger i = 0; i < self.arrayData.count; i++) {
        NSDictionary *dic = self.arrayData[i];
        [dic setValue:[NSNumber numberWithInteger:1] forKey:@"messageState"];
    }
    
    [self.notifyTableView reloadData];
}


#pragma mark - delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotifyTableViewCell *cell = nil;
    NSDictionary *dicData = self.arrayData[indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:@"NotifyTableViewCell"];
    if (cell == nil) {
        cell = [[NotifyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NotifyTableViewCell"];
    }
    
    [cell refreshUI:dicData];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"NotifyDetailViewController" sender:self.arrayData[indexPath.row]];
}

@end
