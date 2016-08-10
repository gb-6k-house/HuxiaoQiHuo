//
//  PositionItemCell.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/16.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PositionItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPositionType;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblAvgPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblCurPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblProfitLoss;
@property (weak, nonatomic) IBOutlet UILabel *stopPrice;

-(void)refreshUI:(NSDictionary*)dic;
-(void)refreshUIByTrade:(NSDictionary*)dic;

@end
