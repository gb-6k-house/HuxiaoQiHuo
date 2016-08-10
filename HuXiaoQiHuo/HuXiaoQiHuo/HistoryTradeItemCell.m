//
//  HistoryTradeItemCell.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/17.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "HistoryTradeItemCell.h"

@implementation HistoryTradeItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshUI:(NSDictionary *)dic{
    NSArray *arrayInfo = dic[@"cell"];
    //cell =     (
//    48771,
//    20048,
//    GCM6,
//    "2016/5/12 17:15:22",
//    1,
//    "1.00",
//    "1270.5000000",
//    "1273.2000000",
//    "193.79845",
//    1,
//    "2093.02326",
//    "3697131.78000",
//    1,
//    1,
//    0,
//    "0.0000000",
//    "2093.0232558",
//    "1273.2000000",
//    "57q957qm5pyf6YeRIDIwMTYtMDY="
////    );
//    cell里面按属性oheid编号 oheoid持仓号 ohemcode商品码 ohedealtime成交时间 ohetype类型
//    ohenumber成交手数 oheprice成交价 oheoddnum剩余手数 ohedealcost手续费 oheadverse建平仓类型 oheProfit获利 oheNBalance本次结余 ModeType模式（一般不显示） MakerType成交类型 UDType(一般不显示) oheLossP止损 oheProfitP止盈 oheBTPrice(暂时无用) 商品名称(已用utf8 base64位数字编码 防止乱码)  的顺序返回的
//    买卖：0卖，1买；建平仓：0平，1建；MakerType 0挂单  1即时成交 2止损止盈 其他 爆仓
    
//    NSInteger oheid = [arrayInfo[0] integerValue];
//    NSInteger oheoid = [arrayInfo[1] integerValue];
    NSString* ohemcode = arrayInfo[2];
    NSString* ohedealtime = arrayInfo[3];
//    NSInteger ohetype = [arrayInfo[4] integerValue];
    double ohenumber = [arrayInfo[5] doubleValue];
//    double oheprice = [arrayInfo[6] doubleValue];
//    double oheoddnum = [arrayInfo[7] doubleValue];
//    double ohedealcost = [arrayInfo[8] doubleValue];
    NSInteger oheadverse = [arrayInfo[9] integerValue];
    double oheProfit = [arrayInfo[10] doubleValue];
//    double oheNBalance = [arrayInfo[11] doubleValue];
//    NSInteger modeType = [arrayInfo[12] integerValue];
    NSInteger makerType = [arrayInfo[13] integerValue];
    NSString* strMakerType = @"";
    if (makerType == 0) {
        strMakerType = @"挂单";
    }else if (makerType == 1){
        strMakerType = @"即时成交";
    }else if (makerType == 2){
        strMakerType = @"止损止盈";
    }else{
        strMakerType = @"爆仓";
    }
//    NSInteger uDType = [arrayInfo[14] integerValue];
//    double oheLossP = [arrayInfo[15] doubleValue];
//    double oheProfitP = [arrayInfo[16] doubleValue];
//    double oheBTPrice = [arrayInfo[17] doubleValue];
    NSString* name = [GTMBase64 decodeBase64String:arrayInfo[18]];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy/MM/dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:ohedealtime];
    NSDateFormatter *dateFormatterChange = [[NSDateFormatter alloc] init];
    [dateFormatterChange setDateFormat:@"yyyy-MM"];
    
    NSString *title = [NSString stringWithFormat:@"%@", name];
    self.lblTitle.text = title;
    self.lblSubTitle.text = ohemcode;
    if (oheadverse == 0) {
        self.lblType.text = @"卖";
        [self.lblType setBackgroundColor:[UIColor greenColor]];
    }else{
        self.lblType.text = @"买";
        [self.lblType setBackgroundColor:[UIColor redColor]];
    }
    //TODO: 天数还没字段
    self.lblDays.text = [NSString stringWithFormat:@"%ld", (long)[ToolCore calcDaysFromBegin:date end:[NSDate date]]];
    self.lblPofit.text = [NSString stringWithFormat:@"%.2f", oheProfit];
    self.lblAmount.text = [NSString stringWithFormat:@"%ld", (long)ohenumber];
    if (oheProfit > 0.01) {
        [self.lblPofit setTextColor:[UIColor redColor]];
    }else if(oheProfit < -0.01){
        [self.lblPofit setTextColor:[UIColor greenColor]];
    }else{
        [self.lblPofit setTextColor:[UIColor grayColor]];
    }
}

@end
