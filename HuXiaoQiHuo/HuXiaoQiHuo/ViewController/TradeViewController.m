//
//  TradeViewController.m
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/12.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#define HISTORY_PAGE_SIZE 10

#import "TradeViewController.h"
#import "TTPageView.h"
#import "PositionItemCell.h"
#import "TTEquityLineView.h"
#import "HistoryTradeItemCell.h"
#import "HangTradeItemCell.h"
#import "CGT6ClientSocket.h"
#import "LoadUserInfoResponse.h"
#import "GT6LoginResponse.h"

@interface TradeViewController ()<TTPageViewSource, TTPageViewDelegate>{
    LoadUserInfoResponseData *info;
   
    double accountPofit;
    double accountAvailabelBalance;
    double accountEquity;
    double accountDepositCash;
    NSInteger accountPosition;
    double accountProfitLoss;
    double accountRiskRate;
}
@property (nonatomic, strong) NSArray *titleList;
@property (nonatomic, strong) NSArray *viewList;

@property (weak, nonatomic) IBOutlet TTPageView *pageView;
@property (strong, nonatomic) IBOutlet UIView *pageIndexView1;
@property (strong, nonatomic) IBOutlet UIView *pageIndexView2;
@property (strong, nonatomic) IBOutlet UIView *pageIndexView3;
@property (strong, nonatomic) IBOutlet UIView *pageIndexView4;
@property (weak, nonatomic) IBOutlet UILabel *lblSumProfitLoss; //盈亏总计
@property (weak, nonatomic) IBOutlet UITableView *positionTabelView;
@property (weak, nonatomic) IBOutlet UITableView *historyTabelView;
@property (weak, nonatomic) IBOutlet UITableView *hangTabelView;

@property(nonatomic, strong)NSArray *arrayPosition;//持仓
@property(nonatomic, strong)NSMutableArray *arrayHistory;//历史
@property(nonatomic, strong)NSArray *arrayHolder;//历史

@property NSInteger historyIndex;

@property (weak, nonatomic) IBOutlet UILabel *lblBalance;  //账户余额
@property (weak, nonatomic) IBOutlet UILabel *lblPofit;  //今日收益
@property (weak, nonatomic) IBOutlet UILabel *lblAvailabelBalance;  //可用余额
@property (weak, nonatomic) IBOutlet UILabel *lblEquity;   //账户净值
@property (weak, nonatomic) IBOutlet UILabel *lblDepositCash;  //占用保证金
@property (weak, nonatomic) IBOutlet UILabel *lblPosition; //持仓
@property (weak, nonatomic) IBOutlet UILabel *lblProfitLoss;  //盈亏
@property (weak, nonatomic) IBOutlet UILabel *lblRiskRate;  //风险率
@property (weak, nonatomic) IBOutlet TTEquityLineView *equityLineView;
@property (nonatomic, strong) MBProgressHUD *progressView;

@property (nonatomic, strong) NSDictionary *dicInfo;
@property (nonatomic, strong) CGT6ClientSocket *gt6Socket;

@end

@implementation TradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super setShowBackButton:NO];
    self.pageView.delegate = self;
    self.pageView.dataSource = self;
    self.titleList = @[@"账户",@"持仓",@"历史",@"挂单"];
    
    [self.positionTabelView registerNib:[UINib nibWithNibName:@"PositionItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PositionItemCell"];
    [self.historyTabelView registerNib:[UINib nibWithNibName:@"HistoryTradeItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HistoryTradeItemCell"];
    self.viewList = @[self.pageIndexView1,self.pageIndexView2,self.pageIndexView3, self.pageIndexView4];

    self.equityLineView.hidden = YES;
    
    
    accountPofit = 0.0;
    accountAvailabelBalance = 0.0;
    accountEquity = 0.0;
    accountDepositCash = 0.0;
    accountPosition = 0;
    accountProfitLoss = 0.0;
    accountRiskRate = 0.0;
    
    
    self.lblPofit.text = [NSString stringWithFormat:@"%.2f",accountPofit];
    self.lblAvailabelBalance.text = [NSString stringWithFormat:@"%.2f",accountAvailabelBalance];
    self.lblEquity.text = [NSString stringWithFormat:@"%.2f",accountEquity];
    self.lblDepositCash.text = [NSString stringWithFormat:@"%.2f",accountDepositCash];
    self.lblPosition.text = [NSString stringWithFormat:@"%ld",(long)accountPosition];
    self.lblProfitLoss.text = [NSString stringWithFormat:@"%.2f",accountProfitLoss];
    self.lblRiskRate.text = [NSString stringWithFormat:@"%.2f",accountRiskRate];
    
    NSDictionary *dicSend = @{@"uid":[NSString stringWithFormat:@"%ld", (long)[GlobalValue sharedInstance].uid],
                              @"account":[GlobalValue sharedInstance].uname,
                              @"pwd": [Request getMD5:[GlobalValue sharedInstance].pwd]};
    [NetWork postDataWithServer:@"http://121.43.232.204:8097/ajax/datahandler.ashx?action=space" sendDic:dicSend kind:HttpRequstLoading tips:@"正在取得用户信息..." target:self userInfo:nil callback:^(NSDictionary *resultDic) {
        NSLog(@"分析师信息=%@", resultDic);
        self.dicInfo = resultDic[@"Data"];

        __weak typeof(self)  weakSelf = self;
        
        [self configeRefreshTableView:self.historyTabelView headBlock:^{
            weakSelf.historyIndex = 1;
            [weakSelf fetchDateHistoryForTableView:weakSelf.historyTabelView pageIndex:weakSelf.historyIndex startTime:[ToolCore strFromTimeStr:self.dicInfo[@"StartDate"] format:@"yyyy-MM-dd"] endTime:[ToolCore strFromTimeStr:self.dicInfo[@"EndDate"] format:@"yyyy-MM-dd"]];
        } footBlock:^{
            weakSelf.historyIndex++;
            [weakSelf fetchDateHistoryForTableView:weakSelf.historyTabelView pageIndex:weakSelf.historyIndex startTime:[ToolCore strFromTimeStr:self.dicInfo[@"StartDate"] format:@"yyyy-MM-dd"] endTime:[ToolCore strFromTimeStr:self.dicInfo[@"EndDate"] format:@"yyyy-MM-dd"]];
        }];
    
    if (self.arrayHistory == nil){
        [self.historyTabelView.header beginRefreshing];
        
    }}errorCallback:nil];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![CGT6ClientSocket sharedInstance].isConnected) {
        [self connectTradeServer];
    }
}
-(void)connectTradeServer{
    self.gt6Socket = [CGT6ClientSocket sharedInstance];
    [self.progressView hide:YES];
    self.progressView = [TToast showProcess:@"正在登录交易服务" inView:self.view];
    [[CGT6ClientSocket sharedInstance] connectToHost:@"121.41.47.212" onPort:9403];
}
SOCKET_PROTOCOL(SocketConnected){
    NSDictionary *dic = response;
    if([CGT6ClientSocket sharedInstance] == dic[@"socket"]){
        [self.progressView hide:YES];
        self.progressView = [TToast showProcess:@"正在获取用户信息" inView:self.view];
        [self.gt6Socket loginWithUsername:[GlobalValue sharedInstance].tradeAccount AndPassword:[GlobalValue sharedInstance].tradePwd];

    }

}

SOCKET_PROTOCOL(NewPrice){
    accountPofit = 0.0f;
    if (self.isApear) {
        [self refreshUI];
    }
    
}

SOCKET_PROTOCOL(GT6Login){
    GT6LoginResponse * rs = response;
    [GlobalValue sharedInstance].tradeUID = ((GT6LoginResponseData*)rs.responseData).uid;
    NSLog(@"交易模块登录返回 %@",response);
}

SOCKET_PROTOCOL(GT6UserInfo){
  
    LoadUserInfoResponse *rs = response;
    info = (LoadUserInfoResponseData*)rs.responseData;
    self.arrayPosition = info.positionlist;
    self.arrayHolder = info.orderlist;
    [self calcAccoutInfo:info];
    
    self.lblBalance.text = [NSString stringWithFormat:@"%.2f", info.price];
    NSLog(@"交易模块获取用户信息返回");
    [self.progressView hide:YES];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)calcAccoutInfo:(LoadUserInfoResponseData*)data{
    //获取最新价格
    NSMutableSet *set = [NSMutableSet set]; //商品
    
    for (NSInteger index = 0; index < data.positionlist.count; ++index) {
        NSString* mmcode = data.positionlist[index][@"mmcode"];		//商品编码
        MerpList_Obj *mpObj = [[CTradeClientSocket sharedInstance] merpListObjWithMpcode:mmcode];

        [set addObject:@(mpObj.nIndex)];
    }
    
    [[CTradeClientSocket sharedInstance] updateMarketInfoWithMpIndexs:set];
    [self refreshUI];
}

-(void)refreshUI{
    //    user			//用户ID
    //    name		//用户名
    //    price			//用户余额
    //    loan			//用户借款
    //    orderlist		//订单列表,JSON的array,成员结构如下
    //    {
    //        user			//用户ID
    //        id			//订单ID
    //        mmcode		//商品编码
    //        mpname		//商品名称
    //        time			//下单时间
    //        isbuy		//1:买,0:卖
    //        number		//数量
    //        oddnumber	//未成交数量
    //        adverse		//平仓标志 1:平仓 0:建仓
    //        price			//订单价格
    //        modetype		//订单状态(见备注1)
    //        loss			//止损价格
    //        margin		//占用的保证金
    //    }
    //    positionlist		//持仓列表,JSON的array,成员结构如下
    //    {
    //        uid			//用户ID
    //        id			//持仓ID
    //        mmcode		//商品编码
    //        mpname		//商品名称
    //        time			//建仓时间
    //        price			//订单价格
    //        isbuy		//1:买,0:卖
    //        number		//数量
    //        mpamount	/每手的量
    //        mpxchange	//汇率
    //        mpcurrency	/币种
    //        margin		//占用的保证金
    //    }
    
    /**
     *  @author LiuK, 16-06-02 15:06:40
     *
     *
     账户余额 price
     今日收益和盈亏是一个东西
     差价*number*mpamount*mpxchange
     可用余额 净值-保证金
     净值 账号余额-盈亏
     持仓 持仓数
     占用保证金 margin 持仓保证金+挂单保证金
     风险率是 持仓保证金/净值
     */
    //    "{user:970,name:\"6K01HX\",price:1000000.0000000,loan:0.0000000,outfreezing:0.0000000,orderfreezing:0.0000000,positionsfreezing:0.0000000,orderlist:[],positionlist:[],time:\"2016-06-02 18:47:20\"}","ScId":0,"UId":0,"check":""}
    
    
    double totalPositionMargin = 0.0;
    accountPofit = 0.0f;
    for (NSInteger index = 0; index < info.positionlist.count; ++index) {
        //        NSInteger uid = [info.positionlist[index][@"uid"] integerValue];			//用户ID
        //        NSInteger nid = [info.positionlist[index][@"nid"] integerValue];			//持仓ID
        NSString* mmcode = info.positionlist[index][@"mmcode"];		//商品编码
        //        NSString* mpname = info.positionlist[index][@"mpname"];		//商品名称
        //        NSString* time = info.positionlist[index][@"time"];		//建仓时间
        double price = [info.positionlist[index][@"price"] doubleValue];			//订单价格
        BOOL isbuy = [info.positionlist[index][@"isbuy"] boolValue];		//1:买,0:卖
        NSInteger number = [info.positionlist[index][@"number"] integerValue];		//数量
        NSInteger mpamount = [info.positionlist[index][@"mpamount"] integerValue];	//每手的量
        double mpxchange = [info.positionlist[index][@"mpxchange"] doubleValue];	//汇率
        //        NSString* mpcurrency = info.positionlist[index][@"mpcurrency"];		//币种
        double margin = [info.positionlist[index][@"margin"] doubleValue];		//占用的保证金
        MerpList_Obj *mpObj = [[CTradeClientSocket sharedInstance] merpListObjWithMpcode:mmcode];
        
        if (mpObj.priceObJ != nil) {
            PriceData_Obj* priceObJ = mpObj.priceObJ;
            
            double priceDiff = 0.0;
            if (isbuy) {
                //买  :当前价-订单价
                priceDiff = priceObJ.fLatestPrice - price;
            }else{
                //卖  :订单价-当前价
                priceDiff = price - priceObJ.fLatestPrice;
            }
            accountPofit += priceDiff*number*mpamount*mpxchange;
        }
        
        totalPositionMargin += margin;
    }
    
    accountProfitLoss = accountPofit;
    accountEquity = info.price - accountPofit;
    accountPosition = info.positionlist.count;
    if (accountEquity > -0.000001 && accountEquity < 0.000001) {
        accountRiskRate = 0;
    }else{
        accountRiskRate = totalPositionMargin * 100 / accountEquity;
    }
    
    double totalOrderMargin = 0.0;
    for (NSInteger index = 0; index < info.orderlist.count; ++index) {
        //        NSInteger uid = [info.orderlist[index][0] integerValue];			//用户ID
        //        NSInteger nid = [info.orderlist[index][1] integerValue];			//订单ID
        //        NSInteger mmcode = [info.orderlist[index][2] integerValue];		//商品编码
        //        NSString* mpname = info.orderlist[index][3];		//商品名称
        //        NSString* time = info.orderlist[index][4];		//下单时间
        //        BOOL isbuy = [info.orderlist[index][5] boolValue];		//1:买,0:卖
        //        NSInteger number = [info.orderlist[index][6] integerValue];		//数量
        //        NSInteger oddnumber = [info.orderlist[index][7] integerValue];	//未成交数量
        //        BOOL adverse = [info.orderlist[index][8] boolValue];	//平仓标志 1:平仓 0:建仓
        //        double price = [info.orderlist[index][9] doubleValue];  //订单价格
        //        NSInteger modetype = [info.orderlist[index][10] integerValue];		//订单状态(见备注1)
        //        double loss = [info.orderlist[index][11] doubleValue];		//止损价格
        double margin = [info.orderlist[index][@"margin"] doubleValue];		//占用的保证金
        
        totalOrderMargin += margin;
    }
    accountDepositCash = totalOrderMargin + totalPositionMargin;
    accountAvailabelBalance = accountEquity - totalOrderMargin;
    
    self.lblPofit.text = [NSString stringWithFormat:@"%.2f",accountPofit];
    self.lblAvailabelBalance.text = [NSString stringWithFormat:@"%.2f",accountAvailabelBalance];
    self.lblEquity.text = [NSString stringWithFormat:@"%.2f",accountEquity];
    self.lblDepositCash.text = [NSString stringWithFormat:@"%.2f",accountDepositCash];
    self.lblPosition.text = [NSString stringWithFormat:@"%ld",(long)accountPosition];
    self.lblProfitLoss.text = [NSString stringWithFormat:@"%.2f",accountProfitLoss];
    self.lblRiskRate.text = [NSString stringWithFormat:@"%.2f",accountRiskRate];
    
    
    [self.positionTabelView reloadData];
    [self.historyTabelView reloadData];
    [self.hangTabelView reloadData];
    
    self.lblSumProfitLoss.text = [NSString stringWithFormat:@"%.2f", accountPofit];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    
    if(![[ToolCore strFromTimeStr:startT format:@"yyyy-MM-dd"] isEqualToString:@"0001-01-01"] &&
       ![[ToolCore strFromTimeStr:endT format:@"yyyy-MM-dd"] isEqualToString:@"0001-01-01"]){
        endT = [ToolCore strFromTimeStr2:[NSDate date] format:@"yyyy-MM-dd"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *destDateString = [dateFormatter stringFromDate:[NSDate date]];
        
        NSDictionary *dicHistory = @{@"uid": [NSNumber numberWithInteger:[GlobalValue sharedInstance].sid],
                                     @"page": [NSNumber numberWithInteger:self.historyIndex],
                                     @"size": @HISTORY_PAGE_SIZE,
                                     @"flag":@1,
                                     @"startdate":@"2015-01-01",
                                     @"enddate":destDateString
                                     };
        
        [NetWork postDataWithServer:@"http://121.41.36.129:8092/ajaxhandler/inter.ashx" sendDic:dicHistory kind:HttpRequstLoadingNone tips:@"" target:self userInfo:nil callback:^(NSDictionary *dic){
            NSLog(@"resultDic %@", dic);
            NSMutableArray *list = [dic objectForKey:@"data"];
            tableView.footer.hidden = [list count] < HISTORY_PAGE_SIZE;
            if (index > 1) {
                [tableView.footer endRefreshing];
                if (tableView == self.historyTabelView) {
                    [self.arrayHistory addObjectsFromArray:list];
                }
            }else{
                if (tableView == self.historyTabelView) {
                    self.arrayHistory = list;
                }
                [tableView.header endRefreshing];
                self.arrayHistory.count == 0? [self showEmtiyFlageInView:tableView]:[self hidenEmtiyFlageInView:tableView];
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
    
    [tableView.header endRefreshing];
    [self showEmtiyFlageInView:tableView];
    
}


#pragma mark TTPageView datasource delegate;
-(NSInteger)numberOfCountInPageView:(TTPageView*)pageView{
    return self.titleList.count;
}
-(void)TTPageView:(TTPageView*)pageView initTopTabView:(TTPageTopTabView*)topTabView atIndex:(NSInteger)index{
    topTabView.titleLabel.text = [self.titleList objectAtIndex:index];
}
-(UIView*)contentViewForPageView:(TTPageView*)pageView atIndex:(NSInteger)index{
    return self.viewList[index];
}


#pragma mark tableview datasource & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.positionTabelView == tableView) {
        return self.arrayPosition.count;
    }else  if (self.historyTabelView == tableView){
        return self.arrayHistory.count;
    }else  if (self.hangTabelView == tableView){
        return self.arrayHolder.count;
    }
    else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.positionTabelView == tableView) {
        PositionItemCell* contentCell = (PositionItemCell*)[tableView dequeueReusableCellWithIdentifier:@"PositionItemCell"];
        NSDictionary *dic = self.arrayPosition[indexPath.row];
        [contentCell refreshUIByTrade:dic];
        contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return contentCell;
    }else  if (self.historyTabelView == tableView){
        HistoryTradeItemCell* contentCell = (HistoryTradeItemCell*)[tableView dequeueReusableCellWithIdentifier:@"HistoryTradeItemCell"];
        NSDictionary *dic = self.arrayHistory[indexPath.row];
        [contentCell refreshUI:dic];
        contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return contentCell;
    }else  if (self.hangTabelView == tableView){
        HangTradeItemCell* contentCell = (HangTradeItemCell*)[tableView dequeueReusableCellWithIdentifier:@"HangTradeItemCell"];
        NSDictionary *dic = self.arrayHolder[indexPath.row];
        contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [contentCell refreshUI:dic];
        return contentCell;
    }
    else{
        return nil;
    }
   }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[self performSegueWithIdentifier:@"GotoStockDetail" sender:nil];
}
- (IBAction)newTradeAction:(id)sender {
    [self performSegueWithIdentifier:@"GotoNewTrade" sender:nil];
}
@end
