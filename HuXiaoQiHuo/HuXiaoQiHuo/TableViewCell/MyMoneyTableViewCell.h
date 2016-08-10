//
//  MyMoneyTableViewCell.h
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/15.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMoneyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayInWeek;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *info;

-(void)refreshUI:(NSDictionary*)dic;

@end
