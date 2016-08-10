//
//  StockDetailViewController.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/16.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "StockDetailViewController.h"
#import "TTPageView.h"
#import "NirKxMenu.h"
#import "getData.h"
#import "YKLineChartView.h"
#import "YKLineEntity.h"
#import "YKLineDataSet.h"
#import "FivePriceView.h"
#import "CGraphClientSocket.h"
#import "CTradeClientSocket.h"
#import "GraphResponse.h"
#import "DBFileManager.h"
#import "NetWorkManager.h"
#import "YKTimeLineView.h"

@interface StockDetailViewController ()<TTPageViewSource, TTPageViewDelegate,YKLineChartViewDelegate>{
    BOOL isAdded;
}
@property (weak, nonatomic) IBOutlet UIView *vBaseInfo;
@property (weak, nonatomic) IBOutlet UIView *vBaseInfoLandscape;

@property (weak, nonatomic) IBOutlet UIView *vPriceInfo;
@property (weak, nonatomic) IBOutlet UIView *vMenuShowView;
@property (weak, nonatomic) IBOutlet YKLineChartView *klineView;
@property (weak, nonatomic) IBOutlet YKLineChartView *klineViewLandscape;
@property (weak, nonatomic) IBOutlet YKTimeLineView *kTimeView;
@property (weak, nonatomic) IBOutlet YKTimeLineView *kTimeViewLandscape;

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UILabel *lblStockTitleLandscape;
@property (weak, nonatomic) IBOutlet UILabel *lblStockSubTitleLandscape;


@property (weak, nonatomic) IBOutlet UILabel *lblCurentPriceLandscape; //当前价
@property (weak, nonatomic) IBOutlet UILabel *lblChgPriceLandscape; //涨跌价
@property (weak, nonatomic) IBOutlet UILabel *lblChg0Landscape; //涨跌幅
@property (weak, nonatomic) IBOutlet UILabel *lblHighestLandscape;
@property (weak, nonatomic) IBOutlet UILabel *lblLowestLandscape;
@property (weak, nonatomic) IBOutlet UILabel *lblChg1Landscape;
@property (weak, nonatomic) IBOutlet UILabel *lblTodayPriceLandscape;
@property (weak, nonatomic) IBOutlet UILabel *lblYestodayPriceLandscape;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalHandsLandscape;

@property (weak, nonatomic) IBOutlet UILabel *lblCurentPrice; //当前价
@property (weak, nonatomic) IBOutlet UILabel *lblChgPrice; //涨跌价
@property (weak, nonatomic) IBOutlet UILabel *lblChg0; //涨跌幅
@property (weak, nonatomic) IBOutlet UILabel *lblHighest;
@property (weak, nonatomic) IBOutlet UILabel *lblLowest;
@property (weak, nonatomic) IBOutlet UILabel *lblChg1;
@property (weak, nonatomic) IBOutlet UILabel *lblTodayPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblYestodayPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalHands;
@property (weak, nonatomic) IBOutlet UILabel *lblBuyPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblSellPrice;
@property (weak, nonatomic) IBOutlet TTPageView *pageView;
@property (weak, nonatomic) IBOutlet TTPageView *pageViewLandscape;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

@property (weak, nonatomic) TTPageTopTabView *topTab;
@property (weak, nonatomic) IBOutlet FivePriceView *fivePriceView;
@property (nonatomic, strong) NSArray *titleList;
@property (nonatomic, strong) NSArray *titleListLandscape;
@property (nonatomic, strong) NSMutableArray *menueItems; //菜单选择状态;
@property (weak, nonatomic) IBOutlet UIView *vLandscape;
@property (nonatomic, strong) CGraphClientSocket *gpSocket;

@property (nonatomic, strong)  DBFileManager *kLineMnger;
@property (nonatomic, strong)  MerpList_Obj *merpObj;
@property (nonatomic, strong) MBProgressHUD *progressView;

@end

@implementation StockDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.pageView.dataSource = self;
    self.pageView.delegate = self;
    self.pageViewLandscape.dataSource = self;
    self.pageViewLandscape.delegate = self;
    self.titleList = @[@"分时",@"日K",@"周K",@"月K",@"1分"];
    self.titleListLandscape = @[@"分时",@"日K",@"周K",@"月K",@"1分",@"5分",@"15分",@"30分",@"60分"];

    self.menueItems = [NSMutableArray array];
    for (int i=0;i< 5; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        switch (i) {
            case 0:
                dic[@"title"] = @"1分";
                break;
            case 1:
                dic[@"title"] = @"5分";
                break;
            case 2:
                dic[@"title"] = @"15分";
                break;
            case 3:
                dic[@"title"] = @"30分";
                break;
            case 4:
                dic[@"title"] = @"60分";
                break;
            default:
                break;
        }
        dic[@"selected"] = i==0?@(YES):@(NO);
        [self.menueItems addObject:dic];
    }
    self.vLandscape.frame =  CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
    
    [self menueShow:NO];
    [self initKLinViewStyle:self.klineViewLandscape];
    [self initKLinViewStyle:self.klineView];
    //[self get600570StockInfo:0];
    
}



-(void)configureWithData:(id)data{
    if (data) {
       // Mer
        MerpList_Obj *obj = data[@"mpInfo"];
        self.title = obj.strMpname;
        self.lblStockTitleLandscape.text = obj.strMpname;
        self.lblStockSubTitleLandscape.text = obj.strMpcode;
        self.merpObj = obj;
        marketIndex_Obj *market = [[CTradeClientSocket sharedInstance] marketIndexByMpIndex:[@(obj.nIndex) stringValue]];
        self.kLineMnger = [[DBFileManager alloc] initWithMarketId:market.strMarketID andMpCode:obj.strMpcode];
        [self updatePrice:obj.priceObJ];
        
        if ([[GlobalValue sharedInstance] ifZXWithMpId:[@(self.merpObj.nIndex) stringValue]]) {
            isAdded = YES;
            [_btnAdd setImage:[UIImage imageNamed:@"ZXcancel"] forState:UIControlStateNormal];
        }else{
            isAdded = NO;
        }
        NSMutableSet *set = [NSMutableSet set]; //商品
        [set addObject:@(obj.nIndex)];
        [[CTradeClientSocket sharedInstance] updateMarketInfoWithMpIndexs:set];

    }
}
-(void)initKLinViewStyle:(YKLineChartView*)klineView{
    [klineView setupChartOffsetWithLeft:50 top:10 right:10 bottom:10];
    klineView.gridBackgroundColor = [UIColor whiteColor];
    klineView.borderColor = [UIColor colorWithRed:203/255.0 green:215/255.0 blue:224/255.0 alpha:1.0];
    klineView.borderWidth = .5;
    klineView.candleWidth = 8;
    klineView.candleMaxWidth = 30;
    klineView.candleMinWidth = 1;
    klineView.uperChartHeightScale = 0.7;
    klineView.xAxisHeitht = 25;
    klineView.delegate = self;
    klineView.highlightLineShowEnabled = YES;
    klineView.zoomEnabled = YES;
    klineView.scrollEnabled = YES;
    klineView.isShowAvgMarkerEnabled = YES;
}

-(void)updateUIWithType:(NSInteger)type{
    if (type==0) {
        //界面设置红色
        self.vBaseInfo.backgroundColor = [UIColor YColorRed];
        self.vBaseInfoLandscape.backgroundColor = [UIColor YColorRed];
    }else{
        self.vBaseInfo.backgroundColor = [UIColor YColorGreen];
        self.vBaseInfoLandscape.backgroundColor = [UIColor YColorGreen];

    }
}

-(void)get600570StockInfo:(NSInteger) type{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        getData *getdata = [[getData alloc] init];
        getdata.kCount = 100;
        getdata.req_type = @"d";
        getdata = [getdata initWithUrl:[self changeUrl]];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray * array = [NSMutableArray array];
            for (NSDictionary * dic in getdata.data) {
                YKLineEntity * entity = [[YKLineEntity alloc]init];
                entity.high = [dic[@"High"] doubleValue];
                entity.open = [dic[@"Open"] doubleValue];
                entity.low = [dic[@"Low"] doubleValue];
                entity.close = [dic[@"Close"] doubleValue];
                entity.date = dic[@"Date"];
                entity.ma5 = [dic[@"MA5"] doubleValue];
                entity.ma10 = [dic[@"MA10"] doubleValue];
                entity.ma20 = [dic[@"MA20"] doubleValue];
                entity.volume = [dic[@"Volume"] doubleValue];
                [array addObject:entity];
                //YTimeLineEntity * entity = [[YTimeLineEntity alloc]init];
            }
            //    [array addObjectsFromArray:array];
            NSLog(@"获取的证券信息%lu条", (unsigned long)array.count);
            YKLineDataSet * dataset = [[YKLineDataSet alloc]init];
            dataset.data = array;
            dataset.highlightLineColor = [UIColor colorWithRed:60/255.0 green:76/255.0 blue:109/255.0 alpha:1.0];
            dataset.highlightLineWidth = 0.7;
            dataset.candleRiseColor = [UIColor colorWithRed:233/255.0 green:47/255.0 blue:68/255.0 alpha:1.0];
            dataset.candleFallColor = [UIColor colorWithRed:33/255.0 green:179/255.0 blue:77/255.0 alpha:1.0];
            dataset.avgLineWidth = 1.f;
            dataset.avgMA10Color = [UIColor colorWithRed:252/255.0 green:85/255.0 blue:198/255.0 alpha:1.0];
            dataset.avgMA5Color = [UIColor colorWithRed:67/255.0 green:85/255.0 blue:109/255.0 alpha:1.0];
            dataset.avgMA20Color = [UIColor colorWithRed:216/255.0 green:192/255.0 blue:44/255.0 alpha:1.0];
            dataset.candleTopBottmLineWidth = 1;
            
            
            [self.klineView setupData:dataset];
            [self.klineViewLandscape setupData:dataset];

        });

    });
    
    
}
SOCKET_PROTOCOL(NewPrice){
    [self updatePrice:response];
}
//K线图数据
SOCKET_PROTOCOL(KGraph){
    NSLog(@"收到K线图数据");
    GraphResponse *graphData = response;
    NSLog(@"K线图数据 (%lu)条", (unsigned long)graphData.arrayGraphDate_Obj.count);
    NSMutableArray * array = [NSMutableArray array];
    for (FenBi7005Data_Obj * data in graphData.arrayGraphDate_Obj) {
        YKLineEntity * entity = [[YKLineEntity alloc]init];
        entity.high = [data.strHighestPrice doubleValue];
        entity.open = [data.strOpenPrice doubleValue];
        entity.low = [data.strLowestPrice doubleValue];
        entity.close = [data.strClosePrice doubleValue];
        entity.date =  [ToolCore strFromTimeStr2:data.strTime format:@"yyyy-MM-dd"] ;
        entity.ma5 = data.MA5;
        entity.ma10 = data.MA10;
        entity.ma20 = data.MA20;
        entity.volume = [data.strVolume doubleValue];
        [array addObject:entity];
        //YTimeLineEntity * entity = [[YTimeLineEntity alloc]init];
    }
    //    [array addObjectsFromArray:array];
    NSLog(@"获取的证券信息%lu条", (unsigned long)array.count);
    YKLineDataSet * dataset = [[YKLineDataSet alloc]init];
    dataset.data = array;
    dataset.highlightLineColor = [UIColor colorWithRed:60/255.0 green:76/255.0 blue:109/255.0 alpha:1.0];
    dataset.highlightLineWidth = 0.7;
    dataset.candleRiseColor = [UIColor colorWithRed:233/255.0 green:47/255.0 blue:68/255.0 alpha:1.0];
    dataset.candleFallColor = [UIColor colorWithRed:33/255.0 green:179/255.0 blue:77/255.0 alpha:1.0];
    dataset.avgLineWidth = 1.f;
    dataset.avgMA10Color = [UIColor colorWithRed:252/255.0 green:85/255.0 blue:198/255.0 alpha:1.0];
    dataset.avgMA5Color = [UIColor colorWithRed:67/255.0 green:85/255.0 blue:109/255.0 alpha:1.0];
    dataset.avgMA20Color = [UIColor colorWithRed:216/255.0 green:192/255.0 blue:44/255.0 alpha:1.0];
    dataset.candleTopBottmLineWidth = 1;
    
    
    [self.klineView setupData:dataset];
    [self.klineViewLandscape setupData:dataset];
    [self.progressView hide:YES];
}


-(void)updateTimeData:(GraphResponse *)graphData timeView:(YKTimeLineView*)timeView{
    NSLog(@"分时图数据 (%lu)条", (unsigned long)graphData.arrayGraphDate_Obj.count);
    NSMutableArray * timeArray = [NSMutableArray array];
    for (int i = 0;i < graphData.arrayGraphDate_Obj.count;i++) {
        TimeShare_Obj * obj = graphData.arrayGraphDate_Obj[i];
        YKTimeLineEntity * e = [[YKTimeLineEntity alloc]init];
        e.currtTime = obj.strTime;
        //e.preClosePx = [dic[@"pre_close_px"] doubleValue];
        if (i > 0) {
            TimeShare_Obj * obj =  graphData.arrayGraphDate_Obj[i-1];
            e.preClosePx = [obj.strNowPrice doubleValue];
        }else{
            e.preClosePx = 0;
        }
        e.avgPirce = [obj.strAvgPrice doubleValue];
        e.lastPirce =[obj.strNowPrice doubleValue];
        e.volume = [obj.strAllTranNum doubleValue];
        // e.rate = dic[@"rise_and_fall_rate"];
        [timeArray addObject:e];
    }
    
    [timeView setupChartOffsetWithLeft:50 top:10 right:10 bottom:10];
    timeView.gridBackgroundColor = [UIColor whiteColor];
    timeView.borderColor = [UIColor colorWithRed:203/255.0 green:215/255.0 blue:224/255.0 alpha:1.0];
    timeView.borderWidth = .5;
    timeView.uperChartHeightScale = 0.7;
    timeView.xAxisHeitht = 25;
    timeView.countOfTimes = 242;
    timeView.endPointShowEnabled = YES;
    
    YKTimeDataset * set  = [[YKTimeDataset alloc]init];
    set.data = timeArray;
    set.avgLineCorlor = [UIColor colorWithRed:253/255.0 green:179/255.0 blue:8/255.0 alpha:1.0];
    set.priceLineCorlor = [UIColor colorWithRed:24/255.0 green:96/255.0 blue:254/255.0 alpha:1.0];
    set.lineWidth = 1.f;
    set.highlightLineWidth = .8f;
    set.highlightLineColor = [UIColor colorWithRed:60/255.0 green:76/255.0 blue:109/255.0 alpha:1.0];
    
    set.volumeTieColor = [UIColor grayColor];
    set.volumeRiseColor = [UIColor colorWithRed:233/255.0 green:47/255.0 blue:68/255.0 alpha:1.0];
    set.volumeFallColor = [UIColor colorWithRed:33/255.0 green:179/255.0 blue:77/255.0 alpha:1.0];
    
    set.fillStartColor = [UIColor colorWithRed:24/255.0 green:96/255.0 blue:254/255.0 alpha:1.0];
    set.fillStopColor = [UIColor whiteColor];
    set.fillAlpha = .5f;
    set.drawFilledEnabled = YES;
    timeView.delegate = self;
    timeView.highlightLineShowEnabled = YES;
    [timeView setupData:set];

}
//分时图数据返回
SOCKET_PROTOCOL(TimeShareGraph){
    [self updateTimeData:response timeView:self.kTimeView];
    [self updateTimeData:response timeView:self.kTimeViewLandscape];
    [self.progressView hide:YES];

}

-(NSString*)formatTitle:(NSString*)title text:(NSString*)text{
    return [NSString stringWithFormat:@"%@%@", title, text];
}
-(void)updatePrice:(PriceData_Obj *) objPriceData{
    if (objPriceData) {
        
        self.lblCurentPrice.text = [[NetWorkManager sharedInstance] getFormatValue:objPriceData.fLatestPrice merplist_obj:self.merpObj];
        self.lblCurentPriceLandscape.text = [[NetWorkManager sharedInstance] getFormatValue:objPriceData.fLatestPrice merplist_obj:self.merpObj];

        self.lblHighest.text = [self formatTitle:@"最高" text:[[NetWorkManager sharedInstance] getFormatValue:objPriceData.fHighestPrice merplist_obj:self.merpObj]];
        self.lblHighestLandscape.text = [self formatTitle:@"最高" text:[[NetWorkManager sharedInstance] getFormatValue:objPriceData.fHighestPrice merplist_obj:self.merpObj]];

        self.lblLowest.text =  [self formatTitle:@"最低" text:[[NetWorkManager sharedInstance] getFormatValue:objPriceData.fLowestPrice merplist_obj:self.merpObj]];
        self.lblLowestLandscape.text =  [self formatTitle:@"最低" text:[[NetWorkManager sharedInstance] getFormatValue:objPriceData.fLowestPrice merplist_obj:self.merpObj]];

        
        self.lblTodayPrice.text = [self formatTitle:@"今开" text:[[NetWorkManager sharedInstance] getFormatValue:objPriceData.fOpenPrice merplist_obj:self.merpObj]];
        self.lblTodayPriceLandscape.text = [self formatTitle:@"今开" text:[[NetWorkManager sharedInstance] getFormatValue:objPriceData.fOpenPrice merplist_obj:self.merpObj]];

        self.lblYestodayPrice.text = [self formatTitle:@"昨收" text:[[NetWorkManager sharedInstance] getFormatValue:objPriceData.fClosePrice merplist_obj:self.merpObj]];
        self.lblYestodayPriceLandscape.text = [self formatTitle:@"昨收" text:[[NetWorkManager sharedInstance] getFormatValue:objPriceData.fClosePrice merplist_obj:self.merpObj]];

        self.lblBuyPrice.text = [[NetWorkManager sharedInstance] getFormatValue:objPriceData.fBuyPrice1 merplist_obj:self.merpObj];
        self.lblSellPrice.text = [[NetWorkManager sharedInstance] getFormatValue:objPriceData.fLatestPrice merplist_obj:self.merpObj];
        self.lblTotalHands.text = [self formatTitle:@"总手" text:[NSString stringWithFormat:@"%.0f",objPriceData.fAmount]];
        self.lblTotalHandsLandscape.text = [self formatTitle:@"总手" text:[NSString stringWithFormat:@"%.0f",objPriceData.fAmount]];
        if (objPriceData.fChgPrice > 0) {
            self.lblChgPrice.text = [NSString stringWithFormat:@"+%.1f",objPriceData.fChgPrice];
            self.lblChgPriceLandscape.text = [NSString stringWithFormat:@"+%.1f",objPriceData.fChgPrice];
            self.lblChg0.text = [NSString stringWithFormat:@"+%.2f%%",objPriceData.fChg*100];
            self.lblChg0Landscape.text = [NSString stringWithFormat:@"+%.2f%%",objPriceData.fChg*100];
            self.lblChg1.text = [self formatTitle:@"振幅" text:[NSString stringWithFormat:@"+%.2f%%",objPriceData.fChg*100]];
            self.lblChg1Landscape.text = [self formatTitle:@"振幅" text:[NSString stringWithFormat:@"+%.2f%%",objPriceData.fChg*100]];
            [self updateUIWithType:0];
        }else{
            self.lblChgPrice.text = [NSString stringWithFormat:@"%.1f",objPriceData.fChgPrice];
            self.lblChgPriceLandscape.text = [NSString stringWithFormat:@"%.1f",objPriceData.fChgPrice];
            self.lblChg0.text = [NSString stringWithFormat:@"%.2f%%",objPriceData.fChg*100];
            self.lblChg0Landscape.text = [NSString stringWithFormat:@"%.2f%%",objPriceData.fChg*100];
            self.lblChg1.text = [self formatTitle:@"振幅" text:[NSString stringWithFormat:@"%.2f%%",objPriceData.fChg*100]];
            self.lblChg1Landscape.text = [self formatTitle:@"振幅" text:[NSString stringWithFormat:@"%.2f%%",objPriceData.fChg*100]];
            [self updateUIWithType:1];
        }
        
        self.fivePriceView.lblBuy1Price.text = [[NetWorkManager sharedInstance] getFormatValue:objPriceData.fBuyPrice1 merplist_obj:self.merpObj];
        self.fivePriceView.lblBuy1Hands.text = [NSString stringWithFormat:@"%.0f",objPriceData.fBuyVolume1];
        self.fivePriceView.lblBuy2Price.text = [[NetWorkManager sharedInstance] getFormatValue:objPriceData.fBuyPrice2 merplist_obj:self.merpObj];
        self.fivePriceView.lblBuy2Hands.text = [NSString stringWithFormat:@"%.0f",objPriceData.fBuyVolume2];
        self.fivePriceView.lblBuy3Price.text = [[NetWorkManager sharedInstance] getFormatValue:objPriceData.fBuyPrice3 merplist_obj:self.merpObj];
        self.fivePriceView.lblBuy3Hands.text = [NSString stringWithFormat:@"%.0f",objPriceData.fBuyVolume3];
        self.fivePriceView.lblBuy4Price.text = [[NetWorkManager sharedInstance] getFormatValue:objPriceData.fBuyPrice4 merplist_obj:self.merpObj];
        self.fivePriceView.lblBuy4Hands.text = [NSString stringWithFormat:@"%.0f",objPriceData.fBuyVolume4];
        self.fivePriceView.lblBuy5Price.text = [[NetWorkManager sharedInstance] getFormatValue:objPriceData.fBuyPrice5 merplist_obj:self.merpObj];
        self.fivePriceView.lblBuy5Hands.text = [NSString stringWithFormat:@"%.0f",objPriceData.fBuyVolume5];
        
        self.fivePriceView.lblSell1Price.text = [[NetWorkManager sharedInstance] getFormatValue:objPriceData.fSellPrice1 merplist_obj:self.merpObj];
        self.fivePriceView.lblSell1Hands.text = [NSString stringWithFormat:@"%.0f",objPriceData.fSellVolume1];
        self.fivePriceView.lblSell2Price.text = [[NetWorkManager sharedInstance] getFormatValue:objPriceData.fSellPrice2 merplist_obj:self.merpObj];
        self.fivePriceView.lblSell2Hands.text = [NSString stringWithFormat:@"%.0f",objPriceData.fSellVolume2];
        self.fivePriceView.lblSell3Price.text = [[NetWorkManager sharedInstance] getFormatValue:objPriceData.fSellPrice3 merplist_obj:self.merpObj];
        self.fivePriceView.lblSell3Hands.text = [NSString stringWithFormat:@"%.0f",objPriceData.fSellVolume3];
        self.fivePriceView.lblSell4Price.text = [[NetWorkManager sharedInstance] getFormatValue:objPriceData.fSellPrice4 merplist_obj:self.merpObj];
        self.fivePriceView.lblSell4Hands.text = [NSString stringWithFormat:@"%.0f",objPriceData.fSellVolume4];
        self.fivePriceView.lblSell5Price.text = [[NetWorkManager sharedInstance] getFormatValue:objPriceData.fSellPrice5 merplist_obj:self.merpObj];
        self.fivePriceView.lblSell5Hands.text = [NSString stringWithFormat:@"%.0f",objPriceData.fSellVolume5];

        [self.fivePriceView setTextColor:objPriceData.fChgPrice > 0?[UIColor YColorRed]:objPriceData.fChgPrice <0?[UIColor YColorGreen]:[UIColor YColorBlack]];
     
        
    }
}
#pragma mark 返回组装好的网址
-(NSString*)changeUrl{
    NSString *url = [[NSString alloc] initWithFormat:@"http://ichart.yahoo.com/table.csv?s=%@&g=%@",@"600570.SS",@"d"];
    return url;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getKGraphByGraphType:(NSString *)strGraphType{
    [self.progressView hide:YES];
    self.progressView = [TToast showProcess:@"正在获取K线图数据" inView:self.view];
    [self.kLineMnger getKLineDataByGraphType:strGraphType];
    
}
-(void)selectMenu:(NSInteger)index{
    for (int i=0; i<self.menueItems.count; i++) {
        NSMutableDictionary *dic = [self.menueItems objectAtIndex:i];
        if (i == index) {
            dic[@"selected"] = @YES;
        }else{
            dic[@"selected"] = @NO;
        }
    }
    self.topTab.titleLabel.text = self.menueItems[index][@"title"];
    NSString *gType = [self getGraphTypeByString:self.menueItems[index][@"title"]];
    NSLog(@"获取 %@ 数据",gType);
    [self getKGraphByGraphType:gType];

    [self.menuTableView reloadData];
}
-(void)menueShow:(BOOL)show{
    if (show) {
        
        self.vMenuShowView.hidden = NO;
        
    }else{
        self.vMenuShowView.hidden = YES;
    }
    
    
}

-(void)menueItemTouched:(id)item{
    
}
#pragma mark TTPageView datasource delegate;
-(NSInteger)numberOfCountInPageView:(TTPageView*)pageView{
    if (pageView == self.pageView) {
        return self.titleList.count;
    }else{
        return self.titleListLandscape.count;
    }
}
-(void)TTPageView:(TTPageView*)pageView initTopTabView:(TTPageTopTabView*)topTabView atIndex:(NSInteger)index{
    
    if (pageView == self.pageView) {

        topTabView.titleLabel.text = [self.titleList objectAtIndex:index];
        //
        if (index == 4) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowSingleDown"]];
            imageView.frame = CGRectMake(topTabView.frame.size.width - 15, topTabView.center.y-5, 10, 10);
            [topTabView addSubview:imageView];
            topTabView.multiSelect = YES;
            self.topTab = topTabView;
        }
    }else{
        topTabView.titleLabel.text = [self.titleListLandscape objectAtIndex:index];

    }
}

-(NSString*)getGraphTypeByString:(NSString*)str{
    if ([str isEqualToString:@"1分"]) {
        return @"M1";
    }else if ([str isEqualToString:@"5分"]) {
        return @"M5";
    }else if ([str isEqualToString:@"15分"]) {
        return @"M15";
    }else if ([str isEqualToString:@"30分"]) {
        return @"M30";
    }else if ([str isEqualToString:@"60分"]) {
        return @"H1";
    }else if ([str isEqualToString:@"周K"]) {
        return @"W1";
    }else if ([str isEqualToString:@"月K"]) {
        return @"MN";
    }else{
        return @"D1";
    }
}
-(void)TTPageView:(TTPageView*)pageView didSelectAtIndex:(NSInteger)index topTabView:(TTPageTopTabView*)topTabView{
    if (pageView == self.pageView) {
        
        self.klineView.hidden = NO;
        self.kTimeView.hidden = YES;
        [self menueShow:NO];
        if (index == 0){
            //分时图
            self.klineView.hidden = YES;
            self.kTimeView.hidden = NO;
            [self.progressView hide:YES];
            self.progressView = [TToast showProcess:@"正在获取分时图数据" inView:self.view];
            [self.kLineMnger getTimeLineData];

        }else if (index == 4) {
            
            NSString *gType = [self getGraphTypeByString:topTabView.titleLabel.text];
            NSLog(@"获取 %@ 数据",gType);
            [self getKGraphByGraphType:gType];
            if (topTabView.tag == 0) {
                topTabView.tag = 1;
            }else{
                topTabView.tag =0;
            }
            [self menueShow:topTabView.tag==1];
        }
        
        switch (index) {
            case 1:
                [self getKGraphByGraphType:@"D1"];
                break;
            case 2:
                [self getKGraphByGraphType:@"W1"];
                break;
            case 3:
                [self getKGraphByGraphType:@"MN"];
                break;
            default:
                break;
        }

    }else{
        self.klineViewLandscape.hidden = NO;
        self.kTimeViewLandscape.hidden = YES;
        if (index == 0){
            //分时图
            self.klineViewLandscape.hidden = YES;
            self.kTimeViewLandscape.hidden = NO;
            [self.progressView hide:YES];
            self.progressView = [TToast showProcess:@"正在获取分时图数据" inView:self.view];
            [self.kLineMnger getTimeLineData];

        }else{
            NSString *gType = [self getGraphTypeByString:topTabView.titleLabel.text];
            NSLog(@"获取 %@ 数据",gType);
            [self getKGraphByGraphType:gType];
        }
    }
    
}


#pragma mark tableview datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menueItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* contentCell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"MenuItem"];
    UILabel *lblTitle = [contentCell viewWithTag:1];
    lblTitle.text = [self.menueItems objectAtIndex:indexPath.row][@"title"];
    lblTitle.textColor = [[self.menueItems objectAtIndex:indexPath.row][@"selected"] boolValue]?[UIColor YColorBlue]:[UIColor YColorGray];
    return contentCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self selectMenu:indexPath.row];
}

- (IBAction)buyAction:(id)sender {
    
    UIViewController *newTrade = [[UIStoryboard storyboardWithName:@"Trade" bundle:nil] instantiateViewControllerWithIdentifier:@"NewTradeCtr"];
    UIStoryboardSegue *gotoTrade =  [UIStoryboardSegue segueWithIdentifier:@"GotoNewTrade" source:self destination:newTrade performHandler:^{
        [self.navigationController pushViewController:newTrade animated:YES];
    }];
    [self prepareForSegue:gotoTrade sender:self.merpObj];
    [gotoTrade perform];
}

- (IBAction)sellAction:(id)sender {
    UIViewController *newTrade = [[UIStoryboard storyboardWithName:@"Trade" bundle:nil] instantiateViewControllerWithIdentifier:@"NewTradeCtr"];
    UIStoryboardSegue *gotoTrade =  [UIStoryboardSegue segueWithIdentifier:@"GotoNewTrade" source:self destination:newTrade performHandler:^{
        [self.navigationController pushViewController:newTrade animated:YES];
    }];
    [self prepareForSegue:gotoTrade sender:self.merpObj];
    [gotoTrade perform];

}
- (IBAction)addCustomAction:(id)sender {
    if (isAdded) {
        [[GlobalValue sharedInstance] removeZxWithMpId:[NSString stringWithFormat:@"%ld", (long)self.merpObj.nIndex]];
        [TToast showToast:@"删除自选成功" afterDelay:1.0f];
        isAdded = NO;
        [_btnAdd setImage:[UIImage imageNamed:@"ic_add_select"] forState:UIControlStateNormal];
    }else{
        [[GlobalValue sharedInstance] addZxWithMpId:[@(self.merpObj.nIndex) stringValue]];
        [TToast showToast:@"添加自选成功" afterDelay:1.0f];
        isAdded = YES;
        [_btnAdd setImage:[UIImage imageNamed:@"ZXcancel"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)refreshAction:(id)sender {
}
// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

// 支持横竖屏显示

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.vLandscape removeFromSuperview];
    }
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.view addSubview:self.vLandscape];
    }
}




@end
