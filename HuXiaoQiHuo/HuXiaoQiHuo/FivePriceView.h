//
//  FivePriceView.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/18.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerpList_Obj.h"
@interface FivePriceView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblBuy1Price;
@property (weak, nonatomic) IBOutlet UILabel *lblBuy1Hands;
@property (weak, nonatomic) IBOutlet UILabel *lblBuy2Price;
@property (weak, nonatomic) IBOutlet UILabel *lblBuy2Hands;
@property (weak, nonatomic) IBOutlet UILabel *lblBuy3Price;
@property (weak, nonatomic) IBOutlet UILabel *lblBuy3Hands;
@property (weak, nonatomic) IBOutlet UILabel *lblBuy4Price;
@property (weak, nonatomic) IBOutlet UILabel *lblBuy4Hands;
@property (weak, nonatomic) IBOutlet UILabel *lblBuy5Price;
@property (weak, nonatomic) IBOutlet UILabel *lblBuy5Hands;
@property (weak, nonatomic) IBOutlet UILabel *lblSell1Price;
@property (weak, nonatomic) IBOutlet UILabel *lblSell1Hands;
@property (weak, nonatomic) IBOutlet UILabel *lblSell2Price;
@property (weak, nonatomic) IBOutlet UILabel *lblSell2Hands;
@property (weak, nonatomic) IBOutlet UILabel *lblSell3Price;
@property (weak, nonatomic) IBOutlet UILabel *lblSell3Hands;
@property (weak, nonatomic) IBOutlet UILabel *lblSell4Price;
@property (weak, nonatomic) IBOutlet UILabel *lblSell4Hands;
@property (weak, nonatomic) IBOutlet UILabel *lblSell5Price;
@property (weak, nonatomic) IBOutlet UILabel *lblSell5Hands;
+(instancetype)instanceFromNib;
-(void)updateUI:(MerpList_Obj *)merpObj;
-(void)setTextColor:(UIColor*)color;
@end
