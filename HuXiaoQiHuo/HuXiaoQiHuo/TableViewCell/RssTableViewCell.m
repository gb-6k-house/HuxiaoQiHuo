//
//  RssTableViewCell.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/13.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "RssTableViewCell.h"

@implementation RssTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshUI:(NSDictionary *)dicData{
    _rssTime.text = dicData[@"rssTime"];
    _userName.text = dicData[@"userName"];
    _userLevel.text = dicData[@"userLevel"];
    _accountMoney.text = dicData[@"accountMoney"];
    _todayMoney.text = dicData[@"todayMoney"];
    _winRate.text = dicData[@"winRate"];
    _type.text = dicData[@"type"];
    _typeName.text = dicData[@"typeName"];
    _typeDate.text = dicData[@"typeDate"];
    _dealPrice.text = dicData[@"dealPrice"];
    _dealNumber.text = dicData[@"dealNumber"];
    _dealMoney.text = dicData[@"dealMoney"];
    //TODO: 还有头像没设置，消息状态没设置
    NSInteger state = [[dicData valueForKey:@"messageState"] intValue];
    if (state != 0) {
        [_messageState setImage:[UIImage imageNamed:@"readIcon"]];
    }else{
        [_messageState setImage:[UIImage imageNamed:@"unReadIcon"]];
    }
}

@end
