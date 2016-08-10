//
//  MyMoneyTableViewCell.m
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/15.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "MyMoneyTableViewCell.h"

@implementation MyMoneyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)refreshUI:(NSDictionary*)dic{

    self.dayInWeek.text = dic[@"dayInWeek"];
    self.date.text = dic[@"date"];
    self.money.text = dic[@"money"];
    self.info.text = dic[@"info"];
    
}

@end
