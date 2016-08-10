//
//  PositionItemCell.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/16.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "PositionItemCell.h"

@implementation PositionItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)refreshUI:(NSDictionary*)dic{
//    cell =             (
//                        18309,
//                        633,
//                        GCM6,
//                        0,
//                        "1279.1000000",
//                        "0.00",
//                        "0.0000000",
//                        "697.6744186",
//                        "2016/5/5 22:39:52",
//                        0,
//                        "0.0000000",
//                        liuyeye01HX,
//                        "0.000000000",
//                        1,
//                        100,
//                        0
//                        );
//}
//);
//msg = "2016-05-25 17:02:06";
//    0成功 1获取数据失败 msg无作用 cell按顺序：TPid 持仓号 TPSuid 用户编号 TPmcode商品码 TPtype买卖类型 TPprice持仓价 TPnumber 持仓手数 TPLossP止损 TPProfitP止盈 TPTime时间 TPMakerType持仓类型 TPAccrual 利息 UserName用户名 返回
    //    买卖：0卖，1买；建平仓：0平，1建；
    
    NSArray *arrData = dic[@"cell"];
//    NSInteger TPid = [arrData[0] integerValue];
//    NSInteger TPSuid = [arrData[1] integerValue];
    NSString* TPmcode = arrData[2];
    NSInteger TPtype = [arrData[3] integerValue];
    double TPprice = [arrData[4] doubleValue];
    double TPnumber = [arrData[5] doubleValue];
    double TPLossP = [arrData[6] doubleValue];
//    double TPProfitP = [arrData[7] doubleValue];
//    NSString *tpTime = arrData[8];
//    NSInteger TPMakerType = [arrData[9] integerValue];
//    double TPAccrual = [arrData[10] doubleValue];
//    NSString* UserName = arrData[11];
    
    MerpList_Obj *mpObj = [[CTradeClientSocket sharedInstance] merpListObjWithMpcode:TPmcode];
    self.lblTitle.text = mpObj.strMpname;
    self.lblSubTitle.text = TPmcode;
    if (TPtype == 0) {
        self.lblPositionType.text = @"卖";
        [self.lblPositionType setBackgroundColor:[UIColor greenColor]];
    }else{
        self.lblPositionType.text = @"买";
        [self.lblPositionType setBackgroundColor:[UIColor redColor]];
    }
    self.lblAmount.text = [NSString stringWithFormat:@"%ld", (long)TPnumber];
    if (mpObj.priceObJ != nil) {
        PriceData_Obj* priceObJ = mpObj.priceObJ;
        self.lblCurPrice.text = [NSString stringWithFormat:@"%.2f", priceObJ.fLatestPrice];
        
        double priceDiff = 0.0;
        if (!TPtype) {
            //买  :当前价-订单价
            priceDiff = priceObJ.fLatestPrice - TPprice;
        }else{
            //卖  :订单价-当前价
            priceDiff = TPprice - priceObJ.fLatestPrice;
        }
        double accountPofit = priceDiff*TPnumber*mpObj.nUnit;//TODO: 汇率没有
        
        self.lblProfitLoss.text = [NSString stringWithFormat:@"%.2f", accountPofit];
        
    }else{
        self.lblCurPrice.text = [NSString stringWithFormat:@"%.2f", TPprice];
    }
    self.lblAvgPrice.text = @"无";
    self.lblProfitLoss.text = @"无";
    self.stopPrice.text = [NSString stringWithFormat:@"%.2f", TPLossP];
}


-(void)refreshUIByTrade:(NSDictionary*)dic{
//    NSInteger uid = [dic[@"uid"] integerValue];			//用户ID
//    NSInteger nid = [dic[@"nid"] integerValue];			//持仓ID
    NSString* mmcode = dic[@"mmcode"];		//商品编码
    NSString* mpname = dic[@"mpname"];		//商品名称
//    NSString* time = dic[@"time"];		//建仓时间
    double price = [dic[@"price"] doubleValue];			//订单价格
    BOOL isbuy = [dic[@"isbuy"] boolValue];		//1:买,0:卖
    NSInteger number = [dic[@"number"] integerValue];		//数量
    NSInteger mpamount = [dic[@"mpamount"] integerValue];	//每手的量
    double mpxchange = [dic[@"mpxchange"] doubleValue];	//汇率
//    NSString* mpcurrency = dic[@"mpcurrency"];		//币种
//    double margin = [dic[@"margin"] doubleValue];		//占用的保证金
    
    self.lblTitle.text = mpname;
    self.lblSubTitle.text = mmcode;
    if (isbuy) {
        self.lblPositionType.text = @"买";
        [self.lblPositionType setBackgroundColor:[UIColor redColor]];
    }else{
        self.lblPositionType.text = @"卖";
        [self.lblPositionType setBackgroundColor:[UIColor greenColor]];
    }
    self.lblAmount.text = [NSString stringWithFormat:@"%ld", (long)number];
    self.lblAvgPrice.text = @"无";
    MerpList_Obj *mpObj = [[CTradeClientSocket sharedInstance] merpListObjWithMpcode:mmcode];
    
    if (mpObj.priceObJ != nil) {
        PriceData_Obj* priceObJ = mpObj.priceObJ;
        self.lblCurPrice.text = [NSString stringWithFormat:@"%.2f", priceObJ.fLatestPrice];
        
        double priceDiff = 0.0;
        if (isbuy) {
            //买  :当前价-订单价
            priceDiff = priceObJ.fLatestPrice - price;
        }else{
            //卖  :订单价-当前价
            priceDiff = price - priceObJ.fLatestPrice;
        }
        double accountPofit = priceDiff*number*mpamount*mpxchange;
        
        self.lblProfitLoss.text = [NSString stringWithFormat:@"%.2f", accountPofit];
        
    }else{
        self.lblCurPrice.text = [NSString stringWithFormat:@"%.2f", price];
    }
    
    self.stopPrice.text = [NSString stringWithFormat:@"无"];

    
}

@end
