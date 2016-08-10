//
//  FivePriceView.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/18.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "FivePriceView.h"

@implementation FivePriceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)instanceFromNib{
    FivePriceView *view = [[[NSBundle mainBundle] loadNibNamed:@"FivePriceView" owner:nil options:nil] objectAtIndex:0];
    return view;

}
-(void)setTextColor:(UIColor*)color{
    self.lblBuy1Price.textColor = color;
    self.lblBuy2Price.textColor = color;
    self.lblBuy3Price.textColor = color;
    self.lblBuy4Price.textColor = color;
    self.lblBuy5Price.textColor = color;

    self.lblBuy1Hands.textColor = color;
    self.lblBuy2Hands.textColor = color;
    self.lblBuy3Hands.textColor = color;
    self.lblBuy4Hands.textColor = color;
    self.lblBuy5Hands.textColor = color;
    
    self.lblSell1Price.textColor = color;
    self.lblSell2Price.textColor = color;
    self.lblSell3Price.textColor = color;
    self.lblSell4Price.textColor = color;
    self.lblSell5Price.textColor = color;

    self.lblSell1Hands.textColor = color;
    self.lblSell2Hands.textColor = color;
    self.lblSell3Hands.textColor = color;
    self.lblSell4Hands.textColor = color;
    self.lblSell5Hands.textColor = color;

}

-(void)updateUI:(MerpList_Obj *)merpObj{
    if (merpObj.priceObJ) {
        self.lblBuy1Price.text = [[NetWorkManager sharedInstance] getFormatValue:merpObj.priceObJ.fBuyPrice1 merplist_obj:merpObj];
        self.lblBuy1Hands.text = [NSString stringWithFormat:@"%.0f",merpObj.priceObJ.fBuyVolume1];
        self.lblBuy2Price.text = [[NetWorkManager sharedInstance] getFormatValue:merpObj.priceObJ.fBuyPrice2 merplist_obj:merpObj];
        self.lblBuy2Hands.text = [NSString stringWithFormat:@"%.0f",merpObj.priceObJ.fBuyVolume2];
        self.lblBuy3Price.text = [[NetWorkManager sharedInstance] getFormatValue:merpObj.priceObJ.fBuyPrice3 merplist_obj:merpObj];
        self.lblBuy3Hands.text = [NSString stringWithFormat:@"%.0f",merpObj.priceObJ.fBuyVolume3];
        self.lblBuy4Price.text = [[NetWorkManager sharedInstance] getFormatValue:merpObj.priceObJ.fBuyPrice4 merplist_obj:merpObj];
        self.lblBuy4Hands.text = [NSString stringWithFormat:@"%.0f",merpObj.priceObJ.fBuyVolume4];
        self.lblBuy5Price.text = [[NetWorkManager sharedInstance] getFormatValue:merpObj.priceObJ.fBuyPrice5 merplist_obj:merpObj];
        self.lblBuy5Hands.text = [NSString stringWithFormat:@"%.0f",merpObj.priceObJ.fBuyVolume5];
        
        self.lblSell1Price.text = [[NetWorkManager sharedInstance] getFormatValue:merpObj.priceObJ.fSellPrice1 merplist_obj:merpObj];
        self.lblSell1Hands.text = [NSString stringWithFormat:@"%.0f",merpObj.priceObJ.fSellVolume1];
        self.lblSell2Price.text = [[NetWorkManager sharedInstance] getFormatValue:merpObj.priceObJ.fSellPrice2 merplist_obj:merpObj];
        self.lblSell2Hands.text = [NSString stringWithFormat:@"%.0f",merpObj.priceObJ.fSellVolume2];
        self.lblSell3Price.text = [[NetWorkManager sharedInstance] getFormatValue:merpObj.priceObJ.fSellPrice3 merplist_obj:merpObj];
        self.lblSell3Hands.text = [NSString stringWithFormat:@"%.0f",merpObj.priceObJ.fSellVolume3];
        self.lblSell4Price.text = [[NetWorkManager sharedInstance] getFormatValue:merpObj.priceObJ.fSellPrice4 merplist_obj:merpObj];
        self.lblSell4Hands.text = [NSString stringWithFormat:@"%.0f",merpObj.priceObJ.fSellVolume4];
        self.lblSell5Price.text = [[NetWorkManager sharedInstance] getFormatValue:merpObj.priceObJ.fSellPrice5 merplist_obj:merpObj];
        self.lblSell5Hands.text = [NSString stringWithFormat:@"%.0f",merpObj.priceObJ.fSellVolume5];
        
        [self setTextColor:merpObj.priceObJ.fChgPrice > 0?[UIColor YColorRed]:merpObj.priceObJ.fChgPrice <0?[UIColor YColorGreen]:[UIColor YColorBlack]];
    }else{
        self.lblBuy1Price.text = @"--";
        self.lblBuy1Hands.text = @"--";
        self.lblBuy2Price.text = @"--";
        self.lblBuy2Hands.text = @"--";
        self.lblBuy3Price.text = @"--";
        self.lblBuy3Hands.text = @"--";
        self.lblBuy4Price.text = @"--";
        self.lblBuy4Hands.text = @"--";
        self.lblBuy5Price.text = @"--";
        self.lblBuy5Hands.text = @"--";
        
        self.lblSell1Price.text = @"--";
        self.lblSell1Hands.text = @"--";
        self.lblSell2Price.text = @"--";
        self.lblSell2Hands.text = @"--";
        self.lblSell3Price.text = @"--";
        self.lblSell3Hands.text = @"--";
        self.lblSell4Price.text = @"--";
        self.lblSell4Hands.text = @"--";
        self.lblSell5Price.text = @"--";
        self.lblSell5Hands.text = @"--";
        [self setTextColor:[UIColor YColorBlack]];
    }

}

@end
