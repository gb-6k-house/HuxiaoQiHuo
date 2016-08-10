//
//  HistoryTradeItemCell.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/17.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTradeItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblDays;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblPofit;

-(void)refreshUI:(NSDictionary*)dic;

@end
