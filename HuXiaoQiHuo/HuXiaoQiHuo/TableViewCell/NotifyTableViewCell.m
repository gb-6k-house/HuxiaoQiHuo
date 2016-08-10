//
//  NotifyTableViewCell.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/13.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "NotifyTableViewCell.h"

@implementation NotifyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)refreshUI:(NSDictionary *)dicData{
    _actionInfo = dicData[@"actionInfo"];
    _content = dicData[@"content"];
    _time = dicData[@"time"];
    NSInteger state = [[dicData valueForKey:@"messageState"] intValue];
    if (state != 0) {
        [_messageState setImage:[UIImage imageNamed:@"readIcon"]];
    }else{
        [_messageState setImage:[UIImage imageNamed:@"unReadIcon"]];
    }
}

@end
