//
//  NewTradeViewController.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/18.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "NewTradeViewController.h"
#import "FivePriceView.h"
#import "TTPageView.h"
#import "UnderlineView.h"
#import "CGT6ClientSocket.h"
#import "AddOrderResponse.h"
#import "TradeConfirmView.h"
#import "MyPopBox.h"
@interface NewTradeViewController ()<TTPageViewSource, TTPageViewDelegate,TradeConfirmViewDelegate>{
    BOOL bHangeSell;
}
@property (weak, nonatomic) IBOutlet UILabel *lblHintTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAvailabelBalance;
@property (weak, nonatomic) IBOutlet UILabel *lblCurentPrice; //当前价
@property (weak, nonatomic) IBOutlet UILabel *lblChg0; //涨跌幅
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblStockName;
@property (weak, nonatomic) IBOutlet UILabel *lblShopPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblShopAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblHangPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblHangAmount;
@property (weak, nonatomic) IBOutlet FivePriceView *fivePriceView;
@property (weak, nonatomic) IBOutlet TTPageView *pageView;
@property (strong, nonatomic) IBOutlet UIView *pageIndexView1;
@property (strong, nonatomic) IBOutlet UIView *pageIndexView2;
@property (weak, nonatomic) IBOutlet UnderlineView *vPriceInfoFrameView;

@property (weak, nonatomic) IBOutlet UIButton *btnShopBuy;
@property (weak, nonatomic) IBOutlet UIButton *btnShopSale;

@property (nonatomic, strong) NSArray *titleList;
@property (weak, nonatomic) IBOutlet UIButton *btnShopCutPirce;

@property (weak, nonatomic) IBOutlet UIButton *btnShopAddPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnShopCutAmount;
@property (weak, nonatomic) IBOutlet UIButton *btnShopAddAmount;
@property (weak, nonatomic) IBOutlet UIButton *btnHangCutPirce;

@property (weak, nonatomic) IBOutlet UIButton *btnHangAddPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnHangCutAmount;
@property (weak, nonatomic) IBOutlet UIButton *btnHangAddAmount;

@property (weak, nonatomic) IBOutlet UILabel *lblHangBuyPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblHangSalePrice;
@property (weak, nonatomic) IBOutlet UIView *vBuyDirection;
@property (weak, nonatomic) IBOutlet UIView *vSaleDirection;
@property (weak, nonatomic) IBOutlet UISwitch *switchPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnHang;
@property (weak, nonatomic) IBOutlet UILabel *lblShopPriceTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblShopAmountTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblHangPriceTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblHangAmountTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblStopLossTitle;
@property (nonatomic, strong)  MerpList_Obj *merpObj;

@property (weak, nonatomic) IBOutlet UILabel *lblDirectionTitle;
@property (nonatomic, strong) MBProgressHUD *progressView;
@property (weak, nonatomic) IBOutlet UnderlineView *vStopTypeViw;
@property (weak, nonatomic) IBOutlet UnderlineView *vStopPoint;
@property (weak, nonatomic) IBOutlet UILabel *lblStopPoint;
@property (weak, nonatomic) IBOutlet UIButton *btnStopPointCut;
@property (weak, nonatomic) IBOutlet UIButton *btnStopPointAdd;
@property (nonatomic, strong)  TradeConfirmView *confirmView;
@property (nonatomic, strong)  MyPopBox *popBox;
@property (nonatomic, strong) NSMutableDictionary * tradeData;
@end

@implementation NewTradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleList = @[@"市场单",@"挂单"];
    self.pageView.delegate = self;
    self.pageView.dataSource = self;
    self.confirmView = [[[NSBundle mainBundle] loadNibNamed:@"TradeConfirmView" owner:self options:nil] objectAtIndex:0];
    self.confirmView.deleate = self;
    self.popBox = [MyPopBox defualPopBox];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark TTPageView datasource delegate;
-(NSInteger)numberOfCountInPageView:(TTPageView*)pageView{
    return self.titleList.count;
}
-(void)TTPageView:(TTPageView*)pageView initTopTabView:(TTPageTopTabView*)topTabView atIndex:(NSInteger)index{
    topTabView.titleLabel.text = [self.titleList objectAtIndex:index];
}
-(UIView*)contentViewForPageView:(TTPageView*)pageView atIndex:(NSInteger)index{
    if (index ==0) {
        return self.pageIndexView1;
    }else{
        return self.pageIndexView2;
    }
    return nil;
}
-(void)configureWithData:(id)data{
    if (data) {
        [self enabelUI];
        self.merpObj = data;
        //获取最新价格
        NSMutableSet *set = [NSMutableSet set]; //商品
        [set addObject:@(self.merpObj.nIndex)];
        [[CTradeClientSocket sharedInstance] updateMarketInfoWithMpIndexs:set];
        [self updatePriceUI];
    }
}

-(void)enabelUI{
    self.lblHintTitle.hidden = YES;
    self.lblChg0.hidden = NO;
    self.lblType.hidden = NO;
    self.lblStockName.hidden = NO;
    self.lblCurentPrice.hidden = NO;
    self.btnShopAddPrice.enabled =YES;
    self.btnShopCutPirce.enabled = YES;
    self.btnShopAddAmount.enabled = YES;
    self.btnShopCutAmount.enabled =YES;
    self.btnShopBuy.enabled =YES;
    [self.btnShopBuy setBackgroundColor:[UIColor YColorRed]];
    self.btnShopSale.enabled = YES;
    [self.btnShopSale setBackgroundColor:[UIColor YColorGreen]];
    self.vPriceInfoFrameView.hidden =NO;
    self.btnHangAddPrice.enabled =YES;
    self.btnHangCutPirce.enabled = YES;
    self.btnHangAddAmount.enabled = YES;
    self.btnHangCutAmount.enabled =YES;
    self.lblHangBuyPrice.hidden = NO;
    self.lblHangSalePrice.hidden = NO;
    self.lblHangSalePrice.textColor = [UIColor YColorGreen];
    self.lblHangBuyPrice.textColor = [UIColor whiteColor];
    self.vBuyDirection.backgroundColor = [UIColor YColorRed];
    self.lblShopPriceTitle.textColor = [UIColor YColorBlack];
    self.lblHangPriceTitle.textColor = [UIColor YColorBlack];
    self.lblShopAmountTitle.textColor = [UIColor YColorBlack];
    self.lblHangPriceTitle.textColor = [UIColor YColorBlack];
    self.lblHangAmountTitle.textColor = [UIColor YColorBlack];
    self.lblDirectionTitle.textColor = [UIColor YColorBlack];
    self.lblStopLossTitle.textColor = [UIColor YColorBlack];
    self.lblStopLossTitle.textColor = [UIColor YColorBlack];

    [self.vBuyDirection addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buyDirectionAction)]];
    
    [self.vSaleDirection addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saleDirectionAction)]];
    self.switchPrice.enabled = YES;
    self.btnHang.enabled = YES;
    self.btnHang.backgroundColor= [UIColor YColorBlue];
    
}
-(void)buyDirectionAction{
    self.vBuyDirection.backgroundColor = [UIColor YColorRed];
    self.vSaleDirection.backgroundColor = [UIColor YColorLineGray];
    self.lblHangSalePrice.textColor = [UIColor YColorGreen];
    self.lblHangBuyPrice.textColor = [UIColor whiteColor];
    self.lblHangPrice.text = [[NetWorkManager sharedInstance] getFormatValue:self.merpObj.priceObJ.fSellPrice1 merplist_obj:self.merpObj];
    bHangeSell = NO;
}
-(void)saleDirectionAction{
    self.vBuyDirection.backgroundColor = [UIColor YColorLineGray];
    self.vSaleDirection.backgroundColor = [UIColor YColorGreen];
    self.lblHangSalePrice.textColor = [UIColor whiteColor];
    self.lblHangBuyPrice.textColor = [UIColor YColorRed];
    self.lblHangPrice.text = [[NetWorkManager sharedInstance] getFormatValue:self.merpObj.priceObJ.fBuyPrice1 merplist_obj:self.merpObj];
    bHangeSell = YES;

}
- (IBAction)hangAction:(id)sender {
    if (!self.merpObj.priceObJ) {
        [TToast showToast:@"无商品行情信息" afterDelay:1.5];
        return;
    }
    if ([self.lblHangAmount.text integerValue] <=0.0001) {
        [TToast showToast:@"请输入正确的数量" afterDelay:1.5];
        return;
    }
    
    NSMutableDictionary * sendData = [NSMutableDictionary dictionary];
    /**
     *  @author LiuK, 16-06-03 13:06:58
     *
     *价格是 当前价格+追价
     
     *   [dicPara setValue:userID forKey:@"UID"];
     [dicPara setValue:mpcode forKey:@"PRODCODE"];
     [dicPara setValue:(isBuy?@"66":@"83") forKey:@"BUYSELL"];
     [dicPara setValue:number forKey:@"QTY"];
     [dicPara setValue:price forKey:@"PRICE"];
     [dicPara setValue:@(type) forKey:@"ORDERTYPE"];
     [dicPara setValue:stopType forKey:@"STOPTYPE"];
     [dicPara setValue:stopPrice forKey:@"STOPLEVEL"];
     
     [dicPara setValue:pid forKey:@"PID"];
     [dicPara setValue:@(1) forKey:@"pltype"];
     */
    double price = [self.lblHangPrice.text doubleValue];

    if (self.switchPrice.on) {
//        price += bHangeSell?-[self.lblStopPoint.text doubleValue]:[self.lblStopPoint.text doubleValue];
        [sendData setValue:@(76) forKey:@"STOPTYPE"];
        [sendData setValue:@(price)forKey:@"STOPLEVEL"];

    }
    [sendData setValue:self.merpObj.strMpcode forKey:@"PRODCODE"];
    [sendData setValue:@([GlobalValue sharedInstance].tradeUID) forKey:@"UID"];
    [sendData setValue:@(!bHangeSell) forKey:@"BUYSELL"];
    [sendData setValue:@([self.lblHangAmount.text integerValue]) forKey:@"QTY"];
    [sendData setValue:@(price) forKey:@"PRICE"];
    [sendData setValue:@(0) forKey:@"ORDERTYPE"];

    self.tradeData = sendData;
    self.confirmView.lblCode.text = self.merpObj.strMpcode;
    self.confirmView.lblType.text = bHangeSell?@"卖出":@"买入";
    self.confirmView.lblPrice.text = [[NetWorkManager sharedInstance] getFormatValue:price merplist_obj:self.merpObj];
    self.confirmView.lblAmount.text = self.lblHangAmount.text;
    self.confirmView.lblDate.text = @"挂单";
    [self.popBox showView:self.confirmView inSuperView:self.view];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSString*)formatTitle:(NSString*)title text:(NSString*)text{
    return [NSString stringWithFormat:@"%@%@", title, text];
}

-(void)updatePriceUI{
    
    if (self.merpObj.priceObJ) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if(bHangeSell){
                self.lblHangPrice.text = [[NetWorkManager sharedInstance] getFormatValue:self.merpObj.priceObJ.fSellPrice1 merplist_obj:self.merpObj];
            }else{
                self.lblHangPrice.text = [[NetWorkManager sharedInstance] getFormatValue:self.merpObj.priceObJ.fBuyPrice1 merplist_obj:self.merpObj];
            }
        });

    }
    
    [self.fivePriceView updateUI:self.merpObj];
    self.lblStockName.text = self.merpObj.strMpname;
    self.lblCurentPrice.text= [[NetWorkManager sharedInstance] getFormatValue:self.merpObj.priceObJ.fBuyPrice1 merplist_obj:self.merpObj];
    self.lblChg0.textColor = [UIColor YColorForPrice:self.merpObj.priceObJ.fChgPrice];
    self.lblChg0.text = [NSString stringWithFormat:@"%.2f%%",self.merpObj.priceObJ.fChg*100];
    if(self.merpObj.priceObJ){
//        [self.btnShopBuy setTitle:[self formatTitle:@"买" text:[[NetWorkManager sharedInstance] getFormatValue:self.merpObj.priceObJ.fSellPrice1 merplist_obj:self.merpObj] ]forState:UIControlStateNormal];
//        [self.btnShopSale setTitle:[self formatTitle:@"卖" text:[[NetWorkManager sharedInstance] getFormatValue:self.merpObj.priceObJ.fBuyPrice1 merplist_obj:self.merpObj]] forState:UIControlStateNormal];
        self.lblHangBuyPrice.text = [[NetWorkManager sharedInstance] getFormatValue:self.merpObj.priceObJ.fSellPrice1 merplist_obj:self.merpObj];
        self.lblHangSalePrice.text = [[NetWorkManager sharedInstance] getFormatValue:self.merpObj.priceObJ.fBuyPrice1 merplist_obj:self.merpObj];
        
    }else{
//        [self.btnShopBuy setTitle:[self formatTitle:@"买" text:@"--"] forState:UIControlStateNormal];
//        
//        [self.btnShopSale setTitle:[self formatTitle:@"卖" text:@"--"] forState:UIControlStateNormal];
    }
    

}
- (IBAction)gotoSelectStockAction:(id)sender {
    [self performSegueWithIdentifier:@"GotoSelectStock" sender:nil completion:^(id data) {
        [self enabelUI];
        self.merpObj = data;
                //获取最新价格
        NSMutableSet *set = [NSMutableSet set]; //商品
        [set addObject:@(self.merpObj.nIndex)];
        [[CTradeClientSocket sharedInstance] updateMarketInfoWithMpIndexs:set];
        [self updatePriceUI];
        
    }];
}
//行情信息刷新, 返回PriceData_Obj信息
SOCKET_PROTOCOL(NewPrice){
    if (self.isApear) {
        [self updatePriceUI];
    }

}
SOCKET_PROTOCOL(GT6AddOrder){
    [self.progressView hide:YES];
    AddOrderResponse *rs = response;
    AddOrderResponseData *data = (AddOrderResponseData*)rs.responseData;
    if (![rs ifSucess]) {
        [ToolCore showAlertViewWithTitle:@"温馨提示" message:data.TP];
    }else{
        [ToolCore showAlertViewWithTitle:@"温馨提示" message:@"下单成功"];

    }
    
}
- (IBAction)shopPriceAction:(UIButton*)sender {
    double price = [self.lblShopPrice.text floatValue];
    if (sender == self.btnShopAddPrice) {
        self.lblShopPrice.text = [[NetWorkManager sharedInstance] getFormatValue:price+self.merpObj.dSetp merplist_obj:self.merpObj];

    }else{
        if(price >0.0000 && (price-self.merpObj.dSetp)>0.00){
            self.lblShopPrice.text =  [[NetWorkManager sharedInstance] getFormatValue:price-self.merpObj.dSetp merplist_obj:self.merpObj];
            
        }
    }
    [self.btnShopBuy setTitle:[self formatTitle:@"买" text:[[NetWorkManager sharedInstance] getFormatValue:self.merpObj.priceObJ.fSellPrice1 + [self.lblShopPrice.text floatValue] merplist_obj:self.merpObj] ]forState:UIControlStateNormal];
    [self.btnShopSale setTitle:[self formatTitle:@"卖" text:[[NetWorkManager sharedInstance] getFormatValue:self.merpObj.priceObJ.fBuyPrice1 - [self.lblShopPrice.text floatValue] merplist_obj:self.merpObj] ]forState:UIControlStateNormal];


}


- (IBAction)shopAmountAction:(UIButton *)sender {
    NSInteger price = [self.lblShopAmount.text integerValue];
    if (sender == self.btnShopAddAmount) {
        self.lblShopAmount.text = [@(price+1) stringValue];
    }else{
        if(price >0){
            self.lblShopAmount.text = [@(price-1) stringValue];
            
        }
    }
}

- (IBAction)shopBuyAction:(id)sender {
    if (!self.merpObj.priceObJ) {
        [TToast showToast:@"无商品行情信息" afterDelay:1.5];
        return;
    }
    if ([self.lblShopAmount.text integerValue] <=0.0001) {
        [TToast showToast:@"请输入正确的数量" afterDelay:1.5];
        return;
    }
    
    NSMutableDictionary * sendData = [NSMutableDictionary dictionary];
    /**
     *  @author LiuK, 16-06-03 13:06:58
     *
     *价格是 当前价格+追价
     
     *   [dicPara setValue:userID forKey:@"UID"];
     [dicPara setValue:mpcode forKey:@"PRODCODE"];
     [dicPara setValue:(isBuy?@"66":@"83") forKey:@"BUYSELL"];
     [dicPara setValue:number forKey:@"QTY"];
     [dicPara setValue:price forKey:@"PRICE"];
     [dicPara setValue:@(type) forKey:@"ORDERTYPE"];
     [dicPara setValue:stopType forKey:@"STOPTYPE"];
     [dicPara setValue:stopPrice forKey:@"STOPLEVEL"];
     
     [dicPara setValue:pid forKey:@"PID"];
     [dicPara setValue:@(1) forKey:@"pltype"];
     */
    double price = self.merpObj.priceObJ.fBuyPrice1 + [self.lblShopPrice.text doubleValue];
    [sendData setValue:self.merpObj.strMpcode forKey:@"PRODCODE"];
    [sendData setValue:@([GlobalValue sharedInstance].tradeUID) forKey:@"UID"];
    [sendData setValue:@(NO) forKey:@"BUYSELL"];
    [sendData setValue:@([self.lblShopAmount.text integerValue]) forKey:@"QTY"];
    [sendData setValue:@(price) forKey:@"PRICE"];
    [sendData setValue:@(1) forKey:@"ORDERTYPE"];
    self.tradeData = sendData;
    self.confirmView.lblCode.text = self.merpObj.strMpcode;
    self.confirmView.lblType.text = @"买入";
    self.confirmView.lblPrice.text = [[NetWorkManager sharedInstance] getFormatValue:price merplist_obj:self.merpObj];
    self.confirmView.lblAmount.text = self.lblShopAmount.text;
    self.confirmView.lblDate.text = @"实时";
    [self.popBox showView:self.confirmView inSuperView:self.view];

//    [sendData setValue:self.merpObj.strMpcode forKey:@"ORDERTYPE"];
//    [sendData setValue:self.merpObj.strMpcode forKey:@"STOPTYPE"];
//    [sendData setValue:self.merpObj.strMpcode forKey:@"STOPLEVEL"];
}
- (IBAction)shopSaleAction:(id)sender {
    if (!self.merpObj.priceObJ) {
        [TToast showToast:@"无商品行情信息" afterDelay:1.5];
        return;
    }
    if ([self.lblShopAmount.text integerValue] <=0.0001) {
        [TToast showToast:@"请输入正确的数量" afterDelay:1.5];
        return;
    }
    
    NSMutableDictionary * sendData = [NSMutableDictionary dictionary];
    /**
     *  @author LiuK, 16-06-03 13:06:58
     *
     *价格是 当前价格+追价*步长单位*精度
     
     *   [dicPara setValue:userID forKey:@"UID"];
     [dicPara setValue:mpcode forKey:@"PRODCODE"];
     [dicPara setValue:(isBuy?@"66":@"83") forKey:@"BUYSELL"];
     [dicPara setValue:number forKey:@"QTY"];
     [dicPara setValue:price forKey:@"PRICE"];
     [dicPara setValue:@(type) forKey:@"ORDERTYPE"];
     [dicPara setValue:stopType forKey:@"STOPTYPE"];
     [dicPara setValue:stopPrice forKey:@"STOPLEVEL"];
     
     [dicPara setValue:pid forKey:@"PID"];
     [dicPara setValue:@(1) forKey:@"pltype"];
     */
    double price = self.merpObj.priceObJ.fSellPrice1 - [self.lblShopPrice.text doubleValue];
    [sendData setValue:self.merpObj.strMpcode forKey:@"PRODCODE"];
    [sendData setValue:@([GlobalValue sharedInstance].tradeUID) forKey:@"UID"];
    [sendData setValue:@(YES) forKey:@"BUYSELL"];
    [sendData setValue:@([self.lblShopAmount.text integerValue]) forKey:@"QTY"];
    [sendData setValue:@(price) forKey:@"PRICE"];
    [sendData setValue:@(1) forKey:@"ORDERTYPE"];

    //    [sendData setValue:self.merpObj.strMpcode forKey:@"ORDERTYPE"];
    //    [sendData setValue:self.merpObj.strMpcode forKey:@"STOPTYPE"];
    //    [sendData setValue:self.merpObj.strMpcode forKey:@"STOPLEVEL"];
    self.tradeData = sendData;
    self.confirmView.lblCode.text = self.merpObj.strMpcode;
    self.confirmView.lblType.text = @"卖出";
    self.confirmView.lblPrice.text = [[NetWorkManager sharedInstance] getFormatValue:price merplist_obj:self.merpObj];
    self.confirmView.lblAmount.text = self.lblShopAmount.text;
    self.confirmView.lblDate.text = @"实时";
    [self.popBox showView:self.confirmView inSuperView:self.view];
}
- (IBAction)hangPriceAction:(UIButton *)sender {
    double price = [self.lblHangPrice.text floatValue];
    if (sender == self.btnHangAddPrice) {
        self.lblHangPrice.text =  [[NetWorkManager sharedInstance] getFormatValue:price+self.merpObj.dSetp merplist_obj:self.merpObj];
    }else{
        if(price >0.0000 && (price-self.merpObj.dSetp)>0.00){
            self.lblHangPrice.text =  [[NetWorkManager sharedInstance] getFormatValue:price-self.merpObj.dSetp merplist_obj:self.merpObj];
            
        }
    }
}

- (IBAction)hangAmountAction:(UIButton *)sender {
    NSInteger price = [self.lblHangAmount.text integerValue];
    if (sender == self.btnHangAddAmount) {
        self.lblHangAmount.text = [@(price+1) stringValue];
    }else{
        if(price >0){
            self.lblHangAmount.text = [@(price-1) stringValue];
            
        }
    }

}
- (IBAction)stopPointAction:(id)sender {
    double price = [self.lblStopPoint.text floatValue];
    if (sender == self.btnStopPointAdd) {
        self.lblStopPoint.text =  [[NetWorkManager sharedInstance] getFormatValue:price+self.merpObj.dSetp merplist_obj:self.merpObj];
    }else{
        if(price >0.0000 && (price-self.merpObj.dSetp)>0.00){
            self.lblStopPoint.text =  [[NetWorkManager sharedInstance] getFormatValue:price-self.merpObj.dSetp merplist_obj:self.merpObj];
            
        }
    }
    if(!bHangeSell){
        self.lblHangPrice.text = [[NetWorkManager sharedInstance] getFormatValue:self.merpObj.priceObJ.fSellPrice1 + [self.lblStopPoint.text floatValue] merplist_obj:self.merpObj];
    }else{
        self.lblHangPrice.text = [[NetWorkManager sharedInstance] getFormatValue:self.merpObj.priceObJ.fBuyPrice1 - [self.lblStopPoint.text floatValue] merplist_obj:self.merpObj];
    }

}

- (IBAction)switchPriceAction:(id)sender {
    if (self.switchPrice.on) {
        self.vStopPoint.hidden = NO;
        self.vStopTypeViw.hidden = NO;
        
    }else{
        self.vStopPoint.hidden = YES;
        self.vStopTypeViw.hidden = YES;
    }
}
-(void)TradeConfirmViewConfirm:(BOOL)confirm{
    if (confirm) {
        [self.popBox hide];
        self.progressView = [TToast showProcess:@"服务器正在处理请求" inView:self.view];
        [[CGT6ClientSocket sharedInstance] sendAddOrderMarket:self.tradeData];

    }else{
        [self.popBox hide];
    }
}


@end
