//
//  MarketMainItemCell.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/13.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "MarketMainItemCell.h"
#import "MerpList_Obj.h"
@implementation MarketMainItemCell
-(void)refreshUI:(id)data{
    MerpList_Obj *obj = data;
    self.lblTitle.text = obj.strMpname;
    self.lblDate.text = obj.strMpcode;
    PriceData_Obj *objPriceData = obj.priceObJ;
    if (objPriceData) {
        float RiseFallPrice = ((objPriceData.fLatestPrice-objPriceData.fClosePrice)/objPriceData.fClosePrice)*100;
        
        //如果涨跌幅没有跳动就不赋值，用先前的
        if (fabs( RiseFallPrice - 0) < 0.00000001) {
            //return cell;
        }
        NSMutableString *mString = [NSMutableString string];
        self.lblPrice.text =  [NSString stringWithFormat:[NSString stringWithFormat:@"%%.%ldf", (long)obj.nPrecision], objPriceData.fLatestPrice];

        if (RiseFallPrice>0){
            //            labelRiseFallPrice.textColor = [[PublicFun Instance]getRedColor];
            [mString appendString:[NSString stringWithFormat:@"+%.2f％",RiseFallPrice]];
            self.lblChg.text =  mString;

            self.lblChg.backgroundColor = [UIColor YColorRed];
            self.lblPrice.textColor = [UIColor YColorRed];
            
        }else if (RiseFallPrice<0)
        {
            [mString appendString:[NSString stringWithFormat:@"%.2f％",RiseFallPrice]];
            self.lblChg.text =  mString;
            
            self.lblChg.backgroundColor = [UIColor YColorGreen];
            self.lblPrice.textColor = [UIColor YColorGreen];
        }else{
            [mString appendString:[NSString stringWithFormat:@"%.2f％",RiseFallPrice]];
            self.lblChg.text =  mString;
            
            self.lblChg.backgroundColor = [UIColor YColorBlack];
            self.lblPrice.textColor = [UIColor YColorBlack];
        }

    }else{
        self.lblPrice.text = @"--";
        self.lblChg.text = @"--";
        self.lblChg.backgroundColor = [UIColor YColorGray];
        self.lblPrice.textColor = [UIColor YColorGray];

    }
}

@end
