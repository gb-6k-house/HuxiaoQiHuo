//
//  HangTradeItemCell.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/23.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HangTradeItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTradeType;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblStockTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblStockSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPositionID;
@property (weak, nonatomic) IBOutlet UILabel *lblPositionAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblPositionType;
@property (weak, nonatomic) IBOutlet UILabel *lblExecutePrice;
@property (weak, nonatomic) IBOutlet UILabel *lblStopPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblRealPrice;

-(void)refreshUI:(NSDictionary*)dic;

@end
