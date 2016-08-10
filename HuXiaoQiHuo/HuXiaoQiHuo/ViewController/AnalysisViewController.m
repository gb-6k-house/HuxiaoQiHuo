//
//  AnalysisViewController.m
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/17.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "AnalysisViewController.h"
#import "RateView.h"
#import "HistoryTradeItemCell.h"
#import "PositionItemCell.h"
#import "TTEquityLineView.h"
#import "PointTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

#define HISTORY_PAGE_SIZE 10

@interface AnalysisViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    BOOL isBooked;
    NSInteger uid;
    NSInteger muid;
    float scrollOffset;
    NSDictionary *dicAnalysisInfo;
    NSDictionary *dicMoney;
    NSInteger diffDate;
}
@property CGFloat contentOffsetY;
@property CGFloat newContentOffsetY;
@property CGFloat oldContentOffsetY;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *userHeader;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet RateView *rate;
@property (weak, nonatomic) IBOutlet UILabel *goodat;
@property (weak, nonatomic) IBOutlet UILabel *registTime;
@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet UILabel *winRate;
@property (weak, nonatomic) IBOutlet UILabel *accountMoney;
@property (weak, nonatomic) IBOutlet UILabel *bookNumber;
@property (weak, nonatomic) IBOutlet UILabel *totalIncome;
@property (weak, nonatomic) IBOutlet UILabel *totalWinMoney;
@property (weak, nonatomic) IBOutlet UILabel *maxPlayback;
@property (weak, nonatomic) IBOutlet UILabel *totalDeal;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segInfo;
@property (weak, nonatomic) IBOutlet TTEquityLineView *equityLine;
@property (weak, nonatomic) IBOutlet UILabel *bookUseMoney;

@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (weak, nonatomic) IBOutlet UITableView *currentTableView;
@property (weak, nonatomic) IBOutlet UITableView *pointTableView;
@property (weak, nonatomic) IBOutlet UIView *currentView;
@property (weak, nonatomic) IBOutlet UIButton *btnAction;
@property (weak, nonatomic) IBOutlet UIView *noBookView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segTopCons;

@property (strong, nonatomic) NSDictionary *dicInfo;
@property (strong, nonatomic) NSMutableArray *arrayHistoryData;
@property (strong, nonatomic) NSMutableArray *arrayCurrentData;
@property (strong, nonatomic) NSMutableArray *arrayPointData;
@property NSInteger historyIndex;
@property NSInteger pointIndex;
@end

@implementation AnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rate.backgroundColor = [UIColor clearColor];
    self.rate.unMarkImage = [UIImage imageNamed:@"xingxing2"];
    self.rate.markImage = [UIImage imageNamed:@"xingxing1"];
    self.rate.rate = 4.2;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 11, 22, 22);
    [btn setBackgroundImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [btn addTarget:self action: @selector(commentTouched:) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    [self.navigationItem setLeftBarButtonItem:super.back];
    
    self.historyIndex = 1;
    
    self.historyTableView.hidden = NO;
    self.currentTableView.hidden = YES;
    self.pointTableView.hidden = YES;
    
    [self.historyTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.currentTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.pointTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self adjustUI];
}

-(void)configureWithData:(id)data{
    dicAnalysisInfo = data;
    uid = [dicAnalysisInfo[@"id"] integerValue];
    isBooked = [dicAnalysisInfo[@"booked"] boolValue];
    diffDate = [[data objectForKey:@"DiffDate"] integerValue];
    if (isBooked) {
        [_btnAction setTitle:@"我要续费" forState:UIControlStateNormal];
        self.currentTableView.hidden = NO;
        self.noBookView.hidden = YES;
    }else{
        self.currentTableView.hidden = YES;
        self.noBookView.hidden = NO;
        [_btnAction setTitle:@"我要订阅" forState:UIControlStateNormal];
    }
    
    [self initData];
}

-(void)adjustUI{
    self.heightCons.constant = (self.view.frame.size.height - 64 - 60)*2 - 40;
    float pageHeight = self.view.frame.size.height - 64 - 60;
    self.segTopCons.constant = pageHeight - 149 - 223 - 40;
    self.tableViewHeightCons.constant = pageHeight - 40;
    scrollOffset = pageHeight - 40;
}

-(void)initData{
    //分析师主页	http://121.43.232.204:8097/ajax/datahandler.ashx?action=space&uid=1275	POST	uid（用户ID）
    //uname（账号）
    //pwd（密码）
    //{"Code":0,"Msg":"success","Data":{"UserID":1275,"UserName":"d3VnYW5namlhbg==","Avatar":"http://121.43.232.204:8098/upload/default_head.png","SelfInfo":"562W55Wl566A5LuL77yaIOacrOetlueVpeagueaNrkE1MOaMh+aVsOi1sOWKv+eJueeCueiuvuiuoe+8jOe7k+WQiOWkmuWRqOacn+WPmOWMlueJueeCue+8jOaXpeWGheS6pOaYk++8jOWBmuWIsOmrmOiDnOeOh+eahOaKhOW6lemAg+mhtuOAgg==","SubscribeFee":0.0,"SubscribeAmount":16,"Balance":816185.72,"SumProfit":-39659.56,"MaxRetracement":20.34,"WinRate":22.47,"ProfitMargin":-3.97,"SumDealNum":356.0,"StartDate":"2016-03-07T13:36:47","EndDate":"2016-05-20T00:00:00","Level":"1","Special":""}}
    //userid:用户ID,username:用户名(base64),avatar:头像地址,level:用户等级,special:擅长方向(base64),selfinfo:简介(base64),subscribeamount:订阅人数,subscribefee:订阅费用,balance:余额,sumprofit:累计利润,maxretracement:最大回撤,winrate:胜率,profitmargin:利润率,sumdealnum:交易手数,enddate:数据截止日期,startdate:交易开始日期

    NSDictionary *dicSend = @{@"uid":[NSNumber numberWithInteger:uid],
                              @"account":[GlobalValue sharedInstance].uname,
                              @"pwd": [Request getMD5:[GlobalValue sharedInstance].pwd]};
    [NetWork postDataWithServer:@"http://121.43.232.204:8097/ajax/datahandler.ashx?action=space" sendDic:dicSend kind:HttpRequstLoading tips:@"正在取得用户信息..." target:self userInfo:nil callback:^(NSDictionary *resultDic) {
        NSLog(@"分析师信息=%@", resultDic);
        self.dicInfo = resultDic[@"Data"];
        muid = [self.dicInfo[@"MUID"] integerValue];
        [self.userHeader sd_setImageWithURL:self.dicInfo[@"Avatar"] placeholderImage:[UIImage imageNamed:@"UserName"]];
        self.userName.text = [GTMBase64 decodeBase64String:self.dicInfo[@"UserName"]];
        self.rate.unMarkImage = [UIImage imageNamed:@"xingxing2"];
        self.rate.markImage = [UIImage imageNamed:@"xingxing1"];
        self.rate.rate = [self.dicInfo[@"Level"] integerValue];
        self.goodat.text = [NSString stringWithFormat:@"擅长:%@", [GTMBase64 decodeBase64String:self.dicInfo[@"Special"]]];
        self.remark.text = [GTMBase64 decodeBase64String:self.dicInfo[@"SelfInfo"]];
        self.winRate.text = [NSString stringWithFormat:@"%0.2f", [self.dicInfo[@"Balance"] doubleValue]];
        self.accountMoney.text = [NSString stringWithFormat:@"%0.2f", [self.dicInfo[@"WinRate"] doubleValue]];
        self.bookNumber.text = [NSString stringWithFormat:@"%ld", (long)[self.dicInfo[@"SubscribeAmount"] integerValue]];
        self.totalIncome.text = [NSString stringWithFormat:@"累计净利润:%0.2f", [self.dicInfo[@"ProfitMargin"] doubleValue]];
        self.totalWinMoney.text = [NSString stringWithFormat:@"累计净值:%0.2f", [self.dicInfo[@"SumProfit"] doubleValue]];
        self.maxPlayback.text = [NSString stringWithFormat:@"最大回放:%0.2f", [self.dicInfo[@"MaxRetracement"] doubleValue]];
        self.totalDeal.text = [NSString stringWithFormat:@"累计成交量:%0.2f", [self.dicInfo[@"SumDealNum"] doubleValue]];
        self.bookUseMoney.text = [NSString stringWithFormat:@"%ld呼啸币", (long)[self.dicInfo[@"SubscribeFee"] integerValue]];
        
        NSDictionary *dicChat = @{@"uid":[NSNumber numberWithInteger:uid],
                                  @"bdate":self.dicInfo[@"StartDate"],
                                  @"edate":self.dicInfo[@"EndDate"]};
        [NetWork postDataWithServer:@"http://121.43.232.204:8097/ajax/datahandler.ashx?action=netchart" sendDic:dicChat kind:HttpRequstLoading tips:@"正在取得图表信息..." target:self userInfo:nil callback:^(NSDictionary *resultDic) {
            NSLog(@"resultdic=%@", resultDic);
            
            TTEquityDataSet *eDataSet = [[TTEquityDataSet alloc] init];
            
            eDataSet.borderColor = [UIColor grayColor];
            eDataSet.backgroundColor = [UIColor whiteColor];
            eDataSet.borderWidth = 1.0f;
            
            eDataSet.startDate = [ToolCore strFromTimeStr:self.dicInfo[@"StartDate"] format:@"yyyy-MM-dd"];
            eDataSet.endDate = [ToolCore strFromTimeStr:self.dicInfo[@"EndDate"] format:@"yyyy-MM-dd"];
            NSMutableArray * array = [NSMutableArray array];
            array = [NSMutableArray array];
            NSMutableArray *list = [resultDic valueForKey:@"Data"];
            if (![list isKindOfClass:[NSNull class]]){
                for (NSDictionary* dicEntity in resultDic[@"Data"]) {
                    TTEquityEntity *ey =  [[TTEquityEntity alloc] init];
                    ey =  [[TTEquityEntity alloc] init];
                    ey.equity = [dicEntity[@"PointData"] doubleValue];
                    [array addObject:ey];
                }
            }
            eDataSet.data = array;
            [self.equityLine setupData:eDataSet];
            
        }errorCallback:^(NSDictionary *resultDic) {
            
        }];
            
        //注意block中必须用weak self不然存在循环引用问题
        __weak typeof(self)  weakSelf = self;
        
        [self configeRefreshTableView:self.historyTableView headBlock:^{
            weakSelf.historyIndex = 1;
            [weakSelf fetchDateHistoryForTableView:weakSelf.historyTableView pageIndex:weakSelf.historyIndex startTime:[ToolCore strFromTimeStr:self.dicInfo[@"StartDate"] format:@"yyyy-MM-dd"] endTime:[ToolCore strFromTimeStr:self.dicInfo[@"EndDate"] format:@"yyyy-MM-dd"]];
        } footBlock:^{
            weakSelf.historyIndex++;
            [weakSelf fetchDateHistoryForTableView:weakSelf.historyTableView pageIndex:weakSelf.historyIndex startTime:[ToolCore strFromTimeStr:self.dicInfo[@"StartDate"] format:@"yyyy-MM-dd"] endTime:[ToolCore strFromTimeStr:self.dicInfo[@"EndDate"] format:@"yyyy-MM-dd"]];
        }];
        
        if (self.arrayHistoryData == nil){
            [self.historyTableView.header beginRefreshing];
            
        }
        
        [self configeRefreshTableView:self.currentTableView headBlock:^{
            [weakSelf fetchPositionForTableView:weakSelf.currentTableView];
        }footBlock:^{
        }];
        
        if (self.arrayCurrentData == nil){
            [self.currentTableView.header beginRefreshing];
        }
        
        
        NSDictionary *dicInfo = @{@"account":[GlobalValue sharedInstance].uname,
                                  @"pwd": [Request getMD5:[GlobalValue sharedInstance].pwd]
                                  };
        [NetWork postDataWithServer:@"http://121.43.232.204:8097/ajax/DataHandler.ashx?action=getwallet" sendDic:dicInfo kind:HttpRequstLoading tips:@"" target:self userInfo:nil callback:^(NSDictionary *dic) {
            NSLog(@"getwallet=%@", dic);
            dicMoney = dic[@"data"][0];
            //    UserName:用户名 UseMoney：资金余额 UseCaijingNum：呼啸币
            if ((NSInteger)[dicMoney[@"UseCaijingNum"] doubleValue] - [self.dicInfo[@"SubscribeFee"] integerValue] < 0 && !isBooked) {
                [_btnAction setTitle:@"我要续费" forState:UIControlStateNormal];
            }
        }errorCallback:nil];
        
    } errorCallback:^(NSDictionary *resultDic) {
        
    }];

   

    
}
-(void)fetchDateHistoryForTableView:(UITableView*)tableView pageIndex:(NSInteger)index startTime:(NSString*)startT endTime:(NSString*)endT{
    
//    成交历史	"http://121.41.36.129:8092/ajaxhandler/inter.ashx?flag=1&uid=用户编号&page=页码
//    &size=每页记录数&startdate=开始时间(可不填)&enddate=结束时间(可不填)
//    &ohemcode=商品码(可不填)&adverse=建平仓类型(0平仓1建仓)"	Get	flag 值为1 固定
//    uid 用户id
//    page 页码页索引 size每页大小
//    startdate开始时间(可不填)
//    enddate结束时间(可不填)
//    ohemcode商品码(可不填)
//    adverse建平仓类型(可不填)
    
    NSDictionary *dicHistory = @{@"uid": [NSNumber numberWithInteger:muid],
                                 @"page": [NSNumber numberWithInteger:self.historyIndex],
                                 @"size": @HISTORY_PAGE_SIZE,
                                 @"flag":@1,
                                 @"startdate":startT,
                                 @"enddate":endT
                                 };
    
    [NetWork postDataWithServer:@"http://121.41.36.129:8092/ajaxhandler/inter.ashx" sendDic:dicHistory kind:HttpRequstLoadingNone tips:@"" target:self userInfo:nil callback:^(NSDictionary *dic){
        NSLog(@"resultDic %@", dic);
        NSMutableArray *list = [dic objectForKey:@"data"];
        tableView.footer.hidden = [list count] < HISTORY_PAGE_SIZE;
        if (index > 1) {
            [tableView.footer endRefreshing];
            if (tableView == self.historyTableView) {
                [self.arrayHistoryData addObjectsFromArray:list];
            }
        }else{
            if (tableView == self.historyTableView) {
                self.arrayHistoryData = list;
            }
            [tableView.header endRefreshing];
            self.arrayHistoryData.count == 0? [self showEmtiyFlageInView:tableView]:[self hidenEmtiyFlageInView:tableView];
        }
        [tableView reloadData];
        
    } errorCallback:^(NSDictionary *resultDic){
        if (index > 0) { //加载跟多
            [tableView.footer endRefreshing];
        }else{
            [tableView.header endRefreshing];
        }
    }];
}

-(void)fetchPositionForTableView:(UITableView*)tableView{
//    持仓记录	"http://121.41.36.129:8092/ajaxhandler/inter.ashx?flag=6&uid=用户编号
//    &martid=市场编号（可不填）"	GET	uid（用户模拟账号ID）
//    martid（市场编号 可不填）
//    flag 值为6 固定参数
    
    NSDictionary *dicPosition = @{@"uid": [NSNumber numberWithInteger:muid],
                                 @"flag":@6
                                 };
    
    [NetWork postDataWithServer:@"http://121.41.36.129:8092/ajaxhandler/inter.ashx" sendDic:dicPosition kind:HttpRequstLoadingNone tips:@"" target:self userInfo:nil callback:^(NSDictionary *dic){
        NSLog(@"resultDic %@", dic);
        NSMutableArray *list = [dic objectForKey:@"data"];
        tableView.footer.hidden = YES;
        if (tableView == self.currentTableView) {
            self.arrayCurrentData = list;
        }
        [tableView.header endRefreshing];
        self.arrayCurrentData.count == 0? [self showEmtiyFlageInView:tableView]:[self hidenEmtiyFlageInView:tableView];
        [tableView reloadData];
        
    } errorCallback:^(NSDictionary *resultDic){
        if (index > 0) { //加载跟多
            [tableView.footer endRefreshing];
        }else{
            [tableView.header endRefreshing];
        }
    }];
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

#pragma mark -action
-(void)commentTouched:(id)sender{
    [self performSegueWithIdentifier:@"CommentViewController" sender:[NSNumber numberWithInteger:uid]];
}

- (IBAction)segChanged:(UISegmentedControl*)sender {
    [self.scrollView setContentOffset:CGPointMake(0, scrollOffset) animated:YES];
    if (sender.selectedSegmentIndex == 1) {
        self.historyTableView.hidden = YES;
        self.currentView.hidden = NO;
        self.pointTableView.hidden = YES;
    }else if (sender.selectedSegmentIndex == 2) {
        [self getMarketPoint];
        self.historyTableView.hidden = YES;
        self.currentView.hidden = YES;
        self.pointTableView.hidden = NO;
    }else{
        [self.historyTableView.header beginRefreshing];
        self.historyTableView.hidden = NO;
        self.currentView.hidden = YES;
    }
}

-(void)getMarketPoint{
    __weak typeof(self)  weakSelf = self;
    [weakSelf fetchMarketPointForTableView:weakSelf.currentTableView pageIndex:self.pointIndex];
    [self configeRefreshTableView:self.pointTableView headBlock:^{
        self.pointIndex = 1;
        [weakSelf fetchMarketPointForTableView:weakSelf.pointTableView pageIndex:self.pointIndex];
    }footBlock:^{
        ++self.pointIndex;
        [weakSelf fetchMarketPointForTableView:weakSelf.pointTableView pageIndex:self.pointIndex];
    }];
    
    if (self.arrayPointData == nil){
        [self.pointTableView.header beginRefreshing];
    }
}

-(void)fetchMarketPointForTableView:(UITableView*)tableView pageIndex:(NSInteger)index{
    //    行情观点（列表）	http://121.43.232.204:8097/ajax/datahandler.ashx?action=articles&uid=4&pid=2&count=5&scount=10	GET	uid（用户ID）
    //    count（返回记录数）	自定义正整数，默认为3
    //    pid（页码）	自定义正整数，默认为1
    //    scount(每篇文章返回的字数，不包括html标签)	自定义正整数，默认为100

    NSDictionary *dicPoint = @{@"uid": [NSNumber numberWithInteger:uid],
                                 @"pid": [NSNumber numberWithInteger:index],
                                 @"count": @HISTORY_PAGE_SIZE,
                                 @"scount":@100
                                 };
    
    [NetWork postDataWithServer:@"http://121.43.232.204:8097/ajax/datahandler.ashx?action=articles" sendDic:dicPoint kind:HttpRequstLoadingNone tips:@"" target:self userInfo:nil callback:^(NSDictionary *dic){
        NSLog(@"dicPoint %@", dic);
        NSMutableArray *list = [dic valueForKey:@"Data"];
        if (![list isKindOfClass:[NSNull class]]){
            tableView.footer.hidden = [list count] < HISTORY_PAGE_SIZE;
            if (index > 1) {
                [tableView.footer endRefreshing];
                if (tableView == self.pointTableView) {
                    [self.arrayPointData addObjectsFromArray:list];
                }
            }else{
                if (tableView == self.pointTableView) {
                    self.arrayPointData = list;
                }
                [tableView.header endRefreshing];
                self.arrayPointData.count == 0? [self showEmtiyFlageInView:tableView]:[self hidenEmtiyFlageInView:tableView];
            }
            [tableView reloadData];
        }else{
            self.arrayPointData.count == 0? [self showEmtiyFlageInView:tableView]:[self hidenEmtiyFlageInView:tableView];
            [tableView.header endRefreshing];
        }
        
    } errorCallback:^(NSDictionary *resultDic){
        if (index > 0) { //加载跟多
            [tableView.footer endRefreshing];
        }else{
            [tableView.header endRefreshing];
        }
    }];
}





- (IBAction)action:(id)sender {
    NSDictionary *dicSend = @{@"isBooked":[NSNumber numberWithBool:isBooked],
                              @"data":dicAnalysisInfo,
                              @"money":dicMoney,
                              @"diffDate":[NSNumber numberWithInteger:diffDate]};

    [self performSegueWithIdentifier:@"BookViewController" sender:dicSend];
    
}

#pragma mark - scroll delegate
//在视图滚动时接到通知，包括一个指向被滚动视图的指针，从中可读取contentOffset属性已确定其滚动到的位置
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    self.contentOffsetY = scrollView.contentOffset.y;
//}
//
//// 滚动时调用此方法(手指离开屏幕后)
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//    self.newContentOffsetY = scrollView.contentOffset.y;
//    
//    if (scrollView.dragging) {  // 拖拽
//        if ((scrollView.contentOffset.y - self.contentOffsetY) > 5.0f) {  // 向上拖拽
//            [scrollView setContentOffset:CGPointMake(0, scrollOffset) animated:YES];
//        } else if ((self.contentOffsetY - scrollView.contentOffset.y) > 5.0f) {   // 向下拖拽
//            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        } else {
//            
//        }
//        
//    }
//    
//}
//
//// 完成拖拽(滚动停止时调用此方法，手指离开屏幕前)
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    self.oldContentOffsetY = scrollView.contentOffset.y;
//}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.historyTableView) {
        return self.arrayHistoryData.count;
    }else if (tableView == self.currentTableView){
        return self.arrayCurrentData.count;
    }else if (tableView == self.pointTableView){
        return self.arrayPointData.count;
    }else{
        return 0;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.historyTableView){
        return 109.0f;
    }else if (tableView == self.currentTableView){
        return 110.0f;
    }else{
        //TODO: 布局还有问题
        CGFloat fHeith = [tableView fd_heightForCellWithIdentifier:@"PointTableViewCell" cacheByIndexPath:indexPath configuration:^(PointTableViewCell * cell) {
            NSDictionary *dicData = [self.arrayPointData objectAtIndex:indexPath.row];
            [cell refreshUI:dicData];
            
        }];
        return fHeith + 45.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = nil;
    if (tableView == self.historyTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTradeItemCell"];
        NSDictionary *dicData = self.arrayHistoryData[indexPath.row];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"HistoryTradeItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HistoryTradeItemCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTradeItemCell"];
        }
        [(HistoryTradeItemCell* )cell refreshUI:dicData];
    }else if (tableView == self.currentTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PositionItemCell"];
        NSDictionary *dicData = self.arrayCurrentData[indexPath.row];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"PositionItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PositionItemCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"PositionItemCell"];
        }
        [(PositionItemCell* )cell refreshUI:dicData];
    }else if (tableView == self.pointTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PointTableViewCell"];
        if (cell == nil) {
            cell = [[PointTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PointTableViewCell"];
        }
        cell = [tableView dequeueReusableCellWithIdentifier:@"PointTableViewCell"];
        if (!cell){
            cell = [tableView dequeueReusableCellWithIdentifier:@"PointTableViewCell"];
        }
        
        NSDictionary *dicData = self.arrayPointData[indexPath.row];
        [((PointTableViewCell* )cell).headerImg sd_setImageWithURL:self.dicInfo[@"Avatar"] placeholderImage:[UIImage imageNamed:@"UserName"]];
        [(PointTableViewCell* )cell refreshUI:dicData];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[self performSegueWithIdentifier:@"GotoStockDetail" sender:nil];
}


@end
